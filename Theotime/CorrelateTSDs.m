function [d1_common, d2_common, r, p] = CorrelateTSDs(tsd1, tsd2, varargin)

% Check if the user provided a 'plot' flag (default: false)
p = inputParser;
defaultplotFlag = false;
defaultoutliersFlag = false;
defaultrestrictFlag = false;
addOptional(p,'fig',defaultplotFlag);
addOptional(p,'filloutliers',defaultoutliersFlag);

addOptional(p, 'restrict', defaultrestrictFlag)

parse(p,varargin{:});
plotFlag = p.Results.fig;
restrict= p.Results.restrict;
rmoutliersFlag = p.Results.filloutliers;

if iscell(tsd1) & iscell(tsd2)
    [d1_common, d2_common, r, p] = CorrelateAllTSDs(tsd1, tsd2, varargin{:});
    return
end


% disp(p.Results)


% tsd1= V ;
% tsd2 = Restrict(LossPredTsd, BadEpoch);
if ~strcmp(class(restrict),'logical')
    disp(['restricting tsd'])
    tsd1 = Restrict(tsd1, restrict);
    tsd2 = Restrict(tsd2, restrict);
end

[common_time, d1_common d2_common] = PrepareTsds(tsd1,tsd2)

if rmoutliersFlag
    disp('all')
    d1_common = filloutliers(d1_common, "previous");
    d2_common = filloutliers(d2_common, "previous");
end

if strcmp(rmoutliersFlag, 'd1')
    disp('1')
    d1_common = filloutliers(d1_common, "previous");
end

if strcmp(rmoutliersFlag, 'd2')
    disp('2')
    d2_common = filloutliers(d2_common, "previous");
end

% Compute correlation coefficient
[r, p] = corr(d1_common, d2_common);
disp(['Correlation Coefficient (R): ', num2str(r)]);
disp(['p-value: ', num2str(p)]);

% Fit linear regression model
p_fit = polyfit(d1_common, d2_common, 1); % Linear fit (y = mx + b)
fit_line = polyval(p_fit, d1_common);

% Compute standard error of the regression
y_pred = polyval(p_fit, d1_common);
residuals = d2_common - y_pred; % Difference between actual and predicted values
SE = std(residuals) / sqrt(length(d1_common)); % Standard Error
disp(['Standard Error (SE): ', num2str(SE)]);

if plotFlag
    figure;
    scatter(d1_common, d2_common, 'b', 'filled'); % Scatter plot
    hold on;
    plot(d1_common, fit_line, 'r', 'LineWidth', 2); % Regression line
    
    % Compute Confidence Interval (±1.96*SE for 95% CI)
    ci_upper = fit_line + 1.96 * SE;
    ci_lower = fit_line - 1.96 * SE;
    
    % Plot Confidence Interval as a shaded area
    x_sorted = sort(d1_common);
    fill([x_sorted; flip(x_sorted)], [ci_upper; flip(ci_lower)], 'r', ...
        'FaceAlpha', 0.2, 'EdgeColor', 'none');
    
    % Labels and title
    xlabel('TSD1 Data');
    ylabel('TSD2 Data');
    title(['Correlation Between TSD Signals (R = ', num2str(r, '%.2f'), ', SE = ', num2str(SE, '%.2f'), ')']);
    
    % Display equation on plot
    eq_text = sprintf('y = %.2fx + %.2f', p_fit(1), p_fit(2));
    text(min(d1_common), max(d2_common), eq_text, 'FontSize', 12, 'Color', 'r');
    
    grid on;
    hold off;
end
end