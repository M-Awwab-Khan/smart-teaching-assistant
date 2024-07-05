import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Item {
    RowLayout {

        spacing: parent.width / 3
        Button {
            Material.background: "#5D3FD3"
            width: 80
            height: 40
            contentItem: Text {
                text: qsTr("Next Page")
                color: "white"
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                console.log("Next Page Clicked!")
            }
            //anchors.left: parent.Center
            //anchors.leftMargin: 50
            //anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
        }

        Button {
            Material.background: "#5D3FD3"
            width: 80
            height: 40
            contentItem: Text {
                text: qsTr("Retry")
                color: "white"
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                console.log("Next Page Clicked!")
            }
            //anchors.left: parent.Center
            //anchors.leftMargin: 50
            //anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
            enabled: false
        }

        Button {
            Material.background: "#5D3FD3"
            width: 80
            height: 40
            contentItem: Text {
                text: qsTr("Submit Grade")
                color: "white"
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                console.log("Submit Grade! Clicked!")
            }
            //anchors.left: parent.Center
            //anchors.leftMargin: 50
            //anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
        }
    }
}
