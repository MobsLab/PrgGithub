% close all
clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.01*1e4;
MiceNumber=[490,507,508,509]; % excluded 514, too few ripples
num = 1;
cd /home/mobsrick/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples

clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
for mm=1:length(MiceNumber)
    mm
    
    clear eigenvalues Spikes StimEpoch Ripples StimEpoch strength templates correlations eigenvectors lambdaMax
    load(['RippleReactInfo_NewRipples_M',num2str(MiceNumber(mm)),'.mat'])
    Q = MakeQfromS(Spikes,Binsize); % data from the conditionning session
    SpikeRate = tsd(Range(Q),nanmean(Data(Q)')');
    SpikeRate_Z = tsd(Range(Q),nanmean(zscore(Data(Q))')');
    % Trigger on wake ripples
    [M,T] = PlotRipRaw(SpikeRate,Range(Ripples,'s'),1000,0,0);
    MnAct_RipWake(mm,:) = M(:,2);
    [M,T] = PlotRipRaw(SpikeRate_Z,Range(Ripples,'s'),1000,0,0);
    MnAct_RipWakeZ(mm,:) = M(:,2);
    
    
    Sleep = load('/home/mobsrick/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/AllRippleInfo_DiffEpochs.mat','Ripples','Spikes');
    % PreSleep
    Q = MakeQfromS(Sleep.Spikes{mm}.SleepPre,Binsize);
    Q = tsd(full(Range(Q)),full(Data(Q)));
    SpikeRate = tsd(Range(Q),nanmean(full(Data(Q))')');
    SpikeRate_Z = tsd(Range(Q),nanmean(zscore(Data(Q))')');
    
    % Trigger on sleepPre ripples
    [M,T] = PlotRipRaw(SpikeRate,Range(Sleep.Ripples.SleepPre{mm},'s'),1000,0,0);
    MnAct_RipSleepPre(mm,:) = M(:,2);
    [M,T] = PlotRipRaw(SpikeRate_Z,Range(Sleep.Ripples.SleepPre{mm},'s'),1000,0,0);
    MnAct_RipSleepPreZ(mm,:) = M(:,2);
    PreRipEpoch = intervalSet(Range(Sleep.Ripples.SleepPre{mm})-2*1e4,Range(Sleep.Ripples.SleepPre{mm})-1*1e4);
    RipEpoch = intervalSet(Range(Sleep.Ripples.SleepPre{mm})-0.5*1e4,Range(Sleep.Ripples.SleepPre{mm})+0.5*1e4);
    dat = Restrict(Q,PreRipEpoch-RipEpoch);
    Mn_Spikes_SleepPre{mm} = full(nanmean(Data(dat)));
    for neur = 1:size()
    
    % PostSleep
    Q = MakeQfromS(Sleep.Spikes{mm}.SleepPost,Binsize);
    Q = tsd(full(Range(Q)),full(Data(Q)));
    SpikeRate = tsd(Range(Q),nanmean(Data(Q)')');
    SpikeRate_Z = tsd(Range(Q),nanmean(zscore(Data(Q))')');
    % Trigger on sleepPost ripples
    [M,T] = PlotRipRaw(SpikeRate,Range(Sleep.Ripples.SleepPost{mm},'s'),1000,0,0);
    MnAct_RipSleepPost(mm,:) = M(:,2);
    [M,T] = PlotRipRaw(SpikeRate_Z,Range(Sleep.Ripples.SleepPost{mm},'s'),1000,0,0);
    MnAct_RipSleepPostZ(mm,:) = M(:,2);
    PreRipEpoch = intervalSet(Range(Sleep.Ripples.SleepPost{mm})-2*1e4,Range(Sleep.Ripples.SleepPost{mm})-1*1e4);
    RipEpoch = intervalSet(Range(Sleep.Ripples.SleepPost{mm})-0.5*1e4,Range(Sleep.Ripples.SleepPost{mm})+0.5*1e4);
    dat = Restrict(Q,PreRipEpoch-RipEpoch);
    Mn_Spikes_SleepPost{mm} = full(nanmean(Data(dat)));
    
end

AllPre = [];
AllPost = [];
for mm=1:length(MiceNumber)
    hold on
    plot( Mn_Spikes_SleepPre{mm}, Mn_Spikes_SleepPost{mm},'*')
    AllPre = [AllPre,Mn_Spikes_SleepPre{mm}];
    AllPost = [AllPost,Mn_Spikes_SleepPost{mm}];
    
end


MakeSpreadAndBoxPlot_SB({log10(AllPre),log10(AllPost)}, {} ,[],{},0,0 )