/*
 * Copyright 2020 Han Young <hanyoung@protonmail.com>
 *           2020 Devin Lin <espidev@gmail.com>
 *           2021 Rui Wang <wangrui@jingos.com>
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
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.15 as Kirigami
import org.kde.plasma.private.digitalclock 1.0 as DC

Kirigami.ApplicationWindow {
    id: appwindow

    property alias toolbarHeight: bottombar.height
    property bool isDarkTheme: false

    StackView {
        id: mainView

        anchors.fill: parent
        initialItem: alarmPage

        replaceEnter: Transition {
            OpacityAnimator {
                to: 1
                duration: 75
            }
        }

        replaceExit: Transition {
            OpacityAnimator {
                to: 0
                duration: 75
            }
        }
    }

    function switchToPage(page, depth) {
        mainView.replace(page)
    }

    Component.onCompleted: {
        changeNav(!isWidescreen)
    }

    function getPage(name) {
        switch (name) {
        case "Time":
            return timePage
        case "Timer":
            return timerListPage
        case "Stopwatch":
            return stopwatchPage
        case "Alarm":
            return alarmPage
        case "Settings":
            return settingsPage
        }
    }

    property bool isWidescreen: appwindow.width >= appwindow.height
    onIsWidescreenChanged: changeNav(!isWidescreen)

    // clock fonts
    FontLoader {
        id: clockFont
        source: "qrc:/assets/Gilroy-Thin.otf"
    }

    JTimerPage {
        id: timerListPage

        objectName: "timer"
        opacity: 0
    }

    JStopwatchPage {
        id: stopwatchPage

        objectName: "stopwatch"
        opacity: 0
    }
    JAlarmPage {
        id: alarmPage
        objectName: "alarm"
    }

    BottomToolbar {
        id: bottombar

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    DC.TimeZoneFilterProxy {
        id: timezoneProxy
    }
}
