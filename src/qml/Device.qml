import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {

    function verifyEmail() {
        if (inputSerial.text.toString().length >= 0) {        
            btnNext.enabled = true
        }
        else {
            btnNext.enabled = false
        }
    }

    function setFocus() {
        inputSerial.focus = true
        inputSerial.forceActiveFocus()
    }

    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtEmail
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Use the barcode wand to scan the barcode sticker on your device."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        TextField {
            id: inputSerial
            // placeholderText: qsTr("Email Address")
            font.pointSize: 20
            Layout.fillWidth: true
            Layout.fillHeight: true
            focus: true
            onTextChanged: {
                verifyEmail()
            }
            
            Component.onCompleted: {
                console.log("inputEmail loaded")
                this.focus = true
                this.forceActiveFocus()
            }
        }

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
    // Setting focus any other way doesn't seem to work. 
    // Kind of kludge, but works
    Timer {
        interval: 100
        running: true
        repeat: false
        onTriggered: setFocus()
    }
}
