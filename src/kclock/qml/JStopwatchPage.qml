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

Kirigami.Page {
    id: stopwatchpage

    property bool running: false
    property int elapsedTime: stopwatchTimer.elapsedTime
    property int stopwatchFontSize: appwindow.fontSize + 108
    property alias sLeft: stopwatchArea.left
    property alias sRight: stopwatchArea.right
    property alias sTop: stopwatchArea.top
    property alias sBottom: stopwatchArea.bottom
    property int lapTitleFontSize: appwindow.fontSize - 3
    property int listitemFontSize: appwindow.fontSize + 6
    property real myScale: appwindow.officalScale * 1.3

    anchors.margins: 0
    Layout.fillWidth: true
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    globalToolBarStyle: Kirigami.ApplicationHeaderStyle.None
    
    background: Item {}

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
        for (var i = 0; i < val; i++) {
            numbers += '0'
        }
        var s = 1 + numbers
        var spot = "." + numbers
        var value = Math.round(parseFloat(data) * s) / s
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

    Rectangle {
        id: contentLayout
        anchors.fill: parent
        color: "#00000000"

        JLogo {}

        Rectangle {
            width: parent.width
            height: parent.height - toolbarHeight
            color: "transparent"
            Rectangle {
                id: controlLayout
                width: parent.width
                height: 200 * appwindow.officalScale
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"

                Rectangle {
                    id: stopwatchArea
                    width: parent.width / 8 * 3
                    height: parent.height - 20 * appwindow.officalScale
                    anchors.centerIn: parent
                    color: "transparent"
                }

                JButton {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: stopwatchArea.left
                        rightMargin: 100 * appwindow.officalScale
                    }
                    btn_width: 160 * appwindow.officalScale
                    btn_height: btn_width
                    btn_icon: "qrc:/image/sw_lap.png"
                    btn_content: "Lap"
                    visible: running

                    onJbtnClick: {
                        roundModel.insert(0, {
                                              "time": elapsedTime
                                          })
                    }
                }

                JButton {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: stopwatchArea.left
                        rightMargin: 100 * appwindow.officalScale
                    }
                    btn_width: 160 * appwindow.officalScale
                    btn_height: btn_width
                    btn_icon: "qrc:/image/sw_reset.png"
                    btn_content: "Reset"
                    visible: !running

                    onJbtnClick: {
                        console.log("Hello World222")
                        stopwatchTimer.reset()
                        roundModel.clear()
                    }
                }

                JButton {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: stopwatchArea.right
                        leftMargin: 100 * appwindow.officalScale
                    }
                    btn_width: 160 * appwindow.officalScale
                    btn_height: btn_width
                    btn_icon: running ? "qrc:/image/sw_pause.png" : "qrc:/image/sw_start.png"
                    btn_content: running ? "Pause" : "Start"
                    statusPress: running ? "#e95b4e" : "#39c17b"

                    onJbtnClick: {
                        //                    console.log("Hello World" , isStopRunning())
                        running = !running
                        stopwatchTimer.toggle()
                    }
                }
            }

            Rectangle {
                id: stopwatchAreaHold
                width: parent.width / 8 * 3
                height: 180 * appwindow.officalScale
                anchors.centerIn: parent
                color: "transparent"
            }
            Rectangle {
                id: stopwatchAreaHoldNew
                width: parent.width / 8 * 3
                height: 180 * appwindow.officalScale
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -200 * appwindow.officalScale
                color: "transparent"
            }

            Rectangle {
                id: lapTitleLayout
                width: parent.width / 8 * 3
                height: 60 * appwindow.officalScale
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -40 * appwindow.officalScale
                color: "transparent"
                z: 20
                visible: running || roundModel.count > 0

                Label {
                    text: i18n("LAP NO.")
                    color: "#aaffffff"
                    font.pointSize: lapTitleFontSize
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    text: i18n("SPLIT")
                    color: "#aaffffff"
                    font.pointSize: lapTitleFontSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    text: i18n("TOTAL")
                    color: "#aaffffff"
                    font.pointSize: lapTitleFontSize
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                id: stopwatchLayout
                anchors {
                    left: stopwatchAreaHold.left
                    top: running
                         || roundModel.count > 0 ? stopwatchAreaHoldNew.top : stopwatchAreaHold.top
                    right: stopwatchAreaHold.right
                    bottom: running || roundModel.count
                            > 0 ? stopwatchAreaHold.top : stopwatchAreaHold.bottom
                }
                color: "transparent"

                RowLayout {
                    id: timeLabels
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -10 * appwindow.officalScale
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: minutesText
                        width: 172 * myScale
                        text: stopwatchTimer.minutes
                        color: "white"
                        font.pointSize: stopwatchFontSize
                        font.family: clockFont.name
                        Layout.alignment: Qt.AlignVCenter
                        anchors {
                            right: left_tag.left
                            rightMargin: 2 * myScale
                        }
                    }
                    Text {
                        id: left_tag
                        text: ":"
                        color: "white"
                        font.pointSize: stopwatchFontSize
                        font.family: clockFont.name
                        anchors {
                            right: sw_minutes.left
                            rightMargin: 2 * myScale
                        }
                    }
                    Text {
                        id: sw_minutes
                        anchors.centerIn: parent
                        width: 172 * myScale
                        color: "white"
                        font.pointSize: stopwatchFontSize
                        font.family: clockFont.name
                        text: stopwatchTimer.seconds
                    }
                    Text {
                        id: right_tag
                        anchors {
                            left: sw_minutes.right
                            leftMargin: 2 * myScale
                        }
                        text: "."
                        color: "white"
                        font.pointSize: stopwatchFontSize
                        font.family: clockFont.name
                    }
                    Text {
                        id: secondsText
                        anchors {
                            left: right_tag.right
                            leftMargin: 2 * myScale
                        }
                        width: 172 * myScale
                        text: stopwatchTimer.small
                        color: "white"
                        font.pointSize: stopwatchFontSize
                        font.family: clockFont.name
                    }
                }
            }

            ListView {
                id: modellist
                model: roundModel
                spacing: 31 * myScale
                anchors.left: lapTitleLayout.left
                anchors.right: lapTitleLayout.right
                anchors.topMargin: 28 * myScale
                anchors.top: lapTitleLayout.bottom
                anchors.bottom: contentLayout.bottom
                anchors.bottomMargin: 137 * appwindow.officalScale
                height: 282 * myScale
                Layout.fillHeight: true

                delegate: Item {

                    width: parent.width
                    height: 42

                    RowLayout {
                        width: modellist.width
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignVCenter

                        Rectangle {
                            id: countLayout
                            implicitWidth: 210
                            implicitHeight: 33
                            color: "transparent"
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            Label {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                color: "white"
                                font.pointSize: listitemFontSize
                                text: i18n("LAP") + (roundModel.count - model.index)
                            }
                        }

                        Rectangle {
                            implicitWidth: 210 * appwindow.officalScale
                            implicitHeight: 28
                            color: "transparent"
                            anchors.centerIn: parent
                            Label {
                                anchors.centerIn: parent
                                color: "white"
                                font.pointSize: listitemFontSize
                                text: index == roundModel.count - 1 ? getStopwatchTime(
                                                                          parseFloat(model.time / 1000).toFixed(2)) : getStopwatchTime(parseFloat((model.time - roundModel.get(index + 1).time) / 1000).toFixed(2))
                            }
                        }

                        Rectangle {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"
                            Layout.fillHeight: true
                            Label {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                color: "white"
                                font.pointSize: listitemFontSize
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
