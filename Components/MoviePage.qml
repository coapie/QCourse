import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


Page {
    id:root
    anchors.fill : parent

    property  bool loaded: false
    //property string colorOfBk: "#EAEAEA"

    property string coursePath
    property string baseUrl
    property var course: Object()

    function loadMovie(courseModel)
    {
        if(loaded)
            return;

        loaded = true;

        root.coursePath = courseModel.coursePath ;
        root.baseUrl = "file:///" + root.coursePath;

        console.log("load course from config file:", root.coursePath + "/manifest.qmm");

        var jsonRaw = misc.readFile(root.coursePath  + "/manifest.qmm");
        root.course = JSON.parse(jsonRaw);

        /*"movies" : [{
            "index":0,
            "movie":"可爱的野马.mpg",
            "image":"可爱的野马.jpg",
            "selected":-1,
            "right":0
        }]*/

        movieSectionModel.clear();

        for (var i in course.movies)
        {
            var movie = course.movies[i];
            var gvm  = Object();

            gvm.mlvmindex       = movie["index"];
            gvm.mlvmmovie       = movie["movie"];
            gvm.mlvmimage       = movie["image"];
            gvm.mlvmright       = movie["right"];
            gvm.mlvmselected    = movie["selected"];
            gvm.mlvmimageUrl    = baseUrl + "/" + gvm.mlvmimage;
            gvm.mlvmmovieUrl    = baseUrl + "/" + gvm.mlvmmovie;
            gvm.mlvmmusicTitle  = "";

            //console.log("index:", gvm.index, " movie:", gvm.movie, " image:", gvm.image, " right:", gvm.right, " selected:", gvm.selected);

            movieSectionModel.append(gvm);
        }

    }

    header:PageTitleBar{
            id:titleBar
            width:parent.width
            height: 32
            mainTitle: "观看视频"
            subTitle: "(通过观看没有声音的动态画面，聆听若干段候选音乐，选择最合适画面的音乐搭配画面)"
        }

    signal selected(int movieIndex, int musicIndex)

    onSelected:
    {
        var gvModel = movieSectionModel.get(movieIndex);

        gvModel.mlvmselected = musicIndex;

        var music = root.course.musics[musicIndex];
        gvModel.mlvmmusicTitle = misc.getBaseName(music["music"]);

        var movie = root.course.movies[movieIndex];
        movie["selected"] = musicIndex;


        var comp = Qt.createComponent("MoviePlayer.qml");
        var obj  = comp.createObject(root);
        var musicUrl = baseUrl + "/" + music["music"];

        console.log("movie  : ", gvModel.mlvmmovieUrl, " music", musicUrl);
        obj.playMovie(misc.getBaseName(gvModel.mlvmmovie), gvModel.mlvmmovieUrl, musicUrl, true);
    }


    ListModel{
        id:movieSectionModel
    }


    Component{
        id:delegateListView

        Rectangle {
            width:movieListView.width
            height: 180
            //color: colorOfBk

            Column{
                anchors.fill: parent
                width:parent.width

                Rectangle{
                    width: parent.width - 20
                    height: 1
                    color: "darkgray"
                    x:10
                }


                Row{
                    id:movieSecionContainer
                    x:0;y:1
                    width: parent.width
                    height: parent.height - 2

                    spacing: 6
                    leftPadding: 10

                    Rectangle{
                        id:movieImageContainer
                        width:parent.height * 3/2
                        height: parent.height
                        //color:colorOfBk

                        Image {
                            id:movieImage
                            width: parent.width - 32
                            height: parent.height - 32
                            x:16;y:16
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectCrop
                            source:mlvmimageUrl


                        Image {
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            source:"../images/play.png"
                        }

                        MouseArea{
                        anchors.fill : parent
                        onClicked: {

                            var comp = Qt.createComponent("MoviePlayer.qml");
                            var obj  = comp.createObject(root);
                            obj.playMovie(misc.getBaseName(mlvmmovie), mlvmmovieUrl, "", false);
                        }
                        }
                        }
                    }


                    Rectangle{
                        width:parent.width - movieImageContainer.width
                        height: parent.height
                        //color: colorOfBk

                        Column{
                            width: parent.width
                            height: parent.height

                            spacing: 4
                            topPadding: 10

                            Label {
                                id:movieTitle

                                width:240
                                height: 32
                                font.pixelSize: 24

                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft

                                text: misc.getBaseName(mlvmmovie)
                            }

                            BoxSelect {
                                id:boxSelect
                                width:320
                                height: parent.height - movieTitle.height - 40
                                y:10
                                color: "lightgray"
                                movieIndex:mlvmindex
                                callerObj: root

                                Component.onCompleted: {
                                    if(mlvmselected >= 0)
                                    {
                                        boxSelect.setChecked(mlvmindex, mlvmselected, false);
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

        /*Rectangle{
            id:musicTitle
            width:parent.width
            height: 40
            color: colorOfBk

            Column{
                id:columnTitleContainer
                anchors.fill : parent
                Row {
                    id:rowContainer
                    width:parent.width
                    height: 32

                    leftPadding: 16

                    Label {
                        id:headerTitile
                        text:"观看视频"
                        font.pixelSize: 16
                        width: 80
                        height: parent.height
                        topPadding: 4

                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                    }
                    Label {
                        text:"(通过观看没有声音的动态画面，聆听若干段候选音乐，选择最合适画面的音乐搭配画面)"
                        font.pixelSize: 12
                        width: parent.width - headerTitile.width
                        height: parent.height
                        topPadding: 4
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft | Text.AlignBottom
                    }
                }

                Row{
                        width:parent.width
                        height: parent.height - rowContainer.height

                        Repeater{
                            id:musicSectionSlider
                            anchors.fill : parent
                            model:100

                            Rectangle
                            {
                                y:2
                                width: musicSectionSlider.width/100
                                height: musicSectionSlider.height - 4
                                color: "gray"
                            }
                        }
                }
            }
        }*/


        ListView {
            id:movieListView
            width: parent.width
            height: parent.height


            //orientation:ListView.Horizontal
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            ScrollBar.vertical: ScrollBar {active: true}


            model: movieSectionModel

            delegate:delegateListView
        }
    }
}
