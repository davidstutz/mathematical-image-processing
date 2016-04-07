#include <opencv2/opencv.hpp>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include "improc.h"

cv::Mat inputImage, outputImage, outputImage2, openedImage;

const char* windowOrigName = "Original Image";
const char* windowFilterNamed = "Filtered Image";
const char* windowFilterNamed2 = "Filtered Image (isodata)";

int windowSize = 3;

void filterImage(int, void*)
{
    opening(inputImage, openedImage, windowSize);
    cv::Mat processed = inputImage - openedImage;
    isodata(processed, outputImage2);
    cv::imshow(windowFilterNamed2, outputImage2);

}

int main(int argc, char** argv)
{
    inputImage = cv::imread( argv[1] );

    if( !inputImage.data )
    {
        std::cout << "Input image" << std::endl;
        return -1;
    }

    cv::cvtColor(inputImage, inputImage, CV_BGR2GRAY);

    outputImage.create(inputImage.size(), CV_8UC1);
    openedImage.create(inputImage.size(), CV_8UC1);
    outputImage2.create(inputImage.size(), CV_8UC1);

    cv::namedWindow(windowOrigName, cv::WINDOW_NORMAL);
    cv::namedWindow(windowFilterNamed, cv::WINDOW_NORMAL);
    cv::namedWindow(windowFilterNamed2, cv::WINDOW_NORMAL);

    cv::imshow(windowOrigName, inputImage);
    isodata(inputImage, outputImage);

    cv::imshow(windowFilterNamed, outputImage);

    cv::createTrackbar("Window size:", windowFilterNamed2, &windowSize, 10, filterImage);

    filterImage(0,0);

    cv::waitKey();

    return 0;
}
