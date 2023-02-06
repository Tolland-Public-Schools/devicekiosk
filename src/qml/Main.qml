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

        function onShowReturnSignal() {
            contentFrame.push(Qt.createComponent("Return.qml"))
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
    }



}
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1}D{i:2}
}
##^##*/
