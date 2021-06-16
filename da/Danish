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
    property int widget_width: 305 
    property int widget_height: 130 

    signal minChanged(var minValue)
    signal hourChanged(var hourValue)

    width: widget_width
    height: widget_height

    spacing: 10 * appwindow.officalScale

    // hours
    Rectangle {
        id: hour_view
        width: 40 
        height: parent.height
        color: appwindow.isDarkTheme ? "#dd000000" : "#FFE4E4E6"
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        radius: 10
        property real hour_beginX
        property real hour_beginY
        property int hour_direction
        property bool pressState1: false

        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 5
            width: parent.width
            height: 11
            color: "transparent"

            Image {
                sourceSize.width: 10
                sourceSize.height: 6
                anchors.centerIn: parent
                source: "qrc:/image/time_wheel_up.png"
            }

            MouseArea {
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    // console.log("hour : ", hour_wheel.value)
                    // if (hour_wheel.value === 0) {
                    //     hour_wheel.value = 23
                    // } else {
                    //     hour_wheel.value -= 1
                    // }
                    // hourNumber = hour_wheel.value
                    // hourChanged(hourNumber)

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

        Rectangle {
            anchors.fill: hour_wheel
            color:"transparent"
            MouseArea {
                anchors.fill:parent 
                onClicked:{
                    console.log("--------hour click-------");
                }
            }
        }

        WheelView {
            id: hour_wheel
            anchors.centerIn: parent
            width: 26
            height: 20 

            model: {
                var list = []
                for (var i = 0; i < 24; i++)
                    list.push({
                                  "display": (i / 10 < 1 ? "0" + i : "" + i),
                                  "value": i
                              })
                return list
            }

            value: 0
            pathItemCount: 1
            displayFontSize: 20
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
            anchors.bottomMargin: 5 
            width: parent.width
            height: 11 
            color: "transparent"

            Image {
                sourceSize.width: 10
                sourceSize.height: 6 
                anchors.centerIn: parent
                source: "qrc:/image/time_wheel_down.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // if (hour_wheel.value === 23) {
                    //     hour_wheel.value = 0
                    // } else {
                    //     hour_wheel.value += 1
                    // }
                    // hourNumber = hour_wheel.value
                    // hourChanged(hourNumber)
                    // mouse.accepted = true

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
        width: timeRow.width / 30
        height: timeRow.width / 20* 5
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        color: "transparent"
        Controls2.Label {
            anchors.centerIn: parent
            text: ":"
            color: appwindow.isDarkTheme ? "white" :"black"
            font.pixelSize: CS.fontSize.f3
            // font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // minutes
    Rectangle {
        width: 40 
        height: parent.height
        color: appwindow.isDarkTheme ? "#dd000000" : "#FFE4E4E6"
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        radius: 10
        id: min_view

        property real min_beginX
        property real min_beginY
        property int min_direction
        property bool pressState: false

        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 5
            width: parent.width
            height: 11
            color: "transparent"

            Image {
                sourceSize.width: 10
                sourceSize.height: 6 
                anchors.centerIn: parent
                source: "qrc:/image/time_wheel_up.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // console.log("hour : ", hour_wheel.value)
                    // if (minute_wheel.value === 0) {
                    //     minute_wheel.value = 59
                    // } else {
                    //     minute_wheel.value -= 1
                    // }

                    // minutesNumber = minute_wheel.value
                    // minChanged(minutesNumber)

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

        Rectangle {
            anchors.fill: minute_wheel
             color:"transparent"
            MouseArea {
                anchors.fill:parent 
                onClicked:{
                    console.log("--------minitue click-------");
                }
            }
        }

        WheelView {
            id: minute_wheel
            anchors.centerIn: parent
            width: 26
            height: 20 
            model: {
                var list = []
                for (var i = 0; i < 60; i++)
                    list.push({
                                  "display": (i / 10 < 1 ? "0" + i : "" + i),
                                  "value": i
                              })
                return list
            }
            value: 0
            pathItemCount: 1
            displayFontSize: 20
            onViewMove: {
                minutesNumber = index
            }
            onValueChanged: {
                console.log("min changed -> ", minutesNumber)
                minChanged(minutesNumber)
            }
        }

        Rectangle {

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            width: parent.width
            height: 11
            color: "transparent"

            Image {
                sourceSize.width: 10
                sourceSize.height: 6 
                anchors.centerIn: parent
                source: "qrc:/image/time_wheel_down.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // console.log("min +")
                    // if (minute_wheel.value === 59) {
                    //     minute_wheel.value = 0
                    // } else {
                    //     minute_wheel.value += 1
                    // }
                    // minutesNumber = minute_wheel.value
                    // minChanged(minutesNumber)

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
