function sync_video_ob(Session_params, datapath)
%%%%%% synchronisation of videos and OB signal %%%%%%%%%

% ToDo:

% for some reason, on 0208, it does not detect the last trigger in LFP
% trig. Fix it. This is not a critical issue, because it influence only the
% scatter plotting for vizualisation, not the sync.

% doesn't detect the last peak in peak_values) for at least 20230508_2 and
% maybe for other's as well

%% Load data
% Load LFP
% load('ExpeInfo.mat')
cd(datapath)
if Session_params.animal_selection == 1 % Labneh
    for l = [42] % vtrig
        load(['LFPData/LFP' num2str(l) '.mat'])
        LFP_ferret{l} = LFP;
    end
elseif Session_params.animal_selection == 2 % Brynza
    for l = [42] % vtrig
        load(['LFPData/LFP' num2str(l) '.mat'])
        LFP_ferret{l} = LFP;
    end
elseif Session_params.animal_selection == 3 % Shropshire
    for l = [112] % vtrig
        load(['LFPData/LFP' num2str(l) '.mat'])
        LFP_ferret{l} = LFP;
    end
    
end

% Load video .csv
cd([datapath '/DLC'])
file=dir('*frames.csv');
data_csv = csvread(fullfile([datapath '/DLC'],file.name)); %loads the csv from line 3 to the end (to skip the Header)

% Define the time scales
time_lfp = Range(LFP_ferret{l}, 's');
% time_trig = data_csv;
% time_trig = time_trig - time_trig(1);

%% find triggers and events
LFP_trig_data = Data(LFP_ferret{l});

tmp = diff(LFP_trig_data);
threshold = max(tmp)/3;

rise_fall_idx = find(tmp>=threshold);
rise_fall = tmp(rise_fall_idx);

threshold_event = 4;

num_points = numel(rise_fall_idx);

% Find the indices of events based on the threshold
event_indices = 1;
for i = 2:num_points
    if (rise_fall_idx(i) - rise_fall_idx(i-1)) > threshold_event
        event_indices = [event_indices, i];
    end
end
event_indices = [event_indices, num_points];

%% Select the peak value for each event
num_events = numel(event_indices) - 1;
peak_values = nan(num_events, 1);
peak_indices = nan(num_events, 1);

% for the session where I had an outlier as the first index
% peak_values = nan(num_events-1, 1);
% peak_indices = nan(num_events-1, 1);


for i = 1:num_events
    event_data = LFP_trig_data(rise_fall_idx(event_indices(i):event_indices(i+1)-1));
    
    if ~isempty(event_data)
        [~, max_idx] = max(event_data);
        current_peak_index = rise_fall_idx(event_indices(i) - 1 + max_idx);
        
        peak_values(i) = event_data(max_idx);
        peak_indices(i) = current_peak_index;
    end
end

% AG 30/10/2024 for 20230323 & 20230208 Labneh HF
if find(isnan(peak_indices)) == size(peak_indices,1)
    peak_indices(find(isnan(peak_indices))) = peak_indices(end-1) + round(nanmean(diff(peak_indices)));
    peak_values(find(isnan(peak_values))) = peak_values(end-1) + round(nanmean(diff(peak_values)));
    disp('the last value of peak_indices/values is NaN, beware. Substitute it with the last value + mean value')
end


%% Control plots
if Session_params.plt(1) == 1
    % Plot the triggers with peak indices
    figure;
    subplot(2, 1, 1);
    plot(time_lfp, LFP_trig_data);
    hold on;
    scatter(time_lfp(rise_fall_idx), LFP_trig_data(rise_fall_idx), 'r', 'filled');
    xlabel('Index');
    ylabel('Value');
    title('Triggers with Rise-Fall Indexes');
    
    subplot(2, 1, 2);
    plot(time_lfp, LFP_trig_data);
    hold on;
    scatter(time_lfp(peak_indices), peak_values, 'r', 'filled');
    xlabel('Index');
    ylabel('Value');
    title('Triggers with Peak Values');
    
    % Display the plot
    grid on;
end

%% Inter-peak interval and outliers (modify the threshold)
% Calculate interpeak intervals
interpeak_intervals = diff(peak_indices);

% Calculate z-scores for the interpeak intervals
z_scores = zscore(interpeak_intervals);

% Set the threshold for outlier detection (e.g., z-score > 3 or < -3)
threshold = 3;

% Find the outlier intervals
outlier_indices = find(z_scores > threshold | z_scores < -threshold);
outlier_intervals = interpeak_intervals(outlier_indices);

%% Control plots
if Session_params.plt(1) == 1
    
    % Plot the histogram of interpeak intervals with outliers
    figure;
    histogram(interpeak_intervals, 10000);
    hold on;
    histogram(outlier_intervals);
    legend('Interpeak Intervals', 'Outlier Intervals');
    xlabel('Interpeak Intervals');
    ylabel('Frequency');
    title('Histogram of Interpeak Intervals with Outliers');
    grid on;
    
    % Check the outliers and remove them (needs to be modified)
    % Plot the triggers with peak indices and outliers
    figure;
    plot(time_lfp, LFP_trig_data);
    hold on;
    % scatter(rise_fall_idx, LFP_trig_data(rise_fall_idx), 'r', 'filled');
    scatter(time_lfp(peak_indices), peak_values, 'r', 'filled');
    scatter(time_lfp(peak_indices(outlier_indices)), peak_values(outlier_indices), 'g', 'filled');
    xlabel('Index');
    ylabel('Value');
    title('Triggers with Peak Indices (Outliers in Green)');
    % Display the plot
    grid on;
    
    figure; plot(LFP_trig_data); hold on; scatter(peak_indices, peak_values, 'r', 'filled')
    
end
%%
% time_csv_trig_tmp = time_trig + time_1st_trig;
% time_lfp_trig_tmp = time_lfp(peak_indices);
% 
% for i = 1:size(time_csv_trig_tmp, 1)
%     diff_csv_lfp_trigs(i) = time_csv_trig_tmp(i) - time_lfp_trig_tmp(i);
% end
% 
% if plt == 1
%     figure; hist(diff_csv_lfp_trigs)
%     
%     disp([num2str(diff_csv_lfp_trigs(end)*1e3) ' ms'])
% end
%% remove the outlier (the first one)
% Check if the first peak is an outlier

if ismember(1, outlier_indices)
    % Remove outliers from peak_indices and peak_values
    peak_indices(outlier_indices == 1) = [];
    peak_values(outlier_indices == 1) = [];
    %
    %     peak_indices(outlier_indices+1) = [];
    %     peak_values(outlier_indices) = [];
    
    outlier_indices(1) = [];
end

if outlier_indices == size(peak_indices, 1)
    peak_indices(end) = [];
    peak_values(end) = [];
end


time_1st_trig = time_lfp(peak_indices(1));
% save([datapath '/DLC/DLC_data.mat'], 'time_1st_trig', '-append');

%YB
% time_trig = time_lfp(peak_indices)-time_1st_trig;
time_trig = time_lfp(peak_indices);

%% Save data
if exist('DLC_data.mat')
    save(['DLC_data.mat'], 'time_1st_trig', 'time_trig', '-append');
else
    save(['DLC_data.mat'], 'time_1st_trig', 'time_trig');
end

%% control plots
if Session_params.plt(1) == 1
    figure;
    plot(time_lfp, LFP_trig_data);
    grid on;
    hold on;
    % scatter(rise_fall_idx, LFP_trig_data(rise_fall_idx), 'r', 'filled');
    scatter(time_lfp(peak_indices), peak_values, 'r', 'filled');
    scatter(time_lfp(peak_indices(outlier_indices)), peak_values(outlier_indices), 'g', 'filled');
    scatter(time_trig+time_1st_trig, peak_values, 'b', 'filled');
    
    xlabel('Time');
    ylabel('Value');
    title('Mismatch between the csv timestamps and the timestamps, extracted from the trigger''s LFP channel');
    % Display the plot
    grid on;
    
    %% sync DLC and triggers
%     figure;
%     grid on;
%     subplot(4, 1, 1)
%     plot(time_lfp, Data(LFP_OB))
%     title('OB 24th channel')
%     
%     subplot(4, 1, 2)
%     plot(time_lfp, LFP_trig_data)
%     hold on
%     scatter(time_trig + time_1st_trig, peak_values, 'r', 'filled')
%     title('LFP video triggers')
%     
%     subplot(4, 1, 3)
%     plot(time_trig + time_1st_trig, pupil_center(:, 1));
%     hold on
%     plot(time_trig + time_1st_trig, pupil_center(:, 1), '.', 'MarkerSize',15);
%     title('DLC pupil center_x')
%     
%     subplot(4, 1, 4)
%     plot(time_trig + time_1st_trig, areas_pupil(:, 1)*1e1);
%     hold on
%     plot(time_trig + time_1st_trig, areas_pupil(:, 1)*1e1,'.', 'MarkerSize',15);
%     title('DLC pupil area_x')
%     
%     ax = findobj(gcf, 'type', 'axes');
%     linkaxes(ax, 'x');
    % xlim([0 100])
    % xlim([5 12])
%     xlim([10912 10916]) %pour 0208
%     xlim([10630 10645]) %pour 0303
%     xlim([5395 5400]) %pour 0508_2
    
end

%% study the mismatch between the video csv time stamps and timestamps extracted from trigger LFP
% if you have 10 fps, then every lag <100ms is fine

% time_csv_trig_tmp = time_trig + time_1st_trig;
% time_lfp_trig_tmp = time_lfp(peak_indices);
% 
% for i = 1:size(time_csv_trig_tmp, 1)
%     diff_csv_lfp_trigs(i) = time_csv_trig_tmp(i) - time_lfp_trig_tmp(i);
% end
% 
% if plt == 1
%     
%     figure; hist(diff_csv_lfp_trigs)
%     
%     disp([num2str(diff_csv_lfp_trigs(end)*1e3) ' ms'])
%     
% end




end


