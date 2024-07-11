import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.11
import QtWebChannel 1.7

Item {
	id: ggDesktop

	GGWallpaper {
		id: wallPaper
	}

	GGDock {
		id: dock
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		// enabled: !screenSaver.active
	}

	GGScreenSaver {
		id: screenSaver
		active: true
		timeout: 60000
	}

	function restartScreensaverTimer() {
		screenSaver.restartScreensaverTimer();
	}

}
