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
import QtQuick 2.12
import QtQuick.Controls 2.12

Menu {
    id: menu

    property real mScale: appwindow.officalScale * 1.3
    property int mwidth: 308 
    property int mheight: 45 
    property var separatorColor: "#80FFFFFF"
    property int separatorWidth: mwidth * 9 / 10
    property int selectIndex
    property int blurX
    property int blurY

    signal deleteClicked

    Action {
        text: i18n("Delete")
        checkable: true
        checked: false
        onCheckedChanged: {
            deleteClicked()
        }
    }

    delegate: MenuItem {
        id: menuItem
        width: mwidth
        height: mheight

        indicator: Item {
            width: 0
            height: 0
        }

        contentItem: Item {
            id: munuContentItem
            width: mwidth
            height: mheight
            Text {
                anchors {
                    left: parent.left
                }
                leftPadding: 20
                text: menuItem.text
                font.pixelSize: 17
                anchors.verticalCenter: parent.verticalCenter
                color: menuItem.highlighted ? "#ffffff" : "#ffffff"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            Image {
                id: rightImage
                sourceSize.width: 16
                sourceSize.height: 16
                anchors {
                    right: parent.right
                    rightMargin: 20
                }
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/image/menu_delete.png"
            }
        }

        background: Rectangle {
            id: menu_bg
            implicitWidth: mwidth
            height: mheight
            color: "transparent"
        }
    }

    background: Rectangle {
        width: mwidth
        color: "#80000000"
        radius: 10
        VagueBackground {
            anchors.fill: parent
            sourceView: root
            mouseX: blurX
            mouseY: blurY
            coverRadius: 10
        }
    }
}
