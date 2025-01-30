%%ScriptLocalDeltaWavesParietal
% 09.09.2019 KJ
%
% Infos
%   script about local delta waves and parietal
%
% see
%  ParcoursHomeostasieLocalDeltaOccupancy


clear
Dir = PathForExperimentsLocalDeltaDown('hemisphere');

p=5;

disp(' ')
disp('****************************************************************')
cd(Dir.path{p})
disp(pwd)

clearvars -except Dir p homeo_res


%params
binsize_cc = 10; %10ms
nb_binscc = 300;


%% load

%night duration and tsd zt
load('IdFigureData2.mat', 'night_duration')


%NREM
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM - TotalNoiseEpoch;

start_sleep = Start(NREM); 
StartSleep = intervalSet(start_sleep(1), start_sleep(1)+2*3600e4);
end_sleep = End(NREM); 
EndSleep = intervalSet(end_sleep(end)-2*3600e4, end_sleep(end));


%PFC
load('ChannelsToAnalyse/PFCx_locations.mat')
channels_pfc = channels;

%tetrodes
load('SpikesToAnalyse/PFCx_tetrodes.mat','channels')
idtetrodes = Dir.tetrodes{p};
tetrodeChannelsCell = channels;
tetrodeChannels = [];
for tt=1:length(tetrodeChannelsCell)
    tetrodeChannels(tt) = channels_pfc(ismember(channels_pfc,tetrodeChannelsCell{tt}));
end
nb_tetrodes = length(tetrodeChannels);


%% Down

%global
load('DownState.mat', 'down_PFCx')
GlobalDown = down_PFCx;
GlobalStart = and(down_PFCx,StartSleep);
GlobalEnd = and(down_PFCx,EndSleep);


%local
load('LocalDownState.mat', 'localdown_PFCx','localdown_PFCx_Info')
%good tetrodes
AllDown_local = localdown_PFCx(idtetrodes);
NumNeurons = localdown_PFCx_Info.neurons(idtetrodes);
tetrodeChannels = tetrodeChannels(idtetrodes);

for tt=1:nb_tetrodes
    [~, ~, ~, idAlocal, ~] = GetIntersectionsEpochs(AllDown_local{tt}, GlobalDown);
    LocalDown{tt} = subset(AllDown_local{tt}, setdiff(1:length(Start(AllDown_local{tt})), idAlocal)');
end


%% Deltas

%PaCx
load('DeltaWaves.mat', 'deltas_PaCx')
PaDeltas = deltas_PaCx;
PaCxStart = and(PaDeltas,StartSleep);
PaCxEnd = and(PaDeltas,EndSleep);

%MoCx
load('DeltaWaves.mat', 'deltas_MoCx')
MoDeltas = deltas_MoCx;
MoCxStart = and(MoDeltas,StartSleep);
MoCxEnd = and(MoDeltas,EndSleep);


%PFCx Diff
load('DeltaWaves.mat', 'deltas_PFCx')
PFCxDeltas = deltas_PFCx;

%Locals
for tt=1:nb_tetrodes

    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(tetrodeChannels(tt))])
    eval(['a = delta_ch_' num2str(tetrodeChannels(tt)) ';'])
    DeltaWavesTT{tt} = a;

    %global delta and other delta
    [GlobalDelta{tt}, ~, ~,idGlobDelta,~] = GetIntersectionsEpochs(DeltaWavesTT{tt}, GlobalDown);
    OtherDelta{tt} = subset(DeltaWavesTT{tt}, setdiff(1:length(Start(DeltaWavesTT{tt})),idGlobDelta)');

    %Local delta and fake delta
    [LocalDelta{tt}, ~, ~,idLocDelta,~] = GetIntersectionsEpochs(OtherDelta{tt}, LocalDown{tt});
    FakeDelta{tt} = subset(OtherDelta{tt}, setdiff(1:length(Start(OtherDelta{tt})),idLocDelta)');

end


%% Local Cross-corr 
figure, hold on

for i=1:nb_tetrodes
    for j=1:nb_tetrodes
        [C,B] = CrossCorr(Start(LocalDown{i}), Start(LocalDown{j}), binsize_cc, nb_binscc);
        if i==j
            C(B==0)=0;
        end
        
        subplot(nb_tetrodes, nb_tetrodes,(i-1)*nb_tetrodes+j), hold on
        plot(B,C,'k','linewidth',2),
        line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
        xlabel(['time from Local down tet ' num2str(i)]),
        ylabel(['occurence of local tet ' num2str(i)]),
    end    
end


%% Global with local
figure, hold on


for tt=1:nb_tetrodes
    [C,B] = CrossCorr(Start(GlobalDown), Start(LocalDown{tt}), binsize_cc, nb_binscc);
    
    subplot(2,2,tt), hold on
    plot(B,C,'k','linewidth',2),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    xlabel('time from Global Down'),
    ylabel(['occurence of local tet ' num2str(tt)]),
    
    title(['tetrodes ' num2str(tt)]),
end

%% PFCx, MoCx, PaCx
figure, hold on

%PFCx PaCx
subplot(2,2,1), hold on
[C,B] = CrossCorr(Start(GlobalDown), Start(PaDeltas), binsize_cc, nb_binscc);
plot(B,C,'k','linewidth',2),
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
xlabel('time from Global Down PFCx'),
ylabel('occurence of delta PaCx'),
title('PFCx vs PaCx')

%PFCx MoCx
subplot(2,2,2), hold on
[C,B] = CrossCorr(Start(GlobalDown), Start(MoDeltas), binsize_cc, nb_binscc);
plot(B,C,'k','linewidth',2),
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
xlabel('time from Global Down PFCx'), ylabel('occurence of delta MoCx'),
title('PFCx vs MoCx')


%MoCx PaCx
subplot(2,2,3), hold on
[C,B] = CrossCorr(Start(MoDeltas), Start(PaDeltas), binsize_cc, nb_binscc);
plot(B,C,'k','linewidth',2),
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
xlabel('time from Delta MoCx'), ylabel('occurence of delta PaCx'),
title('MoCx vs PaCx')



%% Start & End
figure, hold on

%PFCx PaCx
subplot(2,2,1), hold on
[C,B] = CrossCorr(Start(GlobalStart), Start(PaCxStart), binsize_cc, nb_binscc);
h(1) = plot(B,C,'k','linewidth',1);
[C,B] = CrossCorr(Start(GlobalEnd), Start(PaCxEnd), binsize_cc, nb_binscc);
h(2) = plot(B,C,'b','linewidth',1);
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
xlabel('time from Global Down PFCx'),ylabel('occurence of delta PaCx'),
title('PFCx vs PaCx'), legend(h,'first 2h', 'last 2h'),

%PFCx MoCx
subplot(2,2,2), hold on
[C,B] = CrossCorr(Start(GlobalStart), Start(MoCxStart), binsize_cc, nb_binscc);
h(1) = plot(B,C,'k','linewidth',1);
[C,B] = CrossCorr(Start(GlobalEnd), Start(MoCxEnd), binsize_cc, nb_binscc);
h(2) = plot(B,C,'b','linewidth',1);
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
xlabel('time from Global Down PFCx'), ylabel('occurence of delta MoCx'),
title('PFCx vs MoCx'), legend(h,'first 2h', 'last 2h'),

%MoCx PaCx
subplot(2,2,3), hold on
[C,B] = CrossCorr(Start(MoCxStart), Start(PaCxStart), binsize_cc, nb_binscc);
h(1) = plot(B,C,'k','linewidth',1);
[C,B] = CrossCorr(Start(MoCxEnd), Start(PaCxEnd), binsize_cc, nb_binscc);
h(2) = plot(B,C,'b','linewidth',1);
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
xlabel('time from Delta MoCx'), ylabel('occurence of delta PaCx'),
title('MoCx vs PaCx'), legend(h,'first 2h', 'last 2h'),


%% Cross-corr with Pacx

figure, hold on

%PFCx down - delta PaCx
subplot(2,2,1), hold on
[C,B] = CrossCorr(Start(PaDeltas), Start(GlobalDown), binsize_cc, nb_binscc);
plot(B,C,'k','linewidth',2),
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
xlabel('time from delta PaCx'),
ylabel('occurence of global down PFCx'),
title('global down vs PaCx')


for tt=1:nb_tetrodes
    [C,B] = CrossCorr(Start(PaDeltas), Start(LocalDown{tt}), binsize_cc, nb_binscc);
    
    subplot(2,2,1+tt), hold on
    plot(B,C,'k','linewidth',2),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    xlabel('time from delta PaCx'),
    ylabel(['occurence of local tet ' num2str(tt)]),
    
    title(['tetrodes ' num2str(tt)]),
end


%% Cross-corr with MoCx

figure, hold on

%PFCx down - delta PaCx
subplot(2,2,1), hold on
[C,B] = CrossCorr(Start(MoDeltas), Start(GlobalDown), binsize_cc, nb_binscc);
plot(B,C,'k','linewidth',2),
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
xlabel('time from delta MoCx'),
ylabel('occurence of global down PFCx'),
title('global down vs MoCx')


for tt=1:nb_tetrodes
    [C,B] = CrossCorr(Start(MoDeltas), Start(LocalDown{tt}), binsize_cc, nb_binscc);
    
    subplot(2,2,1+tt), hold on
    plot(B,C,'k','linewidth',2),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    xlabel('time from delta MoCx'),
    ylabel(['occurence of local tet ' num2str(tt)]),
    
    title(['tetrodes ' num2str(tt)]),
end











