import QtQuick 2.12
import QtQuick.Controls 2.5
import org.kde.kirigami 2.0 as Kirigami
import QtQuick.Layouts 1.11

Rectangle {
    
    width: parent.width /2
    // height: 48 * appwindow.officalScale
    height: 68
    color: "transparent"
    
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: 30
    // anchors.topMargin: 50 * appwindow.officalScale
    anchors.topMargin: 18

    // Image {
    //     id: tagImage
    //     source: "qrc:/image/clock_logo.png"
    //     width: 48
    //     height: 48
    //     anchors.verticalCenter: parent.verticalCenter
    // }
    Label {
        text: i18n("Clock")
        // font.pixelSize: 50* appwindow.officalScale
        font.pixelSize: 25
         color: appwindow.isDarkTheme ? "white":"black"
        anchors.left: tagImage.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 25
        Layout.alignment: Qt.AlignVCenter
    }


}
