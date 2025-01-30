clear all
MiceNumber=[490,507,508,509,510,512,514];
epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
SessionNames = {'Extinction'};
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';

for mm=1:length(MiceNumber)
    FileNames  =GetAllMouseTaskSessions(MiceNumber(mm),0);
    
    %% Habituation decoder
    figure
    cd(FileNames{2})
    load('SpikeData.mat')
    load('behavResources_SB.mat')
    load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
    Q = MakeQfromS(S,1*1E4);
    Q_z = tsd(Range(Q),(zscore(Data(Q))')');
    SecondHalf = intervalSet(400*1E4,800*1E4);
    Sk = and(SecondHalf,or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{4})) - Behav.FreezeEpoch;
    Sf = and(Behav.ZoneEpoch{2},SecondHalf) - Behav.FreezeEpoch;
    HabVect = nanmean(full(Data(Restrict(Q,Sk)))) - nanmean(full(Data(Restrict(Q,Sf))));
    subplot(121)
    plot(Data(Restrict(Behav.LinearDist,ts(Range(Q)))),Data(Q_z)*HabVect' ,'.')
    title('Hab / Hab')
    
    for ii = 4:7
        cd(FileNames{ii})
        load('SpikeData.mat')
        load('behavResources_SB.mat')
        load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
        Q = MakeQfromS(S,1*1E4);
        Q_z = tsd(Range(Q),(zscore(Data(Q))')');
        subplot(122)
        plot(Data(Restrict(Behav.LinearDist,ts(Range(Q)))),Data(Q_z)*HabVect','.')
        hold on
    end
    title('Hab / Testpre')
    
    
    
    %% Extinction decoder
    figure
    cd(FileNames{18})
    load('SpikeData.mat')
    load('behavResources_SB.mat')
    load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
    Q = MakeQfromS(S,1*1E4);
    Q_z = tsd(Range(Q),(zscore(Data(Q))')');
    SecondHalf = intervalSet(0*1E4,800*1E4);
    Sk = and(SecondHalf,Behav.ZoneEpoch{4}) - Behav.FreezeEpoch;
    Sf = and(Behav.ZoneEpoch{2},SecondHalf) - Behav.FreezeEpoch;
    HabVect = nanmean(full(Data(Restrict(Q,Sk)))) - nanmean(full(Data(Restrict(Q,Sf))));
    subplot(131)
    plot(Data(Restrict(Behav.LinearDist,ts(Range(Q)))),Data(Q_z)*HabVect' - movmean(Data(Q_z)*HabVect',500),'.')
    title('Ext / Ext')
    
    for ii = 14:17
        cd(FileNames{ii})
        load('SpikeData.mat')
        load('behavResources_SB.mat')
        load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
        Q = MakeQfromS(S,1*1E4);
        Q_z = tsd(Range(Q),(zscore(Data(Q))')');
        SecondHalf = intervalSet(0*1E4,800*1E4);
        Sk = and(SecondHalf,or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{4}));
        Sf = and(Behav.ZoneEpoch{2},SecondHalf);
        subplot(132)
        plot(Data(Restrict(Behav.LinearDist,ts(Range(Q)))),Data(Q_z)*HabVect','.')
        hold on
    end
    title('Ext / Testpost')
    
    for ii = 8:12
        cd(FileNames{ii})
        load('SpikeData.mat')
        load('behavResources_SB.mat')
        load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
        Q = MakeQfromS(S,1*1E4);
        Q_z = tsd(Range(Q),(zscore(Data(Q))')');
        subplot(133)
        plot(Data(Restrict(Behav.LinearDist,ts(Range(Q)))),Data(Q_z)*HabVect' ,'.')
        hold on
    end
    title('Ext / Cond')
    
    %% Cond decoder
    figure
    cd(FileNames{9})
    load('SpikeData.mat')
    load('behavResources_SB.mat')
    load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
    Q = MakeQfromS(S,1*1E4);
    Q_z = tsd(Range(Q),zscore(zscore(Data(Q))')');
    SecondHalf = intervalSet(0*1E4,800*1E4);
    Sk = and(SecondHalf,Behav.ZoneEpoch{4});
    Sf = and(Behav.ZoneEpoch{2},SecondHalf);
    HabVect = nanmean(full(Data(Restrict(Q,Sk)))) - nanmean(full(Data(Restrict(Q,Sf))));
%     subplot(131)
    plot(Data(Restrict(Behav.LinearDist,ts(Range(Q)))),Data(Q_z)*HabVect','.')
    title('Cond / Cond')
    
    for ii = 14:17
        cd(FileNames{ii})
        load('SpikeData.mat')
        load('behavResources_SB.mat')
        load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
        Q = MakeQfromS(S,1*1E4);
        Q_z = tsd(Range(Q),(zscore(Data(Q))')');
        SecondHalf = intervalSet(0*1E4,800*1E4);
        Sk = and(SecondHalf,or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{4}));
        Sf = and(Behav.ZoneEpoch{2},SecondHalf);
        subplot(132)
        plot(Data(Restrict(Behav.LinearDist,ts(Range(Q)))),Data(Q_z)*HabVect' ,'.')
        hold on
    end
    title('Ext / Testpost')
    
    for ii = 8:12
        cd(FileNames{ii})
        load('SpikeData.mat')
        load('behavResources_SB.mat')
        load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
        Q = MakeQfromS(S,1*1E4);
        Q_z = tsd(Range(Q),(zscore(Data(Q))')');
        subplot(133)
        plot(Data(Q_z)*HabVect','.')
        hold on
    end
    title('Cond / Cond')
    
    
end

close all
for mm = 1:6
    figure
    FileNames  =GetAllMouseTaskSessions(MiceNumber(mm),0);
    
    AllSk = [];
    AllSf = [];
    AllSk_PT = [];
    AllSf_PT = [];
    for ii = 8:12
        clear Behav LocalFreq Sk Sf
        cd(FileNames{ii})
        load('behavResources_SB.mat')
        load('InstFreqAndPhase_B.mat')
        
        %     SmooAcctsd = tsd(Range(Behav.MovAcctsd),movmean(Data(Behav.MovAcctsd),20));
        %     Behav.FreezeEpoch = thresholdIntervals(SmooAcctsd,1E7,'Direction','Below');
        %     Behav.FreezeEpoch = dropShortIntervals(Behav.FreezeEpoch,3*1E4);
        %
        Sk = and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{4}));
        Sf = and(or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}),Behav.FreezeEpoch);
        AllSk = [AllSk;Data(Restrict(LocalFreq.WV,Sk))];
        AllSf = [AllSf;Data(Restrict(LocalFreq.WV,Sf))];
        AllSk_PT = [AllSk_PT;Data(Restrict(LocalFreq.PT,Sk))];
        AllSf_PT = [AllSf_PT;Data(Restrict(LocalFreq.PT,Sf))];
        
        
    end
    
    
    subplot(221)
    nhist({AllSk_PT,AllSf_PT})
    
    subplot(222)
    nhist({AllSk,AllSf})
    
    subplot(223)
    plot(movmedian(AllSk_PT,10))
    hold on
    plot(movmedian(AllSf_PT,10))
    legend('sk','sf')
    
    subplot(224)
    plot(movmedian(AllSk,100))
    hold on
    plot(movmedian(AllSf,100))
    
end


MiceNumber=[490,507,508,509,510,512,514];

close all
for mm = 1:6
    figure
    FileNames  =GetAllMouseTaskSessions(MiceNumber(mm),0);
    
    AllBr = [];
    AllPos = [];
    AllBr_PT = [];
    for ii = 8:12
        clear Behav LocalFreq Sk Sf
        cd(FileNames{ii})
        load('behavResources_SB.mat')
        load('InstFreqAndPhase_B.mat')
        
        AllBr = [AllBr;Data(Restrict(LocalFreq.WV,Behav.FreezeEpoch))];
        AllBr_PT = [AllBr_PT;Data(Restrict(LocalFreq.PT,Behav.FreezeEpoch))];
        AllPos = [AllPos;Data(Restrict(Behav.LinearDist,Behav.FreezeEpoch))];
        
    end
    
    
    AllBr_clean = movmax(movmin(AllBr,100),400);
    tps = [0.008:0.008:0.008*length(AllBr_clean)];
    
    
    tps_Pos = [0.051:0.051:0.051*length(AllPos)];
    Pos_int = interp1(tps_Pos,AllPos,tps);
    scatter(tps,AllBr_clean,40,Pos_int,'filled')
    colorbar
    colormap(redblue)
    colormap(fliplr(redblue))
    caxis([0 1])
end