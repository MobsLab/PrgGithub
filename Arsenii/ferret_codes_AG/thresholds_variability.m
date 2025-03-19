function thresholds_variability(datapath)
    %% Parameters
    datapath = cd;
    ferret = 'Brynza'; % 'Labneh'
    
    %% Initialize sets for storing gamma_thresh and thresh_01_05 values
    gamma_thresh_set = {[], []};  % 1st column: freely_moving, 2nd column: head_fixed
    thresh_01_05_set = {[], []};  % 1st column: freely_moving, 2nd column: head_fixed
    marker_types = {[], []};  % 1st column: freely_moving, 2nd column: head_fixed

    % Get a list of all StateEpochSB.mat files in the directory and subdirectories
    filelist = dir(fullfile(datapath, '**', 'StateEpochSB.mat'));

    % Loop through each found file
    for i = 1:length(filelist)
        foldername = filelist(i).folder;
        filename = fullfile(foldername, filelist(i).name);

        % Determine if it's a freely_moving or head_fixed folder
        if contains(foldername, 'freely-moving')
            folder_type = 1;  % Freely-moving
        elseif contains(foldername, 'head-fixed')
            folder_type = 2;  % Head-fixed
        else
            % Skip folders that don't match either type
            fprintf("Skipping folder: %s\n", foldername);
            continue;
        end

        % Determine the marker type based on folder name
        if contains(foldername, 'atropine')
            marker_type = 'o';  % Circle
        elseif contains(foldername, 'saline')
            marker_type = '^';  % Triangle
        elseif contains(foldername, 'fluoxetine')
            marker_type = 'x';  % Cross
        elseif contains(foldername, 'domitor')
            marker_type = '*';  % Star
        else
            marker_type = 's';  % Square
        end

        try
            % Load the file
            data = load(filename, 'gamma_thresh', 'thresh_01_05');
            
            % Store 'gamma_thresh' if found
            if isfield(data, 'gamma_thresh')
                gamma_thresh_set{folder_type} = [gamma_thresh_set{folder_type}, data.gamma_thresh];
                marker_types{folder_type} = [marker_types{folder_type}, marker_type];
            else
                fprintf("Can't find 'gamma_thresh' in %s\n", foldername);
            end

            % Store 'thresh_01_05' if found
            if isfield(data, 'thresh_01_05')
                thresh_01_05_set{folder_type} = [thresh_01_05_set{folder_type}, data.thresh_01_05];
                if isempty(marker_types{folder_type}) || ~strcmp(marker_types{folder_type}(end), marker_type)
                    marker_types{folder_type} = [marker_types{folder_type}, marker_type];
                end
            else
                fprintf("Can't find 'thresh_01_05' in %s\n", foldername);
            end

        catch ME
            % Handle file loading errors
            fprintf("Error loading file %s: %s\n", filename, ME.message);
        end
    end

    %% Plot 1: Trend Plot (X and Y axes swapped back, log scale maintained)
    figure;
    sgtitle([ferret], 'FontSize', 20, 'FontWeight', 'bold')

    % Plot Gamma Thresh Distribution (Freely-moving and Head-fixed)
    subplot(1, 2, 1);
    hold on;
    for j = 1:length(gamma_thresh_set{1})
        plot(log(gamma_thresh_set{1}(j)), j, ['b' '-' marker_types{1}(j)]);
    end
    for j = 1:length(gamma_thresh_set{2})
        plot(log(gamma_thresh_set{2}(j)), j, ['r' '-' marker_types{2}(j)]);
    end
    plot(log(gamma_thresh_set{1}), 1:length(gamma_thresh_set{1}), 'b-', 'LineWidth', 1); % Connect freely-moving points
    plot(log(gamma_thresh_set{2}), 1:length(gamma_thresh_set{2}), 'r-', 'LineWidth', 1); % Connect head-fixed points
    title('Gamma power threshold across sessions');
    xlabel('Gamma power (log scale)');
    ylabel('Session count');
    xlim([4 7])
    ylim([1 length(gamma_thresh_set{1})])
    hold off;

    % Plot Thresh 01-05 Distribution (Freely-moving and Head-fixed)
    subplot(1, 2, 2);
    hold on;
    for j = 1:length(thresh_01_05_set{1})
        plot(log(thresh_01_05_set{1}(j)), j, ['b' '-' marker_types{1}(j)]);
    end
    for j = 1:length(thresh_01_05_set{2})
        plot(log(thresh_01_05_set{2}(j)), j, ['r' '-' marker_types{2}(j)]);
    end
    plot(log(thresh_01_05_set{1}), 1:length(thresh_01_05_set{1}), 'b-', 'LineWidth', 1); % Connect freely-moving points
    plot(log(thresh_01_05_set{2}), 1:length(thresh_01_05_set{2}), 'r-', 'LineWidth', 1); % Connect head-fixed points
    
    title('0.1-0.5Hz power threshold across sessions');
    xlabel('0.1-0.5Hz power (log scale)');
    ylabel('Session count');
    xlim([2 7])
    ylim([1 length(gamma_thresh_set{1})])
    hold off;

    %% Display summary of how many values were loaded
    fprintf('Loaded %d gamma_thresh values for freely-moving and %d for head-fixed.\n', ...
        length(gamma_thresh_set{1}), length(gamma_thresh_set{2}));
    fprintf('Loaded %d thresh_01_05 values for freely-moving and %d for head-fixed.\n', ...
        length(thresh_01_05_set{1}), length(thresh_01_05_set{2}));

    %% Calculate and display statistics
    gamma_mean_fm = mean(log(gamma_thresh_set{1}));
    gamma_std_fm = std(log(gamma_thresh_set{1}));
    gamma_mean_hf = mean(log(gamma_thresh_set{2}));
    gamma_std_hf = std(log(gamma_thresh_set{2}));

    thresh_mean_fm = mean(log(thresh_01_05_set{1}));
    thresh_std_fm = std(log(thresh_01_05_set{1}));
    thresh_mean_hf = mean(log(thresh_01_05_set{2}));
    thresh_std_hf = std(log(thresh_01_05_set{2}));

    fprintf('Gamma Thresh Freely-moving: Mean = %.4f, STD = %.4f\n', gamma_mean_fm, gamma_std_fm);
    fprintf('Gamma Thresh Head-fixed: Mean = %.4f, STD = %.4f\n', gamma_mean_hf, gamma_std_hf);
    fprintf('Thresh 01-05 Freely-moving: Mean = %.4f, STD = %.4f\n', thresh_mean_fm, thresh_std_fm);
    fprintf('Thresh 01-05 Head-fixed: Mean = %.4f, STD = %.4f\n', thresh_mean_hf, thresh_std_hf);
end