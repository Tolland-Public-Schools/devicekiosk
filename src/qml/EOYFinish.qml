import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    
    function verifyForm() {
        if (inputEmail.text.toString().length > 0) {        
            btnSubmit.enabled = true
        }
        else {
            btnSubmit.enabled = false
        }
    }

    function setFocus() {
        inputEmail.focus = true
        inputEmail.forceActiveFocus()
    }

    property var chargerReturned: true

    
    
    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtHeader
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Enter an email address to receive the return files.\nEmail will also be sent to: " + ui.getEOYEmailAddresses() + "\nFiles will be backed up this computer in the event something goes wrong."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        // AnimatedImage {
        //     id: image
        //     Layout.alignment: Qt.AlignHCenter
        //     source: "../images/dropoff.gif"
        //     fillMode: Image.Image.PreserveAspectCrop
        // }

        TextField {
            id: inputEmail
            placeholderText: qsTr("Email Address")
            font.pointSize: 20
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: TextInput.AlignHCenter
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
            id: btnSubmit
            text: "Submit Returns"
            enabled: false
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                ui.submitEOYFinish(inputEmail.text)
            }
        }

        Button {
            id: btnMenu
            text: "Return to EOY Menu"
            enabled: true
            font.pointSize: 20
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                contentFrame.push(Qt.createComponent("EOYStart.qml"))
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
