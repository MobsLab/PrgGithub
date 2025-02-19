function zscore_moving = moving_zscore(data, window_size)
    % MOVING_ZSCORE Computes the Z-score with a moving window.
    % 
    % INPUTS:
    %   data - 1D array of numerical values (time series)
    %   window_size - Size of the moving window
    %
    % OUTPUT:
    %   zscore_moving - Array of Z-scores computed within the moving window
    
    % Ensure data is a column vector
    data = data(:);  
    N = length(data);
    
    % Initialize output with NaN values
    zscore_moving = NaN(N, 1); 
    
    % Compute moving Z-score
    for i = 1:N - window_size + 1
        window_data = data(i:i + window_size - 1); % Extract window
        mean_window = mean(window_data); % Compute mean of window
        std_window = std(window_data); % Compute standard deviation of window
        
        if std_window > 0
            % Assign the Z-score to the center of the window
            zscore_moving(i + floor(window_size/2)) = ...
                (data(i + floor(window_size/2)) - mean_window) / std_window;
        end
    end
end
