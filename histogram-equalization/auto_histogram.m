function [histogram] = auto_histogram(img, M)
% Creates an intensity histogram of img with equal bin sizes
%
% DIMENSIONS
% H             - Height of the image in pixels
% W             - Width of the image in pixels
%
% PARAMETERS
% img           - [HxW] uint8 image
% M             - [1] Number of bins
%
% RETURN
% histogram     - [Mx1] double Computed histogram
% 
% AUTHOR
% Tobias Pohlen (tobias.pohlen@rwth-aachen.de)
%

    bounds = create_img_bin_bounds(img, M);
    histogram = create_histogram(img, bounds);
end

function [bin_values] = create_img_bin_bounds(img, M )
% Creates the bin bounds for an uint8 image
% 
% PARAMETERS
% img           - [HxW] uint8 image
% M             - [1] Number of bins
% 
% RETURN
% bin_values    - [(M)x1] bin bounds
% 
% AUTHOR
% Tobias Pohlen (tobias.pohlen@rwth-aachen.de)
%

    bin_values = zeros(M,1);
    
    img_min = min(min(img));
    img_max = max(max(img));
    
    for i=1:M
        bin_values(i) = img_min + (i-1)/(M-1)*(img_max - img_min);
    end
end

function [histogram] = create_histogram(img, bin_values)
% Computes a gray value histogramm of img using the bin limits bin_values
% 
% DIMENSIONS
% H             - Height of the image in pixels
% W             - Width of the image in pixels
% M             - Number of bins
%
% PARAMETERS
% img           - [HxW] uint8 image
% bin_values    - [Mx1] uint8 bin bounds, sorted in ascending order
%
% RETURN
% histogram     - [Mx1] double Computed histogram
% 
% AUTHOR
% Tobias Pohlen (tobias.pohlen@rwth-aachen.de)
%

    % Get the bin map for efficient computation
    [bin_map, offset_min, offset_max] = create_bin_map(bin_values);
    
    % Create the histogram
    histogram = zeros(length(bin_values), 1);
    
    for v = offset_min:offset_max
        histogram(bin_map(v-offset_min+1)) = ...
            histogram(bin_map(v-offset_min+1)) + length(find(img == v));
    end
end

function [map, offset_min, offset_max] = create_bin_map(bin_values)
% Computes a look up table for the map: (value + 1)-> bin which is used in order
% to compute the histograms efficiently. We assume that the images have a
% value range of 0..255 (unsinged 8 bit)
% 
% DIMENSIONS
% M             - Number of bins + 1
%
% PARAMETERS
% bin_values    - [Kx1] uint8 bin bounds, sorted in ascending order
%
% RETURN
% map           - [255x1] value -> bin map
% offset_min    - [1] value of the lowest supported intensity
% offset_max    - [1] value of the highest supported intensity
% 
% AUTHOR
% Tobias Pohlen (tobias.pohlen@rwth-aachen.de)
%

    M_p_1 = size(bin_values, 1);
    offset_min = min(bin_values);
    offset_max = max(bin_values);
    
    % There must be at least 2 values and the max must be 255 and the min
    % must be 0
    if (M_p_1 < 2)
        error('Invalid 8bit bin segmentation.');
    end
    
    % Discretize the mapping value -> bin in order to quickly assign a gray
    % value to its corresponding bin
    % Since img is uint8, the value range ist 0..255
    map = zeros(offset_min - offset_max, 1);
    
    for v=offset_min:offset_max
        % Find the corresponding bin
        map(v-offset_min+1) = find(bin_values <= v, 1, 'last');
    end
end