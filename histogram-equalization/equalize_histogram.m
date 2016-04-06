function [new_img] = equalize_histogram(img)
% Perform a histogram equalization for the image img
% 
% DIMENSIONS
% H             - Height of the image in pixels
% W             - Width of the image in pixels
%
% PARAMETERS
% new_img       - [HxW] uint8 image
%
% RETURN
% img           - [HxW] equalized image
% 
% AUTHOR
% Tobias Pohlen (tobias.pohlen@rwth-aachen.de)
%

    [H, W] = size(img);
    img = uint8(normalize_image(img) * 255);
    img1D = reshape(img, H*W, 1);
    
    % Get the inverse volume of omega
    inv_vol_omega = 1/double(H*W);
    
    new_img = img;
    
    % Perform the transformation
    for v=0:255
        new_img(img == v) = round(inv_vol_omega * length(find(img1D <= v)) * 255);
    end
end

function [img] = normalize_image(img)
% Returns a normalized discrete image
% 
% DIMENSIONS
% H             - Height of the image in pixels
% W             - Width of the image in pixels
%
% PARAMETERS
% img           - [HxW] uint8 image
%
% RETURN
% img           - [HxW] uint8 image
% 
% AUTHOR
% Tobias Pohlen (tobias.pohlen@rwth-aachen.de)
%

    img = double(img);
    
    img_min = min(min(img));
    img_max = max(max(img));
    
    img = clip_image((img - img_min)/(img_max - img_min), 0, 1);
end

function [img] = clip_image(img, a, b)
% Clips an image and returns a double image in [0,1]
% 
% DIMENSIONS
% H             - Height of the image in pixels
% W             - Width of the image in pixels
%
% PARAMETERS
% img           - [HxW] uint8 image
% a             - [1] lower bound
% b             - [1] upper bound
%
% RETURN
% img           - [HxW] double image
% 
% AUTHOR
% Tobias Pohlen (tobias.pohlen@rwth-aachen.de) [308743]
%

    img(img < a) = a;
    img(img > b) = b;
end

