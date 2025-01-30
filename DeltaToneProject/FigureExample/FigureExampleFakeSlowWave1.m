%%FigureExampleFakeSlowWave1
% 05.09.2019 KJ
%
%   
%   
%
% see
%   


clear

%params
pathexample = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep';
timeexample = 190623000;
% 
% pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243';
% timeexample = 116390000; %in ts


% go to
cd(pathexample)
starttime = timeexample/10;
endtime = starttime + 4000;

%% load

%channel and LFP
load('ChannelsToAnalyse/PFCx_deep.mat')
ch_deep = channel;
load('ChannelsToAnalyse/PFCx_sup.mat')
ch_sup = channel;

load(['LFPData/LFP' num2str(ch_deep) '.mat'])
PFCdeep = LFP;
load(['LFPData/LFP' num2str(ch_sup) '.mat'])
PFCsup = LFP;
clear LFP

load('SpikeData.mat')
load('SpikesToAnalyse/PFCx_l_Neurons.mat')
S_down = S(number);

%Epoch of example
LitEpoch = intervalSet(starttime*10,endtime*10);

%delta waves
load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_deep)])
eval(['Deltadeep = delta_ch_' num2str(ch_deep) ';'])
DeltaExample = and(Deltadeep,LitEpoch);
st_deltas  = Start(DeltaExample,'ms');
end_deltas = End(DeltaExample,'ms');


%% Plot
colorBox = 'm';

figure, hold on

%deep
subplot(6,1,1), hold on
plot(Range(PFCdeep,'ms'),Data(PFCdeep),'color','b','linewidth',1)
xlim([starttime endtime]),
YL=ylim;
for i=1:length(st_deltas)
    x_rec = [st_deltas(i) end_deltas(i) end_deltas(i) st_deltas(i)];
    y_rec = [YL(1) YL(1) YL(2) YL(2)];
    p=patch(x_rec,y_rec,colorBox);
    set(p,'FaceAlpha',0.3);
end
% set(gca,'xtick',[],'ytick',[]),
%sup
subplot(6,1,2), hold on
plot(Range(PFCsup,'ms'),Data(PFCsup),'color','r','linewidth',1)
xlim([starttime endtime]),
YL=ylim;
for i=1:length(st_deltas)
    x_rec = [st_deltas(i) end_deltas(i) end_deltas(i) st_deltas(i)];
    y_rec = [YL(1) YL(1) YL(2) YL(2)];
    p=patch(x_rec,y_rec,colorBox);
    set(p,'FaceAlpha',0.3);
end
% set(gca,'xtick',[]),

subplot(6,1,3:6), hold on
RasterPlot(Restrict(S_down,LitEpoch),'AxHandle',gca);
xlim([starttime endtime]),
% set(gca,'xcolor','k','ycolor','k')

















