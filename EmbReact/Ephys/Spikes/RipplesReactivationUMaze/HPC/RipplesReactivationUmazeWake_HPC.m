
clear all, close all
SpeedLim = 2;

Dir = PathForExperimentsERC('UMazePAG');
mice_PAG_neurons = [905,906,911,994,1161,1162,1168,1182,1186,1230,1239];
CondSessionsId = [7:10];

for ff = 1:length(Dir.name)
    if ismember(eval(Dir.name{ff}(6:end)),mice_PAG_neurons)
        cd(Dir.path{ff}{1})
        disp(Dir.path{ff}{1})
        
        load('behavResources.mat')
        % Get the right sessions - just cond
        CondSess = SessionEpoch.Cond1;
        for ss = 2:4
            CondSess = or(CondSess,SessionEpoch.(['Cond' num2str(ss)]));
        end

        load('SpikeData.mat')
        [numNeurons, numtt, TT]=GetSpikesFromStructure('dHPC');
        Spikes = S(numNeurons);
        Spikes = Restrict(Spikes,CondSess);
        
        LinPos = Restrict(LinearDist,CondSess);
        Xtsd = AlignedXtsd;
        Ytsd = AlignedYtsd;
        Vtsd = Restrict(Vtsd,CondSess);
        FreezeEpoch = and(FreezeEpoch,CondSess);
        StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+0.2*1e4);
        length(Start(and(StimEpoch,CondSess)))
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4);
        
        load('SleepScoring_Accelero.mat', 'TotalNoiseEpoch')
        NoiseEpoch = and(TotalNoiseEpoch,CondSess);
        
        
        load('SWR.mat', 'tRipples')
        Ripples =  Restrict(tRipples,CondSess);
        
        
        cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data
        
        save(['RippleReactInfo_NewRipples_',Dir.name{ff},'.mat'],'Ripples','MovEpoch','StimEpoch',...
            'LinPos','Vtsd','Spikes','FreezeEpoch','NoiseEpoch','Xtsd','Ytsd')
        
    end
end



close all
clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.1*1e4;
num = 1;
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data
MiceNumber = [905,906,911,994,1161,1162,1168,1182,1186,1230,1239];

clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
for mm=1:length(MiceNumber)
    mm
    
    clear eigenvalues Spikes StimEpoch Ripples StimEpoch strength templates correlations eigenvectors lambdaMax
    load(['RippleReactInfo_NewRipples_Cond_Mouse',num2str(MiceNumber(mm)),'.mat'])
    Q = MakeQfromS(Spikes,Binsize); % data from the conditionning session
    
    % Define the template epochs
    StimEpochToRemove = intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4);
    RipEpochToRemove = intervalSet(Range(Ripples)-0.2*1e4,Range(Ripples)+0.4*1e4);
    TotEpoch = intervalSet(0,max(Range(Vtsd)));
    Ripples = Restrict(Ripples,TotEpoch-NoiseEpoch);
    Ripples = Restrict(Ripples,thresholdIntervals(LinPos,0.6,'Direction','Above'));
    
    clear Epoch
    Epoch.Shock=thresholdIntervals(LinPos,0.2,'Direction','Below')-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.ShockMov=and(MovEpoch,Epoch.Shock)-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.ShockFreeze=and(FreezeEpoch,Epoch.Shock)-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.Poststim=intervalSet(Start(StimEpoch)+0.1*1E4,Start(StimEpoch)+3*1e4)-StimEpochToRemove;
    Epoch.PreStim=intervalSet(Start(StimEpoch)-3*1e4,Start(StimEpoch))-StimEpochToRemove;
    
    Epoch.Safe=thresholdIntervals(LinPos,0.8,'Direction','Above')-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.SafeMov=and(MovEpoch,Epoch.Safe)-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.SafeFreeze=and(FreezeEpoch,Epoch.Safe)-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.PostRipples=mergeCloseIntervals(intervalSet(Range(Ripples)-0.05*1e4,Range(Ripples)+0.20*1e4),0.5*1e4)-StimEpochToRemove;
    Epoch.PreRipples=(mergeCloseIntervals(intervalSet(Range(Ripples)-2.05*1e4,Range(Ripples)-1.8*1e4),0.5*1e4)-StimEpochToRemove)-Epoch.PostRipples;
    
    EpochNames = fieldnames(Epoch);
    
    clear templates correlations eigenvalues eigenvectors lambdaMax DatPoints GlobalCorr
    for k = 1:length(EpochNames)
        QTemplate = Restrict(Q,Epoch.(EpochNames{k}));
        QTemplate = tsd(Range(QTemplate),nanzscore(Data(QTemplate)));
        dat = Data(QTemplate);
        if k== 8
            size(dat)
        end
        BadGuys = find(sum(isnan(Data(QTemplate))));
        for spk = 1:length(BadGuys)
            dat(:,BadGuys(spk)) = zeros(size(dat,1),1);
        end
        DatPoints.(EpochNames{k}) = size(dat,1);
        
        [templates.(EpochNames{k}),correlations.(EpochNames{k}),eigenvalues.(EpochNames{k}),eigenvectors.(EpochNames{k}),lambdaMax.(EpochNames{k})] = ActivityTemplates_SB(dat,0);
        
    end
    
    
    QMatch = tsd(Range(Q),nanzscore(Data(Q)));
    %% Shuffle the data
    dat = nanzscore(Data(Q));
    clear dat_sh
    for neur = 1:size(dat,2)
        dat_sh(:,neur) = dat(randperm(size(dat,1)),neur);
    end
    QShuff = tsd(Range(Q),dat_sh);
    
    %% Get the reactivation strength
    
    
    for k = 1:length(EpochNames)
        
        strength = ReactivationStrength_SB((Data(QMatch)),templates.(EpochNames{k}));
        strengthShuff = ReactivationStrength_SB((Data(QShuff)),templates.(EpochNames{k}));
        
        MnVal{mm}{k} = NaN;
        MdVal{mm}{k} = NaN;
        PeakNum{mm}{k} = NaN;
        
        MnValShuff{mm}{k} = NaN;
        MdValShuff{mm}{k}= NaN;
        PeakNumShuff{mm}{k}  = NaN;
        
        SaveTriggeredStim{mm}{k} = NaN;
        SaveTriggeredStimZ{mm}{k} = NaN;
        SaveTriggeredStimShuff{mm}{k} = NaN;
        SaveTriggeredStimZShuff{mm}{k} = NaN;
        SaveTriggeredRip{mm}{k} = NaN;
        SaveTriggeredRipZ{mm}{k} = NaN;
        SaveTriggeredRipShuff{mm}{k} = NaN;
        SaveTriggeredRipZShuff{mm}{k} = NaN;
        
        
        % mouse 1 component 2 and 3 are good examples (2 is strongly react,
        % 3 shows nothing) -- used in phD
        for comp = 1:size(templates.(EpochNames{k}),3)
            Strtsd = tsd(Range(QMatch),strength(:,comp));
            StrtsdShuff = tsd(Range(QShuff),strengthShuff(:,comp));
            Lim = prctile(Data(StrtsdShuff),99.9);
            
            % Trigger on Stim
            [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),5000,0,0);
            SaveTriggeredStim{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
            SaveTriggeredStimZ{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
            
            [M,T] = PlotRipRaw(StrtsdShuff,Start(StimEpoch,'s'),5000,0,0);
            SaveTriggeredStimShuff{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
            SaveTriggeredStimZShuff{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
            tpsstim = M(:,1);
            
            % Trigger on Ripples
            if not(isempty(Range(Ripples)))
                [M,T] = PlotRipRaw(Strtsd,Range(Ripples,'s'),2000,0,0);
                SaveTriggeredRip{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
                SaveTriggeredRipZ{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
                
                [M,T] = PlotRipRaw(StrtsdShuff,Range(Ripples,'s'),2000,0,0);
                SaveTriggeredRipShuff{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
                SaveTriggeredRipZShuff{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
                tpsrip = M(:,1);
            end
            
            % Average by epoch
            for kk = 1:length(EpochNames)
                MnVal{mm}{k}(comp,kk) = nanmean(Data(Restrict(Strtsd,Epoch.(EpochNames{kk}))));
                MdVal{mm}{k}(comp,kk) = nanmedian(Data(Restrict(Strtsd,Epoch.(EpochNames{kk}))));
                
                MnValShuff{mm}{k}(comp,kk) = nanmean(Data(Restrict(StrtsdShuff,Epoch.(EpochNames{kk}))));
                MdValShuff{mm}{k}(comp,kk) = nanmedian(Data(Restrict(StrtsdShuff,Epoch.(EpochNames{kk}))));
                if sum(Stop(Epoch.(EpochNames{kk}),'s') - Start(Epoch.(EpochNames{kk}),'s'))>0
                    PeakNumShuff{mm}{k}(comp,kk) = nansum(Data(Restrict(StrtsdShuff,Epoch.(EpochNames{kk})))>Lim)./sum(Stop(Epoch.(EpochNames{kk}),'s') - Start(Epoch.(EpochNames{kk}),'s'));
                    PeakNum{mm}{k}(comp,kk) = nansum(Data(Restrict(Strtsd,Epoch.(EpochNames{kk})))>Lim)./sum(Stop(Epoch.(EpochNames{kk}),'s') - Start(Epoch.(EpochNames{kk}),'s'));
                else
                    PeakNumShuff{mm}{k}(comp,kk) = NaN;
                    PeakNum{mm}{k}(comp,kk) = NaN;
                end
            end
            
            % Link to LinPos
            LinPos = Restrict(LinPos,ts(Range(Strtsd)));
            for ii = 1:10
                LittleEp = and(and(thresholdIntervals(LinPos,(ii-1)/10,'Direction','Above'),...
                    thresholdIntervals(LinPos,ii/10,'Direction','Below')),MovEpoch);
                MnReactPos_Mov{mm}{k}(comp,ii) = nanmean(Data(Restrict(Strtsd,LittleEp))) ;
                
                LittleEp = and(and(thresholdIntervals(LinPos,(ii-1)/10,'Direction','Above'),...
                    thresholdIntervals(LinPos,ii/10,'Direction','Below')),FreezeEpoch);
                MnReactPos_Fz{mm}{k}(comp,ii) = nanmean(Data(Restrict(Strtsd,LittleEp))) ;
            end
            
                        
        end
    end
end


%% Triggered events
for k = 1:size(EpochNames,1)
    AllTriggeredStim{k} = [];
    AllTriggeredRipples{k} = [];
    AllTriggeredStim_Sh{k} = [];
    AllTriggeredRipples_Sh{k} = [];

end

for mm=1:length(MiceNumber)
    for k = 1:size(EpochNames,1)
        if sum(size(SaveTriggeredStim{mm}{k}))>2
            AllTriggeredStim{k} = [AllTriggeredStim{k};SaveTriggeredStim{mm}{k}];
            AllTriggeredStim_Sh{k} = [AllTriggeredStim_Sh{k};SaveTriggeredStimShuff{mm}{k}];
        end
        if sum(size(SaveTriggeredRip{mm}{k}))>2
            AllTriggeredRipples{k} = [AllTriggeredRipples{k};SaveTriggeredRip{mm}{k}];
            AllTriggeredRipples_Sh{k} = [AllTriggeredRipples_Sh{k};SaveTriggeredRipShuff{mm}{k}];
        end
    end
end

AllTrigStim = [];
AllTrigRip = [];
AllTrigStim_Sh = [];
AllTrigRip_Sh = [];

for k = 1:size(EpochNames,1)
    AllTrigStim = [AllTrigStim;nanmean((AllTriggeredStim{k}))];
    AllTrigRip = [AllTrigRip;nanmean((AllTriggeredRipples{k}))];
    AllTrigStim_Sh = [AllTrigStim_Sh;nanmean((AllTriggeredStim_Sh{k}))];
    AllTrigRip_Sh = [AllTrigRip_Sh;nanmean((AllTriggeredRipples_Sh{k}))];
end

figure
subplot(2,2,1)
imagesc(tpsstim,1:size(EpochNames,1),(AllTrigStim))
set(gca,'YTick',1:size(EpochNames,1),'YTickLabel',EpochNames)
clim([-0 3])
xlabel('Time to shock (s)')
set(gca,'FontSize',15,'linewidth',2)
title('Templates different epochs  ')
box off

subplot(2,2,2)
imagesc(tpsrip,1:size(EpochNames,1),(AllTrigRip))
set(gca,'YTick',1:size(EpochNames,1),'YTickLabel',EpochNames)
clim([-0 8])
xlabel('Time to ripples (s)')
set(gca,'FontSize',15,'linewidth',2)
title('Templates different epochs  ')
box off

subplot(2,2,3)
TemplatesToUse = [9,10];
errorbar(tpsstim,nanmean(AllTriggeredStim{TemplatesToUse(1)}),stdError(AllTriggeredStim{TemplatesToUse(1)}),'linewidth',2)
hold on
errorbar(tpsstim,nanmean(AllTriggeredStim{TemplatesToUse(2)}),stdError(AllTriggeredStim{TemplatesToUse(2)}),'linewidth',2)
xlabel('Time to stims (s)')
box off
set(gca,'FontSize',15,'linewidth',2)
legend(EpochNames(TemplatesToUse))
ylabel('Mean R')

subplot(2,2,4)
TemplatesToUse = [9,10];
errorbar(tpsrip,nanmean(AllTriggeredRipples{TemplatesToUse(1)}),stdError(AllTriggeredRipples{TemplatesToUse(1)}),'linewidth',2)
hold on
errorbar(tpsrip,nanmean(AllTriggeredRipples{TemplatesToUse(2)}),stdError(AllTriggeredRipples{TemplatesToUse(2)}),'linewidth',2)
xlabel('Time to ripples (s)')
box off
set(gca,'FontSize',15,'linewidth',2)
legend(EpochNames(TemplatesToUse))
ylabel('Mean R')

% Quantification
figure
A = {nanmax(AllTriggeredStim{10}(:,10:30)'),nanmax(AllTriggeredStim{10}(:,55:65)'),nanmax(AllTriggeredStim{9}(:,10:30)'),nanmax(AllTriggeredStim{9}(:,55:65)')};
Cols = {[0.8 0.8 0.8],[0.4 0.4 0.4],[1 0.6 0.6],[0.8 0.1 0.1]}
MakeSpreadAndBoxPlot_SB(A,Cols,[1,2,4,5],{},1,0)
line([A{1}*0+1;A{2}*0+2],[A{1};A{2}],'color',[0.4 0.4 0.4])
line([A{3}*0+4;A{4}*0+5],[A{3};A{4}],'color',[1 0.4 0.4])
[p1,h,stats] = signrank(A{1},A{2});
[p2,h,stats] = signrank(A{3},A{4});
sigstar_DB({[1,2],[4,5]},[p1,p2])
set(gca,'XTick',[1,2,4,5],'XTickLabel',{'Pre','Post','Pre','Post'})
ylabel('Reactivation strength')
set(gca,'FontSize',15,'linewidth',2)



%% Mean values
% PreRipples - 10
TempEpo= 10;
AllMnVal_Pre = [];
for mm = 1:length(MnVal)
    AllMnVal_Pre = [MnVal{mm}{TempEpo};AllMnVal_Pre];
end

TempEpo= 9;
AllMnVal_Post = [];
for mm = 1:length(MnVal)
    AllMnVal_Post = [MnVal{mm}{TempEpo};AllMnVal_Post];
end
figure
errorbar(1:size(AllMnVal_Pre,2),nanmean(AllMnVal_Pre),stdError(AllMnVal_Pre))
hold on
errorbar(1:size(AllMnVal_Pre,2),nanmean(AllMnVal_Post),stdError(AllMnVal_Post))
set(gca,'XTick',1:size(AllMnVal_Pre,2),'XTickLabel',EpochNames)
xtickangle(45)
legend('PreRip','PostRip')
makepretty


% Relation to position
AllCompOnPos = [];
for mm = 1:length(MnReactPos_Mov)
    AllCompOnPos = [AllCompOnPos;MnReactPos_Mov{mm}{9}];
end
% AllCompOnPos = zscore(AllCompOnPos')';

for pos = 1:10
    ReactByPos{pos}  = AllCompOnPos(:,pos);
end
figure
errorbar([0.05:0.1:1],nanmean(AllCompOnPos),stdError(AllCompOnPos))
xlabel('Position in maze')
ylabel('React strength from ripples')
makepretty