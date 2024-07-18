import QtQuick 2.0
import QtGraphicalEffects 1.12

Item {
    id: blurDialog
    anchors.fill: parent
    visible: opacity>0
    opacity: 0
    property int   dialogWidth:    640
    property int   dialogHeight:   480
    property int   dialogMinWidth:  320
    property int   dialogMinHeight: 240
    property real  dialogOpacity:  1.0
    property color dialogColor:    darkMode ? "#80000000" : "#80ffffff" // #8ecae6
    property color textColor:      darkMode ? "#ffffff" : "#444444"
    property int   cornerRadius:   48
    property int   blurRadius:     64 // 100
    property alias blurDialog: blurRect
    property alias blurSourceItem: blurSource.sourceItem
    property bool showCloseButton: true
    property bool showResizeButton: true
    property bool showRightHandle: true
    property bool darkMode: false
    property alias resizeTimerInterval: resizeTimer.interval
    default property alias childArea: dialogContentArea.children
    signal resized()
    signal finished()
    onVisibleChanged: {
        if (!visible) { finished(); }
    }
    Component.onCompleted: {
        let xx = blurRect.x;
        let yy = blurRect.y;
        blurRect.x = xx;
        blurRect.y = yy;
    }
/*
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.25
    }

    MouseArea {
        anchors.fill: parent
       onClicked: { close(); }
    }
*/
    function open() { opacity = 1; }

    function close() { opacity = 0; }

    Behavior on opacity { NumberAnimation { duration: 250; } }

    ShaderEffectSource {
        id: blurSource
        sourceRect: Qt.rect(blurRect.x, blurRect.y, blurRect.width, blurRect.height)
        live: true
        // sourceItem: mainContent
    }

    Rectangle {
        id: blurRectMask
        anchors.fill: blurRect
        width: blurRect.width
        height: blurRect.height
        radius: blurDialog.cornerRadius
        color: "#000000"
        visible: false
    }

    DropShadow {
        anchors.fill: blurRect
        source:  blurRectBackgroundRect
        horizontalOffset: 0
        verticalOffset:   0
        radius:  16
        samples: 1 + radius * 2
        color:   "#20ffffff"
        smooth:  true
        antialiasing: true
        enabled: true
        visible: enabled
        cached: false
    }

    Item {
        id: blurRect
        visible: true
        width:  blurDialog.dialogWidth
        height: blurDialog.dialogHeight
        opacity: 1.0
        clip: true
        GaussianBlur { // FastBlur
            id: fastBlur
            anchors.fill: parent
            source: blurSource
            radius: blurDialog.blurRadius
            layer.enabled: true
            layer.effect: OpacityMask { maskSource: blurRectMask }
            cached: false
            deviation: radius/2
            samples: 1+radius*2
        }

        Rectangle {
            id: blurRectBackgroundRect
            anchors.fill: parent
            radius: blurRectMask.radius
            color: blurDialog.dialogColor
            visible: true
            opacity: blurDialog.dialogOpacity
        }

        MouseArea {
            id: dragMouseArea
            anchors.fill: parent
            drag.target: parent
            drag.minimumX: 0
            drag.maximumX: blurDialog.width - blurDialog.dialogWidth
            drag.minimumY: 0
            drag.maximumY: blurDialog.height - blurDialog.dialogHeight
        }

        Item {
            id: resizeItem
            x: blurDialog.dialogWidth  - width
            y: blurDialog.dialogHeight - height
            width: 40
            height: 40
            onXChanged: {
                if (resizeMouseArea.pressed) {
                    blurDialog.dialogWidth = x + width;
                    // console.log("WIDTH",blurDialog.dialogWidth);
                    resizeTimer.start();
                }
            }
            onYChanged: {
                if (resizeMouseArea.pressed) {
                    blurDialog.dialogHeight = y + height;
                    resizeTimer.start();
                }
            }

            Timer {
                id: resizeTimer
                interval: 1000
                repeat: false
                running: false
                onTriggered:  { blurDialog.resized(); }
            }
            MouseArea {
                id: resizeMouseArea
                enabled: blurDialog.showResizeButton
                anchors.fill: parent
                drag.target: parent
                drag.axis: Drag.XAndYAxis
                drag.minimumX: blurDialog.dialogMinWidth
                drag.minimumY: blurDialog.dialogMinHeight
                drag.maximumX: blurDialog.width  - blurRect.x - parent.width  //- 16
                drag.maximumY: blurDialog.height - blurRect.y - parent.height //- 16
                onReleased: { resizeTimer.stop(); blurDialog.resized(); }
            }
        }

        Item {
            id: resizeRightItem
            visible: false
            x: blurDialog.dialogWidth  - width
            anchors.verticalCenter: parent.verticalCenter
            width: 38
            height: 180
            onXChanged: {
                if (resizeRightMouseArea.pressed) {
                    blurDialog.dialogWidth = x + width;
                    resizeTimer.start();
                }
            }

            Row {
                id: rightHandleRow
                anchors.fill: parent
                anchors.margins: 10
                spacing: 2
                Repeater {
                    model: 8
                    Rectangle {
                        width: 1
                        height: rightHandleRow.height
                        color: "#888"
                    }
                }
            }

            MouseArea {
                id: resizeRightMouseArea
                enabled: blurDialog.showRightHandle
                anchors.fill: parent
                drag.target: parent
                drag.axis: Drag.XAndYAxis
                drag.minimumX: blurDialog.dialogMinWidth
                drag.minimumY: blurDialog.dialogMinHeight
                drag.maximumX: blurDialog.width  - blurRect.x - parent.width - 16
                drag.maximumY: blurDialog.height - blurRect.y - parent.height - 16
                onReleased: { resizeTimer.stop(); blurDialog.resized(); }
            }
        }
    }

    Item {
        id: dialogContentArea
        anchors.fill: blurRect
        clip: true
    }


    GGCloseButton {
        id: maxButton
        visible: blurDialog.showResizeButton
        isCloseButton: false
        isMaxSize: (blurDialog.dialogWidth === maxSizeW && blurDialog.dialogHeight === maxSizeH)
        anchors.top: blurRect.top
        anchors.right: closeButton.left
        anchors.rightMargin: 0
        property int maxSizeW: blurDialog.parent.width  - 20;
        property int maxSizeH: blurDialog.parent.height - 20;
        onClicked: {
            if (isMaxSize) {
                blurDialog.dialogWidth  = blurDialog.dialogMinWidth  + 50;
                blurDialog.dialogHeight = blurDialog.dialogMinHeight + 50;
            } else {
                blurDialog.dialogWidth  = maxSizeW;
                blurDialog.dialogHeight = maxSizeH;
            }

            blurRect.x = (blurDialog.parent.width  - blurDialog.dialogWidth)  / 2;
            blurRect.y = (blurDialog.parent.height - blurDialog.dialogHeight) / 2;
            blurDialog.resized();
        }
    }

    GGCloseButton {
        id: closeButton
        anchors.top: blurRect.top
        anchors.right: blurRect.right
        onClicked: { blurDialog.close(); }
        visible: blurDialog.showCloseButton
    }

    Rectangle {
        id: moveIndicator
        height: 8
        radius: height/2
        width: 200
        color: "#40ffffff"
        anchors.horizontalCenter: dialogContentArea.horizontalCenter
        anchors.top: dialogContentArea.bottom
        anchors.topMargin: 8
        visible: opacity>0
        opacity: dragMouseArea.pressed ? 1 : 0
        Behavior on opacity { NumberAnimation {} }
    }

    Item {
        id: resizeIndicator
        clip: true
        anchors.right: dialogContentArea.right
        anchors.bottom: dialogContentArea.bottom
        anchors.margins: -blurDialog.cornerRadius - resizeArc.border.width - 8
        width: blurDialog.cornerRadius*2
        height: blurDialog.cornerRadius*2
        visible: opacity>0
        opacity: (resizeMouseArea.pressed || resizeRightMouseArea.pressed) ? 1 : 0
        Behavior on opacity { NumberAnimation {} }

        Rectangle {
            id: resizeArc
            width: parent.width
            height: parent.height
            x: -width/2
            y: -height/2
            color: "transparent"
            border.width: 8
            border.color: "#40ffffff"
            radius: blurDialog.cornerRadius
        }
    }


}
