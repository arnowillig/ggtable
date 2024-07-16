#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngine>
#include "toucheventfilter.h"
#include "qtzeroconf/qzeroconf.h"

int main(int argc, char *argv[])
{
	qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
	QtWebEngine::initialize();
	QGuiApplication app(argc, argv);

	TouchEventFilter* filter = new TouchEventFilter;
	app.installEventFilter(filter);

	QZeroConf zeroconf;
	zeroconf.startServicePublish("GameGrid", "_clipboard._tcp", nullptr, "local", 30564);



	QQmlApplicationEngine engine;
	const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
	QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl) {
		if (!obj && url == objUrl) {
			QCoreApplication::exit(-1);
		}
	}, Qt::QueuedConnection);

	engine.load(url);

	QObject* rootObject = engine.rootObjects().at(0);

	QObject::connect(filter, &TouchEventFilter::touchDetected, rootObject, [rootObject]() {
		QMetaObject::invokeMethod(rootObject, "restartScreensaverTimer");
	});


	return app.exec();
}
