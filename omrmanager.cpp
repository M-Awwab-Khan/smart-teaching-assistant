#include "omrmanager.h"

using namespace cv;
using namespace std;

OMRmanager::OMRmanager(QObject *parent)
    : QObject{parent}   // Inherit with QObject to use signals
{}


void OMRmanager::startOMR(const QVariant &imgVar, const bool firstPage, const QString ansKey, const double negative_marking)
{
    this->ansKey = ansKey;
    this->negative_marking = negative_marking;
    qDebug() << "First Page = " << firstPage;
    qDebug() << ansKey;
    if (imgVar.canConvert<QImage>()) {
        QImage img = imgVar.value<QImage>();
        qDebug() << img.height() << " " << img.width();

        cv::Mat mat(img.height(), img.width(), CV_8UC3, const_cast<uchar*>(img.bits()), img.bytesPerLine());
        cv::rotate(mat, mat, cv::ROTATE_90_CLOCKWISE);
        //cv::Mat temp = imread("C:/opencv/OpenCVCourse/Resources/Sample36(a).jpg");
        cv::Mat paper = detectPaper(mat);

        cv::Mat paperCopy = paper.clone(); // To display annotations

        try {  // If image is not correct
        if(firstPage) {
            this->rollNo = getRollNo(paper, paperCopy);
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
    int dpi = 250;  // Dots per inch of the display
    float w = 8.27 * dpi, h = 11.69 * dpi; // dimension of A4 paper


    cvtColor(img, imgEdge, COLOR_BGR2GRAY);  // Grayscale
    GaussianBlur(imgEdge, imgEdge, Size(5, 5), 0); // Blur
    Canny(imgEdge, imgEdge, 75, 200); // Edge detection


    // Detecting rectangle
    vector<vector<Point>> contours; // For storing shapes
    vector<Vec4i> hierarchy;    // To store heirarchy [Not Used]

    findContours(imgEdge, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE); // Finding Shapes

    vector<vector<Point>> conPoly(contours.size());     // Stores Corners of the shape
    Rect boundRect;                                     // Bounding rectangle
    bool found = false;                                 // Flag

    // Iterating over each shape
    for (int i = 0; i < contours.size(); i++) {
        int area = contourArea(contours[i]);                                // area of shape
        if (area > 35000) {                                                 // Condition to detect Paper
            float peri = arcLength(contours[i], true);                      // Permieter of the shape
            approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);       // Calculating corners and storing them in conPoly[i]
            int cor = (int)conPoly[i].size();                               // Number of Corners
            if (cor >= 4) {                                                 // An imperfect rectangle will atleast have 4 corners
                boundRect = boundingRect(conPoly[i]);
                found = true;
                break;
            }
        }
    }

    if (found) {   // Found paper in the Image
        // Now, Getting top view of the paper referred as Cropping.

        Point2f dst[4] = { {0.0f, 0.0f}, {w, 0.0f}, {0.0f, h}, {w, h} };
        // Destination points for Cropping

        Point2f src[4] = {
            // Source points for Cropping
            // Here boundRect is the Paper itself
            Point2f(boundRect.tl().x + 20, boundRect.tl().y + 20),
            Point2f(boundRect.tl().x + boundRect.width - 20, boundRect.tl().y + 20),
            Point2f(boundRect.tl().x + 20, boundRect.tl().y + boundRect.height - 20),
            Point2f(boundRect.br().x - 20, boundRect.br().y - 20)
        };

        Mat matrix = getPerspectiveTransform(src, dst);
        // A Matrix that will
        // transfer src points to dst points

        warpPerspective(img, newImg, matrix, Point(w, h));      // Actually cropping the image
        resize(newImg, newImg, Size(), 0.5, 0.5);   // A4 paper size is larger, so scaling it down.

        cout << "Paper Successfully Detected\n";
        return newImg;      //Image of paper detected in the given Image
    }

    cout << "Paper unsuccessfully Detected\n";
    return img;             // if not found, returns the same image
}

vector<vector<vector<Point>>> OMRmanager::getCircles(Mat img, Mat& imgCopy, int x, int y, bool rollNo) {

    // This function will return all sorted OMR circles
    // It will not check whether the circle is filled or not.

    Mat localImage, imgEdge;

    localImage = img.clone();                       // Preserving original image

    cvtColor(localImage, imgEdge, COLOR_BGR2GRAY);  // Grayscale
    threshold(imgEdge, imgEdge, 0, 255, THRESH_OTSU | THRESH_BINARY_INV);   // Edge detection

    // Finding Contours

    vector<vector<Point>> contours;     // For storing shapes
    vector<Vec4i> hierarchy;            // To store heirarchry [Not used here]

    findContours(imgEdge, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE); // Finding Shapes

    vector<vector<Point>> conPoly(contours.size());     // Stores corners of the shape
    Rect boundRect;                                     // Bounding Rectangle of the shape

    // Detecting Circles
    vector<vector<Point>> circles;      // To store the circles

    // Iterating over all shapes
    for (int i = 0; i < contours.size(); i++) {
        int area = contourArea(contours[i]);                        // Area of the shape
        float peri = arcLength(contours[i], true);                  // Perimeter of the shape
        approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);   // Corners of the shape
        boundRect = boundingRect(conPoly[i]);                       // Bounding Rectangle of the shape

        int w = boundRect.br().x - boundRect.tl().x, h = boundRect.br().y - boundRect.tl().y;
        // Width and Height of bounding rectangle of the shape

        float aspectRatio = float(w) / float(h);

        // Condition for OMR circle
        if (w >= 20 && h >= 20 && aspectRatio >= 0.8 && aspectRatio <= 1.1 && area < 1300) {
            circles.push_back(contours[i]);
        }
    }

    // Sorting Circles

    vector<vector<vector<Point>>> sortedCircles;    // To store sorted circles

    vector<Rect> empty1;    // Sort function needs empty vector for storing bounfing Rect

    // Vertically sorted circles
    circles = imutils::sort_contours(circles, empty1, imutils::SortContoursMethods::top_to_bottom);

    int c;	// No. of columns
    if (rollNo) {
        c = 10;
    }
    else {
        c = 4;
    }

    for (int i = 0; i < circles.size(); i += c) {

        vector<vector<Point>> temp; // For storing sorrted circles of a row
        vector<Rect> empty2;        // Sort function needs empty vector for storing bounfing Rect

        for (int j = i; (j < circles.size()) && (j < (i + c)); j++) {
            temp.push_back(circles[j]);
        }
        // Temp holds circles of current row

        temp = imutils::sort_contours(temp, empty2, imutils::SortContoursMethods::left_to_right); // Sorting circles of current row
        sortedCircles.push_back(temp);  // Soerted circles gets a row of sorted circles

    }

    // Now, Annotating the imgCopy
    int count = 1;

    for (int i = 0; i < sortedCircles.size(); i++) {
        for (int j = 0; j < sortedCircles[i].size(); j++) {
            // Writing circle count above each circle
            putText(imgCopy, to_string(count++), Point(sortedCircles[i][j][0].x + x, sortedCircles[i][j][0].y + y), FONT_HERSHEY_COMPLEX, 0.75, Scalar(255, 0, 0), 2);

            // Drawing circle on each circle with BLUE color
            drawContours(imgCopy, sortedCircles[i], j, Scalar(255, 0, 0), 2, 8, {}, 2147483647, Point(x, y));
        }
    }

    return sortedCircles;
}

vector<int> OMRmanager::getSelectedCircles(Mat& img, vector<vector<vector<Point>>>& circles, Mat& imgCopy, int x, int y, bool rollNo) {

    // This function will return the selected option of each Row of given circles [Parameter]
    // First option is 0, Second option is 1, ...

    // In case of multiple attempts in Roll No then First circle will be considered filled.
    // In case of multiple attempts in Questions then -1 will be appended denoting NEGATIVE MARKING

    // If no option is selected then -2 will be appended in the vector

    Mat imgEdge;
    cvtColor(img, imgEdge, COLOR_BGR2GRAY);                               // Grayscale
    threshold(imgEdge, imgEdge, 0, 255, THRESH_OTSU | THRESH_BINARY_INV); // Image with Edges

    vector<int> selectedIndices;    // To store selected options

    // Iterating over circles
    for (int i = 0; i < circles.size(); i++) {
        vector<int> options;    // For storing current row's selection

        // Iterating over current row
        for (int j = 0; j < circles[i].size(); j++) {
            Mat mask = Mat::zeros(imgEdge.size(), CV_8UC1);             // Black Mask
            drawContours(mask, circles[i], j, Scalar(255), cv::FILLED); // Creating white circle on Black mask

            Mat masked;
            bitwise_and(imgEdge, imgEdge, masked, mask);   // Gets masked image, for ith circle

            int total = countNonZero(masked);  // Getting count of White pixels [ How much the circle is filled]

            if(total >= 800) { // Atlest 800 white pixels

                options.push_back(j);

                if(rollNo) {        // If its rollNo then just get the first circle of the row
                    break;
                }
            }

        }


        if(options.size() == 1) { // Found 1 selection
            selectedIndices.push_back(options[0]);

            // Drawing green Circle on correctly filled Circle [Not showing the correct option]
            drawContours(imgCopy, circles[i], options[0], Scalar(0, 255, 0), 2, 8, {}, 2147483647, Point(x, y));
        }
        else if(rollNo && options.size() == 0) {  // If its rollNo and row has no selection then
            // break the loop to ignore next rows
            break;
        }
        else if(options.size() == 0) {  // If its questions and row has no selections then
            // It is unattempted
            selectedIndices.push_back(-2);
        }
        else {  // If multiple options are selected in questions then
            // It is negatively marked
            selectedIndices.push_back(-1);

            for(auto o: options) {
                // Drawing RED circle on each negatively marked circle
                drawContours(imgCopy, circles[i], o, Scalar(0, 0, 255), 2, 8, {}, 2147483647, Point(x, y));
            }
        }
    }
    return selectedIndices;
}

int OMRmanager::getRollNo(Mat& img, Mat& imgCopy) {

    // This function will return rollNo of the student

    Mat imgEdge, localImg;

    cvtColor(img, imgEdge, COLOR_BGR2GRAY);             // Grayscale
    GaussianBlur(imgEdge, imgEdge, Size(5, 5), 0);      // Blur
    Canny(imgEdge, imgEdge, 75, 200);                   // Edge detection

    // First cropping the image w.r.t. Rectangle drawn on the first Page

    // Making edges thicker to easily detect rectangle
    Mat kernel = getStructuringElement(MORPH_RECT, Size(5,5));  // Specifes value for thickness of edges
    dilate(imgEdge, imgEdge, kernel);                           // Makes edges thicker

    // Detecting rectangle
    vector<vector<Point>> contours; // For storing shapes
    vector<Vec4i> hierarchy;        // To store heiarchry [Not used here]

    findContours(imgEdge, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE); // Finding shapes

    vector<vector<Point>> conPoly(contours.size());     // To store corners of the shapes
    Rect boundRect;                                     // Bounding rectangle

    // Iterating over each Shape
    for (int i = 0; i < contours.size(); i++) {
        int area = contourArea(contours[i]);            // Calculating Area of the shape
        if (area >= 20000) {                            // Condition for that

            float peri = arcLength(contours[i], true);                  // Perimeter of shape
            approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);   //  Corners of the shape
            int cor = (int)conPoly[i].size();
            if (cor == 4) { // Since rectangle is printed so it is perfect and must have exatcly 4 Corners

                boundRect = boundingRect(conPoly[i]);   // Bounding rectangle

                // Outlined the rectangle with Blue Color
                drawContours(imgCopy, contours, i, Scalar(255, 0, 0), 1, 8, {}, 2147483647);
                break;
            }
        }
    }

    // Now cropping that rectangle from the image
    // ROI is the region which should be cropped from the image
    Rect roi(boundRect.tl().x + 20, boundRect.tl().y, boundRect.br().x - boundRect.tl().x, boundRect.br().y - boundRect.tl().y);

    localImg = img(roi);	// Cropped the Image
    // Loca img now just only holds rollNo circles not the questions of the First Page

    // First detected circles in the image
    vector<vector<vector<Point>>> circles = getCircles(localImg, imgCopy, roi.x, roi.y, true);

    // Passing circles to get selected Options
    vector<int> rollNoVector = getSelectedCircles(localImg, circles, imgCopy, roi.x, roi.y, true);

    // Now convertong vector<int> to int
    int rollNo = 0;
    for (int i = 0; i < rollNoVector.size(); i++) {
        rollNo += rollNoVector[i] * pow(10, rollNoVector.size() - i - 1);
    }

    return rollNo;
}

vector<int> OMRmanager::getSelectedOptions(Mat& img, Mat& imgCopy, bool firstPage) {

    // This function will return selected options of questions

    Mat firstColumn, secondColumn;
    Rect roi1, roi2;    // For cropping

    if (firstPage) {

        Mat imgEdge;
        cvtColor(img, imgEdge, COLOR_BGR2GRAY);          // Grayscale
        GaussianBlur(imgEdge, imgEdge, Size(5, 5), 0);  // Blur
        Canny(imgEdge, imgEdge, 75, 200);               // Edge detection

        // Detecting rectangle on the firstPage
        vector<vector<Point>> contours; // For storing shapes
        vector<Vec4i> hierarchy;        // To store heirarchry [Not used here]

        findContours(imgEdge, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE); // Finding shapes

        vector<vector<Point>> conPoly(contours.size()); // Corners of the shape
        Rect boundRect; // Bounding rectangle

        // Iterating over each shape
        for (int i = 0; i < contours.size(); i++) {

            int area = contourArea(contours[i]);            // Area of the shape
            if (area >= 20000) {
                float peri = arcLength(contours[i], true);      // Perimeter of the shape
                approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);   // Corners of the shape
                int cor = (int)conPoly[i].size();
                if (cor == 4) {
                    boundRect = boundingRect(conPoly[i]);   // Bounding rectangle of the Rectangle
                    break;
                }
            }
        }

        // Cropping for First column w.r.t. Bounding rectangle
        roi1 = Rect(boundRect.tl().x, boundRect.br().y, 480, 850);
        roi2 = Rect(boundRect.tl().x + 380, boundRect.br().y, 480, 850);

    }
    else { // Not first Page

        roi1 = Rect(15, 100, 480, 1200);
        roi2 = Rect(400, 100, 480, 1200);
    }

    firstColumn = img(roi1);    // Cropped first column
    secondColumn = img(roi2);   // Cropped second column

    vector<vector<vector<Point>>> circles;  // To store circles
    vector<int> selectedOptions;            // to store selected options

    // First Column
    circles = getCircles(firstColumn, imgCopy, roi1.x, roi1.y);
    selectedOptions = getSelectedCircles(firstColumn, circles, imgCopy, roi1.x, roi1.y);

    // Second Column
    circles = getCircles(secondColumn, imgCopy, roi2.x, roi2.y);
    vector<int> temp = getSelectedCircles(secondColumn, circles, imgCopy, roi2.x, roi2.y);

    // temp holds options of second column

    selectedOptions.insert(selectedOptions.end(), temp.begin(), temp.end()); // Merged options of both Columns

    return selectedOptions;
}

QVariantMap OMRmanager::returnGrade()
{
    // Returns the dictionary containing result

    result.insert("rollNo", rollNo);
    result.insert("unattempted", 0);
    result.insert("correct", 0);
    result.insert("wrong", 0);
    result.insert("obtained", 0.0);

    string temp = "ABCD";
    int qNo = 0;
    for(auto i: resultVector) {
        if(i == -1) {   // Negative marking
            result["wrong"] = result["wrong"].toInt()+1;

        }
        else if(i == -2) {  // Unattempted
            result["unattempted"] = result["unattempted"].toInt()+1;
        }
        else {
            if(temp[i] == ansKey[qNo]) {    // Correct answer
                result["correct"] = result["correct"].toInt()+1;
            }
            else {
                result["wrong"] = result["wrong"].toInt()+1;    // Wrong answer
                qDebug() << "Qno = " << qNo + 1 << " ANs = " << ansKey[qNo];
            }
        }
        qNo += 1;

        if (qNo == ansKey.size()) { // Breaks if all questions checked
            break;
        }
    }

    // Obtained marks
    result["obtained"] = result["correct"].toInt() - result["wrong"].toInt()*negative_marking;

    // If didn't attempt all questions
    if (ansKey.size() > resultVector.size()) {
        result["unattempted"] = result["unattempted"].toInt() + (ansKey.size() - resultVector.size());
    }

    // If obtained marks are negative then make it 0
    if(result["obtained"].toDouble() < 0.0) {
        result["obtained"] = 0.0;
    }

    // After creating dictionary, clearing the result vector
    resultVector.clear();

    // Printing in console
    for (auto it = result.begin(); it != result.end(); ++it) {
        qDebug() << it.key() << ":" << it.value().toInt();
    }

    return result;
}

void OMRmanager::retry()
{
    qDebug() << "Retrying...";

    // Cleared current calculated result
    resultVector.clear();
    result.clear();

    // Changing to default image
    scannedImage = QImage(200,200,QImage::Format_RGB32);
    scannedImage.fill(QColor("black"));

    // Emitting signal to update the image
    emit newScannedImage(scannedImage);

}

