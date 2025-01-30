

function [meanHeartRatesInBins , binCenters , Dur_in_bin] = HeartRateVsSpeed_Curve_BM(speed, heartRate)
% Function to plot heart rate as a function of speed, compute mean heart rate for each unique speed,
% and compute average speed in bins.
% Input:
%   speed - A vector of speed values (e.g., m/s or km/h).
%   heartRate - A vector of corresponding heart rate values (e.g., bpm).

plot_fig = 0;

speed = Data(Restrict(speed,heartRate));
heartRate = Data(heartRate);

% Validate input sizes
if length(speed) ~= length(heartRate)
    error('Speed and heart rate vectors must be of the same length.');
end

% Define bins for speed (from 0 to 25 with 50 bins)
minSpeed = 0;
maxSpeed = 25;
numBins = 50;
edges = linspace(minSpeed, maxSpeed, numBins + 1);

% Compute average speed and mean heart rate in each bin
binCenters = (edges(1:end-1) + edges(2:end)) / 2;
meanHeartRatesInBins = zeros(1, numBins);
averageSpeedsInBins = zeros(1, numBins);

for i = 1:numBins
    inBin = speed >= edges(i) & speed < edges(i + 1);
    if any(inBin) % Avoid empty bins
        meanHeartRatesInBins(i) = mean(heartRate(inBin));
        averageSpeedsInBins(i) = mean(speed(inBin));
        Dur_in_bin(i) = sum(inBin);
    else
        meanHeartRatesInBins(i) = NaN; % Handle empty bins
        averageSpeedsInBins(i) = NaN;
        Dur_in_bin(i) = NaN;
    end
end
Dur_in_bin=Dur_in_bin./nansum(Dur_in_bin);

% Display results
%     fprintf('Average speed and mean heart rate in each bin (0 to 25 in 50 bins):\n');
%     for i = 1:numBins
%         fprintf('Bin %d (%.2f to %.2f): Average Speed = %.2f, Mean Heart Rate = %.2f bpm\n', ...
%             i, edges(i), edges(i + 1), averageSpeedsInBins(i), meanHeartRatesInBins(i));
%     end

if plot_fig
    % Plot the heart rate vs speed curve
    figure;
    plot(speed, heartRate, '-o', 'LineWidth', 2, 'MarkerSize', 6);
    hold on;
    plot(binCenters, meanHeartRatesInBins, 's-', 'LineWidth', 2, 'MarkerSize', 8, 'Color', 'r'); % Mean heart rates in bins
    grid on;
    
    % Add labels and title
    xlabel('Speed (e.g., m/s or km/h)', 'FontSize', 12);
    ylabel('Heart Rate (bpm)', 'FontSize', 12);
    title('Heart Rate as a Function of Speed (Binned: 0 to 25)', 'FontSize', 14);
    legend('Original Data', 'Mean Heart Rates in Bins', 'Location', 'Best');
    
    % Customize axis
    xlim([minSpeed, maxSpeed]);
    ylim([min(heartRate) - 0.1*range(heartRate), max(heartRate) + 0.1*range(heartRate)]);
    
    % Display the curve
    fprintf('Curve of heart rate as a function of speed with binned averages (0 to 25) has been plotted.\n');
end
end
