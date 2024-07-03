#ifndef OPENCVIMAGEPROVIDER_H
#define OPENCVIMAGEPROVIDER_H

#include <QImage>
#include <QQuickImageProvider>


class OpenCVImageProvider : public QQuickImageProvider
{
    Q_OBJECT

public:
    OpenCVImageProvider();
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

public slots:
    void updateImage(const QImage &img);

signals:
    void imageChanged();

private:
    QImage image;
};

#endif // OPENCVIMAGEPROVIDER_H
