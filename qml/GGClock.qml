import QtQuick 2.15
import QtQuick.Controls 2.15

GGSurface {
	id: ggClock
	width: 320
	height: 180
	minWidth: 140
	minHeight: 80

	property color textColor: "#803ac042"
	Behavior on textColor { ColorAnimation { } }
	state: "clockMode"

	states: [
		State {
			name: "clockMode"
			// PropertyChanges {
			// 	target: shiftText
			// 	text: qsTr("ABC", "KEY_SHIFT")
			// }
		},
		State {
			name: "timerMode"
			// PropertyChanges {
			// 	target: shiftText
			// 	text: qsTr("ABC", "KEY_SHIFT")
			// }
		}
	]

	Column {
		id: clockModeColumn
		visible: ggClock.state === "clockMode"
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
			font.pixelSize: Math.min(ggClock.width * 0.075, ggClock.height * 0.25)
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
				tickText.opacity = tick%2 ? 1 : 0;
				tick++;
				hourText.text   = Qt.formatTime(new Date(), "HH");
				minuteText.text = Qt.formatTime(new Date(), "mm");
				dateText.text   = Qt.formatDate(new Date(), "dd. MMMM yyyy");
				ggClock.textColor = Qt.hsla(0.5 + 0.5*Math.sin(tick*Math.PI / 180.), 0.8, 0.75, 0.5);
			}
		}
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			if (ggClock.state === "clockMode") {
				ggClock.state = "alarmMode";
			} else {
				ggClock.state = "clockMode";
			}
		}
	}
}
