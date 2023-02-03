import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    id: appWindow
    // width: Constants.width
    // height: Constants.height

    visible: true
    title: "Clock"

    // This is the bridge between Python and QML
    // target needs to match the instantiated object ui = UI()
    // Include function on[SignaName] for every signal you'll rasise from Python
    // The magic is done by pyside to match on[SignalName] to [SignalName] in Python
    // This is the best way I've found so far to interact with QtControls
    Connections {
        target: ui
    }

    property var showedColon: false

    function updateClock()
    {
        var time = new Date().toLocaleTimeString(Locale.ShortFormat)
        clock.text = time
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: appWindow.updateClock()
    }

    Rectangle {
//        width: Constants.width
//        height: Constants.height
        anchors.fill: parent

        color: Constants.backgroundColor

        Text {
            id: clock
            width: parent.width
            height: parent.height
//            text: qsTr("88 : 88 PM")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
//            font.pointSize: 250
            fontSizeMode: Text.Fit
            minimumPixelSize: 10
            font.pixelSize: 1000
            anchors.centerIn: parent
            // font.family: "Noto Sans Mono"
        }
    }

}