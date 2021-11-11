/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Bob <pengbo·wu@jingos.com>
 *
 */

import QtQuick 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.12
import org.kde.kirigami 2.15
import jingos.display 1.0
// import "StringUtils.js" as StringUtils
Item {
    id: root

    property bool is12HoursType: utilModel.is24HourFormat()

    implicitHeight: parent.height
    implicitWidth: parent.width

    Component.onCompleted: {
        getAmPm()
    }

    onVisibleChanged: {
        is12HoursType = utilModel.is24HourFormat()
    }

    function getHoursValue(hours) {
        if (!is12HoursType) {
            if (hours == 0) {
                return 12
            } else if (hours <= 12 && hours > 0) {
                return hours < 10 ? "0" + hours : hours
            } else {
                return hours - 12
            }
        } else {
            return hours < 10 ? "0" + hours : hours
        }
    }

    function getAmPm(){
        var dateValue = new Date()
        var hours = dateValue.getHours()

        if (hours > 12) {
            return true
        } else {
            return false
        }
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 0

        Text {
            font.pixelSize: JDisplay.dp(90)
            font.family: "Gilroy Thin"
            font.weight: Font.Light
            text: getHoursValue(kclockFormat.hours)
            color: JTheme.majorForeground
            Layout.alignment: Qt.AlignCenter
        }

        Text {
            font.pixelSize: JDisplay.dp(90)
            text: ":"
            font.family: "Gilroy Thin"
            color: JTheme.majorForeground
            font.weight: Font.Light
            Layout.alignment: Qt.AlignCenter
        }

        Text {
            id: txtMinutes

            font.weight: Font.Light
            font.pixelSize: JDisplay.dp(90)
            font.family: "Gilroy Thin"
            text: kclockFormat.minutes < 10 ? "0" + kclockFormat.minutes : kclockFormat.minutes
            color: JTheme.majorForeground
            Layout.alignment: Qt.AlignCenter
        }

        Text {
            id: amTxt

	        height: JDisplay.dp(22)
	        Layout.alignment: Qt.AlignTop
            Layout.topMargin: amTxt.height / 2

            font.pixelSize: JDisplay.sp(22)
            text: getAmPm() ?  i18n("PM") : i18n("AM")
            color: JTheme.majorForeground
            visible: !is12HoursType
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                is12HoursType = !is12HoursType
            }
        }
    }
}
