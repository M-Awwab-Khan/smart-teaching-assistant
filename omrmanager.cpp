#include "omrmanager.h"

OMRmanager::OMRmanager(QObject *parent)
    : QObject{parent}
{}


void OMRmanager::startOMR(const QVariant &imgVar)
{
    if (imgVar.canConvert<QImage>()) {
        QImage img = imgVar.value<QImage>();
        qDebug() << img.height() << " " << img.width();
    }
}

void OMRmanager::connectOMRPage(QObject *currentItem)
{
    if (currentItem) {
        QVariant pageId = currentItem->property("pageId");
        if (pageId.isValid() && pageId.toString() == "omrpage") {
            QObject::connect(currentItem, SIGNAL(imageCaptured(QVariant)), this, SLOT(startOMR(QVariant)));
        }
    }
}
