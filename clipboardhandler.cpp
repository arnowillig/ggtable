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

void ClipboardHandler::checkClipboard()
{
	const QMimeData* mimeData = _clipboard->mimeData();
	if (mimeData->hasText()) {
		static QRegularExpression youtubeRegex("https://youtu\\.be/([\\w-]+)(?:\\?[^\\s]*)?");
		QString text = mimeData->text();

		QRegularExpressionMatch match = youtubeRegex.match(text);

		if (match.hasMatch()) {
			QString videoId = match.captured(1);
			qDebug() << "Video ID:" << videoId;
			emit gotYouTubeLink(videoId);
		} else {
			qDebug() << "Clipboard contains text:" << text;
		}
	}
}
