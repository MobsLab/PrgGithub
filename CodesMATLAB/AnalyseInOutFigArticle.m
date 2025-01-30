





cd /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/DataInOut
load DataAdjustOut
tpsOut=tps;
V2Out=V2;
load DataAdjustIn
tpsIn=tps;
V2In=V2;



chF=1/median(diff(tpsIn));



Y=V2In;
%         tpsr=tps;
% figure,plot(tpsr,y-mean(y))
% Transformée de Fourier
L = length(Y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(Y,NFFT)/L;
f = chF*1/2*linspace(0,1,NFFT/2+1);
speIn=abs(yf(1:NFFT/2+1));
fIn=f;
chF=1/median(diff(tpsOut));
Y=V2Out;
%         tpsr=tps;
% figure,plot(tpsr,y-mean(y))
% Transformée de Fourier
L = length(Y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(Y,NFFT)/L;
f = chF*1/2*linspace(0,1,NFFT/2+1);
speOut=abs(yf(1:NFFT/2+1));
fOut=f;

% figure, plot(fIn,smooth(speIn,5))
% hold on, plot(fOut,smooth(speOut,5),'r')



YfIn=FilterLFP(tsd(tpsIn*1E4,V2In),[0.05 0.2],1024);
YfOut=FilterLFP(tsd(tpsOut*1E4,V2Out),[0.05 0.2],1024);
YInL=Data(YfIn);
YOutL=Data(YfOut);
chF=1/median(diff(tpsIn));
Y=YInL;
%         tpsr=tps;
% figure,plot(tpsr,y-mean(y))
% Transformée de Fourier
L = length(Y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(Y,NFFT)/L;
f = chF*1/2*linspace(0,1,NFFT/2+1);
speInL=abs(yf(1:NFFT/2+1));
fInL=f;
chF=1/median(diff(tpsOut));
Y=YOutL;
%         tpsr=tps;
% figure,plot(tpsr,y-mean(y))
% Transformée de Fourier
L = length(Y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(Y,NFFT)/L;
f = chF*1/2*linspace(0,1,NFFT/2+1);
speOutL=abs(yf(1:NFFT/2+1));
fOutL=f;

% figure, plot(fInL,smooth(speInL,5))
% hold on, plot(fOutL,smooth(speOutL,5),'r')



YfIn=FilterLFP(tsd(tpsIn*1E4,V2In),[0.3 3],1024);
YfOut=FilterLFP(tsd(tpsOut*1E4,V2Out),[0.3 3],1024);
YInH=Data(YfIn);
YOutH=Data(YfOut);
chF=1/median(diff(tpsOut));
Y=YOutH;
%         tpsr=tps;
% figure,plot(tpsr,y-mean(y))
% Transformée de Fourier
L = length(Y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(Y,NFFT)/L;
f = chF*1/2*linspace(0,1,NFFT/2+1);
speOutH=abs(yf(1:NFFT/2+1));
fOutH=f;
chF=1/median(diff(tpsIn));
Y=YInH;
%         tpsr=tps;
% figure,plot(tpsr,y-mean(y))
% Transformée de Fourier
L = length(Y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(Y,NFFT)/L;
f = chF*1/2*linspace(0,1,NFFT/2+1);
speInH=abs(yf(1:NFFT/2+1));
fInH=f;



%figure, plot(fInH,smooth(speInH,5))
%hold on, plot(fOutH,smooth(speOutH,5),'r')



speInH=speInH(find(fInH>0.3&fInH<3));
speInL=speInL(find(fInL>0.05&fInL<0.2));
speOutH=speOutH(find(fOutH>0.3&fOutH<3));
speOutL=speOutL(find(fOutL>0.05&fOutL<0.2));

ratioH=(mean(speInH)-mean(speOutH))/mean(speInH)*100;
ratioL=(mean(speInL)-mean(speOutL))/mean(speInL)*100;



PlotErrorBar2(speInH,speOutH)
title(['Example Power Spectrum High frequencey (0.3 to 3 Hz), ratio: ',num2str(ratioH),'%'])
PlotErrorBar2(speInL,speOutL)
title(['Example Power Spectrum Low frequencey (0.05 to 0.2 Hz), ratio: ',num2str(ratioL),'%'])






