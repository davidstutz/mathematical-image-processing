function [x, j_t] = gradient_descent(noisy_x, j, j_derivative, lambda, epsilon, beta)
% Gradient descent for denoising where noisy_x is the noisy input signal.
%
% DIMENSIONS
% N:            - length of signal
% T:            - maximum number of iterations
%
% PARAMETERS
% noisy_x:      - [Nx1] noisy signal
% j:            - function handle expecting 4 parameters: [Nx1] signal,
%                 [Nx1] original signal, [1] regularization parameter,
%                 [1] approximation parameter; and returning [1] value
% j_derivative: - function handle of the derivative of j expecting the
%                 same parameters and returning the gradient
% lambda:       - [1] regularization parameter
% epsilon:      - [1] approximation parameter
% beta:         - [1] armijo rule parameter
%
% RETURN
% x:            - [Nx1] denoised signal
% j_t:          - [Tx1] function values over iterations
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%

    n = size(noisy_x, 1);
    x_k = zeros(n, 1);
    % x_k = rand(n, 1);

    max_iterations = 100;
    threshold = 0;
    
    j_t = zeros(max_iterations, 1);
    for t = 1: max_iterations
        j_t(t, 1) = j(x_k, noisy_x, lambda, epsilon);

        if norm(j_derivative(x_k, noisy_x, lambda, epsilon)) < threshold
            break;
        end;
        
        direction = - j_derivative(x_k, noisy_x, lambda, epsilon);

        tau = 0.00001;
        tau = armijo_rule(noisy_x, x_k, j, direction, lambda, epsilon, beta);
        
        x_k = x_k + tau*direction;
    end;

    x = x_k;
end

function [tau] = armijo_rule(noisy_x, x_k, j, direction, lambda, epsilon, beta)
    
    tau = 1;
    condition = amoji_condition(noisy_x, x_k, j, direction, lambda, epsilon, tau);
    
    if condition > 0
        while condition > 0 && tau > 0
            tau = tau/beta;
            condition = amoji_condition(noisy_x, x_k, j, direction, lambda, epsilon, tau);
        end;
        tau = beta*tau;
    else
        while condition <= 0 && tau > 0
            tau = tau*beta;
            condition = amoji_condition(noisy_x, x_k, j, direction, lambda, epsilon, tau);
        end;
    end;
end

function [fulfilled] = amoji_condition(noisy_x, x_k, j, direction, lambda, epsilon, tau)
    value = (j(x_k + tau*direction, noisy_x, lambda, epsilon) - j(x_k, noisy_x, lambda, epsilon))/(tau*direction'*(-direction));

    sigma = 0.5;
    if value > sigma
        fulfilled = 1;
    else
        fulfilled = 0;
    end;
end