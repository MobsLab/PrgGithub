%TestGammaAverageDown

cd('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243')

clear
load('LFPData/LFP27.mat')
load('DownState.mat', 'down_PFCx')
st_down = Start(down_PFCx);
events = st_down;


nBins=200;
binsize = 5;

movingwin=[0.1 0.005];
params.fpass=[0.5 500];
params.tapers=[2 3];
logplot=1;

%params
samplingRate = round(1/median(diff(Range(LFP,'s'))));
params.Fs    = samplingRate;


[Specg, t_spg,frequencies] = mtspecgramc(Data(LFP), movingwin, params);
if logplot
    Specg=10*log10(Specg);   
end

%% Average
clear mean_specgram
for i=1:length(frequencies)
    [mean_specgram(i,:), ~, times] = mETAverage(events, t_spg'*1e4, Specg(:,i), binsize, nBins);
end


figure('color',[1 1 1]), hold on

imagesc(times/1E3, frequencies,zscore(mean_specgram,[],2)), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
xlabel('Times (s)')    
xlim([times(2) times(end-1)]/1E3)
ylim([frequencies(1) frequencies(end)]) 




