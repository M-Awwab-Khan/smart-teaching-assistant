import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material


Window {
    id: root
    width: 1100
    height: 600
    visible: true
    title: qsTr("Smart Teaching Assistant")

    minimumHeight: 430
    minimumWidth: 750

    Material.theme: Material.Light // or Material.Light
    Material.primary: Material.Blue
    Material.accent: Material.Pink

    RowLayout {
        width : parent.width * 0.8
        height: parent.height * 0.6
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter


        Image {
            source: "welcome-withoutbg.png"
            Layout.maximumWidth: parent.width
            Layout.maximumHeight: parent.height
            Layout.minimumHeight: parent.height * 0.4
            Layout.minimumWidth: parent.width * 0.4
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
        }

        ColumnLayout {
            spacing: 20
            width: parent.width * 0.4
            Text {
                text: "Welcome to Smart Teaching Assistant"
                font.pixelSize: 24
                Layout.maximumWidth: parent.width * 0.9
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            }

            Text {
                text: qsTr("Grade your students' tests using OMR and use Virtual Whiteboard to conduct live sessions.")
                font.pixelSize: 16
                Layout.maximumWidth: parent.width
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            }

            Button {
                text: "Get Started"
                width: 150
                height: 40
                Material.background: "#6C63FF"

                contentItem: Text {
                    text: qsTr("Get Started")
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            }
        }
    }

}
