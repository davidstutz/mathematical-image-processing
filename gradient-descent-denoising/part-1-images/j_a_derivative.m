function [j] = j_a_derivative(x, noisy_x, lambda, epsilon)
% Derivative of first functional for denoising: quadratic data term and quadratic
% regularizer.
%
% DIMENSIONS
% N:            - image height
% M:            - image width
%
% PARAMETERS
% x:            - [NxM] image
% noisy_x:      - [NxM] original/reference image
% lambda:       - [1] regularization parameter
% epsilon:      - [1] dummy parameter to be compatible with j_b
%
% RETURN
% j:            - [Nx1] function gradient
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%

    if size(x) ~= size(noisy_x)
        error('Invalid dimensions!');
    end;

    [m, n, ~] = size(x);
    h = 1/(max(m, n) - 1);
	h = h*h;
    
    x_ip1 = circshift(x, -1);
    x_ip1(m, :) = x(m, :);

    x_im1 = circshift(x, 1);
    x_im1(1, :) = x(1, :);

    x_jp1 = circshift(x, -1, 2);
    x_jp1(:, n) = x(:, n);
    
    x_jm1 = circshift(x, 1, 2);
    x_jm1(:, 1) = x(:, 1);
    
    j = 2*(x - noisy_x) + lambda*1/h*(-2*(x_ip1 - x) + 2*(x - x_im1)) + lambda*1/h*(-2*(x_jp1 - x) + 2*(x - x_jm1));
end

