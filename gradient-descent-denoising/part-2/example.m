% Variance of gaussian noise:
variance = 0.05;

% Regularization:
lambda = 0.05;

% Create example signal, noisy signal and denoise.
x = signal_example(100);
noisy_x = signal_gaussian_noise(x, variance);
denoised_x = j_a_solve(noisy_x, lambda);

% Plot:
figure;
subplot(1, 3, 1);
imagesc(x);
subplot(1, 3, 2);
imagesc(noisy_x);
subplot(1, 3, 3);
imagesc(denoised_x);