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
import QtGraphicalEffects 1.12
import org.kde.kirigami 2.11 as Kirigami
import kclock 1.0

Kirigami.Page {
    id: timerPage

    property Timer timer: timerModel.get(0)
    property int timerIndex
    property bool justCreated: timer == null
    property bool showFullscreen: false
    property int elapsed: timer == null ? 0 : timer.elapsed
    property int duration: timer == null ? 0 : timer.length
    property bool running: timer == null ? 0 : timer.running
    property real mScale: appwindow.officalScale

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    globalToolBarStyle: Kirigami.ApplicationHeaderStyle.None

    background: Item {}

    // topbar action
    Rectangle {
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
                height: 160 * appwindow.officalScale
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"

                Rectangle {
                    id: stopwatchArea
                    width: parent.width / 3
                    height: parent.height - 20 * appwindow.officalScale
                    anchors.centerIn: parent
                    visible: justCreated
                    color: "transparent"

                    Rectangle {
                        color: "#9a000000"
                        width: 160 * mScale
                        height: width
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        radius: 40 * appwindow.officalScale
                    }
                    Rectangle {
                        color: "#9a000000"
                        width: 160 * mScale
                        height: width
                        anchors {
                            centerIn: parent
                        }
                        radius: 40 * appwindow.officalScale
                    }
                    Rectangle {
                        color: "#9a000000"
                        width: 160 * mScale
                        height: width
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        radius: 40 * appwindow.officalScale
                    }
                }

                JButton {
                    visible: justCreated
                    btn_width: 160 * appwindow.officalScale
                    btn_height: btn_width
                    btn_icon: "qrc:/image/sw_reset.png"
                    btn_content: "Reset"
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: stopwatchArea.left
                        rightMargin: 100 * appwindow.officalScale
                    }

                    onJbtnClick: {
                        hoursTumber.currentIndex = 0
                        minutesTumber.currentIndex = 5
                        secondsTumber.currentIndex = 0
                    }
                }

                JButton {
                    visible: !justCreated
                    btn_width: 160 * appwindow.officalScale
                    btn_height: btn_width
                    btn_icon: "qrc:/image/timer_done.png"
                    btn_content: "Done"
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: stopwatchArea.left
                        rightMargin: 100 * appwindow.officalScale
                    }

                    onJbtnClick: {
                        timer.reset()
                        timerModel.remove(0)
                        justCreated = true
                    }
                }

                JButton {
                    visible: justCreated
                    btn_width: 160 * appwindow.officalScale
                    btn_height: btn_width
                    btn_icon: "qrc:/image/timer_new.png"
                    btn_content: "New"
                    statusPress: "#39c17b"
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: stopwatchArea.right
                        leftMargin: 100 * appwindow.officalScale
                    }

                    onJbtnClick: {
                        timerModel.addNew()
                        timer = timerModel.get(0)
                        console.log("first timer is : ", timerModel.get(0))
                        var length = hoursTumber.currentIndex * 60 * 60
                                + minutesTumber.currentIndex * 60 + secondsTumber.currentIndex
                        if (length <= 0) {
                            showPassiveNotification("倒计时时长不合法")
                            return
                        }
                        timer.length = length
                        justCreated = false
                    }
                }

                JButton {
                    visible: !justCreated
                    btn_width: 160 * appwindow.officalScale
                    btn_height: btn_width
                    btn_icon: timer.running ? "qrc:/image/sw_pause.png" : "qrc:/image/sw_start.png"
                    btn_content: timer.running ? "Pause" : "Start"
                    statusPress: timer.running ? "#e95b4e" : "#39c17b"
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: stopwatchArea.right
                        leftMargin: 100 * appwindow.officalScale
                    }

                    onJbtnClick: {
                        timer.toggleRunning()
                    }
                }
            }

            Rectangle {
                id: timerLayoutHolder
                width: parent.width / 3
                height: parent.height - 20 * appwindow.officalScale
                anchors.centerIn: parent
                color: "transparent"
            }

            JTimerProgressComponent {
                visible: !justCreated
                timerDuration: duration
                timerElapsed: elapsed
                timerRunning: running
            }

            Kirigami.FormLayout {
                id: form
                
                property int fontSize: 50 * appwindow.officalScale
                anchors.centerIn: parent
                implicitWidth: timerLayoutHolder.width - 60 * mScale
                implicitHeight: (370 + 88 + 2 + 120) * mScale
                visible: justCreated

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"

                    Row {
                        id: row
                        width: form.width
                        height: form.height

                        JTumbler {
                            id: hoursTumber
                            widget_h: parent.height
                            widget_w: 101 * appwindow.officalScale
                            modelValue: 24
                            textSize: form.fontSize
                            textColor: "white"
                            anchors.left: parent.left
                            visibleItemCountValue: 3
                            btn_w: 88 * appwindow.officalScale
                            btn_h: btn_w
                        }

                        JTumbler {
                            id: minutesTumber
                            widget_h: parent.height
                            widget_w: 101 * appwindow.officalScale
                            modelValue: 60
                            textSize: form.fontSize
                            textColor: "white"
                            visibleItemCountValue: 3
                            btn_w: 88 * appwindow.officalScale
                            btn_h: btn_w
                            anchors.horizontalCenter: parent.horizontalCenter
                            currentIndex: 5
                        }

                        JTumbler {
                            id: secondsTumber
                            widget_h: parent.height
                            widget_w: 101 * appwindow.officalScale
                            modelValue: 60
                            textSize: form.fontSize
                            textColor: "white"
                            anchors.right: parent.right
                            visibleItemCountValue: 3
                            btn_w: 88 * appwindow.officalScale
                            btn_h: btn_w
                        }
                    }
                }
            }

            Rectangle {
                id: special_view
                width: parent.width / 3
                height: controlLayout.height
                anchors.centerIn: parent
                visible: justCreated
                color: "transparent"

                JDoubleGradientView {
                    text: "Hours"
                    height: parent.height
                    width: height
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                }

                JDoubleGradientView {
                    text: "Minutes"
                    height: parent.height
                    width: height
                    anchors {
                        centerIn: parent
                    }
                }

                JDoubleGradientView {
                    text: "Seconds"
                    height: parent.height
                    width: height

                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
