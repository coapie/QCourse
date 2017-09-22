import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3

Window {
    id:root

    width:720
    height: 280

    property alias source00:image00.source
    property alias source01:image01.source
    property alias source02:image02.source
    property alias text00: image00.text
    property alias text01: image01.text
    property alias text02: image02.text

    property alias text:titleBar.text
    property bool checked:false
    property var callerObj:Object()
    property var modelSection:Object()

    property int selIndex:-1
    property int secIndex:-1

    function loadMatcher(callerObj, baseUrl, musicUrl, lvmSec) {

        modelSection = lvmSec;
        root.callerObj = callerObj;
        root.selIndex = lvmSec.mlvmSelected;
        root.secIndex = lvmSec.mlvmidx;

        console.log("selected:", lvmSec.mlvmSelected);


        source00 = lvmSec.mlvmImage0;
        source01 = lvmSec.mlvmImage1;
        source02 = lvmSec.mlvmImage2;

        text00 = lvmSec.mlvmImageTitle0;
        text01 = lvmSec.mlvmImageTitle1;
        text02 = lvmSec.mlvmImageTitle2;

        visible = true;

        if(selIndex >= 0){
            switch(selIndex){
            case 0: image00.checked = true; break;
            case 1: image01.checked = true; break;
            case 2: image02.checked = true; break;
            }
        }
    }


    Column {
        anchors.fill: parent

        Label{
            id:titleBar
            width:parent.width
            height: 32

            leftPadding: 10
            rightPadding: 10
            font.pixelSize: 16
            text:"试听音乐选择画面"

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            background:Rectangle{
                width: parent.width - 20
                height: 2
                x:10
                color: "darkgray"
                anchors.bottom: parent.bottom
            }
        }

        Row {
            width: parent.width
            height: parent.height - titleBar.height - buttonBar.height
            leftPadding: 8
            rightPadding: 8
            spacing: 8

            TitleImage {
                id:image00
                width: (parent.width - 32) / 3
                height: parent.height
                uncheckedOpacity: 1.0
                checked: false
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        image00.checked = true;
                        image01.checked = false;
                        image02.checked = false;

                        selIndex = 0;
                    }
                }
            }

            TitleImage {
                id:image01
                width: (parent.width - 32) / 3
                height: parent.height
                uncheckedOpacity: 1.0
                checked: false
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        image00.checked = false;
                        image01.checked = true;
                        image02.checked = false;
                        selIndex = 1;
                    }
                }
            }

            TitleImage {
                id:image02
                width: (parent.width - 32) / 3
                height: parent.height
                uncheckedOpacity: 1.0
                checked: false
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        image00.checked = false;
                        image01.checked = false;
                        image02.checked = true;

                        selIndex = 2;
                    }
                }
            }
        }


       Row {
            id:buttonBar
            width: 128
            height: 64
            x:parent.width/2 - width/2
            topPadding: 12
            spacing: 20

            FramedBtutton {
                id:confirm
                width: parent/2
                height: 20
                x:parent.width/2 - width/2
                text:"确定"
                frameColor: "lightgreen"
                bkColor: "lightgreen"
                onClicked:{
                    callerObj.selected(secIndex, selIndex);
                    root.close();
                }
            }

            FramedBtutton {
                id:conceled
                width: parent/2
                height: 20
                x:parent.width/2 - width/2
                text:"取消"
                frameColor: "darkgray"
                bkColor: "darkgray"
                onClicked:{
                    root.close();
                }
            }
        }
    }
}

