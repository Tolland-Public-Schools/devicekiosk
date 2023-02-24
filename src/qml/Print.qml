import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Connections {
        target: ui
        function onEnableNextSignal() {
            btnNext.enabled = true
        }
    }

    Component.onCompleted: {
        ui.printTicket()
    }

    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtEmail
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "A copy of your ticket is printing. Please tape it to your device."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        AnimatedImage {
            id: image
            Layout.alignment: Qt.AlignHCenter
            source: "../images/print.gif"
            fillMode: Image.Image.PreserveAspectCrop
        }

        Button {
            id: btnNext
            text: "Next"
            enabled: false
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                ui.submitPrint()
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
    // Timer {
    //     interval: 100
    //     running: true
    //     repeat: false
    //     onTriggered: printTicket()
    // }
}
