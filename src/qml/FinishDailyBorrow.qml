import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Connections {
        target: ui
    }
    
    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtMessage
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "You *must* return your loaner by the end of the school day at this kiosk.\nPlease click Finish below."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        Text {
            id: txtError
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: ""
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30
            enabled: false
            color: "red"
        }

        Button {
            id: btnNext
            text: "Finish"
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
