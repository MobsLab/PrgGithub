%%PlotExampleLocalDown
% 13.09.2019 KJ
%
% Infos
%   Examples figures as in Sirota 2005
%
% see
%     FindExampleLocalDown1
%
%


clear

%params
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
filename = 'Breath-Mouse-243-09042015.dat';
id_tetrodes = [1 2 3];

starttime = 298443170; 
starttime = 291569600;
starttime = 291043600;
starttime = 317807300;
starttime = 317981330;
duration = 3e4;
endtime = starttime+duration;


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

NeuronTetrodes = NeuronTetrodes(id_tetrodes);
tetrodeChannelsCell = tetrodeChannelsCell(id_tetrodes);
tetrodeChannels = tetrodeChannels(id_tetrodes);
nb_tetrodes = length(tetrodeChannelsCell);


% %LFP PFCx
% labels_ch = cell(0);
% PFC = cell(0);
% for ch=1:nb_tetrodes
%     load(['LFPData/LFP' num2str(tetrodeChannels(ch)) '.mat'])
%     PFC{ch} = LFP;
%     clear LFP
% 
%     labels_ch{ch} = ['Ch ' num2str(tetrodeChannels(ch))];
% end


%%
%down
load('DownState.mat', 'down_PFCx')
GlobalDown = and(down_PFCx,NREM);
load('LocalDownState.mat', 'localdown_PFCx')
AllDown_local = localdown_PFCx;

%deltas
for tt=1:nb_tetrodes
    %distinguish local and global
    [~, ~, ~, idAlocal, ~] = GetIntersectionsEpochs(AllDown_local{tt}, GlobalDown);
    LocalDown{tt} = subset(AllDown_local{tt}, setdiff(1:length(Start(AllDown_local{tt})), idAlocal)');
end

UnionLocal = dropShortIntervals(LocalDown{1},1000);
for tt=2:nb_tetrodes
    UnionLocal = or(UnionLocal,dropShortIntervals(LocalDown{tt},1000));
end


%% Epoch to Plot

LitEpoch = intervalSet(starttime,endtime);

%delta waves and down states
GlobalExample = and(GlobalDown,LitEpoch);
st_global  = Start(GlobalExample,'ms');
end_global = End(GlobalExample,'ms');

LocalExample = and(UnionLocal,LitEpoch);
st_local  = Start(LocalExample,'ms');
end_local = End(LocalExample,'ms');


%
for ch=1:nb_tetrodes

    data_pfc = LoadBinary(filename,'duration',duration/1e4,'frequency',2e4,'nchannels',35,'start',starttime/1e4,'channels',tetrodeChannels(ch)+1);
    tmp = starttime:0.5:starttime+duration-0.5; tmp=tmp';
    
    PFCraw{ch} = tsd(tmp, data_pfc);
    
end


%% Plot

%params plot
alpha = 0.2;
colorGlobal = 'b';
colorLocal = [0.6 0.6 0.6];
gap = [0,0];

offset = -1000 + (0:length(NeuronTetrodes)-1)*2500;

BarHeight = 1;
BarFraction = 0.8;
LineWidth = 4;

%colors
colori = {'b', [0 0.5 0], 'r', [1 0.6 0]};


%%  figure
figure, hold on
subtightplot(2,1,1,gap), hold on
%PFC
for tt=1:length(PFCraw)
%     Signal = Restrict(PFC{tt},LitEpoch);
    plot(Range(PFCraw{tt},'ms'),Data(PFCraw{tt}) + offset(tt), 'color',colori{tt},'linewidth',2)
end
%options
xlim([starttime endtime]/10),
YL=ylim;
% for i=1:length(st_local)
%     x_rec = [st_local(i) end_local(i) end_local(i) st_local(i)];
%     y_rec = [YL(1) YL(1) YL(2) YL(2)];
%     pa=patch(x_rec,y_rec,colorLocal);
%     set(pa,'FaceAlpha',alpha,'EdgeColor','w');
% end
% for i=1:length(st_global)
%     x_rec = [st_global(i) end_global(i) end_global(i) st_global(i)];
%     y_rec = [YL(1) YL(1) YL(2) YL(2)];
%     pa=patch(x_rec,y_rec,colorGlobal);
%     set(pa,'FaceAlpha',alpha,'EdgeColor','w');
% end

set(gca, 'xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w')



% Raster
S_epoch = Restrict(S,LitEpoch);
subtightplot(2,1,2,gap), hold on
k=0;
for tt=1:length(NeuronTetrodes)
    Stet = S_epoch(NeuronTetrodes{tt});
    for j=1:length(Stet)
        k=k+1; %offset
        
        sp = Range(Stet{j}, 'ms');
        sx = [sp sp repmat(NaN, length(sp), 1)];
        sy = repmat([(k*BarHeight) (k*BarHeight + BarHeight *BarFraction) NaN], length(sp), 1);
        sx = reshape(sx', 1, length(sp)*3);
        sy = reshape(sy', 1, length(sp)*3);

        line(sx, sy, 'Color', colori{tt}, 'LineWidth', LineWidth);
        hold on

    end
end
set(gca, 'ylim', [1 k+1], 'xlim', [starttime endtime]/10);

%rectangles
% for i=1:length(st_local)
%     x_rec = [st_local(i) end_local(i) end_local(i) st_local(i)];
%     y_rec = [YL(1) YL(1) YL(2) YL(2)];
%     pa=patch(x_rec,y_rec,colorLocal);
%     set(pa,'FaceAlpha',alpha,'EdgeColor','w');
% end

% for i=1:length(st_global)
%     x_rec = [st_global(i) end_global(i) end_global(i) st_global(i)];
%     y_rec = [YL(1) YL(1) YL(2) YL(2)];
%     pa=patch(x_rec,y_rec,colorGlobal);
%     set(pa,'FaceAlpha',alpha,'EdgeColor','w');
% end
set(gca, 'xtick',[],'ytick',[])
set(gca,'xcolor','w','ycolor','w')


%scale bar
line([endtime-0.25e4 endtime-0.05e4]/10, [4 4], 'color','k','LineWidth', 3)
text((endtime-0.15e4)/10,3, '200 ms', 'HorizontalAlignment','center')


















