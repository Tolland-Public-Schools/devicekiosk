import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Connections {
        target: ui
        function onShowDailyLoanersSignal() {
            dailyLoanerDeviceRow.visible = true;
            // btnDailyDeviceLoaner.visible = true;
            // btnDailyDeviceLoanerReturn.visible = true;
            dailyLoanerChargerRow.visible = true;
            // btnDailyCharger.visible = true;
            // btnDailyChargerReturn.visible = true;
            btnDailyReport.visible = true;
        }
        function onShowLoanersReportSignal(){
            btnLoanerReport.visible = true;
        }
        function onShowStaffSubBorrowSignal(){
            staffBorrowRow.visible = true;
        }
    }
    
    function showHideDailyLoaners() {
        ui.showHideDailyLoaners()
    }


    ColumnLayout {
        anchors.fill: parent
        // spacing: 2

        Text {
            id: txtIntro
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: "How can we help you?"
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

        RowLayout {
            id: dailyLoanerDeviceRow
            visible: false
            Button {
                id: btnDailyDeviceLoaner
                text: "Borrowing a laptop for the day"
                font.pointSize: 50
                Layout.preferredWidth: parent.width / 2
                // Layout.fillWidth: true
                Layout.fillHeight: true
                // visible: false
                onClicked: {
                    // ui.toEmail()
                    // contentFrame.push(Qt.createComponent("Email.qml"))
                    ui.start(3)
                }
            }
            Button {
                id: btnDailyDeviceLoanerReturn
                text: "Returning a daily laptop"
                font.pointSize: 50
                Layout.fillWidth: true
                Layout.fillHeight: true
                // visible: false
                onClicked: {
                    // ui.toEmail()
                    // contentFrame.push(Qt.createComponent("Email.qml"))
                    ui.start(5)
                }
            }        
        }

        RowLayout {
            id: dailyLoanerChargerRow
            visible: false
            Button {
                id: btnDailyCharger
                text: "Borrowing a charger for the day"
                font.pointSize: 50
                Layout.preferredWidth: parent.width / 2
                // Layout.fillWidth: true
                Layout.fillHeight: true
                // visible: false
                onClicked: {
                    // ui.toEmail()
                    // contentFrame.push(Qt.createComponent("Email.qml"))
                    ui.start(4)
                }
            }
            Button {
                id: btnDailyChargerReturn
                text: "Returning a daily charger"
                font.pointSize: 50
                Layout.fillWidth: true
                Layout.fillHeight: true
                // visible: false
                onClicked: {
                    // ui.toEmail()
                    // contentFrame.push(Qt.createComponent("Email.qml"))
                    ui.start(6)
                }
            }      
        }

        RowLayout {
            id: staffBorrowRow
            visible: false
            Button {
                id: btnStaffBorrow
                text: "Sub/Staff Device Check-out"
                font.pointSize: 50
                Layout.preferredWidth: parent.width / 2
                // Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: {
                    ui.start(7)
                }
            }
            Button {
                id: btnStaffReturn
                text: "Sub/Staff Device Check-in"
                font.pointSize: 50
                Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: {
                    ui.start(8)
                }
            }
        }

        RowLayout {
            Button {
                id: btnDropOff
                text: "\nDropping Off for Repair\n"
                font.pointSize: 50
                Layout.preferredWidth: parent.width / 2
                // Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: {
                    // ui.toEmail()
                    // contentFrame.push(Qt.createComponent("Email.qml"))
                    ui.start(1)
                }
            }
            Button {
                id: btnPickUp
                text: "\nPicking Up Repaired Device\n"
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

        
        RowLayout {
            // Will be handy when PySide6 supports uniformCellSizes
            // uniformCellSizes: true
            Button {
                id: btnDailyReport
                text: "Print Daily Report"
                visible: false
                font.pointSize: 50
                Layout.preferredWidth: parent.width / 2
                // Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: {
                    ui.dailyReport()
                }
            }
            Button {
                id: btnLoanerReport
                text: "Print Total\nBorrows by Student"
                visible: false
                font.pointSize: 50
                Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: {
                    ui.generateBorrowReport()
                }
            }
        }
        
    }
    // Show/hide daily loaner buttons based on config
    Timer {
        interval: 100
        running: true
        repeat: false
        onTriggered: showHideDailyLoaners()
    }
}
