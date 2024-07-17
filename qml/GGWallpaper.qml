import QtQuick 2.15

Image {
	id: backgroundImage
	anchors.fill: parent
	source: rotationArea.rotation % 180 === 0 ? "qrc:/images/garagegunters_1920x1080.jpg" : "qrc:/images/garagegunters_1080x1920.jpg"
	fillMode: Image.PreserveAspectCrop
}
