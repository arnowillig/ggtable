#include "webserver.h"
#include <QDebug>
#include <QClipboard>
#include <QGuiApplication>
#include <QFile>

WebServer::WebServer(QObject* parent) : QTcpServer(parent)
{
	if (!listen(QHostAddress::Any, _port)) {
		qCritical() << "Unable to start the server";
		return;
	}
	qDebug("Server started on port %d", _port);
}

void WebServer::incomingConnection(qintptr handle)
{
	new WebSocket(this, handle);
}


WebSocket::WebSocket(WebServer* parent, qintptr handle) : QTcpSocket(parent)
{
	setSocketDescriptor(handle);
	setObjectName(QString("WebSocket%1").arg(handle));
	setSocketOption(QAbstractSocket::LowDelayOption,true);
	setSocketOption(QAbstractSocket::KeepAliveOption,true);
	/*
	#include "dfm_fileserver_ssl.h"

	QSslCertificate servercert(certData,QSsl::Pem);
	QSslCertificate clientcert(clientcertData,QSsl::Pem);

	QSslKey server_pk(key, QSsl::Rsa, QSsl::Pem, QSsl::PrivateKey, "hahn");
	setPrivateKey(server_pk);
	setLocalCertificate(servercert);
	setPeerVerifyMode(QSslSocket::VerifyPeer);
	QSslConfiguration sslConfig = sslConfiguration();
	sslConfig.setCaCertificates(QList<QSslCertificate>{clientcert});
	setSslConfiguration(sslConfig);

	startServerEncryption();
	// wget --no-check-certificate --certificate=client.pem https://192.168.210.218:49153/disk/brackets/25/253bcab0f580ffa0a21fece73d8ed193_16859136.bfs
*/
	connect(this, &WebSocket::disconnected, this, &WebSocket::deleteLater);
	connect(this, &WebSocket::readyRead, this, &WebSocket::readClient);
}

WebSocket::~WebSocket()
{
	qInfo("%s::~WebSocket()",qPrintable(objectName()));
}

/*
void WebSocket::gotSslErrors(const QList<QSslError> &errors)
{
	for (const QSslError& error : errors) {
		qWarning("%s::requestSslErrors(): %s",qPrintable(objectName()),qPrintable(error.errorString()));
	}
}
*/

// https://youtube.com/shorts/nsqkW9ymEgI?si=8-0xdWQlQf0n78RI
// https://youtube.com/watch?v=LQ5p5501JhY&si=rdlNzsXNSQzzGG0W
void WebSocket::readClient()
{
	_data.append(readAll());
	qDebug("%s::readClient() %d bytes",qPrintable(objectName()), (int) _data.size());

	if (_data.startsWith("POST")) {
		int contentIndex = _data.indexOf("\r\n\r\n");
		if (contentIndex<0) {
			return;
		}
		QByteArray content = _data.mid(contentIndex + 4);
		if (content.isEmpty()) {
			return;
		}
		QGuiApplication::clipboard()->setText(QString::fromUtf8(content));

		// Send response
		QByteArray response = "HTTP/1.1 204 No-Content\r\n\r\n";
		write(response);
		disconnectFromHost();

	} else {
		QByteArray response = "HTTP/1.1 405 Method Not Allowed\r\nContent-Type: text/plain\r\n\r\nOnly POST requests are allowed";
		write(response);
		disconnectFromHost();
	}
}
