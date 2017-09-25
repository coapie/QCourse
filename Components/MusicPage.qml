import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtMultimedia 5.8


Page {
    id:root
    anchors.fill : parent
    property string colorOfBk: "#EAEAEA"


    property var lvmMusic
    property var course
    property string baseUrl
    property string musicUrl

    signal selected(int index, int selIndex)
    onSelected: {
        var lvm = musicSectionModel.get(index);
        lvm.mlvmSelected = selIndex;

        var sec = course.sections[index];
        sec["selected"] = selIndex;

        switch(selIndex){
        case 0:
            lvm.mlvmSelectedImageTitle = lvm.mlvmImageTitle0;
            break;
        case 1:
            lvm.mlvmSelectedImageTitle = lvm.mlvmImageTitle1;
            break;
        case 2:
            lvm.mlvmSelectedImageTitle = lvm.mlvmImageTitle2;
            break;
        }
    }

    onVisibleChanged: {
        console.log("visible change : ", visible);

        if(!visible){
            timerTune.interval = 200;
            timerTune.running = true;
        }
    }

    function loadMusic(musicModel)
    {
        lvmMusic = musicModel;


        console.log("load course from : ", musicModel.coursePath + "/manifest.qmm");
        var jsonRaw = misc.readFile(musicModel.coursePath + "/manifest.qmm");
        var course = JSON.parse(jsonRaw);

        root.course = course;

        root.baseUrl = "file:///" + musicModel.coursePath;
        root.musicUrl = root.baseUrl + "/" + course["music"];

        musicSectionModel.clear();

        for (var i in course.sections)
        {
            var sec = course.sections[i];
            var lm  = Object();

            lm.mlvmidx      = sec["idx"];
            lm.mlvmstart    = sec["start"];
            lm.mlvmend      = sec["end"];
            lm.mlvmscore    = sec["score"];
            lm.mlvmimages   = sec["images"];
            lm.mlvmprefer   = sec["prefer"];
            lm.mlvmRight    = sec["right"];

            lm.mlvmImageTitle0    = misc.getBaseName(lm.mlvmimages[0]);
            lm.mlvmImage0   = root.baseUrl + "/" + (lm.mlvmidx + 1) + "/" + lm.mlvmimages[0];
            lm.mlvmImageTitle1    = misc.getBaseName(lm.mlvmimages[1]);
            lm.mlvmImage1   = root.baseUrl  + "/" + (lm.mlvmidx + 1) + "/" + lm.mlvmimages[1];
            lm.mlvmImageTitle2    = misc.getBaseName(lm.mlvmimages[2]);
            lm.mlvmImage2   = root.baseUrl  + "/" + (lm.mlvmidx + 1) + "/" +  lm.mlvmimages[2];

            if(sec["selected"] === undefined)
            {
                lm.mlvmSelected = -1;
                lm.mlvmSelectedImageTitle = "";
            }else{
                lm.mlvmSelected = sec["selected"];
                lm.mlvmSelectedImageTitle = misc.getBaseName(lm.mlvmimages[lm.mlvmSelected]);
            }

            if(sec["tunes"] === undefined){
                lm.mlvmHaveTunes = false;
            }else{
                lm.mlvmHaveTunes = true;
                lm.mlvmTune0 = root.baseUrl + "/" + (lm.mlvmidx + 1) + "/" +  sec["tunes"][0];
                lm.mlvmTune1 = root.baseUrl + "/" + (lm.mlvmidx + 1) + "/" +  sec["tunes"][1];
                lm.mlvmTune2 = root.baseUrl + "/" + (lm.mlvmidx + 1) + "/" +  sec["tunes"][2];
            }


            musicSectionModel.append(lm);
        }
    }

    header:PageTitleBar{
            id:titleBar
            width:parent.width
            height: 32
            mainTitle: "试听音乐"
            subTitle: "(听一段音乐，观看几幅不同的画面，品味意境选择最匹配的音和画)"
        }
    ListModel{
        id:musicSectionModel
    }

    Timer{
        id:timerTune
        interval: 500
        running: false
        repeat: false

        onTriggered: {
            console.log("tune player stop");
            tunePlayer.stop();
        }
    }

    MediaPlayer{
        id:tunePlayer

        onStatusChanged:
        {
            if(status === MediaPlayer.Loaded){

                if(root.visible)
                {
                    tunePlayer.play();
                    console.log("play source:", source);

                    volume = 1.0
                }
            }
        }
    }

    MusicMatcherDialog{
        id:mmDialog
    }

    Component{
        id:delegateListView

        Rectangle {
            width:musicListView.width
            height: 160
            //color: colorOfBk
            Column{
                anchors.fill: parent

                Rectangle{
                    width: parent.width - 20
                    height: 1
                    color: "darkgray"
                    x:10
                }


                Row{
                    id:musicSecionContainer
                    x:0;y:1
                    width: parent.width
                    height: parent.height - 2

                    spacing: 6
                    leftPadding: 10

                    Rectangle{
                    width:parent.height
                    height: parent.height
                    //color:colorOfBk
                    Image {
                        id:musicLogo
                        width: parent.width/2
                        height: parent.height/2
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit
                        source:"../images/music.png"

                        Image {
                            width:48
                            height: 48
                            anchors.centerIn: parent
                            source: "../images/play.png"
                            fillMode: Image.PreserveAspectFit
                            opacity: 0.5
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                var lvm = musicSectionModel.get(mlvmidx);

                                var com = Qt.createComponent("MusicMatcher.qml");
                                var o = com.createObject(root);

                                o.playSection(root, root.baseUrl, musicUrl, lvm);
                            }
                        }
                    }
                }

                    Label {
                        id:musicSectionName
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        width:parent.height/2
                        height: parent.height
                        text:"段落 " + (mlvmidx+1)
                    }
                    Column{
                    width: parent.height
                    height: parent.height


                    Rectangle{
                        width:parent.width
                        height: parent.height/2

                        FramedBtutton{
                            id:musicSelect

                            width: parent.width*2/3
                            height:24
                            anchors.centerIn: parent

                            text:"当前选择"
                            bkColor :  "lightgreen"
                            frameColor: "lightgreen"

                            onClicked:{

                                var lvm = musicSectionModel.get(mlvmidx);

                                var com = Qt.createComponent("MusicMatcherDialog.qml");
                                var o = com.createObject(root);

                                o.loadMatcher(root, root.baseUrl, musicUrl, lvm);
                            }
                        }
                    }

                    Rectangle{
                        width:parent.width
                        height: parent.height/2

                        Label {
                            id:musicPhoto

                            anchors.top : parent.top

                            width: parent.width
                            height:24
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment:  Text.AlignHCenter
                            text:mlvmSelectedImageTitle

                            font.pixelSize: 16

                        }
                    }
                }

                    Column{
                        width: parent.height
                        height: parent.height

                        Rectangle{
                            width:parent.width
                            height: parent.height/2

                            FramedBtutton {
                            id:musicTry

                            width:parent.width*2/3
                            height: 24
                            anchors.centerIn: parent

                            text:"转换音色"
                            bkColor : "lightgreen"
                            frameColor: "lightgreen"
                            }
                        }

                        Rectangle{
                            id:tuneContainer

                            visible:mlvmHaveTunes ? true:false

                            width:parent.width
                            height: parent.height/2
                            property int btwidth:(width - 24)/2
                            property int btheight:24

                            CheckButton {
                                id:cbt0
                                width:  tuneContainer.btwidth
                                height: tuneContainer.btheight
                                x:parent.width/4 - width/2
                                y:0

                                checked:false
                                index:0
                                bttext:"音色1"
                                colorChecked:"lightgreen"
                                colorUnchecked:"lightgray"
                                colorBgChecked:"lightgreen"
                                colorBgUnchecked:"white"
                                onClicked: {
                                    checked = true;
                                    cbt1.checked = false;
                                    cbt2.checked = false;

                                    tunePlayer.stop();
                                    tunePlayer.source = mlvmTune0;
                                    tunePlayer.play();
                                    //console.log("tune 0: ", mlvmTune0);
                                    }
                                }

                            CheckButton {

                                id:cbt1
                                width:  tuneContainer.btwidth
                                height: tuneContainer.btheight

                                x:parent.width*3/4 - width/2
                                y:0

                                checked:false
                                index:1
                                bttext:"音色2"
                                colorChecked:"lightgreen"
                                colorUnchecked:"lightgray"
                                colorBgChecked:"lightgreen"
                                colorBgUnchecked:"white"
                                onClicked: {
                                    checked = true;
                                    cbt0.checked = false;
                                    cbt2.checked = false;

                                    tunePlayer.stop();
                                    tunePlayer.source = mlvmTune1;
                                    tunePlayer.play();
                                    //console.log("tune 0: ", mlvmTune1);
                                    }
                            }

                            CheckButton {

                                id:cbt2
                                width:  tuneContainer.btwidth
                                height: tuneContainer.btheight
                                x:parent.width/4 - width/2
                                y:30

                                checked:false
                                index:2
                                bttext:"音色3"
                                colorChecked:"lightgreen"
                                colorUnchecked:"lightgray"
                                colorBgChecked:"lightgreen"
                                colorBgUnchecked:"white"
                                onClicked: {
                                    checked = true;
                                    cbt1.checked = false;
                                    cbt0.checked = false;

                                    tunePlayer.stop();
                                    tunePlayer.source = mlvmTune2;
                                    tunePlayer.play();
                                    }
                            }

                        }
                    }

                    Rectangle{
                        width: parent.width - parent.height*3 - parent.height/2
                        height: parent.height

                        visible: false
                        //color: colorOfBk

                        Row {
                        anchors.fill : parent
                        leftPadding: 8
                        rightPadding: 8
                        spacing: 8



                        TitleImage {
                        id:image00
                        width: parent.height/2*3
                        height: parent.height
                        source:mlvmImage0
                        text:mlvmImageTitle0
                        checked: mlvmSelected == 0 ? true : false

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                            mlvmSelectedImageTitle = mlvmImageTitle0;
                            mlvmSelected = 0;

                            image00.checked = true;
                            image01.checked = false;
                            image02.checked = false;

                            var sec = course.sections[mlvmidx];
                            sec["selected"] = 0;
                            }
                        }
                    }

                        TitleImage {
                        id:image01
                        width: parent.height/2*3
                        height: parent.height
                        source:mlvmImage1
                        text:mlvmImageTitle1
                        checked: mlvmSelected == 1 ? true : false
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                            mlvmSelectedImageTitle = mlvmImageTitle1;
                            mlvmSelected = 1;
                            image00.checked = false;
                            image01.checked = true;
                            image02.checked = false;
                            var sec = course.sections[mlvmidx];
                            sec["selected"] = 1;
                            }
                        }
                    }

                        TitleImage {
                        id:image02
                        width: parent.height/2*3
                        height: parent.height
                        source:mlvmImage2
                        text:mlvmImageTitle2
                        checked: mlvmSelected == 2 ? true : false

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                            mlvmSelectedImageTitle = mlvmImageTitle2;
                            mlvmSelected = 2;
                            image00.checked = false;
                            image01.checked = false;
                            image02.checked = true;
                            var sec = course.sections[mlvmidx];
                            sec["selected"] = 2;
                            }
                        }
                    }
                        }
                }
            }

                Rectangle{
                    width: parent.width - 20
                    height: 1
                    color: "darkgray"
                    x:10
                }
            }
        }

    }

    Column {
        anchors.fill: parent

       ListView {
        id:musicListView
        width: parent.width
        height: parent.height


        //orientation:ListView.Horizontal
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        Layout.fillWidth: true
        Layout.fillHeight: true
        ScrollBar.vertical: ScrollBar {active: true}


        model: musicSectionModel

        delegate:delegateListView

     }
    }
}
