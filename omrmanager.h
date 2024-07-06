#ifndef OMRMANAGER_H
#define OMRMANAGER_H

#include <QObject>
#include <QVariant>
#include <QImage>
#include <QDebug>
#include <opencv2/opencv.hpp>
# include <vector>
# include "imutils.h"


class OMRmanager : public QObject
{
    Q_OBJECT
public:
    explicit OMRmanager(QObject *parent = nullptr);
    cv::Mat detectPaper(cv::Mat& img);
    std::vector<std::vector<std::vector<cv::Point>>> getCircles(cv::Mat img, cv::Mat& imgCopy, int x, int y, bool rollNo = false);
    std::vector<int> getSelectedCircles(cv::Mat& img, std::vector<std::vector<std::vector<cv::Point>>>& circles, cv::Mat& imgCopy, int x, int y, bool rollNo = false);
    int getRollNo(cv::Mat& img, cv::Mat& imgCopy);
    std::vector<int> getSelectedOptions(cv::Mat& img, cv::Mat& imgCopy, bool firstPage = false);

public slots:
    void startOMR(const QVariant &imgVar, const bool firstPage);
    void connectOMRPage(QObject* currentItem);

signals:
    void newScannedImage(const QImage img);

private:
    QImage scannedImage;
};

#endif // OMRMANAGER_H
