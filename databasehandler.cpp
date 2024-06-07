#include "databasehandler.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVariantList>
#include <QSqlError>
#include <QVariantMap>

DatabaseHandler::DatabaseHandler(QObject *parent)
    : QObject{parent}
{
    db = QSqlDatabase::database();
}

bool DatabaseHandler::addClass(const QString &className, const int &studentCount, const QString &teacherName, const QString &centerName) {
    QSqlQuery query;
    query.exec("INSERT INTO classes (className, studentCount, teacherName, centerName) VALUES (?, ?, ?, ?)");
    query.addBindValue(className);
    query.addBindValue(studentCount);
    query.addBindValue(teacherName);
    query.addBindValue(centerName);
    if (!query.exec()) {
        qWarning() << "Add user failed: " << query.lastError();
        return false;
    }
    return true;

}

QVariantList DatabaseHandler::getClasses() {
    QVariantList classes;
    QSqlQuery query("SELECT * FROM classes");
    while (query.next()) {
        QVariantMap class_;
        class_["className"] = query.value(1).toString();
        class_["studentCount"] = query.value(2).toInt();
        class_["teacherName"] = query.value(3).toString();
        class_["centerName"] = query.value(4).toString();
        classes.append(class_);
    }
    return classes;
}
