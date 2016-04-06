function [j] = j_b_derivative(x, noisy_x, lambda, epsilon)
% Derivative of second functional for denoising: quadratic data term and
% epsilon-regularized absolute regularizer.
%
% DIMENSIONS
% N:            - length of signal
%
% PARAMETERS
% x:            - [Nx1] signal
% noisy_x:      - [Nx1] original/reference signal
% lambda:       - [1] regularization parameter
% epsilon:      - [1] regularization for absolute term
%
% RETURN
% j:            - [Nx1] function gradient
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%

    n = size(x, 1);
    h = 1/(n - 1);
    
    x_ip1 = circshift(x, -1);
    x_ip1(n, 1) = x(n, 1);
    x_ip1_z = x_ip1;
    x_ip1_z(n, 1) = x(n, 1) + 1;

    x_im1 = circshift(x, 1);
    x_im1(1, 1) = x(1, 1);
    x_im1_z = x_im1;
    x_im1_z(1, 1) = x(1, 1) - 1;

    eps = repmat(epsilon, n, 1);
    j = 2*(x - noisy_x) + lambda*1/h*(- (1./sqrt((x_ip1_z - x).^2 + eps.^2)).*(x_ip1 - x) + (1./sqrt((x - x_im1_z).^2 + eps.^2)).*(x - x_im1));

end

