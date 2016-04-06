function [A] = setup_scalar_product(n, lambda)

    A = zeros(n, n);
    h = 1/(n - 1);
    h = h*h;
    
    for i = 1: n
        
        if i > 1 && i < n
            A(i, i) = lambda*4/h + 2;
        else
            A(i, i) = lambda*2/h + 2;
        end;
        
        if i > 1
            A(i, i - 1) = - lambda*2/h;
        end;

        if i < n
            A(i, i + 1) = - lambda*2/h;
        end;
    end;
end

