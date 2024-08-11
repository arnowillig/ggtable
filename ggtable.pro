QT += quick virtualkeyboard

greaterThan(QT_MAJOR_VERSION, 5): QT += core5compat webenginecore webenginequick

CONFIG += c++11


SOURCES += \
        clipboardhandler.cpp \
        main.cpp \
        toucheventfilter.cpp \
        webserver.cpp

HEADERS += \
	clipboardhandler.h \
	toucheventfilter.h \
	webserver.h

RESOURCES += qml.qrc \
	resources.qrc

include(qtzeroconf/qtzeroconf.pri)

QML_IMPORT_PATH =
QML_DESIGNER_IMPORT_PATH =

unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

equals(QMAKE_HOST.name, rosetta) { CONFIG += devel }

CONFIG(devel) {
	DEFINES += SCREEN_WIDTH=1600
	DEFINES += SCREEN_HEIGHT=900
} else {
	DEFINES += SCREEN_WIDTH=1920
	DEFINES += SCREEN_HEIGHT=1080
}

