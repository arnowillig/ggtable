import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.11
import QtWebChannel 1.7

Item {
	id: ggDesktop
	property var windowList: ([])

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

	function addWindow(windowType, params) {
		let component = Qt.createComponent(windowType + ".qml");
		let obj = params;
		obj.x = Math.floor(Math.random() * (ggDesktop.width  - 384));
		obj.y = Math.floor(Math.random() * (ggDesktop.height - 266));
		obj.z = windowList.length + 1;
		let window = component.createObject(ggDesktop, obj);
		windowList.push(window);
		setWindowActive(window);
	}

	function setWindowActive(window) {
		windowList.splice(windowList.indexOf(window), 1);
		windowList.push(window);
		for (let i = 0; i < windowList.length; i++) {
			windowList[i].z = i;
			windowList[i].isActiveWindow = false;
		}
		windowList[windowList.length-1].isActiveWindow = true;
	}

	Connections {
		target: clipboardHandler
		function onGotYouTubeLink(videoId) {
			addWindow("YouTubeWindow", { "videoId": videoId });
		}
	}
}
