import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

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
                        font.bold: true
                        Layout.bottomMargin: 10
                    }

                    Text {
                        text: `Negative Marking: -${negative_marking}`
                        font.pixelSize: 16
                        Layout.fillWidth: true
                        Layout.maximumWidth: parent.width
                        wrapMode: Text.WordWrap
                        Layout.alignment: Qt.AlignJustify | Qt.AlignTop
                        font.bold: true
                        Layout.bottomMargin: 10
                    }

                    Text {
                        text: `Number of Questions: ${questions_count}`
                        font.pixelSize: 16
                        Layout.fillWidth: true
                        Layout.maximumWidth: parent.width
                        wrapMode: Text.WordWrap
                        Layout.alignment: Qt.AlignJustify | Qt.AlignTop
                        font.bold: true
                    }

                    Button {
                        Material.background: "#5D3FD3"
                        width: 80
                        height: 40
                        contentItem: Text {
                            text: qsTr("Grade")
                            color: "white"
                            font.pixelSize: 16
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        // anchors.top: parent.top
                        // anchors.left: parent.left
                        onClicked: {
                            stackView.push("gradeQuiz.qml")
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

        Text {
            id: marksHeading
            text: "Student's Marks"
            color: "#666666"
            font.pixelSize: 40
            font.bold: true
            x: (root.width - 250) / 2
            y: quizDetails.height - 100
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
                            font.bold: true
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
                            font.bold: true
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
                            font.bold: true
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
                            font.bold: true
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
                            font.bold: true
                        }
                    }
                }

                // Data Rows
                ListView {
                    width: 540
                    height: 200
                    spacing: 0
                    model: ListModel {
                        ListElement {
                            rollNo: "001"
                            correct: 18
                            wrong: 2
                            notAttempted: 0
                            obtainedMarks: 16.0
                        }
                        ListElement {
                            rollNo: "002"
                            correct: 17
                            wrong: 1
                            notAttempted: 2
                            obtainedMarks: 16.0
                        }
                        ListElement {
                            rollNo: "003"
                            correct: 20
                            wrong: 0
                            notAttempted: 0
                            obtainedMarks: 20.0
                        }
                        ListElement {
                            rollNo: "001"
                            correct: 18
                            wrong: 2
                            notAttempted: 0
                            obtainedMarks: 16.0
                        }
                        ListElement {
                            rollNo: "002"
                            correct: 17
                            wrong: 1
                            notAttempted: 2
                            obtainedMarks: 16.0
                        }
                        ListElement {
                            rollNo: "003"
                            correct: 20
                            wrong: 0
                            notAttempted: 0
                            obtainedMarks: 200.0
                        }
                    }

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
