close all
clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.1*1e4;
MiceNumber=[490,507,508,509,510,512,514];
num = 1;
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples

clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
for mm=1:length(MiceNumber)
    mm
    
    clear eigenvalues Spikes StimEpoch Ripples StimEpoch
    load(['RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'])
    Q = MakeQfromS(Spikes,Binsize);
    
TotEpoch = intervalSet(0,max(Range(Vtsd)));
    
    % Define the template epochs
    StimEpochToRemove = intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4);
    RipEpochToRemove = intervalSet(Range(Ripples),Range(Ripples)+0.001*1e4);
    
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
    Epoch.PostRipples=mergeCloseIntervals(intervalSet(Range(Ripples),Range(Ripples)+0.3*1e4),0.1*1e4)-StimEpochToRemove;
    Epoch.PreRipples=mergeCloseIntervals(intervalSet(Range(Ripples)-0.4*1e4,Range(Ripples)-0.1*1e4),0.1*1e4)-StimEpochToRemove;
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
        GlobalCorr.(EpochNames{k}) = correlations.(EpochNames{k});
        GlobalCorr.(EpochNames{k})(1:1+size(GlobalCorr.(EpochNames{k}),1):end) = NaN;
        GlobalCorr.(EpochNames{k}) = triu(GlobalCorr.(EpochNames{k}));
        GlobalCorr.(EpochNames{k})(find(GlobalCorr.(EpochNames{k})==0)) = NaN;
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


        for kk = 1:length(EpochNames)
            x1 = (GlobalCorr.(EpochNames{k})(:));
            x2 = (GlobalCorr.(EpochNames{kk})(:));
            todel = find(isnan(x1) | isnan(x2));
            x1(todel) = [];
            x2(todel) = [];
            
            [R,P] = corrcoef(x1,x2);
            OverallCorrelationR{mm}(k,kk) = R(1,2);
            OverallCorrelationP{mm}(k,kk) = P(1,2);
            TemplateCorrelationR{mm}{k,kk} = NaN;
            TemplateCorrelationP{mm}{k,kk} = NaN;

        end
                
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
                
                for comp2 = 1:size(templates.(EpochNames{kk}),3)
                    x1 = squeeze(templates.(EpochNames{k})(:,:,comp));
                    x1(1:1+size(x1,1):end) = NaN;
                    x1 = triu(x1);
                    x1(find(x1==0)) = NaN;
                    x1 = x1(:);
                    
                    x2 = squeeze(templates.(EpochNames{kk})(:,:,comp2));
                    x2(1:1+size(x2,1):end) = NaN;
                    x2 = triu(x2);
                    x2(find(x2==0)) = NaN;
                    x2 = x2(:);
                    
                    todel = find(isnan(x1) | isnan(x2));
                    x1(todel) = [];
                    x2(todel) = [];
                    [R,P] = corrcoef(x1,x2);
                    
                    TemplateCorrelationR{mm}{k,kk}(comp,comp2) = R(1,2);
                    TemplateCorrelationP{mm}{k,kk}(comp,comp2) = P(1,2);
                end
                
                
            end
            
            %                 subplot(211)
            %                 plot(Range(Strtsd),Data(Strtsd))
            %                 hold on
            %                 plot(Range(StrtsdShuff),Data(StrtsdShuff))
            %                 subplot(212)
            %                 [Y,X] = hist(Data(Strtsd),200);
            %                 plot(X,log(Y),'linewidth',2), hold on
            %                 [Y,X] = hist(Data(StrtsdShuff),200);
            %                 plot(X,log(Y)), hold on
            %                 Lim = prctile(Data(StrtsdShuff),99.9)
            %
            %                 pause
            %                 clf
        end
    end
end

figure
% overal  correlations
subplot(122)
AllR = zeros(10,10);
NumGood = zeros(10,10);
for mm=1:length(MiceNumber)
    for k = 1:10
        for kk = 1:10
            
            AllR(k,kk) = nansum([AllR(k,kk),nanmean(max(TemplateCorrelationR{mm}{k,kk}))]);
            NumGood(k,kk) = NumGood(k,kk) + not(isnan(nanmean(max(TemplateCorrelationR{mm}{k,kk}))));
        end
    end
end
imagesc(AllR./NumGood)
set(gca,'XTick',1:length(EpochNames),'XTickLabel',EpochNames)
set(gca,'YTick',1:10,'YTickLabel',EpochNames)
clim([-0 0.8])
xtickangle(45)
title('Global Corr Mat')
subplot(121)
AllR = zeros(10,10);
NumGood = zeros(10,10);
for mm=1:length(MiceNumber)
    for k = 1:10
        for kk = 1:10
            AllR(k,kk) = nansum([AllR(k,kk),OverallCorrelationR{mm}(k,kk)]);
            NumGood(k,kk) = NumGood(k,kk) + not(isnan(OverallCorrelationR{mm}(k,kk)));
        end
    end
end
imagesc(AllR./NumGood)
set(gca,'XTick',1:length(EpochNames),'XTickLabel',EpochNames)
set(gca,'YTick',1:10,'YTickLabel',EpochNames)
clim([-0 0.8])
xtickangle(45)
title('Templates from  Corr Mat')

% relatino of ripples to shock
num = 1;
for mm=1:length(MiceNumber)
    if sum(size(MnVal{mm}{9}))>2
        for comp = 1:size(MnVal{mm}{9},1)
            
            PreRipPostStim_MN(num) = MnVal{mm}{9}(comp,3);
            PreRipPreStim_MN(num) = MnVal{mm}{9}(comp,4);
            
            
            PreRipPostStimShuff_MN(num) = MnValShuff{mm}{9}(comp,3);
            PreRipPreStimShuff_MN(num) = MnValShuff{mm}{9}(comp,4);
            
            
            PreRipPostStim_PK(num) = PeakNum{mm}{9}(comp,3);
            PreRipPreStim_PK(num) = PeakNum{mm}{9}(comp,4);
            
            
            PreRipPostStimShuff_PK(num) = PeakNum{mm}{9}(comp,3);
            PreRipPreStimShuff_PK(num) = PeakNum{mm}{9}(comp,4);
            num = num+1;
        end
    end
end

num = 1;
for mm=1:length(MiceNumber)
    if sum(size(MnVal{mm}{8}))>2
        
        for comp = 1:size(MnVal{mm}{8},1)
            PostRipPostStim_MN(num) = MnVal{mm}{8}(comp,3);
            PostRipPreStim_MN(num) = MnVal{mm}{8}(comp,4);
            
            
            PostRipPostStimShuff_MN(num) = MnValShuff{mm}{8}(comp,3);
            PostRipPreStimShuff_MN(num) = MnValShuff{mm}{8}(comp,4);
            
            
            PostRipPostStim_PK(num) = PeakNum{mm}{8}(comp,3);
            PostRipPreStim_PK(num) = PeakNum{mm}{8}(comp,4);
            
            
            PostRipPostStimShuff_PK(num) = PeakNum{mm}{8}(comp,3);
            PostRipPreStimShuff_PK(num) = PeakNum{mm}{8}(comp,4);
            
            num = num+1;
        end
    end
end

figure
subplot(2,2,1)
PlotErrorBarN_KJ({PreRipPreStim_MN,PreRipPostStim_MN,PreRipPreStimShuff_MN,PreRipPostStimShuff_MN},'newfig',0)
title('Pre Ripple Trigger')
ylim([-0.5 3])
set(gca,'XTick',1:4,'XTickLabel',{'PreStim','PostStim','PreStimShuff','PostStimShuff'})
subplot(2,2,2)
PlotErrorBarN_KJ({PostRipPreStim_MN,PostRipPostStim_MN,PostRipPreStimShuff_MN,PostRipPostStimShuff_MN},'newfig',0)
title('Post Ripple Trigger')
ylim([-0.5 3])
set(gca,'XTick',1:4,'XTickLabel',{'PreStim','PostStim','PreStimShuff','PostStimShuff'})


subplot(2,2,3)
PlotErrorBarN_KJ({PreRipPreStim_PK,PreRipPostStim_PK,PreRipPreStimShuff_PK,PreRipPostStimShuff_PK},'newfig',0)
title('Pre Ripple Trigger')
ylim([0 0.5])
set(gca,'XTick',1:4,'XTickLabel',{'PreStim','PostStim','PreStimShuff','PostStimShuff'})
subplot(2,2,4)
PlotErrorBarN_KJ({PostRipPreStim_PK,PostRipPostStim_PK,PostRipPreStimShuff_PK,PostRipPostStimShuff_PK},'newfig',0)
title('Post Ripple Trigger')
ylim([0 0.5])
set(gca,'XTick',1:4,'XTickLabel',{'PreStim','PostStim','PreStimShuff','PostStimShuff'})

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

%% ripple and stim using overall correlations
PostRipplePostStim = [];
PostRipplePreStim = [];
PreRipplePostStim = [];
PreRipplePreStim = [];


for mm=1:length(MiceNumber)
    
    PostRipplePostStim = [PostRipplePostStim,max(TemplateCorrelationR{mm}{3,8})];
    PostRipplePreStim = [PostRipplePreStim,max(TemplateCorrelationR{mm}{4,8})];
    PreRipplePostStim = [PreRipplePostStim,max(TemplateCorrelationR{mm}{3,9})];
    PreRipplePreStim = [PreRipplePreStim,max(TemplateCorrelationR{mm}{4,9})];
    
end

figure
PlotErrorBarN_KJ({PostRipplePostStim,PostRipplePreStim,PreRipplePostStim,PreRipplePreStim},'newfig',0,'paired',0)

%% ripple and stim using templates correlations
PostRipplePostStim = [];
PostRipplePreStim = [];
PreRipplePostStim = [];
PreRipplePreStim = [];

for mm=1:length(MiceNumber)
    
            
            PostRipplePostStim(mm) = OverallCorrelationR{mm}(3,8);
            PostRipplePreStim(mm) = OverallCorrelationR{mm}(4,8);
            
            PreRipplePostStim(mm) = OverallCorrelationR{mm}(3,9);
            PreRipplePreStim(mm) = OverallCorrelationR{mm}(4,9);

        
end
figure
PlotErrorBarN_KJ({PostRipplePostStim,PostRipplePreStim,PreRipplePostStim,PreRipplePreStim},'newfig',0)


%% compar different epochs using reactivation
num = 1;
for k = 1:10
    for kk = 1:10
        AllComp{k}{kk} = [];
    end
end
for mm=1:length(MiceNumber)
    for k = 1:10
        for kk = 1:10
            if sum(size(MnVal{mm}{k}))>2
                
                for comp = 1:size(MnVal{mm}{k},1)
                    AllComp{k}{kk} = [AllComp{k}{kk},MnVal{mm}{k}(comp,kk)];
                end
            end
        end
    end
end
figure
clf
for k = 1:10
    subplot(4,3,k)
    PlotErrorBarN_KJ(AllComp{k},'newfig',0,'ShowSigstar','none','showPoints',0)
    set(gca,'XTick',1:length(EpochNames),'XTickLabel',EpochNames)
    ylabel('Mean R')
    xtickangle(45)
    ylim([0 2])
    line([k k], ylim,'color','r')
end

%
num = 1;
for k = 1:10
    for kk = 1:10
        AllComp{k}{kk} = [];
    end
end
for mm=1:length(MiceNumber)
    for k = 1:10
        for kk = 1:10
            if sum(size(MnVal{mm}{k}))>2
                
                for comp = 1:size(MnVal{mm}{k},1)
                    AllComp{k}{kk} = [AllComp{k}{kk},PeakNum{mm}{k}(comp,kk)];
                end
            end
        end
    end
end
figure
clf
for k = 1:10
    subplot(4,3,k)
    PlotErrorBarN_KJ(AllComp{k},'newfig',0,'ShowSigstar','none','showPoints',0)
    set(gca,'XTick',1:length(EpochNames),'XTickLabel',EpochNames)
    xtickangle(45)
    ylabel('R events /s')
    ylim([0 0.15])
    line([k k], ylim,'color','r')
end

                


    figure
    subplot(211)
    PlotErrorBarN_KJ((MnVal{9}),'newfig',0)
    set(gca,'XTick',1:length(EpochNames),'XTickLabel',EpochNames)
    subplot(212)
    PlotErrorBarN_KJ((MnVal{9}),'newfig',0)
    set(gca,'XTick',1:length(EpochNames),'XTickLabel',EpochNames)

%     QTemplate = tsd(Range(QTemplate),nanzscore(Data(QTemplate)));

    dat = Data(QTemplate);
    BadGuys = find(sum(isnan(Data(QTemplate))));
    for i = 1:length(BadGuys)
        dat(:,BadGuys(i)) = zeros(size(dat,1),1);
    end
    [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(dat);
    TemplateSize(mm) = size(dat,1);
    Q = tsd(Range(Q),nanzscore(Data(Q)));
    % Shuffle cell identity
    Qdat =  Data(Q);
    for tps = 1:length(Qdat)
        Qdat(tps,:) = Qdat(tps,randperm(size(Qdat,2)));
    end
    QShuff = tsd(Range(Q),Qdat);

    strength = ReactivationStrength_SB((Data(Q)),templates);
    strengthShuff = ReactivationStrength_SB((Data(QShuff)),templates);
    
   

    
    for comp = 1:size(strength,2)
        if eigenvalues(comp)/lambdaMax>1
            
            % trigger react stregnth on stims
            Strtsd = tsd(Range(Q),strength(:,comp));
            TotalEpoch = intervalSet(0,max(Range(Strtsd)));
            StrtsdShuff = tsd(Range(QShuff),strengthShuff(:,comp));
            
            % MeanReact values
            for k = 1:6
               MeanReact{k}(num) = nanmean(Data(Restrict(Strtsd,Epoch{k})));
               MeanReactShuff{k}(num) = nanmean(Data(Restrict(Strtsd,Epoch{k})));
            end
            
            % Trigger on Stim
            [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),5000,0,0);
            SaveTriggeredStim(num,:) = M(:,2);
            SaveTriggeredStimZ(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
            [M,T] = PlotRipRaw(StrtsdShuff,Start(StimEpoch,'s'),5000,0,0);
            SaveTriggeredStimShuff(num,:) = M(:,2);
            SaveTriggeredStimZShuff(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
            tpsstim = M(:,1);
            
            % Trigger on Ripples
            if not(isempty(Range(Ripples)))
            [M,T] = PlotRipRaw(Strtsd,Range(Ripples,'s'),2000,0,0);
            SaveTriggeredRip(num,:) = M(:,2);
            SaveTriggeredRipZ(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
            [M,T] = PlotRipRaw(StrtsdShuff,Range(Ripples,'s'),2000,0,0);
            SaveTriggeredRipShuff(num,:) = M(:,2);
            SaveTriggeredRipZShuff(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
            tpsrip = M(:,1);
            end
            num = num+1;
        end
    end
end

