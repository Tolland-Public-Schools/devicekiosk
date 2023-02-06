import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {

    function verifyEmail() {
        var pattern = "@tolland.k12.ct.us"
        if (inputEmail.text.toString().search(pattern) >= 0) {        
            // console.log("email valid")
            btnEmailNext.enabled = true
        }
        else {
            btnEmailNext.enabled = false
        }
    }

    function setFocus() {
        inputEmail.focus = true
        inputEmail.forceActiveFocus()
    }

    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtEmail
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Please enter your email address below and tap 'Next'."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        TextField {
            id: inputEmail
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
            id: btnEmailNext
            text: "Next"
            enabled: false
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                ui.submitEmail(inputEmail.text)
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
