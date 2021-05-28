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
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.12 as Kirigami

Rectangle {
    id: root

    property bool status: true
    property string statusPress: appwindow.isDarkTheme ? "#ffffff" :"#000000"
    property string statusRelease: "#5e5e5e"
    property alias btn_content: btn_content_widget.text
    property alias btn_icon: btn_icon_widget.source
    property int btn_width: 160  
    property int btn_height: 160  
    property double iconSize: 22  
    property double shrinkIconSize: 16 
    property double fontSize: 17
    property double shrinkFontSize: 12

    signal jbtnClick
    width: btn_width
    height: btn_height

    color: appwindow.isDarkTheme ? "#5e000000" : "white"
    radius: 10

    Rectangle {
        id: cover_bg
        anchors.fill: parent
        color: "transparent"
        radius: 10
    }

    Behavior on color {
        ColorAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        onEntered: {
            cover_bg.color = "#0c767680"
        }

        onExited: {
            cover_bg.color = "transparent"
        }

        onClicked: {
            jbtnClick()
        }

        onPressed: {
            cover_bg.color = "#10787880"
            widthAnim.to = root.shrinkIconSize
            heightAnim.to = root.shrinkIconSize
            fontAnim.to = root.shrinkFontSize
            widthAnim.restart()
            heightAnim.restart()
            fontAnim.restart()
        }
        onReleased: {
            cover_bg.color = "transparent"
            if (!widthAnim.running) {
                widthAnim.to = root.iconSize
                widthAnim.restart()
            }
            if (!heightAnim.running) {
                heightAnim.to = root.iconSize
                heightAnim.restart()
            }
            if (!fontAnim.running) {
                fontAnim.to = root.fontSize
                fontAnim.restart()
            }
        }
    }

    ColumnLayout {
        id: itemColumn
        anchors.centerIn: parent
        spacing: 0

        Kirigami.Icon {
            id: btn_icon_widget
            color: status ? statusPress : statusRelease
            source: ""
            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: iconSize
            Layout.preferredWidth: iconSize

            ColorAnimation on color {
                easing.type: Easing.Linear
            }
            NumberAnimation on Layout.preferredWidth {
                id: widthAnim
                easing.type: Easing.Linear
                duration: 130
                onFinished: {
                    if (widthAnim.to !== root.iconSize && !mouseArea.pressed) {
                        widthAnim.to = root.iconSize
                        widthAnim.start()
                    }
                }
            }
            NumberAnimation on Layout.preferredHeight {
                id: heightAnim
                easing.type: Easing.Linear
                duration: 130
                onFinished: {
                    if (heightAnim.to !== root.iconSize && !mouseArea.pressed) {
                        heightAnim.to = root.iconSize
                        heightAnim.start()
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 4  
            color: "transparent"
        }

        Label {
            id: btn_content_widget
            color: status ? statusPress : statusRelease
            text: ""
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Text.AlignVCenter
            elide: Text.ElideLeft
            font.pixelSize: root.fontSize

            ColorAnimation on color {
                easing.type: Easing.Linear
            }
            NumberAnimation on font.pixelSize {
                id: fontAnim
                easing.type: Easing.Linear
                duration: 130
                onFinished: {
                    if (fontAnim.to !== root.fontSize && !mouseArea.pressed) {
                        fontAnim.to = root.fontSize
                        fontAnim.start()
                    }
                }
            }
        }
    }
}
