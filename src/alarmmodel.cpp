/*
 * Copyright 2020 Devin Lin <espidev@gmail.com>
 *                Han Young <hanyoung@protonmail.com>
 *                2021 DeXiang Mend <dexiang.meng@jingos.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#include <KConfigGroup>
#include <KSharedConfig>
#include <KStatusNotifierItem>
#include <QDBusConnection>
#include <QDBusReply>
#include <QLocale>
#include <QDebug>
#include <klocalizedstring.h>

#include <QDBusMessage>
#include <QThread>

#include "alarmmodel.h"
#include "alarmmodeladaptor.h"
#include "alarms.h"
#include "utilities.h"

#define SCRIPTANDPROPERTY QDBusConnection::ExportScriptableContents | QDBusConnection::ExportAllProperties
AlarmModel::AlarmModel(QObject *parent)
    : QObject(parent)
    , alarmIsRun(false)
    , m_notifierItem(new KStatusNotifierItem(this))
{
    // DBus
    new AlarmModelAdaptor(this);
    QDBusConnection::sessionBus().registerObject(QStringLiteral("/Alarms"), this);

    // load alarms from config
    auto config = KSharedConfig::openConfig();
    KConfigGroup group = config->group(ALARM_CFG_GROUP);
    for (QString key : group.keyList()) {
        QString json = group.readEntry(key, QStringLiteral());
        if (!json.isEmpty()) {
            Alarm *alarm = new Alarm(json, this);

            m_alarmsList.append(alarm);
        }
    }

    // update notify icon in systemtray
    connect(this, &AlarmModel::nextAlarm, this, &AlarmModel::updateNotifierItem);
    m_notifierItem->setIconByName(QStringLiteral("clock"));
    m_notifierItem->setStandardActionsEnabled(false);
    m_notifierItem->setAssociatedWidget(nullptr);

    // alarm wakeup behaviour
    connect(&Utilities::instance(), &Utilities::wakeup, this, &AlarmModel::wakeupCallback);
}

void AlarmModel::configureWakeups()
{
    // start alarm polling
    scheduleAlarm();
}

quint64 AlarmModel::getNextAlarm()
{
    return m_nextAlarmTime;
}

void AlarmModel::scheduleAlarm()
{
    // if there are no alarms, return
    if (m_alarmsList.count() == 0) {
        m_nextAlarmTime = 0;
        Q_EMIT nextAlarm(0);
        return;
    }

    alarmsToBeRung.clear();

    // get the next minimum time for a wakeup (next alarm ring), and add alarms that will needed to be woken up to the list
    qint64 minTime = std::numeric_limits<qint64>::max();
    for (auto *alarm : m_alarmsList) {
        if (alarm->nextRingTime() > 0) {
            if (alarm->nextRingTime() == minTime) {
                alarmsToBeRung.append(alarm);
            } else if (alarm->nextRingTime() < minTime) {
                alarmsToBeRung.clear();
                alarmsToBeRung.append(alarm);
                minTime = alarm->nextRingTime();
            }
        }
    }

    // if there is an alarm that needs to rung
    if (minTime != std::numeric_limits<qint64>::max()) {
        m_nextAlarmTime = minTime;

        // if we scheduled a wakeup before, cancel it first
        if (m_cookie > 0) {
            Utilities::instance().clearWakeup(m_cookie);
        }

        m_cookie = Utilities::instance().scheduleWakeup(minTime);
    } else {
        // this doesn't explicitly cancel the alarm currently waiting in m_worker if disabled by user
        // because alarm->ring() will return immediately if disabled

        m_nextAlarmTime = 0;
        Utilities::instance().clearWakeup(m_cookie);
        m_cookie = -1;
    }
    Q_EMIT nextAlarm(m_nextAlarmTime);
}

void AlarmModel::nextAlarmRun(QString uuid){

    alarmIsRun = false;

    for (int i = 0; i < this->alarmsWaitToBeRung.count(); i++) {
        if (this->alarmsWaitToBeRung.at(i)->uuid().toString() == uuid) {
            this->alarmsWaitToBeRung.removeAt(i);
            break;
        }
    }

    if (this->alarmsWaitToBeRung.count() > 0) {
        auto alarm = this->alarmsWaitToBeRung.at(0);
        if (alarm) {
            alarm->ring();
            alarmIsRun = true;
        }
    }
    this->scheduleAlarm();
}

void AlarmModel::wakeupCallback(int cookie)
{
    if (this->m_cookie != cookie) {
        return;
    }
    if (true == alarmIsRun) {
        for (auto alarm : this->alarmsToBeRung) {
            if(this->alarmsWaitToBeRung.count() == 0) {
                alarmsWaitToBeRung.append(alarm);
            } else {
                bool haveAlarm = false;
                for (auto alarmToRun : this->alarmsWaitToBeRung) {
                    if (alarmToRun->uuid().toString() == alarm->uuid().toString()) {
                        haveAlarm = true;
                    }
                }
                if (!haveAlarm) {
                    alarmsWaitToBeRung.append(alarm);
                }
            }
        }
    } else {
        for (auto alarm : this->alarmsToBeRung) {
            if (true == alarmIsRun) {
                alarmsWaitToBeRung.append(alarm);
            } else {
                alarm->ring();
                alarmIsRun = true;
            }
        }
    }
    QThread::msleep(500);
    this->scheduleAlarm();
}
void AlarmModel::removeAlarm(QString uuid)
{
    // find index of alarm
    for (int i = 0; i < alarmsWaitToBeRung.count(); i++) {
        if (alarmsWaitToBeRung.at(i)->uuid().toString() == uuid) {
            alarmsWaitToBeRung.removeAt(i);
            break;
        }
    }

    int index = -1;
    for (int i = 0; i < m_alarmsList.size(); i++) {
        if (m_alarmsList[i]->uuid().toString() == uuid) {
            index = i;
            break;
        }
    }
    if (index != -1) {
        this->removeAlarm(index);
    }
}

void AlarmModel::removeAlarm(int index)
{
    if (index < 0 || index >= this->m_alarmsList.size())
        return;

    Q_EMIT alarmRemoved(m_alarmsList.at(index)->uuid().toString());

    Alarm *alarmPointer = m_alarmsList.at(index);

    // remove from list of alarms to ring
    for (int i = 0; i < alarmsToBeRung.size(); i++) {
        if (alarmsToBeRung.at(i) == alarmPointer) {
            alarmsToBeRung.removeAt(i);
            i--;
        }
    }

    // write to config
    auto config = KSharedConfig::openConfig();
    KConfigGroup group = config->group(ALARM_CFG_GROUP);
    group.deleteEntry(m_alarmsList.at(index)->uuid().toString());
    m_alarmsList.at(index)->deleteLater(); // delete object
    m_alarmsList.removeAt(index);

    config->sync();
    scheduleAlarm();
}

void AlarmModel::addAlarm(int hours, int minutes, int daysOfWeek, QString name, QString ringtonePath, int snoozeMinutes)
{
    Alarm *alarm = new Alarm(this, name, minutes, hours, daysOfWeek, snoozeMinutes);
    // insert new alarm in order by time of day
    int i = 0;
    for (auto alarms : m_alarmsList) {
        if (alarms->hours() < hours) {
            i++;
            continue;
        } else if (alarms->hours() == hours) {
            if (alarms->minutes() < minutes) {
                i++;
                continue;
            } else {
                break;
            }
        } else {
            break;
        }
    }

    m_alarmsList.insert(i, alarm);
    alarm->save();
    scheduleAlarm();
    Q_EMIT alarmAdded(alarm->uuid().toString());
}

void AlarmModel::updateNotifierItem(quint64 time)
{
    if (time == 0) {
        notifySystemUI(false);
        m_notifierItem->setStatus(KStatusNotifierItem::Passive);
        m_notifierItem->setToolTip(QStringLiteral("clock"), QStringLiteral("Clock"), QStringLiteral());
    } else {
        notifySystemUI(true);
        auto dateTime = QDateTime::fromSecsSinceEpoch(time).toLocalTime();
        m_notifierItem->setStatus(KStatusNotifierItem::Active);
        m_notifierItem->setToolTip(QStringLiteral("clock"),
                                   QStringLiteral("KClock"),
                                   xi18nc("@info", "Alarm: <shortcut>%1</shortcut>",
                                   QLocale::system().standaloneDayName(dateTime.date().dayOfWeek()) + QLocale::system().toString(dateTime.time(), QLocale::ShortFormat)));
    }
}

void AlarmModel::notifySystemUI(bool visible) {
    QDBusMessage msg = QDBusMessage::createSignal(
        "/jingos/alarm/statusbaricon",
        "jingos.alarm.statusbaricon",
        "getVisible");
    msg << visible;
    QDBusConnection::sessionBus().send(msg);
}
