#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDir>
#include <QQmlContext>
#include "databasehandler.h"
#include "opencvimageprovider.h"
#include "videostreamer.h"
#include "whiteboardmanager.h"
#include "omrmanager.h"


void initializeDatabase() {
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(QDir::currentPath() + "/application.db");
    qDebug() << QDir::currentPath() + "/application.db";
    if (!db.open()) {
        qWarning() << "Cannot connect to the database.";
        return;
    } else {
        qDebug() << "Connected Successfully";
    }

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS classes (\
               id INTEGER PRIMARY KEY AUTOINCREMENT,\
               className TEXT, \
               studentCount INTEGER, \
               teacherName TEXT, \
               centerName TEXT\
               )");
    query.exec("CREATE TABLE IF NOT EXISTS students  (\
               student_id INTEGER,\
               class_id INTEGER,\
               FOREIGN KEY (class_id) REFERENCES classes(id)\
               )");
    query.exec("CREATE TABLE IF NOT EXISTS quizzes (\
               quiz_id INTEGER PRIMARY KEY,\
               class_id INTEGER,\
               quiz_name TEXT NOT NULL,\
               total_marks INTEGER NOT NULL,\
               questions_count INTEGER NOT NULL,\
               negative_marking REAL DEFAULT 0,\
               answer_key TEXT NOT NULL,\
               test_paper_img_path TEXT,\
               taken_at TEXT DEFAULT CURRENT_TIMESTAMP,\
               FOREIGN KEY (class_id) REFERENCES classes(id)\
               )");
    query.exec("CREATE TABLE IF NOT EXISTS marks (\
               student_id INTEGER,\
               quiz_id INTEGER,\
               class_id INTEGER,\
               correct INTEGER,\
               wrong INTEGER,\
               not_attempted INTEGER,\
               marks_obtained REAL,\
               FOREIGN KEY (student_id) REFERENCES students(student_id),\
               FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id)\
               FOREIGN KEY (class_id) REFERENCES classes(id)\
               UNIQUE (quiz_id, class_id, student_id)\
               )");

    query.exec("CREATE TABLE whiteboards (\
               whiteboard_id INTEGER PRIMARY KEY AUTOINCREMENT,\
               whiteboard_name TEXT NOT NULL,\
               class_id INTEGER,\
               created_at TEXT DEFAULT CURRENT_TIMESTAMP,\
               assets_path TEXT NOT NULL,\
               FOREIGN KEY (class_id) REFERENCES classes(id)\
               )");

}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    initializeDatabase();

    // to use any custom class in qml, you need to register it
    qmlRegisterType<DatabaseHandler>("DatabaseHandler", 1, 0, "DatabaseHandler");

    VideoStreamer videoStreamer;
    VideoStreamer videoStreamerOMR;
    WhiteboardManager whiteboardManager;
    OMRmanager omrManager;

    QQmlApplicationEngine engine;

    OpenCVImageProvider *whiteboardImageProvider(new OpenCVImageProvider);
    OpenCVImageProvider *OMRImageProvider(new OpenCVImageProvider);
    OpenCVImageProvider *scannedImageProvider(new OpenCVImageProvider);

    engine.rootContext()->setContextProperty("whiteboardImageProvider", whiteboardImageProvider);
    engine.rootContext()->setContextProperty("OMRImageProvider", OMRImageProvider);
    engine.rootContext()->setContextProperty("scannedImageProvider", scannedImageProvider);
    engine.rootContext()->setContextProperty("videoStreamer", &videoStreamer);
    engine.rootContext()->setContextProperty("videoStreamerOMR", &videoStreamerOMR);
    engine.rootContext()->setContextProperty("whiteboardManager", &whiteboardManager);
    engine.rootContext()->setContextProperty("omrManager", &omrManager);

    engine.addImageProvider("whiteboard", whiteboardImageProvider);
    engine.addImageProvider("omr", OMRImageProvider);
    engine.addImageProvider("scanned", scannedImageProvider);


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

    QObject::connect(&videoStreamerOMR, &VideoStreamer::newImage,  OMRImageProvider, &OpenCVImageProvider::updateImage);
    QObject::connect(&videoStreamer, &VideoStreamer::newImage, &whiteboardManager, &WhiteboardManager::processFrame);
    QObject::connect(&whiteboardManager, &WhiteboardManager::newWeightedImage, whiteboardImageProvider, &OpenCVImageProvider::updateImage);
    QObject::connect(&omrManager, &OMRmanager::newScannedImage, scannedImageProvider, &OpenCVImageProvider::updateImage);
    return app.exec();
}
