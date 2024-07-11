import QtQuick 2.15

Item {
	id: screenSaver
	anchors.fill: parent
	opacity: active ? 1 : 0
	property bool active: false
	property string shader: "clouds" // kaleidoscope
	property alias timeout: screensaverTimer.interval
	Behavior on opacity { NumberAnimation { duration:  1000 } }
	property var shaders: (["water"]) // "water", "rainbow", "kaleidoscope", "clouds", "galaxy", "pinknoise"])
	onActiveChanged: {
		if (active) {
			shader = shaders[Math.floor(Math.random() * shaders.length)];
		}
	}

	function restartScreensaverTimer() {
		screenSaver.active = false;
		screensaverTimer.restart();
	}

	Timer {
		id: screensaverTimer
		interval: 5000
		repeat: false
		onTriggered: { screenSaver.active = true; screensaverTimer.stop(); }
	}

	ShaderEffect {
		id: shaderEffect
		opacity: 0.9 * screenSaver.opacity
		visible: opacity>0
		anchors.fill: parent
		blending: false
		fragmentShader: "qrc:/shaders/" + screenSaver.shader + ".frag"
		property size iResolution: Qt.size(width, height)
		property real iTime: 0
		property variant source: wallPaper
		Timer {
			running: shaderEffect.visible
			repeat: true
			interval: 20
			onTriggered: { shaderEffect.iTime += 0.1; }
		}
	}
}
