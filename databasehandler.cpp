#include "databasehandler.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVariantList>

DatabaseHandler::DatabaseHandler(QObject *parent)
    : QObject{parent}
{
    db = QSqlDatabase::database();
}

bool DatabaseHandler::addClass(const QString className, const int studentCount, const QString teacherName, const QString centerName) {
    QSqlQuery query;
    query.exec("INSERT INTO classes (className, studentCount, teacherName, centerName) VALUES (:className, :studentCount, :teacherName, :centerName)");
    query.bindValue(":className", className);
    query.bindValue(":studentCount", studentCount);
    query.bindValue(":teacherName", teacherName);
    query.bindValue(":centerName", centerName);
    if (query.exec()) {
        return true;
    } else{
        return false;
    }

}

QVariantList DatabaseHandler::getClasses() {
    return QVariantList {};
}
