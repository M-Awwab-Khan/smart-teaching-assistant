import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs
import DatabaseHandler 1.0

Item {
    id: mainwindow
    anchors.fill: parent

    property int classId

    function loadQuizzes() {
        var quizzes = dbhandler.getQuizzes(classId)
        quizModel.clear()
        for (var i = 0; i < quizzes.length; i++) {
            quizModel.append(quizzes[i])
        }
        console.log("quizzes loaded successfully!")
    }

    function loadWhiteboards() {
        var whiteboards = dbhandler.getWhiteboards(classId)
        whiteboardModel.clear()
        for (var i = 0; i < whiteboards.length; i++) {
            whiteboardModel.append(whiteboards[i])
        }
        console.log("whiteboards loaded successfully!")
    }

    Component.onCompleted: function () {
        loadQuizzes()
        loadWhiteboards()
    }

    DatabaseHandler {
        id: dbhandler
    }

    ListModel {
        id: quizModel
    }

    ListModel {
        id: whiteboardModel
    }

    AddQuiz {
        id: dialog_quiz
        visible: false
        anchors.centerIn: parent
        onQuizFormSubmitted: function (title, date, questionscount, answerkey, marks, negativemarks, filepath) {
            console.log("add quiz signal received")
            var response = dbhandler.addQuiz(classId, title, date,
                                             Number(questionscount),
                                             Number(marks),
                                             Number(negativemarks),
                                             answerkey, filepath)
            console.log(`is your quiz added: ${response}`)
            loadQuizzes()
        }
    }

    AddWhiteboard {
        id: dialog_whiteboard
        visible: false
        anchors.centerIn: parent
        onWhiteboardFormSubmitted: function (name, created_at, folderpath) {
            console.log("add whiteboard signal received")
            var response = dbhandler.addWhiteboard(classId, name, created_at,
                                                   folderpath)
            console.log(`is your whiteboard added: ${response}`)
            loadWhiteboards()
        }
    }

    ColumnLayout {
        anchors.fill: parent

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

        Rectangle {
            id: contentFrame
            width: 670
            height: 600

            anchors {
                top: topBar.bottom
                horizontalCenter: topBar.horizontalCenter
                topMargin: 80
            }

            ColumnLayout {

                RowLayout {
                    id: headingsRow
                    spacing: 30

                    Rectangle {
                        id: quizHeading
                        height: 40
                        color: "#E0E0FF"
                        radius: 7
                        Layout.fillWidth: true

                        RowLayout {
                            anchors.fill: parent

                            Text {
                                id: text1
                                color: "#5D3FD3"
                                text: qsTr("Quizzes")
                                font.pixelSize: 20
                                font.bold: true
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                Layout.fillHeight: true
                                Layout.topMargin: 6
                                Layout.leftMargin: 10
                            }
                            Button {
                                Layout.alignment: Qt.AlignRight
                                Layout.rightMargin: 5
                                Layout.topMargin: -10
                                Material.background: "transparent"
                                contentItem: Text {
                                    text: "+"
                                    color: "#5D3FD3"
                                    font.pixelSize: 24
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                onClicked: {
                                    dialog_quiz.open()
                                    console.log("open dialog quiz")
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: whiteboardHeading
                        height: 40
                        color: "#E0E0FF"
                        radius: 7
                        Layout.fillWidth: true

                        RowLayout {
                            anchors.fill: parent

                            Text {
                                id: text2
                                color: "#5D3FD3"
                                text: qsTr("Whiteboards")
                                font.pixelSize: 20
                                font.bold: true
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                Layout.fillHeight: true
                                Layout.topMargin: 6
                                Layout.leftMargin: 10
                            }
                            Button {
                                Layout.alignment: Qt.AlignRight
                                Layout.topMargin: -10
                                Layout.rightMargin: 5
                                Material.background: "transparent"
                                contentItem: Text {
                                    text: "+"
                                    color: "#5D3FD3"
                                    font.pixelSize: 24
                                    font.bold: true
                                }
                                onClicked: dialog_whiteboard.open()
                            }
                        }
                    }
                }

                // the two list views
                RowLayout {
                    id: listviews
                    spacing: 30

                    ListView {
                        width: 320
                        height: 400
                        clip: true
                        model: quizModel
                        anchors {
                            left: contentFrame.left
                            top: headingsRow.bottom
                        }

                        delegate: Item {
                            width: 320
                            height: 70
                            Button {
                                id: myButton2
                                width: 320
                                height: 60
                                background: Rectangle {
                                    border.color: "#666666"
                                    width: parent.width
                                    height: parent.height
                                    radius: 7
                                }
                                property string originalText: model.quiz_name
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

                                    var text = myButton2.originalText
                                    var metrics = textMetrics.width
                                    var maxWidth = 100
                                    if (metrics > maxWidth) {
                                        var ellipsis = "..."
                                        var ellipsisWidth = textMetrics.widthForText(
                                                    ellipsis)
                                        var truncatedText = text

                                        while (metrics + ellipsisWidth > maxWidth
                                               && truncatedText.length > 0) {
                                            truncatedText = truncatedText.slice(
                                                        0, -1)
                                            textMetrics.text = truncatedText
                                            metrics = textMetrics.width
                                        }
                                        truncatedText += ellipsis
                                        myButton2.truncatedText = truncatedText
                                    } else {
                                        myButton2.truncatedText = text
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
                                            text: model.taken_at
                                            font.pixelSize: 12
                                            color: "#666666"
                                            Layout.leftMargin: 23
                                            Layout.topMargin: 10
                                        }

                                        Text {
                                            text: "Max Marks: " + model.total_marks
                                            color: "#666666"
                                            font.pixelSize: 12
                                            Layout.rightMargin: 45
                                            Layout.alignment: Qt.AlignRight
                                        }
                                    }
                                }
                                onClicked: {
                                    stackView.push("quizScreen.qml", {
                                                       "quiz_id": model.quiz_id,
                                                       "class_id": model.class_id,
                                                       "quiz_name": model.quiz_name,
                                                       "questions_count": model.questions_count,
                                                       "total_marks": model.total_marks,
                                                       "negative_marking": model.negative_marking,
                                                       "answer_key": model.answer_key,
                                                       "test_paper_img_path": model.test_paper_img_path,
                                                       "taken_at": model.taken_at
                                                   })
                                }
                            }
                        }
                    }

                    ListView {
                        width: 320
                        height: 400
                        clip: true
                        model: whiteboardModel

                        anchors {
                            left: contentFrame.right
                            top: headingsRow.bottom
                        }
                        delegate: Item {
                            width: 320
                            height: 70

                            Button {
                                id: myButton
                                width: 320
                                height: 60

                                background: Rectangle {
                                    border.color: "#666666"
                                    width: parent.width
                                    height: parent.height
                                    radius: 7
                                }
                                property string originalText: model.whiteboard_name
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

                                    var text = myButton.originalText
                                    var metrics = textMetrics2.width
                                    var maxWidth = 100

                                    if (metrics > maxWidth) {
                                        var ellipsis = "..."
                                        var ellipsisWidth = textMetrics2.widthForText(
                                                    ellipsis)
                                        var truncatedText = text

                                        while (metrics + ellipsisWidth > maxWidth
                                               && truncatedText.length > 0) {
                                            truncatedText = truncatedText.slice(
                                                        0, -1)
                                            textMetrics.text = truncatedText
                                            metrics = textMetrics2.width
                                        }
                                        truncatedText += ellipsis
                                        myButton.truncatedText = truncatedText
                                    } else {
                                        myButton.truncatedText = text
                                    }
                                }

                                onWidthChanged: truncateText()
                                onOriginalTextChanged: truncateText()

                                text: truncatedText

                                Button {
                                    id: editButton
                                    Material.background: "transparent"
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    Image {
                                        source: "edit_icon.png"
                                        fillMode: Image.PreserveAspectFit
                                        width: 20
                                        height: 20
                                        anchors.centerIn: parent
                                    }

                                    onClicked: function () {
                                        console.log("launch whiteboard")
                                        stackView.push('WhiteboardSession.qml',
                                                       {
                                                           "folderpath": model.folderpath
                                                       })
                                    }
                                }

                                ColumnLayout {
                                    anchors.fill: parent
                                    spacing: -10

                                    RowLayout {
                                        spacing: 95
                                        Layout.preferredWidth: parent.width
                                        Layout.alignment: Qt.AlignTop
                                        Layout.topMargin: 30

                                        Text {
                                            text: model.created_at
                                            font.pixelSize: 12
                                            color: "#666666"
                                            Layout.leftMargin: 23
                                            Layout.topMargin: 10
                                        }
                                    }
                                }
                                onClicked: {
                                    console.log("White board button clicked")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
