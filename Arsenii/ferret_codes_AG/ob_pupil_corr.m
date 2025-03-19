function gamma_pupil_corr()
%% Make a proper pipeline with a proper timing taking into account the delay

% Load LFP data
if animal_selection == 1 % Labneh
    for l = [42 emg 36 24 cx] % vtrig, EMG, EKG, OBm, screw
        load(['LFPData/LFP' num2str(l) '.mat'])
        LFP_ferret{l} = LFP;
    end
elseif animal_selection == 2 % Brynza
    for l = [42 4 36 11 13 16] % vtrig, EMG, EKG, OBm, PFCm, HPCm
        load(['LFPData/LFP' num2str(l) '.mat'])
        LFP_ferret{l} = LFP;
    end
end

clear all
animal_name = 'Brynza';
session_name = [animal_name '/head-fixed/20240312_domitor'];
fps = 15;
smootime = 10;

%% Prepare data
cd(['/media/nas7/React_Passive_AG/OBG/' session_name])

load('StateEpochBM.mat', 'REMEpoch', 'SWSEpoch')
load('StateEpochSB.mat', 'Wake', 'Sleep', 'smooth_ghi')

% load('DLC_data.mat')
% load('behavResources.mat', 'MovAcctsd')
% load('StateEpochBM.mat', 'Wake', 'ThetaEpoch','theta_thresh')
% REMEpoch = and(Sleep,ThetaEpoch);
% SWSEpoch = and(Sleep,Sleep-ThetaEpoch);

%% DLC

cd([pwd '/DLC'])
load('DLC_data.mat', 'time_1st_trig', 'time_trig')
file=dir([animal_name '*filtered.csv']);

filename=file.name; %don't forget to specify the csv if you have many
pathname=pwd;
data=csvread(fullfile(pathname,filename),3); %loads the csv from line 3 to the end (to skip the Header)

nframes = size(data,1);

%% Define the DLC time
% define the DLC time

file=dir([pwd '/' '*frames.csv']);

data_csv = csvread(fullfile([pwd '/' ],file.name)); %loads the csv from line 3 to the end (to skip the Header)
dateStr = regexp(file.name, '\d{8}', 'match');
date = dateStr{1};

time = time_trig + time_1st_trig;

%% Calculate things
pupil_x = data(:, 2:3:23);
pupil_y = data(:, 3:3:24);
likelihood_pupil = data(:, 4:3:25);

% Compute the thresholds
% lower_threshold = mean(mean(likelihood_pupil) - 2 * std(likelihood_pupil));
% upper_threshold = mean(mean(likelihood_pupil) + 2 * std(likelihood_pupil));
lower_threshold = mean(mean(likelihood_pupil) - std(likelihood_pupil));
upper_threshold = mean(mean(likelihood_pupil) + std(likelihood_pupil));

filtered_pupil_x = pupil_x(all(likelihood_pupil >= (mean(likelihood_pupil,1:2) - 2*mean(std(likelihood_pupil))), 2), :);
filtered_pupil_y = pupil_y(all(likelihood_pupil >= (mean(likelihood_pupil,1:2) - 2*mean(std(likelihood_pupil))), 2), :);

time_pupil_denoised = time(find(all(likelihood_pupil >= lower_threshold & likelihood_pupil <= upper_threshold, 2) == 1));

areas_pupil = zeros(length(time_pupil_denoised), 1);
pupil_center = zeros(length(time_pupil_denoised), 2);

for frame = 1:length(time_pupil_denoised)
    % Calculate the area using the x and y coordinates
    areas_pupil(frame) = polyarea(filtered_pupil_x(frame, :), filtered_pupil_y(frame, :));
    
    % PUPIL
    % Create a convex hull using the x and y coordinates
    x_pupil = filtered_pupil_x(frame, :);
    y_pupil = filtered_pupil_y(frame, :);
    
    k_pupil = convhull(x_pupil, y_pupil);
    
    % Store the centroid coordinates
    centroid_x_pupil = mean(x_pupil(k_pupil));
    centroid_y_pupil = mean(y_pupil(k_pupil));
    pupil_center(frame, :) = [centroid_x_pupil, centroid_y_pupil];
end

% pupil movement tsd
% D = diff(pupil_center(1:3:end,:));
% pupil_mvt = sqrt(D(:,1).*D(:,1) + D(:,2).*D(:,2));
% pupil_mvt_tsd = tsd(linspace(0,max(Range(MovAcctsd)),length(pupil_mvt)) , pupil_mvt);
% smootime = 10;
% pupil_mvt_smooth = tsd(Range(pupil_mvt_tsd) , runmean(log10(Data(pupil_mvt_tsd)+1) , ceil(smootime/median(diff(Range(pupil_mvt_tsd,'s'))))));
% pupil_mvt_sleep = Restrict(pupil_mvt_smooth , Sleep);
% pupil_mvt_REM = Restrict(pupil_mvt_smooth , REMEpoch);

% area pupil tsd
areas_pupil_corr_tsd = tsd(time_pupil_denoised*1e4, smoothdata(areas_pupil,'rlowess',10));

areas_pupil_smooth = tsd(Range(areas_pupil_corr_tsd) , runmean(Data(areas_pupil_corr_tsd) , ceil(smootime/median(diff(Range(areas_pupil_corr_tsd,'s'))))));
areas_pupil_sleep = Restrict(areas_pupil_corr_tsd , Sleep);
areas_pupil_wake = Restrict(areas_pupil_corr_tsd , Wake);
areas_pupil_REM = Restrict(areas_pupil_corr_tsd , REMEpoch);

% smooth_ghi
smooth_ghi_smooth = tsd(Range(smooth_ghi) , runmean(Data(smooth_ghi) , ceil(smootime/median(diff(Range(smooth_ghi,'s'))))));

%% Time Evolution: Restrict epochs
g_wake = Restrict(smooth_ghi, Wake);
p_wake = Restrict(areas_pupil_corr_tsd, Wake);

g_sleep = Restrict(smooth_ghi, Sleep);
p_sleep = Restrict(areas_pupil_corr_tsd, Sleep);

g_nrem = Restrict(smooth_ghi, SWSEpoch);
p_nrem = Restrict(areas_pupil_smooth, SWSEpoch);

g_rem = Restrict(smooth_ghi, REMEpoch);
p_rem = Restrict(areas_pupil_smooth, REMEpoch);

%% Time Evolution: Raw
figure
clf

sgtitle('Time evolution of OB gamma and pupil area. Domitor. Z-scored', 'FontWeight', 'bold')
subplot(311)
plot(Range(smooth_ghi, 's'), zscore(Data(smooth_ghi)), '.k', 'MarkerSize', 3)
hold on
plot(Range(areas_pupil_corr_tsd, 's'),  zscore(Data(areas_pupil_corr_tsd)), '.', 'MarkerSize', 3, 'color', [1 0.5 0])
a = Range(smooth_ghi,'s'); len = a(end);
% title('Time evolution of OB gamma and pupil area. Z-scored')
xlim([0 len])
xlabel('Time (s)')
legend({'Gamma', 'Pupil area', 'Domitor inj', 'Antisedan inj'}, 'location', 'southwest')

%% Time Evolution: Smoothed
subplot(312)
plot(Range(smooth_ghi_smooth, 's'), zscore(Data(smooth_ghi_smooth)), '.k', 'MarkerSize', 3)
hold on
plot(Range(areas_pupil_smooth, 's'),  zscore(Data(areas_pupil_smooth)), '.', 'MarkerSize', 3, 'color', [1 0.5 0])
a = Range(smooth_ghi_smooth,'s'); len = a(end);
title(['Smoothed (' num2str(smootime) 's)'])
xlim([0 len])
xlabel('Time (s)')
legend({'Gamma', 'Pupil area'}, 'location', 'southwest')

%% Time Evolution: Labelling states
subplot(313)
hold all
% Wake
plot(Range(g_wake, 's'), Data(g_wake),'.b', 'MarkerSize', 3)
plot(Range(p_wake, 's'), Data(p_wake),'.', 'MarkerSize', 3, 'color', [0.2 0.75 1])
% NREM
plot(Range(g_nrem, 's'), Data(g_nrem),'.r', 'MarkerSize', 3)
plot(Range(p_nrem, 's'), Data(p_nrem),'.','MarkerSize', 3, 'color',[1 0.5 0.75])
% REM
plot(Range(g_rem, 's'), Data(g_rem),'.g', 'MarkerSize', 3)
plot(Range(p_rem, 's'), Data(p_rem),'.','MarkerSize', 3, 'color',[0.75 1 0.5])

a = Range(smooth_ghi,'s'); len = a(end);

xlim([0 len])
% title('Time evolution of OB gamma and pupil area. Z-scored')
xlabel('Time (s)')
% Create legend
lgd = legend({'Gamma Wake', 'Pupil area Wake', 'Gamma NREM', 'Pupil area NREM', 'Gamma REM', 'Pupil area REM'}, 'location', 'southwest');

% legendEntries = lgd.EntryContainer.Children;
% for i = 1:2:length(legendEntries)
%     legendEntries(i).Icon.Transform.Children.Children.Size = 15; % Set desired marker size for legend
% end

%% Correlation scatter (all states)
gamma_data = log10(Data(smooth_ghi));
pupil_data = Data(Restrict(areas_pupil_corr_tsd, smooth_ghi));

figure
sgtitle(['Correlation between the pupil size and OB gamma power ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_data,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
% v1=vline(2.2,'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)');
% xlabel('OB gamma power');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_data,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
% v2=vline(3.7,'-r'); v2.LineWidth=5;
% xlabel('Pupil size (log scale)');
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
plot(gamma_data(1:2000:end) , pupil_data(1:2000:end) , '.k')

axis square
% v1=vline(2.2,'-r'); v1.LineWidth=5;
% v2=hline(3.7,'-r'); v2.LineWidth=5;
% xlim([1.8 2.9])

% plot( zscore(Data(smooth_ghi)), zscore(Data(Restrict(areas_pupil_corr_tsd , smooth_ghi))), '.k')

%% Correlation scatter (all states labeled)
gamma_data = log10(Data(smooth_ghi));
pupil_data = Data(areas_pupil_corr_tsd);

gamma_data_Wake = log10(Data(Restrict(smooth_ghi, Wake)));
gamma_data_NREM = log10(Data(Restrict(smooth_ghi, SWSEpoch)));
gamma_data_REM = log10(Data(Restrict(smooth_ghi, REMEpoch)));

pupil_data_Wake = Data(Restrict(areas_pupil_corr_tsd, Restrict(smooth_ghi, Wake)));
pupil_data_NREM = Data(Restrict(areas_pupil_corr_tsd, Restrict(smooth_ghi, SWSEpoch)));
pupil_data_REM = Data(Restrict(areas_pupil_corr_tsd, Restrict(smooth_ghi, REMEpoch)));

figure
sgtitle(['Correlation between the pupil size and OB gamma power' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_data,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
% v1=vline(2.2,'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)');
% xlabel('OB gamma power');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_data,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
% v2=vline(3.7,'-r'); v2.LineWidth=5;
% xlabel('Pupil size (log scale)');
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
plot(gamma_data_Wake(1:2000:end) , pupil_data_Wake(1:2000:end) , '.b')
plot(gamma_data_NREM(1:2000:end) , pupil_data_NREM(1:2000:end) , '.r')
plot(gamma_data_REM(1:2000:end) , pupil_data_REM(1:2000:end) , '.g')

axis square
% v1=vline(2.2,'-r'); v1.LineWidth=5;
% v2=hline(3.7,'-r'); v2.LineWidth=5;
% xlim([1.8 2.9])

% plot( zscore(Data(smooth_ghi)), zscore(Data(Restrict(areas_pupil_corr_tsd , smooth_ghi))), '.k')

%% Correlation scatter (NREM/Wake)
gamma_data_NREM_WAKE = log10(Data(Restrict(smooth_ghi, or(SWSEpoch, Wake))));
% pupil_data = log10(Data(Restrict(areas_pupil_corr_tsd, Restrict(smooth_ghi, or(SWSEpoch, Wake)))));
pupil_data_NREM_WAKE = Data(Restrict(areas_pupil_corr_tsd, Restrict(smooth_ghi, or(SWSEpoch, Wake))));

figure
sgtitle(['Correlation between the pupil size and OB gamma power: NREM and Wake. ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_data_NREM_WAKE,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
% v1=vline(2.2,'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)');
% xlabel('OB gamma power');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_data_NREM_WAKE,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
% v2=vline(3.7,'-r'); v2.LineWidth=5;
% xlabel('Pupil size (log scale)');
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
plot(gamma_data_NREM_WAKE(1:2000:end) , pupil_data_NREM_WAKE(1:2000:end) , '.k')
% plot(gamma_data(1:1000:end) , pupil_data(1:1000:end) , '.k')

axis square
% v1=vline(2.2,'-r'); v1.LineWidth=5;
% v2=hline(3.7,'-r'); v2.LineWidth=5;
% xlim([1.8 2.9])

% plot( zscore(Data(smooth_ghi)), zscore(Data(Restrict(areas_pupil_corr_tsd , smooth_ghi))), '.k')

%% Correlation scatter (0.1-0.5)
% gamma_data = log10(Data(Restrict(smooth_01_05, or(SWSEpoch, Wake))));
% pupil_data = Data(Restrict(areas_pupil_corr_tsd, Restrict(smooth_ghi, or(SWSEpoch, Wake))));

data_01_05 = log10(Data(smooth_01_05));
pupil_data_01_05 = Data(Restrict(areas_pupil_corr_tsd, smooth_01_05));

figure
sgtitle(['Correlation between the pupil size and OB 0.1-0.5 power. ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(data_01_05,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
% v1=vline(2.2,'-r'); v1.LineWidth=5;
xlabel('OB 0.1-0.5 power (log scale)');
% xlabel('OB gamma power');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_data_01_05,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
% v2=vline(3.7,'-r'); v2.LineWidth=5;
% xlabel('Pupil size (log scale)');
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
plot(data_01_05(1:2000:end) , pupil_data_01_05(1:2000:end) , '.k')
% plot(gamma_data(1:1000:end) , pupil_data(1:1000:end) , '.k')

axis square
% v1=vline(2.2,'-r'); v1.LineWidth=5;
% v2=hline(3.7,'-r'); v2.LineWidth=5;
% xlim([1.8 2.9])

% plot( zscore(Data(smooth_ghi)), zscore(Data(Restrict(areas_pupil_corr_tsd , smooth_ghi))), '.k')

%% Correlation scatter (All non-labeled)
gamma_data = log10(Data(smooth_ghi));
pupil_data = Data(Restrict(areas_pupil_corr_tsd, smooth_ghi));

figure
sgtitle(['Correlation between the pupil size and OB gamma power ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_data,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
% v1=vline(2.2,'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)');
% xlabel('OB gamma power');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_data,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
% v2=vline(3.7,'-r'); v2.LineWidth=5;
% xlabel('Pupil size (log scale)');
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
plot(gamma_data(1:1000:end) , pupil_data(1:1000:end) , '.k')
% plot(gamma_data(1:2000:end) , pupil_data(1:2000:end) , '.k')

axis square
% v1=vline(2.2,'-r'); v1.LineWidth=5;
% v2=hline(3.7,'-r'); v2.LineWidth=5;
% xlim([1.8 2.9])

% plot( zscore(Data(smooth_ghi)), zscore(Data(Restrict(areas_pupil_corr_tsd , smooth_ghi))), '.k')

hold on
% PlotCorrelations_BM(gamma_data(1:1000:end) , pupil_data(1:1000:end), 'color', 'k', 'Marker_Size', 1)
X_to_use = gamma_data(1:1000:end);
Y_to_use = pupil_data(1:1000:end);
[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% Correlation scatter (REM)
gamma_data_REM = log10(Data(Restrict(smooth_ghi, REMEpoch)));
pupil_data_REM = Data(Restrict(areas_pupil_corr_tsd, Restrict(smooth_ghi, REMEpoch)));

figure
sgtitle('Correlation between the pupil size and OB gamma power: REM. 27/02/2023', 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_data_REM,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
% v1=vline(2.2,'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)');
% xlabel('OB gamma power');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_data_REM,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
% v2=vline(3.7,'-r'); v2.LineWidth=5;
% xlabel('Pupil size (log scale)');
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
plot(gamma_data_REM(1:1000:end) , pupil_data_REM(1:1000:end) , '.k')
% plot(gamma_data(1:2000:end) , pupil_data(1:2000:end) , '.k')

axis square
% v1=vline(2.2,'-r'); v1.LineWidth=5;
% v2=hline(3.7,'-r'); v2.LineWidth=5;
% xlim([1.8 2.9])

% plot( zscore(Data(smooth_ghi)), zscore(Data(Restrict(areas_pupil_corr_tsd , smooth_ghi))), '.k')

hold on
% PlotCorrelations_BM(gamma_data(1:1000:end) , pupil_data(1:1000:end), 'color', 'k', 'Marker_Size', 1)
X_to_use = gamma_data_REM(1:1000:end);
Y_to_use = pupil_data_REM(1:1000:end);
[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% Correlation scatter (NREM)
gamma_data_NREM = log10(Data(Restrict(smooth_ghi, SWSEpoch)));
pupil_data_NREM = Data(Restrict(areas_pupil_corr_tsd, Restrict(smooth_ghi, SWSEpoch)));

figure
sgtitle('Correlation between the pupil size and OB gamma power: NREM. 27/02/2023', 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_data_NREM,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
% v1=vline(2.2,'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)');
% xlabel('OB gamma power');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_data_NREM,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
% v2=vline(3.7,'-r'); v2.LineWidth=5;
% xlabel('Pupil size (log scale)');
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
plot(gamma_data_NREM(1:500:end) , pupil_data_NREM(1:500:end) , '.k')
% plot(gamma_data(1:2000:end) , pupil_data(1:2000:end) , '.k')

axis square
% v1=vline(2.2,'-r'); v1.LineWidth=5;
% v2=hline(3.7,'-r'); v2.LineWidth=5;
% xlim([1.8 2.9])

% plot( zscore(Data(smooth_ghi)), zscore(Data(Restrict(areas_pupil_corr_tsd , smooth_ghi))), '.k')
hold on
% PlotCorrelations_BM(gamma_data(1:1000:end) , pupil_data(1:1000:end), 'color', 'k', 'Marker_Size', 1)
X_to_use = gamma_data_NREM(1:1000:end);
Y_to_use = pupil_data_NREM(1:1000:end);
[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend([f(1)],['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% Correlation scatter (Wake)
gamma_data_WAKE = log10(Data(Restrict(smooth_ghi, Wake)));
pupil_data_WAKE = Data(Restrict(areas_pupil_corr_tsd, Restrict(smooth_ghi, Wake)));

figure
sgtitle('Correlation between the pupil size and OB gamma power: Wake. 27/02/2023', 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_data_WAKE,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
% v1=vline(2.2,'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)');
% xlabel('OB gamma power');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_data_WAKE,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
% v2=vline(3.7,'-r'); v2.LineWidth=5;
% xlabel('Pupil size (log scale)');
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
plot(gamma_data_WAKE(1:1000:end) , pupil_data_WAKE(1:1000:end) , '.k')
% plot(gamma_data(1:2000:end) , pupil_data(1:2000:end) , '.k')

axis square
% v1=vline(2.2,'-r'); v1.LineWidth=5;
% v2=hline(3.7,'-r'); v2.LineWidth=5;
% xlim([1.8 2.9])

% plot( zscore(Data(smooth_ghi)), zscore(Data(Restrict(areas_pupil_corr_tsd , smooth_ghi))), '.k')

hold on
% PlotCorrelations_BM(gamma_data(1:1000:end) , pupil_data(1:1000:end), 'color', 'k', 'Marker_Size', 1)
X_to_use = gamma_data_WAKE(1:1000:end);
Y_to_use = pupil_data_WAKE(1:1000:end);
[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% DOMITOR: Before/During/After epochs
% Define the injection epochs
inj_1_time = 25*60; %20240312 domitor
inj_2_time = 53*60;

min_inj_1 = nan(length(time), 1);
min_inj_2 = nan(length(time), 1);

for i = 1:length(time)
    min_inj_1(i) = time(i) - inj_1_time;
    min_inj_2(i) = time(i) - inj_2_time;
end
inj_1_time_idx = find(abs(min_inj_1) == min(abs(min_inj_1)));
inj_2_time_idx = find(abs(min_inj_2) == min(abs(min_inj_2)));

time_before = ts(linspace(time(1)*1e4, time(inj_1_time_idx)*1e4, length(time(1:inj_1_time_idx))));
time_during = ts(linspace(time(inj_1_time_idx+1)*1e4, time(inj_2_time_idx)*1e4, length(time((inj_1_time_idx+1):inj_2_time_idx))));
time_after = ts(linspace(time(inj_2_time_idx+1)*1e4, time(end)*1e4, length(time((inj_2_time_idx+1):end))));

% Restrict data to injection epochs
gamma_before = log10(Data(Restrict(smooth_ghi, time_before)));
pupil_before = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_before));

gamma_during = log10(Data(Restrict(smooth_ghi, time_during)));
pupil_during = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_during));

gamma_after = log10(Data(Restrict(smooth_ghi, time_after)));
pupil_after = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_after));

%% Restricted for domitor

gamma_during(gamma_during > 2.15) = NaN;
pupil_during(find(isnan(gamma_during))) = [];
gamma_during(find(isnan(gamma_during))) = [];

%% DOMITOR: Correlation plot: Pre-Injection
figure
sgtitle(['Correlation between the pupil size and OB gamma power: Pre-injection ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_before,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_before,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
% plot(gamma_before(1:2000:end) , pupil_before(1:2000:end) , '.k')
plot(gamma_before(1:5:end) , pupil_before(1:5:end) , '.k')

axis square

hold on
X_to_use = gamma_before;
Y_to_use = pupil_before;
[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% DOMITOR: Correlation plot: After Domitor Injection
figure
sgtitle(['Correlation between the pupil size and OB gamma power: Domitor Epoch ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_during,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_during,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
% plot(gamma_before(1:2000:end) , pupil_before(1:2000:end) , '.k')
plot(gamma_during(1:5:end) , pupil_during(1:5:end) , '.k')

axis square

hold on
% X_to_use = gamma_during(1:1000:end);
% Y_to_use = pupil_during(1:1000:end);
X_to_use = gamma_during;
Y_to_use = pupil_during;

[R,P] = corr(X_to_use(4:end) , Y_to_use(4:end) , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% DOMITOR: Correlation plot: After Antiseda Injection
figure
sgtitle(['Correlation between the pupil size and OB gamma power: Antisedan Epoch ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_after,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_after,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
% plot(gamma_before(1:2000:end) , pupil_before(1:2000:end) , '.k')
plot(gamma_after(1:5:end) , pupil_after(1:5:end) , '.k')

axis square

hold on
% X_to_use = gamma_after(1:1000:end);
% Y_to_use = pupil_after(1:1000:end);
X_to_use = gamma_after;
Y_to_use = pupil_after;

[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)



%% ATROPINE: Before/After epochs
% Define the injection epochs
inj_1_time = 97*60+30; %20240131 atropine

min_inj_1 = nan(length(time), 1);

for i = 1:length(time)
    min_inj_1(i) = time(i) - inj_1_time;
end
inj_1_time_idx = find(abs(min_inj_1) == min(abs(min_inj_1)));

time_before = ts(linspace(time(1)*1e4, time(inj_1_time_idx)*1e4, length(time(1:inj_1_time_idx))));
time_after = ts(linspace(time(inj_1_time_idx+1)*1e4, time(end)*1e4, length(time((inj_1_time_idx+1):end))));

% Restrict data to injection epochs
gamma_before = log10(Data(Restrict(smooth_ghi, time_before)));
pupil_before = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_before));

gamma_after = log10(Data(Restrict(smooth_ghi, time_after)));
pupil_after = Data(Restrict(Restrict(areas_pupil_corr_tsd, smooth_ghi), time_after));

%% Correlation plot: Pre-Injection
figure
sgtitle(['Correlation between the pupil size and OB gamma power: Pre-injection ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_before,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_before,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
% plot(gamma_before(1:2000:end) , pupil_before(1:2000:end) , '.k')
plot(gamma_before(1:5:end) , pupil_before(1:5:end) , '.k')

axis square

hold on
X_to_use = gamma_before(1:1000:end);
Y_to_use = pupil_before(1:1000:end);
[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

%% Correlation plot: After Domitor Injection
figure
sgtitle(['Correlation between the pupil size and OB gamma power: Atropine Epoch ' date], 'FontWeight', 'bold')
subplot(6,6,32:36)
[Y,X] = hist(gamma_after,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(pupil_after,1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
xlabel('Pupil size');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
hold on
% plot(gamma_before(1:2000:end) , pupil_before(1:2000:end) , '.k')
plot(gamma_after(1:5:end) , pupil_after(1:5:end) , '.k')

axis square

hold on
X_to_use = gamma_after(1:1000:end);
Y_to_use = pupil_after(1:1000:end);
[R,P] = corr(X_to_use , Y_to_use , 'Type', 'Pearson');
p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);
f=get(gca,'Children'); legend(['R = ' num2str(R) '     P = ' num2str(P)]);
l = [xlim ylim];
%     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024

line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'Color' , 'r' , 'LineWidth' , 3)

end