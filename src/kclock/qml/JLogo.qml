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
import QtQuick.Controls 2.5
import org.kde.kirigami 2.0 as Kirigami
import QtQuick.Layouts 1.11

Rectangle {
    
    width: parent.width /2
    height: 48 * appwindow.officalScale
    color: "transparent"
    
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: 50 * appwindow.officalScale
    anchors.topMargin: 50 * appwindow.officalScale

    Image {
        id: tagImage
        source: "qrc:/image/clock_logo.png"
        width: 48
        height: 48
        anchors.verticalCenter: parent.verticalCenter
    }
    Label {
        text: "Clock"
        font.pixelSize: 50* appwindow.officalScale
        color: "white"
        anchors.left: tagImage.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 20 * appwindow.officalScale
        Layout.alignment: Qt.AlignVCenter
    }


}
