%%PlotExampleRipplesInDown
% 18.09.2019 KJ
%
% Infos
%   Examples figures :
%       - tones in Up states > Down
%
% see
%     PlotExampleRealFakeSlow PlotExampleRipplesInUp
%
%


clear

%params
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244';
channels_pfc = [0 25 26 27];
ch_deep = 0;
ch_sup = 27;
factorLFP = 0.195;
binsize_mua = 2;


starttime = 116788064; endtime = starttime + 1.5e4;




%init
disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)

%NREM
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);

%HPC
load('ChannelsToAnalyse/dHPC_rip.mat', 'channel')
load(['LFPData/LFP' num2str(channel) '.mat'])
HPC = LFP;

%LFP PFCx
nb_channels = length(channels_pfc);
labels_ch = cell(0);
PFC = cell(0);
for ch=1:length(channels_pfc)
    load(['LFPData/LFP' num2str(channels_pfc(ch)) '.mat'])
    PFC{ch} = LFP;
    clear LFP
    labels_ch{ch} = ['Ch ' num2str(channels_pfc(ch))];
end


%MUA & Spikes
MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
load('SpikeData.mat')
load('SpikesToAnalyse/PFCx_Neurons.mat')
S = S(number);
if ~isa(S,'tsdArray')
    S = tsdArray(S);
end

%down
load('DownState.mat', 'down_PFCx')
 
%ripples
[tRipples, ~] = GetRipples;


%% Plot

LitEpoch = intervalSet(starttime,endtime);
%Restrict
clear Signal
ripples_tmp = Range(Restrict(tRipples,LitEpoch));
for tt=1:length(PFC)
    Signal{tt} = Restrict(PFC{tt},LitEpoch);
end

Signal{nb_channels+1} = Restrict(HPC,LitEpoch);
Signal{end} = tsd(Range(Signal{end}), Data(Signal{end})*0.5);
%S
Sepoch = Restrict(S,LitEpoch);


%params plot
gap = [0,0];
offset = [2800 1400 100 -1000 -8000];
colori = {'r', [0.6 0 0],[0.3 0 0],'b','k'};

BarHeight = 1;
BarFraction = 0.8;
LineWidth = 2;


% figure
figure, hold on
subtightplot(5,1,1:3,gap), hold on

%PFC
for tt=1:length(Signal)
    plot(Range(Signal{tt},'ms'),Data(Signal{tt}) + offset(tt), 'color',colori{tt},'linewidth',2)
end
for i=1:length(ripples_tmp)
    line([ripples_tmp(i) ripples_tmp(i)]/10, ylim,'Linewidth',2,'color',[0.4 0.4 0.4],'LineStyle','--'), hold on
end
%options
xlim([starttime endtime]/10),
set(gca, 'xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w')

% Raster
[colorRaster{1:length(Sepoch)}] = deal('k');

subtightplot(5,1,4:5,gap), hold on
for k=1:length(Sepoch)
  sp = Range(Sepoch{k}, 'ms');
  sx = [sp sp repmat(NaN, length(sp), 1)];
  sy = repmat([(k*BarHeight) (k*BarHeight + BarHeight *BarFraction) NaN], length(sp), 1);
  sx = reshape(sx', 1, length(sp)*3);
  sy = reshape(sy', 1, length(sp)*3);

  line(sx, sy, 'Color', colorRaster{k}, 'LineWidth', LineWidth);
  set(gca, 'ylim', [1 length(Sepoch)+1]);

  hold on

end
for i=1:length(ripples_tmp)
    line([ripples_tmp(i) ripples_tmp(i)]/10, ylim,'Linewidth',2,'color',[0.4 0.4 0.4],'LineStyle','--'), hold on
end
xlim([starttime endtime]/10),
set(gca, 'xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w')


%scale bar
line([endtime-0.25e4 endtime-0.05e4]/10,[3 3], 'color','k','LineWidth', 3)
text((endtime-0.15e4)/10,2, '200 ms', 'HorizontalAlignment','center')

















