function OB_face_analysis_DLC(Session_params, datapath)
% This script calculates the set of basic parameters (on raw data) and figures from the DLC tracking 

%% Load data
cd(datapath)

% Load DLC csv file
cd([datapath '/DLC'])
file=dir('*_filtered.csv'); % smoothed by DLC
% file=dir('*900000.csv'); % not smoothed

filename=file.name; disp(['DLC data: ' filename]) %don't forget to specify the csv if you have many
data = csvread(fullfile(pwd,filename),3); %loads the csv from line 3 to the end (to skip the Header)

% Load video csv file
file=dir('*frames.csv'); 
filename=file.name; disp(['Video framse: ' filename]) %don't forget to specify the csv if you have many
data_csv = csvread(fullfile(pwd,filename)); %loads the csv from line 3 to the end (to skip the Header)

load('DLC_data.mat', 'time_1st_trig', 'time_trig')

%% Prepare data
nframes = size(data,1);
data = data(1:nframes, :);

% Time
% time = ts(linspace(time_1st_trig*1e4, (nframes/Session_params.fps)*1e4 + time_1st_trig*1e4, nframes));
if length(time_trig) > length(data)
   time_trig = time_trig(1:length(data));
   disp(['Camera trigger signal is longer than DLC data by ' num2str(length(time_trig) - length(data)) ' frames. I am restricting it on DLC data length'])
end
time = ts(time_trig*1e4);


% Pupil
pupil_x = data(:, 2:3:23);
pupil_y = data(:, 3:3:24);

% Eyes
eye_x = data(:, 26:3:48);
eye_y = data(:, 27:3:49);

% Nostrils
nostril_x = data(:, 50:3:60);
nostril_y = data(:, 51:3:61);

% Whiskers
whiskers_x = data(:, 62:3:72);
whiskers_y = data(:, 63:3:73);

%% Calculate derivatives
areas_pupil = zeros(nframes, 1);
areas_eye = zeros(nframes, 1);
pupil_center = zeros(nframes, 2);
areas_nostril = zeros(nframes, 1);
nostril_center = zeros(nframes, 2);

for frame = 1:nframes
    
    % Calculate the area using the x and y coordinates
    areas_pupil(frame) = polyarea(pupil_x(frame, :), pupil_y(frame, :));
    areas_eye(frame)= polyarea(eye_x(frame, :), eye_y(frame, :));
    areas_nostril(frame) = polyarea(nostril_x(frame, :), nostril_y(frame, :));
    
    % PUPIL
    % Create a convex hull using the x and y coordinates
    x_pupil = pupil_x(frame, :);
    y_pupil = pupil_y(frame, :);
    if x_pupil ~= 0
        k_pupil = convhull(x_pupil, y_pupil);
        % Store the centroid coordinates
        centroid_x_pupil = mean(x_pupil(k_pupil));
        centroid_y_pupil = mean(y_pupil(k_pupil));
        pupil_center(frame, :) = [centroid_x_pupil, centroid_y_pupil];
    else
        disp(['frame ' num2str(frame) ' is 0. Cannot compute convex hull for pupil. Putting NaN instead'])
        pupil_center(frame, :) = [nan, nan];
    end
    % NOSTRIL
    % Create a convex hull using the x and y coordinates
    x_nostril = nostril_x(frame, :);
    y_nostril = nostril_y(frame, :);
    if x_pupil ~= 0
        k_nostril = convhull(x_nostril, y_nostril);
        
        % Store the centroid coordinates
        centroid_x_nostril = mean(x_nostril(k_nostril));
        centroid_y_nostril = mean(y_nostril(k_nostril));
        nostril_center(frame, :) = [centroid_x_nostril, centroid_y_nostril];
    else
        disp(['frame ' num2str(frame) ' is 0. Cannot compute convex hull for nostril. Putting NaN instead'])
        nostril_center(frame, :) = [nan, nan];
    end

end

% Pupil movement
D = [0 0 ; diff(pupil_center)];
pupil_mvt = sqrt(D(:,1).*D(:,1) + D(:,2).*D(:,2));
pupil_mvt_tsd = tsd(Range(time), pupil_mvt);

% Pupil area
areas_pupil_tsd = tsd(Range(time),  areas_pupil);

% [pupil_size_thresh , mu1 , mu2 , std1 , std2 , AshD] = GetGammaThresh(exp(log10(Data(areas_pupil_tsd))));
% [eye_thresh_sleep , mu1 , mu2 , std1 , std2 , AshD] = GetGammaThresh(exp(Data(pupil_mvt_tsd)));
% close

%% Velocity and acceleration
% Initialize arrays to store velocity and acceleration
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

% variables = {'pupil_x','pupil_y','areas_pupil','pupil_center',...
%         'velocity_pupil_center','acceleration_pupil_center',...
%         'eye_x','eye_y','areas_eye',...
%         'nostril_x','nostril_y','areas_nostril','nostril_center','velocity_nostril_center', 'acceleration_nostril_center',...
%         'whiskers_x','whiskers_y'};
% 
% % Iterate through each variable name, create a tsd object, and assign it to the workspace
% for i = 1:length(variables)
%     varName = variables{i};
%     varValue = evalin('base', varName);  % Get the variable value from the base workspace
%     tsdObject = tsd(Range(time, 's'), varValue);  % Create the tsd object
%     assignin('base', [varName, '_tsd'], tsdObject);  % Assign the tsd object to a new variable in the base workspace
% end

% Pupil
pupil_x = tsd(Range(time), pupil_x);
pupil_y = tsd(Range(time), pupil_y);
pupil_center = tsd(Range(time), pupil_center);
velocity_pupil_center = tsd(Range(time), velocity_pupil_center);
acceleration_pupil_center = tsd(Range(time), acceleration_pupil_center);

% Eye
eye_x = tsd(Range(time), eye_x);
eye_y = tsd(Range(time), eye_y);
areas_eye = tsd(Range(time), areas_eye);

% Nostrils
nostril_x = tsd(Range(time), nostril_x);
nostril_y = tsd(Range(time), nostril_y);
areas_nostril = tsd(Range(time), areas_nostril);
nostril_center = tsd(Range(time), nostril_center);
velocity_nostril_center = tsd(Range(time), velocity_nostril_center);
acceleration_nostril_center = tsd(Range(time), acceleration_nostril_center);

% Whiskers
whiskers_x = tsd(Range(time), whiskers_x);
whiskers_y = tsd(Range(time), whiskers_y);

%% Save the data
cd([datapath '/DLC/'])
if ~exist('DLC_data.mat','file')
    save('DLC_data.mat','pupil_x','pupil_y','areas_pupil_tsd','pupil_center',...
        'pupil_mvt_tsd','velocity_pupil_center','acceleration_pupil_center',...
        'eye_x','eye_y','areas_eye',...
        'nostril_x','nostril_y','areas_nostril','nostril_center','velocity_nostril_center', 'acceleration_nostril_center',...
        'whiskers_x','whiskers_y',...
        'Session_params','time');
else
    save('DLC_data.mat','pupil_x','pupil_y','areas_pupil_tsd','pupil_center',...
        'pupil_mvt_tsd','velocity_pupil_center','acceleration_pupil_center',...
        'eye_x','eye_y','areas_eye',...
        'nostril_x','nostril_y','areas_nostril','nostril_center','velocity_nostril_center', 'acceleration_nostril_center',...
        'whiskers_x','whiskers_y',...
        'Session_params','time', '-append');
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
    sgtitle([Session_params.animal_name{Session_params.animal_selection} '. Session: ' Session_params.session_selection], 'FontWeight', 'bold')
catch
        suptitle([Session_params.animal_name{Session_params.animal_selection} '. Session: ' Session_params.session_selection], 'FontWeight', 'bold')
end
subplot(3,3,1)
plot(Range(time, 's'), Data(pupil_x));
title('pupil_x')
xlabel('Time (s)')

subplot(3,3,2)
plot(Range(time, 's'), Data(pupil_y));
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
plot(Range(time, 's'), Data(eye_x))
title('eye_x')
xlabel('Time (s)')

subplot(3,3,5)
plot(Range(time, 's'), Data(eye_y))
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
plot(Range(time, 's'), Data(nostril_x))
title('nostril_x')
xlabel('Time (s)')

subplot(3,3,8)
plot(Range(time, 's'), Data(nostril_y))
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
sgtitle([Session_params.animal_name{Session_params.animal_selection} '. Session: ' Session_params.session_selection], 'FontWeight', 'bold')

subplot(311)
plot(Range(time, 's'), Data(areas_pupil_tsd))
hold on
plot(Range(time, 's'), Data(areas_eye))
title('pupil and eye areas evolution')
xlabel('Time (s)')

subplot(312)
plot(Range(time, 's'), zscore(Data(areas_pupil_tsd)))
hold on
plot(Range(time, 's'), zscore(Data(areas_eye)))
title('pupil and eye areas evolution (zscored)')
xlabel('Time (s)')

%% f3: Velocity/Acceleration plots 
set(0, 'CurrentFigure', f3)
sgtitle([Session_params.animal_name{Session_params.animal_selection} '. Session: ' Session_params.session_selection], 'FontWeight', 'bold')

subplot(411)
plot(Range(time, 's'), Data(velocity_pupil_center)); 
title('velocity of the pupil')
legend({'velocity x', 'velocity y'})
xlabel('Time (s)')

subplot(412)
plot(Range(time, 's'), Data(acceleration_pupil_center))
title('Acceleration of the pupil')
legend({'Acceleration x', 'Acceleration y'})
xlabel('Time (s)')

subplot(413)
plot(Range(time, 's'), Data(velocity_nostril_center)); 
title('velocity of the nostril')
legend({'velocity x', 'velocity y'})
xlabel('Time (s)')

subplot(414)
plot(Range(time, 's'), Data(acceleration_nostril_center))
title('Acceleration of the nostril')
legend({'Acceleration x', 'Acceleration y'})
xlabel('Time (s)')

%% f4: put everything together (eye + pupil)
set(0, 'CurrentFigure', f4)
sgtitle([Session_params.animal_name{Session_params.animal_selection} '. Session: ' Session_params.session_selection], 'FontWeight', 'bold')

if exist('REMEpoch')
    observed_rem_start = Start(REMEpoch);
    observed_rem_end = End(REMEpoch);
end

% pupil center x
axp1 = subplot(5, 1, 1);
temp_data = Data(pupil_center);
plot(Range(time, 's'), temp_data(:, 1))
title('pupil center_x')
xlabel('Time (s)')

% pupil center y
axp2 = subplot(5, 1, 2);
plot(Range(time, 's'), temp_data(:, 2))
title('pupil center_y')
xlabel('Time (s)')

% pupil and eye areas
axp3 = subplot(5, 1, 3);
plot(Range(time, 's'), zscore(Data(areas_pupil_tsd)))
hold on
plot(Range(time, 's'), zscore(Data(areas_eye)))
title('pupil and eye areas (zscored)')
legend({'pupil', 'eye'})
xlabel('Time (s)')

% pupil velocity x
axp4 = subplot(5, 1, 4);
temp_data = Data(velocity_pupil_center);
plot(Range(time, 's'), temp_data(:, 1))
title('pupil velocity_x')
xlabel('Time (s)')

% pupil velocity y
axp5 = subplot(5, 1, 5);
plot(Range(time, 's'), temp_data(:, 2))
title('pupil velocity_y')
xlabel('Time (s)')

subplot_list = [axp1 axp2 axp3 axp4 axp5];

% plot REM episodes
if exist('REMEpoch')
    for i = 1:size(subplot_list, 2)
        axes(subplot_list(i))
        for j = 1:size(observed_rem_start, 1)
            patch([observed_rem_start(j) observed_rem_end(j) observed_rem_end(j) observed_rem_start(j)], [-500 -500 500 500], 'red', 'FaceAlpha', 0.2);
        end
        clear j
    end
end

%% f5: put everything together (nostril)
set(0, 'CurrentFigure', f5)
sgtitle([Session_params.animal_name{Session_params.animal_selection} '. Session: ' Session_params.session_selection], 'FontWeight', 'bold')

% nostril center x
axn1 = subplot(5, 1, 1);
temp_data = Data(nostril_center);
plot(Range(time, 's'), temp_data(:, 1))
title('nostril center_x')

% nostril center y
axn2 = subplot(5, 1, 2);
plot(Range(time, 's'), temp_data(:, 2))
title('nostril center_y')

% nostril areas
axn3 = subplot(5, 1, 3);
plot(Range(time, 's'), Data(areas_nostril))
title('nostril area')

% nostril velocity x
axn4 = subplot(5, 1, 4);
temp_data = Data(velocity_nostril_center);
plot(Range(time, 's'), temp_data(:, 1))
title('nostril velocity_x')

% nostril velocity y
axn5 = subplot(5, 1, 5);
plot(Range(time, 's'), temp_data(:, 2))
title('nostril velocity_y')

subplot_list = [axn1 axn2 axn3 axn4 axn5];

% plot REM episodes
if exist('REMEpoch')
    for i = 1:size(subplot_list, 2)
        axes(subplot_list(i))
        for j = 1:size(observed_rem_start, 1)
            patch([observed_rem_start(j) observed_rem_end(j) observed_rem_end(j) observed_rem_start(j)], [-500 -500 500 500], 'red', 'FaceAlpha', 0.2);
        end
        clear j
    end
end

%% Save figures

saveas(f1, ['/media/nas7/React_Passive_AG/OBG/Figures/' Session_params.animal_name{Session_params.animal_selection} '/DLC/' 'eye_nostril_DLC' '_' Session_params.session_selection], 'svg') 
saveas(f1, ['/media/nas7/React_Passive_AG/OBG/Figures/' Session_params.animal_name{Session_params.animal_selection} '/DLC/' 'eye_nostril_DLC' '_' Session_params.session_selection], 'png') 
saveas(f1, [pwd '/Figures/' 'eye_nostril_DLC' '_' Session_params.session_selection], 'svg') 
saveas(f1, [pwd '/Figures/' 'eye_nostril_DLC' '_' Session_params.session_selection], 'png') 

saveas(f2, ['/media/nas7/React_Passive_AG/OBG/Figures/' Session_params.animal_name{Session_params.animal_selection} '/DLC/' 'eye_nostril_areas_DLC' '_' Session_params.session_selection], 'svg') 
saveas(f2, ['/media/nas7/React_Passive_AG/OBG/Figures/' Session_params.animal_name{Session_params.animal_selection} '/DLC/' 'eye_nostril_areas_DLC' '_' Session_params.session_selection], 'png') 
saveas(f2, [pwd '/Figures/' 'eye_nostril_areas_DLC' '_' Session_params.session_selection], 'svg') 
saveas(f2, [pwd '/Figures/' 'eye_nostril_areas_DLC' '_' Session_params.session_selection], 'png') 

saveas(f3, ['/media/nas7/React_Passive_AG/OBG/Figures/' Session_params.animal_name{Session_params.animal_selection} '/DLC/' 'eye_nostril_velocity_DLC' '_' Session_params.session_selection], 'svg') 
saveas(f3, ['/media/nas7/React_Passive_AG/OBG/Figures/' Session_params.animal_name{Session_params.animal_selection} '/DLC/' 'eye_nostril_velocity_DLC' '_' Session_params.session_selection], 'png') 
saveas(f3, [pwd '/Figures/' 'eye_nostril_velocity_DLC' '_' Session_params.session_selection], 'svg') 
saveas(f3, [pwd '/Figures/' 'eye_nostril_velocity_DLC' '_' Session_params.session_selection], 'png') 

saveas(f4, ['/media/nas7/React_Passive_AG/OBG/Figures/' Session_params.animal_name{Session_params.animal_selection} '/DLC/' 'eye_pupil_all_DLC' '_' Session_params.session_selection], 'svg') 
saveas(f4, ['/media/nas7/React_Passive_AG/OBG/Figures/' Session_params.animal_name{Session_params.animal_selection} '/DLC/' 'eye_pupil_all_DLC' '_' Session_params.session_selection], 'png') 
saveas(f4, [pwd '/Figures/' 'eye_pupil_all_DLC' '_' Session_params.session_selection], 'svg') 
saveas(f4, [pwd '/Figures/' 'eye_pupil_all_DLC' '_' Session_params.session_selection], 'png') 

saveas(f5, ['/media/nas7/React_Passive_AG/OBG/Figures/' Session_params.animal_name{Session_params.animal_selection} '/DLC/' 'nostril_all_DLC' '_' Session_params.session_selection], 'svg') 
saveas(f5, ['/media/nas7/React_Passive_AG/OBG/Figures/' Session_params.animal_name{Session_params.animal_selection} '/DLC/' 'nostril_all_DLC' '_' Session_params.session_selection], 'png') 
saveas(f5, [pwd '/Figures/' 'nostril_all_DLC' '_' Session_params.session_selection], 'svg') 
saveas(f5, [pwd '/Figures/' 'nostril_all_DLC' '_' Session_params.session_selection], 'png') 

% close all

end

