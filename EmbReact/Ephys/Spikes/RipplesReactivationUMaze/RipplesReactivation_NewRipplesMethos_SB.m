% 
% clear all, close all
% cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,514]; % 510,512 don't have tipples
GetUsefulDataRipplesReactivations_UMaze_SB


SpeedLim = 2;
for mm=1:length(MiceNumber)
    
        
        Spikes = ConcatenateDataFromFolders_BM(Dir{mm}.Cond,'spikes');
        cd(Dir{mm}.Cond{1})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes = Spikes(numNeurons);
       
        LinPos = ConcatenateDataFromFolders_BM(Dir{mm}.Cond,'linearposition');
        Vtsd = ConcatenateDataFromFolders_BM(Dir{mm}.Cond,'speed');
        
        FreezeEpoch = ConcatenateDataFromFolders_BM(Dir{mm}.Cond,'epoch','epochname','freezeepoch');
        StimEpoch = ConcatenateDataFromFolders_BM(Dir{mm}.Cond,'epoch','epochname','stimepoch');
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4);
        
        NoiseEpoch = ConcatenateDataFromFolders_BM(Dir{mm}.Cond,'epoch','epochname','noiseepoch');

        Ripples =  ConcatenateDataFromFolders_BM(Dir{mm}.Cond,'ripples');
        
        
        cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples

        save(['RippleReactInfo_NewRipples_M',num2str(MiceNumber(mm)),'.mat'],'Ripples','MovEpoch','StimEpoch',...
            'LinPos','Vtsd','Spikes','FreezeEpoch','NoiseEpoch')

end




% close all
clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.1*1e4;
MiceNumber=[490,507,508,509]; % excluded 514, too few ripples
num = 1;
cd ~/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples

clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
for mm=1:length(MiceNumber)
    mm
    
    clear eigenvalues Spikes StimEpoch Ripples StimEpoch strength templates correlations eigenvectors lambdaMax
    load(['RippleReactInfo_NewRipples_M',num2str(MiceNumber(mm)),'.mat'])
    Q = MakeQfromS(Spikes,Binsize); % data from the conditionning session
    Q = tsd(Range(Q),nanzscore(full(Data(Q))));

    
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
        % z-score the template epoch
        QTemplate = tsd(Range(QTemplate),(Data(QTemplate)));
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

    
    %% add the templates from sleep
    Sleep = load('~/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/AllRippleInfo_DiffEpochs.mat','Ripples','Spikes');
    % PreSleep
    Q_Sleep_Pre = MakeQfromS(Sleep.Spikes{mm}.SleepPre,Binsize);
    Epoch.PostRipples_SleepPre = mergeCloseIntervals(intervalSet(Range(Sleep.Ripples.SleepPre{mm})-0.05*1e4,Range(Sleep.Ripples.SleepPre{mm})+0.22*1e4),0.1*1e4);
    EpochNames = fieldnames(Epoch);
    k = length(EpochNames);
    QTemplate_Sleep = Restrict(Q_Sleep_Pre,Epoch.PostRipples_SleepPre);
    QTemplate_Sleep = tsd(Range(QTemplate_Sleep),nanzscore(Data(QTemplate_Sleep)));
    dat = Data(QTemplate_Sleep);
    BadGuys = find(sum(isnan(Data(QTemplate_Sleep))));
    for spk = 1:length(BadGuys)
        dat(:,BadGuys(spk)) = zeros(size(dat,1),1);
    end
    DatPoints.(EpochNames{k}) = size(dat,1);
    
    [templates.(EpochNames{k}),correlations.(EpochNames{k}),eigenvalues.(EpochNames{k}),eigenvectors.(EpochNames{k}),lambdaMax.(EpochNames{k})] = ActivityTemplates_SB(dat,0);

    % Post Sleep
    Q_Sleep_Post = MakeQfromS(Sleep.Spikes{mm}.SleepPost,Binsize);
    
    Epoch.PostRipples_SleepPost = mergeCloseIntervals(intervalSet(Range(Sleep.Ripples.SleepPost{mm})-0.05*1e4,Range(Sleep.Ripples.SleepPost{mm})+0.22*1e4),0.1*1e4);
    EpochNames = fieldnames(Epoch);
    k = length(EpochNames);
    QTemplate_Sleep = Restrict(Q_Sleep_Post,Epoch.PostRipples_SleepPost);
    QTemplate_Sleep = tsd(Range(QTemplate_Sleep),nanzscore(Data(QTemplate_Sleep)));
    dat = Data(QTemplate_Sleep);
    BadGuys = find(sum(isnan(Data(QTemplate_Sleep))));
    for spk = 1:length(BadGuys)
        dat(:,BadGuys(spk)) = zeros(size(dat,1),1);
    end
    DatPoints.(EpochNames{k}) = size(dat,1);
    
    [templates.(EpochNames{k}),correlations.(EpochNames{k}),eigenvalues.(EpochNames{k}),eigenvectors.(EpochNames{k}),lambdaMax.(EpochNames{k})] = ActivityTemplates_SB(dat,0);

    
    %% Get the reactivation strength
    % z-score the full data
    QMatch = tsd(Range(Q),(Data(Q)));
    QMatch_Pre = tsd(Range(Q_Sleep_Pre),nanzscore(Data(Q_Sleep_Pre)));
    QMatch_Post = tsd(Range(Q_Sleep_Post),nanzscore(Data(Q_Sleep_Post)));

    
    % Shuffle precise spike timing
    Qdat =  Data(QMatch);
    for spk = 1:size(Qdat,2)
        r(spk) = round(5-rand(1)*10);
        Qdat(:,spk) = circshift(Qdat(:,spk),r(spk));
    end
    QShuff = tsd(Range(QMatch),Qdat);
    
    
    for k = 1:length(EpochNames)
        
        strength = ReactivationStrength_SB((Data(QMatch)),templates.(EpochNames{k}));
        strengthShuff = ReactivationStrength_SB((Data(QShuff)),templates.(EpochNames{k}));
              strength_PreSleep = ReactivationStrength_SB((Data(QMatch_Pre)),templates.(EpochNames{k}));
            strength_PostSleep = ReactivationStrength_SB((Data(QMatch_Post)),templates.(EpochNames{k}));
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
                SaveTriggeredRip_Pre{mm}{k} = NaN;
        SaveTriggeredRipZ_Pre{mm}{k} = NaN;
        SaveTriggeredRip_Post{mm}{k} = NaN;
        SaveTriggeredRipZ_Post{mm}{k} = NaN;

        
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
            
      
            Strtsd_PreSleep = tsd(Range(QMatch_Pre),strength_PreSleep(:,comp));
            Strtsd_PostSleep = tsd(Range(QMatch_Post),strength_PostSleep(:,comp));

             % Trigger on Ripples_sleep pre
            if not(isempty(Range(Sleep.Ripples.SleepPre{mm})))
                [M,T] = PlotRipRaw(Strtsd_PreSleep,Range(Sleep.Ripples.SleepPre{mm},'s'),2000,0,0);
                SaveTriggeredRip_Pre{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
                SaveTriggeredRipZ_Pre{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
                
            end
            
               % Trigger on Ripples_sleep post
            if not(isempty(Range(Sleep.Ripples.SleepPost{mm})))
                [M,T] = PlotRipRaw(Strtsd_PostSleep,Range(Sleep.Ripples.SleepPost{mm},'s'),2000,0,0);
                SaveTriggeredRip_Post{mm}{k}(comp,1:length(M(:,2))) = M(:,2);
                SaveTriggeredRipZ_Post{mm}{k}(comp,1:length(M(:,2))) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
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
            
            
        end
    end
end


%% Triggered events
for k = 1:size(EpochNames,1)
    AllTriggeredStim{k} = [];
    AllTriggeredRipples{k} = [];
    AllTriggeredRipples_Pre{k} = [];
    AllTriggeredRipples_Post{k} = [];
end

for mm=1:length(MiceNumber)
    for k = 1:size(EpochNames,1)
        if sum(size(SaveTriggeredStim{mm}{k}))>2
            AllTriggeredStim{k} = [AllTriggeredStim{k};SaveTriggeredStim{mm}{k}];
        end
        if sum(size(SaveTriggeredRip{mm}{k}))>2
            AllTriggeredRipples{k} = [AllTriggeredRipples{k};SaveTriggeredRip{mm}{k}];
        end
        if sum(size(SaveTriggeredRip_Pre{mm}{k}))>2
            AllTriggeredRipples_Pre{k} = [AllTriggeredRipples_Pre{k};SaveTriggeredRip_Pre{mm}{k}];
        end
        if sum(size(SaveTriggeredRip_Post{mm}{k}))>2
            AllTriggeredRipples_Post{k} = [AllTriggeredRipples_Post{k};SaveTriggeredRip_Post{mm}{k}];
        end

    end
end

AllTrigStim = [];
AllTrigRip = [];

figure
for k = 1:size(EpochNames,1)
    AllTrigStim = [AllTrigStim;nanmean((AllTriggeredStim{k}))];
    AllTrigRip = [AllTrigRip;nanmean((AllTriggeredRipples{k}))];
    plot(tpsstim,nanmean((AllTriggeredStim{k})))
    hold on
end


figure
subplot(2,2,1)
imagesc(tpsstim,1:size(EpochNames,1),(AllTrigStim))
set(gca,'YTick',1:size(EpochNames,1),'YTickLabel',EpochNames)
clim([-0 1])
xlabel('Time to stims (s)')
set(gca,'FontSize',15,'linewidth',2)
box off

subplot(2,2,2)
imagesc(tpsrip,1:size(EpochNames,1),(AllTrigRip))
set(gca,'YTick',1:size(EpochNames,1),'YTickLabel',EpochNames)
clim([-0 1])
xlabel('Time to ripples (s)')
set(gca,'FontSize',15,'linewidth',2)
box off

subplot(2,2,3)
errorbar(tpsstim,nanmean(AllTriggeredStim{9}),stdError(AllTriggeredStim{9}),'linewidth',2)
hold on
errorbar(tpsstim,nanmean(AllTriggeredStim{10}),stdError(AllTriggeredStim{10}),'linewidth',2)
xlabel('Time to stims (s)')
box off
set(gca,'FontSize',15,'linewidth',2)
legend({'PostRipples','PreRipples'})
ylabel('Mean R')

subplot(2,2,4)
errorbar(tpsrip,nanmean(AllTriggeredRipples{5}),stdError(AllTriggeredRipples{5}),'linewidth',2)
hold on
errorbar(tpsrip,nanmean(AllTriggeredRipples{4}),stdError(AllTriggeredRipples{4}),'linewidth',2)
xlabel('Time to ripples (s)')
box off
set(gca,'FontSize',15,'linewidth',2)
legend({'PostStim','PreStim'})
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

figure
A = {nanmax(AllTriggeredRipples{5}(:,1:10)'),nanmax(AllTriggeredRipples{5}(:,20:30)'),nanmax(AllTriggeredRipples{4}(:,1:10)'),nanmax(AllTriggeredRipples{4}(:,20:30)')};
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
figure
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

subplot(311)
errorbar(1:12,nanmean(AllMnVal_Pre),stdError(AllMnVal_Pre))
hold on
errorbar(1:12,nanmean(AllMnVal_Post),stdError(AllMnVal_Post))

set(gca,'XTick',1:12,'XTickLabel',EpochNames)
xtickangle(45)
legend('PreRip','PostRip')
makepretty


subplot(312)
% PreRipples - 10
TempEpo= 5;
AllMnVal_Pre = [];
for mm = 1:length(MnVal)
    AllMnVal_Pre = [MnVal{mm}{TempEpo};AllMnVal_Pre];
end

TempEpo= 4;
AllMnVal_Post = [];
for mm = 1:length(MnVal)
    AllMnVal_Post = [MnVal{mm}{TempEpo};AllMnVal_Post];
end


errorbar(1:12,nanmean(AllMnVal_Pre),stdError(AllMnVal_Pre))
hold on
errorbar(1:12,nanmean(AllMnVal_Post),stdError(AllMnVal_Post))

set(gca,'XTick',1:12,'XTickLabel',EpochNames)
xtickangle(45)
legend('PreStim','PostStim')
makepretty



subplot(313)
% PreRipples - 10
TempEpo= 11;
AllMnVal_Pre = [];
for mm = 1:length(MnVal)
    AllMnVal_Pre = [MnVal{mm}{TempEpo};AllMnVal_Pre];
end

TempEpo= 12;
AllMnVal_Post = [];
for mm = 1:length(MnVal)
    AllMnVal_Post = [MnVal{mm}{TempEpo};AllMnVal_Post];
end


errorbar(1:12,nanmean(AllMnVal_Pre),stdError(AllMnVal_Pre))
hold on
errorbar(1:12,nanmean(AllMnVal_Post),stdError(AllMnVal_Post))

set(gca,'XTick',1:12,'XTickLabel',EpochNames)
xtickangle(45)
legend('RipPreSleep','RipPostSleep')
makepretty

