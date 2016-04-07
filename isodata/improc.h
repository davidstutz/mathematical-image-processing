#ifndef IMPROC_H
#define IMPROC_H

#include <opencv2/opencv.hpp>

/** \brief Compute the dilation of the image using the given window size.
 * \param[in] in
 * \param[out] out
 * \param[in] windowSize
 */
void dilation(const cv::Mat & in, cv::Mat out, int windowSize)
{
    for (int x = 0; x < in.cols; x++)
    {
        for (int y = 0; y < in.rows; y++)
        {
            // Find the max over this window
            uchar sup = 0;
            for (int _x = std::max(0, x - windowSize); _x <= std::min(in.cols - 1, x + windowSize); _x ++)
            {
                for (int _y = std::max(0, y - windowSize); _y <= std::min(in.rows - 1, y + windowSize); _y ++)
                {
                    const uchar val = in.at<uchar>(_y,_x);
                    if (val > sup)
                    {
                        sup = val;
                    }
                }
            }
            out.at<uchar>(y,x) = sup;

        }
    }
}

/** \brief Compute the erosion of the image using the given window size.
 * \param[in] in
 * \param[out] out
 * \param[in] windowSize
 */
void erosion(const cv::Mat & in, cv::Mat out, int windowSize)
{
    for (int x = 0; x < in.cols; x++)
    {
        for (int y = 0; y < in.rows; y++)
        {
            // Find the max over this window
            uchar inf = 255;
            for (int _x = std::max(0, x - windowSize); _x <= std::min(in.cols - 1, x + windowSize); _x ++)
            {
                for (int _y = std::max(0, y - windowSize); _y <= std::min(in.rows - 1, y + windowSize); _y ++)
                {
                    const uchar val = in.at<uchar>(_y,_x);
                    if (val < inf)
                    {
                        inf = val;
                    }
                }
            }
            out.at<uchar>(y,x) = inf;

        }
    }
}

/** \brief Compute the opening of the image (i.e. erosion and dilation) using the given image size.
 * \param[in] in
 * \param[out] out
 * \param[in] windowSize
 */
void opening(const cv::Mat & in, cv::Mat & out, int windowSize)
{
    cv::Mat tempOut = cv::Mat::zeros(in.rows, in.cols, CV_8UC1);
    erosion(in, tempOut, windowSize);
    dilation(tempOut, out, windowSize);
}

/** \brief Compute the closing of the image (i.e. dilation and erosion) using the given image size.
 * \param[in] in
 * \param[out] out
 * \param[in] windowSize
 */
void closing(const cv::Mat & in, cv::Mat & out, int windowSize)
{
    cv::Mat tempOut = cv::Mat::zeros(in.rows, in.cols, CV_8UC1);
    dilation(in, tempOut, windowSize);
    erosion(tempOut, out, windowSize);
}

/** \brief Threshold the given image.
 * \param[in] in
 * \param[out] out
 * \param[in] threshold
 */
void threshold(const cv::Mat & in, cv::Mat & out, uchar threshold)
{
    for (int x = 0; x < in.cols; x++)
    {
        for (int y = 0; y < in.rows; y++)
        {
            if (in.at<uchar>(y,x) < threshold)
            {
                out.at<uchar>(y,x) = 0;
            }
            else
            {
                out.at<uchar>(y,x) = 255;
            }
        }
    }
}

/** \brief Compute of size 256 for the given image which is returned as in array.
 * \param[in] in
 * \return hist
 */
int* computeHistogram(const cv::Mat & in)
{
    auto hist = new int[256];
    for (int i = 0; i < 256; i++)
    {
        hist[i] = 0;
    }

    for (int x = 0; x < in.cols; x++)
    {
        for (int y = 0; y < in.rows; y++)
        {
            hist[static_cast<int>(in.at<uchar>(y,x))]++;
        }
    }
    return hist;
}

/** \brief Compute the cumulative histogram of size 256 for the given image which.
 * \param[in] hist
 * \return cumsum
 */
int* computeCumulativeHistogram(const int* hist)
{
    auto cumsum = new int[256];
    cumsum[0] = hist[0];
    for (int i = 1; i < 256; i++)
    {
        cumsum[i] = hist[i] + cumsum[i-1];
    }
    return cumsum;
}

/** \brief Apply the isodata algorithm on the given image
 * \param[in] in
 * \param[out] out
 */
void isodata(const cv::Mat & in, cv::Mat out)
{
    // Compute a histogram and a cumulative histogram
    int* hist = computeHistogram(in);
    int* cumsum = computeCumulativeHistogram(hist);
    // Set up the multiplied histogram
    for (int i = 0; i < 256; i++)
    {
        hist[i] *= i;
    }
    int* cumsum2 = computeCumulativeHistogram(hist);

    // Set up the fixed point function
    auto phi = [cumsum2, cumsum](float f) -> float {
        int i = static_cast<int>(f);
        return 0.5f*(cumsum2[i]/cumsum[i] + (cumsum2[255] - cumsum2[i])/(cumsum[255] - cumsum[i]));
    };

    float theta = 0.5*255;
    do {
        float newTheta = phi(theta);
        if (std::abs(theta - newTheta) < 1e-3)
        {
            break;
        }
        theta = newTheta;
    } while(true);

    threshold(in, out, static_cast<int>(std::round(theta)));
    delete[] hist;
    delete[] cumsum;
    delete[] cumsum2;
}

#endif
