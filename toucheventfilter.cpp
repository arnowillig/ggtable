#include "toucheventfilter.h"
#include <QTouchEvent>

TouchEventFilter::TouchEventFilter(QObject *parent) : QObject(parent)
{
}

bool TouchEventFilter::eventFilter(QObject *obj, QEvent *event)
{
	switch (event->type()) {
	case QEvent::MouseButtonPress:
	case QEvent::MouseButtonRelease:
	case QEvent::TouchBegin:
	case QEvent::TouchUpdate:
	case QEvent::TouchEnd:
		emit touchDetected();
		break;
	default:
		break;
	}
	return QObject::eventFilter(obj, event);
}
