import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {

    function verifyDescription() {
        if (inputDescription.text.toString().length > 0) {        
            btnNext.enabled = true
        }
        else {
            btnNext.enabled = false
        }
    }

    function setFocus() {
        inputDescription.focus = true
        inputDescription.forceActiveFocus()
    }

    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtDescription
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "Please describe the problem then tap 'Next'."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        TextArea {
            id: inputDescription
            wrapMode: Text.WordWrap
            placeholderText: qsTr("Description")
            font.pointSize: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
            focus: true
            onTextChanged: {
                verifyDescription()
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
                ui.submitDescription(inputDescription.text)
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

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:2}D{i:3}D{i:4}D{i:1}D{i:5}
}
##^##*/
