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
import QtQuick 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.12
import "StringUtils.js" as StringUtils

Item {
    id: root

    // property int digitalFontSize: appwindow.fontSize + 118
    // property int amFontSize: appwindow.fontSize + 6
    property int digitalFontSize: 90
    property int amFontSize: 22
    // 12 / 24
    property bool is12HoursType: utilModel.is24HourFormat()

    implicitHeight: parent.height
    implicitWidth: parent.width

    Component.onCompleted: {
        console.log("111是不是24 小时....." , is12HoursType)
        getAmPm()
    }

    onVisibleChanged: {
        is12HoursType = utilModel.is24HourFormat()
         console.log("222是不是24 小时....." , is12HoursType)
    }

    function getHoursValue(hours) {
        if (!is12HoursType) {
            if (hours == 0) {
                return 12
            } else if (hours <= 12 && hours > 0) {
                return hours < 10 ? "0" + hours : hours
            } else {
                return hours - 12
            }
        } else {
            return hours < 10 ? "0" + hours : hours
        }
    }

    function getAmPm(){
        // Qt.formatDateTime(new Date(), "hh-mm-ss")
        var dateValue = new Date() 
        var hours = dateValue.getHours()
        // var timeValue =  Qt.formatDateTime(new Date(), "hh:mm ddd")
        console.log(" --- 当前的小时::: " , hours)
        // console.log(" 当前的ooo::: " , timeValue)
        if(hours > 12){
            return true  
        }else {
            return false 
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: "transparent"
        Rectangle {
            width: parent.width
            height : digitalFontSize
            color: "transparent"
            anchors.verticalCenter : parent.verticalCenter

            RowLayout {
                anchors.centerIn: parent
                anchors.horizontalCenter: parent.horizontalCenter
                Layout.alignment: Qt.AlignCenter
                height:digitalFontSize
                spacing: 0

                Text {
                    font.pixelSize: digitalFontSize
                    font.family: "Gilroy Thin"
                    font.weight: Font.Light
                    text: getHoursValue(kclockFormat.hours)
                    color: appwindow.isDarkTheme ? "white":"black"
                    Layout.alignment: Qt.AlignCenter
                    height:digitalFontSize
                }

                Text {
                    font.pixelSize: digitalFontSize
                    text: ":"
                    font.family: "Gilroy Thin"
                    color: appwindow.isDarkTheme ? "white":"black"
                    font.weight: Font.Light
                    Layout.alignment: Qt.AlignCenter
                    height:digitalFontSize
                }

                Text {
                    id: txt_minutes
                    font.weight: Font.Light
                    font.pixelSize: digitalFontSize
                    font.family: "Gilroy Thin"
                    text: kclockFormat.minutes < 10 ? "0" + kclockFormat.minutes : kclockFormat.minutes
                    color: appwindow.isDarkTheme ? "white":"black"
                    Layout.alignment: Qt.AlignCenter
                    height:digitalFontSize
                }

                Text {
                    id: am_txt
                    font.pixelSize: amFontSize
                    text: getAmPm() ?  i18n("PM") : i18n("AM")
                    color: appwindow.isDarkTheme ? "white":"black"
                    anchors.top: txt_minutes.top
                    anchors.topMargin: am_txt.height /2 
                    visible: !is12HoursType
                    height:amFontSize
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        is12HoursType = !is12HoursType
                    }
                }
            }
        }
        
    }
}
