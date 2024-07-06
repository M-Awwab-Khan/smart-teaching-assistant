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

    StackView {
        id: stackView
        initialItem: "welcomeScreen.qml"
        anchors.fill: parent

        onCurrentItemChanged: {
            omrManager.connectOMRPage(currentItem)
        }
    }
}
