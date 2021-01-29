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
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.12 as Kirigami
import kclock 1.0

Kirigami.Page {
    id: root

    property bool createdTimer: false
    // timer state :
    // 0 reset ;
    // 1.running;
    property int timerState: 0
    property Timer timer: timer
    property bool justCreated: timer == null ? false : timer.justCreated
    property bool showFullscreen: false
    property int elapsed: timer == null ? 0 : timer.elapsed
    property int duration: timer == null ? 0 : timer.length
    property bool running: timer == null ? 0 : timer.running
    property Timer timerDelegate: timerModel.get(0)

    globalToolBarStyle: Kirigami.ApplicationHeaderStyle.None
    Layout.fillWidth: true
    spacing: 0
    padding:0

    mainAction: Kirigami.Action {
        iconName: "list-add"
        text: i18n("New Timer")
        onTriggered: {
            createdTimer = true
            timerModel.addNew()
        }
    }


    background: Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Rectangle {
        anchors.left: root.left
        anchors.top: parent.top
        anchors.margins: 0
        width: root.width / 2 - 18
        height: root.height
        color: "red"
        id: digitalContentLayout

        TimerComponent {
            visible: !justCreated
            timerDuration: duration
            timerElapsed: elapsed
            timerRunning: running
        }
    }

    Rectangle {
        anchors.left: digitalContentLayout.right
        anchors.top: parent.top
        width: root.width / 2 - 18
        height: root.height
        color: "green"
        id: timerContentLayout

        Kirigami.FormLayout {
            id: form
            anchors.centerIn: parent
            implicitWidth: row.width
            implicitHeight: row.height
            property int fontSize: 60
            visible: true

            Rectangle {
                anchors.fill: parent
                color: "orange"

                Row {
                    id: row
                    width: 595
                    height: 380
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 67

                    Tumbler {
                        id: hoursTumber
                        width: 101
                        height: parent.height
                        model: 100
                        visibleItemCount: 3

                        delegate: Label {
                            opacity: 1.0 - Math.abs(Tumbler.displacement)
                                     / (Tumbler.tumbler.visibleItemCount / 2)
                            text: modelData < 10 ? "0" + modelData : modelData
                            color: "white"
                            font.pointSize: form.fontSize

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            function displacementItemOpacity(displacement, visibleItemCount) {
                                return 1.0 - Math.abs(
                                            displacement) / (visibleItemCount / 2)
                            }
                        }
                    }
                    Label {
                        width: 15
                        height: 90
                        anchors.verticalCenter: row.verticalCenter
                        Layout.alignment: Qt.AlignVCenter
                        color: "white"
                        text: ":"
                        font.pointSize: form.fontSize
                    }

                    Tumbler {
                        id: minutesTumber
                        width: 101
                        height: parent.height
                        model: 60
                        visibleItemCount: 3

                        delegate: Label {
                            opacity: 1.0 - Math.abs(Tumbler.displacement)
                                     / (Tumbler.tumbler.visibleItemCount / 2)
                            color: "white"
                            text: modelData < 10 ? "0" + modelData : modelData
                            font.pointSize: form.fontSize

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            function displacementItemOpacity(displacement, visibleItemCount) {
                                return 1.0 - Math.abs(
                                            displacement) / (visibleItemCount / 2)
                            }
                        }
                    }
                    Label {
                        width: 15
                        height: 90
                        anchors.verticalCenter: parent.verticalCenter
                        Layout.alignment: Qt.AlignVCenter
                        color: "white"
                        text: ":"
                        font.pointSize: form.fontSize
                    }
                    Tumbler {
                        id: secondsTumber
                        width: 101
                        height: parent.height
                        model: 60
                        visibleItemCount: 3

                        delegate: Label {
                            opacity: 1.0 - Math.abs(Tumbler.displacement)
                                     / (Tumbler.tumbler.visibleItemCount / 2)
                            color: "white"
                            text: modelData < 10 ? "0" + modelData : modelData
                            font.pointSize: form.fontSize

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            function displacementItemOpacity(displacement, visibleItemCount) {
                                return 1.0 - Math.abs(
                                            displacement) / (visibleItemCount / 2)
                            }
                        }
                    }
                }

                Rectangle {
                    width: row.width
                    height: 2
                    color: "#aaffffff"
                    anchors.left: row.left
                    anchors.right: row.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -60
                }

                Rectangle {
                    width: row.width
                    height: 2
                    color: "#aaffffff"
                    anchors.left: row.left
                    anchors.right: row.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 60
                }
            }

            function setDuration() {
                timer.length = spinBoxHours.value * 60 * 60
                        + spinBoxMinutes.value * 60 + spinBoxSeconds.value
            }

            Item {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: "Label (optional)"
            }


        }


        RowLayout {
            anchors.left: form.left
            anchors.right: form.right
            anchors.top: form.bottom
            height: 94
            width: form.width

            Kirigami.Heading {
                level: 4
                Layout.alignment: Qt.AlignLeft
                text: timerDelegate.label
            }

            Row {
                anchors.fill: parent

                ToolButton {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    icon.name: "chronometer-reset"
                    onClicked: {
                        hoursTumber.currentIndex = 0
                        minutesTumber.currentIndex = 0
                        secondsTumber.currentIndex = 0
                    }
                }
                ToolButton {
                    anchors.horizontalCenter : parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    icon.name: timerDelegate.running ? "chronometer-pause" : "chronometer-start"
                    onClicked: {
                        console.log(hoursTumber.currentIndex)
                        timerModel.addNew()
                    }
                }

                ToolButton {
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    icon.name: "delete"
                    onClicked: timerModel.remove(index)
                }
            }
        }
    }
}
