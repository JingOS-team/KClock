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
import "../CommonSize.js" as CS
PathView {
    id: root

    property bool bgShow
    property variant value
    property int displayFontSize: width/4
    property real displayStep: 0.6 // displayStep > 0

    width: 100; height: 300
    clip: true
    pathItemCount: 7
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    dragMargin: root.width/2
    signal viewMove(var index)

    Component.onCompleted: findCurrentIndex()

    onMovementEnded: {
        viewMove(model[currentIndex].value)
    }
    onValueChanged: {
        findCurrentIndex()
    }

    Keys.onUpPressed: {
        root.decrementCurrentIndex()
        value = (model[currentIndex].value)
    }

    Keys.onDownPressed: {
        root.incrementCurrentIndex()
        value = (model[currentIndex].value)
    }

    Rectangle{
        id:backgroud
        anchors.centerIn: parent
        width: parent.width
        height: 80
        visible: bgShow
        color: "blue"
        radius: 14

        MouseArea {
            anchors.fill: parent
            onClicked: {
               mouse.accepted = true
            }
        }
    }

    delegate: Item {
        id:delegate
        width: root.width
        height: root.height/pathItemCount
        Text {
            anchors.centerIn: parent
            font.pixelSize: displayFontSize*Number(delegate.PathView.textFontPercent);
            text: modelData.display
            color: "white"
            opacity:  currentIndex == index ? 1 : 0.3
        }
    }

    path: Path {
        startX: root.width/2; startY: 0

        PathAttribute { name: "textFontPercent"; value: displayStep }
        PathLine { x: root.width/2; y: root.height/2 }
        PathAttribute { name: "textFontPercent"; value: 1}
        PathLine { x: root.width/2; y: root.height }
        PathAttribute { name: "textFontPercent"; value: displayStep }
    }

    function findCurrentIndex() {
        for (var i = 0; i < count; i++)
            if (model[i].value === value)
                currentIndex = i;
    }
}

