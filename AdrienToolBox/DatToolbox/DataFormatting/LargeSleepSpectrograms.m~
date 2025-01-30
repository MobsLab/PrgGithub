fname = 'Mouse02-110719-01.eeg';
Fs = 1250;
params.Fs = Fs;
freqRange = [30 200];
window = 0.2;
specWindow = 2^round(log2(window*Fs));% choose window length as power of two

nFFT = specWindow*4;
lfp = LoadBinary(fname,'nChannels',33,'channels',1,'frequency',Fs);
Fs = Fs/4;
lfp = lfp-mean(lfp);

lfp = WhitenSignal(lfp,Fs*2000,1);
[S2,f,t] = mtcsglong(lfp,nFFT,Fs,specWindow,[],2,'linear',[],freqRange);
