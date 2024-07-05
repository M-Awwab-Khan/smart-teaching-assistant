#include "databasehandler.h"
#include <QSqlError>
#include <QDebug>
#include <QVariantMap>

DatabaseHandler::DatabaseHandler(QObject *parent)
    : QObject{parent}
{
    db = QSqlDatabase::database();
}

bool DatabaseHandler::addClass(const QString &className, const int &studentCount, const QString &teacherName, const QString &centerName) {
    QSqlQuery query;
    query.prepare("INSERT INTO classes (className, studentCount, teacherName, centerName) VALUES (?, ?, ?, ?)");
    query.addBindValue(className);
    query.addBindValue(studentCount);
    query.addBindValue(teacherName);
    query.addBindValue(centerName);
    if (!query.exec()) {
        qWarning() << "Add class failed: " << query.lastError();
        return false;
    }
    return true;
}

QVariantList DatabaseHandler::getClasses() {
    QVariantList classes;
    QSqlQuery query("SELECT * FROM classes");
    while (query.next()) {
        QVariantMap class_;
        class_["id"] = query.value("id").toInt();
        class_["className"] = query.value("className").toString();
        class_["studentCount"] = query.value("studentCount").toInt();
        class_["teacherName"] = query.value("teacherName").toString();
        class_["centerName"] = query.value("centerName").toString();
        classes.append(class_);
    }
    return classes;
}

bool DatabaseHandler::editClass(const int id, const QString &className, const int &studentCount, const QString &teacherName, const QString &centerName) {
    QSqlQuery query;
    query.prepare("UPDATE classes SET className = ?, studentCount = ?, teacherName = ?, centerName = ? WHERE id = ?");
    query.addBindValue(className);
    query.addBindValue(studentCount);
    query.addBindValue(teacherName);
    query.addBindValue(centerName);
    query.addBindValue(id);
    if (!query.exec()) {
        qWarning() << "Edit class failed: " << query.lastError();
        return false;
    }
    return true;
}

bool DatabaseHandler::deleteClass(const int id) {
    QSqlQuery query;
    query.prepare("DELETE FROM classes WHERE id = ?");
    query.addBindValue(id);
    if (!query.exec()) {
        qWarning() << "Delete class failed: " << query.lastError();
        return false;
    }
    emit classDeleted(id);
    return true;
}

bool DatabaseHandler::addQuiz(const int &classId, const QString &title, const QString &date, const int &questionsCount, const int &totalMarks, const double &negativeMarks, const QString &answerKey, const QString &imagePath) {
    QSqlQuery query;
    query.prepare("INSERT INTO quizzes (class_id, quiz_name, total_marks, questions_count, negative_marking, answer_key, test_paper_img_path, taken_at)\
                    VALUES (?, ?, ?, ?, ?, ?, ? , ?)");
    query.addBindValue(classId);
    query.addBindValue(title);
    query.addBindValue(totalMarks);
    query.addBindValue(questionsCount);
    query.addBindValue(negativeMarks);
    query.addBindValue(answerKey);
    query.addBindValue(imagePath);
    query.addBindValue(date);
    if (!query.exec()) {
        qWarning() << "Add quiz failed: " << query.lastError();
        return false;
    }
    return true;
}

QVariantList DatabaseHandler::getQuizzes(const int &classId) {
    QVariantList quizzes;
    QSqlQuery query;
    query.prepare("SELECT * FROM quizzes WHERE class_id = ?");
    query.addBindValue(classId);
    query.exec();
    while (query.next()) {
        qDebug() << "in while loop";

        QVariantMap quiz;
        quiz["quiz_id"] = query.value("quiz_id").toInt();
        quiz["class_id"] = query.value("class_id").toInt();
        quiz["quiz_name"] = query.value("quiz_name").toString();
        quiz["total_marks"] = query.value("total_marks").toInt();
        quiz["questions_count"] = query.value("questions_count").toInt();
        quiz["negative_marking"] = query.value("negative_marking").toDouble();
        quiz["answer_key"] = query.value("answer_key").toString();
        quiz["test_paper_img_path"] = query.value("test_paper_img_path").toString();
        quiz["taken_at"] = query.value("taken_at").toString();

        quizzes.append(quiz);
    }
    return quizzes;
}
