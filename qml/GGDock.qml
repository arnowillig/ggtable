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
				let component = Qt.createComponent("YouTubeWindow.qml");
				if (component.status === Component.Ready) {
					finishCreation(component);
				} else {
					component.statusChanged.connect(()=>{finishCreation(component)});
				}
			}
			function finishCreation(component) {
				if (component.status === Component.Ready) {
					let sprite = component.createObject(ggDesktop, {
										    videoId: "f4s1h2YETNY",
										    x: Math.floor(Math.random()*(ggDesktop.width-384)),
										    y: Math.floor(Math.random()*(ggDesktop.height-216-50))});
					if (sprite === null) {
						console.log("Error creating object");
					}
				} else if (component.status === Component.Error) {
					// Error Handling
					console.log("Error loading component:", component.errorString());
				}
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
