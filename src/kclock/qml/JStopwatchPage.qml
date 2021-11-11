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

import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtQuick.Window 2.11
import QtGraphicalEffects 1.12

import org.kde.kirigami 2.4 as Kirigami
import org.kde.kirigami 2.15 as Kirigami215
import jingos.display 1.0
Kirigami.Page {
    id: stopwatchpage

    property bool running: false
    property int elapsedTime: stopwatchTimer.elapsedTime
    property int stopwatchFontSize: JDisplay.sp(90)
    property int lapTitleFontSize: JDisplay.sp(11)
    property int listitemFontSize: JDisplay.sp(17)

    Layout.fillWidth: true
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    globalToolBarStyle: Kirigami.ApplicationHeaderStyle.None

    function getStopwatchTime(result) {

        var h = Math.floor(
                    result / 3600) < 10 ? '0' + Math.floor(
                                              result / 3600) : Math.floor(
                                              result / 3600)
        var m = Math.floor(
                    (result / 60 % 60)) < 10 ? '0' + Math.floor(
                                                   (result / 60 % 60)) : Math.floor(
                                                   (result / 60 % 60))
        var ss = result % 60 < 10 ? '0' + result % 60 : result % 60
        var s = number(ss, 2)

        if (s < 10) {
            s = '0' + s
        }
        if (h == "00") {
            return m + ":" + s
        }
        return h + ":" + m + ":" + s
    }

    function number(data, val) {
        var numbers = ''
        // 保留几位小数后面添加几个0
        for (var i = 0; i < val; i++) {
            numbers += '0'
        }
        var s = 1 + numbers
        // 如果是整数需要添加后面的0
        var spot = "." + numbers
        // Math.round四舍五入
        //  parseFloat() 函数可解析一个字符串，并返回一个浮点数。
        var value = Math.round(parseFloat(data) * s) / s
        // 从小数点后面进行分割
        var d = value.toString().split(".")
        if (d.length == 1) {
            value = value.toString() + spot
            return value
        }
        if (d.length > 1) {
            if (d[1].length < 2) {
                value = value.toString() + "0"
            }
            return value
        }
    }

    Item {
        id: contentLayout

        anchors.fill: parent

        JLogo {}

        Item {
            width: parent.width
            height: parent.height - toolbarHeight
            Item {
                width: parent.width
                height: JDisplay.dp(100)
                anchors.verticalCenter: parent.verticalCenter

                Item {
                    id: stopwatchArea

                    width: parent.width / 8 * 3
                    height: parent.height - JDisplay.dp(2)
                    anchors.centerIn: parent
                }


                Kirigami215.JButton{
                    width: JDisplay.dp(80)
                    height:width
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: stopwatchArea.left
                        rightMargin: JDisplay.dp(62)
                    }

                    display: Button.TextUnderIcon
                    text: i18n("Lap")
                    font.pixelSize: JDisplay.sp(17)
                    visible:running
                    icon.width:JDisplay.dp(22)
                    icon.height:JDisplay.dp(22)
                    icon.color:Kirigami215.JTheme.buttonForeground
                    icon.source:"qrc:/image/sw_lap_l.png"
                    onClicked: {
                        modellist.positionViewAtBeginning()
                        roundModel.insert(0, {"time": elapsedTime})
                   }
                }

                Kirigami215.JButton{
                    width: JDisplay.dp(80)
                    height: width
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: stopwatchArea.left
                        rightMargin: JDisplay.dp(62)
                    }

                    display: Button.TextUnderIcon
                    enabled: !running && elapsedTime != 0
                    visible:!running
                    text: enabled ? i18n("Reset") :  i18n("Lap")
                    font.pixelSize: JDisplay.sp(17)
                    fontColor: enabled ? Kirigami215.JTheme.buttonForeground : Kirigami215.JTheme.minorForeground
                    icon.width:JDisplay.dp(22)
                    icon.height:JDisplay.dp(22)
                    icon.color: enabled ? Kirigami215.JTheme.buttonForeground : Kirigami215.JTheme.minorForeground
                    icon.source: enabled ? "qrc:/image/sw_reset_l.png" : "qrc:/image/sw_lap_l.png"

                    onClicked:{
                        stopwatchTimer.reset()
                        roundModel.clear()
                    }
                }

                Kirigami215.JButton{
                    width:JDisplay.dp(80)
                    height:width
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: stopwatchArea.right
                        leftMargin: JDisplay.dp(62)
                    }

                    icon.width:JDisplay.dp(22)
                    icon.height:JDisplay.dp(22)
                    icon.source:running ? "qrc:/image/sw_pause.png" : "qrc:/image/sw_start.png"
                    fontColor:running ? "#e95b4e" : "#39c17b"
                    text:running ? i18n("Stop") : i18n("Start")
                    font.pixelSize: JDisplay.sp(17)

                    onClicked:{
                        running = !running
                        stopwatchTimer.toggle()
                    }
                }
            }

            Item {
                id: stopwatchAreaHold

                width: parent.width / 8 * 3
                height: JDisplay.dp(90)
                anchors.centerIn: parent
            }

            Item {
                id: stopwatchAreaHoldNew

                width: parent.width / 8 * 3
                height: JDisplay.dp(90)
                anchors.centerIn: parent
                anchors.verticalCenterOffset: JDisplay.dp(-100)
            }

            Item {
                id: lapTitleLayout

                width: parent.width / 8 * 3
                height: JDisplay.dp(14)
                anchors.centerIn: parent
                anchors.verticalCenterOffset: JDisplay.dp(-10)

                z: 20
                opacity: 0

                Label {
                    text: i18n("LAP NO.")
                    color: Kirigami215.JTheme.majorForeground
                    font.pixelSize: lapTitleFontSize
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    text: i18n("SPLIT")
                    color:Kirigami215.JTheme.majorForeground
                    font.pixelSize: lapTitleFontSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    text: i18n("TOTAL")
                    color: Kirigami215.JTheme.majorForeground
                    font.pixelSize: lapTitleFontSize
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: stopwatchLayout

                anchors {
                    left: stopwatchAreaHold.left
                    right: stopwatchAreaHold.right
                }
                height: JDisplay.dp(90)
                state: running || roundModel.count > 0 ? "running" : "stop"

                states: [
                    State {
                        name: "running"
                        AnchorChanges { target: stopwatchLayout; anchors.top: stopwatchAreaHoldNew.top; anchors.bottom: stopwatchAreaHoldNew.bottom }
                    },
                    State {
                        name: "stop"
                        AnchorChanges { target: stopwatchLayout; anchors.top: stopwatchAreaHold.top; anchors.bottom: stopwatchAreaHold.bottom }
                    }
                ]

                transitions: [
                    Transition {
                        from: "running"
                        to: "stop"
                        ParallelAnimation {
                            AnchorAnimation {duration: 75 }
                            NumberAnimation {
                                target: lapTitleLayout
                                property: "opacity"
                                to: 0
                                duration: 75
                            }
                        }
                    },
                    Transition {
                        from: "stop"
                        to: "running"
                        ParallelAnimation {
                            AnchorAnimation {duration: 75 }
                            NumberAnimation {
                                target: lapTitleLayout
                                property: "opacity"
                                to: 1
                                duration: 75
                            }
                        }
                    }
                ]

                RowLayout {
                    id: timeLabels

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: JDisplay.dp(-5)
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: JDisplay.dp(0)
                    Rectangle {
                        id: sw_minutes_parent

                        Layout.minimumWidth: minutesText.width
                        Layout.fillWidth: true
                        height: minutesText.height
                        color: "transparent"
                        Text {
                            id: minutesText
                            anchors.centerIn:parent
                            text: stopwatchTimer.minutes
                            color: Kirigami215.JTheme.majorForeground
                            font.pixelSize: stopwatchFontSize
                            font.family: clockFont.name
                        }
                    }
                    Text {
                        id: left_tag

                        text: ":"
                        color: Kirigami215.JTheme.majorForeground
                        font.pixelSize: stopwatchFontSize
                        font.family: clockFont.name
                    }
                    Rectangle {
                        id: sw_second_parent

                        Layout.fillWidth: true
                        Layout.minimumWidth: JDisplay.dp(116)
                        color: "transparent"
                        height: sw_minutes.height

                         Text {
                            id: sw_minutes

                            text: stopwatchTimer.seconds
                            anchors.centerIn:parent
                            color: Kirigami215.JTheme.majorForeground
                            font.pixelSize: stopwatchFontSize
                            font.family: clockFont.name
                        }

                    }

                    Text {
                        id: right_tag

                        text: "."
                        color: Kirigami215.JTheme.majorForeground
                        font.pixelSize: stopwatchFontSize
                        font.family: clockFont.name
                    }
                    Rectangle {
                        id: sw_msecond_parent

                        Layout.minimumWidth: JDisplay.dp(116)
                        Layout.fillWidth: true
                        height: secondsText.height
                        color: "transparent"

                        Text {
                            id: secondsText

                            anchors.centerIn:parent
                            text: stopwatchTimer.small
                            color: Kirigami215.JTheme.majorForeground
                            font.pixelSize: stopwatchFontSize
                            font.family: clockFont.name
                        }
                    }
                }
            }

            ListView {
                id: modellist

                anchors.left: lapTitleLayout.left
                anchors.right: lapTitleLayout.right
                anchors.topMargin: JDisplay.dp(20)
                anchors.top: lapTitleLayout.bottom
                anchors.bottom: parent.bottom
                anchors.bottomMargin: JDisplay.dp(85)
                height: JDisplay.dp(164)

                model: roundModel
                spacing: JDisplay.dp(20)

                delegate: Item {
                    width: parent.width
                    height: JDisplay.dp(21)

                    RowLayout {
                        width: modellist.width
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignVCenter

                        Item {
                            id: countLayout

                            implicitWidth: JDisplay.dp(210)
                            implicitHeight: JDisplay.dp(33)
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            Label {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                color: Kirigami215.JTheme.majorForeground
                                font.pixelSize: listitemFontSize
                                text: i18n("LAP %1" ,  (roundModel.count - model.index))
                            }
                        }

                        Item {
                            implicitWidth: JDisplay.dp(210)
                            implicitHeight: JDisplay.dp(28)
                            anchors.centerIn: parent
                            Label {
                                anchors.centerIn: parent
                                color: Kirigami215.JTheme.majorForeground
                                font.pixelSize: listitemFontSize
                                text: index == roundModel.count - 1 ? getStopwatchTime(
                                                                          parseFloat(model.time / 1000).toFixed(2)) :
                                                                          getStopwatchTime(parseFloat((model.time - roundModel.get(index + 1).time) / 1000).toFixed(2))
                            }
                        }

                        Item {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Layout.fillHeight: true
                            Label {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                color: Kirigami215.JTheme.majorForeground
                                font.pixelSize: listitemFontSize
                                text: getStopwatchTime(
                                          parseFloat(
                                              model.time / 1000).toFixed(2))
                            }
                        }
                    }
                }
            }

            ListModel {
                id: roundModel
            }
        }
    }
}
