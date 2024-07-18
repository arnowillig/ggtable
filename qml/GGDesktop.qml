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

	function generateUUID() {
		function s4() {
			return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
		}
		return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
	}

	function addWindow(windowType, params) {
		let component = Qt.createComponent(windowType + ".qml");
		let obj = params;
		obj.uuid = generateUUID();
		obj.x = 10 + Math.floor(Math.random() * (ggDesktop.width  - 384 - 20));
		obj.y = 10 + Math.floor(Math.random() * (ggDesktop.height - 266 - 20));
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
			windowList[i].isActiveWindow = (i === windowList.length - 1);
		}
	}

	Connections {
		target: clipboardHandler
		function onGotLink(type, data) {
			if (type==="youtube") {
				addWindow("YouTubeWindow", { "videoId": data });
			}
		}
	}

	ListView {
		id: appPageListView
		opacity: 1-screenSaver.opacity
		width:  parent.width  - 128
		height: parent.height - 128
		anchors.centerIn: parent
		contentWidth: width
		contentHeight: height
		orientation: ListView.Horizontal
		snapMode: ListView.SnapToItem
		model: 3
		spacing: 128
		cacheBuffer: 1920
		interactive: model>1
		delegate: GGAppPage {
			id: appPage
			pageIndex: index
			elevated: appPageListView.flicking || appPageListView.dragging || pressed
			width:  appPageListView.width
			height: appPageListView.height
			onAppClicked: {
				console.log("APP CLICKED: ", appId);
				if (appId==="com.bytefeed.gamegrid.screensaver") {
					screenSaver.active = true;
				}
				if (appId==="com.bytefeed.gamegrid.browser") {
					addWindow("YouTubeWindow", { "videoId": "f4s1h2YETNY" });
				}
				if (appId==="com.bytefeed.gamegrid.dice") {
					addWindow("DiceWindow", {});
				}
				if (appId==="com.bytefeed.gamegrid.clock") {
					addWindow("GGClock", {});
				}
			}
		}
	}
}
