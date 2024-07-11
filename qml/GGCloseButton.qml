import QtQuick 2.0

Item {
    id: closeButton
    width: 64
    height: 64
    signal clicked
    property bool isCloseButton: true
    property bool isMaxSize: false
    Rectangle {
        anchors.centerIn: parent
        color: closeButtonMouseArea.pressed ? "#cccccc" : "#aaaaaa"
        radius: parent.width/2
        opacity: 0.5
        width: 40
        height: width
        Item {
            visible: isCloseButton
            anchors.fill: parent
            opacity: 0.5
            Rectangle {
                anchors.centerIn: parent
                width: 20
                height: 4
                color: "#000000"
                rotation: closeButtonMouseArea.pressed ? 0 : 45
                Behavior on rotation { NumberAnimation {} }
            }
            Rectangle {
                anchors.centerIn: parent
                width: 20
                height: 4
                color: "#000000"
                rotation: closeButtonMouseArea.pressed ? 0 : -45
                Behavior on rotation { NumberAnimation {} }
            }
        }
        Item {
            visible: !isCloseButton
            anchors.fill: parent
            opacity: 0.5
            Rectangle {
                visible: isMaxSize
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 10
                width: 20
                height: 4
                color: "#000000"
            }
            Rectangle {
                visible: !isMaxSize
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: 20
                height: 20
                color: "transparent"
                border.width: 4
                border.color: "#000000"
            }
        }
    }
    MouseArea {
        id: closeButtonMouseArea
        anchors.fill: parent
        onClicked: { closeButton.clicked(); }
    }
}
