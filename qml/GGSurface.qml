import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
	id: ggSurface
	width: 320
	height: 180
	color: "#80000000"
	radius: 32
	property int minWidth: 140
	property int minHeight: 80
	default property alias childArea: contentArea.children

	MouseArea {
		id: dragMouseArea
		anchors.fill: parent
		drag.target: parent
		drag.minimumX: 0
		drag.maximumX: ggSurface.parent.width - ggSurface.width
		drag.minimumY: 0
		drag.maximumY: ggSurface.parent.height - ggSurface.height
		// onPressed: { ggWindow.setActive(); }
	}

	Item {
		id: contentArea
		anchors.fill: parent
	}

	Item {
		id: resizeItem
		x: ggSurface.width  - width
		y: ggSurface.height - height
		width: 40
		height: 40
		onXChanged: {
			if (resizeMouseArea.pressed) { ggSurface.width = x + width; }
		}
		onYChanged: {
			if (resizeMouseArea.pressed) { ggSurface.height = y + height; }
		}
		MouseArea {
			id: resizeMouseArea
			anchors.fill: parent
			drag.target: parent
			drag.axis: Drag.XAndYAxis
			drag.minimumX: ggSurface.minWidth  - resizeItem.width
			drag.minimumY: ggSurface.minHeight - resizeItem.height
			drag.maximumX: ggSurface.parent.width  - ggSurface.x - parent.width
			drag.maximumY: ggSurface.parent.height - ggSurface.y - parent.height
		}
	}

	Rectangle {
		id: dragIndicator
		height: 8
		radius: height/2
		width: 200
		color: "#40ffffff"
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.bottom
		anchors.topMargin: 8
		visible: opacity>0
		opacity: dragMouseArea.pressed ? 1 : 0
		Behavior on opacity { NumberAnimation {} }
	}

	Item {
		id: resizeIndicator
		clip: true
		anchors.right: ggSurface.right
		anchors.bottom: ggSurface.bottom
		anchors.margins: -ggSurface.radius - resizeArc.border.width - 8
		width: ggSurface.radius*2
		height: ggSurface.radius*2
		visible: opacity>0
		opacity: resizeMouseArea.pressed ? 1 : 0
		Behavior on opacity { NumberAnimation {} }

		Rectangle {
			id: resizeArc
			width: parent.width
			height: parent.height
			x: -width  / 2
			y: -height / 2
			color: "transparent"
			border.width: 8
			border.color: "#40ffffff"
			radius: ggSurface.radius
		}
	}


}
