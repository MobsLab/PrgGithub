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
    Epoch.Poststim=intervalSet(Start(StimEpoch),Start(StimEpoch)+3*1e4)-StimEpochToRemove;
    Epoch.PreStim=intervalSet(Start(StimEpoch)-3*1e4,Start(StimEpoch))-StimEpochToRemove;
    Epoch.ShockFreeze=and(FreezeEpoch,Epoch.Shock)-or(StimEpochToRemove,RipEpochToRemove);
    
    Epoch.Safe=thresholdIntervals(LinPos,0.8,'Direction','Above')-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.SafeMov=and(MovEpoch,Epoch.Safe)-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.PostRipples=mergeCloseIntervals(intervalSet(Range(Ripples)-0.05*1e4,Range(Ripples)+0.12*1e4),0.1*1e4)-StimEpochToRemove;
    Epoch.PreRipples=(mergeCloseIntervals(intervalSet(Range(Ripples)-0.85*1e4,Range(Ripples)-0.72*1e4),0.1*1e4)-StimEpochToRemove)-Epoch.PostRipples;
    Epoch.SafeFreeze=and(FreezeEpoch,Epoch.Safe)-or(StimEpochToRemove,RipEpochToRemove);
    
    EpochNames = fieldnames(Epoch);
    
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
        
        [templates.(EpochNames{k}),correlations.(EpochNames{k}),eigenvalues.(EpochNames{k}),eigenvectors.(EpochNames{k}),lambdaMax.(EpochNames{k})] = ActivityTemplates_SB(dat,0);
    end
    
    for k = 1:i
        plot(eigenvalues.(EpochNames{k})/lambdaMax.(EpochNames{k}))
        hold on
    end
    
    QMatch = tsd(Range(Q),nanzscore(Data(Q)));
    
    % Shuffle precise spike timing
    Qdat =  Data(QMatch);
    for spk = 1:size(Qdat,2)
        r(spk) = round(5-rand(1)*10);
        Qdat(:,spk) = circshift(Qdat(:,spk),r(spk));
    end
    QShuff = tsd(Range(QMatch),Qdat);
    
    
    for k = 1:length(EpochNames)
        EpochNames{k}
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
for k = 1:10
    AllTriggeredStim{k} = [];
    AllTriggeredRipples{k} = [];
end

for mm=1:length(MiceNumber)
    for k = 1:10
        if sum(size(SaveTriggeredStim{mm}{k}))>2
            AllTriggeredStim{k} = [AllTriggeredStim{k};SaveTriggeredStim{mm}{k}];
        end
        if sum(size(SaveTriggeredRip{mm}{k}))>2
            AllTriggeredRipples{k} = [AllTriggeredRipples{k};SaveTriggeredRip{mm}{k}];
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

