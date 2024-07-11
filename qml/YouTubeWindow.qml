import QtQuick 2.15
import QtQuick.Controls 2.15
import "secrets.js" as Secrets

GGWindow {
	id: youTubeWindow
	opacity: 1
	width: 320
	height: 216 + 2*cornerRadius
	minWidth: 320
	minHeight: 216
	cornerRadius: 32
	onFinished: { youTubePlayer.pauseVideo(); }
	property alias videoId: youTubePlayer.videoId

	property string apiKey: Secrets.youtube.apiKey
	property string tvCode: Secrets.youtube.tvCode
	property string accessToken: Secrets.youtube.accessToken
	Component.onCompleted: {
		connectToTVCode(tvCode)
	}

	function connectToTVCode(tvCode) {
		console.log("connectToTVCode!",tvCode);

		var url = "https://www.googleapis.com/youtube/v3/liveBroadcasts?broadcastStatus=active&broadcastType=all&part=snippet";
		var request = new XMLHttpRequest();
		request.open("GET", url);
		request.setRequestHeader("Authorization", "Bearer " + accessToken);
		request.onreadystatechange = function() {
			if (request.readyState === XMLHttpRequest.DONE) {
				console.log("connectToTVCode!",tvCode,request.status);
				if (request.status === 200) {
					var response = JSON.parse(request.responseText);
					// Assuming the response contains the video ID based on the TV code
					var videoId = response.items[0].id;
					youTubePlayer.videoId = videoId;
					console.log("HURRA!",videoId);
				} else {
					console.log("Error fetching video for TV Code");
				}
			}
		};
		request.send();
	}

	YouTubePlayer {
		id: youTubePlayer
		anchors.fill: parent
		anchors.topMargin: 60
		anchors.bottomMargin: 32
		videoId: "vRqCs2SUdxY"
	}

	MouseArea {
		anchors.fill: youTubePlayer
		onClicked: { youTubePlayer.playVideo(); }
	}

	Text {
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.leftMargin:  youTubeWindow.cornerRadius / 2
		anchors.rightMargin: youTubeWindow.cornerRadius / 2
		height: youTubeWindow.cornerRadius
		horizontalAlignment: Text.AlignHCenter
		text: youTubePlayer.videoTitle
		font.pixelSize: 28
		minimumPixelSize: 8
		fontSizeMode: Text.Fit
		color: "#ffffff"
		clip: true
	}
}
