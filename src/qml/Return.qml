import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {

    function verifyForm() {
        if (inputSerial.text.toString().length > 0) {        
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

            text: "Use the barcode scanner to scan the barcode sticker on the loaner.\nReturn your loaner to the 'Loaner' area. Be sure to plug laptops into power."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        AnimatedImage {
            id: image
            Layout.alignment: Qt.AlignHCenter
            source: "../images/return.gif"
            fillMode: Image.Image.PreserveAspectCrop
        }

        TextField {
            id: inputSerial
            // placeholderText: qsTr("Email Address")
            font.pointSize: 20
            Layout.fillWidth: true
            Layout.fillHeight: true
            focus: true
            onTextChanged: {
                verifyForm()
            }
            
            Component.onCompleted: {
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
                ui.submitReturn(inputSerial.text)
            }
        }
        Button {
            id: bntStartOver
            text: "Start Over"
            enabled: true
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                ui.startOver()
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
