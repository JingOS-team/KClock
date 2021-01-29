/*
 * Copyright 2021 Wang Rui <wangrui@jingos.com>
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
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import org.kde.kirigami 2.15 as Kirigami

Component {
    id: alarmDelegate

    Rectangle {
        id: root
        width: alarmGridView.cellWidth
        height: alarmGridView.cellHeight
        color: "transparent"

        property int topSize: appwindow.fontSize + 26
        property int otherSize: appwindow.fontSize - 3
        property real myScale: 1.3 * appwindow.officalScale

        GridView.onRemove: SequentialAnimation {
            PropertyAction {
                target: root
                property: "GridView.delayRemove"
                value: true
            }
            NumberAnimation {
                target: root
                property: "scale"
                to: 0
                duration: 200
                easing.type: Easing.InOutQuad
            }
            PropertyAction {
                target: root
                property: "GridView.delayRemove"
                value: false
            }
        }

        Rectangle {
            id: content_Rectangle

            anchors {
                fill: parent
                leftMargin: 0
                rightMargin: 30 * myScale
                topMargin: 30 * myScale
                bottomMargin: 2 * myScale
            }

            color: "#3f000000"
            radius: 40 * appwindow.officalScale

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: {
                    if (mouse.button == Qt.LeftButton) {
                        popupEventEditor.px = (rightLayout.width - popupEventEditor.width) / 2
                        popupEventEditor.py = (rightLayout.height - 624
                                               * appwindow.officalScale) / 2 + 160
                        popupEventEditor.popTitle = "Edit Alarm"

                        var kk = rightLayout.mapToItem(
                                    rightLayout,
                                    popupEventEditor.px + alarmLayout.width,
                                    popupEventEditor.py)
                        popupEventEditor.blurX = kk.x
                        popupEventEditor.blurY = kk.y
                        popupEventEditor.alarmObject = model.alarm
                        popupEventEditor.open()
                    } else if (mouse.button == Qt.RightButton) {
                        delMenu.selectIndex = index
                        var xy = mapToItem(root, mouseX, mouseY)
                        delMenu.blurX = xy.x
                        delMenu.blurY = xy.y
                        delMenu.popup(root, xy.x, xy.y)
                    }
                }

                onPressAndHold: {
                    delMenu.selectIndex = index
                    var xy = mapToItem(root, mouseX, mouseY)
                    delMenu.blurX = xy.x
                    delMenu.blurY = xy.y
                    delMenu.popup(root, xy.x, xy.y)
                }
            }

            DeleteMenu {
                id: delMenu
                onDeleteClicked: {
                    var x = (officalWidth - delDialog.width) / 2
                    var y = (officalHeight - delDialog.height) / 2
                    console.log("x : " + x + "&&&   y:" + y)
                    delDialog.parent = alarm_layout
                    delDialog.startX = x
                    delDialog.startY = y
                    delDialog.x = x
                    delDialog.y = y
                    delDialog.visible = true
                    delDialog.open()
                }
            }

            Kirigami.JDialog {
                id: delDialog
                title: "Delete"
                text: "Are you sure you want to delete this alarm?"
                leftButtonText: "Close"
                rightButtonText: "Delete"
                parent: Overlay.overlay
                dim: false
                focus: true

                onRightButtonClicked: {
                    if (!root.GridView.delayRemove) {
                        alarmModel.remove(index)
                        alarmModel.updateUi()
                        delMenu.close()
                    }
                }

                onLeftButtonClicked: {
                    delDialog.close()
                    delDialog.visible = false
                    delMenu.close()
                }
            }

            RowLayout {
                id: topRow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 31 * myScale
                anchors.rightMargin: 31 * myScale
                anchors.topMargin: 31 * myScale

                Label {
                    id: alarmTime
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    font.weight: Font.Light
                    font.pointSize: topSize
                    color: model.enabled ? "white" : "#919191"
                    text: kclockFormat.formatTimeString(model.hours,
                                                        model.minutes)
                }

                Switch {
                    anchors.right: parent.right
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.columnSpan: 1
                    checked: model.enabled
                    checkable: true
                    onCheckedChanged: {
                        alarmCheckedChange(checked)
                        alarmTime.color = checked ? "white" : "#919191"
                        dayOfWeek.color = checked ? "white" : "#919191"
                    }
                }
            }

            Label {
                id: dayOfWeek

                anchors.top: topRow.bottom
                anchors.left: parent.left
                anchors.leftMargin: 31 * myScale
                anchors.rightMargin: 31 * myScale
                anchors.topMargin: 8 * myScale
                font.weight: Font.Normal
                font.pointSize: otherSize
                color: model.enabled ? "white" : "#919191"
                text: getRepeatFormat(
                          model.daysOfWeek) // related to UI improvements, leave it for now
            }

            Text {
                id: alarmName

                anchors.top: dayOfWeek.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 31 * myScale
                anchors.rightMargin: 31 * myScale
                anchors.topMargin: 10 * myScale
                anchors.bottomMargin: 30 * myScale
                
                color: "#919191"
                font.pointSize: otherSize
                lineHeight: 1
                wrapMode: Text.WrapAnywhere
                maximumLineCount: 2
                elide: Text.ElideRight
                text: model.name
            }
        }
    }
}

