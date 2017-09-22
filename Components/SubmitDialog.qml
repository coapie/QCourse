import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtMultimedia 5.8
import QtQuick.Window 2.2
import QtQml 2.2
import QtWebSockets 1.1

import QMisc 1.0




Dialog {
        id:sendDialog
        width: 256
        height: 128

        property var messageSend:Object()

        Column{
            anchors.fill: parent
            spacing: 8

            Row {
                width: parent.width
                height: 24
                spacing:4
                Label{
                    width:64
                    height:parent.height
                    text:"地址："
                }

                TextField {
                    height: parent.height
                    width:parent.width - 64
                        id: addressServer
                        focus: true
                        readOnly: false
                }
            }

            Row {
                width: parent.width
                height: 24
                spacing:4
                Label{
                    width:64
                    height:parent.height
                    text:"学号："
                }

                TextField {
                    height: parent.height
                    width:parent.width - 64
                        id: studentID
                        focus: true
                        readOnly: false
                }
            }

            Row {
                width: parent.width
                height: 24
                spacing:4
                Label{
                    width:64
                    height:parent.height
                    text:"姓名："
                }

                TextField {
                        id: studentName
                        height: parent.height
                        width:parent.width - 64
                        focus: true
                        readOnly: false
                }
            }
        }
        onAccepted: {
            messageSend.studentID = studentID.text;
            messageSend.studentName = studentName.text;
            var Url = "ws://" + addressServer.text + ":2345";

            console.log("set usl:", Url);
            socket.url = Url;
            socket.messageSend = messageSend;
            socket.active = true;
        }


    WebSocket {
           id: socket

           property var  messageSend

           onTextMessageReceived: {
               socket.active = false;
           }

           onStatusChanged: {
               console.log("send to:", socket.url);
               if (socket.status == WebSocket.Error) {
                   console.log("Client error: ", socket.errorString);
               } else if (socket.status == WebSocket.Closed) {
                   console.log(qsTr("Client socket closed."));
               }else if(socket.status == WebSocket.Open){
                    socket.sendTextMessage(JSON.stringify(messageSend));
                    console.log("send message:", JSON.stringify(messageSend));
               }
           }
       }
 }
