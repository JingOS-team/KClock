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
import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    property int mouseX
    property int mouseY
    property var sourceView
    property string coverColor: "#aa000000"
    property real coverRadius: 40 * appwindow.officalScale

    ShaderEffectSource {
        id: eff
        anchors.centerIn: fastBlur
        width: fastBlur.width
        visible: false
        height: fastBlur.height
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
