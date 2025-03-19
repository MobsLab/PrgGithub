%%SmallIsiDownStates
% 01.04.2018 KJ
%
%
% see
%   
%


clear



Dir=PathForExperimentsBasalSleepSpike;

p=5;

cd(Dir.path{p})


%params
t_start =  -1e4;
t_end = 1e4;
binsize_mua=2;
binsize_met  = 10; %for mETAverage  
nbBins_met   = 400; %for mETAverage 


%LFP 
Signals = cell(0); hemi_channel = cell(0);
load('ChannelsToAnalyse/PFCx_locations.mat','channels')
load(fullfile('LFPData', 'InfoLFP.mat'))

for ch=1:length(channels)
    hemi_channel{ch} = InfoLFP.hemisphere{InfoLFP.channel==channels(ch)};
    hemi_channel{ch} = lower(hemi_channel{ch}(1));
    load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
    Signals{ch} = LFP; clear LFP
    
    ldg{ch} = ['channels ' num2str(channels(ch)) ' - ' hemi_channel{ch}];
end

%MUA
MUA = GetMuaNeurons_KJ('PFCx','binsize',binsize_mua); %2ms


%params down
minDuration = 70;
mergeGap = 0;
thresh_isi = mergeGap+60;
%Down
down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 700, 'mergeGap', mergeGap, 'predown_size', 20, 'method', 'mono');
st_down = Start(down_PFCx);
end_down = End(down_PFCx);
down_duration = End(down_PFCx) - Start(down_PFCx);

%small isi
isi_down = st_down(2:end) - end_down(1:end-1);
idx_isi = [isi_down>=thresh_isi*10;0];
durations = end_down(find(idx_isi==1)+1) - st_down(idx_isi==1);

%met on double down
event_tmp = st_down(idx_isi==1);
event_tmp = event_tmp(durations>2500);% & durations <2500);
for ch=1:length(channels)
    [m,~,tps] = mETAverage(event_tmp, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
    met_lfp{ch}(:,1) = tps; met_lfp{ch}(:,2) = m;
end
[m,~,tps] = mETAverage(event_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_mua(:,1) = tps; met_mua(:,2) = m;


%% PLOT
figure, hold on
subplot(2,1,1), hold on
for ch=1:length(channels)
    h(ch) = plot(met_lfp{ch}(:,1), met_lfp{ch}(:,2)); hold on
end
line([0 0],get(gca,'ylim'), 'color', [0.7 0.7 0.7]), hold on
legend(h, ldg);

subplot(2,1,2), hold on
h(1) = plot(met_mua(:,1), met_mua(:,2)); hold on
line([0 0],get(gca,'ylim'), 'color', [0.7 0.7 0.7]), hold on
legend(h, 'mua');











