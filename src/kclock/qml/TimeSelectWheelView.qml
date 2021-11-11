/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Bob <pengbo·wu@jingos.com>
 *
 */

import QtQuick 2.14
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0 as Controls2
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0
// import "../CommonSize.js" as CS

RowLayout {
    id: timeRow

    property alias hourNumber: hour_wheel.value
    property alias minutesNumber: minute_wheel.value
    property bool is24HourFormat: timezoneProxy.isSystem24HourFormat
    property int hourFormatNumber: is24HourFormat ? 24 : 12

    signal minChanged(var minValue)
    signal hourChanged(var hourValue)

    width:  JDisplay.dp(305)
    height: JDisplay.dp(130)

    spacing: JDisplay.dp(10)
    /*
    *
    * type=true: minutes part
    * type=false: hours part
    *
    */
    function wheel(type, wY, value) {
        var isReduce
        var contentY
        if (type) {
            isReduce = minutes.isReduce
            contentY = minutes.contentY
        } else {
            isReduce = hours.isReduce
            contentY = hours.contentY
        }

        if (wY == 120) {
            value = value - 1
            if (type) {
                if (value < 0) {
                    value = 59
                }
            } else {
                if (value < 0) {
                    value = (hourFormatNumber - 1)
                }
            }

            return value
        } else if (wY == -120) {
            value = value + 1
            if (type) {
                if (value > 59) {
                    value = 0
                }
            } else {
                if (value > (hourFormatNumber - 1)) {
                    value = 0
                }
            }

            return value
        }

        if (wY != 0 & Math.abs(contentY) < Math.abs(wY)) {
            contentY = wY
        } else if (wY != 0 & Math.abs(contentY) > Math.abs(wY)) {
            isReduce = true
        }
        if (isReduce & wY == 0) {
            if (contentY != 0) {
                var count = parseInt(contentY / 250)
                if (Math.abs(contentY) < 300) {
                    if (contentY > 0) {
                        count = 1
                    } else {
                        count = -1
                    }
                }
                isReduce = false
                contentY = 0

                if (type) {
                    if (count >= 1) {
                        value = value - count
                        if (value < 0) {
                            value = 59
                        }
                    } else if (count <= -1) {
                        value = value + Math.abs(count)
                        if (value > 59) {
                            value = 0
                        }
                    }
                } else {
                    if (count >= 1) {
                        value = value - count
                        if (value < 0) {
                            value = (hourFormatNumber - 1)
                        }
                    } else if (count <= -1) {
                        value = value + Math.abs(count)
                        if (value > (hourFormatNumber - 1)) {
                            value = 0
                        }
                    }
                }
            }
        }

        if (type) {
            minutes.isReduce = isReduce
            minutes.contentY = contentY
        } else {
            hours.isReduce = isReduce
            hours.contentY = contentY
        }

        return value
    }

    // hours
    Rectangle {
        id: hour_view

        width: JDisplay.dp(50)
        height: parent.height
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

        color: Kirigami.JTheme.componentBackground
        radius: JDisplay.dp(10)

        Item {
            id: hourTopBtn

            anchors.top: parent.top
            anchors.topMargin: JDisplay.dp(2)
            width: parent.width
            height: JDisplay.dp(14)

            Kirigami.Icon {
                width: JDisplay.dp(10)
                height: JDisplay.dp(6)
                anchors.centerIn: parent

                color:Kirigami.JTheme.iconForeground
                source: "qrc:/image/time_wheel_up.png"
            }

            MouseArea {
               anchors.fill: parent
                onClicked: {
                    if (is24HourFormat) {
                        if (hour_wheel.value === 23) {
                            hour_wheel.value = 0
                        } else {
                            hour_wheel.value += 1
                        }
                    } else {
                        if (hour_wheel.value === 12) {
                            hour_wheel.value = 1
                        } else {
                            hour_wheel.value += 1
                        }
                    }
                    hourNumber = hour_wheel.value
                    hourChanged(hourNumber)
                    mouse.accepted = true
                }
            }
        }

        WheelView {
            id: hour_wheel

            width: JDisplay.dp(26)
            anchors.top:hourTopBtn.bottom
            anchors.bottom: hourBottomBtn.top
            anchors.horizontalCenter: parent.horizontalCenter

            model: {
                var list = []
                for (var i = 0; i < hourFormatNumber; i++)
                    list.push({
                        "display": (!is24HourFormat && i === 0 ? 12 + "" : (i / 10 < 1 ? "0" + i : "" + i)),
                        "value": !is24HourFormat && i === 0 ? 12 : i
                    })
                return list
            }
            value: 0
            pathItemCount: 1
            displayFontSize: JDisplay.sp(20)
            onViewMove: {
                hourNumber = index
            }
            onValueChanged: {
                hourChanged(hourNumber)
            }
        }

        Item {
            id: hourBottomBtn

            anchors.bottom: parent.bottom
            anchors.bottomMargin: JDisplay.dp(2)
            width: parent.width
            height: JDisplay.dp(14)

            Kirigami.Icon {
                width: JDisplay.dp(10)
                height: JDisplay.dp(6)
                anchors.centerIn: parent
                color:Kirigami.JTheme.iconForeground
                source: "qrc:/image/time_wheel_down.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (is24HourFormat) {
                        if (hour_wheel.value === 0) {
                            hour_wheel.value = 23
                        } else {
                            hour_wheel.value -= 1
                        }
                    } else {
                        if (hour_wheel.value === 1) {
                            hour_wheel.value = 12
                        } else {
                            hour_wheel.value -= 1
                        }
                    }

                    hourNumber = hour_wheel.value
                    hourChanged(hourNumber)
                }
            }
        }

        MouseArea {
            id: hours

            property var contentY: 0
            property var pressedY: 0
            property bool isReduce: false

            anchors.fill: parent

            propagateComposedEvents: true
            hoverEnabled: true

            onEntered: {
                preventStealing = true
            }

            onExited: {
                preventStealing = false
            }

            onPressed: {
                propagateComposedEvents = false
                pressedY = mouseY
                preventStealing = true
            }

            onReleased: {
                propagateComposedEvents = true
                preventStealing = false
                var moveY = mouseY - pressedY
                var count = parseInt(moveY / 40)
                if (Math.abs(contentY) < 40 & Math.abs(contentY) > 10) {
                    count = 1
                }
                if (count >= 1) {
                    hourNumber = hourNumber - count
                    if (hourNumber < 0) {
                        hourNumber = (hourFormatNumber - 1)
                    }
                } else if (count <= -1) {
                    hourNumber = hourNumber + Math.abs(count)
                    if (hourNumber > (hourFormatNumber - 1)) {
                        hourNumber = 0
                    }
                }
            }

            onWheel: {
                hourNumber = timeRow.wheel(false, wheel.angleDelta.y, hourNumber)
            }
        }
    }

    // :
    Item {
        width: timeRow.width / 30
        height: timeRow.width / 20 * 5
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Controls2.Label {
            anchors.centerIn: parent
            text: ":"
            color: Kirigami.JTheme.majorForeground
            font.pixelSize: JDisplay.dp(30)
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // minutes
    Rectangle {
        id: min_view

        width: JDisplay.dp(50)
        height: parent.height
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

        color: Kirigami.JTheme.componentBackground
        radius: JDisplay.dp(10)

        Item {
            id: minTopBtn

            anchors.top: parent.top
            anchors.topMargin: JDisplay.dp(2)
            width: parent.width
            height: JDisplay.dp(14)

            Kirigami.Icon {
                width: JDisplay.dp(10)
                height: JDisplay.dp(6)
                anchors.centerIn: parent

                color: Kirigami.JTheme.iconForeground
                source: "qrc:/image/time_wheel_up.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
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
        WheelView {
            id: minute_wheel

            anchors.top:minTopBtn.bottom
            anchors.bottom: minBottomBtn.top
            width: JDisplay.dp(26)
            anchors.horizontalCenter: parent.horizontalCenter

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
            displayFontSize: JDisplay.sp(20)
            onViewMove: {
                minutesNumber = index
            }
            onValueChanged: {
                minChanged(minutesNumber)
            }
        }

        Item {
            id: minBottomBtn

            anchors.bottom: parent.bottom
            anchors.bottomMargin: JDisplay.dp(2)
            width: parent.width
            height: JDisplay.dp(14)

            Kirigami.Icon {
                width: JDisplay.dp(10)
                height: JDisplay.dp(6)
                anchors.centerIn: parent

                color: Kirigami.JTheme.iconForeground
                source: "qrc:/image/time_wheel_down.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
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
            id: minutes

            property var contentY: 0
            property var pressedY: 0
            property bool isReduce: false

            anchors.fill: parent

            propagateComposedEvents: true
            hoverEnabled: true

            onEntered: {
                preventStealing = true
            }

            onExited: {
                preventStealing = false
            }

            onPressed: {
                propagateComposedEvents = false
                pressedY = mouseY
                preventStealing = true
            }

            onReleased: {
                propagateComposedEvents = true
                var moveY = mouseY - pressedY
                var count = parseInt(moveY / 40)
                if (Math.abs(contentY) < 40 & Math.abs(contentY) > 10) {
                    count = 1
                }
                if (count >= 1) {
                    minutesNumber = minutesNumber - count
                    if (minutesNumber < 0) {
                        minutesNumber = 59
                    }
                } else if (count <= -1) {
                    minutesNumber = minutesNumber + Math.abs(count)
                    if (minutesNumber > 59) {
                        minutesNumber = 0
                    }
                }
            }

            onWheel: {
                minutesNumber = timeRow.wheel(true, wheel.angleDelta.y, minutesNumber)
            }
        }
    }

    // time Period
    Rectangle {
        id: timePeriod

        width: JDisplay.dp(40)
        height: parent.height
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

        color: Kirigami.JTheme.componentBackground
        radius: JDisplay.dp(10)
        visible: is24HourFormat ? false : true

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

           Controls2.Label {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter

                text: i18n("AM")
                font.pixelSize:JDisplay.sp(11)
                horizontalAlignment: Text.AlignHCenter
                color: popup.timePeriod ? Kirigami.JTheme.minorForeground : Kirigami.JTheme.majorForeground
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        popup.timePeriod = false
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: JDisplay.dp(1)
                color: Kirigami.JTheme.dividerForeground
            }

            Controls2.Label {
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: true
                Layout.fillHeight: true

                text: i18n("PM")
                color: !popup.timePeriod ? Kirigami.JTheme.minorForeground : Kirigami.JTheme.majorForeground
                font.pixelSize:JDisplay.sp(11)
                horizontalAlignment: Text.AlignHCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        popup.timePeriod = true
                    }
                }
            }
        }
    }
}
