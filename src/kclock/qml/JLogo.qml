/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Bob <pengbo·wu@jingos.com>
 *
 */
import QtQuick 2.12
import QtQuick.Controls 2.5
import org.kde.kirigami 2.15
import jingos.display 1.0

Item {
    width: parent.width /2
    height: JDisplay.dp(68)
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: JDisplay.dp(30)
    anchors.topMargin: JDisplay.dp(18)

    Label {
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: JDisplay.dp(25)

        text: i18n("Clock")
        font.pixelSize: JDisplay.sp(25)
        color: JTheme.majorForeground
    }
}
