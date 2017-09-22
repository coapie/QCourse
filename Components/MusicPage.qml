import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


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

                    Rectangle{
                    width:parent.height
                    height: parent.height
                    //color: colorOfBk


                    FramedBtutton {
                    id:musicTry

                    width:parent.width*2/3
                    height: 24
                    anchors.centerIn: parent

                    text:"试听"
                    //bkColor : colorOfBk
                    frameColor: "darkgray"
                    onClicked: {
                        var lvm = musicSectionModel.get(mlvmidx);

                        var com = Qt.createComponent("MusicMatcher.qml");
                        var o = com.createObject(root);

                        o.playSection(root, root.baseUrl, musicUrl, lvm);
                    }
                    }
                }

                    Column{
                    width: parent.height
                    height: parent.height

                    spacing: 10
                    //topPadding: 24

                    Rectangle{
                        width:parent.width
                        height: parent.height/2
                        //color: colorOfBk

                    FramedBtutton{
                        id:musicSelect

                        width: parent.width
                        height:24
                        anchors.bottom: parent.bottom

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
                        //color:colorOfBk

                    Label {
                        id:musicPhoto

                        anchors.top: parent.top

                        width: parent.width
                        height:24
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text:mlvmSelectedImageTitle
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
