import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs
Window {
id:mainwindow
maximumWidth:  640
maximumHeight:  550
minimumWidth:  640
minimumHeight: 550
visible: true
title: qsTr("Hello World")
ListModel
{
id:quizModel
}

ListModel
{
    id:whiteboardModel
}

Dialog {
    id: dialog_quiz
    height: 550
    width: 600
    title: "Add Quiz"
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true
    signal formSubmitted(string title, string date, int marks,string key)

    Material.theme: Material.Light
    Material.primary: Material.Blue
    Material.accent: "#6C63FF"

    // function moveFocusDown() {
    //     if (title.focus) {
    //         date.forceActiveFocus();
    //     } else if (date.focus) {
    //         marks.forceActiveFocus();
    //     }
    // }

    // function moveFocusUp() {
    //     if (centerName.focus) {
    //         teacherName.forceActiveFocus();
    //     } else if (teacherName.focus) {
    //         studentCount.forceActiveFocus();
    //     } else if (studentCount.focus) {
    //         className.forceActiveFocus();
    //     }
    // }

    onAccepted: {
        console.log("emitting signalbasic");
        formSubmitted(title.text, date.text, marks.text,key.text)
        title.text=""
        date.text=""
        marks.text=""
        key.text=""
    }

    ColumnLayout {
        spacing: 20

        TextField {
            id: title
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            Layout.topMargin: 25
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("title")
            font.pixelSize: 17
            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown();
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp();
                }
            }
        }

        TextField {
            id: date
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("date")
            font.pixelSize: 17

            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown();
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp();
                }
            }
        }
        TextField {
            id: key
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("answer Key")
            font.pixelSize: 17

            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown();
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp();
                }
            }
        }

        TextField {
            id: marks
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("marks")
            font.pixelSize: 17
            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown();
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp();
                }
            }
        }
        Rectangle
        {
            width:540
            height:60
            radius: 7
            anchors.left:parent.left
            border.color: "black"
        Button {
                    text: "Select test"
                    onClicked: fileDialog.open()
                    anchors.left: parent.left
                    anchors.leftMargin: 435
                    anchors.verticalCenter: parent.verticalCenter

                }

                FileDialog {
                    id: fileDialog
                    title: "Select a File"

                    nameFilters: ["All Files (*)"]
                    onAccepted: {
                        console.log("Selected file:", fileDialog.fileUrls)
                    }
                }
        }



            }
        }

Dialog {
    id: dialog_whiteboard
    height: 500
    width: 600
    title: "White Board"
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true
    signal formSubmitted2(string name, string date2)

    Material.theme: Material.Light
    Material.primary: Material.Blue
    Material.accent: "#6C63FF"

    // function moveFocusDown() {
    //     if (title.focus) {
    //         date.forceActiveFocus();
    //     } else if (date.focus) {
    //         marks.forceActiveFocus();
    //     }
    // }

    // function moveFocusUp() {
    //     if (centerName.focus) {
    //         teacherName.forceActiveFocus();
    //     } else if (teacherName.focus) {
    //         studentCount.forceActiveFocus();
    //     } else if (studentCount.focus) {
    //         className.forceActiveFocus();
    //     }
    // }

    onAccepted: {
        console.log("emitting signal");
        formSubmitted2(name.text, date2.text)
        name.text=""
        date2.text=""

    }

    ColumnLayout {
        spacing: 20

        TextField {
            id: name
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            Layout.topMargin: 25
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("title")
            font.pixelSize: 17
            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown();
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp();
                }
            }
        }

        TextField {
            id: date2
            Layout.preferredWidth: parent.width / 2 + 270
            Layout.preferredHeight: 60
            leftPadding: 20
            color: "black"
            placeholderText: qsTr("date")
            font.pixelSize: 17

            Keys.onPressed: {
                if (event.key === Qt.Key_Down) {
                    moveFocusDown();
                } else if (event.key === Qt.Key_Up) {
                    moveFocusUp();
                }
            }
        }


            }
        }
ColumnLayout {
    anchors.fill: parent


    Rectangle
    {
        id: topBar
        Layout.preferredHeight: mainwindow.height/11
        color: "#E0E0FF"
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }

        Button {
            Material.background: "#5D3FD3"
            width: (mainwindow.width/10)+20
            height: (mainwindow.height/10)-10
            contentItem: Text {
                text: qsTr("<- Back")
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
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
        }

        Label
        {
            text: "Software Engineering"
            color: "#5D3FD3"
            font.pixelSize: 20
            font.bold: true
            anchors.horizontalCenter:  parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

    }
    Rectangle
    {
        Layout.preferredHeight: 70
        anchors.top:topBar.bottom
        anchors.margins: 40

        anchors {
            left: parent.left
            right: parent.right
        }

    RowLayout
    {

        Rectangle
        {

            height: 40
            width:280
            color: "#E0E0FF"
            anchors.left: parent.left
            anchors.leftMargin: -20
            radius: 7

            Text {
                id: text1
                color: "#5D3FD3"
                text: qsTr("Quizzes")
                font.pixelSize: 20
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 15
                }
            Button
            {
            background: Rectangle {
                    color: "transparent" // Same color as the parent Rectangle to blend in
                    }
                    contentItem: Text {
                        text: "+"
                        color: "#5D3FD3"
                        font.pixelSize: 24
                        font.bold: true
                        leftPadding: 230
                        topPadding: -11
                    }
              onClicked:
                  dialog_quiz.open();
            }


            }


        Rectangle
        {
            height: 40
            width:280
            color: "#E0E0FF"
            radius: 7
            anchors.right: parent.right
            anchors.rightMargin: 15
            Text {
                id: text2
                color: "#5D3FD3"
                text: qsTr("Whiteboards")
                font.pixelSize: 20
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 15
                }
            Button
            {
            background: Rectangle {
                    color: "transparent" // Same color as the parent Rectangle to blend in
                    }
                    contentItem: Text {
                        text: "+"
                        color: "#5D3FD3"
                        font.pixelSize: 24
                        font.bold: true
                        leftPadding: 230
                        topPadding: -12
                    }
              onClicked:
                  dialog_whiteboard.open();
            }






            }
}
}


    ListView {

               anchors.fill: parent
               anchors.leftMargin: 25
               anchors.topMargin: 170
               width: parent.fillHeight
               height: parent.fillWidth
               model: quizModel
               delegate: Item {
                   width: 300
                   height: 70
                   Button {
                       id:myButton2
                       width: 280
                       height: 60
                       background: Rectangle {
                           border.color: "#666666"
                           width: parent.width
                           height: parent.height
                           radius: 7
                       }
                       property string originalText: model.title
                       property string truncatedText: originalText

                       font.pixelSize: 15
                       contentItem: Text {
                                 text: myButton2.truncatedText
                                 font: myButton2.font
                                 anchors.centerIn: parent
                                 horizontalAlignment: Text.AlignLeft
                                 verticalAlignment: Text.AlignVCenter
                                 elide: Text.ElideRight

                             }

                              TextMetrics {
                                  id: textMetrics

                                  font: myButton2.font
                                  text: myButton2.originalText
                              }

                              function truncateText() {


                                  var text = myButton2.originalText;
                                  var metrics = textMetrics.width;

                                  if (metrics > maxWidth) {
                                      var ellipsis = "...";
                                      var ellipsisWidth = textMetrics.widthForText(ellipsis);
                                      var truncatedText = text;

                                      while (metrics + ellipsisWidth > maxWidth && truncatedText.length > 0) {
                                          truncatedText = truncatedText.slice(0, -1);
                                          textMetrics.text = truncatedText;
                                          metrics = textMetrics.width;
                                      }
                                      truncatedText += ellipsis;
                                      myButton2.truncatedText = truncatedText;
                                  } else {
                                      myButton2.truncatedText = text;
                                  }
                              }

                              onWidthChanged: truncateText()
                              onOriginalTextChanged: truncateText()

                              text: truncatedText

                       ColumnLayout {
                           anchors.fill: parent
                           spacing: -10

                           RowLayout {
                               spacing: 95
                               Layout.preferredWidth: parent.width
                               Layout.alignment: Qt.AlignTop
                               Layout.topMargin: 30

                               Text {
                                   text: model.date
                                   font.pixelSize: 12
                                   color: "#666666"
                                   Layout.leftMargin: 20
                                   topPadding: 10
                               }

                               Text {
                                   text: "Max Marks: " + model.marks
                                   color: "#666666"
                                   font.pixelSize: 12
                                   Layout.rightMargin: 45
                                   Layout.alignment: Qt.AlignRight
                                   topPadding: 10
                               }
                           }
                       }
                       onClicked: {
                           console.log("Quiz button clicked");
                       }
                   }
               }
           }
    ListView {

               anchors.fill: parent
               anchors.leftMargin: 310
               anchors.topMargin: 170
               width: parent.fillHeight
               height: parent.fillWidth
               model: whiteboardModel
               delegate: Item {
                   width: 300
                   height: 70
                   Button {
                       id:myButton
                       width: 280
                       height: 60

                       background: Rectangle {
                           border.color: "#666666"
                           width: parent.width
                           height: parent.height
                           radius: 7
                       }
                       property string originalText: model.name
                       property string truncatedText: originalText
                       font.pixelSize: 15
                       contentItem: Text {
                                 text: myButton.truncatedText
                                 font: myButton.font
                                 anchors.centerIn: parent
                                 horizontalAlignment: Text.AlignLeft
                                 verticalAlignment: Text.AlignVCenter
                                 elide: Text.ElideRight


                             }

                              TextMetrics {
                                  id: textMetrics2

                                  font: myButton.font
                                  text: myButton.originalText
                              }

                              function truncateText() {

                                  var text = myButton.originalText;
                                  var metrics = textMetrics2.width;

                                  if (metrics > maxWidth) {
                                      var ellipsis = "...";
                                      var ellipsisWidth = textMetrics2.widthForText(ellipsis);
                                      var truncatedText = text;

                                      while (metrics + ellipsisWidth > maxWidth && truncatedText.length > 0) {
                                          truncatedText = truncatedText.slice(0, -1);
                                          textMetrics.text = truncatedText;
                                          metrics = textMetrics2.width;
                                      }
                                      truncatedText += ellipsis;
                                      myButton.truncatedText = truncatedText;
                                  } else {
                                      myButton.truncatedText = text;
                                  }
                              }

                              onWidthChanged: truncateText()
                              onOriginalTextChanged: truncateText()

                              text: truncatedText

                       ColumnLayout {
                           anchors.fill: parent
                           spacing: -10



                           RowLayout {
                               spacing: 95
                               Layout.preferredWidth: parent.width
                               Layout.alignment: Qt.AlignTop
                               Layout.topMargin: 30

                               Text {
                                   text: model.date2
                                   font.pixelSize: 12
                                   color: "#666666"
                                   Layout.leftMargin: 20
                                   topPadding: 10
                               }


                           }
                       }
                       onClicked: {
                           console.log("White board button clicked");
                       }
                   }
               }
           }
       }

       Connections {
           target: dialog_quiz
           onFormSubmitted: {
               if (title==="" || date==="" || marks==="" || key==="")
               {
                   return 0
               }

               quizModel.append({"title": title, "date": date, "marks": marks,"key":key})
           }

       }
       Connections {
           target: dialog_whiteboard
           onFormSubmitted2: {
               if (name==="" || date2==="")
               {
                   return 0
               }

               whiteboardModel.append({"name": name, "date2": date2})
           }

       }
}



