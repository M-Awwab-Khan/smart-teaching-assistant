#ifndef DATABASEHANDLER_H
#define DATABASEHANDLER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVariantList> // its like a list

class DatabaseHandler : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseHandler(QObject *parent = nullptr);
    Q_INVOKABLE QVariantList getClasses();
    Q_INVOKABLE bool addClass(const QString &className, const int &studentCount, const QString &teacherName, const QString &centerName);


private:
    QSqlDatabase db;
signals:
};

#endif // DATABASEHANDLER_H
