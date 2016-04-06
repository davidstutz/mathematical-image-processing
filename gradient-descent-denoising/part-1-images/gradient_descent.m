function [x, j_t] = gradient_descent(noisy_x, j, j_derivative, lambda, epsilon, beta)
% Gradient descent for denoising where noisy_x is the noisy input signal.
%
% DIMENSIONS
% N:            - image height
% M:            - image width
% T:            - maximum number of iterations
%
% PARAMETERS
% noisy_x:      - [NxM] noisy image
% j:            - function handle expecting 4 parameters: [NxM] image,
%                 [NxM] original image, [1] regularization parameter,
%                 [1] approximation parameter; and returning [1] value
% j_derivative: - function handle of the derivative of j expecting the
%                 same parameters and returning the gradient
% lambda:       - [1] regularization parameter
% epsilon:      - [1] approximation parameter
% beta:         - [1] armijo rule parameter
%
% RETURN
% x:            - [NxM] denoised image
% j_t:          - [Tx1] function values over iterations
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%

    [m, n, ~] = size(noisy_x);
    x_k = zeros(m, n);
    %x_k = rand(m, n)./10;

    max_iterations = 25;
    
    j_t = zeros(max_iterations, 1);
    for t = 1: max_iterations
        j_t(t, 1) = j(x_k, noisy_x, lambda, epsilon);
        
        direction = - j_derivative(x_k, noisy_x, lambda, epsilon);

        %tau = 0.00000000001;
        tau = amoji_rule(noisy_x, x_k, j, direction, lambda, epsilon, beta);
        
        x_k = x_k + tau*direction;
    end;

    x = x_k;
end

function [tau] = amoji_rule(noisy_x, x_k, j, denom, lambda, epsilon, beta)
    
    tau = 1;
    condition = amoji_condition(noisy_x, x_k, j, denom, lambda, epsilon, tau);
    
    if condition > 0
        while condition > 0 && tau > 0
            tau = tau/beta;
            condition = amoji_condition(noisy_x, x_k, j, denom, lambda, epsilon, tau);
        end;
        tau = beta*tau;
    else
        while condition <= 0 && tau > 0
            tau = tau*beta;
            condition = amoji_condition(noisy_x, x_k, j, denom, lambda, epsilon, tau);
        end;
    end;
end

function [fulfilled] = amoji_condition(noisy_x, x_k, j, denom, lambda, epsilon, tau)
    value = (j(x_k + tau*denom, noisy_x, lambda, epsilon) - j(x_k, noisy_x, lambda, epsilon))/(tau*sum(sum(denom.*(-denom))));

    sigma = 0.5;
    if value > sigma
        fulfilled = 1;
    else
        fulfilled = 0;
    end;
end