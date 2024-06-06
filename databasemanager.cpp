#include "databasemanager.h"
#include <QDebug>


DatabaseManager::DatabaseManager(QObject *parent)
    : QObject{parent}
{
    db = QSqlDatabase::database();
}

bool DatabaseManager::addClass(const QString &className, const int &studentCount, const QString &teacherName, const QString &centerName) {
    QSqlQuery query;
    query.prepare("INSERT INTO Classes (className, studentCount, teacherName, centerName) VALUES (?, ?, ?, ?)");
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

QVariantList DatabaseManager::getClasses() {
    QVariantList classes;
    QSqlQuery query("SELECT className, studentCount, teacherName, centerName FROM Classes");
    while (query.next()) {
        QVariantMap class_;
        class_["className"] = query.value(0).toString();
        class_["studentCount"] = query.value(1);
        class_["teacherName"] = query.value(2).toString();
        class_["centerName"] = query.value(3).toString();
        classes.append(class_);
    }
    return classes;
}
