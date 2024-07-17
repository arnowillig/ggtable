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
		if (text == content()) {
			return;
		}
		setContent(text);

		QRegularExpressionMatch match = youtubeRegex.match(text);

		if (match.hasMatch()) {
			QString videoId = match.captured(1);
			emit gotLink("youtube", videoId);
		} else {
			qDebug("Clipboard contains text: %s", qPrintable(text));
		}
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
