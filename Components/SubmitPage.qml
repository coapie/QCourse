import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QMisc 1.0

Page {
    id:root
    anchors.fill : parent

    property int btWidth:160
    property int btHeight:24

    property var musicCourse : Object();
    property var movieCourse : Object();

    function setCouse(musicCourse, movieCourse)
    {
        root.musicCourse = musicCourse;
        root.movieCourse = movieCourse;

        musicModel.clear();
        var j = 0;
        for(var i in musicCourse.sections){
            var sec = musicCourse.sections[i];

            var lvmu = Object();
            lvmu.sectionIndex = j++;
            var sel = sec["selected"];

            lvmu.selected = sel;
            lvmu.right    = sec["right"];

            if( sel >= 0){
                lvmu.sectionImage = misc.getBaseName(sec["images"][sel]);
            }else{
                lvmu.sectionImage = "尚未选择";
            }

            musicModel.append(lvmu);
        }


        movieModel.clear();
        for(var i in movieCourse.movies){
            var sec = movieCourse.movies[i];

            var lvmu = Object();

            lvmu.movieName = misc.getBaseName(sec["movie"]);
            lvmu.movieIndex = sec["selected"];

            lvmu.selected = sec["selected"];
            lvmu.right    = sec["right"];

            movieModel.append(lvmu);
        }

    }

    Misc {
        id:misc
    }

    ListModel{
        id:musicModel

        ListElement{
            sectionIndex:0
            sectionImage:"空旷的草原"

        }
    }

    ListModel{
        id:movieModel
    }

    header:PageTitleBar{
            id:titleBar
            width:parent.width
            height: 32
            mainTitle: "提交选择"
        }

    Column {
        id:columnContainer

        width: parent.width
        height: parent.height - titleBar.height - submitContainer.height
        topPadding: 20

        Row {
            id:musicContainer
            width: parent.width
            height:parent.height/2

            Label {
                id:labelMusic
                width:btWidth
                height: 24
                text:"音乐匹配选择："

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            ListView{
                id:musicMatcher
                width: parent.width - labelMusic.width
                height: parent.height
                spacing: 8

                model: musicModel
                delegate: Row {
                    width: btWidth * 3
                    height: btHeight
                    spacing: 32

                    Label{
                        width:btWidth
                        height: 24
                        text:"音乐段落" + sectionIndex

                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        background: Rectangle {
                            anchors.fill: parent
                            color:"darkgray"

                            Rectangle{
                                width:parent.width - 4
                                height: parent.height -4
                                x:2;y:2

                                color: "#EAEAEA"
                            }
                        }
                    }


                    Label{
                        width:btWidth
                        height: 24
                        text:sectionImage

                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        background: Rectangle {
                            anchors.fill: parent
                            color:"#66D19C"
                        }
                    }
                }

            }
        }

        Row{
            id:movieContainer
            width: parent.width
            height:parent.height

            Label {
                id:labelMovie
                width:btWidth
                height: 24
                text:"影音匹配选择："

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            ListView{
                id:movieMatcher
                width: parent.width - labelMusic.width
                height: parent.height
                spacing: 8

                model: movieModel
                delegate: Row {
                    width: btWidth * 3
                    height: btHeight
                    spacing: 32

                    Label{
                        width:btWidth
                        height: 24
                        text: movieName

                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        background: Rectangle {
                            anchors.fill: parent
                            color:"darkgray"

                            Rectangle{
                                width:parent.width - 4
                                height: parent.height -4
                                x:2;y:2

                                color: "#EAEAEA"
                            }
                        }
                    }


                    Label{
                        width:btWidth
                        height: 24
                        text:"音乐 " + (movieIndex + 1)

                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        background: Rectangle {
                            anchors.fill: parent
                            color:"#66D19C"
                        }
                    }
                }

            }
        }
    }
    SubmitDialog{
        id:submitDialog
    }

    Rectangle{
        id:submitContainer
        width: parent.width
        height: 32
        anchors.top: columnContainer.bottom

        Button{
            width: 256
            height: 24
            anchors.centerIn: parent

            text:"提交选择"
            background: Rectangle{
                anchors.fill : parent
                color:"#66D19C"
            }

            onClicked: {
                musicCourse = musicCourse;
                root.movieCourse = movieCourse;

                var message = Object();
                message.musicscores = "得分情况:";

                var times = 0;
                for (var i = 0; i < musicModel.count; i++)
                {
                    var lvm = musicModel.get(i);

                    if(lvm.right == lvm.selected)
                    {
                        times ++;
                        message.musicscores += i + ":right,";
                    }else
                    {
                        message.musicscores += i + ":wrong,";
                    }
                }

                message.scoremusic  = (times/musicModel.count)*100;

                message.moviescores = "得分情况:";
                lvm.scoremovie = 0;
                var score = 0;

                for (var i = 0; i < movieModel.count; i++)
                {
                    var lvm = movieModel.get(i);
                             //console.log("right:", lvm.right, "  selected:", lvm.selected);
                    if(lvm.selected === lvm.right)
                    {
                        score += lvm.scoremovie;
                         message.moviescores += i + ":" + lvm.score + ",";
                     }else{

                                 message.moviescores += i + ":0,";
                             }
                    }

                         message.scoremovie  = score;
                         submitDialog.messageSend = message;

                         console.log(JSON.stringify(message));

                submitDialog.open();
                }
        }
    }
}
