#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariantList>

class DatabaseManager : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);
    Q_INVOKABLE bool addClass(const QString &className, const int &studentCount, const QString &teacherName, const QString &centerName);
    Q_INVOKABLE QVariantList getClasses();

private:
    QSqlDatabase db;

signals:
};

#endif // DATABASEMANAGER_H
