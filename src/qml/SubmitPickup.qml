import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Connections {
        target: ui
        function onEnableNextSignal() {
            txtMessage.text = "Pickup processed, please tap 'Done'.\nHave a great day!"
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

            text: "Please wait while your pickup is processed..."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }        

        Button {
            id: btnNext
            text: "Done"
            enabled: false
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                ui.startOver()
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
        onTriggered: ui.processPickup()
    }
}
