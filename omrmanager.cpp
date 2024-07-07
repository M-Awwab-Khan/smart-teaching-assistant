#include "omrmanager.h"
//# include "imutils.h"



using namespace cv;
using namespace std;
//using namespace imutils;

OMRmanager::OMRmanager(QObject *parent)
    : QObject{parent}
{}


void OMRmanager::startOMR(const QVariant &imgVar, const bool firstPage, const QString ansKey, const double negative_marking)
{
    this->ansKey = ansKey;
    qDebug() << "First Page = " << firstPage;
    qDebug() << ansKey;
    if (imgVar.canConvert<QImage>()) {
        QImage img = imgVar.value<QImage>();
        qDebug() << img.height() << " " << img.width();

        cv::Mat mat(img.height(), img.width(), CV_8UC3, const_cast<uchar*>(img.bits()), img.bytesPerLine());
         cv::rotate(mat, mat, cv::ROTATE_90_CLOCKWISE);
        //cv::Mat temp = imread("C:/Users/DELL/Downloads/sample1.jpeg");
        cv::Mat paper = detectPaper(mat);

        cv::Mat paperCopy = paper.clone(); // To display annotations

        try {
        if(firstPage) {
            this->rollNo = getRollNo(paper, paperCopy);
            this->negative_marking = negative_marking;
            cout << "ROll: " << this->rollNo << endl;
        }

        vector<int> temp = getSelectedOptions(paper, paperCopy, firstPage);
        resultVector.insert(resultVector.end(), temp.begin(), temp.end());
        qDebug() << "Length of REsult Vector " << resultVector.size();



        // cv::imwrite("temp1.png", paperCopy);

        scannedImage = QImage(paperCopy.data, paperCopy.cols, paperCopy.rows, static_cast<int>(paperCopy.step), QImage::Format_RGB888).rgbSwapped();
        emit newScannedImage(scannedImage);
        }
        catch (exception& e) {
            cerr << "Error!!!\n";
        }
    }
}

void OMRmanager::connectOMRPage(QObject *currentItem)
{
    qDebug() << "OMRmanager\n";
    if (currentItem) {
        QVariant pageId = currentItem->property("pageId");
        if (pageId.isValid() && pageId.toString() == "omrpage") {
            QObject::connect(currentItem, SIGNAL(imageCaptured(QVariant, bool, QString, double)), this, SLOT(startOMR(QVariant, bool, QString, double)));
        }
    }
}

Mat OMRmanager::detectPaper(Mat& img) {
    Mat imgEdge, newImg;
    int dpi = 250;
    float w = 8.27 * dpi, h = 11.69 * dpi; // dimension of A4 paper


    cvtColor(img, imgEdge, COLOR_BGR2GRAY);  // Grayscale
    GaussianBlur(imgEdge, imgEdge, Size(5, 5), 0); // Blur
    Canny(imgEdge, imgEdge, 75, 200); // Edge detection

    // Detecting rectangle
    vector<vector<Point>> contours; // For storing shapes
    vector<Vec4i> hierarchy;

    findContours(imgEdge, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);

    vector<vector<Point>> conPoly(contours.size());
    Rect boundRect; // Bounding rectangle
    bool found = false;
    for (int i = 0; i < contours.size(); i++) {
        int area = contourArea(contours[i]);
        if (area > 35000) {
            float peri = arcLength(contours[i], true);
            approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);
            int cor = (int)conPoly[i].size();
            if (cor >= 4) {
                drawContours(newImg, contours, -1, cv::Scalar(0, 255, 0), 1);
                boundRect = boundingRect(conPoly[i]);
                found = true;
                break;
            }
        }
    }

    if (found) {
        Point2f dst[4] = { {0.0f, 0.0f}, {w, 0.0f}, {0.0f, h}, {w, h} };

        Point2f src[4] = {
            Point2f(boundRect.tl().x + 20, boundRect.tl().y + 20),
            Point2f(boundRect.tl().x + boundRect.width - 20, boundRect.tl().y + 20),
            Point2f(boundRect.tl().x + 20, boundRect.tl().y + boundRect.height - 20),
            Point2f(boundRect.br().x - 20, boundRect.br().y - 20)
        };

        Mat matrix = getPerspectiveTransform(src, dst);
        warpPerspective(img, newImg, matrix, Point(w, h));
        resize(newImg, newImg, Size(), 0.5, 0.5);

        cout << "Paper Successfully Deteced\n";
        return newImg;
    }
    cout << "Paper unsuccessfully Deteced\n";
    return img; // if not found, returns the same image
}

vector<vector<vector<Point>>> OMRmanager::getCircles(Mat img, Mat& imgCopy, int x, int y, bool rollNo) {
    Mat localImage, imgEdge;
    localImage = img.clone();
    cvtColor(localImage, imgEdge, COLOR_BGR2GRAY);
    //cvtColor(img, imgEdge, COLOR_BGR2GRAY);
    threshold(imgEdge, imgEdge, 0, 255, THRESH_OTSU | THRESH_BINARY_INV);   // Image with edges

    // Finding Contours
    vector<vector<Point>> contours;
    vector<Vec4i> hierarchy;

    if (rollNo) {
    findContours(imgEdge, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
    } else {
        findContours(imgEdge, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);

    }
    // if (rollNo)
    // {
    //     imshow("Edged", imgEdge);
    //     waitKey(0);
    // }

    vector<vector<Point>> conPoly(contours.size());
    Rect boundRect;

    // Detecting Circles
    vector<vector<Point>> circles;
    for (int i = 0; i < contours.size(); i++) {
        int area = contourArea(contours[i]);
        float peri = arcLength(contours[i], true);
        approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);
        boundRect = boundingRect(conPoly[i]);

        int w = boundRect.br().x - boundRect.tl().x, h = boundRect.br().y - boundRect.tl().y;  // Width & Height
        float aspectRatio = float(w) / float(h);

        if (w >= 20 && h >= 20 && aspectRatio >= 0.8 && aspectRatio <= 1.1 && area < 1300) { // Determining Circle
            circles.push_back(contours[i]);
        }
    }

    // Sorting Circles

    vector<vector<vector<Point>>> sortedCircles;

    vector<Rect> empty1, empty2;
    circles = imutils::sort_contours(circles, empty1, imutils::SortContoursMethods::top_to_bottom);

    int c;	// No. of columns
    if (rollNo) {
        c = 10;
    }
    else {
        c = 4;
    }

    for (int i = 0; i < circles.size(); i += c) {
        vector<vector<Point>> temp;
        vector<Rect> empty2;
        for (int j = i; (j < circles.size()) && (j < (i + c)); j++) {
            temp.push_back(circles[j]);
        }
        // Temp holds circles of current row

        temp = imutils::sort_contours(temp, empty2, imutils::SortContoursMethods::left_to_right); // Sorting each row from left to right
        sortedCircles.push_back(temp);

        //for (int j = i; (j < circles.size()) && (j < (i + c)); j++) {
        //circles[j] = temp[j - i];
        //}
        // Reassigned sorted row to circles
    }

    int count = 1;
    //for (int i = 0; i < circles.size(); i++) {
    //putText(imgCopy, to_string(count++), Point(circles[i][0].x + x, circles[i][1].y + y), FONT_HERSHEY_COMPLEX, 0.75, Scalar(255, 0, 0), 2);
    //drawContours(imgCopy, circles, i, Scalar(0, 0, 255), 2, 8, {}, 2147483647, Point(x, y));
    //}

    for (int i = 0; i < sortedCircles.size(); i++) {
        for (int j = 0; j < sortedCircles[i].size(); j++) {
            putText(imgCopy, to_string(count++), Point(sortedCircles[i][j][0].x + x, sortedCircles[i][j][0].y + y), FONT_HERSHEY_COMPLEX, 0.75, Scalar(255, 0, 0), 2);
            drawContours(imgCopy, sortedCircles[i], j, Scalar(255, 0, 0), 2, 8, {}, 2147483647, Point(x, y));
        }
    }

    return sortedCircles;
}

vector<int> OMRmanager::getSelectedCircles(Mat& img, vector<vector<vector<Point>>>& circles, Mat& imgCopy, int x, int y, bool rollNo) {

    Mat imgEdge;
    cvtColor(img, imgEdge, COLOR_BGR2GRAY);
    threshold(imgEdge, imgEdge, 0, 255, THRESH_OTSU | THRESH_BINARY_INV); // Binary Image with Edges


    int indexOfCircle = -1;
    int k = -1;  // For drawing
    int c;
    if (rollNo) {
        c = 10;
    }
    else {
        c = 4;
    }

    vector<int> selectedIndices;


    for (int i = 0; i < circles.size(); i++) {
        bool found = false;
        vector<int> options;
        //int indArray[2] = { -1, -1 };
        for (int j = 0; j < circles[i].size(); j++) {
            Mat mask = Mat::zeros(imgEdge.size(), CV_8UC1);
            drawContours(mask, circles[i], j, Scalar(255), cv::FILLED);

            Mat masked;
            bitwise_and(imgEdge, imgEdge, masked, mask);   // Gets masked image, for ith circle

            int total = countNonZero(masked);

            if(rollNo) {
                if (total >= 800) {
                    // if (found) {
                    //     found = false;
                    //     break;
                    // }
                    // //indArray[0] = i, indArray[1] = j;
                    // found = true;
                    options.push_back(j);
                    break;
                    //k = j;
                }
            }
            else {
                if (total >= 800) {
                    // if (found) {
                    //     found = false;
                    // }
                    // //indArray[0] = i, indArray[1] = j;
                    // found = true;
                    options.push_back(j);
                    //k = j;
                }
            }

        }

        // if (found) {
        //     selectedIndices.push_back(k);
        //     drawContours(imgCopy, circles[i], k, Scalar(0, 255, 0), 2, 8, {}, 2147483647, Point(x, y));
        // }
        // else if (rollNo) {
        //     break;
        // }
        // else {
        //     selectedIndices.push_back(-1);
        // }

        if(options.size() == 1) { // Found 1
            selectedIndices.push_back(options[0]);
            drawContours(imgCopy, circles[i], options[0], Scalar(0, 255, 0), 2, 8, {}, 2147483647, Point(x, y));
        }
        else if(rollNo && options.size() == 0) {
            break;
        }
        else if(options.size() == 0) {
            selectedIndices.push_back(-2);
        }
        else {
            selectedIndices.push_back(-1);
            for(auto o: options) {
                drawContours(imgCopy, circles[i], o, Scalar(0, 0, 255), 2, 8, {}, 2147483647, Point(x, y));
            }
        }
    }
    return selectedIndices;
}

int OMRmanager::getRollNo(Mat& img, Mat& imgCopy) {


    Mat imgEdge, localImg;
    cvtColor(img, imgEdge, COLOR_BGR2GRAY);  // Grayscale
    GaussianBlur(imgEdge, imgEdge, Size(5, 5), 0); // Blur
    Canny(imgEdge, imgEdge, 75, 200); // Edge detection

    // Detecting rectangle
    vector<vector<Point>> contours; // For storing shapes
    vector<Vec4i> hierarchy;

    findContours(imgEdge, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);

    vector<vector<Point>> conPoly(contours.size());
    Rect boundRect; // Bounding rectangle
    bool found = false;
    for (int i = 0; i < contours.size(); i++) {
        int area = contourArea(contours[i]);
        if (area >= 20000) {
            float peri = arcLength(contours[i], true);
            approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);
            int cor = (int)conPoly[i].size();
            if (cor == 4) {
                boundRect = boundingRect(conPoly[i]);
                drawContours(imgCopy, contours, i, Scalar(255, 0, 0), 1, 8, {}, 2147483647);
                break;
            }
        }
    }

    Rect roi(boundRect.tl().x + 20, boundRect.tl().y, boundRect.br().x - boundRect.tl().x, boundRect.br().y - boundRect.tl().y);

    localImg = img(roi);		// Cropped the Image

    vector<vector<vector<Point>>> circles = getCircles(localImg, imgCopy, roi.x, roi.y, true);

    cout << "1 funcs\n";

    vector<int> rollNoVector = getSelectedCircles(localImg, circles, imgCopy, roi.x, roi.y, true);

    cout << "2non funcs\n";

    int rollNo = 0;
    for (int i = 0; i < rollNoVector.size(); i++) {
        rollNo += rollNoVector[i] * pow(10, rollNoVector.size() - i - 1);
    }

    return rollNo;
}

vector<int> OMRmanager::getSelectedOptions(Mat& img, Mat& imgCopy, bool firstPage) {

    Mat firstColumn, secondColumn;
    Rect roi1, roi2;
    if (firstPage) {


        Mat imgEdge, localImg;
        cvtColor(img, imgEdge, COLOR_BGR2GRAY);  // Grayscale
        GaussianBlur(imgEdge, imgEdge, Size(5, 5), 0); // Blur
        Canny(imgEdge, imgEdge, 75, 200); // Edge detection

        // Detecting rectangle
        vector<vector<Point>> contours; // For storing shapes
        vector<Vec4i> hierarchy;

        findContours(imgEdge, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);

        vector<vector<Point>> conPoly(contours.size());
        Rect boundRect; // Bounding rectangle
        bool found = false;
        for (int i = 0; i < contours.size(); i++) {
            int area = contourArea(contours[i]);
            if (area >= 1000) {
                float peri = arcLength(contours[i], true);
                approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);
                int cor = (int)conPoly[i].size();
                if (cor == 4) {
                    boundRect = boundingRect(conPoly[i]);
                    break;
                }
            }
        }

        roi1 = Rect(boundRect.tl().x, boundRect.br().y, 480, 850);
        roi2 = Rect(boundRect.tl().x + 380, boundRect.br().y, 480, 850);

        // roi1 = Rect(boundRect.tl().x, boundRect.br().y + 10, boundRect.tl().x + ((boundRect.tl().x + boundRect.br().x) / 2), 860);
        // roi2 = Rect(boundRect.tl().x + ((boundRect.tl().x + boundRect.br().x) / 2), boundRect.br().y + 10, 480, 860);


        //roi1 = Rect(15, 500, 480, 850);
        //roi2 = Rect(400, 500, 480, 850);
    }
    else {
        roi1 = Rect(15, 100, 480, 1200);
        roi2 = Rect(400, 100, 480, 1200);
    }

    firstColumn = img(roi1);
    secondColumn = img(roi2);

    vector<vector<vector<Point>>> circles;
    vector<int> selectedOptions;

    circles = getCircles(firstColumn, imgCopy, roi1.x, roi1.y);
    selectedOptions = getSelectedCircles(firstColumn, circles, imgCopy, roi1.x, roi1.y);

    circles = getCircles(secondColumn, imgCopy, roi2.x, roi2.y);
    vector<int> temp = getSelectedCircles(secondColumn, circles, imgCopy, roi2.x, roi2.y);

    selectedOptions.insert(selectedOptions.end(), temp.begin(), temp.end());

    return selectedOptions;
}

QVariantMap OMRmanager::returnGrade()
{
    result.insert("rollNo", rollNo);
    result.insert("unattempted", 0);
    result.insert("correct", 0);
    result.insert("wrong", 0);
    result.insert("obtained", 0.0);
    string temp = "ABCD";
    int qNo = 0;
    for(auto i: resultVector) {
        if(i == -1) {
            result["wrong"] = result["wrong"].toInt()+1;
        }
        else if(i == -2) {
            result["unattempted"] = result["unattempted"].toInt()+1;
        }
        else {
            if(temp[i] == ansKey[qNo]) {
                result["correct"] = result["correct"].toInt()+1;
            }
            else {
                result["wrong"] = result["wrong"].toInt()+1;
            }
        }
        qNo += 1;
        if (qNo == ansKey.size()) {
            break;
        }
    }
    result["obtained"] = result["correct"].toInt() - result["wrong"].toInt()*negative_marking;

    if (ansKey.size() > resultVector.size()) {
        result["unattempted"] = result["unattempted"].toInt() + (ansKey.size() - resultVector.size());
    }

    if(result["obtained"].toDouble() < 0.0) {
        result["obtained"] = 0.0;
    }
    resultVector.clear();
    for (auto it = result.begin(); it != result.end(); ++it) {
        qDebug() << it.key() << ":" << it.value().toInt();
    }
    return result;
}

void OMRmanager::retry()
{
    resultVector.clear();
}

