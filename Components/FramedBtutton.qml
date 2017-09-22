import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


Button {
    id:root

    property alias frameColor:backgroundColor.color
    property alias bkColor:frontgroundColor.color

    text:"试听"
    background:Rectangle{
        id:backgroundColor
        anchors.fill : parent
        color: "darkgray"
        Rectangle {
            id:frontgroundColor
            x:2;y:2;
            width:parent.width -4;
            height: parent.height -4
            color: "white"
            }
        }
}

