close all
clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.1*1e4;
MiceNumber=[490,507,508,509,514];
num = 1;
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples

clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
for mm=1:length(MiceNumber)
    mm
    
    clear eigenvalues Spikes StimEpoch Ripples StimEpoch
    load(['RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'])
    Q = MakeQfromS(Spikes,Binsize);
    
    
    % Define the template epochs
    StimEpochToRemove = intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4);
    RipEpochToRemove = intervalSet(Range(Ripples)-0.2*1e4,Range(Ripples)+0.4*1e4);
    TotEpoch = intervalSet(0,max(Range(Vtsd)));
    Ripples = Restrict(Ripples,TotEpoch-NoiseEpoch);
    Ripples = Restrict(Ripples,thresholdIntervals(LinPos,0.6,'Direction','Above'));
    
    clear Epoch
    Epoch.Shock=thresholdIntervals(LinPos,0.2,'Direction','Below')-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.ShockMov=and(MovEpoch,Epoch.Shock)-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.Poststim=intervalSet(Start(StimEpoch)+0.3*1e4,Start(StimEpoch)+0.9*1e4)-StimEpochToRemove;
    Epoch.PreStim=intervalSet(Start(StimEpoch)-2*1e4,Start(StimEpoch)-1.4*1e4)-StimEpochToRemove;
    Epoch.ShockFreeze=and(FreezeEpoch,Epoch.Shock)-or(StimEpochToRemove,RipEpochToRemove);
    
    Epoch.Safe=thresholdIntervals(LinPos,0.8,'Direction','Above')-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.SafeMov=and(MovEpoch,Epoch.Safe)-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.PostRipples=mergeCloseIntervals(intervalSet(Range(Ripples)-0.05*1e4,Range(Ripples)+0.12*1e4),0.1*1e4)-StimEpochToRemove;
    Epoch.PreRipples=(mergeCloseIntervals(intervalSet(Range(Ripples)-0.85*1e4,Range(Ripples)-0.72*1e4),0.1*1e4)-StimEpochToRemove)-Epoch.PostRipples;
    Epoch.SafeFreeze=and(FreezeEpoch,Epoch.Safe)-or(StimEpochToRemove,RipEpochToRemove);
    
    EpochNames = fieldnames(Epoch);
    
    clear templates correlations eigenvalues eigenvectors lambdaMax DatPoints GlobalCorr
    for k = 1:length(EpochNames)
        
        % Template
        QTemplate = Restrict(Q,Epoch.(EpochNames{k}));
        DatTemplate = Data(QTemplate);
        BadGuys.(EpochNames{k}) = find(sum(DatTemplate)==0);
        DatTemplate(:,BadGuys.(EpochNames{k})) = [];
        DatTemplate = full(DatTemplate);
        % Match
        DatMatch = Data(Q);
        DatMatch(:,BadGuys.(EpochNames{k})) = [];
        DatMatch = full(DatMatch);
        
        DatPoints.(EpochNames{k}) = size(DatTemplate,1);
        doEmpty=0;
        
        if not(isempty(DatTemplate))
            % My Code
            [templates.(EpochNames{k}),correlations.(EpochNames{k}),eigenvalues.(EpochNames{k}),eigenvectors.(EpochNames{k}),lambdaMax.(EpochNames{k})] = ActivityTemplates_SB(DatTemplate,0);
            strength = ReactivationStrength_SB(DatMatch,templates.(EpochNames{k}));
            if not(isempty(templates.(EpochNames{k})))
                for comp = 1:size(templates.(EpochNames{k}),3)
                    Strtsd = tsd(Range(Q),strength(:,comp));
                    [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),3000,0,0);
                    SaveTriggeredStim{mm}{k}(comp,:) = M(:,2);
                    [M,T] = PlotRipRaw(Strtsd,Range(Ripples,'s'),1000,0,0);
                    SaveTriggeredRipples{mm}{k}(comp,:) = M(:,2);
                    
                end
            else
                doEmpty=1;
            end
            
            % Adrien's code
            [R,phi,PCs] = ReactStrength(DatTemplate,DatMatch,'method','ica');
            keyboard
            if not(isempty(R))
                for comp = 1:size(R,2)
                    Strtsd = tsd(Range(Q),R(:,comp));
                    [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),3000,0,0);
                    tpsstim = M(:,1);
                    SaveTriggeredStim_Ad{mm}{k}(comp,:) = M(:,2);
                    [M,T] = PlotRipRaw(Strtsd,Range(Ripples,'s'),1000,0,0);
                    SaveTriggeredRipples_Ad{mm}{k}(comp,:) = M(:,2);
                    tpsrip = M(:,1);
                end
            else
                doEmpty=1;
            end
        else
            doEmpty=1;
        end
        
        if doEmpty
            QSum = tsd(Range(Q),full(sum(Data(Q)'))');
            [M,T] = PlotRipRaw(QSum,Start(StimEpoch,'s'),3000,0,0);
            SaveTriggeredStim_Ad{mm}{k}(1,:) = M(:,2)*nan;
            SaveTriggeredStim{mm}{k}(1,:) =  M(:,2)*nan;
            [M,T] = PlotRipRaw(QSum,Range(Ripples,'s'),1000,0,0);
            SaveTriggeredRipples_Ad{mm}{k}(1,:) = M(:,2)*nan;
            SaveTriggeredRipples{mm}{k}(1,:) = M(:,2)*nan;
            
        end
    end
end

figure

%% Triggered events
for k = 1:10
    AllTriggeredStim{k} = [];
    AllTriggeredRipples{k} = [];
end

for mm=1:length(MiceNumber)
    for k = 1:10
        if sum(size(SaveTriggeredStim{mm}{k}))>2
            AllTriggeredStim{k} = [AllTriggeredStim{k};SaveTriggeredStim_Ad{mm}{k}];
        end
        if sum(size(SaveTriggeredRipples{mm}{k}))>2
            AllTriggeredRipples{k} = [AllTriggeredRipples{k};SaveTriggeredRipples_Ad{mm}{k}];
        end
    end
end
AllTrigStim = [];
AllTrigRip = [];

for k = 1:10
    AllTrigStim = [AllTrigStim;nanmean((AllTriggeredStim{k}))];
    AllTrigRip = [AllTrigRip;nanmean((AllTriggeredRipples{k}))];
    plot(tpsstim,nanmean((AllTriggeredStim{k})))
    hold on
end

subplot(2,2,1)
imagesc(tpsstim,1:10,(AllTrigStim))
set(gca,'YTick',1:10,'YTickLabel',EpochNames)
clim([-0 1])
xlabel('Time to stims (s)')
set(gca,'FontSize',15,'linewidth',2)
box off

subplot(2,2,2)
imagesc(tpsrip,1:10,(AllTrigRip))
set(gca,'YTick',1:10,'YTickLabel',EpochNames)
clim([-0 1])
xlabel('Time to ripples (s)')
set(gca,'FontSize',15,'linewidth',2)
box off

subplot(2,2,3)
errorbar(tpsstim,nanmean(AllTriggeredStim{8}),stdError(AllTriggeredStim{8}),'linewidth',2)
hold on
errorbar(tpsstim,nanmean(AllTriggeredStim{9}),stdError(AllTriggeredStim{9}),'linewidth',2)
xlabel('Time to stims (s)')
box off
set(gca,'FontSize',15,'linewidth',2)
legend({'PostRipples','PreRipples'})
ylabel('Mean R')

subplot(2,2,4)
errorbar(tpsrip,nanmean(AllTriggeredRipples{3}),stdError(AllTriggeredRipples{3}),'linewidth',2)
hold on
errorbar(tpsrip,nanmean(AllTriggeredRipples{4}),stdError(AllTriggeredRipples{4}),'linewidth',2)
xlabel('Time to ripples (s)')
box off
set(gca,'FontSize',15,'linewidth',2)
legend({'PostStim','PreStim'})
ylabel('Mean R')

% Quantification
figure
A = {nanmax(AllTriggeredStim{9}(:,20:24)'),nanmax(AllTriggeredStim{9}(:,27:31)'),nanmax(AllTriggeredStim{8}(:,20:24)'),nanmax(AllTriggeredStim{8}(:,27:31)')};
Cols = {[0.8 0.8 0.8],[0.4 0.4 0.4],[1 0.6 0.6],[0.8 0.1 0.1]}
MakeSpreadAndBoxPlot_SB(A,Cols,[1,2,4,5])
line([A{1}*0+1;A{2}*0+2],[A{1};A{2}],'color',[0.4 0.4 0.4])
line([A{3}*0+4;A{4}*0+5],[A{3};A{4}],'color',[1 0.4 0.4])
[p1,h,stats] = signrank(A{1},A{2});
[p2,h,stats] = signrank(A{3},A{4});
sigstar_DB({[1,2],[4,5]},[p1,p2])
set(gca,'XTick',[1,2,4,5],'XTickLabel',{'Pre','Post','Pre','Post'})
ylabel('Reactivation strength')
set(gca,'FontSize',15,'linewidth',2)


%
clf
subplot(2,1,1)
errorbar(tpsstim(1:find(tpsstim==0)-1),nanmean(AllTriggeredStim{8}(:,1:find(tpsstim==0)-1)),stdError(AllTriggeredStim{8}(:,1:find(tpsstim==0)-1)),'linewidth',2,'color','r')
hold on
errorbar(tpsstim(1:find(tpsstim==0)-1),nanmean(AllTriggeredStim{9}(:,1:find(tpsstim==0)-1)),stdError(AllTriggeredStim{9}(:,1:find(tpsstim==0)-1)),'linewidth',2,'color','b')
errorbar(tpsstim(find(tpsstim==0)+2:end),nanmean(AllTriggeredStim{9}(:,find(tpsstim==0)+2:end)),stdError(AllTriggeredStim{9}(:,find(tpsstim==0)+2:end)),'linewidth',2,'color','b')
errorbar(tpsstim(find(tpsstim==0)+2:end),nanmean(AllTriggeredStim{8}(:,find(tpsstim==0)+2:end)),stdError(AllTriggeredStim{8}(:,find(tpsstim==0)+2:end)),'linewidth',2,'color','r')
xlabel('Time to stims (s)')
box off
set(gca,'FontSize',15,'linewidth',2)
legend({['Template: 100ms post ripples n=' num2str(size(AllTriggeredStim{8},1)) ' comp'],['Template: 100ms taken 1s before ripple n=' num2str(size(AllTriggeredStim{9},1)) ' comp']})
ylabel('Mean R')

subplot(2,1,2)
errorbar(tpsrip,nanmean(AllTriggeredRipples{3}),stdError(AllTriggeredRipples{3}),'linewidth',2,'color','r')
hold on
errorbar(tpsrip,nanmean(AllTriggeredRipples{4}),stdError(AllTriggeredRipples{4}),'linewidth',2,'color','b')
xlabel('Time to ripples (s)')
box off
set(gca,'FontSize',15,'linewidth',2)
legend({['Template: Post Stim 300-900ms n=' num2str(size(AllTriggeredRipples{3},1)) ' comp'],['Template: PreStim 900-300ms n=' num2str(size(AllTriggeredRipples{4},1)) ' comp']})
ylabel('Mean R')


%% Ripple
%% Triger firing rate on ripple
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
Binsize = 0.01*1e4;
num = 1;
clear SaveTriggeredStim SaveTriggeredStimZ EigVal RemRipAct Qdat QdatShuff
num = 1;
for mm=1:length(MiceNumber)
    clear Qdat QdatShuff Spikes Ripples
    load(['RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'])
    if not(isempty(Range(Ripples)))
    Q = MakeQfromS(Spikes,Binsize);
    Q = tsd(Range(Q),nanzscore(Data(Q)));
    Qdat =  Data(Q);
    
    for spk = 1:size(Qdat,2)
        tempstsd = tsd(Range(Q),Qdat(:,spk));
        [M,T] = PlotRipRaw(tempstsd,Range(Ripples,'s'),1000,0,0);
        RemRipAct(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
        
        num=num+1;
    end
    end
end
RemRipAct(156,:) = [];
figure
subplot(3,1,1:2)
RemRipActVal = nanmean(RemRipAct(:,floor(length(M(:,2))/2):floor(length(M(:,2))/2)+10)');
RemRipAct2 = sortrows([RemRipActVal;RemRipAct']');
RemRipAct2 = RemRipAct2(:,2:end);
imagesc(M(:,1),1:size(RemRipAct,1),(RemRipAct2')')
Yl = ylim;
% patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
clim([-2 2])

set(gca,'FontSize',15,'linewidth',2)
box off
xlabel('Time to stim (s)')
ylabel('Neuron num - sorted by resp')


subplot(3,1,3)
plot(M(:,1),nanmean(RemRipAct),'linewidth',2), hold on
% plot(M(:,1),nanmean(RemRipActShuff),'--','linewidth',2), hold on
set(gca,'FontSize',15,'linewidth',2)
box off
xlabel('Time to stim (s)')
ylabel('Mean response')
line([0 0],[-0.2 0.6])

%% Triger firing rate on stim
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
Binsize = 0.1*1e4;
num = 1;
clear SaveTriggeredStim SaveTriggeredStimZ EigVal RemStimAct Qdat QdatShuff
num = 1;
for mm=1:length(MiceNumber)
    clear Qdat QdatShuff Spikes
    load(['RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'])
    Q = MakeQfromS(Spikes,Binsize);
    Q = tsd(Range(Q),nanzscore(Data(Q)));
    Qdat =  Data(Q);
    
    % Shuffle cell identity
    for tps = 1:length(Qdat)
        QdatShuff(tps,:) = Qdat(tps,randperm(size(Qdat,2)));
    end
    
    for spk = 1:size(Qdat,2)
        tempstsd = tsd(Range(Q),Qdat(:,spk));
        [M,T] = PlotRipRaw(tempstsd,Start(StimEpoch,'s'),5000,0,0);
        RemStimAct(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
        
%         tempstsd = tsd(Range(Q),QdatShuff(:,spk));
%         [M,T] = PlotRipRaw(tempstsd,Start(StimEpoch,'s'),5000,0,0);
%         RemStimActShuff(num,:) = M(:,2);
        num=num+1;
    end
    
end
RemStimAct(156,:) = [];

figure
subplot(3,1,1:2)
RemStimActVal = nanmean(RemStimAct(:,54:60)');
RemStimAct2 = sortrows([RemStimActVal;RemStimAct']');
RemStimAct2 = RemStimAct2(:,2:end);
imagesc(M(:,1),1:size(RemStimAct,1),(RemStimAct2')')
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
clim([-5 5])
set(gca,'FontSize',15,'linewidth',2)
box off
xlabel('Time to stim (s)')
ylabel('Neuron num - sorted by resp')


subplot(3,1,3)
plot(M(:,1),nanmean(RemStimAct),'linewidth',2), hold on
% plot(M(:,1),nanmean(RemStimActShuff),'--','linewidth',2), hold on
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
set(gca,'FontSize',15,'linewidth',2)
box off
xlabel('Time to stim (s)')
ylabel('Mean response')

figure
RemStimAct2 = sortrows([RemRipActVal;RemStimAct']');
plot(nanmean(RemStimAct(RemRipActVal>prctile(RemRipActVal,90),:))), hold on
plot(nanmean(RemStimAct(RemRipActVal<prctile(RemRipActVal,10),:)))

