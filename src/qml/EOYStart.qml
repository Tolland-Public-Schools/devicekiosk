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

            text: "EOY Return"
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

        // Image {
        //     id: image
        //     width: 100
        //     height: 100
        //     source: "../images/logo.png"
        //     Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        //     fillMode: Image.PreserveAspectFit
        // }

        Button {
            id: btnDropOff
            text: "Begin Returns"
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: {
                contentFrame.push(Qt.createComponent("EOYReturn.qml"))
            }
        }
        Button {
            id: btnPickUp
            text: "Submit Saved Returns"
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: {
                contentFrame.push(Qt.createComponent("EOYFinish.qml"))
            }
        }
    }
}
