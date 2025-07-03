
function matrix_filled = interp2_nan(matrix_in, method)
%INTERP2_NAN Interpolates NaN values in a 2D matrix using griddata.
%   matrix_filled = INTERP2_NAN(matrix_in)
%   matrix_filled = INTERP2_NAN(matrix_in, method)
%
%   Inputs:
%       matrix_in - 2D matrix with NaN values to interpolate
%       method    - (optional) interpolation method: 'linear', 'nearest', 'natural'
%                   Default is 'linear'.
%
%   Output:
%       matrix_filled - matrix with NaNs filled by 2D interpolation

    if nargin < 2
        method = 'linear';
    end

    [nRows, nCols] = size(matrix_in);
    [X, Y] = meshgrid(1:nCols, 1:nRows);

    nan_mask = isnan(matrix_in);
    matrix_filled = matrix_in;

    if all(nan_mask(:))
        warning('Matrix contains only NaNs. Returning unchanged.');
        return;
    end

    matrix_filled(nan_mask) = griddata( ...
        X(~nan_mask), Y(~nan_mask), matrix_in(~nan_mask), ...
        X(nan_mask), Y(nan_mask), ...
        method);

end
