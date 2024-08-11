import QtQuick 2.15
import QtQuick.Controls 2.15

GGWindow {
	id: ggClock
	width: 320
	height: 180
	minWidth: 140
	minHeight: 80
	decorate: false
	deleteOnBorders: true
	showCloseButton: false
	showMaximizeButton: false
	property color textColor: "#803ac042"
	property alias bgColor: bgRect.color
	Rectangle {
		id: bgRect
		anchors.fill: parent
		color: "#80000000"
		radius: 32
	}
	onClicked: {
		if (ggClock.state === "clockMode") {
			ggClock.state = "analogClockMode";
		} else {
			ggClock.state = "clockMode";
		}
	}

	// MouseArea {
	// 	anchors.fill: parent
	// 	anchors.margins: 32
	// 	onClicked: {
	// 		if (ggClock.state === "clockMode") {
	// 			ggClock.state = "analogClockMode";
	// 		} else {
	// 			ggClock.state = "clockMode";
	// 		}
	// 	}
	// }

	Behavior on textColor { ColorAnimation { } }
	state: "clockMode"
	states: [
		State {
			name: "clockMode"
			PropertyChanges { target: clockModeColumn; visible: true }
			PropertyChanges { target: analogClockModeItem; visible: false }
			PropertyChanges { target: ggClock; bgColor: "#80000000" }

		},
		State {
			name: "analogClockMode"
			PropertyChanges { target: clockModeColumn; visible: false }
			PropertyChanges { target: analogClockModeItem; visible: true }
			PropertyChanges { target: ggClock; bgColor: "#00ffffff" }
		}
		// PropertyChanges { target: alarmTimer; tick: 0 }
	]

	Column {
		id: clockModeColumn
		anchors.centerIn: parent
		spacing: 5

		Row {
			anchors.horizontalCenter: parent.horizontalCenter
			Text {
				id: hourText
				font.pixelSize: Math.min(ggClock.width * 0.3, ggClock.height * 0.5)
				color: ggClock.textColor
			}
			Text {
				id: tickText
				font.pixelSize: Math.min(ggClock.width * 0.3, ggClock.height * 0.5)
				text: ":"
				color: ggClock.textColor
				Behavior on opacity { NumberAnimation {} }
			}
			Text {
				id: minuteText
				font.pixelSize: Math.min(ggClock.width * 0.3, ggClock.height * 0.5)
				color: ggClock.textColor
			}
		}

		Text {
			id: dateText
			width: ggClock.width
			font.pixelSize: Math.min(ggClock.width * 0.095, ggClock.height * 0.25)
			horizontalAlignment: Text.AlignHCenter
			color: ggClock.textColor
		}

		Timer {
			interval: 1000
			running: true
			repeat: true
			triggeredOnStart: true
			property int tick: 0
			onTriggered: {
				tickText.opacity = tick % 2 ? 1 : 0;
				tick++;
				hourText.text = Qt.formatTime(new Date(), "HH");
				minuteText.text = Qt.formatTime(new Date(), "mm");
				dateText.text = Qt.formatDate(new Date(), "dd. MMMM yyyy");
				ggClock.textColor = Qt.hsla(0.5 + 0.5 * Math.sin(tick * Math.PI / 180.), 0.8, 0.75, 0.5);
			}
		}
	}

	Item {
		id: analogClockModeItem
		anchors.fill: parent
		visible: false

		Image {
			anchors.fill: parent
			sourceSize.width: 512
			sourceSize.height: 512
			smooth: true
			antialiasing: true
			source: "qrc:/images/clock.svg"
			fillMode: Image.PreserveAspectFit
			opacity: 0.75
		}

		GGClockAppItem {
			anchors.fill: parent
		}
	}
/*
	Column {
		id: alarmModeColumn
		visible: false
		// anchors.centerIn: parent
		anchors.fill: parent
		spacing: 5




		Text {
			id: alarmText
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Math.min(ggClock.width * 0.4, ggClock.height * 0.5)
			color: ggClock.textColor
		}

		Timer {
			id: alarmTimer
			interval: 100
			running: alarmModeColumn.visible
			repeat: true
			triggeredOnStart: true
			property int tick: 0
			onTriggered: {
				alarmText.text = Math.floor(tick / 10) + "," + tick % 10;
				tick++;
			}
		}
	}
	*/
}
