QT += quick sql

SOURCES += \
        databasehandler.cpp \
        main.cpp \
        opencvimageprovider.cpp \
        videostreamer.cpp \
        whiteboardmanager.cpp

resources.files = main.qml 
resources.prefix = /$${TARGET}
RESOURCES += resources \
    application.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

win32:CONFIG(release, debug|release): LIBS += -LC:/OpenCV/opencv/build/x64/vc16/lib/ -lopencv_world490
else:win32:CONFIG(debug, debug|release): LIBS += -LC:/OpenCV/opencv/build/x64/vc16/lib/ -lopencv_world490d

INCLUDEPATH += C:/OpenCV/opencv/build/include
DEPENDPATH += C:/OpenCV/opencv/build/include

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    Addclass.qml \
    EditClass.qml \
    WhiteboardSession.qml \
    classesScreen.qml \
    manage_class.qml \
    manage_quiz_And_board.qml \
    quizScreen.qml \
    welcomeScreen.qml


HEADERS += \
    databasehandler.h \
    opencvimageprovider.h \
    videostreamer.h \
    whiteboardmanager.h
