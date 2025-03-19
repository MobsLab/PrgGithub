% FindLocalDown
% 06.04.2017 KJ
%
% detection of local Down States
%   - find down states on each tetrodes of PFCx
%   - plot Mean LFP curves sync on down states detected
%
%   see 
%


clear

%params
Struct = 'PFCx';
binsize = 100; %10ms
thresh0 = 0.7;
minDownDur = 70;
maxDownDur = 500;
mergeGap = 10; % merge
predown_size = 50;
met_window = 500;


%% Load

load StateEpochSB SWSEpoch Wake

disp('Loading SpikeData.mat...')
load SpikeData S tetrodeChannels TT

disp('Getting InfoLFP...')
load LFPData/InfoLFP InfoLFP
chans=InfoLFP.channel(strcmp(InfoLFP.structure,Struct));
disp(['    channels for ',Struct,': ',num2str(chans)])


%% Global Down states 
try
    eval('load SpikesToAnalyse/PFCx_down')
catch
    try
        eval('load SpikesToAnalyse/PFCx_Neurons')
    catch
        try
            eval('load SpikesToAnalyse/PFCx_MUA')
        catch
            number=[];
        end
    end
end
NumNeurons=number;
clear number
T=PoolNeurons(S,NumNeurons);
clear ST
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q=MakeQfromS(ST,binsize*10);
Qsws = Restrict(Q, SWSEpoch);
GlobalDown = FindDown2_KJ(Qsws, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
center_globaldown = (Start(GlobalDown) + End(GlobalDown)) / 2;


%% Down states for each tetrode
if exist('tetrodeChannels','var') && exist('TT','var')
    % find tetrodes from PFCx
    num_tetrode = [];
    lfp_tetrode = [];
    
    for cc=1:length(chans)
        for tt=1:length(tetrodeChannels)
            if ismember(chans(cc), tetrodeChannels{tt})
                num_tetrode = [num_tetrode, tt];
            end
        end
    end
    num_tetrode = unique(num_tetrode);
    
    %loop over tetrodes
    for tt=1:length(num_tetrode)
        
        clear Q Qsws DownSws T 
        %select neurons from the tetrode
        numNeurons = [];
        for i=1:length(S);
            if TT{i}(1)==num_tetrode(tt)
                numNeurons = [numNeurons i];
            end
        end
        
        %create a MUA tsd, with the number of spikes per bin
        T=PoolNeurons(S,numNeurons);
        clear ST
        ST{1}=T;
        try
            ST=tsdArray(ST);
        end
        Q=MakeQfromS(ST,binsize*10);
        %Restrict to period
        Qsws = Restrict(Q, SWSEpoch);
        %Down
        DownSws = FindDown2_KJ(Qsws, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
        
        TetDown{tt} = DownSws;
        
        %select a channel
        lfp_tetrode = [lfp_tetrode tetrodeChannels{num_tetrode(tt)}(1)];
        
    end
    
else
    disp('No neuron found')
    numNeurons = [];
    num_tetrode = [];
    lfp_tetrode = [];
end


%% Mean lfp on down states

%local
for tt=1:length(num_tetrode)
    %load LFP
    eval(['load LFPData/LFP',num2str(lfp_tetrode(tt))])
    %Mean curves of LFP on tetrodes down
    center_down = (Start(TetDown{tt}) + End(TetDown{tt})) / 2;
    Ml_down{tt} = PlotRipRaw(LFP, center_down/1E4, met_window); close
    
end

%global
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
Ml_globaldown = PlotRipRaw(LFPdeep, center_globaldown/1E4, met_window); close


%% Intersection 



%% Plot
figure, hold on

%locals
for tt=1:length(num_tetrode)
    subplot(2,2,tt), hold on
    
    plot(Ml_down{tt}(:,1),Ml_down{tt}(:,2),'r','linewidth',2), hold on
    ylim([-1500 1700]), hold on
    line([0 0],get(gca,'YLim')), hold on
    title(['Tetrode [' num2str(tetrodeChannels{num_tetrode(tt)}) '] - ' num2str(length(Start(TetDown{tt}))) ' down states']), hold on
end
%global
subplot(2,2,4), hold on
plot(Ml_globaldown(:,1),Ml_globaldown(:,2),'r','linewidth',2), hold on
ylim([-1500 1700]), hold on
line([0 0],get(gca,'YLim')), hold on
title(['Global down states - ' num2str(length(center_globaldown)) ' down states']), hold on
    
suplabel('Mean LFP on local down : -500 +500 ms','t');










