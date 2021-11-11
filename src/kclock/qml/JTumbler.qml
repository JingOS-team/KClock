/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Bob <pengbo·wu@jingos.com>
 *
 */
import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0
Item {
    id: root

    property int default_visible: 3
    property int visibleItemCountValue: default_visible
    property int modelValue: 3
    property real textSize: JDisplay.sp(34)
    property string textColor: Kirigami.JTheme.majorForeground
    property alias currentIndex: tumbler.currentIndex

    property var number: 0

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            id: tumblerUp

            Layout.fillWidth: true
            Layout.preferredHeight: JDisplay.dp(50)
            Kirigami.Icon {
                width: JDisplay.dp(44)
                height: width
                anchors.centerIn:parent
                color:Kirigami.JTheme.iconForeground
                source:"qrc:/image/big_up_l.png"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    tumbler.value ++
                    if (tumbler.value > modelValue) {
                        tumbler.value = 0
                    }
                }
            }
        }

        WheelView {
            id: tumbler

            Layout.fillWidth: true
            Layout.fillHeight: true

            bgShow: true
            pathItemCount: visibleItemCountValue
            displayFontSize: textSize

            model: {
                var list = []
                for (var i = 0; i < modelValue; i++)
                    list.push({
                                "display": i + "",
                                "value": i
                            })
                return list
            }

            onViewMove: {
                value = index
            }
        }

        Item {
            id: tumbler_down

            Layout.fillWidth: true
            Layout.preferredHeight: JDisplay.dp(50)

            Kirigami.Icon {
                width: JDisplay.dp(44)
                height: width
                anchors.centerIn:parent
                color:Kirigami.JTheme.iconForeground
                source: "qrc:/image/big_dow_l.png"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    tumbler.value --
                    if (tumbler.value < 0) {
                        tumbler.value = modelValue - 1
                    }
                }
            }
        }
    }
}
