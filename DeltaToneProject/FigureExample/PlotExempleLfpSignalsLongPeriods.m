%%PlotExempleLfpSignalsLongPeriods
% 04.12.2019 KJ
%
% Infos
%
%
% see
%
%



clear

%params
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243';
ch_deep = 0;
factorLFP = 0.195;
freq_delta = [0.5 4];

%periods
starttime = 2*3600e4; 
duration = 60e4;
endtime = starttime + duration;


%init
disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)


%Substages
load('SleepSubstages.mat', 'Epoch', 'NameEpoch')
SleepStages = CreateSleepStages_tsd(Epoch([3 2 1 4 5]));
NameStages = NameEpoch([3 2 1 4 5]);

%LFP + Filter deep
load(['LFPData/LFP' num2str(ch_deep) '.mat'])
PFCdeep = LFP;
clear LFP
FiltDeep = FilterLFP(PFCdeep, freq_delta, 1024);


%Restrict
starttime = 2*3600e4 + 28.4*60e4;
starttime = 94000000;
starttime = 76200000+120e4;
duration = 2*60e4;
endtime = starttime + duration;

period = intervalSet(starttime, endtime);
LFP_period = Restrict(PFCdeep,period);
Filter_period = Restrict(FiltDeep,period);
Hypno_period = Restrict(SleepStages,period);


%% Plot

figure, hold on
subplot(3,1,1), hold on
h(1) = plot(Range(LFP_period), Data(LFP_period), 'color', 'r');

subplot(3,1,2), hold on
h(2) = plot(Range(Filter_period), Data(Filter_period), 'color', 'k');

subplot(3,1,3), hold on
h(3) = plot(Range(Hypno_period), Data(Hypno_period), 'color', 'k');
ylim([0 6]), 
set(gca, 'ylim',[0 6], 'ytick',1:5, 'yticklabel', NameStages);








