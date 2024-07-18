import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
	id: ggWindow
	width: 320
	height: 240
	visible: opacity>0
	opacity: 1
	z: parent.windowList.indexOf(ggWindow) + 1
	anchors.fill: isFullscreen ? parent : undefined
	property string uuid: ""
	property int cornerRadius: 32
	property int minWidth:  320
	property int minHeight: 240
	property bool isFullscreen: false
	property bool isActiveWindow: false
	default property alias childArea: contentArea.children
	property var lastSize: ({})

	signal resized()
	signal clicked()
	signal finished()

	function close() {
		opacity = 0;
		parent.windowList = parent.windowList.filter(win => win !== ggWindow);
		finished();
		ggWindow.destroy();
	}

	function setActive() {
		parent.setWindowActive(ggWindow);
	}

	function onClicked() {
		setActive();
	}

	Rectangle {
		id: ggWindowRect
		anchors.fill: parent
		radius: parent.cornerRadius
		color: "#444444"
		opacity: 0.5
		visible: false
	}

	DropShadow {
		id: ggWindowDropShadow
		anchors.fill: ggWindowRect
		source:  ggWindowRect
		horizontalOffset: 4
		verticalOffset:   4
		radius:  8
		samples: 1 + radius * 2
		color:   "#40ffffff"
		smooth:  true
		enabled: true
		visible: true
		cached: false
		opacity: isActiveWindow ? 0.9 : 0.5
	}

	MouseArea {
		id: dragMouseArea
		anchors.fill: parent
		drag.target: parent
		drag.minimumX: 0
		drag.maximumX: ggWindow.parent.width - ggWindow.width
		drag.minimumY: 0
		drag.maximumY: ggWindow.parent.height - ggWindow.height
		onPressed: { ggWindow.setActive(); }
	}

	Item {
		id: resizeItem
		x: ggWindow.width  - width
		y: ggWindow.height - height
		width: 40
		height: 40
		onXChanged: {
			if (resizeMouseArea.pressed) {
				ggWindow.width = x + width;
				resizeTimer.start();
				ggWindow.setActive();
			}
		}
		onYChanged: {
			if (resizeMouseArea.pressed) {
				ggWindow.height = y + height;
				resizeTimer.start();
				ggWindow.setActive();
			}
		}
		Timer {
			id: resizeTimer
			interval: 1000
			repeat: false
			running: false
			onTriggered:  { ggWindow.resized(); }
		}
		MouseArea {
			id: resizeMouseArea
			enabled: true // blurDialog.showResizeButton
			anchors.fill: parent
			drag.target: parent
			drag.axis: Drag.XAndYAxis
			drag.minimumX: ggWindow.minWidth  - resizeItem.width
			drag.minimumY: ggWindow.minHeight - resizeItem.height
			drag.maximumX: ggWindow.parent.width  - ggWindow.x - parent.width
			drag.maximumY: ggWindow.parent.height - ggWindow.y - parent.height
			onReleased: { resizeTimer.stop(); ggWindow.resized(); ggWindow.setActive(); }
			onPressed: { ggWindow.setActive(); }
		}
	}

	Item {
		id: contentArea
		anchors.fill: parent
		clip: true
	}

	Rectangle {
		id: activeIndicator
		color: "transparent"
		anchors.fill: parent
		radius: parent.cornerRadius
		visible: parent.isActiveWindow
		border.width: 1
		border.color: "#ffffff"
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
		anchors.right: ggWindow.right
		anchors.bottom: ggWindow.bottom
		anchors.margins: -ggWindow.cornerRadius - resizeArc.border.width - 8
		width: ggWindow.cornerRadius*2
		height: ggWindow.cornerRadius*2
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
			radius: ggWindow.cornerRadius
		}
	}

	GGCloseButton {
		id: maxButton
		visible: true // blurDialog.showResizeButton
		isCloseButton: false
		isMaxSize: (ggWindow.width === maxSizeW && ggWindow.height === maxSizeH)
		anchors.top: ggWindow.top
		anchors.right: closeButton.left
		anchors.rightMargin: 0
		property int maxSizeW: ggWindow.parent.width  - 20;
		property int maxSizeH: ggWindow.parent.height - 20;
		onClicked: {
			if (ggWindow.isFullscreen) {
				ggWindow.isFullscreen = false;
				ggWindow.x = lastSize.x;
				ggWindow.y = lastSize.y;
				ggWindow.width = lastSize.width;
				ggWindow.height = lastSize.height;
			} else {
				lastSize = { "x": ggWindow.x, "y": ggWindow.y, "width": ggWindow.width, "height": ggWindow.height };
				ggWindow.isFullscreen = true;
			}
			ggWindow.resized();
		}
	}

	GGCloseButton {
		id: closeButton
		anchors.top: ggWindow.top
		anchors.right: ggWindow.right
		onClicked: {
			ggWindow.close();
		}
		visible: true // ggWindow.showCloseButton
	}

}
