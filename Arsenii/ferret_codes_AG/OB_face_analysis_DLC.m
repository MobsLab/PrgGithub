function OB_face_analysis_DLC(datapath)
% This script computes basic parameters and generates figures from DLC tracking data.
% It uses synchronized DLC data (with the time column aligned to openephys triggers)
% so that the ephys (OB/LFP) and video/DLC signals are on the same time base.

%% Initialization
[~, Session_params.session_selection, ~] = fileparts(datapath);

Session_params.fig_visibility = 'off';

if contains(datapath, 'Shropshire')
    Session_params.animal_name = 'Shropshire';
elseif contains(datapath, 'Brynza')
    Session_params.animal_name = 'Brynza';
elseif contains(datapath, 'Labneh')
    Session_params.animal_name = 'Labneh';
end

disp(['Processing session: '  Session_params.animal_name ' ' Session_params.session_selection]);

%% Load DLC Synchronized Data
dlc_file = dir(fullfile(datapath, 'DLC', 'synchronized_DLC_data.csv'));
if isempty(dlc_file)
    error('synchronized_DLC_data.csv not found in %s/DLC', datapath);
end
filename = dlc_file(1).name;
disp(['DLC data: ' filename])

% Read entire CSV
% data = csvread(fullfile(datapath, 'DLC', filename), 0, 0);

dataStruct = importdata(fullfile(datapath, 'DLC', filename));
if isstruct(dataStruct)
    data = dataStruct.data;
else
    data = dataStruct;
end

% Verify that the first column (time) is monotonic
time_vals = data(:,1);
if any(diff(time_vals) < 0)
    warning('Time stamps in the first column are not strictly increasing. Fixing it...');
    data(:, 1) = sort(time_vals);
    csvwrite(fullfile(datapath, 'DLC', 'synchronized_DLC_data.csv'), data);
    time_vals = data(:,1);    
end

% Get number of frames from the synchronized data
nframes = size(data, 1);
fprintf('Number of synchronized frames: %d\n', nframes);

% Load frames.csv file
    % video_file=dir(fullfile([datapath '/DLC/'],'*frames.csv')); 
    % filename=video_file.name; disp(['Video frames: ' filename]) %don't forget to specify the csv if you have many
    % data_csv = csvread(fullfile([datapath '/DLC/'],filename)); %loads the csv from line 3 to the end (to skip the Header)

% Load time (already included to data file
    % load([datapath '/DLC/DLC_data.mat'], 'time_1st_trig', 'time_trig')
 
% Terminal command to check the real number of frames in the video
    % ffprobe -v error -count_frames -select_streams v:0 -show_entries stream=nb_read_frames -of csv=p=0 /media/nas8/OB_ferret_AG_BM/Shropshire/head-fixed/20241206_TORCs/shropshire_20241206_hf_TORCs_fixed.avi

%% Extract Tracking Coordinates

% Pupil
pupil_x = data(:, 3:3:24);
pupil_y = data(:, 4:3:25);

% Eyes
eye_x = data(:, 27:3:49);
eye_y = data(:, 28:3:50);

% Nostrils
nostril_x = data(:, 51:3:61);
nostril_y = data(:, 52:3:62);

% Whiskers
whiskers_x = data(:, 63:3:73);
whiskers_y = data(:, 64:3:74);

%% Calculate Basic Metrics Per Frame
% Preallocate arrays
areas_pupil = zeros(nframes, 1);
areas_eye = zeros(nframes, 1);
pupil_center = nan(nframes, 2);
areas_nostril = zeros(nframes, 1);
nostril_center = nan(nframes, 2);

for frame = 1:nframes
    % Calculate the area using polyarea on the x and y coordinates
    areas_pupil(frame) = polyarea(pupil_x(frame, :), pupil_y(frame, :));
    areas_eye(frame)= polyarea(eye_x(frame, :), eye_y(frame, :));
    areas_nostril(frame) = polyarea(nostril_x(frame, :), nostril_y(frame, :));
    
    % Compute pupil centroid via convex hull (if points are valid)
    x_pupil = pupil_x(frame, :);
    y_pupil = pupil_y(frame, :);
    
    if all(x_pupil == 0)
        disp(['Frame ' num2str(frame) ': Pupil points all zero. Setting pupil center to NaN.'])
        pupil_center(frame, :) = [NaN, NaN];
    else
        k_pupil = convhull(x_pupil, y_pupil);
        pupil_center(frame, :) = [mean(x_pupil(k_pupil)), mean(y_pupil(k_pupil))];
    end
    
    % Compute nostril centroid via convex hull (if points are valid)
    x_nostril = nostril_x(frame, :);
    y_nostril = nostril_y(frame, :);
    if all(x_nostril == 0)
        disp(['Frame ' num2str(frame) ': Nostrils points all zero. Setting nostril center to NaN.'])
        nostril_center(frame, :) = [NaN, NaN];
    else
        k_nostril = convhull(x_nostril, y_nostril);
        nostril_center(frame, :) = [mean(x_nostril(k_nostril)), mean(y_nostril(k_nostril))];
    end
end

%% Calculate Pupil Movement and Derivatives
% Compute frame-to-frame displacement of pupil center (Euclidean distance)
D = [0 0 ; diff(pupil_center)]; % prepend zero displacement for first frame
pupil_mvt = sqrt(D(:,1).*D(:,1) + D(:,2).*D(:,2));
pupil_mvt = tsd(data(:, 1)*1e4, pupil_mvt);
areas_pupil = tsd(data(:, 1)*1e4,  areas_pupil);

%% Compute Velocity and Acceleration for Pupil and Nostrils
% Preallocate arrays
velocity_pupil_center = zeros(nframes, 2);
acceleration_pupil_center = zeros(nframes, 2);
velocity_nostril_center = zeros(nframes, 2);
acceleration_nostril_center = zeros(nframes, 2);

% Calculate velocity and acceleration for each time frame
for frame = 2:nframes
    % Calculate the velocity using finite difference approximation
    velocity_pupil_center(frame, :) = pupil_center(frame, :) - pupil_center(frame-1, :);
    velocity_nostril_center(frame, :) = nostril_center(frame, :) - nostril_center(frame-1, :);
    
    % Calculate the acceleration using finite difference approximation
    acceleration_pupil_center(frame, :) = velocity_pupil_center(frame, :) - velocity_pupil_center(frame-1, :);
    acceleration_nostril_center(frame, :) = velocity_nostril_center(frame, :) - velocity_nostril_center(frame-1, :);
end

%% Distance between the 3rd and the 7th eye points - to detect the blink

% for frame = 1:nframes
%     blink(frame, :) = eye_y(frame, 7) - eye_y(frame, 3);
% end

%% Convert to tsd

% Pupil
pupil_x = tsd(data(:, 1)*1e4, pupil_x);
pupil_y = tsd(data(:, 1)*1e4, pupil_y);
pupil_center = tsd(data(:, 1)*1e4, pupil_center);
velocity_pupil_center = tsd(data(:, 1)*1e4, velocity_pupil_center);
acceleration_pupil_center = tsd(data(:, 1)*1e4, acceleration_pupil_center);

% Eye
eye_x = tsd(data(:, 1)*1e4, eye_x);
eye_y = tsd(data(:, 1)*1e4, eye_y);
areas_eye = tsd(data(:, 1)*1e4, areas_eye);

% Nostrils
nostril_x = tsd(data(:, 1)*1e4, nostril_x);
nostril_y = tsd(data(:, 1)*1e4, nostril_y);
areas_nostril = tsd(data(:, 1)*1e4, areas_nostril);
nostril_center = tsd(data(:, 1)*1e4, nostril_center);
velocity_nostril_center = tsd(data(:, 1)*1e4, velocity_nostril_center);
acceleration_nostril_center = tsd(data(:, 1)*1e4, acceleration_nostril_center);

% Whiskers
whiskers_x = tsd(data(:, 1)*1e4, whiskers_x);
whiskers_y = tsd(data(:, 1)*1e4, whiskers_y);

%% Save Processed Data
% Save the computed tsd objects to a MAT file in the DLC folder.
savePath = fullfile(datapath, 'DLC');

if ~exist(fullfile(savePath, 'DLC_data.mat'), 'file')
    save(fullfile(savePath, 'DLC_data.mat'), 'pupil_x','pupil_y','areas_pupil','pupil_center',...
        'pupil_mvt','velocity_pupil_center','acceleration_pupil_center',...
        'eye_x','eye_y','areas_eye',...
        'nostril_x','nostril_y','areas_nostril','nostril_center',...
        'velocity_nostril_center','acceleration_nostril_center',...
        'whiskers_x','whiskers_y');
else
    save(fullfile(savePath, 'DLC_data.mat'), 'pupil_x','pupil_y','areas_pupil','pupil_center',...
        'pupil_mvt','velocity_pupil_center','acceleration_pupil_center',...
        'eye_x','eye_y','areas_eye',...
        'nostril_x','nostril_y','areas_nostril','nostril_center',...
        'velocity_nostril_center','acceleration_nostril_center',...
        'whiskers_x','whiskers_y','-append');
end
 
%% Plot figures
f1 = figure('Visible', Session_params.fig_visibility); 
set(f1, 'Units', 'Normalized', 'Position', [0 0 1 1]);

f2 = figure('Visible', Session_params.fig_visibility); 
set(f2, 'Units', 'Normalized', 'Position', [0 0 1 1]);

f3 = figure('Visible', Session_params.fig_visibility); 
set(f3, 'Units', 'Normalized', 'Position', [0 0 1 1]);

f4 = figure('Visible', Session_params.fig_visibility); 
set(f4, 'Units', 'Normalized', 'Position', [0 0 1 1]);

f5 = figure('Visible', Session_params.fig_visibility); 
set(f5, 'Units', 'Normalized', 'Position', [0 0 1 1]);

%% f1: Dynamics plots 
set(0, 'CurrentFigure', f1)

try
    sgtitle([Session_params.animal_name '. Session: '  Session_params.session_selection], 'FontWeight', 'bold')
catch
    suptitle([Session_params.animal_name '. Session: ' Session_params.session_selection], 'FontWeight', 'bold')
end
subplot(3,3,1)
plot(data(:, 1), Data(pupil_x));
title('pupil_x')
xlabel('Time (s)')

subplot(3,3,2)
plot(data(:, 1), Data(pupil_y));
title('pupil_y')
xlabel('Time (s)')

subplot(3,3,3)
sparse_pupil_x = Data(pupil_x);
sparse_pupil_y = Data(pupil_y);
scatter(sparse_pupil_x(1:1000:end), sparse_pupil_y(1:1000:end));
title('pupil')
xlabel('Time (s)')

% eye
subplot(3,3,4)
plot(data(:, 1), Data(eye_x))
title('eye_x')
xlabel('Time (s)')

subplot(3,3,5)
plot(data(:, 1), Data(eye_y))
title('eye_y')
xlabel('Time (s)')

subplot(3,3,6)
sparse_eye_x = Data(eye_x);
sparse_eye_y = Data(eye_y);
scatter(sparse_eye_x(1:1000:end), sparse_eye_y(1:1000:end))
title('eye')
xlabel('Time (s)')

% another version of scatter that works in mobs
% col_map=magma;
% 
% figure
% for i=1:8
%     plot(eye_x(1:10:end,i), eye_y(1:10:end,i),'.','Color',col_map(32*i,:))
%     hold on
% end
% for i=1:8
%     plot(pupil_x(1:10:end,i), pupil_y(1:10:end,i),'.','Color',col_map(32*i,:))
%     hold on
% end

% nostril 
subplot(3,3,7)
plot(data(:, 1), Data(nostril_x))
title('nostril_x')
xlabel('Time (s)')

subplot(3,3,8)
plot(data(:, 1), Data(nostril_y))
title('nostril_y')
xlabel('Time (s)')

subplot(3,3,9)
sparse_nostril_x = Data(nostril_x);
sparse_nostril_y = Data(nostril_y);
scatter(sparse_nostril_x(1:1000:end), sparse_nostril_y(1:1000:end))
title('nostril')
xlabel('Time (s)')

% another version of scatter that works in mobs
% figure
% for i=1:4
%     plot(nostril_x(1:10:end,i), nostril_y(1:10:end,i),'.','Color',col_map(32*i,:))
%     hold on
% end

%% f2: Areas plots 
set(0, 'CurrentFigure', f2)
sgtitle([Session_params.animal_name '. Session: ' Session_params.session_selection], 'FontWeight', 'bold')

subplot(311)
plot(data(:, 1), Data(areas_pupil))
hold on
plot(data(:, 1), Data(areas_eye))
title('pupil and eye areas evolution')
xlabel('Time (s)')

subplot(312)
plot(data(:, 1), zscore(Data(areas_pupil)))
hold on
plot(data(:, 1), zscore(Data(areas_eye)))
title('pupil and eye areas evolution (zscored)')
xlabel('Time (s)')

%% f3: Velocity/Acceleration plots 
set(0, 'CurrentFigure', f3)
sgtitle([Session_params.animal_name '. Session: ' Session_params.session_selection], 'FontWeight', 'bold')

subplot(411)
plot(data(:, 1), Data(velocity_pupil_center)); 
title('velocity of the pupil')
legend({'velocity x', 'velocity y'})
xlabel('Time (s)')

subplot(412)
plot(data(:, 1), Data(acceleration_pupil_center))
title('Acceleration of the pupil')
legend({'Acceleration x', 'Acceleration y'})
xlabel('Time (s)')

subplot(413)
plot(data(:, 1), Data(velocity_nostril_center)); 
title('velocity of the nostril')
legend({'velocity x', 'velocity y'})
xlabel('Time (s)')

subplot(414)
plot(data(:, 1), Data(acceleration_nostril_center))
title('Acceleration of the nostril')
legend({'Acceleration x', 'Acceleration y'})
xlabel('Time (s)')

%% f4: put everything together (eye + pupil)
set(0, 'CurrentFigure', f4)
sgtitle([Session_params.animal_name '. Session: ' Session_params.session_selection], 'FontWeight', 'bold')

if exist('REMEpoch')
    observed_rem_start = Start(REMEpoch);
    observed_rem_end = End(REMEpoch);
end

% pupil center x
axp1 = subplot(5, 1, 1);
temp_data = Data(pupil_center);
plot(data(:, 1), temp_data(:, 1))
title('pupil center_x')
xlabel('Time (s)')

% pupil center y
axp2 = subplot(5, 1, 2);
plot(data(:, 1), temp_data(:, 2))
title('pupil center_y')
xlabel('Time (s)')

% pupil and eye areas
axp3 = subplot(5, 1, 3);
plot(data(:, 1), zscore(Data(areas_pupil)))
hold on
plot(data(:, 1), zscore(Data(areas_eye)))
title('pupil and eye areas (zscored)')
legend({'pupil', 'eye'})
xlabel('Time (s)')

% pupil velocity x
axp4 = subplot(5, 1, 4);
temp_data = Data(velocity_pupil_center);
plot(data(:, 1), temp_data(:, 1))
title('pupil velocity_x')
xlabel('Time (s)')

% pupil velocity y
axp5 = subplot(5, 1, 5);
plot(data(:, 1), temp_data(:, 2))
title('pupil velocity_y')
xlabel('Time (s)')

subplot_list = [axp1 axp2 axp3 axp4 axp5];

% try 
%     load(fullfile(datapath, 'SleepScoring_OBGamma.mat'), 'REMEpoch')
%     rem_start = Start(REMEpoch)/1e4;
%     rem_end = End(REMEpoch)/1e4;
% catch
%     disp('No REM epoch found')
% end
% % plot REM episodes
% if exist('REMEpoch')
%     for i = 1:size(subplot_list, 2)
%         axes(subplot_list(i))
%         for j = 1:length(rem_start)
%             patch([rem_start(j) rem_end(j) rem_end(j) rem_start(j)], [-5 -5 5 5], 'red', 'FaceAlpha', 0.2);
%         end
%         clear j
%     end
% end

%% f5: put everything together (nostril)
set(0, 'CurrentFigure', f5)
sgtitle([Session_params.animal_name '. Session: ' Session_params.session_selection], 'FontWeight', 'bold')

% nostril center x
axn1 = subplot(5, 1, 1);
temp_data = Data(nostril_center);
plot(data(:, 1), temp_data(:, 1))
title('nostril center_x')

% nostril center y
axn2 = subplot(5, 1, 2);
plot(data(:, 1), temp_data(:, 2))
title('nostril center_y')

% nostril areas
axn3 = subplot(5, 1, 3);
plot(data(:, 1), Data(areas_nostril))
title('nostril area')

% nostril velocity x
axn4 = subplot(5, 1, 4);
temp_data = Data(velocity_nostril_center);
plot(data(:, 1), temp_data(:, 1))
title('nostril velocity_x')

% nostril velocity y
axn5 = subplot(5, 1, 5);
plot(data(:, 1), temp_data(:, 2))
title('nostril velocity_y')

subplot_list = [axn1 axn2 axn3 axn4 axn5];

% % plot REM episodes
% if exist('REMEpoch')
%     for i = 1:size(subplot_list, 2)
%         axes(subplot_list(i))
%         for j = 1:length(rem_start)
%             patch([rem_start(j) rem_end(j) rem_end(j) rem_start(j)], [-5 -5 5 5], 'red', 'FaceAlpha', 0.2);
%         end
%         clear j
%     end
% end


%% Save figures
figFolder = fullfile(datapath, 'DLC/Figures');
if ~exist(figFolder, 'dir')
    mkdir(figFolder);
end

saveas(f1, fullfile(figFolder, [Session_params.animal_name '_eye_nostril_' Session_params.session_selection]), 'svg') 
saveas(f1, fullfile(figFolder, [Session_params.animal_name '_eye_nostril_' Session_params.session_selection]), 'png') 

saveas(f2, fullfile(figFolder, [Session_params.animal_name 'eye_nostril_areas_' Session_params.session_selection]), 'svg') 
saveas(f2, fullfile(figFolder, [Session_params.animal_name 'eye_nostril_areas_' Session_params.session_selection]), 'png') 

saveas(f3, fullfile(figFolder, [Session_params.animal_name 'eye_nostril_velocity_' Session_params.session_selection]), 'svg') 
saveas(f3, fullfile(figFolder, [Session_params.animal_name 'eye_nostril_velocity_' Session_params.session_selection]), 'png') 

saveas(f4, fullfile(figFolder, [Session_params.animal_name 'eye_pupil_all_' Session_params.session_selection]), 'svg') 
saveas(f4, fullfile(figFolder, [Session_params.animal_name 'eye_pupil_all_' Session_params.session_selection]), 'png') 

saveas(f5, fullfile(figFolder, [Session_params.animal_name 'nostril_all_' Session_params.session_selection]), 'svg') 
saveas(f5, fullfile(figFolder, [Session_params.animal_name 'nostril_all_' Session_params.session_selection]), 'png') 

end

