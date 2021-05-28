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

    // property real mScale: appwindow.officalScale * 1.3
    property alias text: content_txt.text

    width:  80
    height: width

    Rectangle {

        id:_rect
        anchors.fill: parent
        color: "transparent"
        radius: 10 

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
            height: 50  
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
                        color: appwindow.isDarkTheme ? "#ff000000" :"#ffffffff"
                    }
                    GradientStop {
                        position: 0.3
                        color: appwindow.isDarkTheme ? "#cf000000" :"#cfffffff"
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
            height: 50  
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
                        color: appwindow.isDarkTheme ? "#ff000000" :"#ffffffff"
                    }
                    GradientStop {
                        position: 1.0
                        color: appwindow.isDarkTheme ? "#ff000000" :"#ffffffff"
                    }
                }
            }
        }

        Text {
            id:content_txt
            text: i18n("Hours")
            color: appwindow.isDarkTheme ? "#6affffff": "#ff000000"
            font.pixelSize: 11  
            anchors {
                bottom: parent.bottom
                bottomMargin: 7
                horizontalCenter: parent.horizontalCenter
            }
        }

    }
}
