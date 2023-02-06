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

        function onShowErrorSignal(error) {
            txtError.enabled = true
            txtError.text = "Error: " + error
            // console.log(error)
        }
    }

    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtMessage
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Please wait while your ticket is submitted."
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
            text: "Next"
            enabled: false
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                ui.submitPrint()
            }

            // Component.onCompleted: {
            //     ui.submitTicket()
            // }
        }
    }
    Timer {
        interval: 500
        running: true
        repeat: false
        onTriggered: ui.submitTicket()
    }
}
