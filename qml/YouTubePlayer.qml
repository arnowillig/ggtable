import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.11
import QtWebChannel 1.7

Item {
    id: youTubePlayer
    property alias isPlaying: webEngineView.isPlaying
    property alias videoId: webEngineView.videoId
    property alias videoTitle: qtBridge.videoTitle

    WebEngineView {
        id: webEngineView
        antialiasing: true
        anchors.fill: parent
        settings.playbackRequiresUserGesture: false
        settings.allowRunningInsecureContent: true
        settings.localContentCanAccessRemoteUrls: true
        settings.showScrollBars: false
        settings.unknownUrlSchemePolicy: WebEngineSettings.AllowAllUnknownUrlSchemes
        url: "about:blank"
        enabled: false
        webChannel: WebChannel { registeredObjects: [qtBridge] }

        property string videoId: "vRqCs2SUdxY"
        property bool isPlaying: false
        // url: "https://www.youtube.com/embed/hrQSseedNWk?enablejsapi=1&autoplay=1&controls=1&rel=0&fs=1&iv_load_policy=3&modestbranding=1"

        onJavaScriptConsoleMessage: {
            console.log("CONSOLE: ", message);
        }

        QtObject {
            id: qtBridge
            WebChannel.id: "backend"
            property string videoTitle: ""
            function setIsPlaying(playing) { isPlaying = playing; }
        }

        Component.onCompleted: {
            webEngineView.loadHtml("<html><body>
                    <style>iframe { width: 100%; height: 100%; border: none; }</style>
                    <div id=\"player\"></div>
                    <script type=\"text/javascript\" src=\"qrc:///qtwebchannel/qwebchannel.js\"></script>
                    <script>
                        var tag = document.createElement('script');
                        tag.src = 'https://www.youtube.com/iframe_api';
                        var firstScriptTag = document.getElementsByTagName('script')[0];
                        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
                        var backend, player;

                        function onYouTubeIframeAPIReady() {
                            console.log('YouTube API ready');
                            player = new YT.Player('player', {
                                height: '" + webEngineView.height + "',
                                width:  '" + webEngineView.width + "',
                                videoId: '" + webEngineView.videoId + "',
                                playerVars: { 'rel': 0, 'controls': 0, 'showinfo': 0, 'enablejsapi': 0, 'fs': 0, 'iv_load_policy': 3, 'modestbranding': 1 },
                                events: {
                                    'onReady': onPlayerReady,
                                    'onStateChange': onPlayerStateChange,
                                    'onError': onPlayerError
                                }
                            });
                        }
                        function injectCss() {
                            var css = '.ytp-pause-overlay { display: none !important; } .ytp-show-cards-title { display: none !important; } .ytp-paid-content-overlay { display: none !important; }';
                            var style = document.createElement('style');
                            style.type = 'text/css';
                            style.appendChild(document.createTextNode(css));
                            var iframe = document.getElementsByTagName('iframe')[0];
                            var iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
                            iframeDoc.head.appendChild(style);
                        }
                        function onPlayerReady(event) {
                            // console.log('onPlayerReady()', JSON.stringify(event));
// event.target.videoTitle

                            new QWebChannel(qt.webChannelTransport, function(channel) {
                                backend = channel.objects.backend;
                                // backend.someSignal.connect(function(someText) { alert(\"Got signal: \" + someText); });
                                backend.videoTitle = event.target.videoTitle;
                            });
                            injectCss();
                            event.target.playVideo();
                        }
                        function onPlayerStateChange(event) {
                            console.log('onPlayerStateChange()', JSON.stringify(event.data));
                            if (event.data == YT.PlayerState.PLAYING) { // PLAYING, ENDED, BUFFERING, PAUSED, CUED
                                console.log('YT.PlayerState.PLAYING');
                                backend.setIsPlaying(true);
                            } else {
                                backend.setIsPlaying(false);
                            }
                        }
                        function onPlayerError(event) {
                            console.error('Error occurred: ', event.data);
                        }
                        function playVideo() {
                            if (player && player.playVideo) {
                                console.log('playVideo()');
                                if (player.getPlayerState() === YT.PlayerState.PLAYING) {
                                    player.pauseVideo();
                                } else {
                                    player.playVideo();
                                }
                            }
                        }

                        function pauseVideo() {
                            if (player && player.playVideo) {
                                console.log('pauseVideo()');
                                player.pauseVideo();
                            }
                        }
                    </script>
                </body>
            </html>", "https://www.youtube.com"); // "about:blank");
        }




    }

    function playVideo() {
        webEngineView.runJavaScript("playVideo();")
    }

    function pauseVideo() {
        webEngineView.runJavaScript("pauseVideo();")
    }

    Item {
        id: pauseIcon
        anchors.centerIn: parent
        width: 50
        height: 50
        opacity: webEngineView.isPlaying ? 0.0 : 0.5
        visible: opacity>0
        Behavior on opacity { NumberAnimation {} }

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Math.floor(parent.width*0.35)
            color: "#ffffff"
        }

        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Math.floor(parent.width*0.35)
            color: "#ffffff"
        }
    }
}
