function [all_data1, all_data2, r, p] = CorrelateAllTSDs(struct_cell1, struct_cell2, varargin)

[all_data1, all_data2] = MergeTsdFromCells(struct_cell1, struct_cell2);

p = inputParser;
defaultplotFlag = false;
defaultoutliersFlag = false;
defaultrestrictFlag = false;
addOptional(p,'fig',defaultplotFlag);
addOptional(p,'rmoutliers',defaultoutliersFlag);

addOptional(p, 'restrict', defaultrestrictFlag);

parse(p,varargin{:});
plotFlag = p.Results.fig;
restrict= p.Results.restrict;
rmoutliersFlag = p.Results.rmoutliers;

if rmoutliersFlag
    disp('all')
    all_data1 = filloutliers(all_data1, "nearest");
    all_data2 = filloutliers(all_data2, "nearest");
end

if strcmp(rmoutliersFlag, 'd1')
    disp('1')
    all_data1 = filloutliers(all_data1, "nearest");
end

if strcmp(rmoutliersFlag, 'd2')
    disp('2')
    all_data2 = filloutliers(all_data2, "nearest");
end


[r, p] = corr(all_data1, all_data2);
disp(['Correlation Coefficient (R): ', num2str(r)]);
disp(['p-value: ', num2str(p)]);

% Fit linear regression model
p_fit = polyfit(all_data1, all_data2, 1); % Linear fit (y = mx + b)
fit_line = polyval(p_fit, all_data1);

% Compute standard error of the regression
y_pred = polyval(p_fit, all_data1);
residuals = all_data2 - y_pred; % Difference between actual and predicted values
SE = std(residuals) / sqrt(length(all_data1)); % Standard Error
disp(['Standard Error (SE): ', num2str(SE)]);


if plotFlag
    figure;
    scatter(all_data1, all_data2, 'b', 'filled'); % Scatter plot
    hold on;
    plot(all_data1, fit_line, 'r', 'LineWidth', 2); % Regression line
    
    % Compute Confidence Interval (±1.96*SE for 95% CI)
    ci_upper = fit_line + 1.96 * SE;
    ci_lower = fit_line - 1.96 * SE;
    
    % Plot Confidence Interval as a shaded area
    x_sorted = sort(all_data1);
    fill([x_sorted; flip(x_sorted)], [ci_upper; flip(ci_lower)], 'r', ...
        'FaceAlpha', 0.2, 'EdgeColor', 'none');
    
    % Labels and title
    xlabel('TSD1 Data','FontSize',30);
    ylabel('TSD2 Data','FontSize',30);
    title(['Correlation Between TSD Signals (R = ', num2str(r, '%.2f'), ', SE = ', num2str(SE, '%.2f'), ')']);
    
    % Display equation on plot
    eq_text = sprintf('y = %.2fx + %.2f', p_fit(1), p_fit(2));
    text(min(all_data1), max(all_data2), eq_text, 'FontSize', 12, 'Color', 'r');
    
    grid on;
    hold off;
end
end