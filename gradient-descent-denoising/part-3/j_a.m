function [j] = j_a(x, noisy_x, lambda, epsilon)
% First functional for denoising: quadratic data term and quadratic
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
% j:            - [1] function value
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%

    n = size(x, 1);
    h = 1/(n - 1);
	h = h*h;
    
    x_ip1 = circshift(x, -1);
    x_ip1(n, 1) = x(n, 1);

    j = sum((x - noisy_x).^2) + lambda*1/h*sum((x_ip1 - x).^2);
end

