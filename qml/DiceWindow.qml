import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.15

GGWindow {
	id: diceWindow
	width: 128 // 220
	height: 128 // 220
	minWidth: 128 // 220
	minHeight: 128 // 220
	cornerRadius: 32
	showCloseButton: false
	showMaximizeButton: false
	allowResize: false
	decorate: false
	deleteOnBorders: true
	clip: true
	property int pipSize: 24
	property color diceColor: Qt.hsla(Math.random(), 0.75, 0.5, 0.75)
	property color pipColor: Qt.darker(diceColor, 4)

	onClicked: { rollDice(); }

	Component.onCompleted: { rollDice(); }

	states: [
		State {
			name: "roll1"
			PropertyChanges { target: pip1; opacity: 0 }
			PropertyChanges { target: pip2; opacity: 0 }
			PropertyChanges { target: pip3; opacity: 0 }
			PropertyChanges { target: pip4; opacity: 0 }
			PropertyChanges { target: pip5; opacity: 0 }
			PropertyChanges { target: pip6; opacity: 0 }
			PropertyChanges { target: pip7; opacity: 1 }
		},
		State {
			name: "roll2"
			PropertyChanges { target: pip1; opacity: 1 }
			PropertyChanges { target: pip2; opacity: 0 }
			PropertyChanges { target: pip3; opacity: 0 }
			PropertyChanges { target: pip4; opacity: 0 }
			PropertyChanges { target: pip5; opacity: 0 }
			PropertyChanges { target: pip6; opacity: 1 }
			PropertyChanges { target: pip7; opacity: 0 }
		},
		State {
			name: "roll3"
			PropertyChanges { target: pip1; opacity: 1 }
			PropertyChanges { target: pip2; opacity: 0 }
			PropertyChanges { target: pip3; opacity: 0 }
			PropertyChanges { target: pip4; opacity: 0 }
			PropertyChanges { target: pip5; opacity: 0 }
			PropertyChanges { target: pip6; opacity: 1 }
			PropertyChanges { target: pip7; opacity: 1 }
		},
		State {
			name: "roll4"
			PropertyChanges { target: pip1; opacity: 1 }
			PropertyChanges { target: pip2; opacity: 1 }
			PropertyChanges { target: pip3; opacity: 0 }
			PropertyChanges { target: pip4; opacity: 0 }
			PropertyChanges { target: pip5; opacity: 1 }
			PropertyChanges { target: pip6; opacity: 1 }
			PropertyChanges { target: pip7; opacity: 0 }
		},
		State {
			name: "roll5"
			PropertyChanges { target: pip1; opacity: 1 }
			PropertyChanges { target: pip2; opacity: 1 }
			PropertyChanges { target: pip3; opacity: 0 }
			PropertyChanges { target: pip4; opacity: 0 }
			PropertyChanges { target: pip5; opacity: 1 }
			PropertyChanges { target: pip6; opacity: 1 }
			PropertyChanges { target: pip7; opacity: 1 }
		},
		State {
			name: "roll6"
			PropertyChanges { target: pip1; opacity: 1 }
			PropertyChanges { target: pip2; opacity: 1 }
			PropertyChanges { target: pip3; opacity: 1 }
			PropertyChanges { target: pip4; opacity: 1 }
			PropertyChanges { target: pip5; opacity: 1 }
			PropertyChanges { target: pip6; opacity: 1 }
			PropertyChanges { target: pip7; opacity: 0 }
		}
	]

	function rollDice() {
		changeFace();
		rollAnimation.start();
		// diceRollSound.play();
	}

	function changeFace() {
		diceWindow.state = "roll" + (Math.floor(Math.random() * 6) + 1);
	}

	Rectangle {
		id: diceRect
		width: 128
		height: 128
		radius: 8
		color: diceWindow.diceColor // "#ccffffff"
		border.width: 1
		border.color: Qt.darker(diceWindow.diceColor) // "#888888"
		anchors.centerIn: parent

		transform: [
			Rotation {
				id: rotationX
				axis { x: 1; y: 0; z: 0 }
				origin.x: diceRect.width  / 2
				origin.y: diceRect.height / 2
				angle: 0
			},
			Rotation {
				id: rotationY
				axis { x: 0; y: 1; z: 0 }
				origin.x: diceRect.width  / 2
				origin.y: diceRect.height / 2
				angle: 0
			}
		]

		SequentialAnimation {
			id: rollAnimation
			property int speed: 125
			NumberAnimation { target: rotationX; property: "angle"; from: 0; to: 90; duration: rollAnimation.speed; easing.type: Easing.InQuad }
			ScriptAction { script: { changeFace() } }
			NumberAnimation { target: rotationX; property: "angle"; from: 90; to: 180; duration: rollAnimation.speed; easing.type: Easing.OutQuad }
			NumberAnimation { target: rotationX; property: "angle"; from: 180; to: 270; duration: rollAnimation.speed; easing.type: Easing.InQuad }
			ScriptAction { script: { changeFace() } }
			NumberAnimation { target: rotationX; property: "angle"; from: 270; to: 360; duration: rollAnimation.speed; easing.type: Easing.OutQuad }

			NumberAnimation { target: rotationY; property: "angle"; from: 0; to: 90; duration: rollAnimation.speed; easing.type: Easing.InQuad }
			ScriptAction { script: { changeFace() } }
			NumberAnimation { target: rotationY; property: "angle"; from: 90; to: 180; duration: rollAnimation.speed; easing.type: Easing.OutQuad }
			NumberAnimation { target: rotationY; property: "angle"; from: 180; to: 270; duration: rollAnimation.speed; easing.type: Easing.InQuad }
			ScriptAction { script: { changeFace() } }
			NumberAnimation { target: rotationY; property: "angle"; from: 270; to: 360; duration: rollAnimation.speed; easing.type: Easing.OutQuad }

			PropertyAnimation { target: diceRect; property: "scale"; from: 1; to: 0.8; duration: 100; easing.type: Easing.OutQuad }
			PropertyAnimation { target: diceRect; property: "scale"; from: 0.8; to: 1; duration: 200; easing.type: Easing.InQuad }
		}

		Rectangle {
			id: pip1
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.margins: 16
			width: diceWindow.pipSize
			height: diceWindow.pipSize
			radius: diceWindow.pipSize / 2
			color: diceWindow.pipColor
		}
		Rectangle {
			id: pip2
			anchors.top: parent.top
			anchors.right: parent.right
			anchors.margins: 16
			width: diceWindow.pipSize
			height: diceWindow.pipSize
			radius: diceWindow.pipSize / 2
			color: diceWindow.pipColor
		}
		Rectangle {
			id: pip3
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			anchors.margins: 16
			width: diceWindow.pipSize
			height: diceWindow.pipSize
			radius: diceWindow.pipSize / 2
			color: diceWindow.pipColor
		}
		Rectangle {
			id: pip4
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			anchors.margins: 16
			width: diceWindow.pipSize
			height: diceWindow.pipSize
			radius: diceWindow.pipSize / 2
			color: diceWindow.pipColor
		}
		Rectangle {
			id: pip5
			anchors.bottom: parent.bottom
			anchors.left: parent.left
			anchors.margins: 16
			width: diceWindow.pipSize
			height: diceWindow.pipSize
			radius: diceWindow.pipSize / 2
			color: diceWindow.pipColor
		}
		Rectangle {
			id: pip6
			anchors.bottom: parent.bottom
			anchors.right: parent.right
			anchors.margins: 16
			width: diceWindow.pipSize
			height: diceWindow.pipSize
			radius: diceWindow.pipSize / 2
			color: diceWindow.pipColor
		}
		Rectangle {
			id: pip7
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			width: diceWindow.pipSize
			height: diceWindow.pipSize
			radius: diceWindow.pipSize / 2
			color: diceWindow.pipColor
		}

		// MouseArea {
		// 	anchors.fill: parent
		// 	onClicked: { rollDice(); }
		// }
	}

	// SoundEffect {
	//   id: diceRollSound
	//   source: "qrc:/sounds/dice_roll.mp3"
	// }
}
