/*
 * Copyright 2020 Han Young <hanyoung@protonmail.com>
 *           2020 Devin Lin <espidev@gmail.com>
 *           2021 Rui Wang <wangrui@jingos.com>
 *           2021 DeXiang Mend <dexiang.meng@jingos.com>
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
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0
import kclock 1.0
import QtQml 2.12

Kirigami.Page {
    id: timerPage

    property var timer: timerModel.get(0)
    property int timerIndex
    property bool justCreated: timer == null
    property bool showFullscreen: false
    property int elapsed: timer == null ? 0 : timer.elapsed
    property int duration: timer == null ? 0 : timer.length
    property bool running: timer == null ? 0 : timer.running

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    globalToolBarStyle: Kirigami.ApplicationHeaderStyle.None

    function showNotification(notification)
    {
        toolTip.show(notification,2000)
    }

    Timer {
        id: pageTimer

        repeat: false
        running: false
        interval: 100

        onTriggered: {
            timer = timerModel.get(0)
            var length = hoursTumber.currentIndex * 60 * 60
                    + minutesTumber.currentIndex * 60 + secondsTumber.currentIndex
            if (length <= 0) {
                timerPage.showNotification(i18n("The countdown length set is illegal"))
                return
            }
            timer.length = length
            justCreated = false
        }
    }
    // topbar action
    Item {
        anchors.fill: parent
        JLogo {}

        Kirigami.JToolTip {
            id: toolTip

            font.pixelSize: JDisplay.sp(17)
        }

        Item {
            width: parent.width
            height: parent.height - toolbarHeight

            Item {
                id: controlLayout

                width: parent.width
                height: JDisplay.dp(80)
                anchors.verticalCenter: parent.verticalCenter

                Item {
                    id: stopwatchArea

                    width: parent.width / 3
                    height: parent.height - JDisplay.dp(20)
                    anchors.centerIn: parent

                    visible: justCreated

                    Rectangle {
                        width: JDisplay.dp(80)
                        height: width
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }

                        radius:  JDisplay.dp(10)
                        color: Kirigami.JTheme.buttonBackground
                    }
                    Rectangle {
                        width:JDisplay.dp(80)
                        height: width
                        anchors.centerIn: parent

                        radius:  JDisplay.dp(10)
                        color: Kirigami.JTheme.buttonBackground
                    }
                    Rectangle {
                        width: JDisplay.dp(80)
                        height: width
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        radius:  JDisplay.dp(10)
                        color: Kirigami.JTheme.buttonBackground
                    }
                }

                Kirigami.JButton{
                    width:JDisplay.dp(80)
                    height:width
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: stopwatchArea.left
                        rightMargin: JDisplay.dp(68)
                    }

                    visible: justCreated
                    display: Button.TextUnderIcon
                    text: i18n("Reset")

                    font.pixelSize: JDisplay.sp(17)
                    icon.width:JDisplay.dp(22)
                    icon.height:JDisplay.dp(22)
                    icon.color:Kirigami.JTheme.buttonForeground
                    icon.source:"qrc:/image/sw_reset_l.png"

                    onClicked:{
                        hoursTumber.currentIndex = 0
                        minutesTumber.currentIndex = 5
                        secondsTumber.currentIndex = 0
                    }
                }

                Kirigami.JButton{
                    property bool notStart : !running &&  elapsed == 0

                    width:JDisplay.dp(80)
                    height:width
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: stopwatchArea.left
                        rightMargin: JDisplay.dp(68)
                    }

                    display: Button.TextUnderIcon
                    visible: !justCreated
                    text: notStart ? i18n("Reset"): i18n("Done")

                    font.pixelSize: JDisplay.sp(17)
                    icon.width: JDisplay.dp(22)
                    icon.height: JDisplay.dp(22)
                    icon.color: Kirigami.JTheme.buttonForeground
                    icon.source: notStart ? "qrc:/image/sw_reset_l.png": "qrc:/image/timer_done_l.png"

                    onClicked: {
                        timer.reset()
                        timerModel.remove(0)
                        justCreated = true
                    }
                }

                Kirigami.JButton{
                    width:JDisplay.dp(80)
                    height:width
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: stopwatchArea.right
                        leftMargin: JDisplay.dp(68)
                    }
                    visible: justCreated
                    fontColor:"#39c17b"
                    text:i18n("New")
                    display: Button.TextUnderIcon

                    font.pixelSize: JDisplay.sp(17)
                    icon.width:JDisplay.dp(22)
                    icon.height:JDisplay.dp(22)
                    icon.source:"qrc:/image/timer_new.png"

                    onClicked:{
                        timerModel.addNew()
                        pageTimer.restart()
                    }
                }

                Kirigami.JButton {
                    width:JDisplay.dp(80)
                    height:width
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: stopwatchArea.right
                        leftMargin: JDisplay.dp(68)
                    }

                    display: Button.TextUnderIcon
                    visible: !justCreated
                    fontColor: timer.running ? "#e95b4e" : "#39c17b"
                    font.pixelSize: JDisplay.sp(17)
                    text: {
                        if (timer.running) {
                            return i18n("Pause")
                        } else {
                            if (timer.length == (timer.length-timer.elapsed)) {
                                return  i18n("Start")
                            } else {
                                return  i18n("Resume")
                            }
                        }
                    }

                    icon.width: JDisplay.dp(22)
                    icon.height: JDisplay.dp(22)
                    icon.source: timer.running ? "qrc:/image/sw_pause.png" : "qrc:/image/sw_start.png"

                    onClicked: {
                        timer.toggleRunning()
                    }
                }
            }

            Item {
                id: timerLayoutHolder

                width: parent.width / 3
                height: parent.height - JDisplay.dp(20)
                anchors.centerIn: parent
            }

            JTimerProgressComponent {
                visible: !justCreated
                timerDuration: duration
                timerElapsed: elapsed
                timerRunning: running

                onVisibleChanged:{
                    kclockFormat.setEnableBackground(visible)
                }
            }

            Kirigami.FormLayout {
                id: form

                property int fontSize: JDisplay.sp(34)

                anchors.centerIn: parent
                implicitWidth: timerLayoutHolder.width + JDisplay.dp(2)
                implicitHeight: JDisplay.dp(300)

                visible: justCreated
                Item {
                    anchors.fill: parent

                    RowLayout {
                        id: row
                        anchors.fill: parent

                        JTumbler {
                            id: hoursTumber

                            Layout.fillHeight: true
                            Layout.preferredWidth: JDisplay.dp(80)
                            Layout.alignment: Qt.AlignLeft

                            modelValue: 24
                            textSize: form.fontSize
                            textColor: Kirigami.JTheme.majorForeground
                            visibleItemCountValue: 3
                        }

                        JTumbler {
                            id: minutesTumber

                            Layout.fillHeight: true
                            Layout.preferredWidth: JDisplay.dp(80)
                            Layout.alignment: Qt.AlignHCenter

                            modelValue: 60
                            textSize: form.fontSize
                            textColor: Kirigami.JTheme.majorForeground
                            visibleItemCountValue: 3
                            currentIndex: 5
                        }

                        JTumbler {
                            id: secondsTumber

                            Layout.fillHeight: true
                            Layout.preferredWidth: JDisplay.dp(80)
                            Layout.alignment: Qt.AlignRight

                            modelValue: 60
                            textSize: form.fontSize
                            textColor: Kirigami.JTheme.majorForeground
                            visibleItemCountValue: 3
                        }
                    }
                }
            }

            Item {
                id: specialView

                width: parent.width / 3
                height: controlLayout.height
                anchors.centerIn: parent

                visible: justCreated
                JDoubleGradientView {
                    height: parent.height
                    width: height
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    text: i18n("Hours")
                }

                JDoubleGradientView {
                    height: parent.height
                    width: height
                    anchors {
                        centerIn: parent
                    }
                    text: i18n("Minutes")
                }

                JDoubleGradientView {
                    height: parent.height
                    width: height
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    text: i18n("Seconds")
                }
            }
        }
    }
}
