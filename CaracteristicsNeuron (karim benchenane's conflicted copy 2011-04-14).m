%CaracteristicsNeuron


%--------------------------------------------------------------------------
%% Parametre generaux
%--------------------------------------------------------------------------

try
    NumNeuron;
catch
    NumNeuron=2;
end

Rip=1; % pas d'analyse des Ripples (pour analysier les ripples : Rip=1)


try
    load SpikeData
    load LFPData
    %load behavResources
    %Pos;
    S;
    lfp;
catch
    
makeData

end


rg=Range(LFP{2});
Epoch=intervalSet(rg(1),rg(end));




b=NumNeuron;

spike=S{NumNeuron}; % numero du neurone


try
     voieLFPref;
        voieLFP=voieLFPRef;
catch

tt=TT{NumNeuron}(1);

if tt<5
    voieLFP=(tt-1)*4+3;
else    
    voieLFP=(tt-5)*4+3;
end

 end


lfp=LFP{voieLFP};

rg=Range(lfp);

Epoch=intervalSet(rg(1),rg(end));


cellnames{NumNeuron}

NumNeuron
voieLFP


%--------------------------------------------------------------------------
%% effacer les periodes avec du bruit
%--------------------------------------------------------------------------

try 
    load GoodEpoch;
    
    catch
    
SetCurrentSession
[data,indices] = GetWideBandData(2);
datatsd=tsd(data(:,1)*1E4,data(:,2));

FilparamG=96;
FilGood=FilterLFP(datatsd,[900,5000],FilparamG);
zrGood = hilbert(Data(FilGood));
powerGood=abs(zrGood);
powerGoodTsd=tsd(Range(FilGood),powerGood);
th=percentile(powerGood,10);

GoodEpoch = thresholdIntervals(powerGoodTsd, th,'Direction','Below');
GoodEpoch=mergecloseIntervals(GoodEpoch,50);

GoodEpoch=dropshortIntervals(GoodEpoch,150);

save GoodEpoch GoodEpoch

clear data
clear dataTsd

end


spike=Restrict(spike,GoodEpoch);
try
    
X=Restrict(X,GoodEpoch);
Y=Restrict(Y,GoodEpoch);
V=Restrict(V,GoodEpoch);
%lfp=Restrict(lfp,GoodEpoch);
end


%--------------------------------------------------------------------------
%% Resampling LFP
%--------------------------------------------------------------------------

re=10;

lfpr=resample(Data(lfp),1,re);
tpsr=[1:length(lfpr)];
tpsr=rescale(tpsr,rg(1),rg(end));
lfp=tsd(tpsr,lfpr);


%--------------------------------------------------------------------------
%% Filtrage
%--------------------------------------------------------------------------

Filparam=1024;
Fil=FilterLFP(lfp,[5,10],Filparam);


%--------------------------------------------------------------------------
%% Verification bon Filtre
%--------------------------------------------------------------------------

zr = hilbert(Data(Fil));
phzr = atan2(imag(zr), real(zr));
phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
% figure, hist(phzr,100)

%--------------------------------------------------------------------------
%% Calcul modulation theta
%--------------------------------------------------------------------------

zrTheta = hilbert(Data(Fil));

power=abs(zrTheta);
powerTsd=tsd(Range(Fil),power);

th=percentile(power,50);

ThetaEpoch = thresholdIntervals(powerTsd, th);


figure('Color',[1 1 1])
try
[ph,mu, Kappa, pval]=ModulationTheta(spike,Fil,ThetaEpoch,10);
end
try
    [phe,mue, Kappae, pvale]=ModulationTheta(spike,Fil,Epoch,10);
end
close

figure('Color',[1 1 1])
try
    subplot(2,2,1),JustPoltMod(Data(ph{1}),15);
end
try
    subplot(2,2,2),rose(Data(ph{1}));
end
try
    subplot(2,2,3),JustPoltMod(Data(phe{1}),15);
end
try
    subplot(2,2,4),rose(Data(phe{1}));
end


%--------------------------------------------------------------------------
%% Calcul modulation gamma
%--------------------------------------------------------------------------


FilparamG=96;
FilG=FilterLFP(LFP{voieLFP},[60,100],FilparamG);

zrG = hilbert(Data(FilG));
phzrG = atan2(imag(zrG), real(zrG));
phzrG(phzrG < 0) = phzrG(phzrG < 0) + 2 * pi;
% figure, hist(phzrG,100)


zrGamma = hilbert(Data(FilG));

powerG=abs(zrGamma);
powerGTsd=tsd(Range(FilG),powerG);

th=percentile(powerG,50);

GammaEpoch = thresholdIntervals(powerGTsd, th);


figure('Color',[1 1 1])
try
[phG,muG, KappaG, pvalG]=ModulationTheta(spike,FilG,GammaEpoch,10);
end
try
    [phGe,muGe, KappaGe, pvalGe]=ModulationTheta(spike,FilG,Epoch,10);
close 
end

figure('Color',[1 1 1])
try
subplot(2,2,1),JustPoltMod(Data(phG{1}),15);
end
try
    subplot(2,2,2),rose(Data(phG{1}));
end
try
    subplot(2,2,3),JustPoltMod(Data(phGe{1}),15);
end
try
    subplot(2,2,4),rose(Data(phGe{1}));
end




%--------------------------------------------------------------------------
%% Clacul modulation 2-40 Hz
%--------------------------------------------------------------------------

if 0
[HS,Ph,ModTheta]=RayleighFreq(lfp,spike,0.05);
end


%--------------------------------------------------------------------------
%% AutoCorrelogramme
%--------------------------------------------------------------------------

if 1
    
[C,B]=CrossCorr(Range(spike),Range(spike),1,60);
C(B==0)=0;

[Cl,Bl]=CrossCorr(Range(spike),Range(spike),10,100);
Cl(Bl==0)=0;


figure('Color',[1 1 1])
subplot(4,2,[1,3]), bar(B,C,1,'k'), xlim([-30 30]),title([cellnames{NumNeuron}, '   Firing rate: ',num2str(floor(length(spike)/(End(Epoch,'s')-Start(Epoch,'s'))*100)/100),'Hz'])
subplot(4,2,[5,7]), bar(Bl,Cl,1,'k'), xlim([-500 500])

for i=1:4
subplot(4,2,2*i), 
try 
hold on
plot(mean(squeeze(W{NumNeuron}(:,i,:))),'k','linewidth',2) 
plot(mean(squeeze(W{NumNeuron}(:,i,:)))+std(squeeze(W{NumNeuron}(:,i,:))),'Color',[0.7 0.7 0.7]) 
plot(mean(squeeze(W{NumNeuron}(:,i,:)))-std(squeeze(W{NumNeuron}(:,i,:))),'Color',[0.7 0.7 0.7]) 

end
end

end


%--------------------------------------------------------------------------
%% place Fied
%--------------------------------------------------------------------------



try
the=percentile(Data(V),60);
Mvt=thresholdIntervals(V, the,'Direction','Above');
Immob=thresholdIntervals(V, the,'Direction','Below');

end



try
[map,stats,px,py]=PlaceField(spike,X,Y);
[map,stats,px,py]=PlaceField(Restrict(spike,Mvt),Restrict(X,Mvt),Restrict(Y,Mvt));
%[map,stats,px,py]=PlaceField(Restrict(spike,Immob),Restrict(X,Immob),Restrict(Y,Immob));
end


%--------------------------------------------------------------------------
% Power spectrum du lfp
%--------------------------------------------------------------------------


if 0
    
    
params.Fs=1/median(diff(Range(lfp,'s')));
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 40];
params.tapers=[10 19];
      
[Spect,f]=mtspectrumc(Data(lfp),params);

movingwin=[4 0.1];
params.tapers=[2 3];
[SpectroG,tsg,fsg]=mtspecgramc(Data(lfp),movingwin,params);

figure, 
subplot(2,1,1), imagesc(tsg,fsg,10*log10(SpectroG')), axis xy

Sgram=tsd(tsg'*1E4,10*log10(SpectroG));
subplot(2,1,2), imagesc(Range(Restrict(Sgram,GoodEpoch),'s'),fsg,Data(Restrict(Sgram,GoodEpoch))'), axis xy

figure('Color',[1 1 1])
subplot(2,2,1), plot(f,10*log10(Spect))

%--------------------------------------------------------------------------

Yy=Data(lfp);

L = length(Yy);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(Yy,NFFT)/L;
f2 = params.Fs*1/2*linspace(0,1,NFFT/2+1);
spe=abs(yf(1:NFFT/2+1));

% figure('Color',[1 1 1])
subplot(2,2,2), 
hold on, plot(f2,spe)
% plot(f2,Smooth(spe,5),'r','linewidth',2)
plot(f2(1:20:end),Smooth(spe(1:20:end),5),'r','linewidth',2)
xlim([2 40])        

Yb=Data(LFP{b});
Fs=1/median(diff(Range(LFP{b},'s')));
Lb = length(Yb);
NFFTb = 2^nextpow2(Lb); % Next power of 2 from length of y
yfb  = fft(Yb,NFFTb)/Lb;
f2b = Fs*1/2*linspace(0,1,NFFTb/2+1);
speb=abs(yfb(1:NFFTb/2+1));


% figure('Color',[1 1 1])
subplot(2,2,3), 
pas=30;
% subplot(1,2,1), 
plot(f2(1:pas:end),Smooth(spe(1:pas:end),5),'k','linewidth',2)
xlim([3 20])
pasb=100;
subplot(2,2,4), 
% subplot(1,2,2), 
plot(f2b(1:pasb:end),Smooth(speb(1:pasb:end),5),'k','linewidth',2)
xlim([30 100])
yl=ylim;
hold on, line([50 50],[yl(1) yl(2)],'Color','r')

end

%--------------------------------------------------------------------------
%% FInd Ripples
%--------------------------------------------------------------------------

if Rip
    
FilRip=FilterLFP(LFP{voieLFP},[130 200],96);
filtered=[Range(FilRip,'s') Data(FilRip)];


if 1
[ripples,stdev,noise] = FindRipples(filtered);
[ripples,stdev,noise] = FindRipples(filtered,'thresholds',[2 4]);
end

if 0
NoiseRip=FilterLFP(LFP{4},[130 200],96);
filteredNoise=[Range(NoiseRip,'s') Data(NoiseRip)];
FilRip=FilterLFP(LFP{a},[130 200],96);
filtered=[Range(FilRip,'s') Data(FilRip)];
[ripples,stdev,noise] = FindRipples(filtered,'thresholds',[3 5],'noise',filteredNoise,'show','off');
end

[maps,data,stats] = RippleStats(filtered,ripples);
PlotRippleStats(ripples,maps,data,stats)


save RippleEvents ripples stdev noise maps data stats

%--------------------------------------------------------------------------
%% PETH Neuron vs Ripples
%--------------------------------------------------------------------------


figure('Color',[1 1 1])
[fh,sq,sweeps] = RasterPETH(S{NumNeuron}, ts(ripples(:,2)*1E4), -2000, +2000,'BinSize',10);


%--------------------------------------------------------------------------
%% Correlation Neuron vs Ripples
%--------------------------------------------------------------------------

if 0
    
ratek = MakeQfromS(S,100);
rate = Data(ratek);
ratek = tsd(Range(ratek),rate(:,NumNeuron));

figure, [fh, rasterAx, histAx, matVal] = ImagePETH(ratek, ts(ripples(:,2)*1E4), -2000, +2000,'BinSize',100);

RipSpk=Data(matVal)';
RipAmp=maps.amplitude;

s1=size(RipAmp,2);
s2=size(RipSpk,2);
ampRip=mean(RipAmp(:,floor(s1/2)-3:floor(s1/2)+3)');
spkRip=mean(RipSpk(:,floor(s2/2)-3:floor(s2/2)+3,:)');

figure, 
subplot(2,2,1),imagesc([-200:200],[1:size(ripples,1)],SmoothDec(RipSpk,[0.001,2])), axis xy
subplot(2,2,3), imagesc([-50:50],[1:size(ripples,1)],RipAmp), axis xy
subplot(2,2,[2,4]), plot(spkRip,ampRip,'ko','MarkerFaceColor','k')
end

end
