/*
 * Copyright 2020 Devin Lin <espidev@gmail.com>
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
import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtQuick.Shapes 1.12
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0

Rectangle {
    id: root

    property int timerDuration
    property int timerElapsed
    property bool timerRunning
    property int fontSize: JDisplay.sp(80)

    anchors.centerIn: parent

    color: "transparent"

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

    // clock display
    RowLayout {
        id: timeLabels

        anchors.centerIn: parent

        Label {
            id: hoursText

            text: getHours()
            color: "white"
            font.pixelSize: root.fontSize
            font.family: clockFont.name
            visible: true
        }
        Label {
            text: ":"
            color: "white"
            font.pixelSize: root.fontSize
            font.family: clockFont.name
            visible: true
        }
        Label {
            id: minutesText

            text: getMinutes()
            color: "white"
            font.pixelSize: root.fontSize
            font.family: clockFont.name
        }
        Label {
            text: ":"
            color: "white"
            font.pixelSize: root.fontSize
            font.family: clockFont.name
        }
        Label {
            text: getSeconds()
            color: "white"
            font.pixelSize: root.fontSize
            font.family: clockFont.name
        }
    }

    Rectangle {
        width: timeLabels.width
        height: JDisplay.dp(2)
        anchors.left: timeLabels.left
        anchors.right: timeLabels.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: JDisplay.dp(-60)

        color: "#aaffffff"
    }

    Rectangle {
        width: timeLabels.width
        height: JDisplay.dp(2)
        anchors.left: timeLabels.left
        anchors.right: timeLabels.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: JDisplay.dp(60)

        color: "#aaffffff"
    }

    Rectangle {
        width: JDisplay.dp(500)
        height: JDisplay.dp(94)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: timeLabels.bottom
        anchors.topMargin: JDisplay.dp(33)

        visible: false
        color: "black"

        RowLayout {
            anchors.fill: parent

            Image {
                id: reset

                width: JDisplay.dp(28)
                height: width
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

                source: "qrc:/image/reset.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        timerPage.timer.reset()
                    }
                }
            }

            Image {
                id: ppBtn

                width: JDisplay.dp(94)
                height: width
                anchors.centerIn: parent
                Layout.alignment: Qt.AlignCenter

                source: timerPage.timer.running ? "qrc:/image/pause.png" : "qrc:/image/play.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        timerPage.timer.toggleRunning()
                    }
                }
            }

            Image {
                id: delBtn

                width: JDisplay.dp(28)
                height: width
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                source: "qrc:/image/delete.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        timerPage.timer.reset()
                        timerModel.remove(0)
                        timerPage.justCreated = true
                    }
                }
            }
        }
    }
}
