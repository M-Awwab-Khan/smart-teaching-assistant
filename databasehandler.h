#ifndef DATABASEHANDLER_H
#define DATABASEHANDLER_H

#include <QObject> // mandatory for every custom class
#include <QSqlDatabase> // for database operations
#include <QSqlQuery> // for running sql queries
#include <QVariantList> // its like a list
#include <string>

class DatabaseHandler : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseHandler(QObject *parent = nullptr);
    Q_INVOKABLE QVariantList getClasses();
    Q_INVOKABLE bool addClass(const QString &className, const int &studentCount, const QString &teacherName, const QString &centerName);
    Q_INVOKABLE bool editClass(const int iD, const QString &className, const int &studentCount, const QString &teacherName, const QString &centerName);
    Q_INVOKABLE bool deleteClass(const int id);
    Q_INVOKABLE QVariantList getWhiteboards(const int &classId);
    Q_INVOKABLE bool addQuiz(const int &classId, const QString &title, const QString &date, const int &questionsCount, const int &totalMarks, const double &negativeMarks, const QString &answerKey, const QString &imagePath);
    Q_INVOKABLE QVariantList getQuizzes(const int &classId);
    Q_INVOKABLE bool addWhiteboard(const int &classId, const QString &whiteboardName, const QString &created_at, const QString &folderPath);

signals:
    void classDeleted(int id);

private:
    QSqlDatabase db;

};

#endif // DATABASEHANDLER_H
