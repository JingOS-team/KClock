/*
 *   SPDX-FileCopyrightText: 2019 Dimitris Kardarakos <dimkard@posteo.net>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.5 as Controls2
import org.kde.kirigami 2.0 as Kirigami
import QtQuick.Layouts 1.11

Item {
    id: root

    property int hours
    property int minutes
    property bool pm

    ColumnLayout {
        anchors.fill: parent
        Item {
            id: clock
            Layout.fillWidth: true
            Layout.fillHeight: true

            //Hours clock
            PathView {
                id: hoursClock

                anchors.fill: parent
                interactive: false
                model: 12
                delegate: JClockElement {
                    type: "hours"
                    selectedValue: root.hours
                    onClicked: root.hours = index
                }
                
                path: Path {
                    PathAngleArc {
                        centerX: clock.width / 2
                        centerY: clock.height / 2
                        radiusX: (Math.min(
                                      clock.width,
                                      clock.height) - Kirigami.Units.gridUnit) / 4
                        radiusY: radiusX
                        startAngle: -90
                        sweepAngle: 360
                    }
                }
            }

            //Minutes clock
            PathView {
                id: minutesClock

                anchors.fill: parent
                interactive: false
                model: 60

                delegate: JClockElement {
                    type: "minutes"
                    selectedValue: root.minutes
                    onClicked: root.minutes = index
                }

                path: Path {
                    PathAngleArc {
                        centerX: clock.width / 2
                        centerY: clock.height / 2
                        radiusX: (Math.min(
                                      clock.width,
                                      clock.height) - Kirigami.Units.gridUnit) / 2
                        radiusY: radiusX
                        startAngle: -90
                        sweepAngle: 360
                    }
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            Controls2.Label {
                text: ((root.hours < 10) ? "0" : "") + root.hours + ":"
                      + ((root.minutes < 10) ? "0" : "") + root.minutes
                color: "white"
                font.pointSize: 24
            }

            Rectangle {
                width: 60
                height: parent.height
            }

            Controls2.ToolButton {
                id: pm

                checked: root.pm
                checkable: true
                implicitWidth: 100
                implicitHeight: 42

                contentItem: Controls2.Label {
                    text: parent.checked ? "PM" : "AM"
                    font.pixelSize: 24
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: root.pm = checked
                background: Rectangle {
                    border.width: 2
                    border.color: "black"
                    color: "#4a4a4a"
                }
            }
        }
    }
}
