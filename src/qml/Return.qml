import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtEmail
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Please place your device in the 'Drop Off' area."
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
            enabled: true
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                ui.submitDropOff()
            }
        }
    }
}
