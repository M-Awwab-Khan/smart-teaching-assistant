import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls

Rectangle {

    property string title: ""
    id: topBar
    height: 50
    color: "#E0E0FF"
    anchors {
        left: parent.left
        top: parent.top
        right: parent.right
    }

    // back button
    Button {
        text: qsTr("← Back")
        Material.background: "#6C63FF"
        width: 80
        height: 40
        contentItem: Text {
            text: qsTr("Back")
            color: "white"
            font.pixelSize: 16
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: {
            stackView.pop()
        }
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.verticalCenter: parent.verticalCenter
    }

    Label {
        text: title
        color: "#6C63FF"
        font.pixelSize: 20
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    // profile icon
    Button {
        background: Rectangle {
            color: "#6C63FF"
            radius: 10
        }
        height: 50
        width: 50
        Image {
            source: "https://static-00.iconduck.com/assets.00/avatar-icon-256x256-lc2hm878.png"
            width: 25
            height: 25
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
        }
        anchors.right: parent.right
        anchors.rightMargin: 50
    }
}
