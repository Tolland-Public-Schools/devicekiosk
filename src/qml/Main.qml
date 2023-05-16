import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: appWindow
    // width: Constants.width
    // height: Constants.height

    visible: true
    visibility: Window.FullScreen
    // visibility: Window.Maximized
    title: "Device Repair Kiosk"

    // This is the bridge between Python and QML
    // target needs to match the instantiated object ui = UI()
    // Include function on[SignaName] for every signal you'll rasise from Python
    // The magic is done by pyside to match on[SignalName] to [SignalName] in Python
    // This is the best way I've found so far to interact with QtControls
    Connections {
        target: ui

        function onShowUserSignal() {
            contentFrame.push(Qt.createComponent("User.qml"))
        }

        function onShowEmailScreenSignal() {
            contentFrame.push(Qt.createComponent("Email.qml"))
        }

        function onStartOverSignal() {
            contentFrame.clear()
            contentFrame.push(Qt.createComponent("Start.qml"))
        }

        function onShowDescriptionSignal() {
            contentFrame.push(Qt.createComponent("Description.qml"))
        }

        function onShowDeviceSignal() {
            contentFrame.push(Qt.createComponent("Device.qml"))
        }

        function onShowDailyLoanerDeviceScreenSignal() {
            contentFrame.push(Qt.createComponent("DailyLoanerDevice.qml"))
        }

        function onShowDailyLoanerChargerScreenSignal() {
            contentFrame.push(Qt.createComponent("DailyLoanerCharger.qml"))
        }

        function onShowPrintSignal() {
            contentFrame.push(Qt.createComponent("Print.qml"))
        }

        function onShowDropoffSignal() {
            contentFrame.push(Qt.createComponent("Dropoff.qml"))
        }

        function onShowLoanerSignal() {
            contentFrame.push(Qt.createComponent("Loaner.qml"))
        }

        function onShowSubmitSignal() {
            contentFrame.push(Qt.createComponent("Submit.qml"))
        }

        function onShowSubmitPickupSignal() {
            contentFrame.push(Qt.createComponent("SubmitPickup.qml"))
        }

        function onShowReturnSignal() {
            contentFrame.push(Qt.createComponent("Return.qml"))
        }

        function onShowPickupSignal() {
            contentFrame.push(Qt.createComponent("Pickup.qml"))
        }

        function onShowFinishSignal(error) {
            contentFrame.push(Qt.createComponent("Finish.qml"))
        }

        function onShowFinishDailyBorrowSignal(error) {
            contentFrame.push(Qt.createComponent("FinishDailyBorrow.qml"))
        }

        function onShowFinishDailyReturnSignal(error) {
            contentFrame.push(Qt.createComponent("FinishDailyReturn.qml"))
        }

        function onShowEOYReturnSignal() {
            // contentFrame.clear()
            contentFrame.push(Qt.createComponent("EOYReturn.qml"))
        }

        function onShowEOYStartSignal() {
            // contentFrame.clear()
            contentFrame.push(Qt.createComponent("EOYStart.qml"))
        }
    }

    // Automatically go to a non-standard kiosk mode start page
    function setInitialPage() {
        switch(ui.getKioskMode()) {
            case 0:
                break;
            case 1:
                // TODO
                break;
            case 2:
                // EOY Return Only Mode
                contentFrame.push(Qt.createComponent("EOYStart.qml"))
            default:
                break;
        }
    }    

    // property var showedColon: false

    // function updateClock()
    // {
    //     var time = new Date().toLocaleTimeString(Locale.ShortFormat)
    //     clock.text = time
    // }

    StackView {
        width: appWindow.width
        height: appWindow.height
        id: contentFrame
        initialItem: Qt.createComponent("Start.qml")
        Component.onCompleted: {
            setInitialPage()
        }
    }



}
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1}D{i:2}
}
##^##*/
