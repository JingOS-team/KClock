/*
 * Copyright 2020   Han Young <hanyoung@protonmail.com>
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
#include "alarmplayer.h"
#include "kclocksettings.h"
AlarmPlayer &AlarmPlayer::instance()
{
    static AlarmPlayer singleton;
    return singleton;
}
AlarmPlayer::AlarmPlayer(QObject *parent)
    : QObject(parent)
    , m_player(new QMediaPlayer(this, QMediaPlayer::LowLatency))
{
    connect(m_player, &QMediaPlayer::stateChanged, this, &AlarmPlayer::loopAudio);
}

void AlarmPlayer::loopAudio(QMediaPlayer::State state)
{
    KClockSettings settings;
    
    if (!userStop && state == QMediaPlayer::StoppedState && static_cast<int>(QDateTime::currentSecsSinceEpoch() - startPlayingTime) < settings.alarmSilenceAfter()) {
        m_player->play();
    }
}

void AlarmPlayer::play()
{
    if (m_player->state() == QMediaPlayer::PlayingState)
        return;

    // if user set a invalid audio path or doesn't even specified a path, resort to default
    if (!m_player->isAudioAvailable()) {
        m_player->setMedia(QUrl::fromLocalFile(QStandardPaths::locate(QStandardPaths::GenericDataLocation, "sounds/freedesktop/stereo/alarm-clock-elapsed.oga")));
    }
    startPlayingTime = QDateTime::currentSecsSinceEpoch();
    userStop = false;
    m_player->play();
}

void AlarmPlayer::stop()
{
    userStop = true;
    m_player->stop();
}

void AlarmPlayer::setVolume(int volume)
{
    m_player->setVolume(volume);
}

void AlarmPlayer::setSource(QUrl path)
{
    m_player->setMedia(path);
}
