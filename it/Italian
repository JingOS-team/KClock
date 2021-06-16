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

Kirigami.ApplicationWindow {
    id: appwindow

    // property int officalWidth: 1920
    // property int officalHeight: 1200
    // property int deviceWidth: screen.width
    // property int deviceHeight: screen.height
    // property int fontSize: theme.defaultFont.pixelSize
    // property real officalScale: deviceWidth / officalWidth

    property int deviceWidth: 888
    property int deviceHeight: 648
    property alias toolbarHeight: bottombar.height
    property bool isDarkTheme: false

    width: deviceWidth
    height: deviceHeight

    // fastBlurMode: true
    // fastBlurColor: "#B2000000"

    onVisibleChanged: {
        appwindow.globalToolBarStyle = ApplicationHeaderStyle.None
    }

    pageStack.initialPage: alarmPage

    function switchToPage(page, depth) {
        while (pageStack.depth > depth)
            pageStack.pop()
        pageStack.push(page)
    }

    Component.onCompleted: {
        changeNav(!isWidescreen)
        console.log("device width: ", applicationWindow().screen.width)
        console.log("device height: ", applicationWindow().screen.height)
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

    function changeNav(toNarrow) {//        sidebarLoader.active = false;
    }

    // clock fonts
    FontLoader {
        id: clockFont
        source: "qrc:/assets/Gilroy-Thin.otf"
    }

    JTimerPage {
        id: timerListPage
        objectName: "timer"
        visible: false
    }

    JStopwatchPage {
        id: stopwatchPage
        objectName: "stopwatch"
        visible: false
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

    Kirigami.AboutPage {
        id: aboutPage
        visible: false
        aboutData: {
            "displayName": "Clock",
            "productName": "kirigami/clock",
            "componentName": "kclock",
            "shortDescription": "A mobile friendly clock app built with Kirigami.",
            "homepage": "",
            "bugAddress": "",
            "version": "0.2",
            "otherText": "",
            "copyrightStatement": "© 2020 Plasma Development Team",
            "desktopFileName": "org.kde.kclock",
            "authors": [{
                            "name": "Devin Lin",
                            "emailAddress": "espidev@gmail.com",
                            "webAddress": "https://espi.dev"
                        }, {
                            "name": "Han Young",
                            "emailAddress": "hanyoung@protonmail.com",
                            "webAddress": "https://han-y.gitlab.io"
                        }],
            "licenses": [{
                             "name": "GPL v2",
                             "text": "long, boring, license text",
                             "spdx": "GPL-2.0"
                         }]
        }
    }
}
