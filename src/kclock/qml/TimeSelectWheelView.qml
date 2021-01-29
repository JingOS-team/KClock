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
import QtQuick 2.14
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0 as Controls2
import org.kde.kirigami 2.3 as Kirigami
import "../CommonSize.js" as CS

RowLayout {
    id: timeRow

    property alias hourNumber: hour_wheel.value
    property alias minutesNumber: minute_wheel.value
    property real mScale: appwindow.officalScale
    property int widget_width: 305 * mScale
    property int widget_height: 130 * mScale

    signal minChanged(var minValue)
    signal hourChanged(var hourValue)

    width: widget_width
    height: widget_height
    spacing: 10 * appwindow.officalScale

    // hours
    Rectangle {
        id: hour_view

        property real hour_beginX
        property real hour_beginY
        property int hour_direction
        property bool pressState1: false

        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        width: 80 * mScale
        height: parent.height
        color: "#dd000000"
        radius: 20 * appwindow.officalScale
        
        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 10
            width: parent.width
            height: 22 * mScale
            color: "transparent"
            Image {
                sourceSize.width: 20 * mScale
                sourceSize.height: 12 * mScale
                anchors.centerIn: parent
                source: "qrc:/image/time_wheel_up.png"
            }
            MouseArea {
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    console.log("hour : ", hour_wheel.value)
                    if (hour_wheel.value === 0) {
                        hour_wheel.value = 23
                    } else {
                        hour_wheel.value -= 1
                    }
                    hourNumber = hour_wheel.value
                    hourChanged(hourNumber)
                }
            }
        }

        WheelView {
            id: hour_wheel
            
            anchors.centerIn: parent
            width: 40 * mScale
            height: 40 * mScale
            value: 0
            pathItemCount: 1
            displayFontSize: 36 * mScale
            model: {
                var list = []
                for (var i = 0; i < 24; i++)
                    list.push({
                                  "display": (i / 10 < 1 ? "0" + i : "" + i),
                                  "value": i
                              })
                return list
            }
            onViewMove: {
                hourNumber = index
            }
            onValueChanged: {
                console.log("hour changed")
                hourChanged(hourNumber)
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * mScale

            width: parent.width
            height: 22 * mScale
            color: "transparent"

            Image {
                sourceSize.width: 20 * mScale
                sourceSize.height: 12 * mScale
                anchors.centerIn: parent
                source: "qrc:/image/time_wheel_down.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (hour_wheel.value === 23) {
                        hour_wheel.value = 0
                    } else {
                        hour_wheel.value += 1
                    }
                    hourNumber = hour_wheel.value
                    hourChanged(hourNumber)
                    mouse.accepted = true
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true

            onPressed: {
                hour_view.pressState1 = true
                hour_view.hour_beginY = mouseY
                hour_view.hour_beginX = mouseX
                preventStealing = true
            }

            onPositionChanged: {
                var min_distance = 10
                if (mouseY - hour_view.hour_beginY > min_distance) {
                    if (hour_wheel.value === 0) {
                        hour_wheel.value = 23
                    } else {
                        hour_wheel.value -= 1
                    }
                } else if (mouseY - hour_view.hour_beginY < -min_distance) {
                    if (hour_wheel.value === 23) {
                        hour_wheel.value = 0
                    } else {
                        hour_wheel.value += 1
                    }
                }

                hourNumber = hour_wheel.value
                hour_view.hour_beginX = mouseX
                hour_view.hour_beginY = mouseY
            }

            onWheel: {
                if (wheel.angleDelta.y >= 120) {
                    if (hour_wheel.value === 0) {
                        hour_wheel.value = 23
                    } else {
                        hour_wheel.value -= 1
                    }
                } else if(wheel.angleDelta.y <= -120){
                    if (hour_wheel.value === 23) {
                        hour_wheel.value = 0
                    } else {
                        hour_wheel.value += 1
                    }
                }
                hourNumber = hour_wheel.value
            }

            onReleased: {
                hour_view.pressState1 = false
                hour_view.hour_beginX = -1
                hour_view.hour_beginY = -1
                preventStealing = true
            }

            onClicked: {
                mouse.accepted = false
            }
        }
    }

    // :
    Rectangle {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        width: timeRow.width / 30
        height: timeRow.width / 36 * 5
        color: "transparent"
        Controls2.Label {
            anchors.centerIn: parent
            text: ":"
            color: "white"
            font.pixelSize: CS.fontSize.f3
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // minutes
    Rectangle {
        id: min_view

        property real min_beginX
        property real min_beginY
        property int min_direction
        property bool pressState: false

        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        width: 80 * mScale
        height: parent.height
        color: "#dd000000"
        radius: 20 * appwindow.officalScale
        
        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 10
            width: parent.width
            height: 22 * mScale
            color: "transparent"

            Image {
                sourceSize.width: 20 * mScale
                sourceSize.height: 12 * mScale
                anchors.centerIn: parent
                source: "qrc:/image/time_wheel_up.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("hour : ", hour_wheel.value)
                    if (minute_wheel.value === 0) {
                        minute_wheel.value = 59
                    } else {
                        minute_wheel.value -= 1
                    }

                    minutesNumber = minute_wheel.value
                    minChanged(minutesNumber)
                }
            }
        }

        WheelView {
            id: minute_wheel
            anchors.centerIn: parent
            width: 40 * mScale
            height: 40 * mScale
            value: 0
            pathItemCount: 1
            displayFontSize: 36 * mScale
            model: {
                var list = []
                for (var i = 0; i < 60; i++)
                    list.push({
                                  "display": (i / 10 < 1 ? "0" + i : "" + i),
                                  "value": i
                              })
                return list
            }
            onViewMove: {
                minutesNumber = index
            }
            onValueChanged: {
                minChanged(minutesNumber)
            }
        }

        Rectangle {

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * mScale
            width: parent.width
            height: 22 * mScale
            color: "transparent"

            Image {
                sourceSize.width: 20 * mScale
                sourceSize.height: 12 * mScale
                anchors.centerIn: parent
                source: "qrc:/image/time_wheel_down.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("min +")
                    if (minute_wheel.value === 59) {
                        minute_wheel.value = 0
                    } else {
                        minute_wheel.value += 1
                    }
                    minutesNumber = minute_wheel.value
                    minChanged(minutesNumber)
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true

            onWheel: {
                if (wheel.angleDelta.y >= 120) {
                    if (minute_wheel.value === 0) {
                        minute_wheel.value = 59
                    } else {
                        minute_wheel.value -= 1
                    }
                } else if (wheel.angleDelta.y <=  -120) {
                    if (minute_wheel.value === 59) {
                        minute_wheel.value = 0
                    } else {
                        minute_wheel.value += 1
                    }
                }

                minutesNumber = minute_wheel.value
            }

            onPressed: {
                min_view.pressState = true
                min_view.min_beginY = mouseY
                min_view.min_beginX = mouseX
            }

            onPositionChanged: {
                var min_distance = 10
                if (mouseY - min_view.min_beginY > min_distance) {

                    if (minute_wheel.value === 0) {
                        minute_wheel.value = 59
                    } else {
                        minute_wheel.value -= 1
                    }
                } else if (mouseY - min_view.min_beginY < -min_distance) {

                    if (minute_wheel.value === 59) {
                        minute_wheel.value = 0
                    } else {
                        minute_wheel.value += 1
                    }
                }
                minutesNumber = minute_wheel.value
                min_view.min_beginX = mouseX
                min_view.min_beginY = mouseY
            }

            onReleased: {
                min_view.pressState = false
                min_view.min_beginX = -1
                min_view.min_beginY = -1
            }

            onClicked: {
                mouse.accepted = false
            }
        }
    }
}
