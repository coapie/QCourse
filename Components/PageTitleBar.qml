import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Rectangle {
    id:root
    width: parent.width
    height: 32

    property alias mainTitle:headLabel.text
    property alias subTitle:subLabel.text

    Column
    {
        width:parent.width
        height: 28

        Row {
            id:rowContainer
            width:parent.width
            height: parent.height

            leftPadding: 16

            Label {
                id:headLabel
                text:""
                font.pixelSize: 18
                font.bold: true
                width: 80
                height: parent.height
                topPadding: 4

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }

            Label {
                id:subLabel
                text:""
                font.pixelSize: 16
                width: parent.width - headLabel.width
                height: parent.height
                topPadding: 4

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }
        }


        Rectangle{
            width:parent.width
            height:2
            color:"darkgray"
        }
    }
}
