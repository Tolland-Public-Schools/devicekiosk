import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    
    function verifyForm() {
        if (inputSerial.text.toString().length > 0) {        
            btnSubmit.enabled = true
        }
        else {
            btnSubmit.enabled = false
        }
    }

    function setFocus() {
        inputSerial.focus = true
        inputSerial.forceActiveFocus()
    }

    property var chargerReturned: true

    function chargerYesClicked() {
        console.log("Yes clicked")
        chargerReturned = true
        btnChargerYesText.color = "white"
        btnChargerYesRect.color = "green"
        btnChargerNoText.color = "red"
        btnChargerNoRect.color = "white"
    }

    function chargerNoClicked() {
        console.log("No clicked")
        chargerReturned = false
        btnChargerYesText.color = "green"
        btnChargerYesRect.color = "white"
        btnChargerNoText.color = "white"
        btnChargerNoRect.color = "red"
    }

    function listProperty(item)
    {
        for (var p in item)
        console.log(p + ": " + item[p]);
    }
    
    ColumnLayout {
            anchors.fill: parent
            // spacing: 2

        Text {
            id: txtHeader
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "End of Year Return.\nPlease use the barcode scanner to scan the barcode sticker on your device."
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        // AnimatedImage {
        //     id: image
        //     Layout.alignment: Qt.AlignHCenter
        //     source: "../images/dropoff.gif"
        //     fillMode: Image.Image.PreserveAspectCrop
        // }

        TextField {
            id: inputSerial
            // placeholderText: qsTr("Email Address")
            font.pointSize: 20
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: TextInput.AlignHCenter
            focus: true
            onTextChanged: {
                verifyForm()
            }
            
            Component.onCompleted: {
                this.focus = true
                this.forceActiveFocus()
            }
        }

        Text {
            id: txtEmail
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "Is the device's charger being returned as well?"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            font.pointSize: 30

        }

        RowLayout {
            Button {
                id: btnChargerYes
                
                enabled: true            
                Layout.fillWidth: true
                Layout.fillHeight: true

                contentItem: Text {
                    id: btnChargerYesText
                    text: "Yes"
                    font.pointSize: 50
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    anchors.fill: parent
                }

                background: Rectangle {
                    id: btnChargerYesRect
                    color: "green"
                    border.width: 1
                    radius: 2
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        chargerYesClicked()
                    }
                }
            }

            Button {
                id: btnChargerNo
                
                enabled: true            
                Layout.fillWidth: true
                Layout.fillHeight: true

                contentItem: Text {
                    id: btnChargerNoText
                    text: "No"
                    color: "red"
                    font.pointSize: 50
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    anchors.fill: parent
                }

                background: Rectangle {
                    id: btnChargerNoRect
                    border.width: 1
                    radius: 2
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        chargerNoClicked()
                    }
                }
            }       
        }

        

        Button {
            id: btnSubmit
            text: "Submit"
            enabled: false
            font.pointSize: 50
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                var returnInfo = [inputSerial.text, chargerReturned]
                ui.submitEOYReturn(returnInfo)
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
