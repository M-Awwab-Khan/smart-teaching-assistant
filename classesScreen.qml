import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Controls
import DatabaseHandler 1.0

Item {
    id: classesScreen
    Material.theme: Material.Light
    Material.primary: Material.Blue
    Material.accent: "#6C63FF"

    DatabaseHandler {
        id: dbhandler
        onClassDeleted: function (id) {
            for (var i = 0; i < classModel.count; ++i) {
                if (classModel.get(i).id === id) {
                    classModel.remove(i)
                    break
                }
            }
        }
    }

    function loadClasses() {
        var classes = dbhandler.getClasses()
        classModel.clear()
        for (var i = 0; i < classes.length; i++) {
            classModel.append(classes[i])
        }
        console.log("classes loaded successfully!")
    }

    Component.onCompleted: loadClasses()

    Rectangle {
        id: rootFrame
        anchors.fill: parent
        color: "#FFFFFF"

        Addclass {
            id: forclass
            visible: false
            anchors.centerIn: parent
            onFormSubmitted: function (className, studentCount, teacherName, centerName) {
                console.log("signal received")
                var response = dbhandler.addClass(className,
                                                  Number(studentCount),
                                                  teacherName, centerName)
                console.log(response)
                loadClasses()
            }
        }

        EditClass {
            id: editclass
            visible: false
            anchors.centerIn: parent
            onEditformSubmitted: function (id, classNamet, studentCountt, teacherNamet, centerNamet) {
                console.log("edit signal received")
                var response = dbhandler.editClass(id, classNamet,
                                                   studentCountt, teacherNamet,
                                                   centerNamet)
                console.log(response)
                loadClasses()
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 50

            //Title Bar
            TitleBar {
                title: "Smart Teaching Assistant"
                id: topBar
            }

            // heading bar with add class button
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
                        color: "#6C63FE"
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

            // the class delegate
            Component {
                id: classDelegate

                Rectangle {
                    id: classRect
                    width: 250
                    height: 200
                    color: "#ECEBFF"
                    radius: 10

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: stackView.push('manage_quiz_And_board.qml', {
                                                      "classId": model.id,
                                                      "className": model.className
                                                  })
                    }

                    ColumnLayout {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 10
                        spacing: -10

                        Button {
                            id: editButton
                            Material.background: "transparent"
                            Layout.preferredHeight: 50
                            Layout.preferredWidth: 50
                            Image {
                                source: "edit_icon.png"
                                fillMode: Image.PreserveAspectFit
                                width: 20
                                height: 20
                                anchors.centerIn: parent
                            }

                            onClicked: function () {
                                editclass.iD = model.id
                                editclass.classNamet = model.className
                                editclass.studentCountt = model.studentCount
                                editclass.teacherNamet = model.teacherName
                                editclass.centerNamet = model.centerName
                                editclass.open()
                            }
                        }

                        Button {
                            id: deleteButton
                            Material.background: "transparent"
                            Layout.preferredHeight: 50
                            Layout.preferredWidth: 50
                            Image {
                                source: "delete_icon.png"
                                fillMode: Image.PreserveAspectFit
                                width: 20
                                height: 20
                                anchors.centerIn: parent
                            }

                            onClicked: {
                                deleteDialog.open()
                            }
                        }

                        Dialog {
                            id: deleteDialog
                            title: "Confirm Delete"
                            modal: true
                            height: 150
                            width: 300
                            parent: rootFrame
                            standardButtons: Dialog.Ok | Dialog.Cancel
                            anchors.centerIn: rootFrame

                            Material.theme: Material.Light
                            Material.primary: Material.Blue
                            Material.accent: "#6C63FF"

                            contentItem: Text {
                                text: "Are you sure you want to delete this class?"
                                width: parent.width
                                wrapMode: Text.WordWrap
                            }
                            onAccepted: {
                                dbhandler.deleteClass(model.id)
                            }
                        }
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: -40

                        RowLayout {
                            Layout.preferredWidth: parent.width
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
            }

            // Grid View
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
