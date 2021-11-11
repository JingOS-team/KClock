/*
 * Copyright 2019 Nick Reitemeyer <nick.reitemeyer@web.de>
 *           2020 Devin Lin <espidev@gmail.com>
 *           2021 Bob <pengbo·wu@jingos.com>
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
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0
import QtQuick.Controls 2.4
import kclock 1.0

Kirigami.Page {
    id: root

    signal alarmCheckedChange(bool checked)
    property bool clockShow: false
    property bool isDarkTheme: Kirigami.JTheme.colorScheme === "jingosDark"

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    globalToolBarStyle : Kirigami.ApplicationHeaderStyle.None

    function getRepeatFormat(dayOfWeek) {
        if (dayOfWeek == 0) {
            return i18n("Never")
        }
        let monday = 1 << 0, tuesday = 1 << 1, wednesday = 1 << 2, thursday = 1 << 3, friday = 1 << 4, saturday = 1 << 5, sunday = 1 << 6

        if (dayOfWeek == monday + tuesday + wednesday + thursday + friday + saturday + sunday)
            return i18n("Everyday")

        if (dayOfWeek == monday + tuesday + wednesday + thursday + friday)
            return i18n("Weekdays")

        let str = ""
        if (dayOfWeek & monday)
            str += i18n("Mon., ")
        if (dayOfWeek & tuesday)
            str += i18n("Tue., ")
        if (dayOfWeek & wednesday)
            str += i18n("Wed., ")
        if (dayOfWeek & thursday)
            str += i18n("Thu., ")
        if (dayOfWeek & friday)
            str += i18n("Fri., ")
        if (dayOfWeek & saturday)
            str += i18n("Sat., ")
        if (dayOfWeek & sunday)
            str += i18n("Sun., ")
        return str.substring(0, str.length - 2)
    }

    Item {
        id: watchLayout

        width: root.width / 2 - JDisplay.dp(18)
        height: root.height - toolbarHeight

        DigitalClock {
            anchors.fill: parent
            visible: !clockShow
        }
        JLogo {}
    }

    Item {
        id: alarmLayout

        anchors.left: watchLayout.right
        width: root.width / 2
        height: root.height - toolbarHeight

        Item {
            id: topLayout

            anchors.left: parent.left
            anchors.right: parent.right
            width: parent.width
            height: parent.height / 9
            z: 20

            Item {
                id: btn_add

                width: parent.width /3
                height: JDisplay.dp(22)
                anchors.left: parent.left
                anchors.leftMargin: JDisplay.dp(10)
                anchors.bottom: parent.bottom

                Kirigami.Icon {
                    id: addIcon

                    width: JDisplay.dp(22)
                    height: width
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    color: Kirigami.JTheme.iconForeground
                    source: "qrc:/image/alarm_add_l.png"
                }

                Label {
                    id: addText

                    anchors.left: addIcon.right
                    anchors.leftMargin: JDisplay.dp(5)
                    anchors.verticalCenter: parent.verticalCenter

                    text: i18n("Add Alarm")
                    font.pixelSize: JDisplay.sp(14)
                    color: Kirigami.JTheme.majorForeground
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var kk = mapToItem(root , btn_add.x , btn_add.y)

                        popupEventEditor.x=btn_add.x
                        popupEventEditor.y=btn_add.y +  22+ 26
                        popupEventEditor.blurX = kk.x
                        popupEventEditor.blurY = kk.y
                        popupEventEditor.popTitle = i18n("Add Alarm")
                        popupEventEditor.open()
                    }
                }
            }
        }

        JAlarmEditDialog {
            id: popupEventEditor
        }

        Item {
            id: bottomLayout

            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: parent.width
            height: parent.height / 10
            z: 20
        }

        Item {
            id: rightLayout

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: bottomLayout.top
            anchors.top: topLayout.bottom
            anchors.topMargin: 26
            Layout.fillHeight: true

            clip: true

            GridView {
                id: alarmGridView

                height: rightLayout.height
                width: rightLayout.width
                anchors.left: parent.left
                anchors.leftMargin: JDisplay.dp(20)
                anchors.top: parent.top

                Layout.fillHeight: true
                model: alarmModel
                cellWidth: parent.width / 2 - JDisplay.dp(10)
                cellHeight: rightLayout.height / 3
                clip: true
                delegate: AlarmItemView {}
            }

            Item {
                id: alarmEmptyView

                width:Math.max(empty_icon.width, empty_text.width)
                height: empty_icon.height + empty_text.height + JDisplay.dp(15)
                anchors.centerIn: parent

                visible: alarmGridView.count == 0

                Kirigami.Icon {
                    id: empty_icon

                    width: JDisplay.dp(60)
                    height: width
                    anchors.horizontalCenter:parent.horizontalCenter

                    color: !isDarkTheme ? Qt.rgba(0,0,0,0.3) : Qt.rgba(247 / 255,247 / 255,247 / 255,0.3)//Kirigami.JTheme.minorForeground
                    source: "qrc:/image/alarm_empty.svg"
                }

                Text {
                    id: empty_text

                    height: JDisplay.dp(16)
                    width: JDisplay.dp(258)
                    anchors.top:empty_icon.bottom
                    anchors.topMargin: JDisplay.dp(15)
                    anchors.horizontalCenter:parent.horizontalCenter

                    horizontalAlignment:Text.AlignHCenter
                    color: !isDarkTheme ? Qt.rgba(0,0,0,0.3) : Qt.rgba(247 / 255,247 / 255,247 / 255,0.3)//Kirigami.JTheme.minorForeground
                    text: i18n("There is no alarm clock at present")
                    font.pixelSize: JDisplay.sp(14)
                }
            }
        }
    }
}
