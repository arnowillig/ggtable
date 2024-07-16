HEADERS+= \
	$$PWD/qzeroconf.h \
	$$PWD/qzeroconfservice.h \
	$$PWD/qzeroconfglobal.h \
	$$PWD/avahi-qt/qt-watch.h  \
	$$PWD/avahi-qt/qt-watch_p.h

SOURCES+= \
	$$PWD/qzeroconfservice.cpp \
	$$PWD/avahiclient.cpp \
	$$PWD/avahi-qt/qt-watch.cpp

LIBS+= -lavahi-client -lavahi-common

QMAKE_CXXFLAGS+= -I$$PWD
