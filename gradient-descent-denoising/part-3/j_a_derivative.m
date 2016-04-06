function [j] = j_a_derivative(x, noisy_x, lambda, epsilon)
% Derivative of irst functional for denoising: quadratic data term and quadratic
% regularizer.
%
% DIMENSIONS
% N:            - length of signal
%
% PARAMETERS
% x:            - [Nx1] signal
% noisy_x:      - [Nx1] original/reference signal
% lambda:       - [1] regularization parameter
% epsilon:      - [1] dummy parameter to be compatible with j_b
%
% RETURN
% j:            - [Nx1] function gradient
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%

    n = size(x, 1);
    h = 1/(n - 1);
	h = h*h;
    
    x_ip1 = circshift(x, -1);
    x_ip1(n, 1) = x(n, 1);

    x_im1 = circshift(x, 1);
    x_im1(1, 1) = x(1, 1);

    j = 2*(x - noisy_x) + lambda*1/h*(-2*(x_ip1 - x) + 2*(x -x_im1));
end

