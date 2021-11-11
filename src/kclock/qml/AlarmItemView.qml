/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *                         2021 Bob <pengbo·wu@jingos.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0
Component {
    id: alarmDelegate

    Item {
        id: root

        property bool is24HourFormat: timezoneProxy.isSystem24HourFormat

        width: alarmGridView.cellWidth
        height: alarmGridView.cellHeight

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
                duration: 75
                easing.type: Easing.InOutQuad
            }
            PropertyAction {
                target: root
                property: "GridView.delayRemove"
                value: false
            }
        }

        GridView.onAdd: SequentialAnimation {
            PropertyAction {
                target: root
                property: "GridView.delayRemove"
                value: false
            }
            NumberAnimation {
                target: root
                property: "scale"
                to: 1
                duration: 75
                easing.type: Easing.InOutQuad
            }
            PropertyAction {
                target: root
                property: "GridView.delayRemove"
                value: true
            }
        }

        Rectangle {
            id: content_Rectangle

            anchors {
                fill: parent
                rightMargin: JDisplay.dp(20)
                topMargin: JDisplay.dp(20)
            }

            color: Kirigami.JTheme.cardBackground
            radius: JDisplay.dp(20)

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: {
                    if (mouse.button == Qt.LeftButton) {
                        popupEventEditor.x = (rightLayout.width - popupEventEditor.width) / 2
                        popupEventEditor.y = (rightLayout.height - 277) / 2 + 22 + 26
                        popupEventEditor.popTitle = i18n("Edit Alarm")
                        popupEventEditor.alarmObject = model.alarm
                        popupEventEditor.open()
                    } else if (mouse.button == Qt.RightButton) {
                        var xy = mapToItem(root, mouseX, mouseY)
                        delMenu.popup(root, xy.x, xy.y)
                    }
                }

                onPressAndHold: {
                    var xy = mapToItem(content_Rectangle, mouseX, mouseY)
                    delMenu.popup(content_Rectangle, (content_Rectangle.width - delMenu.width) / 2, xy.y)
                }
            }

            Kirigami.JPopupMenu {
                id: delMenu

                width: JDisplay.dp(160)
                Action {
                    text: i18n("Delete")
                    icon.source:  "qrc:/image/menu_delete.png"
                    onTriggered: {
                        delDialog.open()
                    }
                }
            }

            Kirigami.JDialog {
                id: delDialog

                title: i18n("Delete")
                text: i18n("Are you sure you want to delete this alarm?")
                leftButtonText: i18n("Cancel")
                rightButtonText: i18n("Delete")
                parent: Overlay.overlay
                dim: false
                focus: true

                onRightButtonClicked: {
                    if (!GridView.delayRemove) {
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
                anchors.leftMargin: JDisplay.dp(20)
                anchors.rightMargin: JDisplay.dp(20)
                anchors.topMargin: JDisplay.dp(20)

                Text {
                    id: alarmTime

                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    font.weight: Font.Light
                    font.pixelSize: JDisplay.sp(30)
                    color: model.enabled ? Kirigami.JTheme.majorForeground : Kirigami.JTheme.disableForeground
                    text: is24HourFormat ? kclockFormat.formatTimeString(model.hours , model.minutes) : kclockFormat.formatTimeString(model.hours , model.minutes, true)
                }

                Label {
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.leftMargin: 0
                    visible: !is24HourFormat
                    text: model.hours < 12 ? i18n("AM") : i18n("PM")
                    font.pixelSize: JDisplay.sp(11)
                    color: model.enabled ? Kirigami.JTheme.majorForeground : Kirigami.JTheme.disableForeground
                }

                Kirigami.JSwitch {
                    id: alarmSwitch

                    anchors.right: parent.right
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.columnSpan: 1

                    checked: model.enabled
                    checkable: true
                    onCheckedChanged: {
                        alarmCheckedChange(checked)
                        model.enabled = checked
                    }
                }
            }

            Text {
                id: dayOfWeek

                anchors.top: topRow.bottom
                anchors.left: parent.left
                anchors.leftMargin: JDisplay.dp(20)
                anchors.rightMargin: JDisplay.dp(20)
                anchors.topMargin: JDisplay.dp(8)

                font.weight: Font.Normal
                font.pixelSize: JDisplay.sp(11)
                color:alarmSwitch.checked ? Kirigami.JTheme.majorForeground : Kirigami.JTheme.disableForeground
                text: getRepeatFormat(model.daysOfWeek) // related to UI improvements, leave it for now
            }

            Text {
                id: alarmName

                anchors.top: dayOfWeek.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: JDisplay.dp(20)
                anchors.rightMargin: JDisplay.dp(20)
                anchors.topMargin: JDisplay.dp(10)
                anchors.bottomMargin: JDisplay.dp(30)

                color: Kirigami.JTheme.minorForeground
                font.pixelSize: JDisplay.sp(11)
                text: model.name
                lineHeight: 1
                wrapMode: Text.WrapAnywhere
                maximumLineCount: 2
                elide: Text.ElideRight
            }
        }
    }
}

