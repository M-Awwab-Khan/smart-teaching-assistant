#ifndef DATABASEHANDLER_H
#define DATABASEHANDLER_H

#include <QObject> // mandatory for every custom class
#include <QSqlDatabase> // for database operations
#include <QSqlQuery> // for running sql queries
#include <QVariantList> // its like a list

class DatabaseHandler : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseHandler(QObject *parent = nullptr);
    Q_INVOKABLE QVariantList getClasses();
    Q_INVOKABLE bool addClass(const QString &className, const int &studentCount, const QString &teacherName, const QString &centerName);
    Q_INVOKABLE bool editClass(const int iD, const QString &className, const int &studentCount, const QString &teacherName, const QString &centerName);
    Q_INVOKABLE bool deleteClass(const int id);
    Q_INVOKABLE bool addQuiz(const int &classId, const QString &title, const QString &date, const int &questionsCount, const int &totalMarks, const double &negativeMarks, const QString &answerKey, const QString &imagePath);

signals:
    void classDeleted(int id);

private:
    QSqlDatabase db;

};

#endif // DATABASEHANDLER_H
