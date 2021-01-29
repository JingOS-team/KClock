/*
 * Copyright 2021 Rui Wang <wangrui@jingos.com>
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
import QtQuick.Controls 2.4
import kclock 1.0

Kirigami.Page {

    id: root
    signal alarmCheckedChange(bool checked)
    property bool clockShow: false
    property real myScale: appwindow.officalScale * 1.3

    background: Item {}

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    globalToolBarStyle : Kirigami.ApplicationHeaderStyle.None

    Rectangle {
        id: alarm_layout
        anchors.fill: parent
        color: "#00000000"

        Rectangle {
            id: watchLayout
            width: root.width / 2 - 18
            height: root.height - toolbarHeight
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                visible: clockShow
                color: "transparent"
                Image {
                    id: clockbg
                    anchors.centerIn: parent
                    source: "qrc:/image/watch_pad.png"
                    width: 736 * appwindow.officalScale
                    height: width
                }

                Item {
                    id: clockItem
                    anchors.centerIn: parent
                    Layout.alignment: Qt.AlignCenter
                    width: (736 - 80) * appwindow.officalScale
                    height: width
                    AnalogClock {
                        id: analogClock
                        clockRadius: clockItem.width / 2
                    }
                }

            }

            Rectangle {
                anchors.fill: parent
                visible: !clockShow
                color: "transparent"

                DigitalClock {
                    anchors.fill: parent
                }
            }

            JLogo{}
        }

        Rectangle {
            id: alarmLayout
            anchors.left: watchLayout.right
            color: "transparent"
            width: root.width / 2
            height: root.height - toolbarHeight

            Rectangle {
                id: topLayout
                anchors.left: parent.left
                anchors.right: parent.right
                width: parent.width
                height: parent.height / 9
                color: "transparent"
                z: 20

                Rectangle {
                    id: btn_add
                    width: parent.width /3
                    height: 48
                    anchors.left: parent.left
                    anchors.leftMargin: 20 * appwindow.officalScale
                    anchors.bottom: parent.bottom
                    color: "transparent"

                    Image {
                        id: addIcon
                        source: "qrc:/image/alarm_add.png"
                        width: 44 * appwindow.officalScale
                        height: 44 * appwindow.officalScale
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Label {
                        id: addText
                        text: i18n("Add Alarm")
                        font.pixelSize: 28
                        color: "white"
                        anchors.left: addIcon.right
                        anchors.leftMargin: 5
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {

                            console.log("px = " + btn_add.x)
                            console.log("py = " + btn_add.y)

                            popupEventEditor.px=btn_add.x
                            popupEventEditor.py=btn_add.y + 60*myScale
                            var kk = mapToItem(root , btn_add.x , btn_add.y)
                            popupEventEditor.blurX = kk.x
                            popupEventEditor.blurY = kk.y
                            popupEventEditor.popTitle = "Add Alarm"
                            popupEventEditor.open()
                        }
                    }
                }
            }

            JAlarmEditDialog {
                  id: popupEventEditor

            }
            JAlarmDelDialog {
                   id: alarmDel
            }

            Rectangle {
                id: bottomLayout
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                width: parent.width
                height: parent.height / 9
                color: "transparent"
                z: 20
            }

            Rectangle {

                id: rightLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: bottomLayout.top
                anchors.top: topLayout.bottom
                Layout.fillHeight: true
                color: "transparent"
                clip: true

                GridView {
                    id: alarmGridView
                    model: alarmModel
                    cellWidth: parent.width / 2 - 40
                    cellHeight:  alarmLayout.height / 9 * 7 / 3
                    clip: true
                    delegate: AlarmItemView {}
                    height: 960 * appwindow.officalScale
                    width: 920 * appwindow.officalScale
                    Layout.fillHeight: true
                    anchors.left: parent.left
                    anchors.leftMargin: 20 * appwindow.officalScale
                    anchors.top: parent.top
                    boundsBehavior: Flickable.StopAtBounds
                }
            }
        }
    }


    function getRepeatFormat(dayOfWeek) {
        if (dayOfWeek == 0) {
            return i18n("No Repeat")
        }
        let monday = 1 << 0, tuesday = 1 << 1, wednesday = 1 << 2, thursday = 1 << 3, friday = 1 << 4, saturday = 1 << 5, sunday = 1 << 6

        if (dayOfWeek == monday + tuesday + wednesday + thursday + friday + saturday + sunday)
            return i18n("Everyday")

        if (dayOfWeek == monday + tuesday + wednesday + thursday + friday)
            return i18n("Weekdays")

        let str = ""
        if (dayOfWeek & monday)
            str += "Mon., "
        if (dayOfWeek & tuesday)
            str += "Tue., "
        if (dayOfWeek & wednesday)
            str += "Wed., "
        if (dayOfWeek & thursday)
            str += "Thu., "
        if (dayOfWeek & friday)
            str += "Fri., "
        if (dayOfWeek & saturday)
            str += "Sat., "
        if (dayOfWeek & sunday)
            str += "Sun., "
        return str.substring(0, str.length - 2)
    }
}
