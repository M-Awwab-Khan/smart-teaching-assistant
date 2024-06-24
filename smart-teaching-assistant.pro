QT += quick sql

SOURCES += \
        databasehandler.cpp \
        main.cpp

resources.files = main.qml 
resources.prefix = /$${TARGET}
RESOURCES += resources \
    application.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    Addclass.qml \
    EditClass.qml \
    classesScreen.qml \
    manage_class.qml \
    welcomeScreen.qml
    manage_quiz_And_board.qml\

HEADERS += \
    databasehandler.h
