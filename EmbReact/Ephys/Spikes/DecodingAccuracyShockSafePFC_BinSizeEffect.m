clear all
WndwSzAll = [0.05,0.1,0.2,0.3,0.5,0.7,1,1.5,2,2.5,3]*1e4;
cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')

for w = 1:length(WndwSzAll)
    clear ShockFzsize  SafeFzsize W Score AllDatProj AllDatProjRand ScoreRand MouseByMouse
    
    WndwSz = WndwSzAll(w);
    load(['OverallInfoSpikesOnly',num2str(WndwSz/1e4),'.mat'])
    
    
    
    for mm=1:7
        ShockFzsize(mm) = sum(MouseByMouse.LinPos{mm}<0.4);
        SafeFzsize(mm) = sum(MouseByMouse.LinPos{mm}>0.6);
        
        BinsToUse = floor(min(min([ShockFzsize(mm),SafeFzsize(mm)]))/2);
        
        RemTrialSafe{mm} = nan(length(MouseByMouse.LinPos{mm}),1000);
        RemTrialShock{mm} = nan(length(MouseByMouse.LinPos{mm}),1000);
        FRZ = nanzscore(MouseByMouse.FR{mm}')';
        
        for perm = 1:500
            
            ShockBins = find(MouseByMouse.LinPos{mm}<0.4);
            ShockBinsToUse = ShockBins(randperm(length(ShockBins),BinsToUse*2));
            ShockSideFrTrain = [FRZ(:,ShockBinsToUse(BinsToUse+1:end))];
            ShockSideFrTest = [FRZ(:,ShockBinsToUse(1:BinsToUse))];
            
            SafeBins = find(MouseByMouse.LinPos{mm}>0.6);
            SafeBinsToUse = SafeBins(randperm(length(SafeBins),BinsToUse*2));
            SafeSideFrTrain = [FRZ(:,SafeBinsToUse(BinsToUse+1:end))];
            SafeSideFrTest = [FRZ(:,SafeBinsToUse(1:BinsToUse))];
            
            
            W{mm}(perm,:) = (nanmean(ShockSideFrTrain')-nanmean(SafeSideFrTrain'));
            Bias = (nanmean(ShockSideFrTrain'*W{mm}(perm,:)') + nanmean(SafeSideFrTrain'*W{mm}(perm,:)'))/2;
            clear ShockGuess SafeGuess
            
            for trial = 1 : BinsToUse
                ShockGuess(trial) = ShockSideFrTest(:,trial)'*W{mm}(perm,:)'>Bias;
                SafeGuess(trial) = SafeSideFrTest(:,trial)'*W{mm}(perm,:)'<Bias;
            end
            
            Score(mm,perm) = (nanmean(ShockGuess)+nanmean(SafeGuess))/2;
            
            % Random
            ShockBinsRand = [ShockBinsToUse(BinsToUse+1:end),SafeBinsToUse(BinsToUse+1:end)];
            SafeBinsRand = [SafeBinsToUse(BinsToUse),ShockBinsToUse(BinsToUse+1:end)];
            SafeBinsRand = SafeBinsRand(randperm(length(SafeBinsRand)));
            ShockBinsRand = ShockBinsRand(randperm(length(ShockBinsRand)));
            
            ShockSideFrTrain = [FRZ(:,ShockBinsRand(BinsToUse+1:end))];
            ShockSideFrTest = [FRZ(:,ShockBinsRand(1:BinsToUse))];
            
            SafeSideFrTrain = [FRZ(:,SafeBinsRand(BinsToUse+1:end))];
            SafeSideFrTest = [FRZ(:,SafeBinsRand(1:BinsToUse))];
            
            WRand{mm}(perm,:) = (nanmean(ShockSideFrTrain')-nanmean(SafeSideFrTrain'));
            Bias = (nanmean(ShockSideFrTrain'*WRand{mm}(perm,:)') + nanmean(SafeSideFrTrain'*WRand{mm}(perm,:)'))/2;
            clear ShockGuess SafeGuess
            
            for trial = 1 : BinsToUse
                ShockGuess(trial) = ShockSideFrTest(:,trial)'*WRand{mm}(perm,:)'>Bias;
                SafeGuess(trial) = SafeSideFrTest(:,trial)'*WRand{mm}(perm,:)'<Bias;
            end
            
            ScoreRand(mm,perm) = (nanmean(ShockGuess)+nanmean(SafeGuess))/2;
            AllDatProjRand{mm}(perm,:)=MouseByMouse.FR{mm}'*WRand{mm}(perm,:)';
            
            
        end
    end
    
%     figure
%     clf
%     Cols = {[0.6 0.6 0.6],[1 0.6 0.6]};
%     A = {nanmean(Score'),nanmean(Score')};
%     UpLim = median(prctile(ScoreRand',97.5))-nanmean(ScoreRand(:));
%     LowLim = nanmean(ScoreRand(:)) - median(prctile(ScoreRand',2.5));
%     shadedErrorBar([0.5 1.5],[1 1]*nanmean(ScoreRand(:)),[UpLim UpLim;LowLim LowLim])
%     hold on
%     MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
%     xlim([0.5 1.5])
%     ylim([0 1])
%     
%     keyboard
    
    
    ScoreFinal(w,:) = nanmean(Score');
    UpLimFinal(w,:) = median(prctile(ScoreRand',97.5))-nanmean(ScoreRand(:));
    LowLimFinal(w,:) = nanmean(ScoreRand(:)) - median(prctile(ScoreRand',2.5));
    ScoreRandFinal(w,:) = nanmean(ScoreRand(:));

end



% figure for decoding
figure
errorbar(WndwSzAll/1e4,nanmean(ScoreFinal'),stdError(ScoreFinal'),'linewidth',2,'color','k')
hold on
g = shadedErrorBar(WndwSzAll/1e4,(ScoreRandFinal'),[LowLimFinal,UpLimFinal]);
xlim([0 3.2])
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('Binsize')
ylabel('Accuracy')

