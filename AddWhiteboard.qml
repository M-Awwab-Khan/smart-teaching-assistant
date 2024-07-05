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
    signal formSubmitted2(string name, string created_at)

    Material.theme: Material.Light
    Material.primary: Material.Blue
    Material.accent: "#6C63FF"

    onAccepted: {
        console.log("emitting signal")
        formSubmitted2(name.text, created_at.text, assets_path.text)
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
            placeholderText: qsTr("title")
            font.pixelSize: 17
            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown()
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp()
                }
            }
        }

        TextField {
            id: created_at
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("date")
            font.pixelSize: 17

            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown()
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp()
                }
            }
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
