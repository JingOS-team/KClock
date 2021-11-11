/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Bob <pengbo·wu@jingos.com>
 *
 */
import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property int mouseX
    property int mouseY
    property var sourceView
    property string coverColor: "#aa000000"
    property real coverRadius: 40

    ShaderEffectSource {
        id: eff

        anchors.centerIn: fastBlur
        width: fastBlur.width
        height: fastBlur.height

        visible: false
        sourceItem: sourceView
        sourceRect: Qt.rect(mouseX, mouseY, width, height)

        function getItemX(width, height) {
            var mapItem = eff.mapToItem(sourceView, mouseX, mouseY,
                                        width, height)
            return mapItem.x
        }
        function getItemY(width, height) {
            var mapItem = eff.mapToItem(sourceView, mouseX, mouseY,
                                        width, height)
            return mapItem.y
        }
    }

    FastBlur {
        id: fastBlur
        anchors.fill: parent

        source: eff
        radius: 70
        cached: true
        visible: false
    }
    Rectangle {
        id: maskRect

        anchors.fill: fastBlur
        visible: false
        clip: true
        radius: coverRadius
    }
    OpacityMask {
        id: mask

        anchors.fill: maskRect
        visible: true
        source: fastBlur
        maskSource: maskRect
    }
    Rectangle {
        anchors.fill: parent
        color: coverColor
        radius: coverRadius
    }
}
