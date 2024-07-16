QT += quick virtualkeyboard webengine

CONFIG += c++11


SOURCES += \
        clipboardhandler.cpp \
        main.cpp \
        toucheventfilter.cpp

HEADERS += \
	clipboardhandler.h \
	toucheventfilter.h

RESOURCES += qml.qrc \
	resources.qrc

include(qtzeroconf/qtzeroconf.pri)

QML_IMPORT_PATH =
QML_DESIGNER_IMPORT_PATH =

unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

