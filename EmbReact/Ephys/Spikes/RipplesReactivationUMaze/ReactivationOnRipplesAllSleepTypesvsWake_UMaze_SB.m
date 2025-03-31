clear all
SessionNames = {'SleepPre','SleepPost','SleepPreSound','SleepPostSound','UMazeCond'};
Binsize = 0.1*1e4;
MiceNumber=[490,507,508,509,514];
vals = [-1:0.1:1];
valsstim = [-3:0.5:3];
TimeAroundDelta = 0.2*1e4;
RemoveDelta = 1;

for mm=1:length(MiceNumber)
    DirTemp = GetAllMouseTaskSessions(MiceNumber(mm));
    
    clear NumRip
    for ss=1:2
        x1 = strfind(DirTemp,[SessionNames{ss} filesep]);
        ToKeep = find(~cellfun(@isempty,x1));
        Dir.(SessionNames{ss}) = DirTemp(ToKeep);
        
        
        Ripples = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'ripples');
        SleepEpochs = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','sleepstates'); % wake - nrem -rem
        
        if RemoveDelta
            Deltas = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'deltawaves');
            DeltaEpoch = mergeCloseIntervals(intervalSet(Start(Deltas)-TimeAroundDelta,Stop(Deltas)+TimeAroundDelta),0.1*1e4);
            RipplesRest = Restrict(Ripples,SleepEpochs{2}-DeltaEpoch);
        else
            RipplesRest = Restrict(Ripples,SleepEpochs{2});
        end
        
        NumRip(ss) = length(RipplesRest);
    end
    NumRipMin{mm} = min(NumRip);
    
    clear templates correlations eigenvalues lambdaMax StimEpoch BadGuysStimAll BadGuysStim BadGuys
    clear templatesStim correlationsStim eigenvaluesStim lambdaMaxStim templatesStimAll correlationsStimAll eigenvaluesStimAll lambdaMaxStimAll
    for ss=1:length(SessionNames)
        
        % Find the session files
        x1 = strfind(DirTemp,[SessionNames{ss} filesep]);
        ToKeep = find(~cellfun(@isempty,x1));
        Dir.(SessionNames{ss}) = DirTemp(ToKeep);
        
        cd(Dir.(SessionNames{ss}){1})
        load('ChannelsToAnalyse/dHPC_rip.mat')
        
        % Load the ripples, spikes and epochs
        Ripples = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'ripples');
        Spikes = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'spikes');
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes = Spikes(numNeurons);
        SleepEpochs = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','sleepstates'); % wake - nrem -rem
        
        if ss==5
            LinPos= ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'linearposition');
            StimEpoch = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','stimepoch');
        end
        
        Q = MakeQfromS(Spikes,Binsize);
        
        if ss<5
            
            if RemoveDelta
                Deltas = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'deltawaves');
                DeltaEpoch = mergeCloseIntervals(intervalSet(Start(Deltas)-TimeAroundDelta,Stop(Deltas)+TimeAroundDelta),0.1*1e4);
                RipplesRest = Restrict(Ripples,SleepEpochs{2}-DeltaEpoch);
            else
                RipplesRest = Restrict(Ripples,SleepEpochs{2});
            end
            
            tsRip = Range(RipplesRest);
            tsRip = tsRip(1:min([NumRipMin{mm},length(tsRip)]))
            RipplesRest = ts(tsRip);
            clear tsRip
        elseif ss==5
            RipplesRest = Restrict(Ripples,thresholdIntervals(LinPos,0.6,'Direction','Above'));
            
        end
        
        %%
        for v = 1:length(vals)-1
            QTemplate = Restrict(Q,mergeCloseIntervals(intervalSet(Range(RipplesRest)+vals(v)*1e4,Range(RipplesRest)+vals(v+1)*1e4),0.05*1e4));
            DatTemplate = Data(QTemplate);
            BadGuys{v}{ss} = find(sum(DatTemplate)==0); % get rid of neurons with zero spikes
            DatTemplate(:,BadGuys{v}{ss}) = [];
            DatTemplate = full(DatTemplate);
            [templates{v}{ss},correlations{v}{ss},eigenvalues{v}{ss},eigenvectors{v}{ss},lambdaMax{v}{ss}] = ActivityTemplates_SB(DatTemplate,0);
        end
        
        if ss==5
            % sliding windown on stim
            for v = 1:length(valsstim)-1
                QTemplate = Restrict(Q,mergeCloseIntervals(intervalSet(Start(StimEpoch)+valsstim(v)*1e4,Start(StimEpoch)+valsstim(v+1)*1e4),0.05*1e4));
                DatTemplate = Data(QTemplate);
                BadGuysStim{v} = find(sum(DatTemplate)==0); % get rid of neurons with zero spikes
                DatTemplate(:,BadGuysStim{v}) = [];
                DatTemplate = full(DatTemplate);
                [templatesStim{v},correlationsStim{v},eigenvaluesStim{v},eigenvectorsStim{v},lambdaMaxStim{v}] = ActivityTemplates_SB(DatTemplate,0);
            end
            
            % all activity around stim
            BroadStimEpoch = mergeCloseIntervals(intervalSet(Start(StimEpoch)-3*1e4,Start(StimEpoch)+3*1e4),0.05*1e4);
            BroadStimEpoch = BroadStimEpoch - intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4);
            QTemplate = Restrict(Q,BroadStimEpoch);
            DatTemplate = Data(QTemplate);
            BadGuysStimAll = find(sum(DatTemplate)==0); % get rid of neurons with zero spikes
            DatTemplate(:,BadGuysStimAll) = [];
            DatTemplate = full(DatTemplate);
            [templatesStimAll,correlationsStimAll,eigenvaluesStimAll,eigenvectorsStimAll,lambdaMaxStimAll] = ActivityTemplates_SB(DatTemplate,0);
            
        end
        
    end
    
    for ss=1:length(SessionNames)
        % Find the session files
        x1 = strfind(DirTemp,[SessionNames{ss} filesep]);
        ToKeep = find(~cellfun(@isempty,x1));
        Dir.(SessionNames{ss}) = DirTemp(ToKeep);
        
        cd(Dir.(SessionNames{ss}){1})
        load('ChannelsToAnalyse/dHPC_rip.mat')
        
        % Load the ripples, spikes and epochs
        Ripples = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'ripples');
        Spikes = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'spikes');
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes = Spikes(numNeurons);
        SleepEpochs = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','sleepstates'); % wake - nrem -rem
        
        if ss==5
            LinPos= ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'linearposition');
            StimEpoch = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','stimepoch');
        end
        
        Q = MakeQfromS(Spikes,Binsize);
        
        % define the trigger events to calc mean reactivation strength and
        % the epochs for z-scoring
        if ss<5
            RipplesRest = Restrict(Ripples,SleepEpochs{2});
            Epoch = SleepEpochs{2};
        elseif ss==5
            RipplesRest = Restrict(Ripples,thresholdIntervals(LinPos,0.6,'Direction','Above'));
            Epoch = thresholdIntervals(LinPos,0.6,'Direction','Above');
            EpochStim = thresholdIntervals(LinPos,0.5,'Direction','Below');
        end
        
        % Used when z-scoring only around the rippl
        %  Epoch = mergeCloseIntervals(intervalSet(Range(RipplesRest)-2*1e4,Range(RipplesRest)+2*1e4),0.05*1e4);
        
        for ss2 = 1:length(SessionNames)
            
            for v = 1:length(vals)-1
                DatMatch = Data(Restrict(Q,Epoch));
                DatMatchTps = Range(Restrict(Q,Epoch));
                
                DatMatch(:,BadGuys{v}{ss2}) = [];
                DatMatch = full(DatMatch);
                strength = ReactivationStrength_SB(DatMatch,templates{v}{ss2});
                
                RemAll = [];
                for comp = 1:size(strength,2)
                    Strtsd = tsd(DatMatchTps,strength(:,comp));
                    [M,T] = PlotRipRaw_SB(Strtsd,(Range(RipplesRest,'s')),1000,0,0);
                    tpsrip = M(:,1);
                    RemAll = [RemAll,M(:,2)];
                end
                
                if not(isempty(RemAll))
                    SlidingReactAll.Ripple.Ripple{ss}{ss2}{mm}{v} = RemAll;
                    SlidingReact.Ripple.Ripple{ss}{ss2}{mm}(v,:) = nanmean(RemAll,2);
                    if size(RemAll,2)>1
                        RemAll(:,1) = [];
                    end
                    SlidingReact2.Ripple.Ripple{ss}{ss2}{mm}(v,:) = nanmean(RemAll,2);
                else
                    SlidingReactAll.Ripple.Ripple{ss}{ss2}{mm}{v} = tpsrip*NaN;
                    SlidingReact.Ripple.Ripple{ss}{ss2}{mm}(v,:) = tpsrip*NaN;
                    SlidingReact2.Ripple.Ripple{ss}{ss2}{mm}(v,:) = tpsrip*NaN;
                end
                
                if ss==5
                    DatMatch = Data(Restrict(Q,EpochStim));
                    DatMatchTps = Range(Restrict(Q,EpochStim));
                    
                    DatMatch(:,BadGuys{v}{ss2}) = [];
                    DatMatch = full(DatMatch);
                    strength = ReactivationStrength_SB(DatMatch,templates{v}{ss2});
                    
                    RemAll = [];
                    for comp = 1:size(strength,2)
                        Strtsd = tsd(DatMatchTps,strength(:,comp));
                        [M,T] = PlotRipRaw_SB(Strtsd,(Start(StimEpoch,'s')),3000,0,0);
                        tpsstim = M(:,1);
                        RemAll = [RemAll,M(:,2)];
                    end
                    
                    
                    if not(isempty(RemAll))
                        SlidingReactAll.Ripple.Stim{ss}{ss2}{mm}{v} = RemAll;
                        SlidingReact.Ripple.Stim{ss}{ss2}{mm}(v,:) = nanmean(RemAll,2);
                        if size(RemAll,2)>1
                            RemAll(:,1) = [];
                        end
                        SlidingReact2.Ripple.Stim{ss}{ss2}{mm}(v,:) = nanmean(RemAll,2);
                    else
                        SlidingReactAll.Ripple.Stim{ss}{ss2}{mm}{v} = tpsstim*NaN;
                        SlidingReact.Ripple.Stim{ss}{ss2}{mm}(v,:) = tpsstim*NaN;
                        SlidingReact2.Ripple.Stim{ss}{ss2}{mm}(v,:) = tpsstim*NaN;
                    end
                    
                    
                end
                
            end
            
            
            if ss2==5
                
                for v = 1:length(valsstim)-1
                    DatMatch = Data(Restrict(Q,Epoch));
                    DatMatchTps = Range(Restrict(Q,Epoch));
                    
                    DatMatch(:,BadGuysStim{v}) = [];
                    DatMatch = full(DatMatch);
                    strength = ReactivationStrength_SB(DatMatch,templatesStim{v});
                    
                    RemAll = [];
                    for comp = 1:size(strength,2)
                        Strtsd = tsd(DatMatchTps,strength(:,comp));
                        [M,T] = PlotRipRaw_SB(Strtsd,(Range(RipplesRest,'s')),1000,0,0);
                        tpsrip = M(:,1);
                        RemAll = [RemAll,M(:,2)];
                    end
                    
                    
                    if not(isempty(RemAll))
                        SlidingReactAll.Stim.Ripple{ss}{mm}{v} = RemAll;
                        SlidingReact.Stim.Ripple{ss}{mm}(v,:) = nanmean(RemAll,2);
                        if size(RemAll,2)>1
                            RemAll(:,1) = [];
                        end
                        SlidingReact2.Stim.Ripple{ss}{mm}(v,:) = nanmean(RemAll,2);
                    else
                        SlidingReactAll.Stim.Ripple{ss}{mm}{v} = tpsrip*NaN;
                        SlidingReact.Stim.Ripple{ss}{mm}(v,:) = tpsrip*NaN;
                        SlidingReact2.Stim.Ripple{ss}{mm}(v,:) = tpsrip*NaN;
                    end
                    
                    
                    
                    if ss==5
                        DatMatch = Data(Restrict(Q,EpochStim));
                        DatMatchTps = Range(Restrict(Q,EpochStim));
                        
                        DatMatch(:,BadGuysStim{v}) = [];
                        DatMatch = full(DatMatch);
                        strength = ReactivationStrength_SB(DatMatch,templatesStim{v});
                        
                        RemAll = [];
                        for comp = 1:size(strength,2)
                            Strtsd = tsd(DatMatchTps,strength(:,comp));
                            [M,T] = PlotRipRaw_SB(Strtsd,(Start(StimEpoch,'s')),3000,0,0);
                            tpsstim = M(:,1);
                            RemAll = [RemAll,M(:,2)];
                        end
                        
                        if not(isempty(RemAll))
                            SlidingReactAll.Stim.Stim{mm}{v} = RemAll;
                            SlidingReact.Stim.Stim{mm}(v,:) = nanmean(RemAll,2);
                            if size(RemAll,2)>1
                                RemAll(:,1) = [];
                            end
                            SlidingReact2.Stim.Stim{mm}(v,:) = nanmean(RemAll,2);
                        else
                            SlidingReactAll.Stim.Stim{mm}{v} = tpsstim*NaN;
                            SlidingReact.Stim.Stim{mm}(v,:) = tpsstim*NaN;
                            SlidingReact2.Stim.Stim{mm}(v,:) = tpsstim*NaN;
                        end
                        
                    end
                    
                    DatMatch = Data(Restrict(Q,Epoch));
                    DatMatchTps = Range(Restrict(Q,Epoch));
                    
                    DatMatch(:,BadGuysStimAll) = [];
                    DatMatch = full(DatMatch);
                    strength = ReactivationStrength_SB(DatMatch,templatesStimAll);
                    
                    RemAll = [];
                    for comp = 1:size(strength,2)
                        Strtsd = tsd(DatMatchTps,strength(:,comp));
                        [M,T] = PlotRipRaw_SB(Strtsd,(Range(RipplesRest,'s')),1000,0,0);
                        tpsrip = M(:,1);
                        RemAll = [RemAll,M(:,2)];
                    end
                    
                    if not(isempty(RemAll))
                        SlidingReact.StimAll.Ripple{ss}{mm} = RemAll;
                        if size(RemAll,2)>1
                            RemAll(:,1) = [];
                        end
                        SlidingReact2.StimAll.Ripple{ss}{mm} = RemAll;
                    else
                        SlidingReact.StimAll.Ripple{ss}{mm} = tpsrip*NaN;
                        SlidingReact2.StimAll.Ripple{ss}{mm} = tpsrip*NaN;
                    end
                    
                    
                end
                
                
            end
            
        end
        
    end
end
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/RippleActivityPFC
save('SlidingReactStimRipplesWithOutDelta.mat','vals','valsstim','tpsrip','tpsstim','SlidingReact2','SlidingReact','SlidingReactAll','NumRipMin')

% load('SlidingReactTake2ZscoreSWSNotRipplesEqualNumRip.mat')
% load('SlidingReactTake2ZscoreSWSNotRipplesEqualNumRipNoDown.mat')

% Ripples just on sleep
figure
for ss1 = 1:length(SessionNames)-1 % template
    for ss2 = 1:length(SessionNames)-1 % data
        
        clear AllSlidingReacttemp
        for mm=1:length(MiceNumber)
            AllSlidingReacttemp(mm,:,:) = SlidingReact2.Ripple.Ripple{ss1}{ss2}{mm};
        end
        AllSlidingReact = squeeze(nanmean(AllSlidingReacttemp,1));
   
        subplot(length(SessionNames)-1,length(SessionNames)-1,ss1+(ss2-1)*(length(SessionNames)-1))
        imagesc(M(:,1),vals,AllSlidingReact)
        clim([0 1.2])
        xlim([-0.5 0.5])
        ylim([-0.5 0.5])
        xlim([-1 1])
        ylim([-1 1])
        if ss2 ==1
            title(SessionNames{ss1})
        end
        xlabel('Time to ripple')
        ylabel('Template time')
        line([0 0],ylim,'color','k')
        line(xlim,[0 0],'color','k')
    end
end


% Ripple templates applied to stim
figure
clf
for ss1 = 1:length(SessionNames) % template
    
    clear AllSlidingReacttemp
    for mm=1:length(MiceNumber)
    AllSlidingReacttemp(mm,:,:) = SlidingReact.Ripple.Stim{5}{ss1}{mm};
    end
    AllSlidingReact = squeeze(nanmean(AllSlidingReacttemp,1));
    AllSlidingReact(:,32) = NaN;
    
    subplot(3,length(SessionNames),ss1)
    imagesc(tpsstim,vals+0.05,AllSlidingReact)
    if ss1==5
        clim([-0.2 1.1])
    else
        clim([-0.1 0.7])
    end
    
    xlim([-2 2])
    ylim([-1 1])
    colorbar
    title(SessionNames{ss1})
    
    xlabel('Time to stim (s) - match')
    ylabel('Tiem to ripple (s) - template ')
    
    line([0 0],ylim,'color',[0.6 0.6 0.6])
    %     line(xlim,[0 0],'color','k')
end


for ss1 = 1:length(SessionNames) % template
    
    
    clear AllSlidingReacttemp
    for mm=1:length(MiceNumber)
        AllSlidingReacttemp(mm,:,:) = SlidingReact.Stim.Ripple{ss1}{mm};
    end
    AllSlidingReact = squeeze(nanmean(AllSlidingReacttemp,1));
    
    subplot(3,length(SessionNames),ss1+5)
    imagesc(tpsrip,valsstim+0.25,AllSlidingReact)
    if ss1==5
        clim([-0.2 1])
    else
        clim([-0.1 1])
        
    end
    %     xlim([-1 1])
    %     ylim([-1 1])
    colorbar
    title(SessionNames{ss1})
    
    xlabel('Time to ripple (s) - match')
    ylabel('Tiem to stim (s) - template ')
    %     line([0 0],ylim,'color','k')
    %     line(xlim,[0 0],'color','k')
end

for ss1 = 1:length(SessionNames) % template
    AllSlidingReact = [];
    for mm=1:length(MiceNumber)
        AllSlidingReact = [AllSlidingReact,SlidingReact.StimAll.Ripple{ss1}{mm}];
    end
    subplot(3,length(SessionNames),ss1+10)
    errorbar(tpsrip,nanmean(AllSlidingReact'),stdError(AllSlidingReact'),'linewidth',2)
    ylim([0 0.6])
    xlabel('Time to ripple (s) - match')
    ylabel('React strength')
    box off
    colorbar
end


% focus on stim template applied to ripples
figure
subplot(4,2,[1,3,5,7])
cols = jet(13);
cols(7,:)=[];
clear Vals
for ss1=1:5
    for v = 7
        AllForV = [];
        for mm=1:length(MiceNumber)
            AllForV = [AllForV,SlidingReactAll.Stim.Ripple{ss1}{mm}{v}];
        end
%         errorbar(tpsrip,nanmean((AllForV)'),stdError((AllForV)'),'linewidth',2)
            plot(tpsrip,nanmean((AllForV)'),'linewidth',2)
        hold on
        Vals{ss1} = nanmean(AllForV(10:12,:));
    end
end
legend(SessionNames(1:5))
box off
set(gca,'FontSize',15,'linewidth',2)
xlabel('Time to ripple')
ylabel('React Strength')

subplot(4,2,[1,3,5,7]+1)
PlotErrorBarN_KJ(Vals,'newfig',0)
set(gca,'XTick',[1,2,3,4,5],'XTickLabel',SessionNames)
xtickangle(45)
box off
set(gca,'FontSize',15,'linewidth',2)
ylabel('React Strength')


for ss1=1:4
    
    subplot(4,2,(ss1-1)*2+2)
        for v = 1:length(valsstim)-1
        AllForV = [];
        for mm=1:length(MiceNumber)
            AllForV = [AllForV,SlidingReactAll.Stim.Ripple{ss1}{mm}{v}];
        end
            plot(tpsrip,nanmean((AllForV)'),'linewidth',2,'color',cols(v,:))
        hold on
    end
ylim([0 1.1])
end

figure
clf
clear Vals
subplot(4,2,[1,3,5,7])
cols = jet(13);
cols(7,:)=[];
for ss1=1:5
        AllForV = [];
        for mm=1:length(MiceNumber)
            AllForV = [AllForV,SlidingReact.StimAll.Ripple{ss1}{mm}];
        end
%         errorbar(tpsrip,nanmean((AllForV)'),stdError((AllForV)'),'linewidth',2)
            plot(tpsrip,nanmean((AllForV)'),'linewidth',2)
        hold on
        Vals{ss1} = nanmean(AllForV(10:12,:));
    
end
legend(SessionNames(1:4))
subplot(4,2,[1,3,5,7]+1)
PlotErrorBarN_KJ(Vals,'newfig',0)
for ss1 = 1:length(SessionNames) % match
    for ss2 = 1:length(SessionNames) % data
        
        AllSlidingReact = SlidingReact1{ss1}{ss2}{1};
        count = 1;
        for mm=2:length(MiceNumber)
            if not(isempty(SlidingReact1{ss1}{ss2}{mm}))
                AllSlidingReact = AllSlidingReact+SlidingReact1{ss1}{ss2}{mm};
                count = count+1;
            end
        end
        AllSlidingReact = AllSlidingReact/count;
        subplot(length(SessionNames),length(SessionNames),ss1+(ss2-1)*length(SessionNames))
        imagesc(M(:,1),vals,AllSlidingReact)
        clim([-0.2 0.9])
        xlim([-0.5 0.5])
        ylim([-0.5 0.5])
        xlim([-1 1])
        ylim([-1 1])
        
        if ss2 ==1
            title(SessionNames{ss1})
        end
        xlabel('Time to ripple')
        ylabel('Template time')
        line([0 0],ylim,'color','k')
        line(xlim,[0 0],'color','k')
        
    end
end

figure
PlotErrorBarN_KJ(Vals,'newfig',0)

% focus on all stim applied to ripples

figure
clear Vals
subplot(4,2,[1,3,5,7])
cols = jet(13);
cols(7,:)=[];
for ss1=1:5
        AllForV = [];
        for mm=1:length(MiceNumber)
            AllForV = [AllForV,SlidingReact.StimAll.Ripple{ss1}{mm}];
        end
%         errorbar(tpsrip,nanmean((AllForV)'),stdError((AllForV)'),'linewidth',2)
            plot(tpsrip,nanmean((AllForV)'),'linewidth',2)
        hold on
        Vals{ss1} = nanmean(AllForV(10:12,:));
    
end
legend(SessionNames(1:5))
box off
set(gca,'FontSize',15,'linewidth',2)
xlabel('Time to ripple')
ylabel('React Strength')

subplot(4,2,[1,3,5,7]+1)
PlotErrorBarN_KJ(Vals,'newfig',0)

set(gca,'XTick',[1,2,3,4,5],'XTickLabel',SessionNames)
xtickangle(45)
box off
set(gca,'FontSize',15,'linewidth',2)
ylabel('React Strength')


figure
clf
for ss1 = 1:length(SessionNames) % match
    for ss2 = 1:length(SessionNames) % data
        
        AllSlidingReact = SlidingReact1{ss1}{ss2}{1};
        count = 1;
        for mm=2:length(MiceNumber)
            if not(isempty(SlidingReact1{ss1}{ss2}{mm}))
                AllSlidingReact = AllSlidingReact+SlidingReact1{ss1}{ss2}{mm};
                count = count+1;
            end
        end
        AllSlidingReact = AllSlidingReact/count;
        subplot(length(SessionNames),length(SessionNames),ss1+(ss2-1)*length(SessionNames))
        imagesc(M(:,1),vals,AllSlidingReact)
        clim([0.2 1.4])
        xlim([-0.5 0.5])
        ylim([-0.5 0.5])
        if ss2 ==1
            title(SessionNames{ss1})
        end
        xlabel('Time to ripple')
        ylabel('Template time')
        line([0 0],ylim,'color','k')
        line(xlim,[0 0],'color','k')
        
    end
end


figure
for ss1 = 1:length(SessionNames) % template
    
    clear AllSlidingReacttemp
    for mm=1:length(MiceNumber)
        AllSlidingReacttemp(mm,:,:) = SlidingReact.Ripple.Ripple{5}{ss1}{mm};
    end
    AllSlidingReact = squeeze(nanmean(AllSlidingReacttemp,1));

    
    subplot(1,length(SessionNames),ss1)
    imagesc(tpsrip,vals,AllSlidingReact)
    if ss1==5
        clim([-0.2 1.4])
    else
        clim([-0.1 0.6])
        
    end
    xlim([-1 1])
    ylim([-1 1])
    colorbar
    title(SessionNames{ss1})
    
    
    xlabel('Time to ripple (s) - match')
    ylabel('Tiem to ripple (s) - template ')
    %     line([0 0],ylim,'color','k')
    %     line(xlim,[0 0],'color','k')
end


figure
clf
ss2=5;
clear AllSlidingReactRem
for ss1 = 1:length(SessionNames) % match
    subplot(1,length(SessionNames),ss1)
    AllSlidingReact = SlidingReact1{ss1}{ss2}{1};
    count = 1;
    for mm=2:length(MiceNumber)
        if not(isempty(SlidingReact1{ss1}{ss2}{mm}))
            AllSlidingReact = AllSlidingReact+SlidingReact1{ss1}{ss2}{mm};
            count = count+1;
        end
    end
    AllSlidingReact = AllSlidingReact/count;
    imagesc(M(:,1),vals,AllSlidingReact)
    clim([-0.2 0.8])
    xlim([-0.5 0.5])
    ylim([-0.5 0.5])
    AllSlidingReactRem(:,ss1) =  AllSlidingReact(12,:);
end



figure
clf
ss2=5;
clear AllSlidingReact
for ss1 = 1:length(SessionNames)-1 % match
    for mm=1:length(MiceNumber)
        try
            AllSlidingReact(mm,:) = SlidingReact2{ss1}{ss2}{mm}(12,:);
        catch
            AllSlidingReact(mm,:) = nan(1,21);
        end
    end
    errorbar(M(:,1),nanmean(AllSlidingReact),stdError(AllSlidingReact),'linewidth',3)
    hold on
end




