import QtQuick 2.15

Item {
	id: clockAppItem
	anchors.fill: parent

	property real fingerLen:   Math.min(width/2, height/2)
	property real fingerWidth: Math.min(width/2, height/2) * 0.04
	property real fontSize:    Math.min(width/2, height/2) * 0.3
	Text {
		id: clockText
		anchors.centerIn: parent
		anchors.verticalCenterOffset: Math.min(parent.width, parent.height) * 0.2
		font.pixelSize: Math.floor(fontSize)
	}

	Rectangle {
		id: fingerHour
		color: "#cc000000"
		x: parent.width/2
		y: parent.height/2
		width: fingerLen * 0.6// 16
		height: fingerWidth // 2
		rotation: 90
		transformOrigin: Item.Left
		smooth: true
		antialiasing: true
		Behavior on rotation { RotationAnimation { duration: 750; direction: RotationAnimation.Clockwise } }
	}

	Rectangle {
		id: fingerMin
		color: "#cc000000"
		x: parent.width/2
		y: parent.height/2
		width: fingerLen * 0.7 // 19
		height: fingerWidth // 2
		rotation: 90
		transformOrigin: Item.Left
		smooth: true
		antialiasing: true
		Behavior on rotation { RotationAnimation { duration: 750; direction: RotationAnimation.Clockwise } }
	}

	Rectangle {
		id: fingerSecs
		color: "#ccc30c15"
		x: parent.width/2
		y: parent.height/2
		width: fingerLen * 0.88 // 22
		height: fingerWidth * 0.5 // 1
		rotation: 90
		transformOrigin: Item.Left
		smooth: true
		antialiasing: true
		Behavior on rotation { RotationAnimation { duration: 750; direction: RotationAnimation.Clockwise } }
	}

	Rectangle {
		id: centerDot
		anchors.centerIn: parent
		width: fingerWidth * 2
		height: width
		radius: width/2
		color: "#cc000000"
	}

	Timer {
		interval: 1000
		running: parent.visible
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			let dt = new Date();
			let hour = dt.getHours();
			let mins = dt.getMinutes();
			let secs = dt.getSeconds();
			fingerHour.rotation = -90 + 720 * ((hour + (mins / 60)) / 24);
			fingerMin.rotation  = -90 + 360 * (mins / 60);
			fingerSecs.rotation = -90 + 360 * (secs / 60);
			clockText.text = Qt.formatTime(dt, "HH:mm");
		}
	}
}
