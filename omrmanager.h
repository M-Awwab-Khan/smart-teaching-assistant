#ifndef OMRMANAGER_H
#define OMRMANAGER_H

#include <QObject>
#include <QVariant>
#include <QImage>
#include <QDebug>

class OMRmanager : public QObject
{
    Q_OBJECT
public:
    explicit OMRmanager(QObject *parent = nullptr);

public slots:
    void startOMR(const QVariant &imgVar);
    void connectOMRPage(QObject* currentItem);

signals:
};

#endif // OMRMANAGER_H
