/*
 *   SPDX-FileCopyrightText: 2019 Dimitris Kardarakos <dimkard@posteo.net>
 *                           2021 Bob <pengbo·wu@jingos.com>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.5 as Controls2
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0
import QtQuick.Layouts 1.11

Controls2.ToolButton {
    id: hoursButton

    property int selectedValue
    property string type

    checkable: true
    checked: index == selectedValue
    autoExclusive: true
    text: index == selectedValue ? ( (type == "hours" && index == 0) ? 12 : index )
                                 : ( (type == "hours") ? ( index == 0 ? 12 : ( (index % 3 == 0) ? index : ".") ) : (index % 15 == 0) ? index : ".")

    contentItem: Controls2.Label {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: hoursButton.text
        font.pixelSize:JDisplay.sp(14)
        color: index <= parent.selectedValue ? "white" : "black"
    }

    background: Rectangle {
        implicitHeight: JDisplay.dp(20)
        implicitWidth: height

        radius: width * 0.5
        border.width: JDisplay.dp(2)
        border.color: "black"
        color: parent.checked ? "green" : "transparent"
    }
}

