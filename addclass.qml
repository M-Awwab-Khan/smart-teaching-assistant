import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs

    Dialog{
        id: dialog
        height:500
        width:600

                title: "Add Class"
                standardButtons: Dialog.Ok | Dialog.Cancel
                modal: true
                visible: true
        ColumnLayout
        {
            spacing:20

        TextField
        {
            Layout.preferredWidth: parent.width/2+270
            Layout.preferredHeight: 60
            Layout.topMargin: 25
            anchors
            {
                left:parent.left

            }

            leftPadding: 20

            color: "black"
            placeholderText: qsTr("Class")
            font.pixelSize: 17

        }
        TextField
        {
            Layout.preferredWidth: parent.width/2+270
            Layout.preferredHeight: 60

            anchors
            {
                left:parent.left
            }

            leftPadding: 20


            color: "black"
            placeholderText: qsTr("No of students")
            font.pixelSize: 17
            validator: IntValidator {bottom: 1; top: 10000}
        }
        TextField
        {
            Layout.preferredWidth: parent.width/2+270
            Layout.preferredHeight: 60
            anchors
            {
                left:parent.left
            }

            leftPadding: 20

            color: "black"
            placeholderText: qsTr("Teacher")
            font.pixelSize: 17

        }
        TextField
        {
            Layout.preferredWidth: parent.width/2+270
            Layout.preferredHeight: 60
            anchors
            {
                left:parent.left
            }

            leftPadding: 20

            color: "black"
            placeholderText: qsTr("Couching Center")
            font.pixelSize: 17

        }
        }
        }








