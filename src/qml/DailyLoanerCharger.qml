import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Connections {
        target: ui        

        function onShowOutstandingLoansSignal(serials) {
            txtInstructions.text += "\nNOTE: The following charger(s) are currently checked out by this student: " + serials + "\n"
        }
    }
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
            id: txtInstructions
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Take a charger from the 'loaner' area. This charger *must* be returned by the end of the school day. Use the barcode scanner to scan the barcode sticker on the charger."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        // AnimatedImage {
        //     id: image
        //     Layout.alignment: Qt.AlignHCenter
        //     source: "../images/loaner.gif"
        //     fillMode: Image.Image.PreserveAspectCrop
        // }


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
                // console.log("inputEmail loaded")
                this.focus = true
                this.forceActiveFocus()
                ui.checkForOustandingLoans()
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
                ui.submitLoaner(inputSerial.text)
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
