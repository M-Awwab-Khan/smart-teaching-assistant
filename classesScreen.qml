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

        // The Addclass Dialog Box
        Addclass{
            id:forclass
            visible: false
            anchors.centerIn: parent
            onFormSubmitted: function(className, studentCount, teacherName, centerName){
                        classModel.append({
                            "className": className,
                            "teacherName": teacherName,
                            "studentCount": studentCount,
                            "centerName": centerName
                        })
                    }
        }

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


                Button {
                    background: Rectangle {
                        color: "#6C63FE"
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


            // Heading bar
            Rectangle {
                id: headingBar
                anchors.top: topBar.bottom
                Layout.preferredWidth: parent.width * 0.9
                Layout.alignment: Qt.AlignHCenter
                anchors.topMargin: 40

                RowLayout {
                    width: parent.width
                    height: 40
                    Layout.alignment: Qt.AlignTop

                    Text {
                        text: qsTr("Classes")
                        font.pixelSize: 30
                        font.bold: true
                        color: "#6C63FE"  // Purple color
                        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    }


                    Button {
                        text: "+ Add Class"
                        Material.background: "#6C63FF"
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
                            forclass.open()
                        }
                    }

                }


            }

            Component {
                id: classDelegate
                Rectangle {
                    width: 250
                    height: 200
                    color: "#ECEBFF"
                    radius: 10
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Class clicked: " + className)
                        }
                    }
                    Component.onCompleted: console.log(width, height)
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: -40

                        RowLayout {
                            Layout.preferredWidth:  parent.width
                            Layout.alignment: Qt.AlignTop
                            Layout.topMargin: 20
                            Text {
                                text: model.className
                                font.pixelSize: 22
                                font.bold: true
                                Layout.leftMargin: 20
                                color: "#333333"
                            }
                            Text {
                                text: "👤 " + model.studentCount
                                font.pixelSize: 14
                                Layout.rightMargin: 20
                                Layout.alignment: Qt.AlignRight
                                color: "#666666"
                            }
                        }


                        Text {
                            text: model.teacherName
                            font.pixelSize: 14
                            Layout.leftMargin: 20
                            color: "#666666"
                        }


                        Text {
                            text: model.centerName
                            font.pixelSize: 14
                            Layout.leftMargin: 20
                            color: "#666666"
                        }
                    }
                }

            }

            ListModel {
                id: classModel
                ListElement { className: "Class 9"; teacherName: "Chemistry Teacher"; studentCount: 60; centerName: "Practical Center" }
                ListElement { className: "Class 10"; teacherName: "Math Teacher"; studentCount: 45; centerName: "Science Center" }
                ListElement { className: "Class 11"; teacherName: "Math Teacher"; studentCount: 45; centerName: "Science Center" }
                ListElement { className: "Class 12"; teacherName: "Math Teacher"; studentCount: 45; centerName: "Science Center" }
            }

            // Grid of class cards
            Rectangle {
                Layout.preferredWidth: rootFrame.width * 0.9
                Layout.preferredHeight: rootFrame.height * 0.8
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                Layout.topMargin: 10

                GridView {
                    cellWidth: 270
                    cellHeight: 250
                    clip: true
                    anchors.fill: parent
                    model: classModel
                    delegate: classDelegate
                }

            }

        }
    }
}
