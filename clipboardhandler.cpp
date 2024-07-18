#include "clipboardhandler.h"
#include <QDebug>
#include <QUrl>
#include <QRegularExpression>

ClipboardHandler::ClipboardHandler(QObject *parent) : QObject(parent)
{
	qDebug("ClipboardHandler::ClipboardHandler()");
	_clipboard = QGuiApplication::clipboard();
	connect(_clipboard, &QClipboard::dataChanged, this, &ClipboardHandler::checkClipboard);
}

static QString extractYouTubeVideoId(const QString& url)
{
	static QRegularExpression regExp("(?:youtube\\.com.*(?:\\?|&|/)v=|youtu\\.be/)([^&#\\?]+)");
	QRegularExpressionMatch match = regExp.match(url);
	return match.hasMatch() ? match.captured(1) :  QString();
}

void ClipboardHandler::checkClipboard()
{
	const QMimeData* mimeData = _clipboard->mimeData();
	if (mimeData->hasText()) {
		// https://youtu.be/eOR2QYy670k?si=PlhLtzoiRE2rx0kY
		// https://youtube.com/watch?v=rrHtoux9zzQ&si=hUcp27Pw9FQV4jiY
		// https://youtube.com/watch?v=LQ5p5501JhY&si=rdlNzsXNSQzzGG0W

		QString text = mimeData->text();
		if (text == content()) {
			return;
		}
		setContent(text);

		QString videoId = extractYouTubeVideoId(text);
		if (!videoId.isEmpty()) {
			qDebug("*** Video ID: '%s'", qPrintable(videoId));
			emit gotLink("youtube", videoId);
			return;

		}
		qDebug("Clipboard contains text: %s", qPrintable(text));

	}
}

QString ClipboardHandler::content() const
{
	return _content;
}

void ClipboardHandler::setContent(const QString& content)
{
	if (_content != content) {
		_content = content;
		emit contentChanged();
	}
}
