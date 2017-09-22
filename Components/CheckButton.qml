import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


Button {
    id:root

    property int index
    property alias bttext:label.text

    Label {
        id:label
        anchors.fill:  parent
        color: "black"

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    background:Rectangle {
        anchors.fill: parent

        color:checked ? "lightgreen" : "darkgray"

        Rectangle{
            x:2;y:2
            width: parent.width - 4
            height: parent.height - 4

            color:checked ? "white" : "lightgray"
        }
    }

    onClicked: {

    }
}

