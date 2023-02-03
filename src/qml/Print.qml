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
    }
    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtEmail
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "A copy of your ticket is printing. Please tape it to your device."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        // TextField {
        //     id: inputSerial
        //     // placeholderText: qsTr("Email Address")
        //     font.pointSize: 20
        //     Layout.fillWidth: true
        //     Layout.fillHeight: true
        //     focus: true
        //     onTextChanged: {
        //         verifyEmail()
        //     }
            
        //     Component.onCompleted: {
        //         console.log("inputEmail loaded")
        //         this.focus = true
        //         this.forceActiveFocus()
        //     }
        // }

            Button {
            id: btnNext
            text: "Next"
            enabled: false
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                ui.submitSerial(inputSerial.text)
                // ui.startOver()
            }
        }
    }
}
