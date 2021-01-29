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
    property int parentWidth: 960 * appwindow.officalScale
    property int parentHeight: 1200 * appwindow.officalScale
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
    property int titleFontSize: appwindow.fontSize + 11
    property int itemFontSize: appwindow.fontSize + 2
    property real myScale: appwindow.officalScale * 1.3

    property bool isChanged: false

    x: px
    y: py

    closePolicy: isChanged ? Popup.CloseOnEscape : Popup.CloseOnPressOutside
    width: parentWidth / 3 * 2
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    topMargin: 110
    leftMargin: 40
    modal: true
    focus: true
    contentHeight: 624 * appwindow.officalScale

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
    }

    contentItem: Rectangle {
        id: contentItem
        anchors.margins: 0
        implicitWidth: parent.width
        radius: 40 * appwindow.officalScale
        color: "#000000"

        VagueBackground {
            anchors.fill: parent
            sourceView: root
            mouseX: blurX
            mouseY: blurY
            coverColor: "#cc000000"
        }

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
            height: parent.height
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 30 * myScale
            color: "transparent"

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
                        color: "white"
                        font.pointSize: titleFontSize
                    }
                    Kirigami.Separator {
                        color: "transparent"
                        Layout.fillWidth: true
                    }

                    Kirigami.JIconButton {
                        id: eventCacel
                        width: 54 * appwindow.officalScale
                        height: 54 * appwindow.officalScale
                        anchors.right: eventConfirm.left
                        anchors.rightMargin: CS.popEventEditor.icon_margin
                        source: "qrc:/image/dlg_close.png"
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
                        width: 54 * appwindow.officalScale
                        height: 54 * appwindow.officalScale
                        anchors.right: parent.right
                        opacity: isChanged ? 1 : 0.4
                        enabled: isChanged
                        source: "qrc:/image/dlg_ok.png"
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
                    height: 20 * myScale
                    color: "transparent"
                }
                // Time
                RowLayout {
                    height: 140 * appwindow.officalScale
                    width: parent.width
                    anchors.topMargin: 25 * myScale

                    Item {
                        width: parent.width
                        Layout.fillWidth: true
                        height: parent.height

                        Image {
                            id: timeIcon
                            width: 25 * myScale
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/image/row_time.png"
                        }

                        Text {
                            anchors {
                                left: timeIcon.right
                                leftMargin: 16 * myScale
                                verticalCenter: parent.verticalCenter
                            }
                            font.pointSize: itemFontSize
                            color: "white"
                            text: "Time"
                        }

                        TimeSelectWheelView {
                            id: timeSeletor
                            widget_width: 225 * appwindow.officalScale
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
                    height: parent.width / 7
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
                            width: 25 * myScale
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/image/row_repeat.png"
                        }
                        Kirigami.Label {
                            anchors {
                                left: alertIcon.right
                                leftMargin: CS.popEventEditor.icon_text_margin
                                verticalCenter: parent.verticalCenter
                            }
                            font.pointSize: itemFontSize
                            text: "Repeat"
                            color: "white"
                        }

                        Kirigami.Label {
                            id: repeatContent
                            width: 240 * appwindow.officalScale
                            anchors {
                                right: repeatRightIcon.left
                                rightMargin: CS.popEventEditor.icon_text_margin
                                verticalCenter: parent.verticalCenter
                            }
                            color: "#8e8e93"
                            font.pointSize: itemFontSize
                            text: getRepeatFormat(alarmDaysOfWeek)
                            horizontalAlignment: Text.AlignRight
                            elide: Text.ElideRight
                            //todo
                        }

                        Image {
                            id: repeatRightIcon
                            width: 34 * appwindow.officalScale
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
                                popup.height = 824 * appwindow.officalScale
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
                    height: parent.width / 7
                    width: 240 * appwindow.officalScale
                    Item {
                        width: parent.width
                        Layout.fillWidth: true
                        height: parent.height
                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            id: label_bg
                        }

                        Image {
                            id: labelIcon
                            width: 25 * myScale
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/image/row_label.png"
                        }

                        Kirigami.Label {
                            id: labelTitle
                            anchors {
                                left: labelIcon.right
                                leftMargin: CS.popEventEditor.icon_text_margin
                                verticalCenter: parent.verticalCenter
                            }
                            color: "white"
                            font.pointSize: itemFontSize
                            text: i18n("Lable")
                        }

                        TextField {
                            id: labelTextField
                            anchors {
                                left: labelTitle.right
                                leftMargin: 90 * appwindow.officalScale
                                right: parent.right
                                rightMargin: CS.popEventEditor.icon_text_margin
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
                            font.pointSize: itemFontSize
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
                    height: parent.width / 7
                    width: parent.width
                    Item {
                        width: parent.width
                        Layout.fillWidth: true
                        height: parent.height
                        Rectangle {
                            anchors.fill: parent
                            id: snooze_bg
                            color: "transparent"
                        }

                        Image {
                            id: snoozeIcon
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/image/row_snooze.png"
                            width: 25 * myScale
                            height: width
                        }

                        Kirigami.Label {
                            anchors {
                                left: snoozeIcon.right
                                leftMargin: CS.popEventEditor.icon_text_margin
                                verticalCenter: parent.verticalCenter
                            }
                            font.pointSize: itemFontSize
                            color: "white"
                            text: "Snooze"
                        }

                        Switch {
                            id: snooze_switch
                            checkable: true
                            checked: true
                            onClicked: {
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
                    height: 104 * appwindow.officalScale
                    color: "transparent"
                    anchors {
                        top: parent.top
                        topMargin: 30 * myScale
                    }

                    Image {
                        id: alertBack
                        source: "qrc:/image/back.png"
                        sourceSize.width: 34 * myScale
                        sourceSize.height: 34 * myScale
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 30 * myScale

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                columnLayout.visible = true
                                weekSelector.visible = false
                                popup.height = 624 * appwindow.officalScale
                            }
                        }
                    }
                    Kirigami.Label {
                        anchors.left: alertBack.right
                        anchors.leftMargin: 13 * myScale
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: titleFontSize
                        text: "Repeat"
                        color: "white"
                    }
                }

                ListView {
                    width: parent.width
                    height: 650
                    model: weekModel
                    clip: true
                    anchors {
                        top: alertTtile.bottom
                        left: parent.left
                        right: parent.right
                        leftMargin: 40 * myScale
                        rightMargin: 40 * myScale
                    }

                    delegate: ToolButton {
                        id: tb_root
                        width: parent.width
                        height: 90 * appwindow.officalScale
                        checkable: true
                        checked: kclockFormat.isChecked(index, alarmDaysOfWeek)

                        background: Rectangle {
                            id: repeat_lst_bg
                            color: "transparent"
                        }

                        Kirigami.Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: name
                            color: "white"
                            font.pointSize: itemFontSize
                        }
                        Kirigami.Separator {
                            anchors.bottom: parent.bottom
                            implicitWidth: parent.width
                            implicitHeight: 1
                            visible: index != 6
                            color: "#36ffffff"
                        }
                        Image {
                            visible: kclockFormat.isChecked(index,
                                                            alarmDaysOfWeek)
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/image/repeat_ok.png"
                            sourceSize.width: 44
                            sourceSize.height: 44
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
            height: 624 * appwindow.officalScale

            ColumnLayout {
                width: parent.width

                Item {
                    id: labelAreaTitle
                    width: parent.width
                    height: 124 * appwindow.officalScale
                    z: 1
                    anchors {
                        top: parent.top
                        topMargin: 30 * myScale
                        left: parent.left
                        leftMargin: 30 * myScale
                    }

                    Image {
                        id: labelAreaBack
                        source: "qrc:/image/back.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        sourceSize.width: 34 * myScale
                        sourceSize.height: 34 * myScale

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                columnLayout.visible = true
                                weekSelector.visible = false
                                lableArea.visible = false
                                popup.height = 624 * appwindow.officalScale
                            }
                        }
                    }
                    Kirigami.Label {
                        anchors.left: labelAreaBack.right
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: titleFontSize
                        text: "Lable"
                        color: "white"
                    }
                }

                Rectangle {
                    width: 10
                    height: 30 * myScale
                    color: "transparent"
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    width: parent.width
                    height: 140 * appwindow.officalScale
                    color: "transparent"

                    anchors {
                        left: parent.left
                        leftMargin: 40 * myScale
                        right: parent.right
                        rightMargin: 40 * myScale
                    }
                    
                    Image {
                        id: lableAreaIcon
                        anchors.verticalCenter: parent.verticalCenter
                        width: 25 * myScale
                        height: width
                        source: "qrc:/image/row_label.png"
                    }

                    TextField {
                        id: eventSummary

                        anchors {
                            left: lableAreaIcon.right
                            leftMargin: 16 * myScale
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        
                        maximumLength: 100
                        color: "white"
                        font.pointSize: itemFontSize
                        placeholderText: "Alarm"
                        wrapMode: Text.WrapAnywhere
                        text: selectTitle

                        background: Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                        }

                       

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
