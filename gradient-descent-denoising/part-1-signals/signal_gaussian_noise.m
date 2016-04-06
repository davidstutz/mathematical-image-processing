function [noisy_x] = signal_gaussian_noise(x, variance)
% Adds additive Gaussian noise with the given variance to the given signal.
%
% DIMENSIONS
% N:            - signal length
%
% PARAMETERS
% x:            - [Nx1] signal
% variance:     - [1] variance of Gaussian noise
%
% RETURN
% noisy_x:      - [Nx1] noisy signal
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%

    noisy_x = x;
    n = size(x, 1);
    
    for i = 1: n
        noisy_x(i, 1) = x(i, 1) + normrnd(0, variance, 1, 1);
    end;

end

