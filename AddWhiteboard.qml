import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls.Material
import QtQuick.Layouts

Dialog {
    height: 500
    width: 600
    anchors.centerIn: parent
    title: "White Board"
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true
    signal whiteboardFormSubmitted(string name, string created_at, string folderpath)

    Material.theme: Material.Light
    Material.primary: Material.Blue
    Material.accent: "#6C63FF"

    function submitForm() {
        if (name.text && created_at.text && folderpath.text) {
            console.log("emitting signal")
            whiteboardFormSubmitted(name.text, created_at.text, folderpath.text)
            name.text = ""
            created_at.text = ""
            folderpath.text = ""
            close() // Close the dialog
        }
    }

    onAccepted: submitForm()

    ColumnLayout {
        spacing: 20

        TextField {
            id: name
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            Layout.topMargin: 25
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("Give a Title")
            font.pixelSize: 17
            Keys.onReturnPressed: created_at.focus = true
            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    created_at.focus = true;
                }
            }
        }

        TextField {
            id: created_at
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("Enter Date")
            font.pixelSize: 17
            Keys.onReturnPressed: folderButton.focus = true
            Keys.onPressed: {
                if (event.key === Qt.Key_Up) {
                    name.focus = true;
                } else if (event.key === Qt.Key_Down) {
                    folderButton.focus = true;
                } else if (event.key === Qt.Key_Left) {
                    name.focus = true;
                }
            }
        }

        Rectangle {
            width: 540
            height: 60
            radius: 7
            anchors.left: parent.left
            Button {
                id: folderButton
                text: "Select Folder"
                onClicked: folderdialog.open()
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                Keys.onReturnPressed: submitForm()
                Keys.onPressed: {
                    if (event.key === Qt.Key_Up) {
                        created_at.focus = true;
                    } else if (event.key === Qt.Key_Left) {
                        created_at.focus = true;
                    }
                }
            }

            FolderDialog {
                id: folderdialog
                title: "Select a Folder"

                onAccepted: {
                    console.log("Selected Folder:", folderdialog.selectedFolder)
                    folderpath.text = folderdialog.selectedFolder
                    folderButton.focus = true
                }
            }

            Label {
                id: folderpath
                text: "Select Whiteboard Assets Folder"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
