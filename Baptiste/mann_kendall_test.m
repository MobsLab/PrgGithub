

function [tau, p_value, trend] = mann_kendall_test(data, alpha)
    % Mann-Kendall Trend Test
    % data - time series data (assumed to be a column vector)
    % alpha - significance level (e.g., 0.05)
    % tau - Kendall's tau coefficient
    % p_value - significance of the trend
    % trend - 'increasing', 'decreasing', or 'no trend'
    
    n = length(data); 
    S = 0;  
    for i = 1:n-1
        for j = i+1:n
            S = S + sign(data(j) - data(i));
        end
    end

    % Calculate variance
    var_S = (n * (n - 1) * (2 * n + 5)) / 18; 
    
    % Compute Z-score
    if S > 0
        Z = (S - 1) / sqrt(var_S);
    elseif S < 0
        Z = (S + 1) / sqrt(var_S);
    else
        Z = 0;
    end

    % Compute p-value (two-tailed test)
    p_value = 2 * (1 - normcdf(abs(Z)));  

    % Compute Kendall's tau
    tau = S / ((n * (n - 1)) / 2);

    % Determine trend significance
    if p_value < alpha
        if tau > 0
            trend = 1;%'increasing';
        else
            trend = -1;%'decreasing';
        end
    else
        trend = 0;%'no trend';
    end

    % Display results
%     fprintf('Kendall’s tau: %.4f\n', tau);
%     fprintf('p-value: %.4f\n', p_value);
%     fprintf('Trend: %s\n', trend);
end











