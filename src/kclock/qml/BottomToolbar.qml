/*
 * Copyright 2020 Han Young <hanyoung@protonmail.com>
 *           2020 Devin Lin <espidev@gmail.com>
 *           2021 Bob <pengbo·wu@jingos.com>
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
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0
ToolBar {
    id: toolbarRoot

    height: JDisplay.dp(55)
    property double iconSize: JDisplay.dp(22)
    property double shrinkIconSize: JDisplay.dp(20)
    property double fontSize: JDisplay.sp(14)
    property double shrinkFontSize:  JDisplay.sp(12)

    function getPage(name) {
        switch (name) {
            case "Time": return timePage;
            case "Timer": return timerListPage;
            case "Stopwatch": return stopwatchPage;
            case "Alarm": return alarmPage;
            case "Settings": return settingsPage;
        }
    }

    background: Rectangle {
        color: Kirigami.JTheme.cardBackground
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Repeater {
            model: ListModel {

                ListElement {
                    name: "Alarm"
                    icon_highlight:"qrc:/image/footer_alarm_grey_l.svg"
                    icon: "qrc:/image/footer_alarm_grey.svg"
                }
                ListElement {
                    name: "Stopwatch"
                    icon_highlight: "qrc:/image/footer_sw_grey_l.svg"
                    icon: "qrc:/image/footer_sw_grey.svg"
                }
                ListElement {
                    name: "Timer"
                    icon_highlight: "qrc:/image/footer_timer_grey_l.svg"
                    icon: "qrc:/image/footer_timer_grey.svg"
                }
            }

            Item {
                Layout.minimumWidth: parent.width / 3
                Layout.maximumWidth: parent.width / 3
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignCenter

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        appwindow.switchToPage(getPage(model.name), 0)
                    }
                }

                RowLayout {
                    id: itemColumn

                    anchors.centerIn: parent
                    spacing: JDisplay.dp(5)

                    Kirigami.Icon {
                        Layout.alignment: Qt.AlignCenter
                        Layout.preferredHeight: toolbarRoot.iconSize
                        Layout.preferredWidth: toolbarRoot.iconSize
                        color:getPage(model.name).opacity ===1 ?  Kirigami.JTheme.buttonStrongBackground : Kirigami.JTheme.majorForeground
                        source: model.icon

                        ColorAnimation on color {
                            easing.type: Easing.Linear
                        }
                        NumberAnimation on Layout.preferredWidth {
                            id: widthAnim

                            easing.type: Easing.Linear
                            duration: 130
                            onFinished: {
                                if (widthAnim.to !== toolbarRoot.iconSize && !mouseArea.pressed) {
                                    widthAnim.to = toolbarRoot.iconSize;
                                    widthAnim.start();
                                }
                            }
                        }
                        NumberAnimation on Layout.preferredHeight {
                            id: heightAnim

                            easing.type: Easing.Linear
                            duration: 130
                            onFinished: {
                                if (heightAnim.to !== toolbarRoot.iconSize && !mouseArea.pressed) {
                                    heightAnim.to = toolbarRoot.iconSize;
                                    heightAnim.start();
                                }
                            }
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignCenter
                        horizontalAlignment: Text.AlignVCenter
                        color: getPage(model.name).opacity ===1 ?  Kirigami.JTheme.buttonStrongBackground : Kirigami.JTheme.majorForeground
                        elide: Text.ElideLeft
                        font.pixelSize: toolbarRoot.fontSize
                        text: i18n(model.name)

                        ColorAnimation on color {
                            easing.type: Easing.Linear
                        }
                        NumberAnimation on font.pixelSize {
                            id: fontAnim

                            easing.type: Easing.Linear
                            duration: 130
                            onFinished: {
                                if (fontAnim.to !== toolbarRoot.fontSize && !mouseArea.pressed) {
                                    fontAnim.to = toolbarRoot.fontSize;
                                    fontAnim.start();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
