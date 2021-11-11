/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Bob <pengbo·wu@jingos.com>
 *
 */
import QtQuick 2.0
import QtGraphicalEffects 1.12
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0
Item {
    property alias text: contentText.text

    width:  JDisplay.dp(80)
    height: width

    Item {
        id:_rect

        anchors.fill: parent
        Item {
            width: parent.width
            height:JDisplay.dp(50)
            anchors {
                top: parent.top
                left: parent.left
            }
        }

        Item {
            width: parent.width
            height: JDisplay.dp(50)
            anchors {
                bottom: parent.bottom
                left: parent.left
            }
        }

        Text {
            id: contentText

            anchors {
                bottom: parent.bottom
                bottomMargin: JDisplay.dp(7)
                horizontalCenter: parent.horizontalCenter
            }

            text: i18n("Hours")
            color: Kirigami.JTheme.majorForeground
            font.pixelSize: JDisplay.sp(11)
        }
    }
}
