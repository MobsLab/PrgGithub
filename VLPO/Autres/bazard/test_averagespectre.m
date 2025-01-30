

chan=[3 6 7 1 0 14];

Signals = cell(0);

for ch=1:length(chan)
    load(['LFPData/LFP' num2str(chan)], 'LFP')
    Signals{ch} = LFP; clear LFP
end


%% spectrogram
mkdir('Spectra')

params.fpass  = [0 48];
params.tapers = [3 5];
movingwin     = [3 0.2];
params.Fs     = 1250;

%for each location of PFCx
for ch=1:length(Signals)
    
    [Sp,t,f]=mtspecgramc(Data(Signals{ch}),movingwin,params);
    Spectro={Sp,t,f};
    
    savefolder = fullfile('Spectra', ['Specg_ch' num2str(channels(ch))]);
    channel =  channels(ch);
    save(savefolder,'Spectro','params','movingwin', 'channel', '-v7.3')

end







[M,S,t]=AverageSpectrogram(tsd(Spectro{3},Spectro{1}'),ts(Spectro{2}),ts(events*1E4),10,1000);




