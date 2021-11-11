/*
 * Copyright 2020 Devin Lin <espidev@gmail.com>
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
import QtQuick.Shapes 1.12
import org.kde.kirigami 2.15 as Kirigami215
import jingos.display 1.0
import QtGraphicalEffects 1.0

Item {
    id: root

    property int timerDuration
    property int timerElapsed
    property bool timerRunning
    property int fontSize: JDisplay.sp(34)

    width: JDisplay.dp(320)
    height: JDisplay.sp(80)
    anchors.centerIn: parent

    function getTimeLeft() {
        return timerDuration - timerElapsed
    }
    function getHours() {
        return ("0" + parseInt(getTimeLeft() / 60 / 60).toFixed(0)).slice(-2)
    }
    function getMinutes() {
        return ("0" + parseInt(getTimeLeft() / 60 - 60 * getHours())).slice(-2)
    }
    function getSeconds() {
        return ("0" + parseInt(getTimeLeft() - 60 * getMinutes())).slice(-2)
    }

    Slider {
        id: sliderArea

        width: parent.width
        height: parent.height
        leftPadding: 0
        rightPadding: 0

        from: timerDuration
        to: 0

        handle: Item {
            visible: true
            width: 1
            height: 1
            x: 0
            y: 0

            Rectangle {
                anchors.centerIn: parent
                width: 1
                height: 1
                visible: false
            }
        }
        background: Rectangle {
            id: progressBarBackground

            color: Kirigami215.JTheme.cardBackground
            radius: JDisplay.sp(10)

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: progressBarBackground.width
                    height: progressBarBackground.height
                    radius: progressBarBackground.radius
                }
            }

            Rectangle {
                width: (1 - timerElapsed / timerDuration) * parent.width
                height: parent.height
                color: {
                    if(appwindow.isDarkTheme){
                        timerRunning ? "#39c17b" : "#555555"
                    }else {
                        timerRunning ? "#39c17b" : "#333C3F48"
                    }

                }
            }
        }
    }

    Item {
        width: JDisplay.dp(240)
        height: JDisplay.dp(42)
        anchors.centerIn: parent
        RowLayout {
            anchors.centerIn: parent

            Label {
                text: getHours()
                font.pixelSize: fontSize
                font.family: "Gilroy SemiBold"
                color: Kirigami215.JTheme.majorForeground
            }
            Label {
                text: ":"
                font.pixelSize: fontSize
                font.family: "Gilroy SemiBold"
                color: Kirigami215.JTheme.majorForeground
            }
            Label {
                text: getMinutes()
                font.pixelSize: fontSize
                font.family: "Gilroy SemiBold"
                color: Kirigami215.JTheme.majorForeground
            }
            Label {
                text: ":"
                font.pixelSize: fontSize
                font.family: "Gilroy SemiBold"
                color: Kirigami215.JTheme.majorForeground
            }
            Label {
                text: getSeconds()
                font.pixelSize: fontSize
                font.family: "Gilroy SemiBold"
                color: Kirigami215.JTheme.majorForeground
            }
        }
    }
}
