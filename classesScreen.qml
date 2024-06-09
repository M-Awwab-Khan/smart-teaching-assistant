import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Controls
import DatabaseHandler 1.0

Item {
    id: classesScreen
    Material.theme: Material.Light
    Material.primary: Material.Blue
    Material.accent: Material.Pink

    DatabaseHandler {
        id: dbhandler
        onClassDeleted: function(id) {
            for (var i = 0; i < classModel.count; ++i) {
                if (classModel.get(i).id === id) {
                    classModel.remove(i);
                    break;
                }
            }
        }
    }

    function loadClasses() {
        var classes = dbhandler.getClasses();
        classModel.clear();
        for (let i = 0; i < classes.length; i++) {
            classModel.append(classes[i]);
        }
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
            onFormSubmitted: function(className, studentCount, teacherName, centerName) {
                console.log("signal received");
                var response = dbhandler.addClass(className, Number(studentCount), teacherName, centerName);
                console.log(response);
                loadClasses();
            }
        }

        EditClass {
            id: editclass
            visible: false
            anchors.centerIn: parent
            onEditformSubmitted: function(id, classNamet, studentCountt, teacherNamet, centerNamet) {
                console.log("edit signal received");
                var response = dbhandler.editClass(id, classNamet, studentCountt, teacherNamet, centerNamet);
                console.log(response);
                loadClasses();
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 50

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
                    }

                    RowLayout {
                        spacing: 10
                        anchors.centerIn: parent

                        Button {
                            id: editButton
                            Material.background: "#6C63FF"
                            Image {
                                source: "https://www.iconsdb.com/icons/preview/white/edit-xxl.png"
                                fillMode: Image.PreserveAspectFit
                                width: 20
                                height: 20
                                anchors.centerIn: parent
                            }

                            onClicked: function() {
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
                            Material.background: "#6C63FF"
                            Image {
                                source: "https://www.iconsdb.com/icons/preview/white/delete-xxl.png"
                                fillMode: Image.PreserveAspectFit
                                width: 20
                                height: 20
                                anchors.centerIn: parent
                            }

                            onClicked: {
                                deleteDialog.open();
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
                            contentItem: Text {
                                text: "Are you sure you want to delete this class?"
                                width: parent.width
                                wrapMode: Text.WordWrap

                            }
                            onAccepted: {
                                dbhandler.deleteClass(model.id);
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
