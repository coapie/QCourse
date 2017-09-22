import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QtWebSockets 1.1

ApplicationWindow {
    visible: true
    width: 480
    height: 320
    title: qsTr("Network Test")

    WebSocket {
           id: socket

           onTextMessageReceived: {
                outPutData.append(message);
                socket.active = false;
           }

           onStatusChanged: {

               if (socket.status == WebSocket.Error) {
                   outPutData.append("Client error: " +  socket.errorString);
               } else if (socket.status == WebSocket.Closed) {
                   outPutData.append(qsTr("Client socket closed."));
               }else if(socket.status == WebSocket.Open){
                    socket.sendTextMessage("Are you hear me?");
                   outPutData.append("send test data to :" + socket.url);
               }
           }
       }

    Column {
        anchors.fill : parent
        spacing: 4

        Row {
            id:titleBar
            width: parent.width
            height: 24
            spacing: 4

            Label {

                height: parent.height
                width: 64
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                text:"目标地址:"
            }

            TextField {
                id:addressServer
                height: parent.height
                width:256
                    focus: true
                    readOnly: false
            }

            Button {
                id:sendTest
                height: parent.height
                width:48
                text:"测试"

                onClicked: {

                    var Url = "ws://" + addressServer.text + ":5432";

                    outPutData.append("----------------");
                    outPutData.append("connect to : " + Url);
                    socket.url = Url;
                    socket.active = true;
                }
            }
        }

        TextArea{
            id:outPutData

            x:4; y:4
            width: parent.width - 8
            height: parent.height - titleBar.height - 8
            readOnly: true

            background: Rectangle{
                anchors.fill : parent
                color:"#f0f0f0"

            }
        }
    }

}
