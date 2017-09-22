import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QMisc 1.0

import "Components"

ApplicationWindow {
    id:root
    visible: true
    width: 1024
    height: 768
    title: qsTr("丝路音画-公共艺术")

    property bool fullScreen: false
    //flags: Qt.FramelessWindowHint | Qt.Window


    Component.onCompleted:
    {
        var course = misc.appDir + "/../QCourse.conf";
        var courseRoot = misc.getFilePath(course);

        var jsonRaw = misc.readFile(course);
        var courseConf = JSON.parse(jsonRaw);


        for (var i in courseConf.QMusicProjects)
        {
            var music = courseConf.QMusicProjects[i];
            var lmmusic = Object;

            lmmusic.courseType = "音图匹配";
            lmmusic.courseID = "QMusic";

            lmmusic.courseTitle = music.name;
            lmmusic.coursePath = courseRoot + "/" + music.path;

            siderBar.loadMusic(lmmusic);
        }

        for (var j in courseConf.QMovieProjects)
        {
            var movie = courseConf.QMovieProjects[j];
            var lmmovie = Object;

            lmmovie.courseType = "影音匹配";
            lmmovie.courseID = "QMovie";
            lmmovie.courseTitle = movie.name;
            lmmovie.coursePath =  courseRoot + "/" + movie.path;
            siderBar.loadMovie(lmmovie);
       }

    }

    Misc {
        id:misc
    }

    Column {
        x:0;y:0
        anchors.fill : parent

        Rectangle{
            id:titleContainer
            width : parent.width
            height: 0
            color: "#7FCE9B"

            MouseArea {
                anchors.fill: parent;
                property var startPos: "0,0";
                onPressed: {
                    startPos = Qt.point(mouse.x,mouse.y);
                }
                onPositionChanged: {
                    var d = Qt.point(mouse.x - startPos.x, mouse.y - startPos.y);
                    root.x =  root.x + d.x; root.y = root.y + d.y;
                }
            }

            RowLayout {
                anchors.fill: parent
                Button {
                    id:closeButton
                    width:24
                    height: 24
                    anchors.right: parent.right

                    text:"x"
                    onClicked: {
                        root.close();
                    }

                    background: Rectangle{
                        anchors.fill: parent
                        color: "#7FCE9B"
                    }
                }

                Button {
                    id:enlargeButton
                    width:24
                    height: 24
                    anchors.right: closeButton.left

                    text:"[]"
                    onClicked: {
                        if(fullScreen){
                            root.showNormal();
                            fullScreen = false;
                        }else{
                            root.showMaximized();
                            fullScreen = true;
                        }
                    }
                    background: Rectangle{
                        anchors.fill: parent
                        color: "#7FCE9B"
                    }
                }

                Button {
                    id:miniButton
                    width:24
                    height: 24
                    anchors.right: enlargeButton.left

                    text:"_"

                    onClicked: {
                        root.showMinimized()
                    }
                    background: Rectangle{
                        anchors.fill: parent
                        color: "#7FCE9B"
                    }
                }
            }
        }


        SiderBar {
            id:siderBar
            width: parent.width
            height: parent.height - titleContainer.height
        }
    }
}
