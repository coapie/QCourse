import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


Rectangle {
    id:root

    property alias source:imageContainer.source
    property alias text:titleBar.text
    property bool checked:false
    property double uncheckedOpacity:0.4

    Column {
        width:parent.width - 8
        height: parent.height - 10
        anchors.centerIn: parent
        spacing: 2
        Image {
            id: imageContainer
            width:parent.width
            height: parent.height - 16
            opacity: checked ? 1.0 : uncheckedOpacity
        }

        Label {
            id:titleBar
            width:parent.width
            height: 16
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            rightPadding: 16

            opacity: checked ? 1.0 : uncheckedOpacity

            background:Image{
                id:bkImage
                width:16
                height: 16
                anchors.right: parent.right
                fillMode: Image.PreserveAspectFit
                source:checked ? "../images/checked.png" : "../images/unchecked.png"
           }
        }
      }
}

