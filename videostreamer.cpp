#include "videostreamer.h"

VideoStreamer::VideoStreamer()
{
    connect(&tUpdate,&QTimer::timeout,this,&VideoStreamer::streamVideo);
}


VideoStreamer::~VideoStreamer()
{
    cap.release();
    tUpdate.stop();
}

void VideoStreamer::startStream(int camera){
    cap.open(camera);
    double fps = cap.get(cv::CAP_PROP_FPS);

    tUpdate.start(1000/fps);
}

void VideoStreamer::stopStream() {
    cap.release();
    tUpdate.stop();
}

QImage VideoStreamer::getCurrentFrame() const
{
    return QImage(frame.data, frame.cols, frame.rows, QImage::Format_RGB888).rgbSwapped();

}

void VideoStreamer::streamVideo()
{
    cap>>frame;

    QImage img = QImage(frame.data,frame.cols,frame.rows,QImage::Format_RGB888).rgbSwapped();
    emit newImage(img);
}
