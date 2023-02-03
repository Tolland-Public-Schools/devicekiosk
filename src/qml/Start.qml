import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    ColumnLayout {
        anchors.fill: parent
        // spacing: 2

        Text {
            id: txtIntro
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Are you dropping off a device for repair or picking up a repaired device?"
            // anchors.fill: self
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30
            // fontSizeMode: Text.Fit
            // minimumPixelSize: 30
            // font.pixelSize: 1000
            
            // anchors.centerIn: self
        }

        Image {
            id: image
            width: 100
            height: 100
            source: "../images/logo.png"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            fillMode: Image.PreserveAspectFit
        }

        Button {
            id: btnDropOff
            text: "Dropping Off"
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: {
                // ui.toEmail()
                // contentFrame.push(Qt.createComponent("Email.qml"))
                ui.start(1)
            }
        }
        Button {
            id: btnPickUp
            text: "Picking up"
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: {
                // ui.toEmail()
                // contentFrame.push(Qt.createComponent("Email.qml"))
                ui.start(2)
            }
        }
    }
}
