#include "databasehandler.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVariantList>
#include <QSqlError>

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
    return QVariantList {};
}
