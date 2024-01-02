import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Connections {
        target: ui        

        function onSetHomeroomLabelSignal(homeroom) {
            txtInstructions.text += "Please enter the teacher or room number of your " + homeroom
        }
    }

    function verifyForm() {
        if (inputHomeroom.text.toString().length > 0) {        
            btnNext.enabled = true
        }
        else {
            btnNext.enabled = false
        }
    }

    function setFocus() {
        inputHomeroom.focus = true
        inputHomeroom.forceActiveFocus()        
    }
    

    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtInstructions
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: ""
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

            Component.onCompleted: {
                ui.getAndSetHomeroomName()
            }

        }

        TextField {
            id: inputHomeroom
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
                ui.submitHomeroom(inputHomeroom.text)
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
