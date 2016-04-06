#include <opencv2/opencv.hpp>
#include <math.h>

/** \brief Correlate the given image with the given filter.
 * \param[in] image
 * \param[in] filter
 * \return filteredImage
 */
cv::Mat correlate(const cv::Mat &image, const cv::Mat &filter) {
    assert(filter.rows % 2 == 1);
    assert(filter.cols % 2 == 1);

    int width = filter.rows/2;
    int height = filter.cols/2;

    cv::Mat filteredImage = image.clone();
    
    for (int j = 0; j < image.cols; j++) {
        for (int i = 0; i < image.rows; i++) {
            
            float value = 0;
            for (int jj = 0; jj < filter.cols; jj++) {
                for (int ii = 0; ii < filter.rows; ii++) {
                    if (j + jj - width < 0 || j + jj - width > image.cols - 1) {
                        continue;
                    }
                    
                    if (i + ii - height < 0 || i + ii - height > image.rows - 1) {
                        continue;
                    }
                    
                    value += image.at<unsigned char>(i + ii - height, j + jj - width) * filter.at<float>(ii, jj);
                    // std::cout << value << std::endl;
                }
            }
            
            filteredImage.at<unsigned char>(i, j) = value;
        }
    }
    
    return filteredImage;
}

/** \brief Apply a median filter of the given size to the image.
 * \param[in] image
 * \param[in] size
 * \return filteredImage
 */
cv::Mat medianFilter(const cv::Mat & image, int size) {
    
    int N = (2*size + 1)*(2*size + 1);
    std::vector<unsigned char> values(N, 0);

    cv::Mat filteredImage = image.clone();

    for (int j = 0; j < image.cols; j++) {
        for (int i = 0; i < image.rows; i++) {
            
            int n = 0;
            std::fill(values.begin(), values.end(), 0);
            
            for (int jj = -size; jj <= size; jj++) {
                for (int ii = -size; ii <= size; ii++) {
                    if (j + jj < 0 || j + jj > image.cols - 1) {
                        continue;
                    }
                    
                    if (i + ii < 0 || i + ii > image.rows - 1) {
                        continue;
                    }
                    
                    values[n] = image.at<unsigned char>(i + ii, j + jj);
                    n++;
                }
            }
            
            std::sort(values.begin(), values.end());
            filteredImage.at<unsigned char>(i, j) = values[2*size + 1];
        }
    }
    
    return filteredImage;
}

/** \brief Get the binomial coefficient.
 * \param[in] n
 * \param[in] k
 * \return binomialCoefficient
 */
int binomialCoefficient(int n, int k) {
    
    if (0 == k || n == k) {
        return 1;
    }
    
    if (k > n) {
        return 0;
    }
    
    if (k > (n - k)) {
        k = n - k;
    }
    
    if (1 == k) {
        return n;
    }
    
    int res = 1;
    for (int i = 1; i <= k; ++i) {
        res *= (n - (k - i));
        
        if (res < 0) {
            return -1;
        }
        
        res /= i;
    }
    
    return res;
}

/** \brief Apply a specified, fixed filter on the given image.
 * Usage: ./filters_cli path/to/image
 * Creates output.png containing the filtered image. To change the used filter,
 * adapt 'filter' below.
 * \param[in] argc
 * \param[in] argv
 * \return status
 */
int main(int argc, char** argv) {
    
    // Set to change applied filter!
    int filter = 1;
    int size = 5;
    int height = 2*size + 1;
    int width = 2*size + 1;
    
    float variance = 2.5;
    float lambda = 0.5;
    
    cv::Mat image = cv::imread(argv[1]);
    cv::cvtColor(image, image, CV_BGR2GRAY);
    cv::Mat filteredImage;
    
    cv::Mat average(height, width, CV_32FC1, cv::Scalar(0));
    average = 1.f/(height*width);
    
    cv::Mat gaussian(height, width, CV_32FC1, cv::Scalar(0));
         
    float normalization = 0;
    for (int j = 0; j < gaussian.cols; j++) {
        for (int i = 0; i < gaussian.rows; i++) {
            int jj = j - size;
            int ii = i - size;
            
            gaussian.at<float>(i, j) = std::exp(- (ii*ii + jj*jj)/(2*variance*variance));
            normalization += gaussian.at<float>(i, j);
        }
    }
    gaussian /= normalization;

    cv::Mat binomial(height, width, CV_32FC1, cv::Scalar(0));
    
    std::vector<int> b(2*size + 2);
    for (int i = 0; i < b.size(); i++) {
        b[i] = binomialCoefficient(2*size + 1, i);
    }
    normalization = 0;
    for (int j = 0; j < binomial.cols; j++) {
        for (int i = 0; i < binomial.rows; i++) {
            binomial.at<float>(i, j) = b[i]*b[j];
            normalization += binomial.at<float>(i, j);
        }
    }
    
    binomial /= normalization;
    
    switch (filter) {
        case 0:
            filteredImage = correlate(image, average);
            break;
        case 1:
            filteredImage = correlate(image, gaussian);
            break;
        case 2:
            filteredImage = medianFilter(image, size);
            break;
        case 3:
            filteredImage = correlate(image, gaussian);
            filteredImage = lambda*image + (1 - lambda)*filteredImage;
            break;
        case 4:
            filteredImage = correlate(image, binomial);
            break;
    }
    
    cv::imwrite("output.png", filteredImage);
    return 0;
}
