close all
clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.2*1e4;
MiceNumber=[490,507,508,509,514];
num = 1;
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples

clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
for mm=1:length(MiceNumber)
    mm
    

    % Directory
    clear Dir
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'UMazeCond');
    ToKeep = find(~cellfun(@isempty,x1));
    Dir = Dir(ToKeep);

    % Load reactivation data
    clear eigenvalues Spikes StimEpoch Ripples StimEpoch
    load(['/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'])
    TotEpoch = intervalSet(0,max(Range(Vtsd)));

    % spikes
    Q = MakeQfromS(Spikes,Binsize);
    
    % get phase of spikes
    
    % Load behaviour variables
    LinPos = ConcatenateDataFromFolders_SB(Dir,'linearposition');
    FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
    StimEpochToRemove = intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4);
    RipEpochToRemove = intervalSet(Range(Ripples)-0.2*1e4,Range(Ripples)+0.4*1e4);

    FreezeEpochToUse.Shock = and(FreezeEpoch -or(StimEpochToRemove,RipEpochToRemove),thresholdIntervals(LinPos,0.6,'Direction','Above'));
    FreezeEpochToUse.Safe = and(FreezeEpoch -or(StimEpochToRemove,RipEpochToRemove),thresholdIntervals(LinPos,0.4,'Direction','Below'));
    FreezeEpochToUse.SafeWiRipples = and(FreezeEpoch -or(StimEpochToRemove,RipEpochToRemove),thresholdIntervals(LinPos,0.4,'Direction','Below'));

    EpochNames = fieldnames(FreezeEpochToUse);

    % Get OB phase
    PhaseOB = ConcatenateDataFromFolders_SB(Dir,'instphase','suffix_instphase','B');
    % Get ripple timesConcatenateDataFromFolders_SB
    Ripples = (Dir,'ripples');
    Ripples = Restrict(Ripples,TotEpoch-NoiseEpoch);
    Ripples = Restrict(Ripples,thresholdIntervals(LinPos,0.6,'Direction','Above'));

    % Define the template epochs
    clear Epoch
    Epoch.PostRipples=mergeCloseIntervals(intervalSet(Range(Ripples)-0.05*1e4,Range(Ripples)+0.22*1e4),0.1*1e4)-StimEpochToRemove;
    Epoch.PreRipples=(mergeCloseIntervals(intervalSet(Range(Ripples)-0.85*1e4,Range(Ripples)-0.62*1e4),0.1*1e4)-StimEpochToRemove)-Epoch.PostRipples;
    EpochNames = fieldnames(Epoch);
    
    % Get templates
    clear templates correlations eigenvalues eigenvectors lambdaMax DatPoints GlobalCorr
    for k = 1:length(EpochNames)

        QTemplate = Restrict(Q,Epoch.(EpochNames{k}));
        QTemplate = tsd(Range(QTemplate),nanzscore(Data(QTemplate)));
        dat = Data(QTemplate);
        BadGuys = find(sum(isnan(Data(QTemplate))));
        for spk = 1:length(BadGuys)
            dat(:,BadGuys(spk)) = zeros(size(dat,1),1);
        end
        DatPoints.(EpochNames{k}) = size(dat,1);
        
        [templates.(EpochNames{k}),correlations.(EpochNames{k}),eigenvalues.(EpochNames{k}),eigenvectors.(EpochNames{k}),lambdaMax.(EpochNames{k})] = ActivityTemplates_SB(dat,1);
    end
    
    % Match epoch
    QMatch = tsd(Range(Q),nanzscore(Data(Q)));
    
      
    
    for k = 1:length(EpochNames)
        EpochNames{k}
        strength = ReactivationStrength_SB((Data(QMatch)),templates.(EpochNames{k}));
        
        
        for comp = 1:min([3,size(templates.(EpochNames{k}),3)])
            Strtsd = tsd(Range(QMatch),strength(:,comp));
            Events = thresholdIntervals(Strtsd,prctile(Data(Strtsd),99),'Direction','Above');
            ReactEvents = ts((Stop(Events)+Start(Events))/2);

            % Phase locing of reactivation events
        rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/FMAToolbox/General/')
        rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
        [mu(mm), Kappa(mm), pval(mm)] = CircularMean(Data(Restrict(PhaseOB,ReactEvents)));
        addpath(genpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats'))
        addpath(genpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/FMAToolbox/General/'))


            for ph  = 1:20
                PhaseInt1 = thresholdIntervals(PhaseOB,(ph-1)*2*pi/20+0.00001,'Direction','Above');
                PhaseInt2 = thresholdIntervals(PhaseOB,(ph)*2*pi/20-0.00001,'Direction','Below');
                PhaseInt = and(PhaseInt1,PhaseInt2);
                
                ValStr_Safe{mm}{k}(comp,ph) = nanmean(Data(Restrict(Strtsd,and(PhaseInt,and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above'))))));
                ValStr_Shock{mm}{k}(comp,ph) = nanmean(Data(Restrict(Strtsd,and(PhaseInt,and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below'))))));

            end

          % Trigger on Stim
            [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),5000,0,0);
            SaveTriggeredStim{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
            SaveTriggeredStimZ{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
            tpsstim = M(:,1);
            
        end
        
    end

end

%% Triggered events
for k = 1:2
    AllTriggeredStim{k} = [];
    AllPhaseDep_Shock{k} = [];
    AllPhaseDep_Safe{k} = [];

end

for mm=1:length(MiceNumber)
    for k = 1:2
        if sum(size(SaveTriggeredStim{mm}{k}))>2
            
AllTriggeredStim{k} = [AllTriggeredStim{k};SaveTriggeredStim{mm}{k}];
        end
         AllPhaseDep_Shock{k} = [AllPhaseDep_Shock{k};ValStr_Shock{mm}{k}];
         AllPhaseDep_Safe{k} = [AllPhaseDep_Safe{k};ValStr_Safe{mm}{k}];


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
A = {nanmax(AllTriggeredStim{9}(:,20:24)'),nanmax(AllTriggeredStim{9}(:,27:30)'),nanmax(AllTriggeredStim{8}(:,20:24)'),nanmax(AllTriggeredStim{8}(:,27:30)')};
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



%% Ripple
%% Triger firing rate on ripple
MiceNumber=[490,507,508,509,514];
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
Binsize = 0.01*1e4;
num = 1;
clear SaveTriggeredStim SaveTriggeredStimZ EigVal RemRipAct Qdat QdatShuff RemRipAct
num = 1;
for mm=1:length(MiceNumber)
    clear Qdat QdatShuff Spikes Ripples
    load(['RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'])
    if not(isempty(Range(Ripples)))
        Q = MakeQfromS(Spikes,Binsize);
        %     Q = tsd(Range(Q),nanzscore(Data(Q)));
        Qdat =  Data(Q);
    
    for spk = 1:size(Qdat,2)
        if nanmean(Qdat(:,spk))*100>1
        tempstsd = tsd(Range(Q),Qdat(:,spk));
        
        [M,T] = PlotRipRaw(tempstsd,Range(Ripples,'s'),1000,0,0);
        RemRipAct(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
        
        num=num+1;
        end
    end
    end
end

% RemRipAct2(113,:) = [];
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
plot(M(:,1),nanmean(RemRipAct2),'linewidth',2), hold on
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

