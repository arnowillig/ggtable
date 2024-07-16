/**************************************************************************************************
---------------------------------------------------------------------------------------------------
	Copyright (C) 2015  Jonathan Bagg
	This file is part of QtZeroConf.

	QtZeroConf is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	QtZeroConf is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with QtZeroConf.  If not, see <http://www.gnu.org/licenses/>.
---------------------------------------------------------------------------------------------------
   Project name : QtZeroConf
   File name    : qzeroconf.h
   Created      : 20 July 2015
   Author(s)    : Jonathan Bagg
---------------------------------------------------------------------------------------------------
   QtZeroConf class definition
---------------------------------------------------------------------------------------------------
**************************************************************************************************/
#ifndef QZEROCONF_H_
#define QZEROCONF_H_

#include <QObject>
#include <QHostAddress>
#include <QMap>

#include "qzeroconfglobal.h"
#include "qzeroconfservice.h"

class QZeroConfPrivate;

class QZeroConfSubService
{
public:
	QZeroConfSubService(const char* t, const char* st, const char* d, quint16 p) : type(t), subtype(st), domain(d), port(p){}

	const char* type;
	const char* subtype;
	const char* domain;
	quint16 port;
};

class Q_ZEROCONF_EXPORT QZeroConf : public QObject
{
	Q_OBJECT

	friend class QZeroConfPrivate;

public:
	enum error_t {
		NoError = 0,
		ServiceRegistrationFailed = -1,
		ServiceNameCollision = -2,
		BrowserFailed = -3,
	};
	QZeroConf(QObject* parent = nullptr);
	~QZeroConf();

	bool startServicePublish(const char* name, const char* type, const char* subtype, const char* domain, quint16 port);
	bool startServicePublish(const char* name, QList<QZeroConfSubService> services);
	void stopServicePublish();
	bool publishExists() const;
	void startBrowser(const QString& type, QAbstractSocket::NetworkLayerProtocol protocol = QAbstractSocket::IPv4Protocol);
	void stopBrowser();
	bool browserExists();
	void addServiceTxtRecord(const QString& name, const QString& value);
	void clearServiceTxtRecords();

signals:
	void servicePublished();
	void error(QZeroConf::error_t);
	void serviceAdded(QZeroConfService);
	void serviceUpdated(QZeroConfService);
	void serviceRemoved(QZeroConfService);

private:
	QZeroConfPrivate* _priv;
	QMap<QString, QZeroConfService> services;



};

#endif	// QZEROCONF_H_
