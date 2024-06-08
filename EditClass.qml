import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs

Dialog {
    property int iD;
    property string classNamet;
    property int studentCountt;
    property string teacherNamet;
    property string centerNamet;

    id: dialog
    height: 500
    width: 600
    title: "Edit Class"
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true
    signal editformSubmitted(int iD, string classNamet, int studentCountt, string teacherNamet, string centerNamet)


    onAccepted: {
        console.log("emitting signal");
        editformSubmitted(iD, className.text, studentCount.text, teacherName.text, centerName.text)
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
            text: classNamet

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
            text: studentCountt

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
            text: teacherNamet

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

            text: centerNamet

            leftPadding: 20

            color: "black"
            placeholderText: qsTr("Couching Center")
            font.pixelSize: 17
        }
    }
}
