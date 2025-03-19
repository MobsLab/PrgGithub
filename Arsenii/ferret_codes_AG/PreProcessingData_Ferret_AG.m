%%                           ------------- Processing steps -------------

% 1. Upload the data to /media/nas7/React_Passive_AG/OBG/
cd('/media/nas7/React_Passive_AG/OBG/Labneh/')
% 2. Copy the ExpeInfo.mat to the |date| folder
% 3. Convert continuous/events matlab/python with prompt command below

% ~/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/matlab/convertEvents2Mat -p /path/to/your/recording/experimentN/recordingN/continuous/
% ~/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/matlab/convertEvents2Mat -p /path/to/your/recording/experimentN/recordingN/events/
% 

~/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/matlab/convertEvents2Mat -p /media/nas7/React_Passive_AG/OBG/Brynza/2024-02-02_12-39-50_fm_saline/recording1/continuous
~/Dropbox/Kteam/PrgMatlab/OnlinePlaceDecoding/matlab/convertEvents2Mat -p /media/nas7/React_Passive_AG/OBG/Brynza/2024-03-08_11-21-53_hf/recording1/events

% You can make sure it's properly done if you find .dat file in the folder
% 4. Go to the right folder (data, where you have ExpeInfo). Make sure to
% copy ExpeInfo beforehands
% 5. run GUI
GUI_StepOne_ExperimentInfo
% 1.
% MouseNum - number of the ferret
        % Mouse strain - ferret
        % Experimenter - AG
        % Date 
        % SessionName (sleep Session checked)
        % Recording Room - LSP lab
        % Recording environment - MB2 booth
        % Camera type - none
        % Uncheck Optogenetics, Drug injection, Electrical stimulation
        % Click "I'm done" and then "Next step"
    % 2.
        % Num Wideband Channels - 32
        % Num Accelero Channels - 3
        % Num Dig Channels - 0
        % Num Analog Channels - 8
        % Num Digital inputs - 4 
        % Click "I'm done"
        % Check 'Channels to analyse'
            % Here we don't care much about Ref and Bulb Up, but we do care
            % about Bulb Deep. Now we stick to 24, where the gamma is not
            % too high
        % Click "I'm done"
    % 3. 
        % Click "Get files"
        % Is there ephys? - yes
        % Which hardware did we use? - OpenEphys or Mix
        % Number of folders to concatenate - 1
        % Is there behaviour? - no
        % Do you want to clean spikes? - no
        % Click "GetFile" and choose up to the Rhythm folder where you have continuous.dat
        % Put the Session name
        % Check the "Ref done"
        % Click "I'm done"
        % Select the path again
        % Click "I'm done"
        % Grab a coffee and enjoy your free time while it creates event files

%% Sleep Scoring based on OB signals
% Decide on scoring base
SS_base = '0.1-0.5'; % '0.1-0.5' or '1-8'

% Decide on scoring epoch. Based on that, you restrict scoring base to a certain epoch
% Epoch_Case = 'Sleep'; % 'Sleep' ; 'Total-Noise'. Putting 'Sleep' is a bad idea.

SleepScoreObOnly_Ferret(SS_base)


%% Get scoring from cortical activity
clear all

if exist('Ref_Low_Spectrum.mat')==0
    LowSpectrumSB([pwd filesep],1,'Ref');
    disp('Low Ref Spectrum done')
end

load('StateEpochSB.mat', 'Epoch', 'TotalNoiseEpoch', 'ThetaI', 'Wake', 'Sleep', 'smooth_ghi', 'gamma_thresh')
save('StateEpochBM.mat', 'Epoch', 'TotalNoiseEpoch', 'ThetaI', 'Wake', 'Sleep', 'smooth_ghi', 'gamma_thresh')

load('ChannelsToAnalyse/ThetaREM.mat', 'channel')
FindThetaEpoch_Ferret_BM(Sleep,ThetaI,channel,[pwd filesep])

load('StateEpochBM.mat', 'ThetaEpoch','theta_thresh')
REMEpoch = and(Sleep,ThetaEpoch);
SWSEpoch = and(Sleep,Sleep-ThetaEpoch);

Info.theta_thresh = theta_thresh;
Info.gamma_thresh = gamma_thresh;

save('StateEpochBM.mat', 'REMEpoch' , 'SWSEpoch' , 'Info' , '-append')

%
clear all
Figure_SleepScoring_OB_Ferret_BM


%% Load data
load('StateEpochSB.mat', 'chB')
load(['LFPData/LFP', num2str(chB),'.mat']);

load('StateEpochSB.mat', 'MovingEpoch')
load('StateEpochSB.mat', 'ImmobilityEpoch')

load('StateEpochSB.mat', 'smooth_ghi')
load('StateEpochSB.mat', 'smooth_1_8')
load('StateEpochSB.mat', 'smooth_01_05')

load('ChannelsToAnalyse/Bulb_deep.mat'); 

load('B_Middle_Spectrum.mat')
load('B_UltraLow_Spectrum.mat')

load('StateEpochSB.mat', 'Wake','Sleep')
load('behavResources.mat', 'MovAcctsd')

%% Define variables
LFP_Mobile = Restrict(LFP , MovingEpoch); 
LFP_Immobile = Restrict(LFP , ImmobilityEpoch);

smooth_1_8_Mobile = Restrict(smooth_1_8 , MovingEpoch); 
smooth_1_8_Immobile = Restrict(smooth_1_8 , ImmobilityEpoch);

smooth_01_05_Mobile = Restrict(smooth_01_05 , MovingEpoch); 
smooth_01_05_Immobile = Restrict(smooth_01_05 , ImmobilityEpoch);

% OB_Middle_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1}); 
% OB_Middle_Sp_tsd_Wake = Restrict(OB_Middle_Sp_tsd , Wake);
% OB_Middle_Sp_tsd_Sleep = Restrict(OB_Middle_Sp_tsd , Sleep);

LFP_Wake = Restrict(LFP , Wake);
LFP_Sleep = Restrict(LFP , Sleep);

smooth_4060_Mobile = Restrict(smooth_ghi , MovingEpoch); %smooth-4060 is smooth_ghi, right?? According to FindGammaEpoch_AG, yes
smooth_4060_Immobile = Restrict(smooth_ghi , ImmobilityEpoch); 

smootime = 3;
smooth_Acc = tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),ceil(smootime/median(diff(Range(MovAcctsd,'s'))))));
smooth_Acc_Mobile = Restrict(smooth_Acc , MovingEpoch);
smooth_Acc_Immobile = Restrict(smooth_Acc , ImmobilityEpoch);

Acc_Mobile = Restrict(MovAcctsd , MovingEpoch);
Acc_Immobile = Restrict(MovAcctsd , ImmobilityEpoch);

%% Here we create spectrograms for each channel
foldername=pwd;
mkdir('Spectrograms')
cd('./Spectrograms')
mkdir('LFPData')
for channel=8:11 % OB channels of the ferret
    copyfile([foldername filesep 'LFPData/LFP' num2str(channel) '.mat'] , [foldername filesep 'Spectrograms' filesep 'LFPData/LFP' num2str(channel) '.mat'])
    LowSpectrumSB([cd filesep],channel,'B')
    movefile('B_Low_Spectrum.mat',['B_Low_Spectrum_' num2str(channel) '.mat'])
    MiddleSpectrum_BM([cd filesep],channel,'B')
    movefile('B_Middle_Spectrum.mat',['B_Middle_Spectrum_' num2str(channel) '.mat'])
end

cd('./Spectrograms')

Channel={'Numb24','Numb25','Numb26','Numb27','Numb28','Numb29'}; i=1;

load('StateEpochSB.mat', 'Wake')
load('StateEpochSB.mat', 'Sleep')
load('StateEpochSB.mat', 'ImmobilityEpoch')
load('StateEpochSB.mat', 'MovingEpoch')

for channel=24:29
    
    load(['B_Low_Spectrum_' num2str(channel) '.mat'])
    OB_Low_Sp_tsd.(Channel{i}) = tsd(Spectro{2}*1e4 , Spectro{1});
    load(['B_Middle_Spectrum_' num2str(channel) '.mat'])
    OB_Middle_Sp_tsd.(Channel{i}) = tsd(Spectro{2}*1e4 , Spectro{1});
    load(['B_High_Spectrum_' num2str(channel) '.mat'])
    OB_High_Sp_tsd.(Channel{i}) = tsd(Spectro{2}*1e4 , Spectro{1});
    
    OB_Low_Wake.(Channel{i}) = Restrict(OB_Low_Sp_tsd.(Channel{i}) , Wake);
    OB_Middle_Wake.(Channel{i}) = Restrict(OB_Middle_Sp_tsd.(Channel{i}) , Wake);
    OB_High_Wake.(Channel{i}) = Restrict(OB_High_Sp_tsd.(Channel{i}) , Wake);
    OB_Low_Sleep.(Channel{i}) = Restrict(OB_Low_Sp_tsd.(Channel{i}) , Sleep);
    OB_Middle_Sleep.(Channel{i}) = Restrict(OB_Middle_Sp_tsd.(Channel{i}) , Sleep);
    OB_High_Sleep.(Channel{i}) = Restrict(OB_High_Sp_tsd.(Channel{i}) , Sleep);
    
    OB_Low_Mobile.(Channel{i}) = Restrict(OB_Low_Sp_tsd.(Channel{i}) , MovingEpoch);
    OB_Middle_Mobile.(Channel{i}) = Restrict(OB_Middle_Sp_tsd.(Channel{i}) , MovingEpoch);
    OB_High_Mobile.(Channel{i}) = Restrict(OB_High_Sp_tsd.(Channel{i}) , MovingEpoch);
    OB_Low_Immobile.(Channel{i}) = Restrict(OB_Low_Sp_tsd.(Channel{i}) , ImmobilityEpoch);
    OB_Middle_Immobile.(Channel{i}) = Restrict(OB_Middle_Sp_tsd.(Channel{i}) , ImmobilityEpoch);
    OB_High_Immobile.(Channel{i}) = Restrict(OB_High_Sp_tsd.(Channel{i}) , ImmobilityEpoch);

    
%     OB_Low_Mobile.(Channel{i}) = Restrict(OB_Low_Sp_tsd.(Channel{i}) , MovementEpoch);
%     OB_Middle_Mobile.(Channel{i}) = Restrict(OB_Middle_Sp_tsd.(Channel{i}) , MovementEpoch);
%     OB_High_Mobile.(Channel{i}) = Restrict(OB_High_Sp_tsd.(Channel{i}) , MovementEpoch);
%     OB_Low_Immobile.(Channel{i}) = Restrict(OB_Low_Sp_tsd.(Channel{i}) , ImmobilityEpoch);
%     OB_Middle_Immobile.(Channel{i}) = Restrict(OB_Middle_Sp_tsd.(Channel{i}) , ImmobilityEpoch);
%     OB_High_Immobile.(Channel{i}) = Restrict(OB_High_Sp_tsd.(Channel{i}) , ImmobilityEpoch);
    
    i=i+1;
end

% Doesn't work properly for now cause it's too large to save.
save('OB_spectrograms_channels',...
     'OB_Low_Sp_tsd', 'OB_Middle_Sp_tsd', 'OB_High_Sp_tsd',...  
     'OB_Low_Wake', 'OB_Middle_Wake', 'OB_High_Wake',...
     'OB_Low_Sleep' , 'OB_Middle_Sleep', 'OB_High_Sleep',...
     'OB_Low_Mobile', 'OB_Middle_Mobile', 'OB_High_Mobile',...
     'OB_Low_Immobile', 'OB_Middle_Immobile', 'OB_High_Immobile', '-v7.3')
     
%  save('OB_spectrograms_channels_mid_sup', 'OB_Middle_Sp_tsd', 'OB_Middle_Immobile', '-v7.3')

%
cd ..
% load('B_Low_Spectrum.mat'); range_Low = Spectro{3};
% load('B_Middle_Spectrum.mat'); range_Middle = Spectro{3};
load('B_High_Spectrum.mat'); range_High = Spectro{3};
    
%%                                    ------------- Figures -------------

%% Spectrograms
figure

load('B_Low_Spectrum.mat')
range_Low = Spectro{3};

subplot(211)
imagesc(Spectro{2}/60 , Spectro{3} , log10(Spectro{1})'); axis xy
% caxis([0 1e4]) % for 01/12
% caxis([1e2 8e4]) % for 10/12
% caxis([7e2 1.5e5]) % for 12/12
% caxis([1e3 1.5e4]) % for 16/12
ylabel('Frequency (Hz)')
title('OB Low Spectrogram')
colorbar

load('B_Middle_Spectrum.mat')
range_Middle = Spectro{3};

subplot(212)
imagesc(Spectro{2}/60 , Spectro{3} , log10(Spectro{1})'); axis xy
% caxis([0 2e3]) % for 01/12
% caxis([0 2e4]) % for 10/12
% caxis([0 1.5e4]) % for 12/12
% caxis([0 8e3]) % for 16/12

hline(40,'--r')
hline(60,'--r')
xlabel('time (min)'), ylabel('Frequency (Hz)')
title('OB High Spectrogram')
colorbar

a=sgtitle('Spectrograms, sleep session');
a.FontSize=20;

%% Mean spectrum
order = [1 5 6 2 3 4];

figure
subplot(231); i=1;
for channel=order
    plot(range_Low , nanmean(Data(OB_Low_Sp_tsd.(Channel{channel}))) , 'Color' , [0+i*0.1 0+i*0.1 +i*0.1]); hold on
    i=i+1;
end
makepretty; ylim([0 3e4])
title('All Epoch'); ylabel('Power (a.u.)')
legend('Depth1','Depth2','Depth3','Depth4','Depth5','Depth6')
u=text(-8 , 4e3, 'Low frequencies', 'FontSize' , 20 , 'FontWeight', 'bold'), set(u,'Rotation',90)

subplot(234); i=1;
for channel=order
    plot(range_Middle , nanmean(Data(OB_Middle_Sp_tsd.(Channel{channel}))) , 'Color' , [0+i*0.1 0+i*0.1 +i*0.1]); hold on
    i=i+1;
end
makepretty; ylim([0 8e3]); xlim([20 100])
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')
u=text(-15 , 2e2, 'High frequencies', 'FontSize' , 20 , 'FontWeight', 'bold'), set(u,'Rotation',90)


subplot(232); i=1;
for channel=order
    plot(range_Low , nanmean(Data(OB_Low_Wake.(Channel{channel}))) , 'Color' , [0+i*0.1 0+i*0.1 1-i*0.1]); hold on
    i=i+1;
end
makepretty; title('Wake'); 
legend('Depth1','Depth2','Depth3','Depth4','Depth5','Depth6')

subplot(235); i=1;
for channel=order
    plot(range_Middle , nanmean(Data(OB_Middle_Wake.(Channel{channel}))) , 'Color' , [0+i*0.1 0+i*0.1 1-i*0.1]); hold on
    i=i+1;
end
makepretty; ylim([0 8e3]); xlim([20 100])
xlabel('Frequency (Hz)');

subplot(233); i=1;
for channel=order
    plot(range_Low , nanmean(Data(OB_Low_Sleep.(Channel{channel}))) , 'Color' , [1-i*0.1 0+i*0.1 0+i*0.1]); hold on
    i=i+1;
end
makepretty; title('Sleep'); ylim([0 3e4])
legend('Depth1','Depth2','Depth3','Depth4','Depth5','Depth6')

subplot(236); i=1;
for channel=order
    plot(range_Middle , nanmean(Data(OB_Middle_Sleep.(Channel{channel}))) , 'Color' , [1-i*0.1 0+i*0.1 0+i*0.1 ]); hold on
    i=i+1;
end
makepretty; ylim([0 8e3]); xlim([20 100])
xlabel('Frequency (Hz)');

a=sgtitle('Mean spectrums for all LFP wires in OB, sleep session, Labneh'), a.FontSize=20;

%% Histogram gamma power log 10
% [Y,X]=hist(log10(Data(smooth_4060)),1000);
figure
[Y,X]=hist(log10(Data(smooth_ghi)),1000);
Y=Y/sum(Y);
plot(X,Y)
ylabel('#')
xlabel('gamma power value')
u=vline(2.6,'-k'), set(u,'Linewidth',5)



%% Temporal evolution. Wake (Accelerometer, Gamma 40-60 Hz)

load('StateEpochSB.mat', 'MovingEpoch')
load('StateEpochSB.mat', 'ImmobilityEpoch')

smooth_accelero_mobile = Restrict(smooth_Acc, MovingEpoch);
smooth_accelero_immobile = Restrict(smooth_Acc, ImmobilityEpoch);

smooth_ghi_wake = Restrict(smooth_ghi, Wake);
smooth_ghi_sleep = Restrict(smooth_ghi, Sleep);

figure 
sgtitle('Wake-Sleep separation', 'FontSize', 25,'FontWeight','bold')

% Accelerometer
subplot(211)
plot(Range(smooth_accelero_mobile , 's')/60 , log(Data(smooth_accelero_mobile)), '.','MarkerSize',2.5)
hold on
plot(Range(smooth_accelero_immobile , 's')/60 , log(Data(smooth_accelero_immobile)), '.r','MarkerSize',2.5)
% plot(Range(smooth_accelero_mobile , 's')/60 , log(Data(smooth_accelero_mobile)))
% hold on
% plot(Range(smooth_accelero_immobile , 's')/60 , log(Data(smooth_accelero_immobile)), 'Color' , [0.4660 0.6740 0.1880])

ylabel('Movement quantity, log scale')
title('Accelerometer')
xlim([min(Range(smooth_accelero_mobile , 's')/60) max(Range(smooth_accelero_mobile , 's')/60)])
ylim([13 20])
legend('Mobile','Immobile')

set(get(gca, 'XLabel'), 'FontSize', 15);
set(get(gca, 'YLabel'), 'FontSize', 15);
set(gca, 'FontSize', 15);
set(gca,'Linewidth',1)
set(get(gca, 'Title'), 'FontSize', 18);

% Gamma 40-60 Hz
subplot(212)
plot(Range(smooth_ghi_wake , 's')/60 , log(Data(smooth_ghi_wake)), '.','MarkerSize',2.5)
hold on
plot(Range(smooth_ghi_sleep , 's')/60 , log(Data(smooth_ghi_sleep)), '.r','MarkerSize',2.5)
% plot(Range(smooth_ghi_wake , 's')/60 , log(Data(smooth_ghi_wake)))
% hold on
% plot(Range(smooth_ghi_sleep , 's')/60 , log(Data(smooth_ghi_sleep)), 'Color' , [0.4660 0.6740 0.1880])
title('40-60 Hz evolution (gamma)')
ylabel('Power, log scale')
xlabel('Time (min)')
xlim([min(Range(smooth_ghi_wake , 's')/60) max(Range(smooth_ghi_wake , 's')/60)])
ylim([4.5 8])
legend('Wake','Sleep')

set(get(gca, 'XLabel'), 'FontSize', 15);
set(get(gca, 'YLabel'), 'FontSize', 15);
set(gca, 'FontSize', 15);
set(gca,'Linewidth',1)
set(get(gca, 'Title'), 'FontSize', 18);

%% Temporal evolution. Sleep (0.1-0.5, 1-8, 10-20 Hz)
smooth_fact = 1e4;
% Runmean for better display
smooth_01_05_new = tsd(Range(smooth_01_05) , runmean(log(Data(smooth_01_05)),smooth_fact));
smooth_1_8_new = tsd(Range(smooth_1_8) , runmean(log(Data(smooth_1_8)),smooth_fact));
smooth_1020_new = tsd(Range(smooth_1020) , runmean(log(Data(smooth_1020)),smooth_fact));

% Create stages
%0.1-0.5
stage_1_0105 = Restrict(smooth_01_05_new, Epoch_01_05);
stage_2_0105 = Restrict(smooth_01_05_new, Epoch - Epoch_01_05);
stage_wake_0105 = Restrict(smooth_01_05_new, Wake);
%1-8
stage_1_0108 = Restrict(smooth_1_8_new, OneEightEpoch);
stage_2_0108 = Restrict(smooth_1_8_new, Epoch - OneEightEpoch);
stage_wake_0108 = Restrict(smooth_1_8_new, Wake);

stage_1_0108_Sleep = Restrict(stage_1_0108, Sleep);
stage_2_0108_Sleep = Restrict(stage_2_0108, Sleep);
%10-20
stage_1_1020 = Restrict(smooth_1020_new, TenTwentyEpoch);
stage_2_1020 = Restrict(smooth_1020_new, Epoch - TenTwentyEpoch - Wake);
stage_wake_1020 = Restrict(smooth_1020_new, Wake);


figure
sgtitle('States separation', 'FontSize', 25,'FontWeight','bold')

% 0.1-0.5 Hz
subplot(311)
plot(Range(stage_wake_0105 , 's')/60 , Data(stage_wake_0105), '.','MarkerSize',2.5)
hold on
plot(Range(stage_1_0105 , 's')/60 , Data(stage_1_0105), '.','MarkerSize',2.5 , 'Color' , [0.4660 0.6740 0.1880])
plot(Range(stage_2_0105 , 's')/60 , Data(stage_2_0105), '.r','MarkerSize',2.5)

ylabel('Power, log scale')
% xlabel('Time (min)')
title('0.1-0.5 Hz evolution')
xlim([min(Range(stage_wake_0105 , 's')/60) max(Range(stage_wake_0105 , 's')/60)])
ylim([3 8])
legend('Wake','Stage 1','Stage 2')

set(get(gca, 'XLabel'), 'FontSize', 15);
set(get(gca, 'YLabel'), 'FontSize', 15);
set(gca, 'FontSize', 15);
set(gca,'Linewidth',1)
set(get(gca, 'Title'), 'FontSize', 18);

% plot(Range(smooth_01_05 , 's')/60 , runmean(log(Data(smooth_01_05)),smooth_fact))
% plot(Range(Restrict(stage_1_0105, Sleep) , 's')/60 , runmean(log(Data(Restrict(stage_1_0105,Sleep))),smooth_fact))
% plot(Range(Restrict(stage_2_0105, Sleep) , 's')/60 , runmean(log(Data(Restrict(stage_2_0105,Sleep))),smooth_fact), 'r')
% hold on 
% plot(Range(Restrict(smooth_01_05, Wake) , 's')/60 , runmean(log(Data(Restrict(smooth_01_05,Wake))),smooth_fact), 'r')

% 1-8 Hz
subplot(312)
plot(Range(stage_wake_0108 , 's')/60 , Data(stage_wake_0108), '.','MarkerSize',2.5)
hold on
plot(Range(stage_1_0108_Sleep , 's')/60 , Data(stage_1_0108_Sleep), '.','MarkerSize',2.5, 'Color' , [0.4660 0.6740 0.1880])
plot(Range(stage_2_0108_Sleep , 's')/60 , Data(stage_2_0108_Sleep), '.r','MarkerSize',2.5)

ylabel('Power, log scale')
% xlabel('Time (min)')
title('1-8 Hz evolution')
xlim([min(Range(stage_wake_0108 , 's')/60) max(Range(stage_wake_0108 , 's')/60)])
ylim([5.5 8])
% legend('Wake','Stage 1','Stage 2')

set(get(gca, 'XLabel'), 'FontSize', 15);
set(get(gca, 'YLabel'), 'FontSize', 15);
set(gca, 'FontSize', 15);
set(gca,'Linewidth',1)
set(get(gca, 'Title'), 'FontSize', 18);

% plot(Range(Restrict(smooth_1_8 , Sleep) , 's')/60 , runmean(log(Data(Restrict(smooth_1_8,Sleep))),smooth_fact))
% plot(Range(stage_1_0108 , 's')/60 , Data(stage_1_0108))
% hold on
% plot(Range(stage_2_0108 , 's')/60 , Data(stage_2_0108))
% plot(Range(Restrict(stage_1_0108, Sleep) , 's')/60 , runmean(log(Data(Restrict(stage_1_0108,Sleep))),smooth_fact))
% hold on
% plot(Range(Restrict(stage_2_0108, Sleep) , 's')/60 , runmean(log(Data(Restrict(stage_2_0108,Sleep))),smooth_fact), 'r')

% beta 10-20 Hz 
subplot(313)
plot(Range(stage_wake_1020 , 's')/60 , Data(stage_wake_1020), '.','MarkerSize',2.5)
hold on
plot(Range(stage_1_1020 , 's')/60 , Data(stage_1_1020), '.r','MarkerSize',2.5)
plot(Range(stage_2_1020 , 's')/60 , Data(stage_2_1020), '.','MarkerSize',2.5, 'Color' , [0.4660 0.6740 0.1880])

ylabel('Power, log scale')
xlabel('Time (min)')
title('10-20 Hz evolution (Beta range)')
xlim([min(Range(stage_wake_1020 , 's')/60) max(Range(stage_wake_1020 , 's')/60)])
ylim([5 6.5])

set(get(gca, 'XLabel'), 'FontSize', 15);
set(get(gca, 'YLabel'), 'FontSize', 15);
set(gca, 'FontSize', 15);
set(gca,'Linewidth',1)
set(get(gca, 'Title'), 'FontSize', 18);

% plot(Range(smooth_1020 , 's')/60 , runmean(log(Data(smooth_1020)),smooth_fact))
% plot(Range(Restrict(stage_1_1020, Sleep) , 's')/60 , runmean(log(Data(Restrict(stage_1_1020,Sleep))),smooth_fact))
% hold on
% plot(Range(Restrict(stage_2_1020, Sleep) , 's')/60 , runmean(log(Data(Restrict(stage_2_1020,Sleep))),smooth_fact), 'r')

%
figure
subplot(311)
plot(Range(smooth_Acc_Mobile , 's')/60 , log(Data(smooth_Acc_Mobile)))
hold on
plot(Range(smooth_Acc_Immobile , 's')/60 , log(Data(smooth_Acc_Immobile)))
legend('Mobile','Immobile')
ylabel('Movement quantity (log scale)')
title('Accelerometer')

subplot(312)
plot(Range(smooth_4060_Mobile,'s')/60 , Data(smooth_4060_Mobile))
hold on
plot(Range(smooth_4060_Immobile,'s')/60 , Data(smooth_4060_Immobile))
ylabel('Power (a.u.)')
title('Gamma power 40-60Hz')

subplot(313)
plot(Range(smooth_1_8_Mobile,'s')/60 , Data(smooth_1_8_Mobile))
hold on
plot(Range(smooth_1_8_Immobile,'s')/60 , Data(smooth_1_8_Immobile))
xlabel('time (min)'); ylabel('Power (a.u.)')
title('Power 1-8Hz')

a=sgtitle('Temporal evolution, Mobile/Immobile sleep session, Labneh'), a.FontSize=20;

%%          Correlations - smth is wrong here
% MovAcctsd_new = Restrict(smooth_Acc , smooth_4060);
% D1_Mobile = log(Data(Restrict(MovAcctsd_new , MovementEpoch)));
% D2_Mobile = log(Data(Restrict(smooth_4060 , MovementEpoch)));
% D1_Immobile = log(Data(Restrict(MovAcctsd_new , ImmobilityEpoch)));
% D2_immobile = log(Data(Restrict(smooth_4060 , ImmobilityEpoch)));
% 
MovAcctsd_new = Restrict(smooth_Acc , smooth_ghi);
D1_Mobile = log(Data(Restrict(MovAcctsd_new , MovingEpoch)));
D2_Mobile = log(Data(Restrict(smooth_ghi , MovingEpoch)));
D1_Immobile = log(Data(Restrict(MovAcctsd_new , ImmobilityEpoch)));
D2_immobile = log(Data(Restrict(smooth_ghi , ImmobilityEpoch)));

D1 = log(Data(Restrict(MovAcctsd_new , or(intervalSet(0,30*60e4) , intervalSet(120*60e4 , 135*60e4)))));
D2 = log(Data(Restrict(smooth_ghi , or(intervalSet(0,30*60e4) , intervalSet(120*60e4 , 135*60e4)))));
% D1 = log(Data(Restrict(MovAcctsd_new , intervalSet(0 , 135*60e4))));
% D2 = log(Data(Restrict(smooth_ghi , intervalSet(0,135*60e4))));

figure
subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
plot(D2(1:500:end) , D1(1:500:end) , '.k')
set(gca, 'XTick', [], 'YTick', []);
l1 = vline(log(gamma_thresh));
l2 = hline(15.2);
set([l1, l2], 'lineWidth', 3, 'linestyle','-')

t1 = text(5.1, 18, sprintf('Accelero: Mobile\nGamma: Sleep'));
set(t1, 'Fontsize', 12, 'FontWeight', 'normal')

t2 = text(6.8,18, sprintf('Accelero: Mobile\nGamma: Wake'));
set(t2, 'Fontsize', 12, 'FontWeight', 'normal')

t3 = text(5.1,13.8, sprintf('Accelero: Immobile\nGamma: Sleep'));
set(t3, 'Fontsize', 12, 'FontWeight', 'normal')

t3 = text(6.8,13.8, sprintf('Accelero: Immobile\nGamma: Wake'));
set(t3, 'Fontsize', 12, 'FontWeight', 'normal')

subplot(6,6,[1 7 13 19 25])
[Y,X]=hist(D1(1:500:end),1000);
Y=Y/sum(Y);
f1 = plot(X,runmean(Y,5), 'k')
camroll(90)
set(gca, 'YDir','reverse')
set(gca, 'XAxisLocation', 'top')
ylabel('#')
xlabel('Accelerometer values, log scale')
set(gca, 'FontSize', 13')
box off

subplot(6,6,[32:36])
[Y,X]=hist(D2(1:500:end), 1000);
Y=Y/sum(Y);
f1 = plot(X,runmean(Y,5), 'k')
ylabel('#')
xlabel('Gamma power, log scale')
set(gca, 'FontSize', 13')
box off


%
PlotCorrelations_BM(D1_Mobile(1:500:end) , D2_Mobile(1:500:end) , 5 , 0 , 'b')
hold on
PlotCorrelations_BM(D1_Immobile(1:600:end) , D2_immobile(1:600:end) , 5 , 0 , 'r')
xlabel('Accelerometer values (log scale)')
ylabel('Gamma power values (log scale)')
legend('Mobile','Immobile')
title('Correlations gamma power / accelerometer')

%% Distribution
figure
[Y,X]=hist(D2_Mobile,1000);
Y=Y/sum(Y);
plot(X,Y)
hold on


%% Accelerometer during epochs - what is NewMovAcctsd
NewMovAcctsd_new = Restrict(NewMovAcctsd , smooth_ghi);
[Y,X]=hist(log10(Data(MovAcctsd)),1000);
Y=Y/sum(Y);
[Y2,X2]=hist(log10(Data(NewMovAcctsd_new)),1000);
Y2=Y2/sum(Y2);
figure, hold on, 
plot(X,Y,'k')
plot(X2,Y2,'r')

MovAcctsd_S2 = Data(Restrict(NewMovAcctsd_new , S2_epoch));
MovAcctsd_S1 = Data(Restrict(NewMovAcctsd_new , S1_epoch));
MovAcctsd_Wake = Data(Restrict(NewMovAcctsd_new , Wake));
MovAcctsd_Sleep = Data(Restrict(NewMovAcctsd_new , Sleep));

[Y,X]=hist(log10(MovAcctsd_S2),1000);
Y=Y/sum(Y);
plot(X,Y,'r')
hold on

clear Y

[Y,X]=hist(log10(MovAcctsd_S1),1000);
Y=Y/sum(Y);
plot(X,Y,'g')

clear Y

[Y,X]=hist(log10(MovAcctsd_Wake),1000);
Y=Y/sum(Y);
plot(X,Y,'b')
hold on

clear Y

[Y,X]=hist(log10(MovAcctsd_Sleep),1000);
Y=Y/sum(Y);
plot(X,Y,'k')

%% Gamma-Accelero correlation
smootime = 3;
NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),ceil(smootime/median(diff(Range(MovAcctsd,'s'))))));

NewMovAcctsd_new = Restrict(NewMovAcctsd , smooth_ghi);
D1_Mobile = log10(Data(Restrict(NewMovAcctsd_new , MovementEpoch)));
D2_Mobile = log10(Data(Restrict(smooth_ghi , MovementEpoch)));
D1_Immobile = log10(Data(Restrict(NewMovAcctsd_new , ImmobilityEpoch)));
D2_immobile = log10(Data(Restrict(smooth_ghi , ImmobilityEpoch)));

figure
PlotCorrelations_BM(D1_Mobile(1:600:end) , D2_Mobile(1:600:end) , 5 , 0 , 'b')
hold on
PlotCorrelations_BM(D1_Immobile(1:600:end) , D2_immobile(1:600:end) , 5 , 0 , 'r')
xlabel('Accelerometer values (log scale)')
ylabel('Gamma power values (log scale)')
legend('Mobile','Immobile')
title('Correlations gamma power / accelerometer')

%% ok this is just plotting dpeth
figure
 i=1;
for channel=[1:6]
    plot(range_Middle , nanmean(Data(OB_Middle_Wake.(Channel{channel}))) ); hold on
    i=i+1;
end
makepretty; ylim([0 8e3]); xlim([20 100])
xlabel('Frequency (Hz)');


figure

load('B_Low_Spectrum.mat')

figure
imagesc(Spectro{2}/60 , Spectro{3} , Spectro{3}'.*Spectro{1}'); axis xy
% caxis([0 1e4])
caxis([1e2 8e4])
ylabel('Frequency (Hz)')
title('OB Low Spectrogram')

%%
load('B_Middle_Spectrum.mat')

D = Data(OB_Low_Sp_tsd.Numb24)';

LFP_to_use = D(52,:)';

params.fpass=[0.1 20];
params.tapers=[3 5];
movingwin=[3 0.2];
params.Fs=5;
suffix='L';

[Sp,t,f]=mtspecgramc(LFP_to_use,movingwin,params);

Spectro={Sp,t,f};

figure
imagesc(log(Sp)'), axis xy
caxis

save(strcat([filename,struc,'_Low_Spectrum.mat']),'Spectro','ch','-v7.3')

%% Spectrogram of the spectrogram

%% 3D Dynamics and speed of states

%% Dynamics of transitions

%% Ashman's D
edit AshmanD.m

%% Ultralow spectrogram

% if necessary, calculate spectrogram
if exist('B_UltraLow_Spectrum.mat')==0
    load('ChannelsToAnalyse/Bulb_deep.mat')
    UltraLowSpectrumBM([cd filesep],channel,'B')
end
% spectrograms display
load('StateEpochSB.mat', 'Wake','Sleep')
load('B_UltraLow_Spectrum.mat')
 
Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
OB_Low_Sptsd_Wake = Restrict(Sp_tsd , Wake);
OB_Low_Sptsd_Sleep = Restrict(Sp_tsd , Sleep);

figure
subplot(311)
imagesc(Spectro{2}/60 , Spectro{3} , Spectro{1}'), axis xy, caxis([0 4e4])
hline(.11,'--r')
hline(.5,'--r')
subplot(312)
imagesc(Range(OB_Low_Sptsd_Wake)/60e4 , Spectro{3} , Data(OB_Low_Sptsd_Wake)'), axis xy, caxis([0 4e4])
hline(.11,'--r')
hline(.5,'--r')
subplot(313)
imagesc(Range(OB_Low_Sptsd_Sleep)/60e4 , Spectro{3} , Data(OB_Low_Sptsd_Sleep)'), axis xy, caxis([0 4e4])
hline(.11,'--r')
hline(.5,'--r')








