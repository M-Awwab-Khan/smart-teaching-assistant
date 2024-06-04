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
            anchors {
                left: parent.left
            }

            leftPadding: 20

            color: "black"
            placeholderText: qsTr("Class")
            font.pixelSize: 17
        }
        TextField {
            id: studentCount
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60

            anchors {
                left: parent.left
            }

            leftPadding: 20

            color: "black"
            placeholderText: qsTr("No of students")
            font.pixelSize: 17
            validator: IntValidator {
                bottom: 1
                top: 10000
            }
        }
        TextField {
            id: teacherName
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            anchors {
                left: parent.left
            }

            leftPadding: 20

            color: "black"
            placeholderText: qsTr("Teacher")
            font.pixelSize: 17
        }
        TextField {
            id: centerName
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            anchors {
                left: parent.left
            }

            leftPadding: 20

            color: "black"
            placeholderText: qsTr("Couching Center")
            font.pixelSize: 17
        }
    }
}
