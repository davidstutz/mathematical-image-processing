% Variance of gaussian noise:
variance = 0.1;

% Regularization:
lambda = 0.05;
eps = 0.0005;

% Amoji Rule:
beta = 0.5;

% Create example signal, noisy signal and denoise.
x = double(imread('lenaTest3.jpg'))./255;
noisy_x = signal_gaussian_noise(x, variance);
[denoised_x, j_t] = gradient_descent(noisy_x, @j_a, @j_a_derivative, lambda, eps, beta);
denoised_x = denoised_x ./ max(max(denoised_x));
[denoised_x_eps, j_t_eps] = gradient_descent(noisy_x, @j_b, @j_b_derivative, lambda, eps, beta);
denoised_x_eps = denoised_x_eps ./ max(max(denoised_x_eps));

% Plot:
figure;
subplot(3, 2, 1);
imshow(x);
subplot(3, 2, 2);
imshow(noisy_x);
subplot(3, 2, 3);
imshow(denoised_x);
subplot(3, 2, 4);
plot(j_t);
subplot(3, 2, 5);
imshow(denoised_x_eps);
subplot(3, 2, 6);
plot(j_t_eps);