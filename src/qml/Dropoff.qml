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

        AnimatedImage {
            id: image
            Layout.alignment: Qt.AlignHCenter
            source: "../images/dropoff.gif"
            fillMode: Image.Image.PreserveAspectCrop
        }

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
}
