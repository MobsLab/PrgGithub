



load LFPDatadata03MMN

EEG=LFP{10};
ECoG=LFP{11};
LfpS=LFP{15};
LfpD=LFP{13};

% LfpS=LFP{2};	%channel 1
% LfpD=LFP{15};    %channel 2

% deb=a;
% fin=a+5;

deb=411;
fin=450;

Epoch=intervalSet(deb*1E4,fin*1E4);

% movingwin=[(fin-deb)/10,(fin-deb)/100];
movingwin=[0.5,0.05];


params.trialave = 0;
params.err = [1 0.05];

% fp1s=4/(fin-deb);
fp1s=0.2;
fp2s=25;
params.fpass = [fp1s fp2s];

params.Fs = 1/median(diff(Range(Restrict(LfpS,Epoch), 's')));
params.tapers=[2 3];
params.pad=2;

d1=Data(Restrict(LfpS,Restrict(LfpD,Epoch)));
d2=Data(Restrict(LfpD,Epoch));
[Cs,phis,S12s,S1s,S2s,tsl,fsl,confCs,phierrs]=cohgramc(d1-mean(d1),d2-mean(d2),movingwin,params);




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


movingwin=[0.05,0.001];
 
params.trialave = 0;
params.err = [1 0.05];

fp1h=55;
fp2h=220;


params.fpass = [fp1h fp2h];

params.Fs = 1/median(diff(Range(Restrict(LfpS,Epoch), 's')));
params.tapers=[1 2];
params.pad=2;

d1=Data(Restrict(LfpS,Restrict(LfpD,Epoch)));
d2=Data(Restrict(LfpD,Epoch));

d1tsd=(Restrict(LfpS,Restrict(LfpD,Epoch)));
d2tsd=(Restrict(LfpD,Epoch));

d1h=Data(FilterLFP(d1tsd,[40,500]));
d2h=Data(FilterLFP(d2tsd,[40,500]));


[Chg,phihg,S12hg,S1hg,S2hg,thg,fhg,confChg,phierrhg]=cohgramc(d1h-mean(d1h),d2h-mean(d2h),movingwin,params);





%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


movingwin=[0.2,0.01];
 
params.trialave = 0;
params.err = [1 0.05];

fp1l=10;
fp2l=45;


params.fpass = [fp1l fp2l];

params.Fs = 1/median(diff(Range(Restrict(LfpS,Epoch), 's')));
params.tapers=[1 2];
params.pad=2;

d1=Data(Restrict(LfpS,Restrict(LfpD,Epoch)));
d2=Data(Restrict(LfpD,Epoch));

d1tsd=(Restrict(LfpS,Restrict(LfpD,Epoch)));
d2tsd=(Restrict(LfpD,Epoch));

d1l=Data(FilterLFP(d1tsd,[10,500]));
d2l=Data(FilterLFP(d2tsd,[10,500]));


[Clg,philg,S12lg,S1lg,S2lg,tlg,flg,confClg,phierrlg]=cohgramc(d1l-mean(d1l),d2l-mean(d2l),movingwin,params);




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if 1

smo=[0.1 1];


yl1=fp1s;
yl2=fp2s;

try 
    num;
catch
    
figure('color',[1 1 1]),
num=gcf;
end


   
figure(num)
subplot(7,3,1), hold on
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpD,Epoch)),'r')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
ylim([min(min(d1),min(d2)) max(max(d1),max(d2))])

% title(['moovingwin ', num2str(movingwin(1)),' & ', num2str(movingwin(2)),', tapers ', num2str(params.tapers(1)),  ' & ', num2str(params.tapers(2)), ', pad ', num2str(params.pad)])
subplot(7,3,4), imagesc(tsl,fsl,SmoothDec(Cs',smo)), axis xy, ylim([yl1 yl2])
subplot(7,3,7), imagesc(tsl,fsl,SmoothDec(phis',smo)), axis xy, ylim([yl1 yl2])

subplot(7,3,10), imagesc(tsl,fsl,SmoothDec(10*log(S1s)',smo)), axis xy, ylim([yl1 yl2])
subplot(7,3,13), imagesc(tsl,fsl,SmoothDec(10*log(S2s)',smo)), axis xy, ylim([yl1 yl2])

fvecs=fsl'*ones(1,length(tsl));
subplot(7,3,16), imagesc(tsl,fsl,SmoothDec(fvecs.*(S1s)',smo)), axis xy, ylim([yl1 yl2])
subplot(7,3,19), imagesc(tsl,fsl,SmoothDec(fvecs.*(S2s)',smo)), axis xy, ylim([yl1 yl2])



yl1=fp1l+1;
yl2=fp2l;

subplot(7,3,2), hold on
plot(Range(Restrict(LfpS,Epoch),'s'),d1l,'k')
plot(Range(Restrict(LfpS,Epoch),'s'),d2l,'r')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
ylim([min(min(d1l),min(d2l)) max(max(d1l),max(d2l))])

% title(['moovingwin ', num2str(movingwin(1)),' & ', num2str(movingwin(2)),', tapers ', num2str(params.tapers(1)),  ' & ', num2str(params.tapers(2)), ', pad ', num2str(params.pad)])
subplot(7,3,5), imagesc(tlg,flg,SmoothDec(Clg',smo)), axis xy, ylim([yl1 yl2])
subplot(7,3,8), imagesc(tlg,flg,SmoothDec(philg',smo)), axis xy, ylim([yl1 yl2])

subplot(7,3,11), imagesc(tlg,flg,SmoothDec(10*log(S1lg)',smo)), axis xy, ylim([yl1 yl2])
subplot(7,3,14), imagesc(tlg,flg,SmoothDec(10*log(S2lg)',smo)), axis xy, ylim([yl1 yl2])

fveclg=flg'*ones(1,length(tlg));
subplot(7,3,17), imagesc(tlg,flg,SmoothDec(fveclg.*(S1lg)',smo)), axis xy, ylim([yl1 yl2])
subplot(7,3,20), imagesc(tlg,flg,SmoothDec(fveclg.*(S2lg)',smo)), axis xy, ylim([yl1 yl2])



yl1=fp1h;
yl2=fp2h;


subplot(7,3,3), hold on
plot(Range(Restrict(LfpS,Epoch),'s'),d1h,'k')
plot(Range(Restrict(LfpS,Epoch),'s'),d2h,'r')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
ylim([min(min(d1h),min(d2h)) max(max(d1h),max(d2h))])

% title(['moovingwin ', num2str(movingwin(1)),' & ', num2str(movingwin(2)),', tapers ', num2str(params.tapers(1)),  ' & ', num2str(params.tapers(2)), ', pad ', num2str(params.pad)])
subplot(7,3,6), imagesc(thg,fhg,SmoothDec(Chg',smo)), axis xy, ylim([yl1 yl2])
subplot(7,3,9), imagesc(thg,fhg,SmoothDec(phihg',smo)), axis xy, ylim([yl1 yl2])

subplot(7,3,12), imagesc(thg,fhg,SmoothDec(10*log(S1hg)',smo)), axis xy, ylim([yl1 yl2])
subplot(7,3,15), imagesc(thg,fhg,SmoothDec(10*log(S2hg)',smo)), axis xy, ylim([yl1 yl2])

fvechg=fhg'*ones(1,length(thg));
subplot(7,3,18), imagesc(thg,fhg,SmoothDec(fvechg.*(S1hg)',smo)), axis xy, ylim([yl1 yl2])
subplot(7,3,21), imagesc(thg,fhg,SmoothDec(fvechg.*(S2hg)',smo)), axis xy, ylim([yl1 yl2])


end



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



fvechg=fhg'*ones(1,length(thg));

fveclg=flg'*ones(1,length(tlg));



S1hgT=fvechg.*(S1hg)';
S2hgT=fvechg.*(S2hg)';
S1lgT=fveclg.*(S1lg)';
S2lgT=fveclg.*(S2lg)';

try 
    num2;
catch
    
figure('color',[1 1 1]),
num2=gcf;
end


figure(num2), clf

subplot(2,1,1), hold on

plot(tsl,rescale(mean(S1s(:,find(fsl>1&fsl<5))'),0,1),'k','linewidth',2)
plot(tsl,rescale(mean(S1s(:,find(fsl>5&fsl<15))'),0,1),'r','linewidth',2)

plot(tlg,rescale(mean(S1lgT(find(flg>10&flg<25),:)),0,1),'color',[0 0 0.7])
plot(tlg,rescale(mean(S1lgT(find(flg>30&flg<45),:)),0,1),'color',[0 0 1])

plot(thg,rescale(mean(S1hgT(find(fhg>75&fhg<120),:)),0,1),'color',[0 0.7 0])
plot(thg,rescale(mean(S1hgT(find(fhg>140&fhg<180),:)),0,1),'color',[0 1 0])



subplot(2,1,2), hold on

plot(tsl,rescale(mean(S2s(:,find(fsl>1&fsl<5))'),0,1),'k','linewidth',2)
plot(tsl,rescale(mean(S2s(:,find(fsl>5&fsl<15))'),0,1),'r','linewidth',2)

plot(tlg,rescale(mean(S2lgT(find(flg>10&flg<25),:)),0,1),'color',[0 0 0.7])
plot(tlg,rescale(mean(S2lgT(find(flg>30&flg<45),:)),0,1),'color',[0 0 1])

plot(thg,rescale(mean(S2hgT(find(fhg>75&fhg<120),:)),0,1),'color',[0 0.7 0])
plot(thg,rescale(mean(S2hgT(find(fhg>140&fhg<180),:)),0,1),'color',[0 1 0])






PowDelta1=mean(S1s(:,find(fsl>0.1&fsl<3))');
PowSpindles1=mean(S1s(:,find(fsl>9&fsl<11))');

PowLowGammaA1=mean(S1lgT(find(flg>10&flg<25),:));
PowLowGammaB1=mean(S1lgT(find(flg>30&flg<45),:));

PowHighGammaA1=mean(S1hgT(find(fhg>75&fhg<120),:));
PowHighGammaB1=mean(S1hgT(find(fhg>140&fhg<180),:));



PowDelta2=(mean(S2s(:,find(fsl>0.1&fsl<3))'));
PowSpindles2=(mean(S2s(:,find(fsl>9&fsl<11))'));

PowLowGammaA2=(mean(S2lgT(find(flg>10&flg<25),:)));
PowLowGammaB2=(mean(S2lgT(find(flg>30&flg<45),:)));

PowHighGammaA2=(mean(S2hgT(find(fhg>75&fhg<120),:)));
PowHighGammaB2=(mean(S2hgT(find(fhg>140&fhg<180),:)));


save PowerLFPDatadata03MMN PowDelta1 PowDelta2 PowSpindles1 PowSpindles2 PowLowGammaA1 PowLowGammaA2 PowLowGammaB1 PowLowGammaB2 PowHighGammaA1 PowHighGammaA2 PowHighGammaB1 PowHighGammaB2 tsl tlg thg fsl flg fhg


le=length(PowLowGammaA1);

PowDelta1s=resample(PowDelta1,le,(length(PowDelta1)));
PowSpindles1s=resample(PowSpindles1,le,floor(length(PowDelta1)));
% PowLowGammaA1s=resample(PowLowGammaA1,le,floor(length(PowDelta1)));
% PowLowGammaB1s=resample(PowLowGammaB1,le,floor(length(PowDelta1)));
PowHighGammaA1s=resample(PowHighGammaA1,le,floor(length(PowDelta1)));
PowHighGammaB1s=resample(PowHighGammaB1,le,floor(length(PowDelta1)));

PowDelta2s=resample(PowDelta2,le,(length(PowDelta1)));
PowSpindles2s=resample(PowSpindles2,le,floor(length(PowDelta1)));
% PowLowGammaA2s=resample(PowLowGammaA2,le,floor(length(PowDelta1)));
% PowLowGammaB2s=resample(PowLowGammaB2,le,floor(length(PowDelta1)));
PowHighGammaA2s=resample(PowHighGammaA2,le,floor(length(PowDelta1)));
PowHighGammaB2s=resample(PowHighGammaB2,le,floor(length(PowDelta1)));





%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

freq=1/median(diff(tlg));

if 0



nbin=400;

[C1,B1]=crosscorr(PowDelta1s,PowDelta2s,nbin); 
[C2,B2]=crosscorr(PowDelta1s,PowSpindles1s,nbin);
[C3,B3]=crosscorr(PowDelta1s,PowLowGammaA1,nbin);
[C4,B4]=crosscorr(PowDelta1s,PowLowGammaB1,nbin);
[C5,B5]=crosscorr(PowDelta1s,PowHighGammaA1,nbin);
[C6,B6]=crosscorr(PowDelta1s,PowHighGammaB1s,nbin);



figure('color',[1 1 1]), 

subplot(3,2,1), hold on
plot(B1/freq,C1,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('Delta2 vs Delta1')

subplot(3,2,2), hold on
plot(B2/freq,C2,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('Spindles1 vs Delta1')

subplot(3,2,3), hold on
plot(B3/freq,C3,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('10-25 Hz vs Delta1')

subplot(3,2,4), hold on
plot(B4/freq,C4,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('30-45 Hz vs Delta1')

subplot(3,2,5), hold on
plot(B5/freq,C5,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('75-120 Hz vs Delta1')

subplot(3,2,6), hold on
plot(B6/freq,C6,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('140-180 Hz vs Delta1')

[C1,B1]=crosscorr(PowSpindles1s,PowDelta2s,nbin); 
[C2,B2]=crosscorr(PowSpindles1s,PowSpindles2s,nbin);
[C3,B3]=crosscorr(PowSpindles1s,PowLowGammaA1,nbin);
[C4,B4]=crosscorr(PowSpindles1s,PowLowGammaB1,nbin);
[C5,B5]=crosscorr(PowSpindles1s,PowHighGammaA1,nbin);
[C6,B6]=crosscorr(PowSpindles1s,PowHighGammaB1s,nbin);

figure('color',[1 1 1]), 

subplot(3,2,1), hold on
plot(B1/freq,C1,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('Delta1 vs Spindles1')

subplot(3,2,2), hold on
plot(B2/freq,C2,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('Spindles2 vs Spindles1')

subplot(3,2,3), hold on
plot(B3/freq,C3,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('10-25 Hz vs Spindles1')

subplot(3,2,4), hold on
plot(B4/freq,C4,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('30-45 Hz vs Spindles1')

subplot(3,2,5), hold on
plot(B5/freq,C5,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('75-120 Hz vs Spindles1')

subplot(3,2,6), hold on
plot(B6/freq,C6,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('140-180 Hz vs Spindles1')



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



[C1,B1]=crosscorr(PowDelta2s,PowDelta2s,nbin); 
[C2,B2]=crosscorr(PowDelta2s,PowSpindles1s,nbin);
[C3,B3]=crosscorr(PowDelta2s,PowLowGammaA1,nbin);
[C4,B4]=crosscorr(PowDelta2s,PowLowGammaB1,nbin);
[C5,B5]=crosscorr(PowDelta2s,PowHighGammaA1,nbin);
[C6,B6]=crosscorr(PowDelta2s,PowHighGammaB1s,nbin);



figure('color',[1 1 1]), 

subplot(3,2,1), hold on
plot(B1/freq,C1,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('Delta2 vs Delta2')

subplot(3,2,2), hold on
plot(B2/freq,C2,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('Spindles1 vs Delta2')

subplot(3,2,3), hold on
plot(B3/freq,C3,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('10-25 Hz vs Delta2')

subplot(3,2,4), hold on
plot(B4/freq,C4,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('30-45 Hz vs Delta2')

subplot(3,2,5), hold on
plot(B5/freq,C5,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('75-120 Hz vs Delta2')

subplot(3,2,6), hold on
plot(B6/freq,C6,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('140-180 Hz vs Delta2')

[C1,B1]=crosscorr(PowSpindles2s,PowDelta2s,nbin); 
[C2,B2]=crosscorr(PowSpindles2s,PowSpindles2s,nbin);
[C3,B3]=crosscorr(PowSpindles2s,PowLowGammaA1,nbin);
[C4,B4]=crosscorr(PowSpindles2s,PowLowGammaB1,nbin);
[C5,B5]=crosscorr(PowSpindles2s,PowHighGammaA1s,nbin);
[C6,B6]=crosscorr(PowSpindles2s,PowHighGammaB1s,nbin);

figure('color',[1 1 1]), 

subplot(3,2,1), hold on
plot(B1/freq,C1,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('Delta1 vs Spindles2')

subplot(3,2,2), hold on
plot(B2/freq,C2,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('Spindles2 vs Spindles2')

subplot(3,2,3), hold on
plot(B3/freq,C3,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('10-25 Hz vs Spindles2')

subplot(3,2,4), hold on
plot(B4/freq,C4,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('30-45 Hz vs Spindles2')

subplot(3,2,5), hold on
plot(B5/freq,C5,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('75-120 Hz vs Spindles2')

subplot(3,2,6), hold on
plot(B6/freq,C6,'k'), yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([B1(1) B1(end)]/freq)
title('140-180 Hz vs Spindles2')


end



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

thSpindles=(max(PowSpindles1s)-min(PowSpindles1s))*2/3+min(PowSpindles1s);

% [hde,bde]=hist(PowSpindles1s,100);
% [c,s]=kmeans(hde,2);
% 
% thSpindles=max(bde(s==1));


Pspi=tsd((deb+[1:length(PowSpindles1s)]'/freq)*1E4,PowSpindles1s');
spi=thresholdIntervals(Pspi,thSpindles);
%spi=mergeCloseIntervals(spi,0.5);
spi=dropShortIntervals(spi,0.2);


% figure('color',[1 1 1]), hold on
% plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
% plot(Range(Restrict(LfpS,Epoch),'s'),500+Data(Restrict(LfpD,Epoch)),'r')
% plot(Range(Pspi,'s'),Data(Pspi)*2E3,'g','linewidth',2)
% plot(Range(Restrict(LfpS,spi),'s'),Data(Restrict(LfpS,spi)),'b.','linewidth',1)
% plot(Range(Restrict(LfpS,spi),'s'),500+Data(Restrict(LfpD,spi)),'m.','linewidth',1)
% 


FilS=FilterLFP(LfpS,[7,15]);
  
  tPeaks=[];
for kl=1:length(Start(spi))
    
    
    eeg=Data(Restrict(FilS,subset(spi,kl)));
    teeg=Range(Restrict(FilS,subset(spi,kl)));
    
  de = diff(eeg');
  de1 = [de 0];
  de2 = [0 de];
  
  
  %finding peaks
  upPeaksIdx = find(de1 < 0 & de2 > 0);
  downPeaksIdx = find(de1 > 0 & de2 < 0);
  
%   PeaksIdx = [upPeaksIdx downPeaksIdx];
  PeaksIdx = [downPeaksIdx ];
  
  PeaksIdx = sort(PeaksIdx);
  
  tPeakstemp = teeg(PeaksIdx);
  
    tPeaks= [tPeaks; tPeakstemp];
    
end

tPeaks=sort(tPeaks); 






tbins=4;
% nbbins=6000;
nbbins=400;

[m1,s1,tps1]=mETAverage(tPeaks/10, (deb+[1:length(PowDelta1s)]'/freq)*1E3,PowDelta1s',tbins,nbbins);
[m2,s2,tps2]=mETAverage(tPeaks/10, (deb+[1:length(PowDelta2s)]'/freq)*1E3,PowDelta2s',tbins,nbbins);
[m3,s3,tps3]=mETAverage(tPeaks/10, (deb+[1:length(PowLowGammaA1)]'/freq)*1E3,PowLowGammaA1',tbins,nbbins);
[m4,s4,tps4]=mETAverage(tPeaks/10, (deb+[1:length(PowLowGammaA2)]'/freq)*1E3,PowLowGammaA2',tbins,nbbins);
[m5,s5,tps5]=mETAverage(tPeaks/10, (deb+[1:length(PowLowGammaB1)]'/freq)*1E3,PowLowGammaB1',tbins,nbbins);
[m6,s6,tps6]=mETAverage(tPeaks/10, (deb+[1:length(PowLowGammaB2)]'/freq)*1E3,PowLowGammaB2',tbins,nbbins);
[m7,s7,tps7]=mETAverage(tPeaks/10, (deb+[1:length(PowHighGammaA1s)]'/freq)*1E3,PowHighGammaA1s',tbins,nbbins);
[m8,s8,tps8]=mETAverage(tPeaks/10, (deb+[1:length(PowHighGammaA2s)]'/freq)*1E3,PowHighGammaA2s',tbins,nbbins);
[m9,s9,tps9]=mETAverage(tPeaks/10, (deb+[1:length(PowHighGammaB1s)]'/freq)*1E3,PowHighGammaB1s',tbins,nbbins);
[m10,s10,tps10]=mETAverage(tPeaks/10, (deb+[1:length(PowHighGammaB2s)]'/freq)*1E3,PowHighGammaB2s',tbins,nbbins);
[m11,s11,tps11]=mETAverage(tPeaks/10, (deb+[1:length(PowSpindles1s)]'/freq)*1E3,PowSpindles1s',tbins,nbbins);
[m12,s12,tps12]=mETAverage(tPeaks/10, (deb+[1:length(PowSpindles2s)]'/freq)*1E3,PowSpindles2s',tbins,nbbins);

% 
% tps1=tps1/10;
% tps2=tps2/10;
% tps3=tps3/10;
% tps4=tps4/10;
% tps5=tps5/10;
% tps6=tps6/10;
% tps7=tps7/10;
% tps8=tps8/10;
% tps9=tps9/10;
% tps10=tps10/10;
% tps11=tps11/10;
% tps12=tps12/10;





figure('color',[1 1 1]), 
subplot(3,2,1),hold on
plot(tps1,rescale(m1,0,1),'k')
plot(tps2,rescale(m2,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('Delta vs Spindles Peaks')

subplot(3,2,2),hold on
plot(tps1,rescale(m3,0,1),'k')
plot(tps2,rescale(m4,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('Low Gamma A vs Spindles Peaks')


subplot(3,2,3),hold on
plot(tps1,rescale(m5,0,1),'k')
plot(tps2,rescale(m6,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('Low Gamma B vs Spindles Peaks')


subplot(3,2,4),hold on
plot(tps7,rescale(m7,0,1),'k')
plot(tps8,rescale(m8,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('High Gamma A vs Spindles Peaks')

subplot(3,2,5),hold on
plot(tps9,rescale(m9,0,1),'k')
plot(tps10,rescale(m10,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('High Gamma B vs Spindles Peaks')


subplot(3,2,6),hold on
plot(tps11,rescale(m11,0,1),'k')
plot(tps12,rescale(m12,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('Spindles vs Spindles Peaks')




%--------------------------------------------------------------------------

thDelta=(max(PowDelta1s)-min(PowDelta1s))*2/3+min(PowDelta1s);

% [hde,bde]=hist(PowDelta1s,100);
% [c,s]=kmeans(hde,2);
% 
% thDelta=max(bde(s==1));


Pdelta=tsd((deb+[1:length(PowDelta1s)]'/freq)*1E4,PowDelta1s');
delta=thresholdIntervals(Pdelta,thDelta);
%spi=mergeCloseIntervals(spi,0.5);
delta=dropShortIntervals(delta,0.05);


% figure('color',[1 1 1]), hold on
% plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
% plot(Range(Restrict(LfpS,Epoch),'s'),500+Data(Restrict(LfpD,Epoch)),'r')
% plot(Range(Pspi,'s'),Data(Pspi)*2E3,'g','linewidth',2)
% plot(Range(Restrict(LfpS,spi),'s'),Data(Restrict(LfpS,spi)),'b.','linewidth',1)
% plot(Range(Restrict(LfpS,spi),'s'),500+Data(Restrict(LfpD,spi)),'m.','linewidth',1)
% 


FilS=FilterLFP(LfpD,[0.1,4]);
  
  tDelta=[];
for kl=1:length(Start(delta))
    
    
    eeg=Data(Restrict(FilS,subset(delta,kl)));
    teeg=Range(Restrict(FilS,subset(delta,kl)));
    
%   de = diff(eeg');
%   de1 = [de 0];
%   de2 = [0 de];
%   
%   
%   %finding peaks
%   upPeaksIdx = find(de1 < 0 & de2 > 0);
%   downPeaksIdx = find(de1 > 0 & de2 < 0);
%   
% %   PeaksIdx = [upPeaksIdx downPeaksIdx];
%     PeaksIdx = [ downPeaksIdx];
%   PeaksIdx = sort(PeaksIdx);
%   
%   tDeltatemp = teeg(PeaksIdx);
  
    tDeltatemp=(teeg(end)-teeg(1))/2+teeg(1);

    tDelta= [tDelta; tDeltatemp];
    
end

tDelta=sort(tDelta); 






tbins=4;
nbbins=400;
% nbbins=100;

[m1,s1,tps1]=mETAverage(tDelta/10, (deb+[1:length(PowDelta1s)]'/freq)*1E3,PowDelta1s',tbins,nbbins);
[m2,s2,tps2]=mETAverage(tDelta/10, (deb+[1:length(PowDelta2s)]'/freq)*1E3,PowDelta2s',tbins,nbbins);
[m3,s3,tps3]=mETAverage(tDelta/10, (deb+[1:length(PowLowGammaA1)]'/freq)*1E3,PowLowGammaA1',tbins,nbbins);
[m4,s4,tps4]=mETAverage(tDelta/10, (deb+[1:length(PowLowGammaA2)]'/freq)*1E3,PowLowGammaA2',tbins,nbbins);
[m5,s5,tps5]=mETAverage(tDelta/10, (deb+[1:length(PowLowGammaB1)]'/freq)*1E3,PowLowGammaB1',tbins,nbbins);
[m6,s6,tps6]=mETAverage(tDelta/10, (deb+[1:length(PowLowGammaB2)]'/freq)*1E3,PowLowGammaB2',tbins,nbbins);
[m7,s7,tps7]=mETAverage(tDelta/10, (deb+[1:length(PowHighGammaA1s)]'/freq)*1E3,PowHighGammaA1s',tbins,nbbins);
[m8,s8,tps8]=mETAverage(tDelta/10, (deb+[1:length(PowHighGammaA2s)]'/freq)*1E3,PowHighGammaA2s',tbins,nbbins);
[m9,s9,tps9]=mETAverage(tDelta/10, (deb+[1:length(PowHighGammaB1s)]'/freq)*1E3,PowHighGammaB1s',tbins,nbbins);
[m10,s10,tps10]=mETAverage(tDelta/10, (deb+[1:length(PowHighGammaB2s)]'/freq)*1E3,PowHighGammaB2s',tbins,nbbins);
[m11,s11,tps11]=mETAverage(tDelta/10, (deb+[1:length(PowSpindles1s)]'/freq)*1E3,PowSpindles1s',tbins,nbbins);
[m12,s12,tps12]=mETAverage(tDelta/10, (deb+[1:length(PowSpindles2s)]'/freq)*1E3,PowSpindles2s',tbins,nbbins);

% 
% tps1=tps1/10;
% tps2=tps2/10;
% tps3=tps3/10;
% tps4=tps4/10;
% tps5=tps5/10;
% tps6=tps6/10;
% tps7=tps7/10;
% tps8=tps8/10;
% tps9=tps9/10;
% tps10=tps10/10;
% tps11=tps11/10;
% tps12=tps12/10;





figure('color',[1 1 1]), 
subplot(3,2,1),hold on
plot(tps1,rescale(m1,0,1),'k')
plot(tps2,rescale(m2,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('Delta vs Delta waves')

subplot(3,2,2),hold on
plot(tps1,rescale(m3,0,1),'k')
plot(tps2,rescale(m4,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('Low Gamma A vs Spindles Peaks')


subplot(3,2,3),hold on
plot(tps1,rescale(m5,0,1),'k')
plot(tps2,rescale(m6,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('Low Gamma B vs Delta waves')


subplot(3,2,4),hold on
plot(tps7,rescale(m7,0,1),'k')
plot(tps8,rescale(m8,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('High Gamma A vs Delta waves')

subplot(3,2,5),hold on
plot(tps9,rescale(m9,0,1),'k')
plot(tps10,rescale(m10,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('High Gamma B vs Delta waves')


subplot(3,2,6),hold on
plot(tps11,rescale(m11,0,1),'k')
plot(tps12,rescale(m12,0,1),'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
xlim([tps1(1) tps1(end)])
title('Spindles vs Delta waves')





[ma,sa,tpsa]=mETAverage(tPeaks/10, Range(LfpS)/10,Data(LfpS),tbins,nbbins);
[mb,sb,tpsb]=mETAverage(tPeaks/10, Range(LfpS)/10,Data(LfpD),tbins,nbbins);

[mc,sc,tpsc]=mETAverage(tDelta/10, Range(LfpS)/10,Data(LfpS),tbins,nbbins);
[md,sd,tpsd]=mETAverage(tDelta/10, Range(LfpS)/10,Data(LfpD),tbins,nbbins);





figure('color',[1 1 1])
subplot(2,1,1), hold on
plot(tpsa,ma,'k')
plot(tpsb,mb,'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
% xlim([tps1(1) tps1(end)])
xlim([-500 500])
title('LFP vs Spindles peaks')

subplot(2,1,2), hold on
plot(tpsc,mc,'k')
plot(tpsd,md,'b')
yl=ylim;
line([0 0],[yl(1) yl(2)],'color','r')
% xlim([tps1(1) tps1(end)])
xlim([-500 500])
title('LFP vs Delta waves')



figure('color',[1 1 1]), hold on
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpD,Epoch)),'r')
plot(tPeaks/1E4,ones(length(tPeaks),1),'ko','markerfacecolor','g')
plot(tDelta/1E4,ones(length(tDelta),1),'ko','markerfacecolor','y')


% 
% figure('color',[1 1 1]),  imagesc(tsl,fsl,SmoothDec(10*log(S1s)',smo)), axis xy
% hold on, plot(Range(Restrict(LfpS,Epoch),'s')-deb,Data(Restrict(LfpS,Epoch))/1000+3,'k')
% plot(Range(Restrict(LfpS,Epoch),'s')-deb,Data(Restrict(LfpD,Epoch))/1000+3,'b')


figure('color',[1 1 1]),  imagesc(tsl,fsl,SmoothDec(10*log(S1s)',smo)), axis xy
hold on, plot(Range(Restrict(LfpS,Epoch),'s')-deb,Data(Restrict(LfpS,Epoch))/1000+3,'k')
plot(Range(Restrict(LfpS,Epoch),'s')-deb,Data(Restrict(LfpD,Epoch))/1000+3,'b')
plot(Range(Restrict(LfpS,Epoch),'s')-deb,(Data(Restrict(LfpD,Epoch))-Data(Restrict(LfpS,Epoch)))/1000+3,'g')
plot(tDelta/1E4-deb,3.5*ones(length(tDelta),1),'ko','markerfacecolor','y')
plot(tPeaks/1E4-deb,3.5*ones(length(tPeaks),1),'ko','markerfacecolor','g')
caxis([40 120])
ylim([0 15])
a=0;
a=a+5; xlim([a a+5])

% 
% x1=a;
% x2=a+1;
% subplot(7,1,1), xlim([x1 x2])
% for i=2:7
% subplot(7,1,i), xlim([x1 x2]-deb)
% end
% 
% 
% figure('color',[1 1 1]),hold on
% plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
% plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpD,Epoch)),'r')
% 
% plot(Range(Restrict(ECoG,Epoch),'s'),Data(Restrict(ECoG,Epoch)),'b')
% 

