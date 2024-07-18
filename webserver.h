#ifndef WEBSERVER_H
#define WEBSERVER_H
#include <QTcpServer>
#include <QTcpSocket>

class WebServer : public QTcpServer
{
	Q_OBJECT
public:
	WebServer(QObject* parent=nullptr);
protected:
	virtual void incomingConnection(qintptr handle) override;
// private slots:
// 	void readClient();
private:
	quint16	_port = 8080;
};

class WebSocket : public QTcpSocket
{
	Q_OBJECT

public:
	WebSocket(WebServer* parent, qintptr handle);
	virtual ~WebSocket();
	// void sendFileResponse(const QString& path);
	// void sendNotFoundResponse();
private slots:
	void readClient();
	// void gotSslErrors(const QList<QSslError> &errors);
private:
	QByteArray _data;
};


#endif // WEBSERVER_H
