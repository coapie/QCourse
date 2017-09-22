import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


Rectangle {
    id:root

    color: "lightgray"

    property int btwidth: 64
    property int btheight:24
    property var callerObj:Object()
    property int movieIndex

    function setCaller(callerObj){
        root.callerObj = callerObj
    }

    function setChecked(movieIndex, musicIndex, dontPlay)
    {
        cbt0.checked = false;
        cbt1.checked = false;
        cbt2.checked = false;
        cbt3.checked = false;
        cbt4.checked = false;
        cbt5.checked = false;
        cbt6.checked = false;
        cbt7.checked = false;

        switch(musicIndex){
        case 0:
            cbt0.checked = true;
            break;
        case 1:
            cbt1.checked = true;
            break;
         case 2:
            cbt2.checked = true;
            break;
         case 3:
            cbt3.checked = true;
            break;
        case 4:
            cbt4.checked = true;
            break;
         case 5:
            cbt5.checked = true;
            break;
         case 6:
            cbt6.checked = true;
            break;
         case 7:
            cbt7.checked = true;
            break;

        }

        //checkedIndex = musicIndex;
        if(dontPlay)
            callerObj.selected(movieIndex, musicIndex);
    }

    Column{
        width: parent.width - 20
        height: parent.height - 10
        x:10;y:5

        spacing: 8

        Label{
            width: parent.width
            height: 24

            //leftPadding: 10

            font.pixelSize: 16
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            text:"选择音乐"
        }

        Row {
            width: parent.width
            height: btheight
            y:10;
            spacing: 10

            CheckButton {
                id:cbt0
                width:  btwidth
                height: btheight

                checked:false
                index:0
                bttext:"音乐1"
                onClicked: {
                    setChecked(movieIndex, 0, true);
                    checked = true;
                    }
            }

            CheckButton {

                id:cbt1
                width:  btwidth
                height: btheight

                checked:false
                index:1
                bttext:"音乐2"
                onClicked: {
                    setChecked(movieIndex, 1, true);
                    checked = true;
                    }
            }

            CheckButton {

                id:cbt2
                width:  btwidth
                height: btheight

                checked:false
                index:2
                bttext:"音乐3"
                onClicked: {
                    setChecked(movieIndex, 2, true);
                    checked = true;
                    }
            }

            CheckButton {

                id:cbt3
                width:  btwidth
                height: btheight

                checked:false
                index:3
                bttext:"音乐4"
                onClicked: {
                    setChecked(movieIndex, 3, true);
                    checked = true;
                    }
            }

        }


        Row {
            width: parent.width
            height: btheight
            y:10;
            spacing: 10

            CheckButton {

                id:cbt4
                width:  btwidth
                height: btheight

                checked:false
                index:4
                bttext:"音乐5"
                onClicked: {
                    setChecked(movieIndex, 4, true);
                    checked = true;
                    }
            }

            CheckButton {

                id:cbt5
                width:  btwidth
                height: btheight

                checked:false
                index:5
                bttext:"音乐6"
                onClicked: {
                    setChecked(movieIndex, 5, true);
                    checked = true;
                    }
            }

            CheckButton {

                id:cbt6
                width:  btwidth
                height: btheight

                checked:false
                index:6
                bttext:"音乐7"
                onClicked: {
                    setChecked(movieIndex, 6, true);
                    checked = true;
                    }
            }

            CheckButton {

                id:cbt7
                width:  btwidth
                height: btheight

                checked:false
                index:7
                bttext:"音乐8"
                onClicked: {
                    setChecked(movieIndex, 7, true);
                    checked = true;
                    }
            }
        }
    }
}

