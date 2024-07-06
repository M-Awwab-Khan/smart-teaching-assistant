#include "whiteboardmanager.h"
#include <QDebug>

WhiteboardManager::WhiteboardManager(QObject *parent)
    : QObject(parent),
    lowerColor(cv::Scalar(0, 114, 153)),
    upperColor(cv::Scalar(22, 255, 255)),
    currentColor(cv::Scalar(0, 0, 255)),
    redArea(cv::Rect(0, 0, 50, 50)),
    greenArea(cv::Rect(60, 0, 50, 50)),
    blueArea(cv::Rect(120, 0, 50, 50)),
    eraserArea(cv::Rect(180, 0, 50, 50)),
    clearArea(cv::Rect(640 - 100, 0, 100, 50)),
    isDrawing(false),
    eraserSelected(false),
    drawingEnabled(false)
{
    whiteboard = cv::Mat(cv::Size(640, 480), CV_8UC3, cv::Scalar(255, 255, 255));
}

WhiteboardManager::~WhiteboardManager()
{
}

void WhiteboardManager::enableDrawing() {
    drawingEnabled = true;
}

void WhiteboardManager::disableDrawing() {
    drawingEnabled = false;
}

void WhiteboardManager::processFrame(const QImage &frame)
{
    cv::Mat matFrame(frame.height(), frame.width(), CV_8UC3, const_cast<uchar*>(frame.bits()), frame.bytesPerLine());
    cv::cvtColor(matFrame, matFrame, cv::COLOR_RGB2BGR);

    cv::Mat hsvFrame, mask;
    cv::cvtColor(matFrame, hsvFrame, cv::COLOR_BGR2HSV);
    cv::inRange(hsvFrame, lowerColor, upperColor, mask);

    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(mask, contours, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE);

    if (!contours.empty() && drawingEnabled) {
        std::sort(contours.begin(), contours.end(), [](const std::vector<cv::Point>& c1, const std::vector<cv::Point>& c2) {
            return cv::contourArea(c1, false) > cv::contourArea(c2, false);
        });

        cv::Rect boundingRect = cv::boundingRect(contours[0]);
        cv::Point center(boundingRect.x + boundingRect.width / 2, boundingRect.y + boundingRect.height / 2);

        // Check if the marker is in any of the selection areas
        if (clearArea.contains(center)) {
            clearWhiteboard();
        } else if (redArea.contains(center)) {
            currentColor = cv::Scalar(0, 0, 255); // Red
            eraserSelected = false;
        } else if (greenArea.contains(center)) {
            currentColor = cv::Scalar(0, 255, 0); // Green
            eraserSelected = false;
        } else if (blueArea.contains(center)) {
            currentColor = cv::Scalar(255, 0, 0); // Blue
            eraserSelected = false;
        } else if (eraserArea.contains(center)) {
            currentColor = cv::Scalar(255, 255, 255); // White for eraser
            eraserSelected = true;
        } else {
            if (isDrawing) {
                int thickness = eraserSelected ? 15 : 2; // Larger thickness for eraser
                cv::line(whiteboard, prevPoint, center, currentColor, thickness);
            }
            prevPoint = center;
            isDrawing = true;
        }
    } else {
        isDrawing = false;
    }

    // Draw the "Clear" button with a distinct background color
    cv::rectangle(whiteboard, clearArea, cv::Scalar(200, 200, 200), cv::FILLED); // Light gray background
    cv::putText(whiteboard, "Clear", cv::Point(whiteboard.cols - 90, 30), cv::FONT_HERSHEY_SIMPLEX, 0.5, cv::Scalar(0, 0, 0), 1); // Black text

    // Draw color selection and eraser buttons
    cv::rectangle(whiteboard, redArea, cv::Scalar(0, 0, 255), cv::FILLED);
    cv::rectangle(whiteboard, greenArea, cv::Scalar(0, 255, 0), cv::FILLED);
    cv::rectangle(whiteboard, blueArea, cv::Scalar(255, 0, 0), cv::FILLED);
    cv::rectangle(whiteboard, eraserArea, cv::Scalar(200, 200, 200), cv::FILLED);
    cv::putText(whiteboard, "Eraser", cv::Point(eraserArea.x + 5, eraserArea.y + 30), cv::FONT_HERSHEY_SIMPLEX, 0.4, cv::Scalar(0, 0, 0), 1);

    // qtWhiteboardImage = QImage(whiteboard.data, whiteboard.cols, whiteboard.rows, QImage::Format_RGB888).rgbSwapped();

    cv::Mat weightedFrame;
    cv::addWeighted(matFrame, 0.5, whiteboard, 0.5, 0, weightedFrame);

    qtWeightedImage = QImage(weightedFrame.data, weightedFrame.cols, weightedFrame.rows, QImage::Format_RGB888).rgbSwapped();

    emit newWeightedImage(qtWeightedImage);

}

void WhiteboardManager::clearWhiteboard()
{
    whiteboard = cv::Mat(cv::Size(640, 480), CV_8UC3, cv::Scalar(255, 255, 255));
    emit newWeightedImage(QImage(whiteboard.data, whiteboard.cols, whiteboard.rows, QImage::Format_RGB888).rgbSwapped());
}

void WhiteboardManager::saveSnapshot(const QString &filePath)
{
    qDebug() << filePath;
    QImage(whiteboard.data, whiteboard.cols, whiteboard.rows, QImage::Format_RGB888).rgbSwapped().save(filePath);
}

void WhiteboardManager::loadImage(const QString &filePath) {
    qDebug() << "image received";
    QImage image(filePath);
    qDebug() << image.isNull();
    if (!image.isNull()) {
        qDebug() << "image converted";
        cv::Mat mat(image.height(), image.width(), CV_8UC4, const_cast<uchar*>(image.bits()), image.bytesPerLine());
        cv::cvtColor(mat, whiteboard, cv::COLOR_RGBA2BGR);
        emit newWeightedImage(QImage(whiteboard.data, whiteboard.cols, whiteboard.rows, QImage::Format_RGB888).rgbSwapped());
    }
}
