function [noisy_x] = signal_salt_pepper_noise(x, p)
% Adds salt and pepper noise with the given variance to the given signal.
%
% DIMENSIONS
% N:            - length of signal
%
% PARAMETERS
% x:            - [Nx1] signal
% variance:     - [1] probability of salt and pepper
%
% RETURN
% noisy_x:      - [Nx1] noisy image
%
% AUTHOR
% David Stutz (david.stutz@rwth-aachen.de)
%

    noisy_x = x;
    n = size(x, 1);
    
    for i = 1: n
        r = rand(1, 1);
        
        if r <= p
            r = rand(1, 1);
            
            if r > 0.5
                noisy_x(i, 1) = 1;
            else
                noisy_x(i, 1) = 0;
            end;
        end;
    end;

end

