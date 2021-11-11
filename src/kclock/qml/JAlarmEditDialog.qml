/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Bob <pengbo·wu@jingos.com>
 *
 */
import QtQuick 2.7
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0
import QtGraphicalEffects 1.0
import kclock 1.0
// import "../CommonSize.js" as CS

Popup {
    id: popup

    property string uid
    property var description: ""
    property int parentWidth: JDisplay.dp(444)
    property int parentHeight: JDisplay.dp(648)
    property Alarm alarmObject
    property string popTitle: "popTitle"
    property string alarmName
    property string status
    property int blurX
    property int blurY
    property alias selectHour: timeSeletor.hourNumber
    property alias selectMin: timeSeletor.minutesNumber
    property alias snoozed: snooze_switch.checked
    property string selectTitle: ""
    property int snoozedTime: 10
    property int alarmDaysOfWeek: alarmObject ? alarmObject.daysOfWeek : 0
    property string ringtonePath: alarmObject ? alarmObject.ringtonePath : ""
    property int titleFontSize: JDisplay.sp(20)
    property int itemFontSize: JDisplay.sp(14)
    property bool is24HourFormat: timezoneProxy.isSystem24HourFormat

    property bool timePeriod: false

    property bool isChanged: false

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 ;duration: 75}
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 ;duration: 75}
    }

    onTimePeriodChanged: {
        isChanged = true
    }

    onIs24HourFormatChanged: {
        if (is24HourFormat) {
            if (timePeriod) {
                selectHour += 12;
            }
        } else {
            if (selectHour >= 12) {
                    timePeriod = true
                }
            if (selectHour > 12) {
                selectHour -= 12
            }
        }
    }

    closePolicy: isChanged ? Popup.CloseOnEscape : Popup.CloseOnPressOutside
    width: parentWidth / 3 * 2
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    topMargin: JDisplay.dp(23)
    leftMargin: JDisplay.dp(20)
    modal: true
    focus: true
    contentHeight: JDisplay.dp(300)
    onAboutToShow: {
        if (alarmObject) {
            status = "edit"
            selectHour = alarmObject.hours
            selectMin = alarmObject.minutes
            selectTitle = alarmObject.name
            snoozed = alarmObject.snooze != 0
            alarmDaysOfWeek = alarmObject.daysOfWeek
            if (!is24HourFormat) {
                if (selectHour >= 12) {
                    timePeriod = true
                }
                if (selectHour > 12) {
                    selectHour -= 12
                }
            }
        } else {
            status = "add"
            snoozed = true
            var currentDate = utilModel.localSystemDateTime()

            selectMin = currentDate.getMinutes()
            selectHour = currentDate.getHours()

            if (!is24HourFormat) {
                if (selectHour >= 12) {
                    timePeriod = true
                }
                if (selectHour > 12) {
                    selectHour -= 12
                }
            }
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
        selectTitle = ""
        alarmDaysOfWeek = 0
        alarmObject = null
        timeSeletor.hourNumber = 0
        timeSeletor.minutesNumber = 0
        columnLayout.visible = true
        lableArea.visible = false
        weekSelector.visible = false
        isChanged = false
    }

    background: Kirigami.JBlurBackground {
        // sourceItem: popup.parent
    }

    contentItem: Item {
        id: contentItem
        anchors.margins: 0
        implicitWidth: parent.width

        ColumnLayout {
            id: columnLayout
            width: parent.width
            spacing: 0
            anchors {
                top: parent.top
                left: parent.left
                leftMargin: JDisplay.dp(20)
                rightMargin: JDisplay.dp(20)
                topMargin: JDisplay.dp(23)
                bottomMargin: JDisplay.dp(20)
                right: parent.right
            }

            // Title
            RowLayout {
                id: rowTitle
                Layout.fillWidth: true
                spacing:0

                Kirigami.Label {
                    text:popTitle
                    color:Kirigami.JTheme.majorForeground
                    font.pixelSize: titleFontSize
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Kirigami.JIconButton {
                    id: eventCacel
                    Layout.preferredWidth: JDisplay.dp(22) + 10
                    Layout.preferredHeight: JDisplay.dp(22) + 10
                    color:Kirigami.JTheme.iconForeground
                    source: appwindow.isDarkTheme ? "qrc:/image/dlg_close.png" : "qrc:/image/dlg_close_l.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            popup.close()
                            finishEdit()
                        }
                    }
                }

                Item {
                    width: JDisplay.dp(15)
                    height:1
                }

                Kirigami.JIconButton {
                    id: eventConfirm
                    Layout.preferredWidth: JDisplay.dp(22) + 10
                    Layout.preferredHeight: JDisplay.dp(22) + 10
                    Layout.alignment: Qt.AlignRight
                    opacity: isChanged ? 1 : 0.4
                    enabled: isChanged
                    // enabled: true
                    color: Kirigami.JTheme.iconForeground
                    source: "qrc:/image/dlg_ok_l.png"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // OK
                            if (status === "edit") {
                                if (selectTitle == "") {
                                    selectTitle = i18n("Alarm")
                                }
                                alarmObject.name = selectTitle

                                if (!is24HourFormat) {
                                    if (timePeriod) {
                                        if (selectHour === 12) {
                                            alarmObject.hours = selectHour
                                        } else {
                                            alarmObject.hours = selectHour + 12
                                        }
                                    } else {
                                        if (selectHour === 12) {
                                            alarmObject.hours = selectHour - 12
                                        } else {
                                            alarmObject.hours = selectHour
                                        }
                                    }
                                } else {
                                    alarmObject.hours = selectHour
                                }

                                alarmObject.minutes = selectMin
                                alarmObject.daysOfWeek = alarmDaysOfWeek
                                alarmObject.snooze = snoozed ? 10 : 0
                                alarmObject.enabled = true
                                alarmPlayer.stop()
                                alarmObject.save()
                            } else if (status === "add") {
                                if(selectTitle == "") {
                                    selectTitle = i18n("Alarm")
                                }

                                if (!is24HourFormat) {
                                    if (timePeriod) {
                                        if (selectHour === 12) {
                                            alarmModel.addAlarm(selectHour, selectMin, alarmDaysOfWeek, selectTitle, "", snoozed ? 10 : 0)
                                        } else {
                                            alarmModel.addAlarm(selectHour + 12, selectMin, alarmDaysOfWeek, selectTitle, "", snoozed ? 10 : 0)
                                        }
                                    } else {
                                        if (selectHour === 12) {
                                            alarmModel.addAlarm(selectHour - 12, selectMin, alarmDaysOfWeek, selectTitle, "", snoozed ? 10 : 0)
                                        } else {
                                            alarmModel.addAlarm(selectHour, selectMin, alarmDaysOfWeek, selectTitle, "", snoozed ? 10 : 0)
                                        }
                                    }
                                } else {
                                    alarmModel.addAlarm(selectHour, selectMin, alarmDaysOfWeek, selectTitle, "", snoozed ? 10 : 0)
                                }

                                alarmModel.updateUi()
                                alarmPlayer.stop()
                            }
                            popup.close()
                            finishEdit()
                        }
                    }
                }
            }

            Item {
                width: JDisplay.dp(10)
                height: JDisplay.dp(23)
            }
            // Time
            Rectangle {
                height: JDisplay.dp(60)
                width: parent.width
                color: "transparent"

                Item {
                    width: parent.width
                    Layout.fillWidth: true
                    height: parent.height

                    Kirigami.Icon {
                        id: timeIcon

                        width: JDisplay.dp(16)
                        height: width
                        anchors.verticalCenter: parent.verticalCenter

                        color:Kirigami.JTheme.iconForeground
                        source: "qrc:/image/row_time.png"
                    }

                    Text {
                        anchors {
                            left: timeIcon.right
                            leftMargin: JDisplay.dp(11)
                            verticalCenter: parent.verticalCenter
                        }
                        font.pixelSize: itemFontSize
                        color:Kirigami.JTheme.majorForeground
                        text: i18n("Time")
                    }

                    TimeSelectWheelView {
                        id: timeSeletor

                        width: is24HourFormat ? JDisplay.dp(160) : JDisplay.dp(180)
                        height: parent.height
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        hourNumber: selectHour
                        minutesNumber: selectMin

                        onMinChanged: {
                            selectMin = minValue
                            isChanged = true
                        }
                        onHourChanged: {
                            selectHour = hourValue
                            isChanged = true
                        }
                    }
                }
            }
            // Repeat
            RowLayout {
                height: JDisplay.dp(45)
                width: parent.width

                Item {
                    width: parent.width
                    Layout.fillWidth: true
                    height: parent.height
                    id: repeat_row

                    Rectangle {
                        id: repeat_bg

                        anchors.fill: parent
                        color: repeatMouse.containsMouse ? (repeatMouse.pressed ? Kirigami.JTheme.pressBackground : Kirigami.JTheme.hoverBackground ) : "transparent"
                    }

                    Kirigami.Icon {
                        id: alertIcon

                        width: JDisplay.dp(17)
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                        color:Kirigami.JTheme.iconForeground
                        source: "qrc:/image/row_repeat.png"
                    }
                    Kirigami.Label {
                        anchors {
                            left: alertIcon.right
                            leftMargin: JDisplay.dp(11)
                            verticalCenter: parent.verticalCenter
                        }
                        font.pixelSize: itemFontSize
                        text: i18n("Repeat")
                        color: Kirigami.JTheme.majorForeground
                    }

                    Kirigami.Label {
                        id: repeatContent

                        width: JDisplay.dp(120)
                        anchors {
                            right: repeatRightIcon.left
                            rightMargin: JDisplay.dp(2)
                            verticalCenter: parent.verticalCenter
                        }
                        color:Kirigami.JTheme.minorForeground
                        font.pixelSize: itemFontSize
                        text: getRepeatFormat(alarmDaysOfWeek)
                        horizontalAlignment: Text.AlignRight
                        elide: Text.ElideRight
                        //todo
                    }

                    Kirigami.Icon {
                        id: repeatRightIcon

                        width: JDisplay.dp(22)
                        height: width
                        color:Kirigami.JTheme.iconForeground
                        source: "qrc:/image/icon_right.png"
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    Kirigami.Separator {
                        width: parent.width
                        anchors.bottom: parent.bottom
                        color: Kirigami.JTheme.dividerForeground
                    }

                    MouseArea {
                        id:repeatMouse

                        anchors.fill: parent
                        onClicked: {
                            columnLayout.visible = false
                            weekSelector.visible = true
                            popup.height = JDisplay.dp(397)
                            isChanged = true
                        }
                        hoverEnabled: true
                    }
                }
            }

            // Lable
            RowLayout {
                height: JDisplay.dp(45)
                width: parent.width

                Item {
                    width: parent.width
                    height: parent.height
                    Layout.fillWidth: true

                    Kirigami.Icon {
                        id: labelIcon

                        width: JDisplay.dp(17)
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                        color:Kirigami.JTheme.iconForeground
                        source: "qrc:/image/row_label.png"
                    }

                    Kirigami.Label {
                        id: labelTitle

                        anchors {
                            left: labelIcon.right
                            leftMargin: JDisplay.dp(11)
                            verticalCenter: parent.verticalCenter
                        }
                        color: Kirigami.JTheme.majorForeground
                        font.pixelSize: itemFontSize
                        text: i18n("Label")
                    }

                    TextField {
                        id: labelTextField

                        anchors {
                            left: labelTitle.right
                            leftMargin: JDisplay.dp(10)
                            right: parent.right
                            rightMargin: JDisplay.dp(2)
                            verticalCenter: parent.verticalCenter
                        }

                        background: Item {}
                        horizontalAlignment: Text.AlignRight
                        text: selectTitle
                        maximumLength: 100
                        color: Kirigami.JTheme.minorForeground
                        font.pixelSize: itemFontSize
                        placeholderText: i18n("Alarm")
                        onTextChanged: {
                            selectTitle = text
                            isChanged = true
                        }
                    }

                    Kirigami.Separator {
                        width: parent.width
                        anchors.bottom: parent.bottom
                        color: Kirigami.JTheme.dividerForeground
                    }
                }
            }

            // Snooze
            RowLayout {
                height: JDisplay.dp(45)
                width: parent.width

                Item {
                    width: parent.width
                    height: parent.height
                    Layout.fillWidth: true

                    Kirigami.Icon {
                        id: snoozeIcon
                        anchors.verticalCenter: parent.verticalCenter
                        color:Kirigami.JTheme.iconForeground
                        source: "qrc:/image/row_snooze.png"
                        width: JDisplay.dp(17)
                        height: width
                    }

                    Kirigami.Label {
                        anchors {
                            left: snoozeIcon.right
                            leftMargin: JDisplay.dp(11)
                            verticalCenter: parent.verticalCenter
                        }
                        font.pixelSize: itemFontSize
                        color: Kirigami.JTheme.majorForeground
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
                        id:labelMouse
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: {
                            snooze_switch.checked = !snooze_switch.checked
                        }
                    }
                }
            }
        }


        Item {
            id: weekSelector

            visible: false
            anchors.fill: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: JDisplay.dp(20)
                spacing: 20
                Item {
                    id: alertTtile

                    Layout.fillWidth: true
                    Layout.preferredHeight: JDisplay.dp(22)

                    Kirigami.JIconButton {
                        id: alertBack

                        width: JDisplay.dp(22)
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                        color:Kirigami.JTheme.iconForeground
                        source: "qrc:/image/back_l.png"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                columnLayout.visible = true
                                weekSelector.visible = false
                                popup.height = JDisplay.dp(300)
                            }
                        }
                    }
                    Kirigami.Label {
                        anchors.left: alertBack.right
                        anchors.leftMargin: JDisplay.dp(8)
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: titleFontSize
                        text: i18n("Repeat")
                        color: Kirigami.JTheme.majorForeground
                    }
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: weekModel
                    clip: true

                    delegate: ToolButton {
                        id: tb_root

                        width: parent.width
                        height: JDisplay.dp(45)
                        checkable: true
                        checked: kclockFormat.isChecked(index, alarmDaysOfWeek)

                        background: Rectangle {
                            color:weakSelectDelMouse.containsMouse ? (weakSelectDelMouse.pressed ? Kirigami.JTheme.pressBackground : Kirigami.JTheme.hoverBackground ) : "transparent"
                        }

                        Kirigami.Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: name
                            color: Kirigami.JTheme.majorForeground
                            font.pixelSize: itemFontSize
                        }
                        Kirigami.Separator {
                            anchors.bottom: parent.bottom
                            implicitWidth: parent.width
                            visible: index != 6
                            color: Kirigami.JTheme.dividerForeground
                        }
                        Kirigami.Icon  {
                            visible: kclockFormat.isChecked(index,
                                                            alarmDaysOfWeek)
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            color:Kirigami.JTheme.iconForeground
                            source: "qrc:/image/repeat_ok.png"
                            width: JDisplay.dp(22)
                            height: width
                        }
                        MouseArea {
                            id:weakSelectDelMouse
                            anchors.fill: parent
                            onClicked: {
                                if (!tb_root.checked) {
                                    alarmDaysOfWeek |= flag
                                } else {
                                    alarmDaysOfWeek &= ~flag
                                }
                                tb_root.checked =  kclockFormat.isChecked(index, alarmDaysOfWeek)
                            }
                            hoverEnabled: true
                        }
                    }
                }
            }
        }

        Item {
            id: lableArea

            visible: false
            width: parent.width
            height: JDisplay.dp(315)

            ColumnLayout {
                width: parent.width

                Item {
                    id: labelAreaTitle

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredHeight: JDisplay.dp(62)
                    Layout.leftMargin: JDisplay.dp(11)
                    Layout.topMargin: JDisplay.dp(11)
                    z: 1

                    Image {
                        id: labelAreaBack

                        source: "qrc:/image/back.png"
                        anchors.verticalCenter: parent.verticalCenter
                        sourceSize.width: JDisplay.dp(17)
                        sourceSize.height: JDisplay.dp(17)
                        anchors.left: parent.left
                        anchors.leftMargin: JDisplay.dp(11)

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                columnLayout.visible = true
                                weekSelector.visible = false
                                lableArea.visible = false
                                popup.height = JDisplay.dp(312)
                            }
                        }
                    }
                    Kirigami.Label {
                        anchors.left: labelAreaBack.right
                        anchors.leftMargin: JDisplay.dp(5)
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: titleFontSize
                        text: i18n("Label")
                        color: Kirigami.JTheme.majorForeground
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: JDisplay.dp(30)
                }

                Item {
                    Layout.fillWidth: true
                    Layout.leftMargin: JDisplay.dp(20)
                    Layout.rightMargin: JDisplay.dp(20)
                    Layout.preferredHeight: JDisplay.dp(70)
                    Image {
                        width: JDisplay.dp(17)
                        height: width
                        id: lableAreaIcon
                        anchors.verticalCenter: parent.verticalCenter
                        source: "qrc:/image/row_label.png"
                    }

                    TextField {
                        id: eventSummary

                        anchors {
                            left: lableAreaIcon.right
                            leftMargin: JDisplay.dp(8)
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        background: Item {
                        }

                        text: selectTitle
                        maximumLength: 100
                        color: Kirigami.JTheme.majorForeground
                        font.pixelSize: itemFontSize
                        placeholderText: i18n("Alarm")
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
            newDt.setMinutes(newDt.getMinutes() + _calindoriConfig.eventsDuration)
            newDt.setSeconds(0)
        }
        eventDate.selectorDate = newDt
    }

    function getRepeatFormat(dayOfWeek) {
        if (dayOfWeek == 0) {
            return i18n("Never")
        }
        let monday = 1 << 0, tuesday = 1 << 1, wednesday = 1 << 2, thursday = 1 << 3, friday = 1 << 4, saturday = 1 << 5, sunday = 1 << 6

        if (dayOfWeek == monday + tuesday + wednesday + thursday + friday + saturday + sunday)
            return i18n("Everyday")

        if (dayOfWeek == monday + tuesday + wednesday + thursday + friday)
            return i18n("Weekdays")

        let str = ""
        if (dayOfWeek & monday)
            str += i18n("Mon., ")
        if (dayOfWeek & tuesday)
            str += i18n("Tue., ")
        if (dayOfWeek & wednesday)
            str += i18n("Wed., ")
        if (dayOfWeek & thursday)
            str += i18n("Thu., ")
        if (dayOfWeek & friday)
            str += i18n("Fri., ")
        if (dayOfWeek & saturday)
            str += i18n("Sat., ")
        if (dayOfWeek & sunday)
            str += i18n("Sun., ")
        return str.substring(0, str.length - 2)
    }
}
