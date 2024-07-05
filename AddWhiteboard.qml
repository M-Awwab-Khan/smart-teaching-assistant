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

    onAccepted: {
        console.log("emitting signal")
        whiteboardFormSubmitted(name.text, created_at.text, folderpath.text)
        name.text = ""
        created_at.text = ""
    }

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
        }

        TextField {
            id: created_at
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("Enter Date")
            font.pixelSize: 17

        }

        Rectangle {
            width: 540
            height: 60
            radius: 7
            anchors.left: parent.left
            Button {
                text: "Select Folder"
                onClicked: folderdialog.open()
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }

            FolderDialog {
                id: folderdialog
                title: "Select a Folder"

                onAccepted: {
                    console.log("Selected Folder:", folderdialog.selectedFolder)
                    folderpath.text = folderdialog.selectedFolder
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
