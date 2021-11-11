/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Bob <pengbo·wu@jingos.com>
 *
 */
import QtQuick 2.11
import QtQuick.Controls 2.4

Item {
    id: root

    property alias value: datePicker.value
    property alias min: datePicker.min
    property alias max: datePicker.max
    property string dateFormat: "dd.MM.yyyy"

    signal valueUpdated(var value)

    implicitWidth: 90
    implicitHeight: inputField.implicitHeight

    TextField {
        id: inputField
        implicitWidth: root.implicitWidth
        readOnly: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: datePicker.value.toLocaleString(Qt.locale(), root.dateFormat)
        onPressed: datePicker.open()
    }

    TimerPicker {
        id: datePicker
        onValueUpdated: {
            root.valueUpdated(value)
        }
    }
}
