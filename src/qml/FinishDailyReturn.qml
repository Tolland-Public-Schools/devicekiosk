import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Connections {
        target: ui
        function onEnableNextSignal() {
            btnNext.enabled = true
        }

        // function onShowErrorSignal(error) {
        //     txtError.enabled = true
        //     txtError.text = "Error: " + error
        //     // console.log(error)
        // }

        function onShowErrorSignal(error) {
            console.log("Error: " + error)
            if (error != "") {
                txtMessage.text = "There was an error creating your ticket."
                txtError.enabled = true
                txtError.text = "Error: " + error
                btnNext.text = "Start Over"
            }            
        }
    }
    
    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtMessage
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Thank you for returning your loaner.\nPlease click Finish below."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        Text {
            id: txtError
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: ""
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30
            enabled: false
            color: "red"
        }

        Button {
            id: btnNext
            text: "Finish"
            enabled: true
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                ui.startOver()
            }
        }

        Component.onCompleted: {
            ui.checkForErrors()
        }
    }
}
