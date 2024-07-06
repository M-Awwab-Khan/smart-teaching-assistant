import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Item {

    ScrollView
    {
        anchors.fill: parent
        contentHeight: 800


    Rectangle {
        id: topBar
        height: 50
        width: parent.width
        color: "#E0E0FF"
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }

        Button {
            Material.background: "#5D3FD3"
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

        Label {
            text: "Software Engineering"
            color: "#5D3FD3"
            font.pixelSize: 20
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20

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
                text: "Graded Quiz 1 | Agile Methodology"
                font.pixelSize: 24
                Layout.fillWidth: true
                Layout.maximumWidth: parent.width
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.bottomMargin: 20
            }

            Text {
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi efficitur est vitae est vehicula cursus. Fusce sodales turpis eget porta ultricies. Nulla facilisi. Maecenas euismod purus odio, in varius justo porta quis. Nullam lobortis, ante non dignissim dictum, nibh metus aliquam nisl, at elementum lectus elit et nibh."
                font.pixelSize: 16
                Layout.fillWidth: true
                Layout.maximumWidth: parent.width
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignJustify | Qt.AlignTop
                Layout.bottomMargin: 20
            }

            Text {
                text: "Max Marks: 20"
                font.pixelSize: 16
                Layout.fillWidth: true
                Layout.maximumWidth: parent.width
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignJustify | Qt.AlignTop
                font.bold: true
                Layout.bottomMargin: 10
            }

            Text {
                text: "Negative Marking: -1"
                font.pixelSize: 16
                Layout.fillWidth: true
                Layout.maximumWidth: parent.width
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignJustify | Qt.AlignTop
                font.bold: true
                Layout.bottomMargin: 10
            }

            Text {
                text: "Number of Questions: 20"
                font.pixelSize: 16
                Layout.fillWidth: true
                Layout.maximumWidth: parent.width
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignJustify | Qt.AlignTop
                font.bold: true
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
                source: "quiz.jpg"
                width: parent.width * 0.8
                height: parent.height * 0.8
                anchors.topMargin: -100
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    Rectangle {

           anchors
           {
               top:parent.top
               horizontalCenter:parent.horizontalCenter
               topMargin:600
           }


           color: "#f0f0f0"

           Column {
               anchors.centerIn: parent
               spacing: 0

               // Header Row
               Row {
                   spacing: 0

                   Rectangle {
                       width: 100
                       height: 40
                       color: "#e0e0e0"
                       border.color: "black"
                       border.width: 1

                       Text {
                           anchors.centerIn: parent
                           text: "Roll No"
                           font.bold: true
                       }
                   }

                   Rectangle {
                       width: 100
                       height: 40
                       color: "#e0e0e0"
                       border.color: "black"
                       border.width: 1

                       Text {
                           anchors.centerIn: parent
                           text: "Correct"
                           font.bold: true
                       }
                   }

                   Rectangle {
                       width: 100
                       height: 40
                       color: "#e0e0e0"
                       border.color: "black"
                       border.width: 1

                       Text {
                           anchors.centerIn: parent
                           text: "Wrong"
                           font.bold: true
                       }
                   }

                   Rectangle {
                       width: 120
                       height: 40
                       color: "#e0e0e0"
                       border.color: "black"
                       border.width: 1

                       Text {
                           anchors.centerIn: parent
                           text: "Not Attempted"
                           font.bold: true
                       }
                   }

                   Rectangle {
                       width: 120
                       height: 40
                       color: "#e0e0e0"
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
                       ListElement { rollNo: "001"; correct: 18; wrong: 2; notAttempted: 0; obtainedMarks: 16.0 }
                       ListElement { rollNo: "002"; correct: 17; wrong: 1; notAttempted: 2; obtainedMarks: 16.0 }
                       ListElement { rollNo: "003"; correct: 20; wrong: 0; notAttempted: 0; obtainedMarks: 20.0 }
                       ListElement { rollNo: "001"; correct: 18; wrong: 2; notAttempted: 0; obtainedMarks: 16.0 }
                       ListElement { rollNo: "002"; correct: 17; wrong: 1; notAttempted: 2; obtainedMarks: 16.0 }
                       ListElement { rollNo: "003"; correct: 20; wrong: 0; notAttempted: 0; obtainedMarks: 200.0 }
                   }

                   delegate: Row {
                       spacing: 0

                       Rectangle {
                           width: 100
                           height: 40
                           border.color: "black"
                           border.width: 1

                           Text {
                               anchors.centerIn: parent
                               text: model.rollNo
                           }
                       }

                       Rectangle {
                           width: 100
                           height: 40
                           border.color: "black"
                           border.width: 1

                           Text {
                               anchors.centerIn: parent
                               text: model.correct
                           }
                       }

                       Rectangle {
                           width: 100
                           height: 40
                           border.color: "black"
                           border.width: 1

                           Text {
                               anchors.centerIn: parent
                               text: model.wrong
                           }
                       }

                       Rectangle {
                           width: 120
                           height: 40
                           border.color: "black"
                           border.width: 1

                           Text {
                               anchors.centerIn: parent
                               text: model.notAttempted
                           }
                       }

                       Rectangle {
                           width: 120
                           height: 40
                           border.color: "black"
                           border.width: 1

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
