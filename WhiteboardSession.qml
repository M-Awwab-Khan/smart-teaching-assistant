import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform

Item {
    width: Screen.width
    height: Screen.height
    visible: true
    focus: true

    Component.onCompleted: function () {
        videoStreamer.startStream()
        focusArea.focus = true
    }

    Component.onDestruction: videoStreamer.stopStream()

    Button {
        width: 100
        height: 50
        text: "Clear Whiteboard"
        anchors.top: parent.top
        anchors.left: parent.left
        onClicked: whiteboardManager.clearWhiteboard()
    }

    Button {
        width: 100
        height: 50
        text: "Back"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        onClicked: stackView.pop()
    }

    Button {
        width: 100
        height: 50
        text: "Save Snapshot"
        anchors.top: parent.top
        anchors.right: parent.right
        onClicked: {
            var filePath = "snapshot1.png"
            whiteboardManager.saveSnapshot(filePath)
            console.log("Snapshot saved to " + filePath)
        }
    }

    Button {
        width: 100
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Upload Image"
        onClicked: {
            fileDialog.open()
            focusArea.focus = true
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select an Image"
        onAccepted: {
            whiteboardManager.loadImage(fileDialog.file.toString())
            focusArea.focus = true
        }
        onRejected: {
            console.log("Canceled")
            focusArea.focus = true
        }
    }

    RowLayout {
        id: imageRect
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height

        Item {
            id: focusArea
            Layout.preferredHeight: 600
            Layout.preferredWidth: 800
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            focus: true
            Keys.onPressed: {
                if (event.key === Qt.Key_Control) {
                    whiteboardManager.enableDrawing()
                }
            }

            Keys.onReleased: {
                if (event.key === Qt.Key_Control) {
                    whiteboardManager.disableDrawing()
                }
            }

            Image {
                id: whiteboardSpace
                fillMode: Image.PreserveAspectFit
                source: "image://whiteboard/image"
                cache: false
                function reload() {
                    source = "image://whiteboard/image?id=" + Date.now()
                }
            }
        }
    }

    Connections {
        target: whiteboardImageProvider
        function onImageChanged() {
            whiteboardSpace.reload()
            focusArea.focus = true
        }
    }
}
