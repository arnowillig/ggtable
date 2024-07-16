import QtQuick 2.15

Rectangle {
	id: dock
	height: 50
	color: "#40000000"
	visible: opacity>0
	enabled: true
	opacity: enabled ? 1 : 0
	Behavior on opacity { NumberAnimation {} }
	Row {
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.topMargin: 4
		spacing: 10

		GGDockButton {
			id: youTubeButton
			image: "qrc:/images/youtube_logo.svg"
			onClicked: {
				addWindow("YouTubeWindow", { "videoId": "f4s1h2YETNY" });
			}
		}

		GGDockButton {
			id: rotateButton
			image: "qrc:/images/rotate.svg"
			onClicked: { rotationArea.rotation = (rotationArea.rotation + 90) % 360; }
		}

		GGDockButton {
			id: screenSaverButton
			image: "qrc:/images/sleepmode.svg"
			onClicked: { screenSaver.active = true; }
		}
	}


}
