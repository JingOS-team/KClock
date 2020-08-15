/*
 * Copyright 2020 Devin Lin <espidev@gmail.com>
 *                Han Young <hanyoung@protonmail.com>
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
#include <QDBusInterface>
#include <QDBusReply>
#include <QLocale>
#include <QQmlEngine>
#include <QThread>
#include <klocalizedstring.h>

#include "alarmmodel.h"
#include "alarms.h"
#include "alarmwaitworker.h"

#define SCRIPTANDPROPERTY QDBusConnection::ExportScriptableContents | QDBusConnection::ExportAllProperties
AlarmModel::AlarmModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_interface(new QDBusInterface("org.kde.Solid.PowerManagement", "/org/kde/Solid/PowerManagement", "org.kde.Solid.PowerManagement"))
    , m_notifierItem(new KStatusNotifierItem(this))
{
    // DBus
    QDBusConnection::sessionBus().registerObject("/alarms", this, QDBusConnection::ExportScriptableContents);

    beginResetModel();
    // add alarms from config
    auto config = KSharedConfig::openConfig();
    KConfigGroup group = config->group(ALARM_CFG_GROUP);
    for (QString key : group.keyList()) {
        QString json = group.readEntry(key, "");
        if (!json.isEmpty()) {
            Alarm *alarm = new Alarm(json, this);

            alarmsList.append(alarm);
            QDBusConnection::sessionBus().registerObject("/alarms/" + alarm->uuid().toString(QUuid::Id128), alarm, SCRIPTANDPROPERTY);
        }
    }
    endResetModel();

    // update notify icon in systemtray
    connect(this, &AlarmModel::nextAlarm, this, &AlarmModel::updateNotifierItem);
    m_notifierItem->setIconByName(QStringLiteral("clock"));
    m_notifierItem->setStandardActionsEnabled(false);
    m_notifierItem->setAssociatedWidget(nullptr);

    // if PowerDevil is present rely on PowerDevil to track time, otherwise we do it ourself
    if (m_interface->isValid()) {
        m_interface->call("wakeup"); // test Plasma 19.20 PowerDevil schedule wakeup feature

        if (!m_interface->lastError().isValid()) // have this feature
        {
            m_isPowerDevil = true;
            QDBusConnection::sessionBus().registerObject("/alarms/", "org.kde.PowerManagement", this, QDBusConnection::ExportNonScriptableSlots);
        } else {
            m_isPowerDevil = false;
        }
    } else {
        m_isPowerDevil = false;
    }

    if (!m_isPowerDevil) {
        m_timerThread = new QThread(this);
        m_worker = new AlarmWaitWorker();
        m_worker->moveToThread(m_timerThread);
        connect(m_worker, &AlarmWaitWorker::finished, [this] {
            qDebug() << "ring";
            if (this->alarmToBeRung)
                alarmToBeRung->ring();
        });
        m_timerThread->start();
    }

    scheduleAlarm();
}

quint64 AlarmModel::getNextAlarm()
{
    return nextAlarmTime;
}

void AlarmModel::scheduleAlarm()
{
    if (alarmsList.count() == 0) // no alarm, return
        return;
    qint64 minTime = std::numeric_limits<qint64>::max();
    for (auto alarm : alarmsList) {
        if (alarm->nextRingTime() > 0 && alarm->nextRingTime() < minTime) {
            alarmToBeRung = alarm;
            minTime = alarm->nextRingTime();
        }
    }
    if (minTime != std::numeric_limits<qint64>::max()) {
        qDebug() << "scheduled" << QDateTime::fromSecsSinceEpoch(minTime).toLocalTime().toString();
        nextAlarmTime = minTime;
        if (m_isPowerDevil) {
            // if we scheduled wakeup before, cancel it first
            if (m_token > 0)
                m_interface->call("clearWakeup", m_token);
            // schedule wakeup and store token
            QDBusReply<int> reply = m_interface->call("scheduleWakeup", "org.kde.kclock", "/alarms", minTime);
            m_token = reply.value();
        } else {
            m_worker->setNewTime(minTime);
        }
        emit nextAlarm(minTime);
    } else {
        // this don't explicitly cancel the alarm currently waiting in m_worker if disabled by user
        // because alarm->ring() will return immediatly if disabled
        qDebug() << "no alarm to ring";
        nextAlarmTime = 0;
        alarmToBeRung = nullptr;
        if (m_isPowerDevil)
            m_interface->call("clearWakeup", m_token);
        emit nextAlarm(0);
    }
}

void AlarmModel::wakeupCallback(int token)
{
    if (!(m_token == token))
        return; // something muse be wrong here, return and do nothing

    if (alarmToBeRung) {
        // neutralise token
        m_token = -1;

        qDebug() << "ring";
        alarmToBeRung->ring();
    }
}

/* ~ Alarm row data ~ */

QHash<int, QByteArray> AlarmModel::roleNames() const
{
    return {{HoursRole, "hours"}, {MinutesRole, "minutes"}, {NameRole, "name"}, {EnabledRole, "enabled"}, {DaysOfWeekRole, "daysOfWeek"}, {RingtonePathRole, "ringtonePath"}, {AlarmRole, "alarm"}};
}

QVariant AlarmModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= alarmsList.count()) {
        return QVariant();
    }

    auto *alarm = alarmsList[index.row()];
    if (!alarm)
        return false;
    if (role == EnabledRole)
        return alarm->enabled();
    else if (role == HoursRole)
        return alarm->hours();
    else if (role == MinutesRole)
        return alarm->minutes();
    else if (role == NameRole)
        return alarm->name();
    else if (role == DaysOfWeekRole)
        return alarm->daysOfWeek();
    else if (role == AlarmRole)
        return QVariant::fromValue(alarm);
    else
        return QVariant();
}

bool AlarmModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || alarmsList.length() <= index.row())
        return false;
    // to switch or not to switch?
    auto *alarm = alarmsList[index.row()];
    if (!alarm)
        return false;
    if (role == EnabledRole)
        alarm->setEnabled(value.toBool());
    else if (role == HoursRole)
        alarm->setHours(value.toInt());
    else if (role == MinutesRole)
        alarm->setMinutes(value.toInt());
    else if (role == NameRole)
        alarm->setName(value.toString());
    else if (role == DaysOfWeekRole)
        alarm->setDaysOfWeek(value.toInt());
    else if (role == RingtonePathRole)
        alarm->setRingtone(value.toString());
    else
        return false;

    emit dataChanged(index, index);
    return true;
}

int AlarmModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return alarmsList.size();
}

Qt::ItemFlags AlarmModel::flags(const QModelIndex &index) const
{
    Q_UNUSED(index);
    return Qt::ItemIsEditable;
}

void AlarmModel::remove(QString uuid)
{
    int index = 0;
    bool found = false;
    for (auto id : alarmsList) {
        if (id->uuid().toString() == uuid) {
            found = true;
            break;
        }
        index++;
    }
    if (!found) // do nothing if not found
        return;
    emit beginRemoveRows(QModelIndex(), index, index);

    // write to config
    auto config = KSharedConfig::openConfig();
    KConfigGroup group = config->group(ALARM_CFG_GROUP);
    group.deleteEntry(alarmsList.at(index)->uuid().toString());
    alarmsList[index]->deleteLater(); // delete object
    alarmsList.removeAt(index);

    config->sync();

    emit endRemoveRows();
}

void AlarmModel::remove(int index)
{
    if (index < 0 || index >= this->rowCount({}))
        return;

    emit beginRemoveRows(QModelIndex(), index, index);

    // write to config
    auto config = KSharedConfig::openConfig();
    KConfigGroup group = config->group(ALARM_CFG_GROUP);
    group.deleteEntry(alarmsList.at(index)->uuid().toString());
    alarmsList[index]->deleteLater(); // delete object
    alarmsList.removeAt(index);

    config->sync();

    emit endRemoveRows();
}

void AlarmModel::updateUi()
{
    emit dataChanged(createIndex(0, 0), createIndex(alarmsList.count() - 1, 0));
}

void AlarmModel::addAlarm(int hours, int minutes, int daysOfWeek, QString name, QString ringtonePath)
{
    emit beginInsertRows(QModelIndex(), alarmsList.count(), alarmsList.count());
    Alarm *alarm = new Alarm(this, name, minutes, hours, daysOfWeek);
    alarm->setRingtone(ringtonePath);
    alarmsList.append(alarm);
    emit endInsertRows();
    scheduleAlarm();
    QDBusConnection::sessionBus().registerObject("/alarms/" + alarm->uuid().toString(QUuid::Id128), alarm, SCRIPTANDPROPERTY);
}

void AlarmModel::updateNotifierItem(quint64 time)
{
    if (time == 0) {
        m_notifierItem->setStatus(KStatusNotifierItem::Passive);
        m_notifierItem->setToolTip(QStringLiteral("clock"), QStringLiteral("KClock"), QStringLiteral());
    } else {
        m_notifierItem->setStatus(KStatusNotifierItem::Active);
        m_notifierItem->setToolTip(QStringLiteral("clock"), QStringLiteral("KClock"), xi18nc("@info", "Alarm: <shortcut>%1</shortcut>", QLocale::system().toString(QDateTime::fromSecsSinceEpoch(time).toLocalTime(), QLocale::ShortFormat)));
    }
}
