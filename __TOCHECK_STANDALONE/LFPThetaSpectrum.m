function [FPeak,Peak,FPeak3,Peak3,FPeakt,Peakt,FPeak3t,Peak3t,FPeake,Peake,FPeak3e,Peak3e,f,S2m,S3m,S2mt,S3mt,S2me,S3me,DataCh]=LFPThetaSpectrum(lfp,DataCh);



params.Fs=1167;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 30];
params.tapers=[10 19];

try 

DataCh{1};
num1=DataCh{1};
num2=DataCh{2};
DataCh{10};
Lfp=DataCh{3};
Fil=DataCh{4};
rg=DataCh{5};
S=DataCh{6};
f=DataCh{7};
t=DataCh{8};
params=DataCh{9};
movingwin=DataCh{10};


catch

disp('Calcul')
Lfp=tsd([1:length(lfp)]/params.Fs*1E4, lfp);

Filparam=1024;
Fil=FilterLFP(Lfp,[4,12],Filparam);

rg=Range(Lfp,'s');

movingwin=[3 0.2];
params.tapers=[3 5];
[S,t,f]=mtspecgramc(Data(Lfp),movingwin,params);



end







Stsd=tsd(t*1E4,S);

S2=S';
S3=10*log10(S');


power=mean(S2(f>5&f<12,:))./mean(S2(f>2&f<6,:));
PowerTsd=tsd(t'*1E4,power');
S2tsd=tsd(t'*1E4,S2');

power3=mean(S3(f>5&f<12,:))./mean(S3(f>2&f<6,:));
PowerTsd3=tsd(t'*1E4,power3');
S3tsd=tsd(t'*1E4,S3');

Th3=1.1;
Th=2;

ThetaEpoch=thresholdIntervals(PowerTsd,Th,'Direction','Above');
dur=sum(End(ThetaEpoch,'s')-Start(ThetaEpoch,'s'));

ThetaEpoch3=thresholdIntervals(PowerTsd3,Th3,'Direction','Above');
dur3=sum(End(ThetaEpoch3,'s')-Start(ThetaEpoch3,'s'));

ok=0;
testEpoch=intervalSet(rg(1)*1E4,rg(end)*1E4);
a=1;
b=0;
c=0;
The=4;

while ok==0
sum(End(testEpoch,'s')-Start(testEpoch,'s'));
[p,id]=max(Data(Restrict(PowerTsd,testEpoch)));
tps=Range(Restrict(PowerTsd,testEpoch),'s');
Epoch=intervalSet((tps(id)-2.5)*1E4,(tps(id)+2.5)*1E4);
s=Data(Restrict(PowerTsd,Epoch));
s(s>The)=The;
%keyboard
if sum(s)>=length(Data(Restrict(PowerTsd,Epoch)))*The
ok=1;
else
testEpoch=minus(testEpoch,Epoch);   
end

a=a+1;

if a>20&b==0;
    The=3;
    testEpoch=intervalSet(rg(1)*1E4,rg(end)*1E4);
    b=1;
end

if a>40&c==0
    The=2;
    testEpoch=intervalSet(rg(1)*1E4,rg(end)*1E4);
    c=1;
end

if a>60
    [p,id]=max(power);
    Epoch=intervalSet((t(id)-2.5)*1E4,(t(id)+2.5)*1E4);
    ok=1;
    disp('grrr')
end

end

thetaLow=6;

S2m=mean(Data(S2tsd));
S3m=mean(Data(S3tsd));

S2mt=mean(Data(Restrict(S2tsd,ThetaEpoch)));
S3mt=mean(Data(Restrict(S3tsd,ThetaEpoch3)));

S2me=mean(Data(Restrict(S2tsd,Epoch)));
S3me=mean(Data(Restrict(S3tsd,Epoch)));


Fpeak=f(f>thetaLow);

Speak=S2m(f>thetaLow);
[Peak,id]=max(Speak);
FPeak=Fpeak(id);

Speak3=S3m(f>thetaLow);
[Peak3,id3]=max(Speak3);
FPeak3=Fpeak(id3);

Speakt=S2mt(f>thetaLow);
[Peakt,id2t]=max(Speakt);
FPeakt=Fpeak(id2t);

Speak3t=S3mt(f>thetaLow);
[Peak3t,id3t]=max(Speak3t);
FPeak3t=Fpeak(id3t);

Speake=S2me(f>thetaLow);
[Peake,id2e]=max(Speake);
FPeake=Fpeak(id2e);

Speak3e=S3me(f>thetaLow);
[Peak3e,id3e]=max(Speak3e);
FPeak3e=Fpeak(id3e);


try
    num1;
    figure(num1),clf
catch
    figure('Color',[1 1 1]), 
    num1=gcf;
end

subplot(1,4,1:2), hold on
imagesc(t,f,10*log10(S')), axis xy, ylim([params.fpass(1) params.fpass(2)]), xlim([0 rg(end)])
plot(t,power,'k')
xlabel(['Time (s)'])
ylabel(['Frequency (Hz)'])

subplot(1,4,3), hold on
plot(f,mean(Data(Restrict(S2tsd,ThetaEpoch))),'r','linewidth',2)
plot(f,mean(Data(S2tsd)),'k','linewidth',2)
title(['Theta: ',num2str(floor(dur)),' s, Pmax:',num2str(floor(10*Peak)/10),', Fmax:',num2str(floor(FPeak*100)/100),'Hz'])
xlabel(['Frequency (Hz)'])
ylabel(['Power'])

subplot(1,4,4), hold on
plot(f,mean(Data(Restrict(S3tsd,ThetaEpoch3))),'r','linewidth',2)
plot(f,mean(Data(S3tsd)),'k','linewidth',2)
title(['Theta (10*log10): ',num2str(floor(dur3)),'s, Pmax:',num2str(floor(Peak3*10)/10),', Fmax:',num2str(floor(FPeak3*100)/100),'Hz'])
xlabel(['Frequency (Hz)'])
ylabel(['Power (10*log10)'])
ylim([12 34])


try
    num2;
    figure(num2), clf
catch
    figure('Color',[1 1 1]), 
    num2=gcf;
end

subplot(1,4,1:2), hold on
plot(Range(Restrict(Lfp,Epoch),'s'),Data(Restrict(Lfp,Epoch)),'k')
plot(Range(Restrict(Fil,Epoch),'s'),Data(Restrict(Fil,Epoch)),'r','linewidth',2), xlim([Start(Epoch,'s') End(Epoch,'s')]), ylim([-700 700])
subplot(1,4,3), hold on
plot(f,S2me,'k','linewidth',2)
title(['Theta, Pmax:',num2str(floor(10*Peake)/10),', Fmax:',num2str(floor(FPeake*100)/100),'Hz'])
subplot(1,4,4), hold on
plot(f,S3me,'k','linewidth',2)
title(['Theta (10*log10), Pmax:',num2str(floor(10*Peak3e)/10),', Fmax:',num2str(floor(FPeak3e*100)/100),'Hz'])
ylim([12 34])

DataCh{1}=num1;
DataCh{2}=num2;
DataCh{3}=Lfp;
DataCh{4}=Fil;
DataCh{5}=rg;
DataCh{6}=S;
DataCh{7}=f;
DataCh{8}=t;
DataCh{9}=params;
DataCh{10}=movingwin;


