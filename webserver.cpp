#include "webserver.h"
#include <QDebug>
#include <QClipboard>
#include <QGuiApplication>

Webserver::Webserver(QObject* parent) : QObject(parent)
{
	_server = new QTcpServer(this);

	connect(_server, &QTcpServer::newConnection, this, &Webserver::newConnection);

	if (!_server->listen(QHostAddress::Any, 8080)) {
		qCritical() << "Unable to start the server";
		return;
	}

	qDebug() << "Server started on port 8080";
}

void Webserver::newConnection()
{
	QTcpSocket* client = _server->nextPendingConnection();
	connect(client, &QTcpSocket::readyRead, this, &Webserver::readClient);
}

void Webserver::readClient()
{
	QTcpSocket* client = qobject_cast<QTcpSocket *>(sender());
	if (!client) {
		return;
	}

	if (client->canReadLine()) {
		QByteArray request = client->readAll();
		qDebug() << "Request received:" << request;

		if (request.startsWith("POST")) {
			int contentIndex = request.indexOf("\r\n\r\n");
			if (contentIndex != -1) {
				QByteArray content = request.mid(contentIndex + 4);
				QGuiApplication::clipboard()->setText(QString::fromUtf8(content));

				// Send response
				QByteArray response = "HTTP/1.1 204 No-Content\r\n\r\n";
				client->write(response);
				client->disconnectFromHost();
			}
		} else {
			QByteArray response = "HTTP/1.1 405 Method Not Allowed\r\nContent-Type: text/plain\r\n\r\nOnly POST requests are allowed";
			client->write(response);
			client->disconnectFromHost();
		}
	}
}
