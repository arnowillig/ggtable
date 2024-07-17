#ifndef WEBSERVER_H
#define WEBSERVER_H
#include <QTcpServer>
#include <QTcpSocket>

class Webserver : public QObject
{
public:
	Webserver(QObject* parent=nullptr);
private slots:
	void newConnection();
	void readClient();
private:
	QTcpServer* _server = nullptr;
};

#endif // WEBSERVER_H
