function [j] = j_b(x, noisy_x, lambda, epsilon)
% Second functional for denoising: quadratic data term and
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
% j:            - [1] function value
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%

    n = size(x, 1);
    h = 1/(n - 1);
    
    x_ip1 = circshift(x, -1);
    x_ip1(n, 1) = x(n, 1);

    j = sum((x - noisy_x).^2) + lambda*1/h*sum(norm_epsilon(x_ip1 - x, epsilon));
end

function [y] = norm_epsilon(x, epsilon)
    y = sqrt(x.*x + epsilon*epsilon);
end
