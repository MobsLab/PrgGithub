% get the "good responses and looks in function of first peak stimulus

load LocalGlobalAssignment
ThalIndex = 1;
if ThalIndex
    load LFP24 %11
    LFP= LFP24; clearvars LFP24
    % order for std
    figure, [fh, rasterAx, histAx, MLstd1]=ImagePETH(LFP, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
    MtestThal=Data(MLstd1)';
    
    % explude artefacted trials
    ArtifTest = max(abs(MtestThal),[], 2);
    Threshold = median(ArtifTest)+3*std(ArtifTest);
    rejectedstd = find(ArtifTest>Threshold);
    MtestThal(rejectedstd, :) = NaN;
    
    % gets the amplitude of first response
    Time = Range(MLstd1,'ms');
    Pre = nanmean(MtestThal(:,find((Time>20) & (Time<30))),2);
    Peak = nanmean(MtestThal(:, find((Time>55) & (Time<75))),2);
    IndexResp = abs(Peak-Pre);
    [ampl, orderstd] = sort(IndexResp);
    figure, subplot(1,2,1), imagesc(MtestThal); title('Local Standards')
    subplot(1,2,2), imagesc(MtestThal(orderstd,:)),axis xy, title('Local Stabdards ordered by theta index')
    
    
    
    
    
    % order for dev
    figure, [fh, rasterAx, histAx, MLstd1]=ImagePETH(LFP, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
    MtestdevThal=Data(MLstd1)';
    
    % explude artefacted trials
    ArtifTest = max(abs(MtestdevThal),[], 2);
    Threshold = median(ArtifTest)+3*std(ArtifTest);
    rejecteddev = find(ArtifTest>Threshold);
    MtestdevThal(rejecteddev, :) = NaN;
    
    % gets the amplitude of first response
    Time = Range(MLstd1,'ms');
    Pre = mean(MtestdevThal(:,find((Time>20) & (Time<30))),2);
    Peak = mean(MtestdevThal(:, find((Time>55) & (Time<75))),2);
    IndexResp = abs(Peak-Pre);
    [ampl, orderdev] = sort(IndexResp);
    figure, subplot(1,2,1), imagesc(MtestdevThal); title('Local dev')
    subplot(1,2,2), imagesc(MtestdevThal(orderdev,:)),axis xy, title('Local dev ordered by theta index')
    
    
end
list_channel = 17;%[ 2];% 3];% 4 5 7:15];




for chan = list_channel
    %% load the channel
    clearvars LFP
    disp([ 'loading channel ' num2str(chan) ])
    eval(['load LFP' num2str(chan) ])
    eval(['LFP = LFP' num2str(chan) '; clearvars LFP' num2str(chan) ';'])
    
    %% standards
    
    
    % gets the trials
    figure, [fh, rasterAx, histAx, MLstd1]=ImagePETH(LFP, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
    Mtest=Data(MLstd1)';
    
    
    % explude artefacted trials
    ArtifTest = max(abs(Mtest),[], 2);
    Threshold = median(ArtifTest)+3*std(ArtifTest);
    Mtest(ArtifTest>Threshold, :) = NaN;
    Mtest(rejectedstd,:) = NaN;
    if ThalIndex == 0
        % gets the amplitude of first response
        Time = Range(MLstd1,'ms');
        Pre = mean(Mtest(:,find((Time>20) & (Time<30))),2);
        Peak = mean(Mtest(:, find((Time>55) & (Time<75))),2);
        IndexResp = abs(Peak-Pre);
        [ampl, orderstd] = sort(IndexResp);
    end
    figure, subplot(1,2,1), imagesc(Mtest); title('Local Standards')
    subplot(1,2,2), imagesc(Mtest(orderstd,:)),axis xy, title('Local Stabdards ordered by theta index')
    
    
    f1 = figure;
    subplot(2,1,1);plot(Range(MLstd1,'ms'),nanmean(Mtest(orderstd(1:100),:)),'k'),hold on, plot(Range(MLstd1,'ms'),nanmean(Mtest(orderstd(end-100:end),:)),'r'); plot(Range(MLstd1,'ms'),nanmean(Mtest(orderstd(200:end-200),:)),'b');
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    title(['channel ' num2str(chan)])
    
    f2 = figure; plot(Range(MLstd1,'ms'),nanmedian(Mtest),'k'),hold on
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    title(['channel ' num2str(chan)])
    
    %% same for deviants
    
    % gets the trials
    figure, [fh, rasterAx, histAx, MLstd1]=ImagePETH(LFP, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
    Mtestdev=Data(MLstd1)';
    
    
    % explude artefacted trials
    ArtifTest = max(abs(Mtestdev),[], 2);
    Threshold = median(ArtifTest)+3*std(ArtifTest);
    Mtestdev(ArtifTest>Threshold, :) = NaN;
    Mtestdev(rejecteddev,:) = NaN;
    if ThalIndex ==0
        % gets the amplitude of first response
        Time = Range(MLstd1,'ms');
        Pre = mean(Mtestdev(:,find((Time>20) & (Time<30))),2);
        Peak = mean(Mtestdev(:, find((Time>55) & (Time<75))),2);
        IndexResp = abs(Peak-Pre);
        [ampl, orderdev] = sort(IndexResp);
    end
    figure, subplot(1,2,1), imagesc(Mtestdev); title('Local Deviants')
    subplot(1,2,2), imagesc(Mtestdev(orderdev,:)),axis xy, title('Local Deviants ordered by theta index')
    
    
    figure(f1);
    subplot(2,1,2);plot(Range(MLstd1,'ms'),nanmean(Mtestdev(orderdev(1:100),:)),'k'),hold on, plot(Range(MLstd1,'ms'),nanmean(Mtestdev(orderdev(end-100:end),:)),'r'); plot(Range(MLstd1,'ms'),nanmean(Mtestdev(orderdev(200:end-200),:)),'b');
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    
    figure(f2)
    plot(Range(MLstd1,'ms'),nanmedian(Mtestdev),'r')
    
end
Mtest_order = Mtest(orderstd,:);
MtestThal_order = MtestThal(orderstd,:);
nantrials = find(isnan(nanmean(Mtest_order,2)));
nanlist = nantrials;
nantrials = find(isnan(nanmean(MtestThal_order,2)));
nanlist = [nanlist; nantrials];
nanlist = unique(nanlist);
Mtest_order(nanlist, :) = [];
MtestThal_order(nanlist, :) = [];
[r,p]=corrcoef([Mtest_order,MtestThal_order]);
figure, imagesc(r)
caxis([-0.4 0.4])