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
        
        
        Ripples = Restrict(Ripples,thresholdIntervals(LinPos,0.6,'Direction','Above'));
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
        [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(firingrates');
        strength = ReactivationStrength_SB((Data(Q)),templates);
        cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
        save(['RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'],'Spikes','LinPos','Ripples','Vtsd','NoiseEpoch','FreezeEpoch',...
            'templates','correlations','eigenvalues','eigenvectors','StimEpoch','MovEpoch','strength','lambdaMax')
        clear Spikes LinPos RipTimes Vtsd NoiseEpochFreezeEpoch
        clear templates correlations eigenvalues eigenvectors StimEpoch lambdaMax
    end
end
        cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples

%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.1*1e4;
num = 1;
clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
for mm=1:length(MiceNumber)
    clear eigenvalues Spikes
    load(['RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'])
    Q = MakeQfromS(Spikes,Binsize);
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
            StimEpoch = intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4);
            
            % trigger react stregnth on stims
            Strtsd = tsd(Range(Q),strength(:,comp));
            TotalEpoch = intervalSet(0,max(Range(Strtsd)));
            Strtsd = Restrict(Strtsd,TotalEpoch-StimEpoch);
            
            StrtsdShuff = tsd(Range(QShuff),strengthShuff(:,comp));
            StrtsdShuff = Restrict(StrtsdShuff,TotalEpoch-StimEpoch);
            
            [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),5000,0,0);
            subplot(221)
            plot(M(:,1),M(:,2))
            subplot(222)
            hold on
            [Y,X] = hist(Data(StrtsdShuff),200)
            plot(X,log(Y),'color',[0.6 0.6 0.6])
            line([1 1]*prctile(Data(StrtsdShuff),99),ylim)
            
            [Y,X] = hist(Data(Strtsd),200)
            plot(X,log(Y),'b','linewidth',2),hold on
            subplot(2,1,2)
            hold on
            plot(Range(StrtsdShuff,'s'),Data(StrtsdShuff),'color',[0.6 0.6 0.6])
            plot(Range(Strtsd,'s'),Data(Strtsd),'b'),
            plot(Range(Ripples,'s'),30,'k*')
            plot(Start(StimEpoch,'s'),40,'r*')

            yyaxis right
            plot(Range(LinPos,'s'),Data(LinPos))
            num = num+1;
            pause
            clf
        end
    end
end


        SaveTriggeredStim(num,:) = M(:,2);
        SaveTriggeredStimZ(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';

        % trigger react stregnth on stims
        Strtsd = tsd(Range(QShuff),strengthShuff(:,comp));
        Strtsd = Restrict(Strtsd,TotalEpoch-StimEpoch);
        [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),5000,0,0);
        SaveTriggeredStimShuff(num,:) = M(:,2);
        SaveTriggeredStimZShuff(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';

        EigVal(num) = eigenvalues(comp)./lambdaMax;
        num = num+1;
    end
end

figure 
tps = M(:,1);
StimTimes = [find(tps>=0,1,'first'):find(tps>=0.18,1,'first')];
subplot(3,2,[1,3])
if SortByEigVal
    A = sortrows([EigVal',SaveTriggeredStim]);
    A = A(:,2:end);
    EigVal2 = sort(EigVal);
else
    A = SaveTriggeredStim;
end
A(:,StimTimes) = NaN;
imagesc(M(:,1)+median(diff(tps))/2,1:num-1,A((EigVal2>1),:))
clim([-0.5 2])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
title('Real data')
xlabel('Time to stim (s)')
ylabel('Significant PC')
set(gca,'linewidth',2,'FontSize',10)
box off

subplot(3,2,[5])
hold on
h=shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2<=1),:)),stdError(A((EigVal2<=1),:)));
set(h.patch,'FaceColor',[0.3 0.3 0.3]*2)
h = shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2>1),:)),stdError(A((EigVal2>1),:)))
set(h.patch,'FaceColor',[0.3 0.3 0.3])
ylim([-0.5 1.5])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
xlabel('Time to stim (s)')
ylabel('Reactivation stregth - zscore')
set(gca,'linewidth',2,'FontSize',10)

subplot(3,2,[1,3]+1)
if SortByEigVal
    A = sortrows([EigVal',SaveTriggeredStimShuff]);
    A = A(:,2:end);
else
    A = SaveTriggeredStimShuff;
end
A(:,StimTimes) = NaN;
imagesc(M(:,1)+median(diff(tps))/2,1:num-1,A((EigVal2>1),:))
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
clim([-0.5 2])
title('Shuffled data')%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.2*1e4;
num = 1;
clear SaveTriggeredStim SaveTriggeredStimZ EigVal
for mm=1:length(MiceNumber)
    load(['RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'])
    Q = MakeQfromS(Spikes,Binsize);
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
        StimEpoch = intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4);
        
        % trigger react stregnth on stims
        Strtsd = tsd(Range(Q),strength(:,comp));
                        TotalEpoch = intervalSet(0,max(Range(Strtsd)));

        Strtsd = Restrict(Strtsd,TotalEpoch-StimEpoch);
        [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),5000,0,0);
        SaveTriggeredStim(num,:) = M(:,2);
        SaveTriggeredStimZ(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';

        % trigger react stregnth on stims
        Strtsd = tsd(Range(QShuff),strengthShuff(:,comp));
        Strtsd = Restrict(Strtsd,TotalEpoch-StimEpoch);
        [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),5000,0,0);
        SaveTriggeredStimShuff(num,:) = M(:,2);
        SaveTriggeredStimZShuff(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';

        EigVal(num) = eigenvalues(comp)./lambdaMax;
        num = num+1;
    end
end

figure 
tps = M(:,1);
StimTimes = [find(tps>=0,1,'first'):find(tps>=0.18,1,'first')];
subplot(3,2,[1,3])
if SortByEigVal
    A = sortrows([EigVal',SaveTriggeredStim]);
    A = A(:,2:end);
    EigVal2 = sort(EigVal);
else
    A = SaveTriggeredStim;
end
A(:,StimTimes) = NaN;
imagesc(M(:,1)+median(diff(tps))/2,1:num-1,A((EigVal2>1),:))
clim([-0.5 2])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
title('Real data')
xlabel('Time to stim (s)')
ylabel('Significant PC')
set(gca,'linewidth',2,'FontSize',10)
box off

subplot(3,2,[5])
hold on
h=shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2<=1),:)),stdError(A((EigVal2<=1),:)));
set(h.patch,'FaceColor',[0.3 0.3 0.3]*2)
h = shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2>1),:)),stdError(A((EigVal2>1),:)))
set(h.patch,'FaceColor',[0.3 0.3 0.3])
ylim([-0.5 1.5])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
xlabel('Time to stim (s)')
ylabel('Reactivation stregth - zscore')
set(gca,'linewidth',2,'FontSize',10)

subplot(3,2,[1,3]+1)
if SortByEigVal
    A = sortrows([EigVal',SaveTriggeredStimShuff]);
    A = A(:,2:end);
else
    A = SaveTriggeredStimShuff;
end
A(:,StimTimes) = NaN;
imagesc(M(:,1)+median(diff(tps))/2,1:num-1,A((EigVal2>1),:))
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
clim([-0.5 2])
title('Shuffled data')
xlabel('Time to stim (s)')
ylabel('Significant PC')
set(gca,'linewidth',2,'FontSize',10)
box off
subplot(3,2,[6])
hold on
h=shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2<=1),:)),stdError(A((EigVal2<=1),:)));
set(h.patch,'FaceColor',[0.3 0.3 0.3]*2)
h = shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2>1),:)),stdError(A((EigVal2>1),:)))
set(h.patch,'FaceColor',[0.3 0.3 0.3])
ylim([0.5 1.5])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
ylim([-0.5 1.5])
xlabel('Time to stim (s)')
ylabel('Reactivation stregth - zscore')
set(gca,'linewidth',2,'FontSize',10)

figure 
tps = M(:,1);
StimTimes = [find(tps>=0,1,'first'):find(tps>=0.18,1,'first')];
subplot(3,2,[1,3])
if SortByEigVal
    A = sortrows([EigVal',SaveTriggeredStimZ]);
    A = A(:,2:end);
    EigVal2 = sort(EigVal);
else
    A = SaveTriggeredStimZ;
end
A(:,StimTimes) = NaN;
imagesc(M(:,1)+median(diff(tps))/2,1:num-1,A((EigVal2>1),:))
clim([-3 5])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
title('Real data')
xlabel('Time to stim (s)')
ylabel('Significant PC')
set(gca,'linewidth',2,'FontSize',10)
box off

subplot(3,2,[5])
hold on
h=shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2<=1),:)),stdError(A((EigVal2<=1),:)));
set(h.patch,'FaceColor',[0.3 0.3 0.3]*2)
h = shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2>1),:)),stdError(A((EigVal2>1),:)))
set(h.patch,'FaceColor',[0.3 0.3 0.3])
ylim([-2 6])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
xlabel('Time to stim (s)')
ylabel('Reactivation stregth - zscore')
set(gca,'linewidth',2,'FontSize',10)

subplot(3,2,[1,3]+1)
if SortByEigVal
    A = sortrows([EigVal',SaveTriggeredStimZShuff]);
    A = A(:,2:end);
else
    A = SaveTriggeredStimZShuff;
end
A(:,StimTimes) = NaN;
imagesc(M(:,1)+median(diff(tps))/2,1:num-1,A((EigVal2>1),:))
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
clim([-3 5])
title('Shuffled data')
xlabel('Time to stim (s)')
ylabel('Significant PC')
set(gca,'linewidth',2,'FontSize',10)
box off
subplot(3,2,[6])
hold on
h=shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2<=1),:)),stdError(A((EigVal2<=1),:)));
set(h.patch,'FaceColor',[0.3 0.3 0.3]*2)
h = shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2>1),:)),stdError(A((EigVal2>1),:)))
set(h.patch,'FaceColor',[0.3 0.3 0.3])
ylim([-2 6])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
box off
xlabel('Time to stim (s)')
ylabel('Reactivation stregth - zscore')
set(gca,'linewidth',2,'FontSize',10)


figure
A = SaveTriggeredStim;
AShuff = SaveTriggeredStimShuff;
BefTimes = [find(tps>=-3.5,1,'first'):find(tps>=-0.5,1,'first')];
AftTimes = [find(tps>=0.25,1,'first'):find(tps>=3,1,'first')];
CellPlot = {nanmean(AShuff((EigVal>1),BefTimes)'),nanmean(AShuff((EigVal>1),AftTimes)'),nanmean(A((EigVal>1),BefTimes)'),nanmean(A((EigVal>1),AftTimes)')};
Cols = {[0.8 0.8 0.8],[0.2 0.2 0.2],[1 0.8 0.8],[1 0.2 0.2]};
MakeSpreadAndBoxPlot_SB(CellPlot,Cols,1:4)
line([CellPlot{1}*0+1; CellPlot{2}*0+2],[CellPlot{1}; CellPlot{2} ],'color','k')
line([CellPlot{3}*0+3; CellPlot{4}*0+4],[CellPlot{3}; CellPlot{4} ],'color','k')
[p1,h1,stats1] = signrank(CellPlot{1}, CellPlot{2});
[p2,h2,stats2] = signrank(CellPlot{3}, CellPlot{4});
sigstar_DB({[1,2],[3,4]},[p1,p2])
set(gca,'XTick',[1:4],'XTickLabel',{'PreStim','PostStim','PreStim','PostStim'},'linewidth',2,'FontSize',18)
xtickangle(45)
ylabel('Reactivation strength')

xlabel('Time to stim (s)')
ylabel('Significant PC')
set(gca,'linewidth',2,'FontSize',10)
box off
subplot(3,2,[6])
hold on
h=shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2<=1),:)),stdError(A((EigVal2<=1),:)));
set(h.patch,'FaceColor',[0.3 0.3 0.3]*2)
h = shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2>1),:)),stdError(A((EigVal2>1),:)))
set(h.patch,'FaceColor',[0.3 0.3 0.3])
ylim([0.5 1.5])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
ylim([-0.5 1.5])
xlabel('Time to stim (s)')
ylabel('Reactivation stregth - zscore')
set(gca,'linewidth',2,'FontSize',10)

figure 
tps = M(:,1);
StimTimes = [find(tps>=0,1,'first'):find(tps>=0.18,1,'first')];
subplot(3,2,[1,3])
if SortByEigVal
    A = sortrows([EigVal',SaveTriggeredStimZ]);
    A = A(:,2:end);
    EigVal2 = sort(EigVal);
else
    A = SaveTriggeredStimZ;
end
A(:,StimTimes) = NaN;
imagesc(M(:,1)+median(diff(tps))/2,1:num-1,A((EigVal2>1),:))
clim([-3 5])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
title('Real data')
xlabel('Time to stim (s)')
ylabel('Significant PC')
set(gca,'linewidth',2,'FontSize',10)
box off

subplot(3,2,[5])
hold on
h=shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2<=1),:)),stdError(A((EigVal2<=1),:)));
set(h.patch,'FaceColor',[0.3 0.3 0.3]*2)
h = shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2>1),:)),stdError(A((EigVal2>1),:)))
set(h.patch,'FaceColor',[0.3 0.3 0.3])
ylim([-2 6])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
xlabel('Time to stim (s)')
ylabel('Reactivation stregth - zscore')
set(gca,'linewidth',2,'FontSize',10)

subplot(3,2,[1,3]+1)
if SortByEigVal
    A = sortrows([EigVal',SaveTriggeredStimZShuff]);
    A = A(:,2:end);
else
    A = SaveTriggeredStimZShuff;
end
A(:,StimTimes) = NaN;
imagesc(M(:,1)+median(diff(tps))/2,1:num-1,A((EigVal2>1),:))
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
clim([-3 5])
title('Shuffled data')
xlabel('Time to stim (s)')
ylabel('Significant PC')
set(gca,'linewidth',2,'FontSize',10)
box off
subplot(3,2,[6])
hold on
h=shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2<=1),:)),stdError(A((EigVal2<=1),:)));
set(h.patch,'FaceColor',[0.3 0.3 0.3]*2)
h = shadedErrorBar(M(1:size(A,2),1)+median(diff(tps))/2,nanmean(A((EigVal2>1),:)),stdError(A((EigVal2>1),:)))
set(h.patch,'FaceColor',[0.3 0.3 0.3])
ylim([-2 6])
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
box off
xlabel('Time to stim (s)')
ylabel('Reactivation stregth - zscore')
set(gca,'linewidth',2,'FontSize',10)


figure
A = SaveTriggeredStim;
AShuff = SaveTriggeredStimShuff;
BefTimes = [find(tps>=-3.5,1,'first'):find(tps>=-0.5,1,'first')];
AftTimes = [find(tps>=0.25,1,'first'):find(tps>=3,1,'first')];
CellPlot = {nanmean(AShuff((EigVal>1),BefTimes)'),nanmean(AShuff((EigVal>1),AftTimes)'),nanmean(A((EigVal>1),BefTimes)'),nanmean(A((EigVal>1),AftTimes)')};
Cols = {[0.8 0.8 0.8],[0.2 0.2 0.2],[1 0.8 0.8],[1 0.2 0.2]};
MakeSpreadAndBoxPlot_SB(CellPlot,Cols,1:4)
line([CellPlot{1}*0+1; CellPlot{2}*0+2],[CellPlot{1}; CellPlot{2} ],'color','k')
line([CellPlot{3}*0+3; CellPlot{4}*0+4],[CellPlot{3}; CellPlot{4} ],'color','k')
[p1,h1,stats1] = signrank(CellPlot{1}, CellPlot{2});
[p2,h2,stats2] = signrank(CellPlot{3}, CellPlot{4});
sigstar_DB({[1,2],[3,4]},[p1,p2])
set(gca,'XTick',[1:4],'XTickLabel',{'PreStim','PostStim','PreStim','PostStim'},'linewidth',2,'FontSize',18)
xtickangle(45)
ylabel('Reactivation strength')

% same as Nat Neuro
PlotErrorBarN_KJ(CellPlot,'showPoints',0)
Yl = ylim;
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')


%% Triger firing rate on stim
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
        num=num+1;
    end
    
end

figure
subplot(3,1,1:2)
RemStimActVal = nanmean(RemStimAct(:,54:60)');
RemStimAct2 = sortrows([RemStimActVal;RemStimAct']');
RemStimAct2 = RemStimAct2(:,2:end);
imagesc(M(:,1),1:size(RemStimAct,1),nanzscore(RemStimAct2')')
patch([0 0.3 0.3 0],[Yl(1) Yl(1) Yl(2) Yl(2)],'w','EdgeColor','w')
clim([-3 3])

subplot(3,1,3)
plot(M(:,1),nanmean(RemStimAct),'linewidth',2), hold on
plot(M(:,1),nanmean(RemStimActShuff),'--','linewidth',2), hold on



    



%% Look at different regions
clear EigVal MeanValAll MeanValRun MeanValFreeze ShkFz ShkRun SfFz SfRun
num = 1;
for mm=1:length(MiceNumber)
    clear LinPos FreezeEpoch strength Ripples MovEpoch templates Spikes lambdaMax
    load(['RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'])
    
    % Define epochs
    RipplesEpoch =  intervalSet(RipTimes-2*Binsize,RipTimes+2*Binsize);
    
    FreezeShock = and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below'))-RipplesEpoch;
    FreezeSafe = and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above'))-RipplesEpoch;
    RunShock = and(MovEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below'))-RipplesEpoch;
    RunSafe = and(MovEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above'))-RipplesEpoch;
    
    Q = MakeQfromS(Spikes,Binsize);
    Q = tsd(Range(Q),nanzscore(Data(Q)));
    strength = ReactivationStrength_SB((Data(Q)),templates);
    
    RipTimes = Range(Ripples);
    
    for comp = 1:size(strength,2)
        Strtsd = tsd(Range(Q),strength(:,comp));
        Strtsd = Restrict(Strtsd,TotEpoch - intervalSet(RipTimes-0.2*1e4,RipTimes+0.2*1e4));
        % Shock zone - freezing
        ShkFz(num) = nanmean(Data(Restrict(Strtsd,FreezeShock)));
        
        % Safe zone - freezing no ripples
        SfFz(num) = nanmean(Data(Restrict(Strtsd,FreezeSafe)));
        
        % Shock zone - running
        ShkRun(num) = nanmean(Data(Restrict(Strtsd,RunShock)));
        
        % Safe zone - running
        SfRun(num) = nanmean(Data(Restrict(Strtsd,RunSafe)));
        
        EigVal(num) = eigenvalues(comp)/lambdaMax;
        
        %         for pos = 1:8
        %             LitEpoch = and(thresholdIntervals(LinPos,(pos-1)/8,'Direction','Above'),thresholdIntervals(LinPos,(pos)/8,'Direction','Below'));
        %             MeanValAll{mm}{comp}(pos) = nanmean(Data(Restrict(Strtsd,LitEpoch)));
        %             LitEpoch2 = and(LitEpoch,MovEpoch);
        %             MeanValRun{mm}{comp}(pos) = nanmean(Data(Restrict(Strtsd,LitEpoch2)));
        %             LitEpoch2 = and(LitEpoch,FreezeEpoch);
        %             MeanValFreeze{mm}{comp}(pos) = nanmean(Data(Restrict(Strtsd,LitEpoch2)));
        %         end
        num = num+1;
    end
    
end

clear p h stats
CellPlot = {ShkFz(EigVal>1),SfFz(EigVal>1),ShkRun(EigVal>1),SfRun(EigVal>1)};
Cols = {UMazeColors('Shock'),UMazeColors('Safe'),UMazeColors('Shock'),UMazeColors('Safe')};
MakeSpreadAndBoxPlot_SB(CellPlot,Cols,1:4)
[p(1),h(1),stats(1)] = signrank(CellPlot{1}, CellPlot{2});
[p(2),h(2),stats(2)] = signrank(CellPlot{3}, CellPlot{4});
[p(3),h(3)] = signrank([CellPlot{1},CellPlot{2}],[CellPlot{3},CellPlot{4}]);
sigstar_DB({[1,2],[3,4],[1.5 3.5]},p)
set(gca,'XTick',[1:4],'XTickLabel',{'Shk-Fz','Sf-Fz','Shk-Run','Sf-Run'},'linewidth',2,'FontSize',18)
xtickangle(45)
ylabel('Reactivation strength')


% Look at values along the maze
cols = lines(7)
RemAll = [];
AllMeanRun = [];
AllMeanFz = [];
EigValAll = [];
for mm=1:length(MiceNumber)
    for comp = 1:length(ShkFz{mm})
        RemAll = [RemAll;[ShkFz{mm}(comp)',SfFz{mm}(comp)',ShkRun{mm}(comp)',SfRun{mm}(comp)']];
        AllMeanRun = [AllMeanRun;MeanValRun{mm}{comp}];
        AllMeanFz = [AllMeanFz;MeanValFreeze{mm}{comp}];
        EigValAll = [EigValAll;EigVal{mm}(comp) ];
    end
end

figure
hold on
errorbar([1:8]/8,nanmean(AllMeanRun((EigValAll<=1),:)),stdError(AllMeanRun((EigValAll<=1),:)),'Color',[1 0.5 0.5],'linewidth',2)
errorbar([1:8]/8,nanmean(AllMeanRun((EigValAll>1),:)),stdError(AllMeanRun((EigValAll>1),:)),'Color',[1 0.1 0.2],'linewidth',2)

errorbar([1:8]/8,nanmean(AllMeanFz((EigValAll<=1),:)),stdError(AllMeanFz((EigValAll<=1),:)),'Color',[0.5 0.5 1],'linewidth',2)
errorbar([1:8]/8,nanmean(AllMeanFz((EigValAll>1),:)),stdError(AllMeanFz((EigValAll>1),:)),'Color',[0.1 0.2 1],'linewidth',2)

figure
plot([1:8]/8,(AllMeanRun((EigValAll>1),:)),'k.','MarkerSize',10)



