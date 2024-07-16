#include "avahi-qt/qt-watch.h"
#include <avahi-client/client.h>
#include <avahi-client/publish.h>
#include <avahi-common/error.h>
#include <avahi-client/lookup.h>
#include <avahi-common/timeval.h>
#include "qzeroconf.h"

#include <QTimer>
#include <QSocketNotifier>
#include <avahi-common/watch.h>

class QZeroConfPrivate
{
public:
	QZeroConfPrivate(QZeroConf *parent);

	static void groupCallback(AvahiEntryGroup* g, AvahiEntryGroupState state, AVAHI_GCC_UNUSED void *userdata);

	static void browseCallback(AvahiServiceBrowser*, AvahiIfIndex interface, AvahiProtocol protocol, AvahiBrowserEvent event,
				   const char* name, const char* type, const char* domain, AvahiLookupResultFlags flags, void* userdata);

	static void resolveCallback(AvahiServiceResolver* r, AvahiIfIndex interface, AvahiProtocol protocol, AvahiResolverEvent event,
				    const char* name, const char* type, const char* domain, const char* host_name, const AvahiAddress* address,
				    uint16_t port, AvahiStringList* txt, AvahiLookupResultFlags, void* userdata);

	void cleanup();

	QZeroConf *pub;
	const AvahiPoll *poll;
	AvahiClient *client;
	AvahiEntryGroup *group;
	AvahiServiceBrowser *browser;
	AvahiProtocol aProtocol;
	QMap <QString, AvahiServiceResolver *> resolvers;
	AvahiStringList *txt;
};

QZeroConf::QZeroConf(QObject* parent) : QObject(parent)
{
	_priv = new QZeroConfPrivate(this);
	qRegisterMetaType<QZeroConfService>("QZeroConfService");
}

QZeroConf::~QZeroConf()
{
	avahi_string_list_free(_priv->txt);
	_priv->cleanup();
	if (_priv->client) {
		avahi_client_free(_priv->client);
	}
	delete _priv;
}

bool QZeroConf::startServicePublish(const char* name, QList<QZeroConfSubService> services)
{
	if (_priv->group) {
		emit error(QZeroConf::ServiceRegistrationFailed);
		return false;
	}

	_priv->group = avahi_entry_group_new(_priv->client, QZeroConfPrivate::groupCallback, _priv);

	for (QZeroConfSubService service : services) {
		int ret = avahi_entry_group_add_service_strlst(_priv->group, AVAHI_IF_UNSPEC, AVAHI_PROTO_UNSPEC, AVAHI_PUBLISH_UPDATE, name, service.type, service.domain, nullptr, service.port, _priv->txt);
		if (ret < 0) {
			avahi_entry_group_free(_priv->group);
			_priv->group = nullptr;
			emit error(QZeroConf::ServiceRegistrationFailed);
			return false;
		}
		if (strlen(service.subtype) > 0) {
			ret = avahi_entry_group_add_service_subtype(_priv->group, AVAHI_IF_UNSPEC, AVAHI_PROTO_UNSPEC, static_cast<AvahiPublishFlags>(0), name, service.type, service.domain, service.subtype);
			if(ret < 0) {
				avahi_entry_group_free(_priv->group);
				_priv->group = nullptr;
				emit error(QZeroConf::ServiceRegistrationFailed);
				return false;
			}
		}
	}

	int ret = avahi_entry_group_commit(_priv->group);
	if (ret < 0) {
		_priv->group = nullptr;
		avahi_entry_group_free(_priv->group);
		emit error(QZeroConf::ServiceRegistrationFailed);
		return false;
	}

	if (!_priv->group) {
		emit error(QZeroConf::ServiceRegistrationFailed);
		return false;
	}
	return true;
}

bool QZeroConf::startServicePublish(const char* name, const char* type, const char* subtype, const char* domain, quint16 port)
{
	if (_priv->group) {
		emit error(QZeroConf::ServiceRegistrationFailed);
		return false;
	}

	_priv->group = avahi_entry_group_new(_priv->client, QZeroConfPrivate::groupCallback, _priv);

	int ret = avahi_entry_group_add_service_strlst(_priv->group, AVAHI_IF_UNSPEC, AVAHI_PROTO_UNSPEC, AVAHI_PUBLISH_UPDATE, name, type, domain, nullptr, port, _priv->txt);
	if (ret < 0) {
		avahi_entry_group_free(_priv->group);
		_priv->group = nullptr;
		emit error(QZeroConf::ServiceRegistrationFailed);
		return false;
	}
	if (subtype && strlen(subtype) > 0){
		ret = avahi_entry_group_add_service_subtype(_priv->group, AVAHI_IF_UNSPEC, AVAHI_PROTO_UNSPEC, static_cast<AvahiPublishFlags>(0), name, type, domain, subtype);
		if (ret < 0) {
			avahi_entry_group_free(_priv->group);
			_priv->group = nullptr;
			emit error(QZeroConf::ServiceRegistrationFailed);
			return false;
		}
	}
	ret = avahi_entry_group_commit(_priv->group);
	if (ret < 0) {
		_priv->group = nullptr;
		avahi_entry_group_free(_priv->group);
		emit error(QZeroConf::ServiceRegistrationFailed);
		return false;
	}

	if (!_priv->group) {
		emit error(QZeroConf::ServiceRegistrationFailed);
		return false;
	}
	return true;
}

void QZeroConf::stopServicePublish()
{
	if (_priv->group) {
		avahi_entry_group_free(_priv->group);
		_priv->group = nullptr;
	}
}

bool QZeroConf::publishExists() const
{
	return _priv->group ? true : false;
}

// http://www.zeroconf.org/rendezvous/txtrecords.html

void QZeroConf::addServiceTxtRecord(const QString& name, const QString& value)
{
	_priv->txt = avahi_string_list_add(_priv->txt, QString("%1=%2").arg(name, value).toUtf8().constData());
}

void QZeroConf::clearServiceTxtRecords()
{
	avahi_string_list_free(_priv->txt);
	_priv->txt = nullptr;
}

void QZeroConf::startBrowser(const QString& type, QAbstractSocket::NetworkLayerProtocol protocol)
{
	if (_priv->browser) {
		emit error(QZeroConf::BrowserFailed);
	}

	switch (protocol) {
	case QAbstractSocket::IPv4Protocol: _priv->aProtocol = AVAHI_PROTO_INET; break;
	case QAbstractSocket::IPv6Protocol: _priv->aProtocol = AVAHI_PROTO_INET6; break;
	default:
		qDebug("QZeroConf::startBrowser() - unsupported protocol, using IPv4");
		_priv->aProtocol = AVAHI_PROTO_INET;
		break;
	};

	_priv->browser = avahi_service_browser_new(_priv->client, AVAHI_IF_UNSPEC, _priv->aProtocol, type.toUtf8(), nullptr, AVAHI_LOOKUP_USE_MULTICAST, QZeroConfPrivate::browseCallback, _priv);
	if (!_priv->browser) {
		emit error(QZeroConf::BrowserFailed);
	}
}

void QZeroConf::stopBrowser()
{
	_priv->cleanup();
}

bool QZeroConf::browserExists()
{
	return _priv->browser ? true : false;
}

QZeroConfPrivate::QZeroConfPrivate(QZeroConf *parent)
{
	qint32 error;

	txt = nullptr;
	pub = parent;
	group = nullptr;
	browser = nullptr;
	poll = avahi_qt_poll_get();
	if (!poll) {
		return;
	}
	client = avahi_client_new(poll, AVAHI_CLIENT_IGNORE_USER_CONFIG, nullptr, this, &error);
	if (!client) {
		return;
	}
}

void QZeroConfPrivate::groupCallback(AvahiEntryGroup *g, AvahiEntryGroupState state, void *userdata)
{
	QZeroConfPrivate* ref = static_cast<QZeroConfPrivate *>(userdata);
	switch (state) {
	case AVAHI_ENTRY_GROUP_ESTABLISHED:
		emit ref->pub->servicePublished();
		break;
	case AVAHI_ENTRY_GROUP_COLLISION:
		avahi_entry_group_free(g);
		ref->group = nullptr;
		emit ref->pub->error(QZeroConf::ServiceNameCollision);
		break;
	case AVAHI_ENTRY_GROUP_FAILURE:
		avahi_entry_group_free(g);
		ref->group = nullptr;
		emit ref->pub->error(QZeroConf::ServiceRegistrationFailed);
		break;
	case AVAHI_ENTRY_GROUP_UNCOMMITED: break;
	case AVAHI_ENTRY_GROUP_REGISTERING: break;
	}
}

void QZeroConfPrivate::browseCallback(AvahiServiceBrowser *, AvahiIfIndex interface, AvahiProtocol protocol, AvahiBrowserEvent event, const char *name, const char *type, const char *domain, AvahiLookupResultFlags flags, void *userdata)
{
	Q_UNUSED(flags);
	QString key = name + QString::number(interface);
	QZeroConfPrivate *ref = static_cast<QZeroConfPrivate *>(userdata);

	QZeroConfService zcs;

	switch (event) {
	case AVAHI_BROWSER_FAILURE:
		ref->cleanup();
		emit ref->pub->error(QZeroConf::BrowserFailed);
		break;
	case AVAHI_BROWSER_NEW:
		if (!ref->resolvers.contains(key))
			ref->resolvers.insert(key, avahi_service_resolver_new(ref->client, interface, protocol, name, type, domain, ref->aProtocol, AVAHI_LOOKUP_USE_MULTICAST, resolveCallback, ref));
		break;
	case AVAHI_BROWSER_REMOVE:
		if (!ref->resolvers.contains(key))
			return;
		avahi_service_resolver_free(ref->resolvers[key]);
		ref->resolvers.remove(key);

		if (!ref->pub->services.contains(key))
			return;

		zcs = ref->pub->services[key];
		ref->pub->services.remove(key);
		emit ref->pub->serviceRemoved(zcs);
		break;
	case AVAHI_BROWSER_ALL_FOR_NOW:
	case AVAHI_BROWSER_CACHE_EXHAUSTED:
		break;
	}
}

void QZeroConfPrivate::resolveCallback(AvahiServiceResolver *r, AvahiIfIndex interface, AvahiProtocol protocol, AvahiResolverEvent event, const char *name, const char *type, const char *domain, const char *host_name, const AvahiAddress *address, uint16_t port, AvahiStringList *txt, AvahiLookupResultFlags, void *userdata)
{
	Q_UNUSED(r);
	Q_UNUSED(protocol);
	bool newRecord = 0;
	QZeroConfService zcs;
	QZeroConfPrivate *ref = static_cast<QZeroConfPrivate *>(userdata);

	QString key = name + QString::number(interface);
	if (event == AVAHI_RESOLVER_FOUND) {
		if (ref->pub->services.contains(key))
			zcs = ref->pub->services[key];
		else {
			zcs = QZeroConfService(new QZeroConfServiceData);
			newRecord = 1;
			zcs->m_name = name;
			zcs->m_type = type;
			zcs->m_domain = domain;
			zcs->m_host = host_name;
			zcs->m_interfaceIndex = interface;
			zcs->m_port = port;
			while (txt)	// get txt records
			{
				QByteArray avahiText((const char *)txt->text, txt->size);
				QList<QByteArray> pair = avahiText.split('=');
				if (pair.size() == 2)
					zcs->m_txt[pair.at(0)] = pair.at(1);
				else
					zcs->m_txt[pair.at(0)] = "";
				txt = txt->next;
			}
			ref->pub->services.insert(key, zcs);
		}

		char a[AVAHI_ADDRESS_STR_MAX];
		avahi_address_snprint(a, sizeof(a), address);
		QHostAddress addr(a);
		zcs->setIp(addr);

		if (newRecord)
			emit ref->pub->serviceAdded(zcs);
		else
			emit ref->pub->serviceUpdated(zcs);
	}
	else if (ref->pub->services.contains(key)) {	// delete service if exists and unable to resolve
		zcs = ref->pub->services[key];
		ref->pub->services.remove(key);
		emit ref->pub->serviceRemoved(zcs);
		// don't delete the resolver here...we need to keep it around so Avahi will keep updating....might be able to resolve the service in the future
	}
}

void QZeroConfPrivate::cleanup()
{
	if (!browser) {
		return;
	}
	avahi_service_browser_free(browser);
	browser = nullptr;

	QMap<QString, QZeroConfService>::iterator i;
	for (i = pub->services.begin(); i != pub->services.end(); i++) {
		emit pub->serviceRemoved(i.value());
	}
	pub->services.clear();

	QMap<QString, AvahiServiceResolver *>::iterator r;
	for (r = resolvers.begin(); r != resolvers.end(); r++) {
		avahi_service_resolver_free(*r);
	}
	resolvers.clear();
}
