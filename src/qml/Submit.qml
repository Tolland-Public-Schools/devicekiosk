import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Connections {
        target: ui
        function onEnableNextSignal() {
            txtMessage.text = "Ticket sumbmitted, please tap 'Next'"
            btnNext.enabled = true
        }
    }

    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtMessage
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Please wait while your ticket is submitted..."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }        

        Button {
            id: btnNext
            text: "Next"
            enabled: false
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                ui.submitTicketPage()
            }

            // Component.onCompleted: {
            //     ui.submitTicket()
            // }
        }
    }
    Timer {
        interval: 500
        running: true
        repeat: false
        onTriggered: ui.submitTicket()
    }
}
