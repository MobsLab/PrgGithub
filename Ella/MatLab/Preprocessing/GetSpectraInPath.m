function GetSpectraInPath(root_dir)
% GetSpectraInPath - Recursively computes low and high spectra in all folders 
% containing ExpeInfo.mat and behavResources.mat
%
% Usage:
%   GetSpectraInPath('path/to/start')

    if nargin < 1
        root_dir = uigetdir(pwd, 'Select root directory');
        if root_dir == 0
            disp('No directory selected. Exiting.');
            return;
        end
    end

    % Recursively get all subfolders
    folders = getAllSubfolders(root_dir);

    % Loop through each folder
    for i = 1:length(folders)
        folder_path = folders{i};

        expe_file = fullfile(folder_path, 'ExpeInfo.mat');
        behav_file = fullfile(folder_path, 'behavResources.mat');
        bulb_file = fullfile(folder_path, 'ChannelsToAnalyse', 'Bulb_deep.mat');
        low_spectrogram_file = fullfile(folder_path, 'B_Low_Spectrum.mat');
        high_spectrogram_file = fullfile(folder_path, 'B_High_Spectrum.mat');

        if exist(expe_file, 'file') && exist(behav_file, 'file')
            disp(['Processing folder: ', folder_path]);
            old_dir = cd(folder_path);

            if exist(bulb_file, 'file')
                load(bulb_file, 'channel');

                % Low spectrum
                if ~exist(low_spectrogram_file, 'file')
                    LowSpectrumSB([cd filesep], channel, 'B');
                else
                    disp('B_Low_Spectrum.mat already exists. Skipping low spectrum computation.');
                end

                % High spectrum
                if ~exist(high_spectrogram_file, 'file')
                    HighSpectrum([cd filesep], channel, 'B');
                else
                    disp('B_High_Spectrum.mat already exists. Skipping high spectrum computation.');
                end
            else
                disp('Bulb_deep.mat not found. Skipping spectrum computation.');
            end

            cd(old_dir);
        end
    end
end

function folder_list = getAllSubfolders(root_dir)
    % Recursively get all subfolders
    folder_list = {};
    stack = {root_dir};

    while ~isempty(stack)
        current = stack{1};
        stack(1) = [];

        folder_list{end+1} = current;
        subdirs = dir(current);
        subdirs = subdirs([subdirs.isdir] & ~ismember({subdirs.name}, {'.', '..'}));

        for i = 1:length(subdirs)
            stack{end+1} = fullfile(current, subdirs(i).name);
        end
    end
end
