toLoad = true;

if toLoad
    load('in-18-2eegHIP LFP.mat')
%    extractSpikes(TTmark13, 'in-18-1spikes')
    load('in-18-2ev_Sync.mat')
    load('in-18-1spikes')
end

sy = Range(Sync);



epochs{1}.label = 'bis 90-121 (15min after injection';
epochs{1}.ix = 1:11;

epochs{2}.label = 'bis 632-790 (20 min after injection)';
epochs{2}.ix = 92:171;

epochs{3}.label = 'bis 928-956 ';
epochs{3}.ix = 172:181;

epochs{4}.label = 'bis 1091-1118 ';
epochs{4}.ix = 182:191;

epochs{5}.label = 'bis 1262-1424 ';
epochs{5}.ix = 192:273;

epochs{6}.label = 'bis 1262-1424 ';
epochs{6}.ix = 192:273;

epochs{7}.label = 'bis 1565-1628 ';
epochs{7}.ix = 274:287;

epochs{8}.label = 'bis 1565-1628 ';
epochs{8}.ix = 274:287;

epochs{8}.label = 'bis 1565-1628 ';
epochs{8}.ix = 274:287;

epochs{9}.label = 'bis 1889-1916 ';
epochs{9}.ix = 288:297;

epochs{10}.label = 'bis 2455-2613 ';
epochs{10}.ix = 378:457;


epochs{11}.label = 'bis 2752-2779 ';
epochs{11}.ix = 458:467;

epochs{12}.label = 'bis 2916-2943 ';
epochs{12}.ix = 468:477;

epochs{13}.label = 'bis 3392-3554 ';
epochs{13}.ix = 558:639;

epochs{14}.label = 'bis 3765-3792 ';
epochs{14}.ix = 640:649;

epochs{15}.label = 'bis 3765-3792 ';
epochs{15}.ix = 640:649;

epochs{16}.label = 'bis 3932-3968 ';
epochs{16}.ix = 650:662;












Fs = 1 / median(diff(Range(EEGHIPLFP, 's')));
params.Fs = Fs;
params.fpass = [0 40];
params.err = [2, 0.95];
params.trialave = 0;



for i = 12:length(epochs)
    fname = ['figures/peth_spectrum_bis' num2str(i) '.png'];
    figure(2)
    subplot(1, 2, 1)
    data = Data(Restrict(EEGHIPLFP, sy(epochs{i}.ix(1)), sy(epochs{i}.ix(end))));
    [S,f,Serr]=mtspectrumc(data,params);
    plot(f, S);
    title(epochs{i}.label);
    subplot(1,2,2);
    [C, B, C2] = CtsdPETH(EEGHIPLFP, sy(epochs{i}.ix), 2000);
    errorbar(B, C, C2/sqrt(length(epochs{i}.ix)));
    set(gca, 'XLim', [-2000, 2000]);
    keyboard
    print('-dpng', fname);
end

