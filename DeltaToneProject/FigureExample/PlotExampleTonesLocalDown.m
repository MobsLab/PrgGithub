%%PlotExampleTonesLocalDown
% 18.09.2019 KJ
%
% Infos
%   Examples figures :
%       - tones in Down states > Up
%
% see
%     PlotExampleRealFakeSlow
%
%


clear

%params
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243';
factorLFP = 0.195;
binsize_mua = 2;


starttime = 101890220; endtime = starttime + 2.5e4;
              


%init
disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)

%NREM
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);

%PFC
load('ChannelsToAnalyse/PFCx_locations.mat')
channels_pfc = channels;

%Spikes
load('SpikeData.mat', 'S');
load('SpikesToAnalyse/PFCx_Neurons.mat')
all_neurons = number;
S = S(all_neurons);
if ~isa(S,'tsdArray')
    S = tsdArray(S);
end
%Spike tetrode
load('SpikesToAnalyse/PFCx_tetrodes.mat')
NeuronTetrodes = numbers;
tetrodeChannelsCell = channels;
nb_tetrodes = length(tetrodeChannelsCell);

tetrodeChannels = [];
for tt=1:nb_tetrodes
    tetrodeChannels(tt) = channels_pfc(ismember(channels_pfc,tetrodeChannelsCell{tt}));
end
nb_tetrodes = length(tetrodeChannelsCell);


%LFP PFCx
labels_ch = cell(0);
PFC = cell(0);
for ch=1:length(tetrodeChannels)
    load(['LFPData/LFP' num2str(tetrodeChannels(ch)) '.mat'])
    PFC{ch} = LFP;
    clear LFP
    labels_ch{ch} = ['Ch ' num2str(tetrodeChannels(ch))];
end

 
%tones
load('behavResources.mat', 'ToneEvent')


%% Plot

LitEpoch = intervalSet(starttime,endtime);
%Restrict
tones_tmp = Range(Restrict(ToneEvent,LitEpoch));
for tt=1:length(PFC)
    Signal{tt} = Restrict(PFC{tt},LitEpoch);
end
Sepoch = Restrict(S,LitEpoch);


%params plot
gap = [0,0];
offset = [2800 1400 100 -1000];
colori = {'b', [0 0.5 0], 'r'};

%colors
colorRaster = cell(length(S),1);
for tt=1:nb_tetrodes
    for i=1:length(NeuronTetrodes{tt})
        colorRaster{NeuronTetrodes{tt}(i)} = colori{tt};
    end
end


BarHeight = 1;
BarFraction = 0.8;
LineWidth = 2;


% figure
figure, hold on
subtightplot(2,1,1,gap), hold on

%PFC
for tt=1:length(Signal)
    plot(Range(Signal{tt},'ms'),Data(Signal{tt}) + offset(tt), 'color',colori{tt},'linewidth',2)
end
line([tones_tmp tones_tmp]/10, ylim,'Linewidth',2,'color',[0.4 0.4 0.4],'LineStyle','--'), hold on
%options
xlim([starttime endtime]/10),
set(gca, 'xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w')


% Raster
subtightplot(2,1,2,gap), hold on
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
axis ij, hold on
line([tones_tmp tones_tmp]/10, ylim,'Linewidth',2,'color',[0.4 0.4 0.4],'LineStyle','--'), hold on
xlim([starttime endtime]/10),
set(gca, 'xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w')


%scale bar
line([endtime-0.25e4 endtime-0.05e4]/10,[3 3], 'color','k','LineWidth', 3)
text((endtime-0.15e4)/10,2, '200 ms', 'HorizontalAlignment','center')



















