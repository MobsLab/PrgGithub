% plot the data in function of theta power at time of stim
try 
    load StateEpoch
    
catch
    disp('... no state Epoch was found, aborting...'); return
end
load LocalGlobalAssignment  

%% compute theta index based on Hpc channel

disp('... Computing Theta index')
load LFP13 % change for Hpc channel
LFP = LFP13; clearvars LFP13
    
% compute theta ratio
FilTheta=FilterLFP(LFP,[5 10],1024);
FilDelta=FilterLFP(LFP,[3 6],1024);

HilTheta=hilbert(Data(FilTheta));
HilDelta=hilbert(Data(FilDelta));

H=abs(HilDelta);
H(H<100)=100;

ThetaRatio=abs(HilTheta)./H;
rgThetaRatio=Range(FilTheta,'s');
ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);
%figure, plot(Range(ThetaRatioTSD, 's'), Data(ThetaRatioTSD))

%% plot lfp in function of theta power    
list_channel = [ 2 4 8 11 13];
for chan = list_channel
    clearvars LFP
    disp([ 'loading channel ' num2str(chan) ])
    eval(['load LFP' num2str(chan) ])
    eval(['LFP = LFP' num2str(chan) '; clearvars LFP' num2str(chan) ';'])
    
   
    disp('ploting standards')
    
    ThetaIndex = Restrict(ThetaRatioTSD, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])));
    [thet, order] = sort(Data(ThetaIndex));
    
    
    %local_Effect
%     figure, [fh, rasterAx, histAx, MLstd1]=ImagePETH(LFP, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);%close
    figure, [fh, rasterAx, histAx, MLstd1]=ImagePETH(LFP, ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
    %figure, [fh, rasterAx, histAx, MLstd1]=ImagePETH(LFP, Restrict(ts(sort([LocalStdGlobStdA;LocalStdGlobStdB])), SWSEpoch), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);%close
    %figure, [fh, rasterAx, histAx, MLdev1]=ImagePETH(LFP, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);%close
     Mtest=Data(MLstd1)';
    figure, subplot(1,2,1), imagesc(Mtest); title('Local Standards')
    subplot(1,2,2), imagesc(Mtest(order,:)),axis xy, title('Local Stabdards ordered by theta index')
       
   
    f1 = figure;
    subplot(2,1,1);plot(Range(MLstd1,'ms'),mean(Mtest(order(1:300),:)),'k'),hold on, plot(Range(MLstd1,'ms'),mean(Mtest(order(end-300:end),:)),'r'); 
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    
     disp('ploting deviants')
    ThetaIndex = Restrict(ThetaRatioTSD, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])));
    [thet, order] = sort(Data(ThetaIndex));
    
    figure, [fh, rasterAx, histAx, MLstd1]=ImagePETH(LFP, ts(sort([LocalDvtGlobStdA;LocalDvtGlobStdB])), -2000, +11000,'BinSize',800);title(['Block Local std - Global Standard   A']);close
    Mtest=Data(MLstd1)';
    figure, subplot(1,2,1), imagesc(Mtest); title('Local Deviants')
    subplot(1,2,2), imagesc(Mtest(order,:)),axis xy, title('Local Deviants ordered by theta index')
    
    figure(f1);
    subplot(2,1,2); plot(Range(MLstd1,'ms'),mean(Mtest(order(1:300),:)),'k'),hold on, plot(Range(MLstd1,'ms'),mean(Mtest(order(end-300:end),:)),'r')
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    title(['channel ' num2str(chan)])

end