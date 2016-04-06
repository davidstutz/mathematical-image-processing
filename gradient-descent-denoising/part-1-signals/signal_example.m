function [x] = signal_example(n)
% Creates a sample signal of given length.
%
% DIMENSIONS
% n:        - signal length
%
% PARAMETERS
% n:        - length of signal
%
% RETURN
% x:        - [nx1] signal
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%
    
    x = zeros(n, 1);
    
    edge = n/3.0;
    gradient_start = n/3.0;
    gradient_end = 2*n/3.0;
    slope = 1/(gradient_end - gradient_start);
    intercept = 1 - slope*gradient_end;
    
    for i = 1: n
        
        x(i, 1) = 0; % default!
        
        if i < edge
            x(i, 1) = 1;
        end;
        if i >= gradient_start && i <= gradient_end
            x(i, 1) = slope*i + intercept;
        end;
    end;
    
end

