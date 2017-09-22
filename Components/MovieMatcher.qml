import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtMultimedia 5.8
import QtQuick.Window 2.2

Window {
    id:root

    width: 640
    height: 512

    visible: false

    modality:Qt.WindowModal
    property string colorOfBk: "#EAEAEA"
    color: colorOfBk

    property var modelSection:Object()
    property string sectionImage0

    property string sectionImage1
    property string sectionImage2
    property string sectionTitle0

    property string sectionTitle1
    property string sectionTitle2

    property string sectionMusic
    property int sectionStart
    property int sectionEnd
    property int sectionSelected

    property var myParent


    function resetSection()
    {
        switch(sectionSelected)
        {
        case 0:
            titleMusic.text = sectionTitle0;
            imageMusic.source = sectionImage0;
            break;
        case 1:
            titleMusic.text = sectionTitle1;
            imageMusic.source = sectionImage1;
            break;

        case 2:
            titleMusic.text = sectionTitle2;
            imageMusic.source = sectionImage2;
            break;
        }
    }

    function playSection(callerObj, baseUrl, musicUrl, lvmSec){
        modelSection = lvmSec;
        myParent = callerObj;

        sectionMusic = musicUrl;

        //console.log("title :", lvmSec.imageTitle0);
        sectionImage0 = lvmSec.mlvmImage0;
        sectionImage1 = lvmSec.mlvmImage1;
        sectionImage2 = lvmSec.mlvmImage2;

        sectionTitle0 = lvmSec.mlvmImageTitle0;
        sectionTitle1 = lvmSec.mlvmImageTitle1;
        sectionTitle2 = lvmSec.mlvmImageTitle2;

        sectionStart = lvmSec.mlvmstart;
        sectionEnd   = lvmSec.mlvmend;
        sectionSelected = lvmSec.mlvmSelected;

        if(sectionSelected < 0)
            sectionSelected = 0;

        localMedia.source = sectionMusic;

        visible = true;
        resetSection();
    }

    onClosing:
    {
        localMedia.stop();
    }

    MediaPlayer {
        id:localMedia

        onStatusChanged:
        {
            if(status === MediaPlayer.Loaded){

                localMedia.seek(sectionStart*1000 + 1);

                volume = 1.0;
                playStop.enabled = true;
            }
        }

        onPositionChanged: {

            var pos = position/1000;

            progressBar.value = (position - sectionStart*1000) / ((sectionEnd - sectionStart)*1000);

            if(position >= (sectionEnd*1000)){
                seek(sectionStart*1000);
            }
        }
    }

    Column{
        anchors.fill: parent

        Rectangle{
            width:parent.width
            height: 480

            Image {
              id:imageMusic
              width: parent.width
              height:parent.height
              fillMode: Image.PreserveAspectCrop
            }

            Label {
            id:titleMusic

            width:parent.width
            height: 32
            x:0; y:parent.height - 48

            font.pixelSize: 24
            wrapMode:Text.Wrap
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter

            background: Rectangle {
                anchors.fill: parent
                color:colorOfBk
                opacity: 0.7
             }
            }
        }


        Row{
            width:parent.width
            height: 32
            spacing: 4

            Slider {

                id: progressBar
                width:480
                height: 32


                from:0.0
                to:1.0

                onValueChanged:
                {

                    var pos = progressBar.value * ((sectionEnd - sectionStart) * 1000);
                    pos += sectionStart* 1000;
                    localMedia.seek(pos);
                }
            }

            Button {
            id:playStop
            width:48
            height: parent.height
            enabled: false

            text:"播放"

            property bool playStatus: true
            onClicked: {
                if(playStatus){
                        playStop.text = "暂停"
                    playStop.playStatus = false
                        localMedia.play()
                }else{

                        playStop.text = "播放"
                        playStop.playStatus = true
                        localMedia.pause()
                }
            }
            }

            Button {
                id:switchPic
                width:48
                height: parent.height

                text:"换图"

                onClicked: {
                    sectionSelected = (sectionSelected + 1) % 3;
                    resetSection();
                }
            }

            Button {
                id:closeWin
                width:48
                height: parent.height

                text:"选择"

                onClicked: {
                    myParent.selected(modelSection.mlvmidx, sectionSelected);
                    root.close();
                }
            }
        }
    }
}
