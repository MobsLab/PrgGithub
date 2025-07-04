function [val,spi,SWA]=EvalEpochs
load('StateEpoch.mat')
clear val
load('SpindlesRipples.mat')
% load('SleepWakeEpochs.mat')
load('listLFP.mat')
% NoiseEpoch=Or(NoiseEpoch,IntervalSet(0,500*1e4));
% wakeper=wakeper-NoiseEpoch-GndNoiseEpoch;
% sleepper=sleepper-NoiseEpoch-GndNoiseEpoch;
load('/media/DataMOBs/ProjetLPS/Mouse051/20130220/BULB-Mouse-51-20022013/SpectrumDataL/Spectrum22.mat')
TotalEpoch=intervalSet(t(1)*1e4,1e4*t(end));
Epoch=TotalEpoch-GndNoiseEpoch-NoiseEpoch;
num=1;
channels=[17,18,29,30,24,25,26,23,27,28,20,21,22];
ext=30;
pasTheta=100;
for ch=channels
    ch
load(strcat('LFPData/LFP',num2str(ch),'.mat'))
LFP=ResampleTSD(LFP,250);
try
load(strcat('SpectrumDataL/Spectrum',num2str(ch),'.mat'))
catch
    load(strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/LFP',num2str(ch),'.mat'))
% catch
%     load('SpectrumDataL/Spectrum22.mat')
% [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
% save(strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/LFP',num2str(ch),'.mat'),'Sp','t','f','params','movingwin')

end

sptsd=tsd(t*10000,Sp);
Sptemp=Data(sptsd);
lowvals=tsd(t*10000,mean(Sptemp(:,1:10)')');
lowvals=Restrict(lowvals,Epoch);
m=percentile(Data(lowvals),85);
NewEpoch=thresholdIntervals(lowvals,m,'Direction','Below');
lowvals2=tsd(t*10000,mean(Sptemp(:,250:300)')');
lowvals2=Restrict(lowvals2,Epoch);
m=percentile(Data(lowvals2),2);
NewEpoch2=thresholdIntervals(lowvals2,m,'Direction','Above');
m=percentile(abs(Data(Restrict(LFP,Epoch))),99.99);
NewEpoch3=thresholdIntervals(tsd(Range(LFP),abs(Data(LFP))),m,'Direction','Below');
NewEpoch=And(NewEpoch,NewEpoch2);
NewEpoch=And(NewEpoch,NewEpoch3);
load('SleepWakeEpochs.mat')
wakeper=And(wakeper,NewEpoch);
sleepper=And(sleepper,NewEpoch);


a=Start(sleepper);
b=Stop(sleepper);
num1=1;
num2=1;
clear sleep sleep2 aftsleep befsleep
for k=2:length(Start(sleepper))
    if a(k)-ext*1e4>0 & (b(k-1)-a(k)+ext*1e4)<0
        befsleep(num1)=a(k)-ext*1e4;
        sleep(num1)=a(k);
        num1=num1+1;
    elseif a(k)-ext*1e4>0 & (b(k-1)-a(k)+ext*1e4)>0
        befsleep(num1)=b(k-1);
        sleep(num1)=a(k);
        num1=num1+1;
    end
    
    if a(k)+ext*1e4>0 & (b(k)-a(k)-ext*1e4)>0
        aftsleep(num2)=a(k)+ext*1e4;
        sleep2(num2)=a(k);
        num2=num2+1;
    elseif a(k)-ext*1e4>0 & (b(k)-a(k)-ext*1e4)<0
        aftsleep(num2)=b(k);
        sleep2(num2)=a(k);
        num2=num2+1;
    end
    
end
Aftsleep=intervalSet(sleep2,aftsleep);
Aftsleep=And(Aftsleep,NewEpoch);
Befsleep=intervalSet(befsleep,sleep);
Befsleep=And(Befsleep,NewEpoch);
        
a=Start(wakeper);
b=Stop(wakeper);
num1=1;
num2=1;
clear wake wake2 befwake aftwake
for k=2:length(Start(wakeper))
    if a(k)-ext*1e4>0 & (b(k-1)-a(k)+ext*1e4)<0
        befwake(num1)=a(k)-ext*1e4;
        wake(num1)=a(k);
        num1=num1+1;
    elseif a(k)-ext*1e4>0 & (b(k-1)-a(k)+ext*1e4)>0
        befwake(num1)=b(k-1);
        wake(num1)=a(k);
        num1=num1+1;
    end
    
    if a(k)+ext*1e4>0 & (b(k)-a(k)-ext*1e4)>0
        aftwake(num2)=a(k)+ext*1e4;
        wake2(num2)=a(k);
        num2=num2+1;
    elseif a(k)-ext*1e4>0 & (b(k)-a(k)-ext*1e4)<0
        aftwake(num2)=b(k);
        wake2(num2)=a(k);
        num2=num2+1;
    end
    
end
Aftwake=intervalSet(wake2,aftwake);
Aftwake=And(Aftwake,NewEpoch);
Befwake=intervalSet(befwake,wake);
Befwake=And(Befwake,NewEpoch);
% 
% h=figure;
% subplot(1,3,1)
% plot(f,f.*(mean(Data(Restrict(sptsd,sleepper)))),'r','linewidth',2)
% hold on
% plot(f,f.*(mean(Data(Restrict(sptsd,wakeper)))),'b','linewidth',2)
% title(num2str(ch))
% legend('sleep','wake')
% subplot(1,3,2)
% plot(f,f.*(mean(Data(Restrict(sptsd,Befsleep)))),'k','linewidth',2)
% hold on
% plot(f,f.*(mean(Data(Restrict(sptsd,Aftsleep)))),'g','linewidth',2)
% legend('Bef Sleep','Aft Sleep')
% subplot(1,3,3)
% plot(f,f.*(mean(Data(Restrict(sptsd,Befwake)))),'g','linewidth',2)
% hold on
% plot(f,f.*(mean(Data(Restrict(sptsd,Aftwake)))),'k','linewidth',2)
% legend('Bef Wake','Aft Wake')
% 
% saveas(h,strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/spectrsleep_ch',num2str(ch),'.png'))
% saveas(h,strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/spectrsleep_ch',num2str(ch),'.fig'))
% close all
% 
% h=figure
% subplot(2,3,1)
% imagesc(f,Range(Restrict(sptsd,wakeper)),log(Data(Restrict(sptsd,wakeper))))
% title('wake')
% subplot(2,3,4)
% imagesc(f,Range(Restrict(sptsd,sleepper)),log(Data(Restrict(sptsd,sleepper))))
% title('sleep')
% subplot(2,3,2)
% imagesc(f,Range(Restrict(sptsd,Befsleep)),log(Data(Restrict(sptsd,Befsleep))))
% title('Bef sleep')
% subplot(2,3,5)
% imagesc(f,Range(Restrict(sptsd,Aftsleep)),log(Data(Restrict(sptsd,Aftsleep))))
% title('Aft sleep')
% subplot(2,3,3)
% imagesc(f,Range(Restrict(sptsd,Befwake)),log(Data(Restrict(sptsd,Befwake))))
% title('Bef wake')
% subplot(2,3,6)
% imagesc(f,Range(Restrict(sptsd,Aftwake)),log(Data(Restrict(sptsd,Aftwake))))
% title('Aft wake')
% saveas(h,strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/spectrnonavsleep_ch',num2str(ch),'.png'))
% saveas(h,strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/spectrnonavsleep_ch',num2str(ch),'.fig'))
% close all
% 
% h=figure;
% subplot(1,3,1)
% St=[];
% clear Freq
% for i=1:length(Start(sleepper))
% try
% Epoch1=subset(sleepper,i);
% [S,f]=mtspectrumc(Data(Restrict(LFP,Epoch1)),params);
% try
% Freq;
% catch
% Freq=f;
% end
% Stsd=tsd(f,S);
% S2=Restrict(Stsd,ts(Freq(1:10:end)));
% St=[St;Data(S2)'];
% end
% end
% storder=sort(St(:));
% [row,col]=find(St>storder(size(storder,1)-ceil(size(storder,1)/200)));
% St(row,col)=NaN;
% plot(Freq(1:10:end),Freq(1:10:end).*(nanmean(St)),'r','linewidth',2)
% 
% St=[];
% clear Freq
% for i=1:length(Start(wakeper))
% try
% Epoch1=subset(wakeper,i);
% [S,f]=mtspectrumc(Data(Restrict(LFP,Epoch1)),params);
% try
% Freq;
% catch
% Freq=f;
% end
% Stsd=tsd(f,S);
% S2=Restrict(Stsd,ts(Freq(1:10:end)));
% St=[St;Data(S2)'];
% end
% end
% storder=sort(St(:));
% [row,col]=find(St>storder(size(storder,1)-ceil(size(storder,1)/200)));
% St(row,col)=NaN;
% hold on, plot(Freq(1:10:end),Freq(1:10:end).*(nanmean(St)),'b','linewidth',2)
% title(num2str(ch))
% legend('sleep','wake')
% 
% subplot(1,3,2)
% St=[];
% clear Freq
% for i=1:length(Start(Befsleep))
% try
% Epoch1=subset(Befsleep,i);
% [S,f]=mtspectrumc(Data(Restrict(LFP,Epoch1)),params);
% try
% Freq;
% catch
% Freq=f;
% end
% Stsd=tsd(f,S);
% S2=Restrict(Stsd,ts(Freq(1:10:end)));
% St=[St;Data(S2)'];
% end
% end
% storder=sort(St(:));
% [row,col]=find(St>storder(size(storder,1)-ceil(size(storder,1)/200)));
% St(row,col)=NaN;
% plot(Freq(1:10:end),Freq(1:10:end).*(nanmean(St)),'k','linewidth',2)
% 
% St=[];
% clear Freq
% for i=1:length(Start(Aftsleep))
% try
% Epoch1=subset(Aftsleep,i);
% [S,f]=mtspectrumc(Data(Restrict(LFP,Epoch1)),params);
% try
% Freq;
% catch
% Freq=f;
% end
% Stsd=tsd(f,S);
% S2=Restrict(Stsd,ts(Freq(1:10:end)));
% St=[St;Data(S2)'];
% end
% end
% storder=sort(St(:));
% [row,col]=find(St>storder(size(storder,1)-ceil(size(storder,1)/200)));
% St(row,col)=NaN;
% hold on, plot(Freq(1:10:end),Freq(1:10:end).*(nanmean(St)),'g','linewidth',2)
% legend('Bef Sleep','Aft Sleep')
% 
% subplot(1,3,3)
% St=[];
% clear Freq
% for i=1:length(Start(Befwake))
% try
% Epoch1=subset(Befwake,i);
% [S,f]=mtspectrumc(Data(Restrict(LFP,Epoch1)),params);
% try
% Freq;
% catch
% Freq=f;
% end
% Stsd=tsd(f,S);
% S2=Restrict(Stsd,ts(Freq(1:10:end)));
% St=[St;Data(S2)'];
% end
% end
% storder=sort(St(:));
% [row,col]=find(St>storder(size(storder,1)-ceil(size(storder,1)/200)));
% St(row,col)=NaN;
% plot(Freq(1:10:end),Freq(1:10:end).*(nanmean(St)),'g','linewidth',2)
% 
% St=[];
% clear Freq
% for i=1:length(Start(Aftwake))
% try
% Epoch1=subset(Aftwake,i);
% [S,f]=mtspectrumc(Data(Restrict(LFP,Epoch1)),params);
% try
% Freq;
% catch
% Freq=f;
% end
% Stsd=tsd(f,S);
% S2=Restrict(Stsd,ts(Freq(1:10:end)));
% St=[St;Data(S2)'];
% end
% end
% storder=sort(St(:));
% [row,col]=find(St>storder(size(storder,1)-ceil(size(storder,1)/200)));
% St(row,col)=NaN;
% hold on, plot(Freq(1:10:end),Freq(1:10:end).*(nanmean(St)),'k','linewidth',2)
% legend('Bef Wake','Aft Wake')
% 
% saveas(h,strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/spectrsleep2_ch',num2str(ch),'.png'))
% saveas(h,strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/spectrsleep2_ch',num2str(ch),'.fig'))
% close all


FilTheta=FilterLFP(LFP,[5 10],1024);
FilDelta=FilterLFP(LFP,[3 6],1024);
HilTheta=hilbert(Data(FilTheta));
HilDelta=hilbert(Data(FilDelta));
H=abs(HilDelta);
HT=abs(HilTheta);
H(H<100)=100;
ThetaRatio=abs(HilTheta)./H;
rgThetaRatio=Range(FilTheta,'s');
rgDelta=Range(FilDelta,'s');
rgTheta=Range(FilTheta,'s');

ThetaRatio=SmoothDec(ThetaRatio(1:pasTheta:end),50);
Delta=SmoothDec(H(1:pasTheta:end),50);
Theta=SmoothDec(HT(1:pasTheta:end),50);
rgThetaRatio=rgThetaRatio(1:pasTheta:end);
rgDelta=rgDelta(1:pasTheta:end);
rgTheta=rgTheta(1:pasTheta:end);

ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);
DeltaTSD=tsd(rgDelta*1E4,Delta);
ThetaTSD=tsd(rgTheta*1E4,Theta);
Sptemp=Data(sptsd);
correctedav=tsd(t*10000,mean(Sptemp(:,17:end)')');
thetav=tsd(t*10000,(mean(Sptemp(:,100:160)')./mean(Sptemp(:,17:end)'))');
deltav=tsd(t*10000,(mean(Sptemp(:,30:65)')./mean(Sptemp(:,17:end)'))');


val(num,1)=ch;
val(num,2)=median(median(Data(Restrict(sptsd,sleepper))));
val(num,3)=median(median(Data(Restrict(sptsd,wakeper))));
val(num,4)=median(abs(Data(Restrict(LFP,sleepper))));
val(num,5)=median(abs(Data(Restrict(LFP,wakeper))));
val(num,6)=median(abs(Data((Restrict(deltav,sleepper)))));
val(num,7)=median(abs(Data((Restrict(deltav,wakeper)))));
val(num,8)=median(abs(Data((Restrict(thetav,sleepper)))));
val(num,9)=median(abs(Data((Restrict(thetav,wakeper)))));
val(num,10)=median(median(Data(Restrict(correctedav,sleepper))));
val(num,11)=median(median(Data(Restrict(correctedav,wakeper))));

num=num+1;
% TotalEpoch=intervalSet(t(1)*1e4,1e4*t(end));
% Epoch=TotalEpoch-GndNoiseEpoch-NoiseEpoch;
% numm=1;
% for m=1:length(Start(Epoch))
%     littleEpoch=subset(Epoch,m);
%     times=[Start(littleEpoch)/1e4:1:Stop(littleEpoch)/1e4-1];
%     for j=times
%     miniEpoch=intervalSet(j*1e4,(j+1)*1e4);
%     timeval(numm)=(j+0.5)*1e4;
%     gamval(numm)=mean(Data(Restrict(smooth_ghi,miniEpoch)));
%     delval(numm)=mean(Data(Restrict(DeltaTSD,miniEpoch)));
%     thetrat(numm)=mean(Data(Restrict(ThetaRatioTSD,miniEpoch)));
%     thetval(numm)=mean(Data(Restrict(ThetaTSD,miniEpoch)));
% numm=numm+1;
%     end
% end



end
h=figure;
subplot(4,1,1)
bar([mean(val(:,2)),mean(val(:,3))])
hold on
errorbar([mean(val(:,2)),mean(val(:,3))],[std(val(:,2)),std(val(:,3))],'x')
title('Total Spectrum Power')
subplot(1,2,2)
bar([mean(val(:,4)),mean(val(:,5))])
hold on
errorbar([mean(val(:,4)),mean(val(:,5))],[std(val(:,4)),std(val(:,5))],'x')
title('Average LFP Amp')
saveas(h,strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/MeanPowerAverage.png'))
saveas(h,strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/MeanPowerAverage.fig'))
close all

h=figure;
subplot(5,5,1:4)
bar(val(:,1),val(:,5)./val(:,4))
title('Total Spectrum Power')
subplot(5,5,5)
bar(mean(val(:,5)./val(:,4)))
hold on
errorbar(mean(val(:,5)./val(:,4)),std(val(:,5)./val(:,4)))
subplot(5,5,6:9)
bar(val(:,1),val(:,3)./val(:,2))
title('Average LFP Amp')
subplot(5,5,10)
bar(mean(val(:,3)./val(:,2)))
hold on
errorbar(mean(val(:,3)./val(:,2)),std(val(:,3)./val(:,2)))
subplot(5,5,11:14)
bar(val(:,1),val(:,7)./val(:,6))
title('Average Delta')
subplot(5,5,15)
bar(mean(val(:,7)./val(:,6)))
hold on
errorbar(mean(val(:,7)./val(:,6)),std(val(:,7)./val(:,6)))
subplot(5,5,16:19)
bar(val(:,1),val(:,9)./val(:,8))
title('Average Theta')
subplot(5,5,20)
bar(mean(val(:,9)./val(:,8)))
hold on
errorbar(mean(val(:,9)./val(:,8)),std(val(:,9)./val(:,8)))
subplot(5,5,21:24)
bar(val(:,1),val(:,11)./val(:,10))
title('Total Spectrum Power - cut off 2Hz')
subplot(5,5,25)
bar(mean(val(:,11)./val(:,10)))
hold on
errorbar(mean(val(:,11)./val(:,10)),std(val(:,11)./val(:,10)))

saveas(h,strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/MeanPowerChannel.png'))
saveas(h,strcat('/media/DataMOBs14/BulbSleepScoring/figures/Mouse51/20130220/MeanPowerChannel.fig'))
close all

save('vals.mat','val')

% Spitimes=ts(SpiTot(:,2)*1e4);
% spi(1,1)=length(Spitimes);
% Spitimes2=Restrict(Spitimes,sleepper);
% spi(1,2)=length(Spitimes2);
% 
% Spitimes=ts(SpiHigh(:,2)*1e4);
% spi(2,1)=length(Spitimes);
% Spitimes2=Restrict(Spitimes,sleepper);
% spi(2,2)=length(Spitimes2);
% 
% Spitimes=ts(SpiLow(:,2)*1e4);
% spi(3,1)=length(Spitimes);
% Spitimes2=Restrict(Spitimes,sleepper);
% spi(3,2)=length(Spitimes2);
% 
% Spitimes=ts(SpiULow(:,2)*1e4);
% spi(4,1)=length(Spitimes);
% Spitimes2=Restrict(Spitimes,sleepper);
% spi(4,2)=length(Spitimes2);
%  mean(spi(:,2)./spi(:,1))
% 
% 
% SWAtimes=ts(SWATot(:,2)*1e4);
% SWA(1,1)=length(SWAtimes);
% SWAtimes2=Restrict(SWAtimes,sleepper);
% SWA(1,2)=length(SWAtimes2);
% 
% SWAtimes=ts(SWAHigh(:,2)*1e4);
% SWA(2,1)=length(SWAtimes);
% SWAtimes2=Restrict(SWAtimes,sleepper);
% SWA(2,2)=length(SWAtimes2);
% 
% SWAtimes=ts(SWALow(:,2)*1e4);
% SWA(3,1)=length(SWAtimes);
% SWAtimes2=Restrict(SWAtimes,sleepper);
% SWA(3,2)=length(SWAtimes2);
% 
% SWAtimes=ts(SWAULow(:,2)*1e4);
% SWA(4,1)=length(SWAtimes);
% SWAtimes2=Restrict(SWAtimes,sleepper);
% SWA(4,2)=length(SWAtimes2);
% mean(SWA(:,2)./SWA(:,1))



end