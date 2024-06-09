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
