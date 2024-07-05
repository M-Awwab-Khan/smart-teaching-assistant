import QtQuick.Dialogs
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick

Dialog {
    height: 550
    width: 600
    anchors.centerIn: parent
    title: "Add Quiz"
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true
    signal quizFormSubmitted(string title, string date, int questionscount, string answerkey, int marks, double negativemarks, string filepath)

    Material.theme: Material.Light
    Material.primary: Material.Blue
    Material.accent: "#6C63FF"

    onAccepted: {
        console.log("emitting signalbasic")
        quizFormSubmitted(title.text, date.text, questionscount.text,
                          answerkey.text, marks.text, negativemarks.text,
                          filepath.text)
        title.text = ""
        date.text = ""
        questionscount.text = ""
        marks.text = ""
        answerkey.text = ""
        filepath.text = ""
        negativemarks.text = ""
    }

    ColumnLayout {
        spacing: 20

        TextField {
            id: title
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            Layout.topMargin: 25
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("Enter Title")
            font.pixelSize: 17
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            TextField {
                id: date
                Layout.preferredWidth: parent.width / 2
                Layout.preferredHeight: 60
                leftPadding: 20
                color: "black"
                placeholderText: qsTr("Enter Date")
                font.pixelSize: 17
            }

            TextField {
                id: questionscount
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color: "black"
                placeholderText: qsTr("Enter No. of questions")
                font.pixelSize: 17
            }
        }

        TextField {
            id: answerkey
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("Enter Answer Key")
            font.pixelSize: 17
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            TextField {
                id: marks
                Layout.preferredWidth: parent.width / 2
                Layout.preferredHeight: 60
                leftPadding: 20
                color: "black"
                placeholderText: qsTr("Enter Total Marks")
                font.pixelSize: 17
                validator: IntValidator {
                    bottom: 1
                    top: 100
                }
            }

            TextField {
                id: negativemarks
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color: "black"
                placeholderText: qsTr("Enter Negative Marks")
                font.pixelSize: 17
                validator: DoubleValidator {
                    bottom: 0
                    top: 3
                }
            }
        }

        Rectangle {
            width: 540
            height: 60
            radius: 7
            anchors.left: parent.left
            Button {
                text: "Select test"
                onClicked: fileDialog.open()
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }

            FileDialog {
                id: fileDialog
                title: "Select a File"

                nameFilters: ["All Files (*)"]
                onAccepted: {
                    console.log("Selected file:", fileDialog.selectedFile)
                    filepath.text = fileDialog.selectedFile
                }
            }

            Label {
                id: filepath
                text: "File path"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
