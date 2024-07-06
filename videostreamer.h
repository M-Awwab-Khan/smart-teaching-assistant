#ifndef VIDEOSTREAMER_H
#define VIDEOSTREAMER_H

#include <QObject>
#include <QTimer>
#include <opencv2/opencv.hpp>
#include <opencv2/videoio.hpp>
#include <QImage>
#include <iostream>

class VideoStreamer : public QObject
{
    Q_OBJECT
public:
    VideoStreamer();
    ~VideoStreamer();

public:
    void streamVideo();
    Q_INVOKABLE void startStream();
    Q_INVOKABLE void stopStream();
    Q_INVOKABLE QImage getCurrentFrame() const;

private:
    cv::Mat frame;
    cv::VideoCapture cap;
    QTimer tUpdate;

signals:
    void newImage(QImage img);
};

#endif // VIDEOSTREAMER_H
