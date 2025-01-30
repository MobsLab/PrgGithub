%%ScriptAnalyseSynchronisationLocalDown
% 05.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%    QuantifHomeostasisPFCdeepFakeDelta ParcoursHomeostasieLocalDeltaOccupancy
%    


clear
Dir = PathForExperimentsLocalDeltaDown('hemisphere');


for p=1%:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p homeo_res
    
    homeo_res.path{p}   = Dir.path{p};
    homeo_res.manipe{p} = Dir.manipe{p};
    homeo_res.name{p}   = Dir.name{p};
    homeo_res.date{p}   = Dir.date{p};
    homeo_res.hemisphere{p}   = Dir.hemisphere{p};
    homeo_res.tetrodes{p} = Dir.tetrodes{p};
    
    %params
    windowsize_density = 60e4; %60s  
    limREM=60;
    edges = 0:2:100;
    
    
    %% load

    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')

    %Stages
    [NREM, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [N1, N2, N3, ~, ~] = GetSubstages;
    
    
    %NREM in ZT
    new_st = Data(Restrict(NewtsdZT, ts(Start(NREM))));
    new_end = Data(Restrict(NewtsdZT, ts(End(NREM))));
    %check duration
    event_dur = End(NREM) - Start(NREM);
    new_event_dur = new_end - new_st;
    event_ok = new_event_dur<1.3*event_dur;
    %new events Epoch
    NREMzt = intervalSet(new_st(event_ok), new_end(event_ok));
    
    %Sync tsd
    load('LocalDownState.mat', 'tSyncLocalDown')
    
    
    
    %% Sleep Cycle
    
    SleepStagesRaw=CreateSleepStages_tsd({NREM,REM,Wake},'y_value',[1 3 4]);
    
    [REM,WakeC,idbad] = CleanREMEpoch(SleepStagesRaw,REM,Wake);
    REMm = mergeCloseIntervals(REM,limREM*1E4);
    Wake  = Wake-REMm; 
    NREM  = NREM-REMm;
    end_rem = End(REMm);
    SleepCycleRaw = intervalSet(end_rem(1:end-1),end_rem(2:end));
    firstSleepCycle = intervalSet(0, end_rem(1));
    SleepCycleRaw = CleanUpEpoch(or(firstSleepCycle,SleepCycleRaw));
    st_cycle = Start(SleepCycleRaw);
    
    for i=1:length(Start(SleepCycleRaw))        
        clear dur_cycle
        dur_cycle = End(and(Wake,subset(SleepCycleRaw,i)),'s')-Start(and(Wake,subset(SleepCycleRaw,i)),'s');
        if ~isempty(dur_cycle)
            for j=1:length(dur_cycle)
                if dur_cycle(j)>10
                    try
                        if dur_cycle(j)>dur_cycle(j-1)
                            st_cycle(i) = End(subset(and(Wake,subset(SleepCycleRaw,i)),j));%st_cycle(i), disp('check 1')
                        end
                    catch
                        st_cycle(i) = End(subset(and(Wake,subset(SleepCycleRaw,i)),j));%st_cycle(i), disp('check 2')
                    end
                end
            end
        end
    end

    SleepCycle  = intervalSet(st_cycle, End(SleepCycleRaw));
    SleepStages = CreateSleepStages_tsd({NREM,REMm,Wake},'y_value',[1 3 4]);
    
    nb_cycle = length(Start(SleepCycle));
    
    
    %% Mean sync value in N1, N2, N3
    Substages = {N1,N2,N3};
    for s=1:length(Substages)
        datasy = Data(Restrict(tSyncLocalDown, Substages{s}));
        [y_hist{s}, x_hist{s}] = histcounts(datasy*100, edges, 'Normalization','probability');
        x_hist{s} = x_hist{s}(1:end-1);
        
        for i=1:length(Start(Substages{s}))
            meansync_substages{s}(i,1) = mean(Data(Restrict(tSyncLocalDown, subset(Substages{s},i))))*100;
        end
    end
    
    
    %% Evolution in cycle
    xq = linspace(0,1,51);
    y_norm = nan(length(xq),nb_cycle);
    
    for i=1:nb_cycle
        y_sync = Data(Restrict(tSyncLocalDown, subset(SleepCycle,i)))*100;
        x_sync = linspace(0,1,length(y_sync))';
        
        y_norm(:,i) = interp1(x_sync, y_sync, xq', 'pchip');
    end
    
    sync_cycle.X     = xq;
    sync_cycle.stdY  = std(y_norm,0,2) / sqrt(size(y_norm,2));
    sync_cycle.meanY = mean(y_norm,2);
    


    %% Plot
    fontsize = 18;
    col_mean = 'k';
    col_curve = [0.8 0.8 0.8];
    colori_sub = {'k', 'b', [0 0.5 0]}; %substage color

    sigtest = 'ttest';
    showPoints = 0;
    showsig = 'sig';
    
    
    %figure
    figure, hold on

    
    %substages sync
    subplot(2,2,1), hold on
    PlotErrorBarN_KJ(meansync_substages, 'newfig',0, 'barcolors',colori_sub(1:3), 'paired',0, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
    set(gca,'xtick',1:3,'XtickLabel',{'N1','N2','N3'},'Fontsize',fontsize)
    ylabel('%Sync');
    title('%Sync per substages'),

    
    %histogram
    subplot(2,2,2), hold on
    for s=1:length(Substages)
        h(s) = plot(x_hist{s}, y_hist{s}, 'color', colori_sub{s}, 'linewidth',2);
    end
    legend(h,'N1','N2','N3'),
    set(gca,'Fontsize',fontsize)
    xlabel('%Sync'), ylabel('probability'),
    title([Dir.name{p} ' - ' Dir.date{p}]);
    
    %cycle
    subplot(2,2,3), hold on
    for c=1:nb_cycle
        plot(sync_cycle.X, y_norm(:,c), 'color', col_curve, 'linewidth',1);
    end
    plot(sync_cycle.X, sync_cycle.meanY, 'color',col_mean, 'linewidth',2),
    xlabel('normalised time in sleep cycle'),
    ylabel('Sync %'), 
    set(gca,'Fontsize',fontsize)
    title('Synchronisation in sleep cycles'),

    
end




