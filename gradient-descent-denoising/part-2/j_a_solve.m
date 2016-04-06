function [x] = j_a_solve(noisy_x, lambda)
% Setup A and b to solve J_a via a linear system.
%
% DIMENSIONS
% N:            - length of signal
%
% PARAMETERS
% noisy_x:      - [Nx1] noisy signal
% lambda:       - [1] regularization parameter
%
% RETURN
% A:            - [NxN] matrix
% b:            - [Nx1] right hand side
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%

    n = size(noisy_x, 1);
    h = 1/(n - 1);
    h = h*h;
    
    A = zeros(n, n);
    b = zeros(n, 1);
    
    for i = 1: n
        b(i, 1) = noisy_x(i, 1);
        
        if i > 1 && i < n
            A(i, i) = lambda*2/h + 1;
        else
            A(i, i) = lambda/h + 1;
        end;
        
        if i > 1
            A(i, i - 1) = - lambda/h;
        end;

        if i < n
            A(i, i + 1) = - lambda/h;
        end;
    end;
    
    x = A\b;
end

