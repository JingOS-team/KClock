/*
 * Copyright 2020 Han Young <hanyoung@protonmail.com>
 *           2020 Devin Lin <espidev@gmail.com>
 *           2021 Wang Rui  <wangrui@jingos.com>
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

ToolBar {
    id: toolbarRoot

    property double iconSize: 45 * appwindow.officalScale
    property double shrinkIconSize: 48 * appwindow.officalScale
    property double fontSize: Kirigami.Theme.defaultFont.pixelSize * 0.8
    property double shrinkFontSize: Kirigami.Theme.defaultFont.pixelSize * 0.7
    
    width: 1920 * appwindow.officalScale
    height: 105 * appwindow.officalScale
    
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
        color: "#a6000000"
        anchors.fill: parent
    }
    
    RowLayout {
        anchors.fill: parent
        spacing: 0

        Repeater {
            model: ListModel {
                ListElement {
                    name: "Alarm"
                    icon_highlight: "qrc:/image/footer_alarm_w.png"
                    icon: "qrc:/image/footer_alarm_grey.png"
                }
                ListElement {
                    name: "Stopwatch"
                    icon_highlight: "qrc:/image/footer_sw_w.png"
                    icon: "qrc:/image/footer_sw_grey.png"
                }
                ListElement {
                    name: "Timer"
                    icon_highlight: "qrc:/image/footer_timer_w.png"
                    icon: "qrc:/image/footer_timer_grey.png"
                }
            }
            
            Rectangle {
                Layout.minimumWidth: parent.width / 3
                Layout.maximumWidth: parent.width / 3
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignCenter
                color: "transparent"

                Behavior on color {
                    ColorAnimation { 
                        duration: 100 
                        easing.type: Easing.InOutQuad
                    }
                }
                
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent

                    onClicked: {
                        appwindow.switchToPage(getPage(model.name), 0)
                    }
                    onPressed: {
                        widthAnim.to = toolbarRoot.shrinkIconSize;
                        heightAnim.to = toolbarRoot.shrinkIconSize;
                        fontAnim.to = toolbarRoot.shrinkFontSize;
                        widthAnim.restart();
                        heightAnim.restart();
                        fontAnim.restart();
                    }
                    onReleased: {
                        if (!widthAnim.running) {
                            widthAnim.to = toolbarRoot.iconSize;
                            widthAnim.restart();
                        }
                        if (!heightAnim.running) {
                            heightAnim.to = toolbarRoot.iconSize;
                            heightAnim.restart();
                        }
                        if (!fontAnim.running) {
                            fontAnim.to = toolbarRoot.fontSize;
                            fontAnim.restart();
                        }
                    }
                }
                
                RowLayout {
                    id: itemColumn

                    anchors.centerIn: parent
                    spacing: 15 * appwindow.officalScale

                    Kirigami.Icon {

                        Layout.alignment: Qt.AlignCenter
                        Layout.preferredHeight: toolbarRoot.iconSize
                        Layout.preferredWidth: toolbarRoot.iconSize

                        color: getPage(model.name).visible ? "#ffffff" : "#5e5e5e"
                        source: getPage(model.name).visible ? model.icon_highlight:  model.icon
                    
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
                        color: getPage(model.name).visible ? "#ffffff" : "#5e5e5e"
                        font.pixelSize: 30 * appwindow.officalScale
                        Layout.alignment: Qt.AlignCenter
                        horizontalAlignment: Text.AlignVCenter
                        elide: Text.ElideLeft
                        font.pointSize: toolbarRoot.fontSize
                        text: i18n(model.name)
                        
                        ColorAnimation on color {
                            easing.type: Easing.Linear
                        }
                        NumberAnimation on font.pointSize {
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
