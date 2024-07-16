QT += quick virtualkeyboard webengine

CONFIG += c++11

#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000

include(qtzeroconf/qtzeroconf.pri)

SOURCES += \
        main.cpp \
        toucheventfilter.cpp

RESOURCES += qml.qrc \
	resources.qrc


LIBS += -lavahi-client -lavahi-common

QML_IMPORT_PATH =
QML_DESIGNER_IMPORT_PATH =

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
	toucheventfilter.h
