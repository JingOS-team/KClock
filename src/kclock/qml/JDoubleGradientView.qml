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
import QtGraphicalEffects 1.12

Item {

    property real mScale: appwindow.officalScale * 1.3
    property alias text: content_txt.text

    width:  160 * mScale
    height: width

    Rectangle {
        id:_rect
        anchors.fill: parent
        color: "transparent"
        radius: 40 * appwindow.officalScale

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: _rect.width
                height: _rect.height
                radius: _rect.radius
            }
        }

        Rectangle {
            width: parent.width
            height: 50 * appwindow.officalScale
            color: "transparent"

            anchors {
                top: parent.top
                left: parent.left
            }

            LinearGradient {
                ///--[Mark]
                anchors.fill: parent
                start: Qt.point(0, 0)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: "#ff000000"
                    }
                    GradientStop {
                        position: 0.3
                        color: "#cf000000"
                    }
                    GradientStop {
                        position: 1.0
                        color: "#00000000"
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 50 * appwindow.officalScale
            color: "transparent"
            clip: true

            anchors {
                bottom: parent.bottom
                left: parent.left
            }

            LinearGradient {
                ///--[Mark]
                anchors.fill: parent
                start: Qt.point(0, 0)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: "#00000000"
                    }
                    GradientStop {
                        position: 0.7
                        color: "#ff000000"
                    }
                    GradientStop {
                        position: 1.0
                        color: "#ff000000"
                    }
                }
            }
        }

        Text {
            id:content_txt
            text: "Hours"
            color: "#6affffff"
            font.pixelSize: 22 * appwindow.officalScale
            anchors {
                bottom: parent.bottom
                bottomMargin: 13 * appwindow.officalScale
                horizontalCenter: parent.horizontalCenter
            }
        }

    }
}
