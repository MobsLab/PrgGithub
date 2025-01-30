clear all
close all
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')
AllSess = load('OverallInfoPhysioSpikesAllSess2.mat');
MiceNumber=[490,507,508,509,510,512,514];

clear ShockFzsize  SafeFzsize W Score AllDatProj AllDatProjRand ScoreRand DecodeBrainState W WRand
SpeedLim = 2;
SessType{1} = 'UMazeCond';
SessType{2} = 'UMazeCond';

for  FzOnly = 0:1
    
    for mm=1:7
        if FzOnly
            ShockFzsize(mm) = sum(AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}<0.4 & AllSess.MouseByMouse.(SessType{FzOnly+1}).IsFz{mm}>0.95);
            SafeFzsize(mm) = sum(AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}>0.6 & AllSess.MouseByMouse.(SessType{FzOnly+1}).IsFz{mm}>0.95);
        else
            ShockFzsize(mm) = sum(AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}<0.4 & AllSess.MouseByMouse.(SessType{FzOnly+1}).Speed{mm}>SpeedLim);
            SafeFzsize(mm) = sum(AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}>0.6 & AllSess.MouseByMouse.(SessType{FzOnly+1}).Speed{mm}>SpeedLim);
        end
        
        BinsToUseTemp(FzOnly+1,mm) = floor(min(min([ShockFzsize(mm),SafeFzsize(mm)]))/2);
    end
end
    BinsToUse = min(BinsToUseTemp);

for FzOnly = 0:1
    figure
    
    for mm=1:7
        
        
        RemTrialSafe{mm} = nan(length(AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}),1000);
        RemTrialShock{mm} = nan(length(AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}),1000);
        FRZ = nanzscore(AllSess.MouseByMouse.(SessType{FzOnly+1}).FR{mm}')';
        
        for perm = 1:1000
            if FzOnly
                ShockBins = find(AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}<0.4 & AllSess.MouseByMouse.(SessType{FzOnly+1}).IsFz{mm}>0.95);
                SafeBins = find(AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}>0.6 & AllSess.MouseByMouse.(SessType{FzOnly+1}).IsFz{mm}>0.95);
            else
                ShockBins = find(AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}<0.4 & AllSess.MouseByMouse.(SessType{FzOnly+1}).Speed{mm}>SpeedLim);
                SafeBins = find(AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}>0.6 & AllSess.MouseByMouse.(SessType{FzOnly+1}).Speed{mm}>SpeedLim);
            end
            
            ShockBinsToUse = ShockBins(randperm(length(ShockBins),BinsToUse(mm)*2));
            ShockSideFrTrain = [FRZ(:,ShockBinsToUse(BinsToUse(mm)+1:end))];
            ShockSideFrTest = [FRZ(:,ShockBinsToUse(1:BinsToUse(mm)))];
            
            SafeBinsToUse = SafeBins(randperm(length(SafeBins),BinsToUse(mm)*2));
            SafeSideFrTrain = [FRZ(:,SafeBinsToUse(BinsToUse(mm)+1:end))];
            SafeSideFrTest = [FRZ(:,SafeBinsToUse(1:BinsToUse(mm)))];
            
            
            W{FzOnly+1}{mm}(perm,:) = (nanmean(ShockSideFrTrain')-nanmean(SafeSideFrTrain'));
            Bias = (nanmean(ShockSideFrTrain'*W{FzOnly+1}{mm}(perm,:)') + nanmean(SafeSideFrTrain'*W{FzOnly+1}{mm}(perm,:)'))/2;
            
            for trial = 1 : BinsToUse(mm)
                ShockGuess(trial) = ShockSideFrTest(:,trial)'*W{FzOnly+1}{mm}(perm,:)'>Bias;
                SafeGuess(trial) = SafeSideFrTest(:,trial)'*W{FzOnly+1}{mm}(perm,:)'<Bias;
                RemTrialSafe{mm}(SafeBinsToUse(trial),perm) = SafeGuess(trial);
                RemTrialShock{mm}(ShockBinsToUse(trial),perm) = ShockGuess(trial);
            end
            
            Score{FzOnly+1}(mm,perm) = (nanmean(ShockGuess)+nanmean(SafeGuess))/2;
            AllDatProj{FzOnly+1}{mm}(perm,:)=AllSess.MouseByMouse.(SessType{FzOnly+1}).FR{mm}'*W{FzOnly+1}{mm}(perm,:)';
            
            % Random
            ShockBinsRand = [ShockBinsToUse(BinsToUse(mm)+1:end),SafeBinsToUse(BinsToUse(mm)+1:end)];
            SafeBinsRand = [SafeBinsToUse(1:BinsToUse(mm)),ShockBinsToUse(1:BinsToUse(mm))];
            
            SafeBinsRand = SafeBinsRand(randperm(length(SafeBinsRand)));
            ShockBinsRand = ShockBinsRand(randperm(length(ShockBinsRand)));
            
            ShockSideFrTrain = [FRZ(:,ShockBinsRand(BinsToUse(mm)+1:end))];
            ShockSideFrTest = [FRZ(:,ShockBinsRand(1:BinsToUse(mm)))];
            
            SafeSideFrTrain = [FRZ(:,SafeBinsRand(BinsToUse(mm)+1:end))];
            SafeSideFrTest = [FRZ(:,SafeBinsRand(1:BinsToUse(mm)))];
            
            WRand{FzOnly+1}{mm}(perm,:) = (nanmean(ShockSideFrTrain')-nanmean(SafeSideFrTrain'));
            Bias = (nanmean(ShockSideFrTrain'*WRand{FzOnly+1}{mm}(perm,:)') + nanmean(SafeSideFrTrain'*WRand{FzOnly+1}{mm}(perm,:)'))/2;
            
            for trial = 1 : BinsToUse(mm)
                ShockGuess(trial) = ShockSideFrTest(:,trial)'*WRand{FzOnly+1}{mm}(perm,:)'>Bias;
                SafeGuess(trial) = SafeSideFrTest(:,trial)'*WRand{FzOnly+1}{mm}(perm,:)'<Bias;
                RemTrialSafeRand{mm}(SafeBinsToUse(trial),perm) = SafeGuess(trial);
                RemTrialShockRand{mm}(ShockBinsToUse(trial),perm) = ShockGuess(trial);
            end
            
            ScoreRand{FzOnly+1}(mm,perm) = (nanmean(ShockGuess)+nanmean(SafeGuess))/2;
            AllDatProjRand{FzOnly+1}{mm}(perm,:)=AllSess.MouseByMouse.(SessType{FzOnly+1}).FR{mm}'*WRand{FzOnly+1}{mm}(perm,:)';
            
            
        end
    end
    nanmean(Score{FzOnly+1}')
    
    % figure for decoding
    subplot(1,3,1)
    Cols = {[0.6 0.6 0.6],[1 0.6 0.6]};
    A = {nanmean(Score{FzOnly+1}'),nanmean(Score{FzOnly+1}')};
    UpLim = median(prctile(ScoreRand{FzOnly+1}',97.5))-nanmean(ScoreRand{FzOnly+1}(:));
    LowLim = nanmean(ScoreRand{FzOnly+1}(:)) - median(prctile(ScoreRand{FzOnly+1}',2.5));
    shadedErrorBar([0.5 1.5],[1 1]*nanmean(ScoreRand{FzOnly+1}(:)),[UpLim UpLim;LowLim LowLim])
    hold on
    MakeSpreadAndBoxPlot_SB(A,Cols,1:2,{},0,0)
    xlim([0.5 1.5])
    ylim([0 1])
    
    
    LinPos = [];
    DataPCATogether = [];
    IsFz = [];
    Speed = [];
    for m= 1:7
        
        DataPCATogether = [DataPCATogether;[AllSess.MouseByMouse.(SessType{FzOnly+1}).OBFreq{(m)}',log(AllSess.MouseByMouse.(SessType{FzOnly+1}).HPCPower{(m)})',AllSess.MouseByMouse.(SessType{FzOnly+1}).HR{(m)}',...
            AllSess.MouseByMouse.(SessType{FzOnly+1}).HRVar{(m)}',AllSess.MouseByMouse.(SessType{FzOnly+1}).RipplePower{(m)}']];
        LinPos = [LinPos,AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{(m)}];
        IsFz = [IsFz,AllSess.MouseByMouse.(SessType{FzOnly+1}).IsFz{(m)}];
        Speed = [Speed,AllSess.MouseByMouse.(SessType{FzOnly+1}).Speed{(m)}];
        
    end
    dat = (nanzscore(DataPCATogether));
    if FzOnly
        DecodeBrainState{FzOnly+1} = nanmean(dat(find(LinPos<0.4 & IsFz>0.95),:))-nanmean(dat(find(LinPos>0.6 & IsFz>0.95),:));
    else
        DecodeBrainState{FzOnly+1} = nanmean(dat(find(LinPos<0.4 & Speed>SpeedLim),:))-nanmean(dat(find(LinPos>0.6 & Speed>SpeedLim),:));
    end
    
    Val = [];
    for mm=1:7
        Val = [Val,nanmean(AllDatProj{FzOnly+1}{mm})];
    end
    subplot(1,3,2:3)
    if FzOnly
        scatter(LinPos(IsFz>0.9),dat(IsFz>0.9,:)*DecodeBrainState{FzOnly+1}',30,'filled','k'), hold on
        scatter(LinPos(IsFz>0.9),dat(IsFz>0.9,:)*DecodeBrainState{FzOnly+1}',20,Val(IsFz>0.9),'filled')
        xtmp = LinPos(IsFz>0.9)';
        ytmp = dat(IsFz>0.9,:)*DecodeBrainState{FzOnly+1}';
        ind = find(isnan(xtmp) | isnan(ytmp));
        xtmp(ind) = [];
        ytmp(ind) = [];
        [R,P] = corrcoef(xtmp,ytmp);
        
    else
        scatter(LinPos(Speed>SpeedLim),dat(Speed>SpeedLim,:)*DecodeBrainState{FzOnly+1}',30,'filled','k'), hold on
        scatter(LinPos(Speed>SpeedLim),dat(Speed>SpeedLim,:)*DecodeBrainState{FzOnly+1}',20,Val(Speed>SpeedLim),'filled')
        xtmp = LinPos(Speed>SpeedLim)';
        ytmp = dat(Speed>SpeedLim,:)*DecodeBrainState{FzOnly+1}';
        ind = find(isnan(xtmp) | isnan(ytmp));
        xtmp(ind) = [];
        ytmp(ind) = [];
        [R,P] = corrcoef(xtmp,ytmp);
        
    end
    title(['Corr: R=' num2str(R(1,2)) ' P=' num2str(P(1,2))])
    
    colormap(redblue)
    set(gca,'LineWidth',2,'FontSize',15), box off
    xlabel('Linpos')
    ylabel('Physio proj')
end

%

figure
SpeedLim = 2;
for mm=1:7
subplot(3,3,mm)
    FRZ = nanzscore(AllSess.MouseByMouse.(SessType{FzOnly+1}).FR{mm}')';
    scatter(FRZ'*nanmean(W{1}{mm})',FRZ'*nanmean(W{2}{mm})',15,AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm},'filled')
    hold on
    scatter(FRZ(:,AllSess.MouseByMouse.(SessType{FzOnly+1}).Speed{mm}>SpeedLim)'*nanmean(W{1}{mm})',...
        FRZ(:,AllSess.MouseByMouse.(SessType{FzOnly+1}).Speed{mm}>SpeedLim)'*nanmean(W{2}{mm})',50,AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}(AllSess.MouseByMouse.(SessType{FzOnly+1}).Speed{mm}>SpeedLim))
title([num2str(size(W{1}{mm},2)) ' units'])
xlabel('Shock vs Safe - Act')
ylabel('Shock vs Safe - Fr')

end
colormap(fliplr(redblue(100)')')



figure
for mm=1:7
    DataPCATogether = [];
    DataPCATogether = [AllSess.MouseByMouse.(SessType{FzOnly+1}).OBFreq{(mm)}',log(AllSess.MouseByMouse.(SessType{FzOnly+1}).HPCPower{(mm)})',AllSess.MouseByMouse.(SessType{FzOnly+1}).HR{(mm)}',...
        AllSess.MouseByMouse.(SessType{FzOnly+1}).HRVar{(mm)}',AllSess.MouseByMouse.(SessType{FzOnly+1}).RipplePower{(mm)}'];
    DataPCATogether = DataPCATogether(AllSess.MouseByMouse.(SessType{FzOnly+1}).IsFz{mm}>0.95,:);
    DataPCATogether = nanzscore(DataPCATogether);
    
    subplot(3,3,mm)
    FRZ = nanzscore(AllSess.MouseByMouse.(SessType{FzOnly+1}).FR{mm}')';
    scatter(DataPCATogether*DecodeBrainState{1}',DataPCATogether*DecodeBrainState{2}',15,AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}(AllSess.MouseByMouse.(SessType{FzOnly+1}).IsFz{mm}>0.95),'filled')
    %     hold on
    %     ind = AllSess.MouseByMouse.(SessType{FzOnly+1}).Speed{mm}>SpeedLim;
    %         scatter(DataPCATogether(ind,:)*DecodeBrainState{1}',DataPCATogether(ind,:)*DecodeBrainState{2}',50,AllSess.MouseByMouse.(SessType{FzOnly+1}).LinPos{mm}(ind))
    
    title([num2str(size(W{1}{mm},2)) ' units'])
    xlabel('Shock vs Safe - Act')
    ylabel('Shock vs Safe - Fr')
    
end
colormap(fliplr(redblue(100)')')

figure
AllWDiff = [];
AllWFz = [];
AllWNoFz = [];
for mm=1:7
AllWFz = [AllWFz,nanmean(W{2}{mm})];
AllWNoFz = [AllWNoFz,nanmean(W{1}{mm})];

AllWDiff = [AllWDiff,(nanmean(W{1}{mm})-nanmean(W{2}{mm}))];

end


cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD/PFCUnitFiringOBFrequency
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
load('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoSleep.mat')
FreqLims=[2:0.15:11];
%% Just the sig units
GoodNeur = [];
PNeur = [];
RNeur = [];
AllSpk=[];

for mm=1:length(MiceNumber)
    for sp=1:length(RSpk{mm})
        if IsPFCNeuron{mm}(sp)==1
            
            if RSpk{mm}(sp)>prctile(RSpk_btstrp{mm}(sp,:),97.5)
                GoodNeur = [GoodNeur,1];
            elseif RSpk{mm}(sp)<prctile(RSpk_btstrp{mm}(sp,:),2.5);
                GoodNeur = [GoodNeur,-1];
            else
                GoodNeur = [GoodNeur,0];
            end
            PNeur = [PNeur,PSpk{mm}(sp)];
            RNeur = [RNeur,RSpk{mm}(sp)];

        end
    end

    AllSpk =[AllSpk;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];

end

figure
subplot(131)
scatter(AllWFz,AllWNoFz,20,abs(AllWDiff),'filled')
clim([0 1.5])
xlim([-2 2])
ylim([-2 2])
[R,P] = corrcoef(AllWFz,AllWNoFz);
title(['Corr: R=' num2str(R(1,2)) ' P=' num2str(P(1,2))])
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('WFz')
ylabel('WNoFr')


subplot(132)
scatter(AllWFz,RNeur,20,abs(AllWDiff),'filled')
[p,S,mu] = polyfit(AllWFz,RNeur,1)
f = polyval(p,AllWFz);
hold on,
plot(AllWFz,f)

clim([0 1.5])
xlim([-2 2])
ylim([-0.2 0.4])
[R,P] = corrcoef(AllWFz,RNeur);
title(['Corr: R=' num2str(R(1,2)) ' P=' num2str(P(1,2))])
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('WFz')
ylabel('RNeur')

subplot(133)
scatter(AllWNoFz,RNeur,20,abs(AllWDiff),'filled')
clim([0 1.5])
xlim([-2 2])
ylim([-0.2 0.4])
[R,P] = corrcoef(AllWNoFz,RNeur);
title(['Corr: R=' num2str(R(1,2)) ' P=' num2str(P(1,2))])
[p,S,mu] = polyfit(AllWNoFz,RNeur,1)
f = polyval(p,AllWNoFz);
hold on,
plot(AllWNoFz,f)
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('WNoFz')
ylabel('RNeur')



 figure
 subplot(121)
 Cols = {UMazeColors('Shock'),UMazeColors('Safe')}
 A = {RNeur(abs(GoodNeur)>0 & AllWFz>0.5),RNeur(abs(GoodNeur)>0 & AllWFz<-0.5)};
 MakeSpreadAndBoxPlot_SB(A,Cols,1:2,{},0,0)

 [p,h] = ranksum(RNeur(abs(GoodNeur)>0 & AllWFz>0.5),RNeur(abs(GoodNeur)>0 & AllWFz<-0.5))
 sigstar_DB({[1,2]},[p])
 set(gca,'LineWidth',2,'FontSize',15,'XTick',[1,2],'XTickLabel',{'Shock Pref','Safe Pref'}), box off
 ylabel('Freq Corr - R')
 title('Freezing')
 subplot(122)
 Cols = {UMazeColors('Shock'),UMazeColors('Safe')}
 A = {RNeur(abs(GoodNeur)>0 & AllWNoFz>0.5),RNeur(abs(GoodNeur)>0 & AllWNoFz<-0.5)};
 MakeSpreadAndBoxPlot_SB(A,Cols,1:2,{},0,0)
 
 [p,h] = ranksum(RNeur(abs(GoodNeur)>0 & AllWNoFz>0.5),RNeur(abs(GoodNeur)>0 & AllWNoFz<-0.5))
 sigstar_DB({[1,2]},[p])
 set(gca,'LineWidth',2,'FontSize',15,'XTick',[1,2],'XTickLabel',{'Shock Pref','Safe Pref'}), box off
 ylabel('Freq Corr - R')
 title('No Freezing')
 
 
XRand = rand(1,1000);
YRand = rand(1,1000);
clear RemR
for k =20:20:1000
[R,P] = corrcoef(XRand(1:k),YRand(1:k));
RemR(k/20) = R(1,2);

[p,S,mu] = polyfit(XRand(1:k),YRand(1:k),1)
Remp(k/20) = p(2);
end