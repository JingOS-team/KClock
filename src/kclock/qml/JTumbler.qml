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
import org.kde.kirigami 2.11 as Kirigami

Item {
    id: root

    property int default_visible: 3
    property real widget_w
    property real widget_h
    property int visibleItemCountValue: default_visible
    property int modelValue: 3
    property real textSize: 24
    property string textColor: "white"
    property real btn_w
    property real btn_h
    property alias currentIndex: tumbler.currentIndex
    property real myScale: appwindow.officalScale * 1.3

    width: widget_w
    height: widget_h

    Rectangle {
        anchors.fill: parent
        color: "transparent"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: tumbler_up
            width: parent.width
            height: btn_h
            color: "transparent"

            Image {
                source: "qrc:/image/big_up.png"
                width: 30 * myScale * 2
                height: 24 * myScale * 2
                anchors.centerIn:parent

            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("remove")
                    if(tumbler.currentIndex == 0){
                        tumbler.currentIndex = tumbler.model -1
                    }else {
                        tumbler.currentIndex -= 1
                    }
                }
            }
        }

        Tumbler {
            id: tumbler
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.fillHeight: true
            model: modelValue
            visibleItemCount: visibleItemCountValue
            wheelEnabled: true

            MouseArea {
                anchors.fill: parent
                onWheel: {
                        if(wheel.angleDelta.y > 0 ){
                            tumbler.currentIndex --
                        }else {
                            tumbler.currentIndex ++
                        }
                }
            }

            delegate: Label {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: 1.0 - (Math.abs(
                             Tumbler.displacement)+0.2 )/ (Tumbler.tumbler.visibleItemCount / 2)
                color: textColor
                text: modelData < 10 ? "0" + modelData : modelData
                font.pixelSize: textSize
                function displacementItemOpacity(displacement, visibleItemCount) {
                    return 1.0 - Math.abs(displacement) / (visibleItemCount / 2)
                }
            }
        }

        Rectangle {
            id: tumbler_down
            width: parent.width
            height:btn_h
            color: "transparent"

            Image {
                anchors.centerIn:parent
                width: 30 * myScale * 2
                height: 24 * myScale * 2
                source: "qrc:/image/big_dow.png"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("add")
                    if(tumbler.currentIndex === tumbler.model-1){
                        tumbler.currentIndex = 0
                    }else {
                        tumbler.currentIndex += 1
                    }
                }
            }
        }
    }
}
