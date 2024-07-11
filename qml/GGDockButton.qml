import QtQuick 2.15

Rectangle {
	id: dockButton
	width: 44
	height: 44
	border.width: 1
	border.color: "#40000000"
	radius: 8
	color: "#ffffff"
	signal clicked
	property alias text: dockButtonText.text
	property alias image: dockButtonImage.source

	Image {
		id: dockButtonImage
		anchors.centerIn: parent
		smooth: true
		sourceSize.width: 32
		sourceSize.height: 32
	}
	Text {
		id: dockButtonText
		anchors.centerIn: parent
		font.pixelSize: 32
		color: "#80000000"
	}
	MouseArea {
		anchors.fill: parent
		onClicked: { dockButton.clicked(); }
	}
}
