img = rgb2gray(imread('lena_std.tif'));
equalized_img = equalize_histogram(img);

figure;
subplot(3, 2, 1);
title('Image');
imshow(img);
subplot(3, 2, 2);
title('[Equalized] Image');
imshow(equalized_img);
imwrite(equalized_img, 'lena_equalized.tif');

histogram = auto_histogram(img, 255);
subplot(3, 2, 3);
title('Histogram');
bar(histogram);
subplot(3, 2, 4);
title('Cumulative Histogram');
bar(cumsum(histogram));

equalized_histogram = auto_histogram(equalized_img, 255);
subplot(3, 2, 5);
title('[Equalized] Cumulative Histogram');
bar(equalized_histogram);
subplot(3, 2, 6);
title('[Equalized] Cumulative Histogram');
bar(cumsum(equalized_histogram));
