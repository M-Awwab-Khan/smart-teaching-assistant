#include "opencvimageprovider.h"

OpenCVImageProvider::OpenCVImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Image)
{
    image = QImage(200,200,QImage::Format_RGB32);
    image.fill(QColor("black"));
}

QImage OpenCVImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{

    return image;
}

void OpenCVImageProvider::updateImage(const QImage &img)
{
    if(!img.isNull() && this->image != img) {
        this->image = img;
        emit imageChanged();
    }
}
