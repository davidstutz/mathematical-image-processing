function [j] = j_b(x, noisy_x, lambda, epsilon)
% Second functional for denoising: quadratic data term and
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
% j:            - [1] function value
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

    x_jp1 = circshift(x, -1, 2);
    x_jp1(:, n) = x(:, n);
    
    j = sum(sum((x - noisy_x).^2)) + lambda*1/h*sum(sum(norm_epsilon(x_ip1 - x, epsilon))) + lambda*1/h*sum(sum(norm_epsilon(x_jp1 - x, epsilon)));
end

function [y] = norm_epsilon(x, epsilon)
    y = sqrt(x.*x + epsilon*epsilon);
end
