
%% load data
cd('/home/arsenii/data5/Arsenii/Codes/')
AddMyPaths_AG('icelos')
addpath(genpath('/home/arsenii/data5/Arsenii/OBG_AG/Codes'))
search_directory = '/home/pinky/temp_folder';
cd(search_directory)

% % Find csv files
% clear extension; extension = '.csv';
% filepaths(:, 1) = find_file(extension, search_directory);
% clear extension; extension = '.avi';
% filepaths(:, 2) = find_file(extension, search_directory);

% Find CSV files
csv_files = dir(fullfile(search_directory, '*.csv'));
csv_filepaths = fullfile(search_directory, {csv_files.name});

% Find AVI files
avi_files = dir(fullfile(search_directory, '*.avi'));
avi_filepaths = fullfile(search_directory, {avi_files.name});

% Combine file paths into one cell array
filepaths = [csv_filepaths(:), avi_filepaths(:)];

%% Calculate the number of frames
for i = 1:size(filepaths, 1)
    if i ~=3
        % select the session
        extract_name = strsplit(filepaths{i,1}, '/');
        
        session_name = extract_name{5};
        
        % number of trigs from the csv file
        n_csv_trigs = size(readtable(filepaths{i, 1}), 1);
        
        % number of frames
        videoObj = VideoReader(filepaths{i, 2}); % create a VideoReader object
       % get the total number of frames
        
        % Duration of the video
        duration = videoObj.Duration/60;
        
        % Calculate the difference
        difference = n_csv_trigs - numFrames;
        if difference ~= 0
            disp(['There is a mismatch in the ' session_name ' session. #CSV ' num2str(n_csv_trigs) ', #frames ' num2str(numFrames) '. Difference: ' num2str(difference) '. Video duration: ' num2str(duration) 'm']);
        end
        if difference == 0
            disp(['All good in the ' session_name ' session! #CSV ' num2str(n_csv_trigs) ', #frames ' num2str(numFrames) '. Difference: ' num2str(difference) '. Video duration: ' num2str(duration) 'm']);
        end
    end
end


