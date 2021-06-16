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
import QtQuick 2.7
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "../CommonSize.js" as CS
import org.kde.kirigami 2.15 as Kirigami
import QtGraphicalEffects 1.0
import kclock 1.0

Popup {
    id: popup

    property string uid
    property var description: ""
    property int px: 0
    property int py: 0
    property int parentWidth: 444
    property int parentHeight: 648
    property Alarm alarmObject
    property string popTitle: "popTitle"
    property string alarmName
    property string status
    property int blurX
    property int blurY
    property alias selectHour: timeSeletor.hourNumber
    property alias selectMin: timeSeletor.minutesNumber
    property alias snoozed: snooze_switch.checked
    property string selectTitle: "Alarm"
    property int snoozedTime: 10
    property int alarmDaysOfWeek: alarmObject ? alarmObject.daysOfWeek : 0
    property string ringtonePath: alarmObject ? alarmObject.ringtonePath : ""
    property int titleFontSize: 20
    property int itemFontSize: 14
    // property real myScale: appwindow.officalScale * 1.3

    property bool isChanged: false

    x: px
    y: py

    closePolicy: isChanged ? Popup.CloseOnEscape : Popup.CloseOnPressOutside
    width: parentWidth / 3 * 2
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    topMargin: 23
    leftMargin: 20
    modal: true
    focus: true
    contentHeight: 300  

    onOpened: {
        if (alarmObject) {
            status = "edit"
            selectHour = alarmObject.hours
            selectMin = alarmObject.minutes
            selectTitle = alarmObject.name
            snoozed = alarmObject.snooze != 0
            alarmDaysOfWeek = alarmObject.daysOfWeek
        } else {
            status = "add"
            snoozed = true 
        }
        isChanged = false
    }

    onClosed: {
        finishEdit()
    }

    function finishEdit() {
        status = ""
        selectHour = 0
        selectMin = 0
        selectTitle = "Alarm"
        alarmDaysOfWeek = 0
        alarmObject = null
        timeSeletor.hourNumber = 0
        timeSeletor.minutesNumber = 0
        columnLayout.visible = true
        lableArea.visible = false
        weekSelector.visible = false
        isChanged = false
    }

    Overlay.modal: Rectangle {
        color: "transparent"
    }

    background: Rectangle {
        id: background
        color: "#00000000"
        radius:10 
    }

    contentItem: Rectangle {
        id: contentItem
        anchors.margins: 0
        implicitWidth: parent.width
        implicitHeight: 300
        color: "#00000000"
        radius: 10

        // VagueBackground {
        //     anchors.fill: parent
        //     sourceView: root
        //     mouseX: blurX
        //     mouseY: blurY
        //     coverColor: "#00000000"
        //     // radius: 10 
        //     // coverColor: appwindow.isDarkTheme ? "#cc000000" :"white"
        // }

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            radius: 40
            samples: 25
            color: "#1a000000"
            verticalOffset: 10
            spread: 0
        }

        Rectangle {
            id: scroll
            width: parent.width
            height: 300
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            // color: "transparent"
            color:"white"
            radius: 10
            // color: "blue"

            // MouseArea{
            //     anchors.fill:parent 
            // }

            ColumnLayout {
                id: columnLayout
                width: parent.width
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: CS.popEventEditor.common_margin
                }

                // Title
                RowLayout {
                    id: rowTitle
                    Layout.fillWidth: true

                    Kirigami.Label {
                        text: popTitle
                        color: appwindow.isDarkTheme ? "white":"black"
                        font.pixelSize: titleFontSize
                    }
                    Kirigami.Separator {
                        color: "transparent"
                        Layout.fillWidth: true
                    }

                    Kirigami.JIconButton {
                        id: eventCacel
                        width: 22  
                        height: 22  
                        anchors.right: eventConfirm.left
                        anchors.rightMargin: CS.popEventEditor.icon_margin
                        source: appwindow.isDarkTheme ? "qrc:/image/dlg_close.png" : "qrc:/image/dlg_close_l.png"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                popup.close()
                                finishEdit()
                            }
                        }
                    }

                    Kirigami.JIconButton {
                        id: eventConfirm
                        width: 22  
                        height: 22  
                        anchors.right: parent.right
                        opacity: isChanged ? 1 : 0.4
                        enabled: isChanged
                        // enabled: true
                        source: appwindow.isDarkTheme ? "qrc:/image/dlg_ok.png":"qrc:/image/dlg_ok_l.png"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // OK
                                if (status === "edit") {
                                    alarmObject.name = selectTitle
                                    alarmObject.hours = selectHour
                                    alarmObject.minutes = selectMin
                                    alarmObject.daysOfWeek = alarmDaysOfWeek
                                    alarmObject.snooze = snoozed ? 10 : 0
                                    alarmObject.enabled = true
                                    alarmPlayer.stop()
                                    alarmObject.save()
                                } else if (status === "add") {
                                    alarmModel.addAlarm(selectHour, selectMin,
                                                        alarmDaysOfWeek,
                                                        selectTitle, "",
                                                        snoozed ? 10 : 0)
                                    alarmModel.updateUi()
                                    alarmPlayer.stop()
                                }
                                popup.close()
                                finishEdit()
                            }
                        }
                    }
                }

                Rectangle {
                    width: 10
                    height: 20  
                    color: "transparent"
                }
                // Time
                RowLayout {
                    height: 60  
                    width: parent.width

                    Item {
                        width: parent.width
                        Layout.fillWidth: true
                        height: parent.height

                        Image {
                            id: timeIcon
                            width: 16  
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/image/row_time.png"
                        }

                        Text {
                            anchors {
                                left: timeIcon.right
                                leftMargin: 11  
                                verticalCenter: parent.verticalCenter
                            }
                            font.pixelSize: itemFontSize
                            color: appwindow.isDarkTheme ? "white":"black"
                            text: i18n("Time")
                        }

                        TimeSelectWheelView {
                            id: timeSeletor
                            widget_width: 120  
                            hourNumber: selectHour
                            minutesNumber: selectMin
                            height: parent.height
                            anchors {
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                            }
                            onMinChanged: {
                                console.log("select MIN :", minValue)
                                selectMin = minValue
                                isChanged = true
                            }
                            onHourChanged: {
                                console.log("select HOUR :", hourValue)
                                selectHour = hourValue
                                isChanged = true
                            }
                        }
                    }
                }
                // Repeat
                RowLayout {
                    height: 45
                    width: parent.width

                    Item {
                        width: parent.width
                        Layout.fillWidth: true
                        height: parent.height
                        id: repeat_row

                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            id: repeat_bg
                        }

                        Image {
                            id: alertIcon
                            width: 17  
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/image/row_repeat.png"
                        }
                        Kirigami.Label {
                            anchors {
                                left: alertIcon.right
                                leftMargin: 11
                                verticalCenter: parent.verticalCenter
                            }
                            font.pixelSize: itemFontSize
                            text: i18n("Repeat")
                            color: appwindow.isDarkTheme ? "white":"black"
                        }

                        Kirigami.Label {
                            id: repeatContent
                            width: 120  
                            anchors {
                                right: repeatRightIcon.left
                                rightMargin: 2
                                verticalCenter: parent.verticalCenter
                            }
                            color: "#8e8e93"
                            font.pixelSize: itemFontSize
                            text: getRepeatFormat(alarmDaysOfWeek)
                            horizontalAlignment: Text.AlignRight
                            elide: Text.ElideRight
                            //todo
                        }

                        Image {
                            id: repeatRightIcon
                            width: 22  
                            height: width
                            source: "qrc:/image/icon_right.png"
                            anchors {
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                            }
                        }

                        Kirigami.Separator {
                            width: parent.width
                            anchors.bottom: parent.bottom
                            color: "#36ffffff"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                columnLayout.visible = false
                                weekSelector.visible = true
                                popup.height = 397
                                isChanged = true
                            }
                            hoverEnabled: true
                            onEntered: {
                                repeat_bg.color = "#0c767680"
                            }

                            onExited: {
                                repeat_bg.color = "transparent"
                            }

                            onPressed: {
                                repeat_bg.color = "#10787880"
                            }

                            onReleased: {
                                repeat_bg.color = "transparent"
                            }
                        }
                    }
                }

                // Lable
                RowLayout {
                    height: 45
                    width: parent.width
                     
                    Item {
                        width: parent.width
                        height: parent.height
                        Layout.fillWidth: true

                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            id: label_bg
                        }

                        Image {
                            id: labelIcon
                            width: 17  
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/image/row_label.png"
                        }

                        Kirigami.Label {
                            id: labelTitle
                            anchors {
                                left: labelIcon.right
                                leftMargin: 11
                                verticalCenter: parent.verticalCenter
                            }
                            color: appwindow.isDarkTheme ? "white":"black"
                            font.pixelSize: itemFontSize
                            text: i18n("Label")
                        }

                        TextField {
                            id: labelTextField
                            anchors {
                                left: labelTitle.right
                                leftMargin: 10
                                right: parent.right
                                rightMargin: 2
                                verticalCenter: parent.verticalCenter
                            }

                            background: Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                            }
                            horizontalAlignment: Text.AlignRight
                            text: selectTitle
                            maximumLength: 100
                            color: "#8e8e93"
                            font.pixelSize: itemFontSize
                            placeholderText: "Alarm"
                            onTextChanged: {
                                console.log("inputing.....", text)
                                selectTitle = text
                                isChanged = true
                            }
                        }

                        Kirigami.Separator {
                            width: parent.width
                            anchors.bottom: parent.bottom
                            color: "#36ffffff"
                        }
                    }
                }

                // Snooze
                RowLayout {
                    height: 45
                    width: parent.width
                    
                    Item {
                        width: parent.width
                        height: parent.height
                        Layout.fillWidth: true
                        Rectangle {
                            anchors.fill: parent
                            id: snooze_bg
                            color: "transparent"
                        }

                        Image {
                            id: snoozeIcon
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/image/row_snooze.png"
                            width: 17  
                            height: width
                        }

                        Kirigami.Label {
                            anchors {
                                left: snoozeIcon.right
                                leftMargin: 11
                                verticalCenter: parent.verticalCenter
                            }
                            font.pixelSize: itemFontSize
                            color: appwindow.isDarkTheme ? "white":"black"
                            text: i18n("Snooze")
                        }

                        Kirigami.JSwitch {
                            id: snooze_switch
                            checkable: true
                            checked: true
                            onClicked: {
                                isChanged = true
                                snoozed = checked
                            }

                            onCheckedChanged:{
                                 isChanged = true
                                snoozed = checked
                            }

                            anchors {
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                snooze_switch.checked = !snooze_switch.checked
                            }
                            onEntered: {
                                snooze_bg.color = "#0c767680"
                            }
                            onExited: {
                                snooze_bg.color = "transparent"
                            }
                            onPressed: {
                                snooze_bg.color = "#10787880"
                            }
                            onReleased: {
                                snooze_bg.color = "transparent"
                            }
                        }
                    }
                }

                Rectangle {
                    width: 10
                    height: 20  
                    color: "transparent"
                }
            }
        }

        Item {
            id: weekSelector
            visible: false
            width: parent.width
            height: parent.height

            ColumnLayout {
                width: parent.width
                Layout.fillWidth: true
                height: parent.height

                Rectangle {
                    id: alertTtile
                    width: parent.width
                    height: 22  
                    color: "transparent"
                    anchors {
                        top: parent.top
                        topMargin: 20  
                    }

                    Image {
                        id: alertBack
                        source: appwindow.isDarkTheme ? "qrc:/image/back.png" : "qrc:/image/back_l.png" 
                        sourceSize.width: 22  
                        sourceSize.height: 22  
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 17  

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                columnLayout.visible = true
                                weekSelector.visible = false
                                popup.height = 300  
                            }
                        }
                    }
                    Kirigami.Label {
                        anchors.left: alertBack.right
                        anchors.leftMargin: 8 
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: titleFontSize
                        text: i18n("Repeat")
                        color: appwindow.isDarkTheme ? "white":"black"
                    }
                }

                ListView {
                    width: parent.width
                    height: 45* 7
                    model: weekModel
                    clip: true
                    anchors {
                        top: alertTtile.bottom
                        left: parent.left
                        right: parent.right
                        leftMargin: 20  
                        rightMargin: 20 
                        topMargin: 23 
                    }

                    delegate: ToolButton {
                        id: tb_root
                        width: parent.width
                        height: 45  
                        checkable: true
                        checked: kclockFormat.isChecked(index, alarmDaysOfWeek)

                        background: Rectangle {
                            id: repeat_lst_bg
                            color: "transparent"
                        }

                        Kirigami.Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: name
                            color: appwindow.isDarkTheme ? "white":"black"
                            font.pixelSize: itemFontSize
                        }
                        Kirigami.Separator {
                            anchors.bottom: parent.bottom
                            implicitWidth: parent.width
                            implicitHeight: 2
                            visible: index != 6
                            color: "#36ffffff"
                        }
                        Image {
                            visible: kclockFormat.isChecked(index,
                                                            alarmDaysOfWeek)
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/image/repeat_ok.png"
                            sourceSize.width: 22
                            sourceSize.height: 22
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (!tb_root.checked) {
                                    alarmDaysOfWeek |= flag
                                } else {
                                    alarmDaysOfWeek &= ~flag
                                }
                                tb_root.checked = !tb_root.checked
                            }
                            hoverEnabled: true
                            onEntered: {
                                repeat_lst_bg.color = "#0c767680"
                            }

                            onExited: {
                                repeat_lst_bg.color = "transparent"
                            }

                            onPressed: {
                                repeat_lst_bg.color = "#10787880"
                            }

                            onReleased: {
                                repeat_lst_bg.color = "transparent"
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: lableArea
            visible: false
            width: parent.width
            height: 315  

            ColumnLayout {
                width: parent.width

                Item {
                    id: labelAreaTitle
                    width: parent.width
                    height: 62  
                    z: 1
                    anchors {
                        top: parent.top
                        topMargin: 11  
                        left: parent.left
                        leftMargin: 11  
                    }

                    Image {
                        id: labelAreaBack
                        source: "qrc:/image/back.png"
                        anchors.verticalCenter: parent.verticalCenter
                        sourceSize.width: 17  
                        sourceSize.height: 17  
                        anchors.left: parent.left
                        anchors.leftMargin: 11

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                columnLayout.visible = true
                                weekSelector.visible = false
                                lableArea.visible = false
                                popup.height = 312  
                            }
                        }
                    }
                    Kirigami.Label {
                        anchors.left: labelAreaBack.right
                        anchors.leftMargin: 5
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: titleFontSize
                        text: i18n("Label")
                        color: appwindow.isDarkTheme ? "white":"black"
                    }
                }

                Rectangle {
                    width: 10
                    height: 30  
                    color: "transparent"
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    width: parent.width
                    height: 70  

                    anchors {
                        left: parent.left
                        leftMargin: 20  
                        right: parent.right
                        rightMargin: 20  
                    }
                    color: "transparent"

                    Image {
                        width: 17  
                        height: width
                        id: lableAreaIcon
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/image/row_label.png"
                    }

                    TextField {
                        id: eventSummary
                        anchors {
                            left: lableAreaIcon.right
                            leftMargin: 8  
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        background: Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                        }

                        text: selectTitle
                        maximumLength: 100
                        color: appwindow.isDarkTheme ? "white":"black"
                        font.pixelSize: itemFontSize
                        placeholderText: "Alarm"
                        wrapMode: Text.WrapAnywhere

                        onTextChanged: {
                            selectTitle = text
                        }
                    }

                    Kirigami.Separator {
                        width: parent.width
                        anchors.bottom: parent.bottom
                        color: "#36ffffff"
                    }
                }
            }
        }
    }

    ListModel {
        id: listModel
        ListElement {
            displayName: "Every Sunday"
            value: 0
        }
        ListElement {
            displayName: "Every Monday"
            value: 0
        }
        ListElement {
            displayName: "Every Tuesday"
            value: 0
        }
        ListElement {
            displayName: "Every Wednesday"
            value: 0
        }
        ListElement {
            displayName: "Every Thursday"
            value: 0
        }
        ListElement {
            displayName: "Every Friday"
            value: 0
        }
        ListElement {
            displayName: "Every Saturday"
            value: 0
        }
    }

    function initNewDate() {

        var newDt

        if (incidenceData) {
            newDt = incidenceData.dtend
        } else {
            newDt = startDt
            newDt.setMinutes(newDt.getMinutes(
                                 ) + _calindoriConfig.eventsDuration)
            newDt.setSeconds(0)
        }

        eventDate.selectorDate = newDt
    }

    function getRepeatFormat(dayOfWeek) {
        if (dayOfWeek == 0) {
            return i18n("No Repeat")
        }
        let monday = 1 << 0, tuesday = 1 << 1, wednesday = 1 << 2, thursday = 1 << 3, friday = 1 << 4, saturday = 1 << 5, sunday = 1 << 6

        if (dayOfWeek == monday + tuesday + wednesday + thursday + friday + saturday + sunday)
            return i18n("Everyday")

        if (dayOfWeek == monday + tuesday + wednesday + thursday + friday)
            return i18n("Weekdays")

        let str = ""
        if (dayOfWeek & monday)
            str += "Mon., "
        if (dayOfWeek & tuesday)
            str += "Tue., "
        if (dayOfWeek & wednesday)
            str += "Wed., "
        if (dayOfWeek & thursday)
            str += "Thu., "
        if (dayOfWeek & friday)
            str += "Fri., "
        if (dayOfWeek & saturday)
            str += "Sat., "
        if (dayOfWeek & sunday)
            str += "Sun., "
        return str.substring(0, str.length - 2)
    }
}
