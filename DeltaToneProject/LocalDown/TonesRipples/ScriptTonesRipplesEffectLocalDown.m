%%ScriptTonesRipplesEffectLocalDown
% 01.12.2018 KJ
%
%
%
%
% see
%   TonesInUpN2N3Effect   
%


clear

Dir = PathForExperimentsTonesLocalDown;
p=1;
cd(Dir.path{p})
disp(pwd)

%params
binsize_met = 10;
nbBins_met  = 80;
binsize_cc = 5; %10ms
nb_binscc = 200;
binsize_mua = 2;

minDurationLocal = 100*10;

%night info
load('IdFigureData2.mat', 'night_duration')
load('behavResources.mat', 'NewtsdZT')

%tones
load('behavResources.mat', 'ToneEvent')
tones_res.nb_tones = length(ToneEvent);

%substages
load('SleepSubstages.mat','Epoch')
N2 = Epoch{2} ; N3 = Epoch{3};
NREM = or(or(N2,N3), Epoch{1});

%PFC
load('ChannelsToAnalyse/PFCx_locations.mat')
channels_pfc = channels;

%Sync


%% MUA and down

MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);

%Global
load('DownState.mat', 'down_PFCx')
GlobalDown = down_PFCx;

%Spikes
load('SpikeData.mat', 'S');
if ~isa(S,'tsdArray')
    S = tsdArray(S);
end
%Spike tetrode
load('SpikesToAnalyse/PFCx_tetrodes.mat')
nb_tetrodes = length(numbers);
NeuronTetrodes = numbers;
tetrodeChannelsCell = channels;
tetrodeChannels = [];
for tt=1:nb_tetrodes
    tetrodeChannels(tt) = channels_pfc(ismember(channels_pfc,tetrodeChannelsCell{tt}));
end

%Local
load('LocalDownState.mat', 'all_local_PFCx')
all_local_PFCx = all_local_PFCx(Dir.tetrodes{p});
nb_tetrodes = length(all_local_PFCx);
for tt=1:nb_tetrodes
    %distinguish local and global
    [~, ~, ~, idAlocal, ~] = GetIntersectionsEpochs(all_local_PFCx{tt}, GlobalDown);
    LocalDown{tt} = subset(all_local_PFCx{tt}, setdiff(1:length(Start(all_local_PFCx{tt})), idAlocal)');
    LocalDown{tt} = dropShortIntervals(and(LocalDown{tt},NREM), minDurationLocal);

    AllDown_local{tt} = dropShortIntervals(and(all_local_PFCx{tt},NREM), minDurationLocal);
    
    local_neurons{tt} = NeuronTetrodes{tt};
    MUA_local{tt} = MakeQfromS(S(local_neurons{tt}), binsize_mua);
    MUA_local{tt} = tsd(Range(MUA_local{tt}), sum(full(Data(MUA_local{tt})),2));
    
end


%% Correlogram
figure, hold on

subplot(2,2,1), hold on
[C,B] = CrossCorr(Range(ToneEvent), Start(LocalDown{tt}), binsize_cc, nb_binscc);
plot(B,C,'k','linewidth',2),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
title('global')

for tt=1:nb_tetrodes
    subplot(2,2,1+tt), hold on
    [C,B] = CrossCorr(Range(ToneEvent), Start(LocalDown{tt}), binsize_cc, nb_binscc);
    plot(B,C,'k','linewidth',2),
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title(['local ' num2str(tt)])
    
end


%% MUA
figure, hold on

subplot(2,2,1), hold on
[m,~,tps] = mETAverage(Range(ToneEvent), Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
plot(tps,m,'k','linewidth',2),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
title('global')

for tt=1:nb_tetrodes
    subplot(2,2,1+tt), hold on
    [m,~,tps] = mETAverage(Range(ToneEvent), Range(MUA_local{tt}), Data(MUA_local{tt}), binsize_met, nbBins_met);
    plot(tps,m,'k','linewidth',2),
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title(['local ' num2str(tt)])
    
end












