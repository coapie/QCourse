import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QMisc 1.0
import QtWebSockets 1.1

ApplicationWindow {
    visible: true
    width: 480
    height: 320
    title: qsTr("Network Echo Back")

    property int comboBoxIndex

    Misc{
        id:misc

    }

    WebSocketServer{
        id:serverWeb

        name: "qcourse"
        port:5432

        onClientConnected: {
            webSocket.onTextMessageReceived.connect(function(message) {
                console.log (message);
                webSocket.sendTextMessage(message);
                textOut.append("Receive Message : " +message);
            });


            textOut.append("--------------------");
            textOut.append("Accept client login");
        }

        onErrorStringChanged: {
            textOut.append(qsTr("****Server error: " + errorString));
        }

    }


    Component.onCompleted:
    {
        var ips = JSON.parse(misc.getIPToJSON());

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

    Column{
        anchors.fill : parent
        spacing: 4

        ComboBox {
            id:comboBoxIPS
            width: parent.width
            height: 24
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

        TextArea{
            id:textOut
            width:parent.width
            height: parent.height - comboBoxIPS.height
            readOnly:  true
        }
    }


}
