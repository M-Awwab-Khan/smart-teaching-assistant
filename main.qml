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

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        RowLayout {
            id: rowLayout
            anchors.fill: parent
            anchors.margins: 20


            // Left Side (Image Content)
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2
                color: "transparent"

                Image {
                    id: illustration
                    anchors.centerIn: parent
                    source: "welcome_illustration.svg" // Provide the path to your image
                    fillMode: Image.PreserveAspectFit
                    width: parent.width * 0.4
                    height: parent.height * 0.8
                }
            }


            ColumnLayout {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width / 2
                spacing: 20

                Text {
                    text: "Welcome to Smart Teaching Assistant"
                    font.pixelSize: 24
                    Layout.fillWidth: true
                    Layout.maximumWidth: parent.width
                    wrapMode: Text.WordWrap
                    Layout.alignment: Qt.AlignLeft
                }

                Text {
                    text: qsTr("Grade your students' tests using OMR and use Virtual Whiteboard to conduct live sessions.")
                    font.pixelSize: 16
                    Layout.fillWidth: true
                    Layout.maximumWidth: parent.width
                    wrapMode: Text.WordWrap
                    Layout.alignment: Qt.AlignLeft
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


}
