import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: classesScreen
    Material.theme: Material.Light // or Material.Light
    Material.primary: Material.Blue
    Material.accent: Material.Pink
    Rectangle {
        id: rootFrame
        anchors.fill: parent
        color: "#FFFFFF"

        ColumnLayout {
            anchors.fill: parent
            spacing: 50

            // Top bar with Back button and Profile icon
            Rectangle {
                id: topBar
                height: 50
                color: "#E0E0FF"
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                }

                Button {
                    text: qsTr("<- Back")
                    background: Rectangle {
                        color: "transparent"  // Light purple color
                        radius: 10
                    }
                    font.pixelSize: 16
                    font.bold: true
                    onClicked: {
                        stackView.pop()
                    }
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                }


                Button {
                    background: Rectangle {
                        color: "#6C63FE"
                        radius: 10
                    }
                    height: 50
                    width: 50
                    Image {
                        source: "https://icons.veryicon.com/png/o/miscellaneous/rookie-official-icon-gallery/225-default-avatar.png"
                        width: 32
                        height: 32
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent

                    }
                    anchors.right: parent.right
                    anchors.rightMargin: 50
                }

            }

            // Heading bar
            Rectangle {
                id: headingBar
                anchors.top: topBar.bottom
                Layout.preferredWidth: parent.width * 0.9
                Layout.alignment: Qt.AlignHCenter
                anchors.margins: 30

                RowLayout {
                    width: parent.width
                    height: 40
                    Layout.alignment: Qt.AlignTop

                    Text {
                        text: qsTr("Classes")
                        font.pixelSize: 24
                        font.bold: true
                        color: "#6C63FE"  // Purple color
                        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    }

                    Button {

                        background: Rectangle {
                            color: "#6C63FE"  // Purple color
                            radius: 10
                        }
                        font.pixelSize: 16
                        font.bold: true
                        contentItem: Text {
                            text: qsTr("+ Add Class")
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        Layout.alignment: Qt.AlignTop | Qt.AlignRight
                        onClicked: {
                            // Handle add class action here
                        }
                    }
                }

            }

            Component {
                id: classDelegate
                Rectangle {
                    width: 200
                    height: 200
                    color: "#ECEBFF"  // Light purple color
                    radius: 10
                    border.width: 1
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // Handle class card click here
                            console.log("Class clicked: " + className)
                        }
                    }
                    Component.onCompleted: console.log(width, height)
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 15

                        Text {
                            text: model.className
                            font.pixelSize: 18
                            font.bold: true
                            color: "#333333"
                        }

                        Text {
                            text: model.teacherName
                            font.pixelSize: 14
                            color: "#666666"
                        }

                        RowLayout {
                            spacing: 10
                            Text {
                                text: "👤 " + model.studentCount
                                font.pixelSize: 14
                                color: "#666666"
                            }
                        }

                        Text {
                            text: model.centerName
                            font.pixelSize: 14
                            color: "#666666"
                        }
                    }
                }

            }

            ListModel {
                id: classModel
                ListElement { className: "Class 9"; teacherName: "Chemistry Teacher"; studentCount: 60; centerName: "Practical Center" }
                ListElement { className: "Class 10"; teacherName: "Math Teacher"; studentCount: 45; centerName: "Science Center" }

            }

            // Grid of class cards
            Rectangle {
                Layout.preferredWidth: rootFrame.width * 0.9
                Layout.preferredHeight: rootFrame.height * 0.8
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                GridView {
                    anchors.fill: parent
                    model: classModel
                    delegate: classDelegate
                }


            }

        }
    }
}
