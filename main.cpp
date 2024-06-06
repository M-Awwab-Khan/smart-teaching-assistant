#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDir>


void initializeDatabase() {
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(QDir::currentPath() + "/application.db");

    if (!db.open()) {
        qWarning() << "Cannot connect to the database.";
        return;
    } else {
        qDebug() << "Connected Successfully";
    }

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS classes (id INTEGER PRIMARY KEY, className TEXT, studentCount INTEGER, teacherName TEXT, centerName TEXT)");
    query.exec("INSERT INTO classes (className, studentCount, teacherName, centerName) VALUES ('AP', 54, 'Tahir Jamal', 'Local Pakistani')");

}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    initializeDatabase();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/smart-teaching-assistant/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
