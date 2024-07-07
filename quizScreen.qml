import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import DatabaseHandler 1.0
import QtQuick.Dialogs

Item {
    id: root
    width: parent.width
    height: parent.height

    property int quiz_id
    property int class_id
    property string class_name
    property string quiz_name
    property int total_marks
    property double negative_marking
    property int questions_count
    property string taken_at
    property string answer_key
    property string test_paper_img_path

    function loadMarks() {
        var marks = dbhandler.getMarks(quiz_id, class_id)
        console.log(marks.length)
        marksModel.clear()
        for (var i = 0; i < marks.length; i++) {
            marksModel.append(marks[i])
        }
        console.log("Successfully loaded marks")
    }

    Component.onCompleted: loadMarks()

    DatabaseHandler {
        id: dbhandler
    }

    FileDialog {
        id: saveDialog
        title: "Save Dialog"
        currentFile: "quiz" + quiz_id.toString()
        nameFilters: ["CSV files (*.csv)"]
        fileMode: FileDialog.SaveFile
        onAccepted: {
            dbhandler.exportMarksAsCSV(saveDialog.selectedFile.toString(
                                           ).replace("file:///", ""),
                                       quiz_id, class_id)
        }
    }

    ScrollView {
        contentHeight: 1200
        contentWidth: availableWidth
        anchors.fill: parent
        TitleBar {
            title: class_name
            id: topBar
        }

        Rectangle {
            height: 800
            width: root.width
            id: quizDetails
            anchors.top: topBar.bottom
            anchors.rightMargin: 50
            anchors.leftMargin: 50

            RowLayout {
                anchors.fill: parent
                anchors.rightMargin: 50
                anchors.leftMargin: 50
                anchors.topMargin: -50

                Item {
                    Layout.preferredWidth: 50
                }

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width / 2
                    spacing: 10
                    Layout.topMargin: -30
                    Layout.leftMargin: -30

                    Text {
                        text: quiz_name
                        font.pixelSize: 24
                        Layout.fillWidth: true
                        Layout.maximumWidth: parent.width
                        wrapMode: Text.WordWrap
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.bottomMargin: 20
                        font.bold: true
                    }

                    // Text {
                    //     text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi efficitur est vitae est vehicula cursus. Fusce sodales turpis eget porta ultricies. Nulla facilisi. Maecenas euismod purus odio, in varius justo porta quis. Nullam lobortis, ante non dignissim dictum, nibh metus aliquam nisl, at elementum lectus elit et nibh."
                    //     font.pixelSize: 16
                    //     Layout.fillWidth: true
                    //     Layout.maximumWidth: parent.width
                    //     wrapMode: Text.WordWrap
                    //     Layout.alignment: Qt.AlignJustify | Qt.AlignTop
                    //     Layout.bottomMargin: 20
                    // }
                    Text {
                        text: `Max Marks: ${total_marks}`
                        font.pixelSize: 16
                        Layout.fillWidth: true
                        Layout.maximumWidth: parent.width
                        wrapMode: Text.WordWrap
                        Layout.alignment: Qt.AlignJustify | Qt.AlignTop
                        Layout.bottomMargin: 10
                    }

                    Text {
                        text: `Negative Marking: -${negative_marking}`
                        font.pixelSize: 16
                        Layout.fillWidth: true
                        Layout.maximumWidth: parent.width
                        wrapMode: Text.WordWrap
                        Layout.alignment: Qt.AlignJustify | Qt.AlignTop
                        Layout.bottomMargin: 10
                    }

                    Text {
                        text: `Number of Questions: ${questions_count}`
                        font.pixelSize: 16
                        Layout.fillWidth: true
                        Layout.maximumWidth: parent.width
                        wrapMode: Text.WordWrap
                        Layout.alignment: Qt.AlignJustify | Qt.AlignTop
                    }

                    Button {
                        Material.background: "#6C63FF"
                        width: 80
                        height: 40
                        text: qsTr("Grade")
                        contentItem: Text {
                            text: qsTr("Grade")
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        Layout.topMargin: 10
                        // anchors.top: parent.top
                        // anchors.left: parent.left
                        onClicked: {
                            stackView.push("gradeQuiz.qml", {
                                               "ansKey": answer_key,
                                               "quizId": quiz_id,
                                               "classId": class_id,
                                               "negative_marking": negative_marking
                                           })
                        }
                    }
                }

                Rectangle {
                    anchors.top: topBar.bottom
                    Layout.preferredWidth: parent.width / 2

                    Layout.preferredHeight: 50
                    Layout.fillHeight: true
                    color: "transparent"
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                    Image {
                        source: test_paper_img_path
                        width: parent.width * 0.8
                        height: parent.height * 0.8
                        anchors.topMargin: -100
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }
        }

        Rectangle {
            id: tableRect

            anchors {
                top: quizDetails.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: 100
            }

            Column {
                anchors.centerIn: parent
                spacing: 0
                anchors.topMargin: 100

                Text {
                    id: marksHeading
                    text: "Marks Table"
                    color: "#333333"
                    font.pixelSize: 40
                    font.bold: true
                    // x: (root.width - 250) / 2
                    // y: quizDetails.height - 100
                }

                Button {
                    text: "+ Export As CSV"
                    Material.background: "#6C63FF"
                    font.pixelSize: 16
                    font.bold: true

                    Image {
                        source: "https://www.iconsdb.com/icons/preview/white/download-2-xxl.png"
                        width: 15
                        height: 15

                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 15
                    }

                    contentItem: Text {
                        text: qsTr("    Export As CSV")
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    anchors.right: parent.right
                    anchors.bottomMargin: 30
                    onClicked: {
                        saveDialog.open()
                    }
                }

                // Header Row
                Row {
                    spacing: 0

                    Rectangle {
                        width: 150
                        height: 40
                        color: "#E0E0FF"
                        border.color: "black"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Roll No"
                        }
                    }

                    Rectangle {
                        width: 150
                        height: 40
                        color: "#E0E0FF"
                        border.color: "black"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Correct"
                        }
                    }

                    Rectangle {
                        width: 150
                        height: 40
                        color: "#E0E0FF"
                        border.color: "black"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Wrong"
                        }
                    }

                    Rectangle {
                        width: 150
                        height: 40
                        color: "#E0E0FF"
                        border.color: "black"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Not Attempted"
                        }
                    }

                    Rectangle {
                        width: 150
                        height: 40
                        color: "#E0E0FF"
                        border.color: "black"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Obtained Marks"
                        }
                    }
                }

                ListModel {
                    id: marksModel
                }

                // Data Rows
                ListView {
                    width: 540
                    height: 200
                    spacing: 0
                    model: marksModel

                    delegate: Row {
                        spacing: 0

                        Rectangle {
                            width: 150
                            height: 40
                            border.color: "gray"
                            border.width: 0.5

                            Text {
                                anchors.centerIn: parent
                                text: model.rollNo
                            }
                        }

                        Rectangle {
                            width: 150
                            height: 40
                            border.color: "gray"
                            border.width: 0.5

                            Text {
                                anchors.centerIn: parent
                                text: model.correct
                            }
                        }

                        Rectangle {
                            width: 150
                            height: 40
                            border.color: "gray"
                            border.width: 0.5

                            Text {
                                anchors.centerIn: parent
                                text: model.wrong
                            }
                        }

                        Rectangle {
                            width: 150
                            height: 40
                            border.color: "gray"
                            border.width: 0.5

                            Text {
                                anchors.centerIn: parent
                                text: model.notAttempted
                            }
                        }

                        Rectangle {
                            width: 150
                            height: 40
                            border.color: "gray"
                            border.width: 0.5

                            Text {
                                anchors.centerIn: parent
                                text: model.obtainedMarks
                            }
                        }
                    }
                }
            }
        }
    }
}
