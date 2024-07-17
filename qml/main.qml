import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.11
import QtWebChannel 1.7
import "secrets.js" as Secrets

ApplicationWindow {
	id: appWindow
	visible: true
	title: "GameGrid"
	color: "#1a191e"

	function restartScreensaverTimer() {
		ggDesktop.restartScreensaverTimer();
	}

	Item {
		objectName: "rotationArea"
		id: rotationArea
		anchors.centerIn: parent
		rotation: 0
		transformOrigin: Item.Center
		width:  (rotation%180==0) ? parent.width  : parent.height
		height: (rotation%180==0) ? parent.height : parent.width

		GGDesktop {
			id: ggDesktop
			anchors.fill: parent
		}
	}
}
