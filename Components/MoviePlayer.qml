import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtMultimedia 5.8
import QtQuick.Window 2.2
import QtQml 2.2


Window {
    id: root

    width: 640 //
    height: 480 //

    maximumHeight : height
    maximumWidth : width
    minimumHeight : height
    minimumWidth : width

    //modality: Qt.WindowModal
    visible: false

    property bool withMusic:true

    function playMovie(winTitle, videoUrl, musicUrl, hasMusic)
    {
        title = winTitle;
        videoWin.source = videoUrl;
        if(hasMusic){
            musicPlayer.source = musicUrl;
        }

        withMusic = hasMusic;
        visible = true;

        console.log("title:", winTitle, " video:", videoUrl, " music:", musicUrl, " hasMusic:", hasMusic);
    }

    MediaPlayer
    {
        id:musicPlayer
        property bool loaded:false
        loops:MediaPlayer.Infinite

        onStatusChanged:
        {
            if(status === MediaPlayer.Loaded){
                loaded = true;
            }

        }
    }

    Column {
        anchors.fill : parent
        spacing: 4
        topPadding: 10


        Video
        {
            id:videoWin
            property bool loaded:false
            visible: true

            width:parent.width - 20
            height: parent.height - rowContainer.height - 20
            x:10;y:10
            fillMode:VideoOutput.PreserveAspectFit
            muted: true
            loops: MediaPlayer.Infinite

            onStatusChanged:
            {
                if(status === MediaPlayer.Loaded)
                {
                    loaded = true;
                }

                console.log("video status changed:", status, " positon:", position, " EndOfMedia:", MediaPlayer.EndOfMedia);
            }

            onPositionChanged:
            {
                sliderPlayer.value = position / duration;
            }
        }

        Row
        {
            id:rowContainer

            width:parent.width
            height: 32
            leftPadding: 10
            rightPadding: 10

            spacing: 10

            Slider
            {
                id:sliderPlayer
                width:parent.width - 80
                height: parent.height

                onValueChanged:
                {
                    if(pressed){
                        videoWin.seek(value * videoWin.duration);

                        if(withMusic){
                            var pos = value * videoWin.duration;
                            if(musicPlayer.duration > pos){
                                musicPlayer.seek(pos);
                            }else{
                                pos = pos % musicPlayer.duration;
                                musicPlayer.seek(pos);
                            }
                        }
                   }
                }
            }

            Button
            {
                id:playstop
                width:48
                height: parent.height

                enabled:  withMusic ? (videoWin.loaded && musicPlayer.loaded) : videoWin.loaded

                property bool played:false

                text:qsTr("播放")
                onClicked:
                {
                    if(played){
                        played = false;
                        text = qsTr("播放");

                        videoWin.pause();
                        if(withMusic)
                            musicPlayer.pause();
                    }else{
                        played = true;
                        text = qsTr("暂停");
                        videoWin.play();
                        if(withMusic)
                            musicPlayer.play();
                    }
                }
            }
        }
    }

    onClosing:
    {
        videoWin.stop();
        if(withMusic)
            musicPlayer.stop();
    }
}
