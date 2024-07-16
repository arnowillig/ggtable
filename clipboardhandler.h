#ifndef CLIPBOARDHANDLER_H
#define CLIPBOARDHANDLER_H

#include <QObject>
#include <QClipboard>
#include <QGuiApplication>
#include <QMimeData>

class ClipboardHandler : public QObject {
	Q_OBJECT
public:
	explicit ClipboardHandler(QObject* parent = nullptr);

signals:
	void gotYouTubeLink(const QString& videoId);

public slots:
	void checkClipboard();

private:
	QClipboard* _clipboard = nullptr;
};

#endif // CLIPBOARDHANDLER_H
