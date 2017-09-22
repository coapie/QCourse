import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Row {
    id:root

    property var lvmMusic:Object()
    property var lvmMovie:Object()
    property var musicUrl


    function loadMusic(musicModel)
    {
        lvmMusic = musicModel;

        root.musicUrl = lvmMusic.coursePath + "/manifest.qmm";
        console.log("xxmusic config:",root.musicUrl );

        musicPage.loadMusic(musicModel);
    }

    function loadMovie(movieModel)
    {
        lvmMovie = movieModel;
        moviePage.loadMovie(lvmMovie)
    }


    ListModel {
        id:siderBarModel

        ListElement {
            sblvmIndex:0
            sblvmImageNormal: "../images/00.jpg"
            sblvmImageSelected:"../images/01.jpg"
            sblvmPageIndex:0
        }

        ListElement {
            sblvmIndex:1
            sblvmImageNormal: "../images/10.jpg"
            sblvmImageSelected:"../images/11.jpg"
            sblvmPageIndex:1
        }

        ListElement {
            sblvmIndex:2
            sblvmImageNormal: "../images/20.jpg"
            sblvmImageSelected:"../images/21.jpg"
            sblvmPageIndex:2
        }

        ListElement {
            sblvmIndex:3
            sblvmImageNormal: "../images/30.jpg"
            sblvmImageSelected:"../images/31.jpg"
            sblvmPageIndex:3
        }
    }

    Column {
        id:columnContainer
        width:180
        height: parent.height

        Rectangle {
            id:paddingRect
            width: parent.width
            height: 34
            color:"#EAEAEA"
        }
        Rectangle {
            width:parent.width
            height: parent.height - paddingRect.height
            color:"#EAEAEA"

            ListView {
            id:siderBarListView
            anchors.fill: parent


            model: siderBarModel
            delegate: Image {
                id:siderBarItem
                width:parent.width
                height: 130

                source: (siderBarListView.currentIndex == sblvmIndex) ?sblvmImageSelected:sblvmImageNormal
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("silder bar : ", sblvmIndex, "stack cur:", stackContainer.currentIndex);
                        siderBarListView.currentIndex = sblvmIndex;
                        stackContainer.currentIndex = sblvmIndex;

                        if(sblvmIndex == 1){
                            moviePage.loadMovie(lvmMovie)
                        }

                        if(sblvmIndex == 2){
                            submitPage.setCouse(musicPage.course, moviePage.course);
                        }

                        if(sblvmIndex == 3){
                            var movieBaseUrl = lvmMovie.coursePath + "/manifest.qmm";

                            savePage.setCourse(root.musicUrl, musicPage.course, movieBaseUrl, moviePage.course);

                        }
                    }
                }
            }

        }
           }
    }


    StackLayout
    {
        id:stackContainer
        width:parent.width - columnContainer.width
        height: parent.height

        MusicPage {
            id:musicPage
            anchors.fill : parent
        }

        MoviePage {
            id:moviePage
            anchors.fill : parent
        }

        SubmitPage {
            id:submitPage
            anchors.fill : parent
        }

        SavePage{
            id:savePage
            anchors.fill : parent
        }
    }

}
