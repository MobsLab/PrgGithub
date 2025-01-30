%CoherenceManipeSkull


EEG=LFP{10};
ECoG=LFP{11};
LfpS=LFP{15};
LfpD=LFP{13};
Epoch=intervalSet(500*1E4, 870*1E4);

movingwin=[1,0.5];
params.trialave = 0;
params.err = [1 0.05];

fp1=0;
fp2=220;
params.fpass = [fp1 fp2];

params.Fs = 1/median(diff(Range(Restrict(LfpS,Epoch), 's')));
params.tapers=[10 19];
params.pad=4;


[Ca,phia,S12a,S1a,S2a,t,f,confC,phierr]=cohgramc(Data(Restrict(EEG,Restrict(ECoG,Epoch))),Data(Restrict(ECoG,Epoch)),movingwin,params);
[Cb,phib,S12b,S1b,S2b,t,f,confC,phierr]=cohgramc(Data(Restrict(EEG,Restrict(LfpS,Epoch))),Data(Restrict(LfpS,Epoch)),movingwin,params);
[Cc,phic,S12c,S1c,S2c,t,f,confC,phierr]=cohgramc(Data(Restrict(ECoG,Restrict(LfpS,Epoch))),Data(Restrict(LfpS,Epoch)),movingwin,params);
[Cd,phid,S12d,S1d,S2d,t,f,confC,phierr]=cohgramc(Data(Restrict(EEG,Restrict(LfpD,Epoch))),Data(Restrict(LfpD,Epoch)),movingwin,params);
[Ce,phie,S12e,S1e,S2e,t,f,confC,phierr]=cohgramc(Data(Restrict(ECoG,Restrict(LfpD,Epoch))),Data(Restrict(LfpD,Epoch)),movingwin,params);
[Cf,phif,S12f,S1f,S2f,t,f,confC,phierr]=cohgramc(Data(Restrict(LfpS,Restrict(LfpD,Epoch))),Data(Restrict(LfpD,Epoch)),movingwin,params);

figure('color',[1 1 1]),
subplot(6,2,1), imagesc(t,f,Ca'), axis xy, title('EEG vs. ECoG')
subplot(6,2,3), imagesc(t,f,Cb'), axis xy, title('EEG vs. LFP superficiel')
subplot(6,2,7), imagesc(t,f,Cc'), axis xy, title('ECoG vs. LFP superficiel')
subplot(6,2,5), imagesc(t,f,Cd'), axis xy, title('EEG vs. LFP deep')
subplot(6,2,9), imagesc(t,f,Ce'), axis xy, title('ECoG vs. LFP deep')
subplot(6,2,11), imagesc(t,f,Cf'), axis xy, title('LFP superficiel vs. LFP deep')

subplot(6,2,2), plot(f,mean(Ca),'k'), title('EEG vs. ECoG')
subplot(6,2,4), plot(f,mean(Cb),'k'), title('EEG vs. LFP superficiel')
subplot(6,2,8), plot(f,mean(Cc),'k'), title('ECoG vs. LFP superficiel')
subplot(6,2,6), plot(f,mean(Cd),'k'), title('EEG vs. LFP deep')
subplot(6,2,10), plot(f,mean(Ce),'k'), title('ECoG vs. LFP deep')
subplot(6,2,12), plot(f,mean(Cf),'k'), title('LFP superficiel vs. LFP deep')

figure('color',[1 1 1]),
subplot(2,1,1), hold on,
plot(f,mean(Cd),'k','linewidth',2), title('Coherence EEG/LFP superfical (red) vs deep (black)')
plot(f,mean(Cb),'r','linewidth',2)
subplot(2,1,2), hold on,
plot(f,mean(Ce),'k','linewidth',2), title('Coherence ECoG/LFP superfical (red) vs deep (black)')
plot(f,mean(Cc),'r','linewidth',2)


%save DataCoherenceManipeSkull

fact=1;

Epoch2=intervalSet(300*1E4, 870*1E4);


dat=Data(Restrict(LfpS,Epoch2));
cdeb=1;
cfin=length(dat);
Fs=params.Fs;%Hz
L = length(dat);                     % Length of signal
NFFT1 = 2^nextpow2(L); % Next power of 2 from length of y
   NFFT1=2048;
%     NFFT1=1024;
 %   NFFT1=512;
%y=smooth(dat(cdeb:cfin),fact);
y=dat(cdeb:cfin);
Y1 = fft(y,NFFT1)/L;
f1 = Fs/2*linspace(0,1,NFFT1/2);
pow1=f1'.*abs(Y1(1:NFFT1/2)*2);


dat2=Data(Restrict(LfpD,Epoch2));
Fs=params.Fs;%Hz
L2 = length(dat2);                     % Length of signal
NFFT2 = 2^nextpow2(L2); % Next power of 2 from length of y
    NFFT2=2048;
%    NFFT2=1024;
 %  NFFT2=512;
%y=smooth(dat(cdeb:cfin),fact);
y2=dat2(cdeb:cfin);
Y2 = fft(y2,NFFT2)/L2;
f2 = Fs/2*linspace(0,1,NFFT2/2);
pow2=f2'.*abs(Y2(1:NFFT2/2)*2);


smo=1;

figure('color',[1 1 1]),
subplot(2,2,1), hold on, 
plot(f1,pow1,'k','linewidth',1), xlim([0 220])
plot(f2,pow2,'r','linewidth',1), xlim([0 220])
subplot(2,2,2), hold on, 
plot(f1,10*log10(abs(Y1(1:NFFT1/2)*2)),'k','linewidth',1), xlim([0 220])
plot(f2,10*log10(abs(Y2(1:NFFT2/2)*2)),'r','linewidth',1), xlim([0 220])



subplot(2,2,3), hold on, 
plot(f1,SmoothDec(pow1,smo),'k','linewidth',1), xlim([0 220])
plot(f2,SmoothDec(pow2,smo),'r','linewidth',1), xlim([0 220])
subplot(2,2,4), hold on, 
plot(f1,SmoothDec(10*log10(abs(Y1(1:NFFT1/2)*2)),smo),'k','linewidth',1), xlim([0 220])
plot(f2,SmoothDec(10*log10(abs(Y2(1:NFFT2/2)*2)),smo),'r','linewidth',1), xlim([0 220])



