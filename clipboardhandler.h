#ifndef CLIPBOARDHANDLER_H
#define CLIPBOARDHANDLER_H

#include <QObject>
#include <QClipboard>
#include <QGuiApplication>
#include <QMimeData>

class ClipboardHandler : public QObject {
	Q_OBJECT
	Q_PROPERTY(QString content READ content WRITE setContent NOTIFY contentChanged)
public:
	explicit ClipboardHandler(QObject* parent = nullptr);

	QString content() const;
	void setContent(const QString& content);

signals:
	void gotLink(const QString& type, const QString& data);

	void contentChanged();

public slots:
	void checkClipboard();

private:
	QString _content;
	QClipboard* _clipboard = nullptr;
};

#endif // CLIPBOARDHANDLER_H
