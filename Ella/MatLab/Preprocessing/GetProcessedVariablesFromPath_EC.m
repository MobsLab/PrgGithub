function GetProcessedVariablesFromPath_EC(root_dir)
    % Process all experiments by finding directories with ExpeInfo.mat and ChannelsToAnalyse folder
    % and running GetProcessedVariables_EC in each.

    if nargin < 1
        root_dir = uigetdir(pwd, 'Select the root directory'); % Ask user for directory if not provided
        if root_dir == 0
            disp('No directory selected. Exiting.');
            return;
        end
    end

    % Get list of all directories in root_dir
    dir_list = dir(root_dir);
    dir_list = dir_list([dir_list.isdir]); % Keep only directories

    % Loop through each directory and check for required files
    for i = 1:length(dir_list)
        % Skip '.' and '..'
        if strcmp(dir_list(i).name, '.') || strcmp(dir_list(i).name, '..')
            continue;
        end

        % Get full directory path
        experiment_dir = fullfile(root_dir, dir_list(i).name);

        % Check for ExpeInfo.mat and ChannelsToAnalyse folder
        expe_info_file = fullfile(experiment_dir, 'ExpeInfo.mat');
        channels_folder = fullfile(experiment_dir, 'ChannelsToAnalyse');

        if exist(expe_info_file, 'file') && exist(channels_folder, 'dir')
            disp(['Processing experiment in: ', experiment_dir]);

            % Change to the experiment directory
            old_dir = cd(experiment_dir);

            try
                % Run processing function
                GetProcessedVariables_EC;
            catch ME
                disp(['Error processing ', experiment_dir, ': ', ME.message]);
            end

            % Return to the original directory
            cd(old_dir);
        else
            disp(['Skipping ', experiment_dir, ' (missing ExpeInfo.mat or ChannelsToAnalyse folder).']);
        end
    end

    disp('Processing completed.');
end
