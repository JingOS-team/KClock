import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.11 as Kirigami

Item {
    id: root

    property int default_visible: 3
    property real widget_w
    property real widget_h
    property int visibleItemCountValue: default_visible
    property int modelValue: 3
    property real textSize: 34
    property string textColor: "white"
    property real btn_w
    property real btn_h
    property alias currentIndex: tumbler.currentIndex
    property real myScale: appwindow.officalScale * 1.3

    width: widget_w
    height: widget_h

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        // color: "green"

    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: tumbler_up
            width: parent.width
            height: btn_h
            color: "transparent"

            Image {
                source: appwindow.isDarkTheme ? "qrc:/image/big_up.png" :"qrc:/image/big_up_l.png"
                width: 44
                height: 44
                anchors.centerIn:parent

            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("remove")
                    if(tumbler.currentIndex == 0){
                        tumbler.currentIndex = tumbler.model -1
                    }else {
                        tumbler.currentIndex -= 1
                    }
                }
            }
        }

        Tumbler {
            id: tumbler
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.fillHeight: true
            model: modelValue
            visibleItemCount: visibleItemCountValue
            wheelEnabled: true

            MouseArea {
                anchors.fill: parent
                onWheel: {
                        if(wheel.angleDelta.y > 0 ){
                            tumbler.currentIndex --
                        }else {
                            tumbler.currentIndex ++
                        }
                }
            }

            delegate: Label {
                opacity: 1.0 - (Math.abs(
                             Tumbler.displacement)+0.2 )/ (Tumbler.tumbler.visibleItemCount / 2)
                color: textColor
                text: modelData < 10 ? "0" + modelData : modelData
                font.pixelSize: textSize

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                function displacementItemOpacity(displacement, visibleItemCount) {
                    return 1.0 - Math.abs(displacement) / (visibleItemCount / 2)
                }
            }
        }

        Rectangle {
            id: tumbler_down
            width: parent.width
            height:btn_h
            color: "transparent"

            Image {
                source: appwindow.isDarkTheme ? "qrc:/image/big_dow.png" : "qrc:/image/big_dow_l.png"
                width: 44
                height: 44
                anchors.centerIn:parent
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("add")
                    if(tumbler.currentIndex === tumbler.model-1){
                        tumbler.currentIndex = 0
                    }else {
                        tumbler.currentIndex += 1
                    }
                }
            }
        }
    }
}
