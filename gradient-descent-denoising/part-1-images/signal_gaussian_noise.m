function [noisy_img] = signal_gaussian_noise(image, variance)
% Adds additive Gaussian noise with the given variance to the given signal.
%
% DIMENSIONS
% N:            - image height
% M:            - image width
% PARAMETERS
% x:            - [NxM] image
% variance:     - [1] variance of Gaussian noise
%
% RETURN
% noisy_x:      - [NxM] noisy image
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%

    noisy_img = image;
    [m, n, ~] = size(image);
    
    for i = 1: m
        for j = 1: n
            noisy_img(i, j) = image(i, j) + normrnd(0, variance, 1, 1);
        end;
    end;

end

