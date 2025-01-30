clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,510,512,514];

Binsize = 0.1*1e4;
SpeedLim = 2;

for mm=1:length(MiceNumber)
    mm
    clear Dir
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'UMazeCond');
    ToKeep = find(~cellfun(@isempty,x1));
    Dir = Dir(ToKeep);
    Ripples = ConcatenateDataFromFolders_SB(Dir,'ripples');
    if not(isempty(Ripples))
        Spikes = ConcatenateDataFromFolders_SB(Dir,'spikes');
        cd(Dir{1})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes = Spikes(numNeurons);
        
        NoiseEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepochclosestims');
        FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
        StimEpoch= ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
        
        LinPos = ConcatenateDataFromFolders_SB(Dir,'linearposition');
        LFP = ConcatenateDataFromFolders_SB(Dir,'lfp','ChanNumber',14);
        Vtsd = ConcatenateDataFromFolders_SB(Dir,'speed');
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4);
        
        % Clean epochs
        TotEpoch = intervalSet(0,max(Range(LFP)));
        TotEpoch = TotEpoch-NoiseEpoch;
        FreezeEpoch = FreezeEpoch-NoiseEpoch;
        MovEpoch = MovEpoch - NoiseEpoch;
        
        Ripples = Restrict(Ripples,TotEpoch);
        
        
        Ripples = Restrict(Ripples,thresholdIntervals(LinPos,0.4,'Direction','Below'));
        RipTimes = Range(Ripples);
        
        firingrates = NaN(length(Spikes),length(RipTimes)*3);
        TimeBins = NaN(length(RipTimes)*3,1);
        evnum = 0;
        for rip = 1:length(RipTimes)
            for  i = -1.5:0.5
                evnum = evnum +1;
                LitEpoch =  intervalSet(RipTimes(rip)+Binsize*i,RipTimes(rip)+Binsize*(i+1));
                TimeBins(evnum) = RipTimes(rip)+Binsize*i;
                for sp = 1 : length(Spikes)
                    firingrates(sp,evnum) = length(Range(Restrict(Spikes{sp},LitEpoch))) / (Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
                end
            end
        end
        
        Q = MakeQfromS(Spikes,Binsize);
        Q = tsd(Range(Q),nanzscore(Data(Q)));
        [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(firingrates',1);
        strength = ReactivationStrength_SB((Data(Q)),templates);
        cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
        save(['RippleReactInfo_Shock_M',num2str(MiceNumber(mm)),'.mat'],'Spikes','LinPos','Ripples','Vtsd','NoiseEpoch','FreezeEpoch',...
            'templates','correlations','eigenvalues','eigenvectors','StimEpoch','MovEpoch','strength','lambdaMax')
        clear Spikes LinPos RipTimes Vtsd NoiseEpochFreezeEpoch
        clear templates correlations eigenvalues eigenvectors StimEpoch lambdaMax
    end
end

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
    
    clear eigenvalues Spikes StimEpoch Ripples SrimEpoch
    load(['RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'])
    
    StimEpochToRemove = intervalSet(Start(StimEpoch),Start(StimEpoch)+3*1e4);
    RipEpochToRemove = intervalSet(Range(Ripples),Range(Ripples)+0.001*1e4);
    
%             StimEpochToUse = intervalSet(Start(StimEpoch),Start(StimEpoch)+3*1e4);
    % StimEpochToUse = StimEpochToUse-StimEpochToRemove;
%     StimEpochToUse = and(FreezeEpoch,(thresholdIntervals(LinPos,0.2,'Direction','Below'))) - intervalSet(Start(StimEpoch),Start(StimEpoch)+3*1e4);
       StimEpochToUse =  intervalSet(Range(Ripples)-0.1*1e4,Range(Ripples)+0.3*1e4);
        StimEpochToUse = mergeCloseIntervals(StimEpochToUse,0.2*1e4);
    
    Q = MakeQfromS(Spikes,Binsize);
    Q = tsd(Range(Q),nanzscore(Data(Q)));

    QTemplate = Restrict(Q,StimEpochToUse);
%     QTemplate = tsd(Range(QTemplate),nanzscore(Data(QTemplate)));

    dat = Data(QTemplate);
    BadGuys = find(sum(isnan(Data(QTemplate))));
    for i = 1:length(BadGuys)
        dat(:,BadGuys(i)) = zeros(size(dat,1),1);
    end
    [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(dat,1);
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
    
    clear Epoch
    i=0;
    i=i+1;Epoch{i}=thresholdIntervals(LinPos,0.2,'Direction','Below')-or(StimEpochToRemove,RipEpochToRemove);
    i=i+1;Epoch{i}=thresholdIntervals(LinPos,0.8,'Direction','Above')-or(StimEpochToRemove,RipEpochToRemove);
    i=i+1;Epoch{i}=and(FreezeEpoch,Epoch{1})-or(StimEpochToRemove,RipEpochToRemove);
    i=i+1;Epoch{i}=and(FreezeEpoch,Epoch{2})-or(StimEpochToRemove,RipEpochToRemove);
    i=i+1;Epoch{i}=and(MovEpoch,Epoch{1})-or(StimEpochToRemove,RipEpochToRemove);
    i=i+1;Epoch{i}=and(MovEpoch,Epoch{2})-or(StimEpochToRemove,RipEpochToRemove);

    
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


figure
errorbar(tpsrip,nanmean(SaveTriggeredRipZ),stdError(SaveTriggeredRipZ))
hold on
errorbar(tpsrip,nanmean(SaveTriggeredRipZShuff),stdError(SaveTriggeredRipZShuff))

figure
errorbar(tpsstim,nanmean(SaveTriggeredStimZ),stdError(SaveTriggeredStimZ))
hold on
errorbar(tpsstim,nanmean(SaveTriggeredStimZShuff),stdError(SaveTriggeredStimZShuff))














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
        RemStimAct(num,:) = M(:,2);
        
        tempstsd = tsd(Range(Q),QdatShuff(:,spk));
        [M,T] = PlotRipRaw(tempstsd,Start(StimEpoch,'s'),5000,0,0);
        RemStimActShuff(num,:) = M(:,2);
        if not(isempty(Range(Ripples)))
            
            [M,T] = PlotRipRaw(tempstsd,Range(Ripples,'s'),5000,0,0);
            RemRipAct(num,:) = M(:,2);
        end
        num=num+1;
    end
    
end

figure
subplot(3,1,1:2)
RemStimActVal = nanmean(RemStimAct(:,54:60)');
RemStimAct2 = sortrows([RemStimActVal;RemStimAct']');
RemStimAct2 = RemStimAct2(:,2:end);
imagesc(M(:,1),1:size(RemStimAct,1),nanzscore(RemStimAct2')')
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
clim([-3 3])

subplot(3,1,3)
plot(M(:,1),nanmean(RemStimAct),'linewidth',2), hold on
plot(M(:,1),nanmean(RemStimActShuff),'--','linewidth',2), hold on


RemStimActVal = nanmean(RemStimAct(:,54:60)');
RemStimAct2 = sortrows([RemStimActVal;RemRipAct']');
RemStimAct2 = RemStimAct2(:,2:end);
imagesc(M(:,1),1:size(RemStimAct,1),nanzscore(RemStimAct2')')




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


%% Ripple
%% Triger firing rate on stim
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
Binsize = 0.01*1e4;
num = 1;
clear SaveTriggeredStim SaveTriggeredStimZ EigVal RemStimAct Qdat QdatShuff
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
        RemStimAct(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
        
        num=num+1;
    end
    end
end
RemStimAct(156,:) = [];
figure
subplot(3,1,1:2)
RemStimActVal = nanmean(RemStimAct(:,floor(length(M(:,2))/2):floor(length(M(:,2))/2)+10)');
RemStimAct2 = sortrows([RemStimActVal;RemStimAct']');
RemStimAct2 = RemStimAct2(:,2:end);
imagesc(M(:,1),1:size(RemStimAct,1),(RemStimAct2')')
Yl = ylim;
% patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
clim([-2 2])

set(gca,'FontSize',15,'linewidth',2)
box off
xlabel('Time to stim (s)')
ylabel('Neuron num - sorted by resp')


subplot(3,1,3)
plot(M(:,1),nanmean(RemStimAct),'linewidth',2), hold on
% plot(M(:,1),nanmean(RemStimActShuff),'--','linewidth',2), hold on
set(gca,'FontSize',15,'linewidth',2)
box off
xlabel('Time to stim (s)')
ylabel('Mean response')
line([0 0],[-0.2 0.6])
