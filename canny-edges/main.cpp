#include <opencv2/opencv.hpp>
#include <math.h>

int threshold = 10;
int max_threshold = 50;

cv::Mat canny;
cv::Mat grad;
cv::Mat orientation;

std::string window_name = "Canny";

/** \brief Correlate the image with the given filter.
 * \param[in] image
 * \param[in] filter
 * \return filteredImage
 */
cv::Mat correlate(const cv::Mat &image, const cv::Mat &filter) {
    assert(filter.rows % 2 == 1);
    assert(filter.cols % 2 == 1);

    int width = filter.rows/2;
    int height = filter.cols/2;

    cv::Mat filteredImage(image.rows, image.cols, CV_32FC1, cv::Scalar(0));
    
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
                }
            }
            
            filteredImage.at<float>(i, j) = value;
        }
    }
    
    return filteredImage;
}

/** \brief Compute canny edges whenever the threshold is updated. */
void canny_edges(int, void*) {
    
    for (int j = 0; j < grad.cols; j++) {
        for (int i = 0; i < grad.rows; i++) {
            
            canny.at<float>(i, j) = 0;
            if (grad.at<float>(i, j) > threshold) {
                int i_step = 0;
                int j_step = 1;
                
                if (std::abs(orientation.at<float>(i, j)) < M_PI/8) {
                    // Nothing changes
                }
                else if (std::abs(orientation.at<float>(i, j)) >= M_PI/8
                        && std::abs(orientation.at<float>(i, j)) < 3*M_PI/8) {
                    
                    i_step = 1;
                    j_step = 1;
                }
                else if (std::abs(orientation.at<float>(i, j)) >= 3*M_PI/8) {
                    i_step = 1;
                    j_step = 0;
                }
                
                if (i - i_step >= 0 && i - i_step < grad.rows 
                        && j - j_step >= 0 && j - j_step < grad.cols
                        && grad.at<float>(i, j) <= grad.at<float>(i - i_step, j - j_step)) {
                    
                    continue;
                }
                
                if (i + i_step >= 0 && i + i_step < grad.rows 
                        && j + j_step >= 0 && j + j_step < grad.cols
                        && grad.at<float>(i, j) <= grad.at<float>(i + i_step, j + j_step)) {
                    
                    continue;
                }
                
                canny.at<float>(i, j) = 255;
            }
        }
    }
    
    cv::imshow(window_name, canny);
}

/** \brief Apply simple Canny edges on the given image.
 * Usage: ./simple_canny_cli path/to/image
 * \param[in] argc
 * \param[in] argv
 * \return status
 */
int main(int argc, char** argv) {
    
    int filter = 1;
    int size = 2;
    int height = 2*size + 1;
    int width = 2*size + 1;
    
    float variance = 2.5;
    
    cv::Mat image = cv::imread(argv[1]);
    cv::cvtColor(image, image, CV_BGR2GRAY);

    cv::Mat gaussian_derivative_x(height, width, CV_32FC1, cv::Scalar(0));
    cv::Mat gaussian_derivative_y(height, width, CV_32FC1, cv::Scalar(0));
    
    float normalization_x = 0;
    float normalization_y = 0;
    for (int j = 0; j < width; j++) {
        for (int i = 0; i < height; i++) {
            int jj = j - size;
            int ii = i - size;
            
            gaussian_derivative_x.at<float>(i, j) = std::exp(- (ii*ii + jj*jj)/(2*variance*variance))
                    * (- ii/(variance*variance));
            normalization_x += std::abs(gaussian_derivative_x.at<float>(i, j));
            
            gaussian_derivative_y.at<float>(i, j) = std::exp(- (ii*ii + jj*jj)/(2*variance*variance))
                    * (- jj/(variance*variance));
            normalization_y += std::abs(gaussian_derivative_y.at<float>(i, j));
        }
    }
    
    cv::Mat sobel_x(3, 3, CV_32FC1, cv::Scalar(0));
    sobel_x.at<float>(0, 0) = -1/8.f;
    sobel_x.at<float>(1, 0) = -2/8.f;
    sobel_x.at<float>(2, 0) = -1/8.f;
    sobel_x.at<float>(0, 2) = 1/2.f;
    sobel_x.at<float>(1, 2) = 2/8.f;
    sobel_x.at<float>(2, 2) = 1/8.f;
    
    gaussian_derivative_x /= normalization_x;
    gaussian_derivative_y /= normalization_y;
    
    cv::Mat grad_x = correlate(image, -gaussian_derivative_x);
    cv::Mat grad_y = correlate(image, -gaussian_derivative_y);
    
    canny.create(image.rows, image.cols, CV_32FC1);
    grad.create(image.rows, image.cols, CV_32FC1);
    orientation.create(image.rows, image.cols, CV_32FC1);
    
    for (int j = 0; j < grad_x.cols; j++) {
        for (int i = 0; i < grad_x.rows; i++) {
            grad.at<float>(i, j) = std::sqrt(grad_x.at<float>(i, j)*grad_x.at<float>(i, j)
                    + grad_y.at<float>(i, j)*grad_y.at<float>(i, j));
            orientation.at<float>(i, j) = std::atan(grad_x.at<float>(i, j)/grad_y.at<float>(i, j));
        }
    }
    
    cv::namedWindow(window_name, CV_WINDOW_AUTOSIZE);
    cv::createTrackbar("Min Threshold:", window_name, &threshold, max_threshold, canny_edges);
    canny_edges(0, 0);
    cv::waitKey(0);
    
    return 0;
}
