import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {

    function verifyForm() {
        if (
            inputFirst.text.toString().length >= 0 &&
            inputLast.text.toString().length >= 0 &&
            inputID.text.toString().length >= 0
        ) {        
            btnNext.enabled = true
        }
        else {
            btnNext.enabled = false
        }
    }

    function setFocus() {
        inputFirst.focus = true
        inputFirst.forceActiveFocus()
    }

    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtInstructions
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Please enter your first name, last name, and student ID then click 'Next'"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        TextField {
            id: inputFirst
            placeholderText: qsTr("First Name")
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
        TextField {
            id: inputLast
            placeholderText: qsTr("Last Name")
            font.pointSize: 20
            Layout.fillWidth: true
            Layout.fillHeight: true
            focus: true
            onTextChanged: {
                verifyForm()
            }
        }
        TextField {
            id: inputID
            placeholderText: qsTr("Student ID Number")
            font.pointSize: 20
            Layout.fillWidth: true
            Layout.fillHeight: true
            focus: true
            onTextChanged: {
                verifyForm()
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
                var userInfo = [inputFirst.text, inputLast.text, inputID.text]
                // ui.firstName = inputFirst.text
                // ui.lastName = inputLast.text
                // ui.studenID = inputID.text
                ui.submitUser(userInfo)
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
