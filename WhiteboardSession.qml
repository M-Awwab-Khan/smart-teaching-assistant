import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs

Item {
    property string folderpath
    property bool dialogopen
    width: parent.width
    height: parent.height
    visible: true
    id: focusArea
    focus: true

    Material.theme: Material.Light
    Material.primary: Material.Blue
    Material.accent: "#6C63FF"

    Component.onCompleted: function () {
        videoStreamer.startStream(0)
        focusArea.focus = true
    }

    Component.onDestruction: videoStreamer.stopStream()
    RowLayout {
        id: buttons
        width: parent.width
        height: 50
        spacing: (width / 4) - 100

        Button {
            Material.background: "#5D3FD3"
            width: 80
            height: 40
            contentItem: Text {
                text: qsTr("Clear")
                color: "white"
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            // anchors.top: parent.top
            // anchors.left: parent.left
            onClicked: {
                whiteboardManager.clearWhiteboard()
            }
        }

        Button {
            Material.background: "#5D3FD3"
            width: 80
            height: 40
            contentItem: Text {
                text: qsTr("Back")
                color: "white"
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            // anchors.bottom: parent.bottom
            // anchors.left: parent.left
            onClicked: stackView.pop()
        }

        Button {
            Material.background: "#5D3FD3"
            width: 150
            height: 40
            contentItem: Text {
                text: qsTr("Save Snapshot")
                color: "white"
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            // anchors.top: parent.top
            // anchors.right: parent.right
            onClicked: {
                snapshotDialog.forceActiveFocus()
                snapshotDialog.open()
            }
        }

        Button {
            Material.background: "#5D3FD3"
            width: 150
            height: 40
            contentItem: Text {
                text: qsTr("Upload Image")
                color: "white"
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            // anchors.horizontalCenter: parent.horizontalCenter
            text: "Upload Image"
            onClicked: {
                fileDialog.open()
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select an Image"
        onAccepted: {
            whiteboardManager.loadImage(fileDialog.selectedFile.toString(
                                            ).replace("file:///", ""))
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    Image {
        id: whiteboardSpace
        fillMode: Image.PreserveAspectFit
        width: 800
        height: 600
        anchors.top: buttons.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        source: "image://whiteboard/image"
        cache: false
        function reload() {
            source = "image://whiteboard/image?id=" + Date.now()
        }
    }

    Dialog {
        id: snapshotDialog
        title: "Save Snapshot"
        standardButtons: Dialog.Ok | Dialog.Cancel
        width: 300
        height: 250
        anchors.centerIn: parent
        modal: true

        ColumnLayout {
            spacing: 10
            width: parent.width
            Text {
                text: "Enter the name for the snapshot:"
                Layout.alignment: Qt.AlignLeft
            }
            TextField {
                id: snapshotNameInput
                placeholderText: "Snapshot name"
                Layout.fillWidth: true
            }
        }

        onAccepted: {
            var rawPath = folderpath + "/" + snapshotNameInput.text + ".png"
            var cleanedPath = rawPath.replace("file:///", "")
            whiteboardManager.saveSnapshot(cleanedPath)
            console.log("Snapshot saved to " + cleanedPath)
            focusArea.focus = true
        }

        onRejected: {
            console.log("Snapshot save canceled")
            focusArea.focus = true
        }
    }

    Connections {
        target: whiteboardImageProvider
        function onImageChanged() {
            whiteboardSpace.reload()
        }
    }

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
}
