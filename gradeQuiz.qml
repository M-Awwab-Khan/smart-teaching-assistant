import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import DatabaseHandler 1.0

Item {
    id: omrpage
    property string pageId: "omrpage"
    property int pNo: 1
    property int quizId
    property int classId
    property string ansKey

    width: parent.width
    height: parent.height

    signal imageCaptured(var img, bool firstPage, string ansKey)

    Component.onCompleted: {
        videoStreamerOMR.startStream()
    }

    Component.onDestruction: {
        videoStreamerOMR.stopStream()
    }

    DatabaseHandler {
        id: dbhandler
    }

    ColumnLayout {
        width: parent.width
        RowLayout {
            Layout.fillWidth: true
            spacing: (parent.width - 100) / 4

            Button {
                Material.background: "#5D3FD3"
                width: 80
                height: 40
                anchors.top: omrSpace.bottom
                contentItem: Text {
                    text: qsTr("Back")
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    console.log("Back Clicked!")
                    stackView.pop()
                }
            }

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
                    retryButton.enabled = true
                    pNo += 1
                }
            }

            Button {
                id: retryButton
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
                    pNo = 1
                    console.log("Retry Clicked!")
                    omrManager.retry()
                }
                enabled: false
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
                    var result = omrManager.returnGrade()
                    var response = dbhandler.uploadQuizMarks(
                                quizId, classId, result["rollNo"],
                                result["correct"], result["wrong"],
                                result["unattempted"], result["obtained"])
                    if (!response) {
                        console.log("Failed to upload quiz marks")
                    } else {
                        console.log("Successfully uploaded quiz marks")
                    }

                    pNo = 1
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Image {
                id: omrSpace
                fillMode: Image.PreserveAspectFit
                source: "image://omr/image"
                cache: false
                Layout.preferredWidth: 600
                Layout.preferredHeight: 900
                transform: Rotation {
                    id: rotateImagePhoto
                    angle: 90
                    origin.x: omrSpace.width / 2
                    origin.y: omrSpace.height / 2
                }

                Layout.topMargin: -130
                Layout.alignment: Qt.AlignLeft

                function reload() {
                    source = "image://omr/image?id=" + Date.now()
                }
            }

            Image {
                id: scannedSpace
                fillMode: Image.PreserveAspectFit
                source: "image://scanned/image"
                cache: false
                Layout.preferredWidth: 400
                Layout.preferredHeight: 600

                Layout.topMargin: -130
                Layout.alignment: Qt.AlignRight

                function reload() {
                    source = "image://scanned/image?id=" + Date.now()
                }
            }
        }
    }

    Connections {
        target: OMRImageProvider
        function onImageChanged() {
            omrSpace.reload()
        }
    }

    Connections {
        target: scannedImageProvider
        function onImageChanged() {
            scannedSpace.reload()
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_S) {
            console.log(ansKey)
            var img = videoStreamerOMR.getCurrentFrame()
            if (pNo == 1) {
                imageCaptured(img, true, ansKey)
            } else {
                imageCaptured(img, false, ansKey)
            }
        }
    }
}
