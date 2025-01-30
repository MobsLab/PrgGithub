toLoad = true;

if toLoad
    load('in-18-1eegPFC LFP.mat')
%    extractSpikes(TTmark13, 'in-18-1spikes')
    load('in-18-1ev_Sync.mat')
    load('in-18-1spikes')
end

sy = Range(Sync);



epochs{1}.label = '215-656 s';
epochs{1}.ix = 1:213;

epochs{2}.label = '215-656 s';
epochs{2}.ix = 214:321;

epochs{3}.label = '1611-1769s';
epochs{3}.ix = 375:454;

epochs{4}.label = '2551-2700s';
epochs{4}.ix = 475:494;

epochs{5}.label = '3310-3470s';
epochs{5}.ix = 495:574;

epochs{6}.label = '3834-3968s';
epochs{6}.ix = 586:653;

epochs{7}.label = '4762-4855s';
epochs{7}.ix = 664:684;

epochs{8}.label = '4984-5144s';
epochs{8}.ix = 686:766;

epochs{9}.label = '7016-7182s 5 min from injection';
epochs{9}.ix = 858:941;

epochs{10}.label = '7337-7364s 10 mins from injection';
epochs{10}.ix = 942:951;



Fs = 1 / median(diff(Range(EEGPFCLFP, 's')));
params.Fs = Fs;
params.fpass = [0 40];
params.err = [2, 0.95];
params.trialave = 0;



for i = 1:length(epochs)
    fname = ['figures/peth_spectrum_pfc_' num2str(i) '.png'];
    figure(2)
    subplot(1, 2, 1)
    data = Data(Restrict(EEGPFCLFP, sy(epochs{i}.ix(1)), sy(epochs{i}.ix(end))));
    [S,f,Serr]=mtspectrumc(data,params);
    plot(f, S);
    title(epochs{i}.label);
    subplot(1,2,2);
    [C, B, C2] = CtsdPETH(EEGPFCLFP, sy(epochs{i}.ix), 1000);
    errorbar(B, C, C2/sqrt(length(epochs{i}.ix)));
    set(gca, 'XLim', [-1000, 1000]);
    keyboard
    print('-dpng', fname);
end

