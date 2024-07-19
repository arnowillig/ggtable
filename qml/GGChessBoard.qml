import QtQuick 2.15
import QtQuick.Controls 2.15

GGWindow {
	id: ggChessBoard
	width: 640
	height: 640
	minWidth: 320
	minHeight: 320
	decorate: true
	deleteOnBorders: true
	showCloseButton: false
	showMaximizeButton: false
	keepAspectRatio: false

	onReshaping: { decorate = true; }
	onResized: { decorate = false; }
	onMoved: { decorate = false; }

	onClicked: {
	}

	Item {
		anchors.fill: parent
		anchors.margins: 20

		Grid {
			id: chessboard
			rows: 8
			columns: 8
			anchors.centerIn: parent

			property int squareSize: Math.min(parent.width, parent.height) / 8

			Repeater {
				model: 64
				Rectangle {
					width: chessboard.squareSize
					height: chessboard.squareSize
					color: (index + Math.floor(index / 8)) % 2 == 0 ? "white" : "black"
				}
			}
		}
	}
}
