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
import QtQuick 2.7
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.3 as Kirigami
import QtQuick.Controls.Styles 1.4
import "../CommonSize.js" as CS

Popup {
    id:root

    property string uid
    property var description: ""
    property int px: 0
    property int py: 0
    property int popWidth: 400 * appwindow.officalScale
    property int popHeight: 120 * appwindow.officalScale
    property int selectIndex

    x: px
    y: py
    width: popWidth
    height: popHeight

    modal: true
    focus: true

    background: Rectangle {
        id: background
        color: "transparent"
    }

    contentItem: Rectangle {
        id: contentItem
        width: parent.width
        height: parent.height
        radius: 40 * appwindow.officalScale
        color: "#a2000000"

        anchors.left: parent.left
        anchors.right: parent.right

        Label {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 40 * appwindow.officalScale
            text: i18n("Delete")
            color: "white"
            font.pixelSize: 28 * appwindow.officalScale
        }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
             anchors.rightMargin: 40 * appwindow.officalScale

            width: 32 * appwindow.officalScale
            height: 32 * appwindow.officalScale
            source: "qrc:/image/delete.png"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                alarmModel.remove(selectIndex)
                alarmModel.updateUi()
                root.close()
            }
        }
    }
}
