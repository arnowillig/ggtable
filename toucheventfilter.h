#ifndef TOUCHEVENTFILTER_H
#define TOUCHEVENTFILTER_H

#include <QObject>
#include <QEvent>

class TouchEventFilter : public QObject {
	Q_OBJECT

public:
	explicit TouchEventFilter(QObject *parent = nullptr);

protected:
	bool eventFilter(QObject *obj, QEvent *event) override;

signals:
	void touchDetected();
};

#endif // TOUCHEVENTFILTER_H
