function [j] = j_b_derivative(x, noisy_x, lambda, epsilon)
% Derivative of second functional for denoising: quadratic data term and
% epsilon-regularized absolute regularizer.
%
% DIMENSIONS
% N:            - image height
% M:            - image width
%
% PARAMETERS
% x:            - [NxM] image
% noisy_x:      - [NxM] original/reference image
% lambda:       - [1] regularization parameter
% epsilon:      - [1] regularization for absolute term
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
    
    x_ip1 = circshift(x, -1);
    x_ip1(m, :) = x(m, :);
    x_ip1_z = x_ip1;
    x_ip1_z(m, :) = x(m, :) + 1;

    x_im1 = circshift(x, 1);
    x_im1(1, :) = x(1, :);
    x_im1_z = x_im1;
    x_im1_z(1, :) = x(1, :) - 1;
    
    x_jp1 = circshift(x, -1, 2);
    x_jp1(:, n) = x(:, n);
    x_jp1_z = x_jp1;
    x_jp1_z(:, n) = x(:, n) + 1;

    x_jm1 = circshift(x, 1, 2);
    x_jm1(:, 1) = x(:, 1);
    x_jm1_z = x_jm1;
    x_jm1_z(:, 1) = x(:, 1) - 1;
    
    eps = repmat(epsilon, m, n);
    j = 2*(x - noisy_x) + lambda*1/h*(- (1./sqrt((x_ip1 - x).^2 + eps.^2)).*(x_ip1 - x) + (1./sqrt((x - x_im1).^2 + eps.^2)).*(x - x_im1)) ...
            + lambda*1/h*(- (1./sqrt((x_jp1 - x).^2 + eps.^2)).*(x_jp1 - x) + (1./sqrt((x - x_jm1).^2 + eps.^2)).*(x - x_jm1));

end

