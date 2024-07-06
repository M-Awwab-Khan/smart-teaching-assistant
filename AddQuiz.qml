import QtQuick.Dialogs
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick

Dialog {
    id: dialog
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

    function submitForm() {
        if (title.text && date.text && questionscount.text &&
            answerkey.text && marks.text && negativemarks.text &&
            filepath.text) {
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
            dialog.close() // Close the dialog
        }
    }

    onAccepted: submitForm

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
            Keys.onReturnPressed: date.focus = true
            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    date.focus = true;
                } else if (event.key === Qt.Key_Right) {
                    date.focus = true;
                }
            }
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
                Keys.onReturnPressed: questionscount.focus = true
                Keys.onPressed: {
                    if (event.key === Qt.Key_Up) {
                        title.focus = true;
                    } else if (event.key === Qt.Key_Down) {
                        questionscount.focus = true;
                    } else if (event.key === Qt.Key_Right) {
                        questionscount.focus = true;
                    }
                }
            }

            TextField {
                id: questionscount
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color: "black"
                placeholderText: qsTr("Enter No. of questions")
                font.pixelSize: 17
                Keys.onReturnPressed: answerkey.focus = true
                Keys.onPressed: {
                    if (event.key === Qt.Key_Up) {
                        date.focus = true;
                    } else if (event.key === Qt.Key_Down) {
                        answerkey.focus = true;
                    } else if (event.key === Qt.Key_Left) {
                        date.focus = true;
                    }
                }
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
            Keys.onReturnPressed: marks.focus = true
            Keys.onPressed: {
                if (event.key === Qt.Key_Up) {
                    questionscount.focus = true;
                } else if (event.key === Qt.Key_Down) {
                    marks.focus = true;
                } else if (event.key === Qt.Key_Left) {
                    questionscount.focus = true;
                } else if (event.key === Qt.Key_Right) {
                    marks.focus = true;
                }
            }
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
                Keys.onReturnPressed: negativemarks.focus = true
                Keys.onPressed: {
                    if (event.key === Qt.Key_Up) {
                        answerkey.focus = true;
                    } else if (event.key === Qt.Key_Down) {
                        negativemarks.focus = true;
                    } else if (event.key === Qt.Key_Left) {
                        answerkey.focus = true;
                    } else if (event.key === Qt.Key_Right) {
                        negativemarks.focus = true;
                    }
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
                Keys.onReturnPressed: fileButton.focus = true
                Keys.onPressed: {
                    if (event.key === Qt.Key_Up) {
                        marks.focus = true;
                    } else if (event.key === Qt.Key_Down) {
                        fileButton.focus = true;
                    } else if (event.key === Qt.Key_Left) {
                        marks.focus = true;
                    }
                }
            }
        }

        Rectangle {
            width: 540
            height: 60
            radius: 7
            anchors.left: parent.left
            Button {
                id: fileButton
                text: "Select test"
                onClicked: fileDialog.open()
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                Keys.onReturnPressed: submitForm()
                Keys.onPressed: {
                    if (event.key === Qt.Key_Up) {
                        negativemarks.focus = true;
                    } else if (event.key === Qt.Key_Left) {
                        negativemarks.focus = true;
                    }
                }
            }

            FileDialog {
                id: fileDialog
                title: "Select a File"

                nameFilters: ["All Files (*)"]
                onAccepted: {
                    console.log("Selected file:", fileDialog.selectedFile)
                    filepath.text = fileDialog.selectedFile
                    fileButton.focus = true
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
