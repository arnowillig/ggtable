import QtQuick 2.15
// import QtGraphicalEffects 1.0
import Qt5Compat.GraphicalEffects

Item {
	id: appItem
	width: 96
	height: 96
	property string appId: ""
	property alias text: appItemText.text
	property string icon: ""
	scale: pressed ? 2 : 1
	z: pressed ? 1 : 0
	property alias pressed: appItemMouseArea.pressed
	default property alias childArea: contentItem.children
	Behavior on scale { NumberAnimation {} }
	signal clicked

	Item {
		id: contentItem
		anchors.horizontalCenter: parent.horizontalCenter
		width: 64
		height: width

		Rectangle {
			id: iconMask
			anchors.fill: parent
			radius: parent.width/2
			visible: false
		}
		Rectangle {
			id: iconBackground
			// anchors.margins: 1
			anchors.fill: parent
			radius: parent.width/2
			gradient: Gradient {
				GradientStop { position: 0.0; color: "#ffffffff" }
				GradientStop { position: 1.0; color: "#80aaaaaa" }
			}
		}
		Image {
			anchors.fill: parent
			sourceSize.width: 512
			sourceSize.height: 512
			smooth: true
			antialiasing: true
			source: appItem.icon.length>0 ? "qrc:/images/"+appItem.icon : ""
			layer.enabled: true
			layer.textureSize: Qt.size(512, 512)
			layer.mipmap: true
			layer.effect: OpacityMask {
				maskSource: Rectangle {
					width: 64
					height: 64
					radius: 32
					color: "white"
				}
			}
		}
		MouseArea {
			id: appItemMouseArea
			anchors.fill: parent
			onClicked: { appItem.clicked(); }
		}
	}

	Rectangle {
		anchors.fill: appItemText
		color: "#000000"
		opacity: appItem.pressed ? 0.25 : 0
		radius: 8
		Behavior on opacity { NumberAnimation {} }
	}

	Text {
		id: appItemText
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		wrapMode: Text.WordWrap
		text: appModel.get(index + rowItem.rowIndex * appPageItem.calculateColumns(appModel.count, appPageItem.calculateRows(appModel.count))[rowItem.rowIndex]).name
		font.pixelSize: 12
		color: "#ffffff"
		horizontalAlignment: Text.AlignHCenter
	}
}
