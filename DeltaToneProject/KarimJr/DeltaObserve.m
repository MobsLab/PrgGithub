function DeltaObserve()
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZATION
load('newDeltaPFCx.mat')
load('DeltaSleepEvent.mat', 'TONEtime2')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% AutoCorr of delta events, by sleep periods
deltas = Range(ts(tDelta),'ms');
time_lim = [0 2 4 6 8] * 3600 * 1000;
binsize = 200;
nbins = 2000;

n_row = ceil(length(time_lim)/2);

figure; hold on
for i=1:length(time_lim)
    if i == length(time_lim)
        time_deltas = deltas(deltas>time_lim(i));
        sub_title = [num2str(time_lim(i)/3600000) 'h - end'];
    else    
        time_deltas = deltas(deltas>time_lim(i) & deltas<time_lim(i+1));
        sub_title = [num2str(time_lim(i)/3600000) 'h - ' num2str(time_lim(i+1)/3600000) 'h'];
    end
    [C, B] = CrossCorr(time_deltas, time_deltas, binsize, nbins);
    C(nbins/2+1) = 0;
    subplot(n_row,2,i), hold on
    plot(B,C)
    title(sub_title)
end






