import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtWebSockets 1.1

import QMisc 1.0

ApplicationWindow {
    visible: true
    width: 1024
    height: 768
    title: qsTr("课程管理中心")

    property int tbWidth:64
    property int comboBoxIndex:0

    id:root

    WebSocketServer{
        id:serverWeb

        name: "qcourse"
        port:2345

        onClientConnected: {
            webSocket.onTextMessageReceived.connect(function(message) {
                console.log (message);

                var msgObj = JSON.parse(message);
                var lvm = Object();

                for(var i = 0; i <  lvmStudents.count; i++){
                    var m = lvmStudents.get(i);
                    if(m.lvmID === msgObj.studentID){
                        lvmStudents.remove(i);
                    }
                }

                lvm.lvmIndex = lvmStudents.count;
                lvm.lvmID = msgObj.studentID;
                lvm.lvmName = msgObj.studentName;


                lvm.lvmCourse = "音画匹配";
                lvm.lvmScore = msgObj.scoremusic;
                lvm.lvmScores = msgObj.musicscores;

                lvmStudents.append(lvm);

                lvm.lvmCourse = "影音匹配";
                lvm.lvmScore = msgObj.scoremovie;
                lvm.lvmScores = msgObj.moviescores;

                lvmStudents.append(lvm);

                webSocket.sendTextMessage(qsTr("received!"));
            });
        }

        onErrorStringChanged: {
            console.log(qsTr("Server error: ", errorString));
        }
    }

    Component.onCompleted:
    {
        //ipAddress.text = qsTr("服务器地址：") + misc.getIP();

        lvmStudents.clear();

        var ips = JSON.parse(misc.getIPToJSON());

        //console.log(misc.getIPToJSON());

        var mod = Object();
        for(var i in ips.IPs){
            mod.key = ips.IPs[i];
            mod.value = ips.IPs[i];
            comboBoxModel.append(mod);
        }

        if(comboBoxModel.count){
            comboBoxIPS.currentIndex = 0;
            comboBoxIndex = 0;


            var m = comboBoxModel.get(comboBoxIPS.currentIndex)

            serverWeb.host = m.key;
            console.log(serverWeb.url);
            serverWeb.accept = true;
            serverWeb.listen =  true;
        }
    }

    FileDialog{
        id:fdSave
        folder: shortcuts.home
        selectExisting:false

        onAccepted: {
            var students;
            students = "序号，课程，学号，姓名，分数，详情\n";

            for(var i = 0; i < lvmStudents.count; i++){
                var lvm = lvmStudents.get(i);
                students += lvm.lvmIndex + "," + lvm.lvmCourse + "," + lvm.lvmID + "," +
                        lvm.lvmName + "," + lvm.lvmScore + "," + lvm.lvmScores + "\n";
            }

            var ofile = misc.writeFile(misc.UrlToPath(fdSave.fileUrl), students);

          }
    }

    Column
    {
        id:columnContainer
        anchors.fill: parent
        spacing: 4

        ToolBar
        {
            id:toolBarContainer
            width:parent.width
            height: 32
            Row {
                anchors.fill: parent
                spacing: 8

            Label {
                id:ipAddress
                width: 80;
                height: parent.height
                text:qsTr("服务地址：") ;
                verticalAlignment:Text.AlignVCenter
                horizontalAlignment:Text.AlignHCenter
                font.bold: true
            }

            ComboBox {
                id:comboBoxIPS
                width: 240
                height: parent.height
                textRole: "key"

                model: ListModel{
                    id:comboBoxModel
                }

                onActivated: {
                    if(comboBoxIPS.currentIndex != comboBoxIndex){
                        comboBoxIndex = comboBoxIPS.currentIndex;

                        var m = comboBoxModel.get(comboBoxIPS.currentIndex)

                        serverWeb.host = m.key;
                        console.log(serverWeb.url);
                        serverWeb.accept = true;
                        serverWeb.listen =  true;
                    }
                }
            }

            }
          }


        ListView
        {
            id:lvStudents
            width:parent.width
            height: columnContainer.height - toolBarContainer.height


            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            Layout.fillWidth: true
            Layout.fillHeight: true
            ScrollBar.horizontal: ScrollBar { active: true }
            ScrollBar.vertical: ScrollBar { active: true }

            header : Rectangle {
                width: parent.width
                height: 32
                color:"#f0f0f0"


                Row
                {
                    id:lvheaderContainer
                    x:4;y:0
                    width:parent.width - 64
                    height:32
                    spacing:4

                    Label
                    {
                        width: 128;
                        height: parent.height
                        text:qsTr("课程")
                        verticalAlignment:Text.AlignVCenter
                        horizontalAlignment:Text.AlignHCenter

                        background: Rectangle{
                            anchors.fill:parent
                            color:"lightgray"
                        }

                    }

                    Label
                    {
                        width: 128;
                        height: parent.height
                        text:qsTr("学号")
                        verticalAlignment:Text.AlignVCenter
                        horizontalAlignment:Text.AlignHCenter

                        background: Rectangle{
                            anchors.fill:parent
                            color:"lightgray"
                        }

                    }

                    Label
                    {
                        width: 128;
                        height: parent.height
                        text:qsTr("姓名")
                        verticalAlignment:Text.AlignVCenter
                        horizontalAlignment:Text.AlignHCenter
                        background: Rectangle{
                            anchors.fill:parent
                            color:"lightgray"
                        }

                     }

                    Label
                    {
                        width: parent.width - 128*3;
                        height: parent.height
                        text:qsTr("得分")
                        verticalAlignment:Text.AlignVCenter
                        horizontalAlignment:Text.AlignHCenter
                        background: Rectangle{
                            anchors.fill:parent
                            color:"lightgray"
                        }

                    }

                }
                Button
                {
                    width: 64
                    height: parent.height
                    anchors.right : parent.right
                    text:qsTr("导出")
                    onClicked: {
                        fdSave.open();
                    }
                }
            }

            model: lvmStudents
            delegate:Rectangle {
                width: parent.width
                height: 32
                color: ((lvmIndex % 2)  == 0) ? "#f0f0f0" : "white"

                Row
                {
                    id:lvDelegateRowContainer
                    x:4;y:0
                    width:parent.width - 64
                    height:32
                    spacing:4

                    Label
                    {
                        width: 128;
                        height: parent.height
                        text: lvmCourse
                        verticalAlignment:Text.AlignVCenter
                        horizontalAlignment:Text.AlignHCenter

                    }

                    Label
                    {
                        width: 128;
                        height: parent.height
                        text:lvmID
                        verticalAlignment:Text.AlignVCenter
                        horizontalAlignment:Text.AlignHCenter


                    }
                    Label
                    {
                        width: 128;
                        height: parent.height
                        text:lvmName
                        verticalAlignment:Text.AlignVCenter
                        horizontalAlignment:Text.AlignHCenter

                    }

                    Label
                    {
                        width: parent.width - 128*3;
                        height: parent.height
                        text:lvmScores
                        verticalAlignment:Text.AlignVCenter
                        horizontalAlignment:Text.AlignHCenter

                    }


                }
            }
        }

        ListModel {
            id:lvmStudents
            ListElement {
                lvmIndex:0
                lvmCourse: "影音混搭"
                lvmID: "20170206"
                lvmName: "张三"
                lvmScore:50
                lvmScores:"total:50, 1:0, 2:12.5, 3:0, 4:12.5, 5:12.5, 6:0, 7:12.5, 8:0"

            }

            ListElement {
                lvmIndex:1
                lvmCourse: "影音混搭"
                lvmID: "20170206"
                lvmName: "李四"
                lvmScore:50
                lvmScores:"total:50, 1:0, 2:12.5, 3:0, 4:12.5, 5:12.5, 6:0, 7:12.5, 8:0"
            }

            ListElement {
                lvmIndex:2
                lvmCourse: "影音混搭"
                lvmID: "20170206"
                lvmName: "王五"
                lvmScore:50
                lvmScores:"total:50, 1:0, 2:12.5, 3:0, 4:12.5, 5:12.5, 6:0, 7:12.5, 8:0"
            }
        }
    }
    Misc{
        id:misc
    }
}
