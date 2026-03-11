import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Connections {
        target: ui        

        Component.onCompleted: {
            appWindow.setInitialPage()
        }
    }

    function firstLastInputChange(){
        verifyForm()
        setEmail()
    }

    function setEmail() {
        if (ui.getServiceMode() == 7) {
            inputEmail.text = inputFirst.text[0].toLowerCase() + inputLast.text.toLowerCase() + "@tolland.k12.ct.us"
        }
    }
    
    function verifyForm() {
        if (inputFirst.text.toString().length > 0 &&
            inputLast.text.toString().length > 0 &&
            (inputID.text.toString().length > 0 || ui.getServiceMode() == 7)
        ) {        
            btnNext.enabled = true
        }
        else {
            btnNext.enabled = false
        }
    }

    function setupUsers() {
        configureUser()
        inputFirst.focus = true
        inputFirst.forceActiveFocus()
    }

    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Label {
            id: txtInstructions
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Please enter your first name, last name, and student ID then tap 'Next'."
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
                firstLastInputChange()
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
                firstLastInputChange()
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
        TextField {
            id: inputEmail
            placeholderText: qsTr("Email Address")
            font.pointSize: 20
            Layout.fillWidth: true
            Layout.fillHeight: true
            focus: true
            visible: false
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
                var userInfo = [inputFirst.text, inputLast.text, inputID.text, inputEmail.text]
                // ui.firstName = inputFirst.text
                // ui.lastName = inputLast.text
                // ui.studenID = inputID.text
                ui.submitUser(userInfo)
                // ui.startOver()
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

    // Automatically go to a non-standard kiosk mode start page
    function configureUser() {
        switch(ui.getServiceMode()) {
            case 7:
                // serviceMode = 7
                inputID.visible = false
                inputEmail.visible = true
                break;
            default:
                break;
        }
    }

    // Setting focus any other way doesn't seem to work. 
    // Kind of kludge, but works
    Timer {
        interval: 100
        running: true
        repeat: false
        onTriggered: setupUsers()
    }
}
