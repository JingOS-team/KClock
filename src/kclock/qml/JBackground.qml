/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Bob <pengbo·wu@jingos.com>
 *
 */
import QtQuick 2.0
import QtGraphicalEffects 1.12

Rectangle {
    id: root

    anchors.fill: parent
    color: appwindow.isDarkTheme ? "#00000000" : "#E8EFFF"
    Image {
        anchors.fill:parent

        visible:appwindow.isDarkTheme
        source: "qrc:/image/background.png"
    }
}
