function [nbDownSWS, nbDownWake, DurDownSWS, DurDownWake]=FindDownThreshDuration(S,neurons,SWSEpoch,WakeEpoch,binsize,thresholds,minDurBins,ch,toplot)


% Plot a color map to find the good parameters of downstate detection
% Plot the difference in the amount of downstate detected between SWS and
% other states, in function of their minimum duration and spiking threshold
% 
% thresholds = 0.01:0.03:0.5;
% [nbDownSWS, nbDownWake, DurDownSWS, DurDownWake]=FindDownThreshDuration(S,NumNeurons,SWSEpoch,Wake, binSize,thresholds, minDurBins,1,1);


try
    fac;
    fac = fac * 10;
catch
    fac=[0 0];
end

try
    toplot;
catch
    toplot=1;
end

% Extract MUA
binsize=binsize * 10; %binsize in E-4s, for MUA
T=PoolNeurons(S,neurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q=MakeQfromS(ST,binsize);


% Type of thresholds
if ch==0
    thresh = ones(length(thresholds)) * 0.01;
elseif ch==1
    thresh = thresholds * mean(full(Data(Q)));
elseif ch==2
    thresh = thresholds * max(full(Data(Q)));
elseif ch ==3
    thresh = thresholds * median(full(Data(Q)));
end
% bins of downstate duration, for histogram
bins_hist = 0:floor(binsize/10):2000;

%resulting matrix, for colormap plot
nbDownSWS = zeros(length(thresh), length(minDurBins));
nbDownWake = zeros(length(thresh), length(minDurBins));


%Loop over firing thresholds and minimum duration
for i=1:length(thresh)
    th = thresh(i);
    Down=thresholdIntervals(Q,th,'Direction','Below');
    DurTsd=tsd(Start(Down),End(Down,'ms') - Start(Down,'ms'));
    [h1,b1]=hist(Data(Restrict(DurTsd,SWSEpoch)),bins_hist);
    [h2,b2]=hist(Data(Restrict(DurTsd,WakeEpoch)),bins_hist);
    
    for j=1:length(minDurBins)
        bmin = minDurBins(j);
        nbDownSWS(i,j) = sum(h1(b1>bmin));
        nbDownWake(i,j) = sum(h2(b2>bmin));
    end  
end

% Total durations of Epochs
DurDownSWS=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
DurDownWake=sum(End((WakeEpoch),'s')-Start((WakeEpoch),'s'));


%% Plot
if toplot
    figure, hold on
    for i=1:length(thresh)
        hold on, subplot(4,5,i)
        hold on, plot(minDurBins, nbDownSWS(i,:), 'r','linewidth',2)
        hold on, plot(minDurBins, nbDownWake(i,:), 'k','linewidth',2)
        hold on, set(gca,'yscale','log')
        hold on, set(gca,'xscale','log')
        hold on, set(gca,'xtick',[10 50 100 500 1500])
        hold on, title(['Threshold=',num2str(thresholds(i))]) 
    end
    hold off

    figure, hold on
    
    subplot(1,2,1)
    imagesc(minDurBins, thresholds, results_norm)
    colorbar
    
    subplot(1,2,2)
    imagesc(minDurBins, thresholds, results)
    colorbar
end






