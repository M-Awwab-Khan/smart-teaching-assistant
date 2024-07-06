import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Item {
    id: omrpage
    property string pageId: "omrpage"

    width: parent.width
    height: parent.height

    signal imageCaptured(var img)

    Component.onCompleted: {
        videoStreamerOMR.startStream()
    }

    ColumnLayout {
        RowLayout {
            width: parent.width
            spacing: parent.width / 3

            Button {
                Material.background: "#5D3FD3"
                width: 80
                height: 40
                contentItem: Text {
                    text: qsTr("Next Page")
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    console.log("Next Page Clicked!")
                }
                Layout.alignment: Qt.AlignLeft
            }

            Button {
                Material.background: "#5D3FD3"
                width: 80
                height: 40
                contentItem: Text {
                    text: qsTr("Retry")
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    console.log("Retry Clicked!")
                }
                enabled: false
                Layout.alignment: Qt.AlignRight
            }

            Button {
                Material.background: "#5D3FD3"
                width: 80
                height: 40
                contentItem: Text {
                    text: qsTr("Submit Grade")
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    console.log("Submit Grade Clicked!")
                }
                Layout.alignment: Qt.AlignHCenter
            }
        }

        Image {
            id: omrSpace
            fillMode: Image.PreserveAspectFit
            source: "image://omr/image"
            cache: false
            anchors.centerIn: parent

            function reload() {
                source = "image://omr/image?id=" + Date.now()
            }
        }
    }

    Connections {
        target: OMRImageProvider
        function onImageChanged() {
            omrSpace.reload()
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_S) {
            var img = videoStreamerOMR.getCurrentFrame()
            imageCaptured(img)
        }
    }
}
