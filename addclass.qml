import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs

Dialog {
    id: dialog
    height: 500
    width: 600
    title: "Add Class"
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true
    signal formSubmitted(string className, int studentCount, string teacherName, string centerName)

    function moveFocusDown() {
        if (className.focus) {
            studentCount.forceActiveFocus();
        } else if (studentCount.focus) {
            teacherName.forceActiveFocus();
        } else if (teacherName.focus) {
            centerName.forceActiveFocus();
        }
    }

    function moveFocusUp() {
        if (centerName.focus) {
            teacherName.forceActiveFocus();
        } else if (teacherName.focus) {
            studentCount.forceActiveFocus();
        } else if (studentCount.focus) {
            className.forceActiveFocus();
        }
    }

    onAccepted: {
        console.log("emitting signal");
        formSubmitted(className.text, studentCount.text, teacherName.text, centerName.text)
    }

    ColumnLayout {
        spacing: 20

        TextField {
            id: className
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            Layout.topMargin: 25
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("Class")
            font.pixelSize: 17
            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown();
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp();
                }
            }
        }

        TextField {
            id: studentCount
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("No of students")
            font.pixelSize: 17
            validator: IntValidator {
                bottom: 1
                top: 10000
            }
            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown();
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp();
                }
            }
        }

        TextField {
            id: teacherName
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("Teacher")
            font.pixelSize: 17
            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown();
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp();
                }
            }
        }

        TextField {
            id: centerName
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("Couching Center")
            font.pixelSize: 17
            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown();
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp();
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    dialog.accept();
                }
            }
        }
    }
}
