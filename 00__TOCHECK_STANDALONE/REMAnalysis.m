function [S,FR,x1,x2,h1,h2,h3,h1a,h2a,h3a,h1b,h2b,h3b]=REMAnalysis(spikeanalysis);

%[S,Fr,x1,x2,h1,h2,h3,h1a,h2a,h3a,h1b,h2b,h3b]=REMAnalysis;

% cd('/Volumes/One Touch/Data_KB/DataUmazeSpikes_KB/M508')

spikeanalysis=0;

try 
    load Spikes 
end
load SleepScoring
load behavResources

try
    SessionNames.SleepPre{1};
catch
    SessionNames.SleepPre{1}=SessionNames.SleepPre_PreDrug{1};   
end

try
    SessionNames.SleepPost{1};
catch
    SessionNames.SleepPost{1}=SessionNames.SleepPost_PreDrug{1};   
end

try
cond=or(or(SessionNames.UMazeCond{1},SessionNames.UMazeCond{2}),or(SessionNames.UMazeCond{4},SessionNames.UMazeCond{5}));
catch
cond=or(SessionNames.UMazeCondExplo_PreDrug{2},SessionNames.UMazeCondExplo_PreDrug{2});
end


stim=Start(StimEpoch);

namb='bulb_deep';
namh='dHPC_rip';
namp='PFCx_deep';

res=pwd;
clear LFP
eval(['tempchBulb=load([res,''/ChannelsToAnalyse/',namb,'''],''channel'');'])
chBulb=tempchBulb.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chBulb),'.mat'');'])
LFPb=LFP;

clear LFP
eval(['tempchHpc=load([res,''/ChannelsToAnalyse/',namh,'''],''channel'');'])
chHpc=tempchHpc.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chHpc),'.mat'');'])
LFPh=LFP;
clear LFP

eval(['tempchPfc=load([res,''/ChannelsToAnalyse/',namh,'''],''channel'');'])
chPfc=tempchPfc.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chPfc),'.mat'');'])
LFPp=LFP;
clear LFP



%%

try 
    load B_Low_spectrum
    SpBtsd=Sptsd;
    load Pfcx_Low_spectrum
    SpPtsd=Sptsd;
    load H_Low_spectrum
    SpHtsd=Sptsd;


figure, 
subplot(1,3,1), hold on, 
plot(f, mean(Data(Restrict(SpBtsd,and(SessionNames.SleepPre{1},REMEpoch))))/10,'k')
plot(f, mean(Data(Restrict(SpPtsd,and(SessionNames.SleepPre{1},REMEpoch)))),'b')
plot(f, mean(Data(Restrict(SpHtsd,and(SessionNames.SleepPre{1},REMEpoch)))),'r')
subplot(1,3,2), hold on, title(pwd)
plot(f, mean(Data(Restrict(SpBtsd,and(cond,FreezeEpoch))))/10,'k')
plot(f, mean(Data(Restrict(SpPtsd,and(cond,FreezeEpoch)))),'b')
plot(f, mean(Data(Restrict(SpHtsd,and(cond,FreezeEpoch)))),'r')
subplot(1,3,3), hold on, 
plot(f, mean(Data(Restrict(SpBtsd,and(SessionNames.SleepPost{1},REMEpoch))))/10,'k')
plot(f, mean(Data(Restrict(SpPtsd,and(SessionNames.SleepPost{1},REMEpoch)))),'b')
plot(f, mean(Data(Restrict(SpHtsd,and(SessionNames.SleepPost{1},REMEpoch)))),'r')


S(:,1)=f;
S(:,2)=mean(Data(Restrict(SpBtsd,and(SessionNames.SleepPre{1},REMEpoch))));
S(:,3)=mean(Data(Restrict(SpPtsd,and(SessionNames.SleepPre{1},REMEpoch))));
S(:,4)=mean(Data(Restrict(SpHtsd,and(SessionNames.SleepPre{1},REMEpoch))));
S(:,5)=mean(Data(Restrict(SpBtsd,and(cond,FreezeEpoch))));
S(:,6)=mean(Data(Restrict(SpPtsd,and(cond,FreezeEpoch))));
S(:,7)=mean(Data(Restrict(SpHtsd,and(cond,FreezeEpoch))));
S(:,8)=mean(Data(Restrict(SpBtsd,and(SessionNames.SleepPost{1},REMEpoch))));
S(:,9)=mean(Data(Restrict(SpPtsd,and(SessionNames.SleepPost{1},REMEpoch))));
S(:,10)=mean(Data(Restrict(SpHtsd,and(SessionNames.SleepPost{1},REMEpoch))));


end



%%


SleepStages=PlotSleepStage(Wake,NREMEpoch,REMEpoch);
hold on, plot(Range(Restrict(SleepStages,FreezeEpoch),'s'),-1,'g.')
plot(stim*1E-4,0,'ko','markerfacecolor','y')
hold on, plot(Range(Pos,'s'),Data(Pos)-0.5)
title(pwd)

%%

Filh=FilterLFP(LFPh,[5 10],1024);
Filb=FilterLFP(LFPb,[2 5],2048);
Filbh=FilterLFP(LFPb,[5 10],1024);
Filhb=FilterLFP(LFPh,[2 5],2048);

i=6;



if spikeanalysis
    
% [Phb,phasesandtimesb,powerTsdb]=CalCulPrefPhase(Restrict(Spikes,and(cond,FreezeEpoch)),Filb,'H');
% [Phh,phasesandtimesh,powerTsdh]=CalCulPrefPhase(Restrict(Spikes,and(cond,FreezeEpoch)),Filh,'H');

[Phb,phasesandtimesb,powerTsdb]=CalCulPrefPhase(Spikes,Filb,'H');
[Phh,phasesandtimesh,powerTsdh]=CalCulPrefPhase(Spikes,Filh,'H');

i=6;
i=i+1;
figure, 
subplot(2,3,1), [mub(i,1), Kappab(i,1), pvalb(i,1)]=JustPoltModKB(Data(Restrict(Phb{i},and(SessionNames.SleepPre{1},REMEpoch))),25);
subplot(2,3,2), [mub(i,2), Kappab(i,2), pvalb(i,2)]=JustPoltModKB(Data(Restrict(Phb{i},and(cond,FreezeEpoch))),25);
subplot(2,3,3), [mub(i,3), Kappab(i,3), pvalb(i,3)]=JustPoltModKB(Data(Restrict(Phb{i},and(SessionNames.SleepPost{1},REMEpoch))),25);
subplot(2,3,4), [muh(i,1), Kappah(i,1), pvalh(i,1)]=JustPoltModKB(Data(Restrict(Phh{i},and(SessionNames.SleepPre{1},REMEpoch))),25);
subplot(2,3,5), [muh(i,2), Kappah(i,2), pvalh(i,2)]=JustPoltModKB(Data(Restrict(Phh{i},and(cond,FreezeEpoch))),25);
subplot(2,3,6), [muh(i,3), Kappah(i,3), pvalh(i,3)]=JustPoltModKB(Data(Restrict(Phh{i},and(SessionNames.SleepPost{1},REMEpoch))),25);

end

try
    
for i=1:length(Spikes)
Fr(i,1)=length(Range(Restrict(Spikes{i},and(SessionNames.SleepPre{1},REMEpoch))))/sum(DurationEpoch(and(SessionNames.SleepPre{1},REMEpoch))/1E4);
Fr(i,2)=length(Range(Restrict(Spikes{i},and(cond,FreezeEpoch))))/sum(DurationEpoch(and(cond,FreezeEpoch))/1E4);
Fr(i,3)=length(Range(Restrict(Spikes{i},and(SessionNames.SleepPre{1},REMEpoch))))/sum(DurationEpoch(and(SessionNames.SleepPre{1},REMEpoch))/1E4);
Fr(i,4)=length(Range(Restrict(Spikes{i},(cond-FreezeEpoch))))/sum(DurationEpoch((cond-FreezeEpoch))/1E4);
Fr(i,5)=length(Range(Restrict(Spikes{i},(cond))))/sum(DurationEpoch((cond))/1E4);
end
catch
    Fr=[];
end

FR=Fr;
%%

if spikeanalysis
for i=1:10
[H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(Restrict(LFPb,and(SessionNames.SleepPre{1},REMEpoch)),Restrict(Spikes{i},and(SessionNames.SleepPre{1},REMEpoch)),0.05,40,1024,'H',25,2);
[H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(Restrict(LFPb,and(cond,FreezeEpoch)),Restrict(Spikes{i},and(cond,FreezeEpoch)),0.05,40,1024,'H',25,2);
[H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(Restrict(LFPb,and(SessionNames.SleepPost{1},REMEpoch)),Restrict(Spikes{i},and(SessionNames.SleepPost{1},REMEpoch)),0.05,40,1024,'H',25,2);
[H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(Restrict(LFPh,and(SessionNames.SleepPre{1},REMEpoch)),Restrict(Spikes{i},and(SessionNames.SleepPre{1},REMEpoch)),0.05,40,1024,'H',25,2);
[H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(Restrict(LFPh,and(cond,FreezeEpoch)),Restrict(Spikes{i},and(cond,FreezeEpoch)),0.05,40,1024,'H',25,2);
[H,HS,Ph,ModTheta, EpochSelected]=RayleighFreq2(Restrict(LFPh,and(SessionNames.SleepPost{1},REMEpoch)),Restrict(Spikes{i},and(SessionNames.SleepPost{1},REMEpoch)),0.05,40,1024,'H',25,2);
end

end


%%

if spikeanalysis
for i=1:length(Spikes)
try
figure, 
subplot(2,3,1), [mub(i,1), Kappab(i,1), pvalb(i,1)]=JustPoltModKB(Data(Restrict(Phb{i},and(SessionNames.SleepPre{1},REMEpoch))),25);
subplot(2,3,2), [mub(i,2), Kappab(i,2), pvalb(i,2)]=JustPoltModKB(Data(Restrict(Phb{i},and(cond,FreezeEpoch))),25);
subplot(2,3,3), [mub(i,3), Kappab(i,3), pvalb(i,3)]=JustPoltModKB(Data(Restrict(Phb{i},and(SessionNames.SleepPost{1},REMEpoch))),25);
subplot(2,3,4), [muh(i,1), Kappah(i,1), pvalh(i,1)]=JustPoltModKB(Data(Restrict(Phh{i},and(SessionNames.SleepPre{1},REMEpoch))),25);
subplot(2,3,5), [muh(i,2), Kappah(i,2), pvalh(i,2)]=JustPoltModKB(Data(Restrict(Phh{i},and(cond,FreezeEpoch))),25);
subplot(2,3,6), [muh(i,3), Kappah(i,3), pvalh(i,3)]=JustPoltModKB(Data(Restrict(Phh{i},and(SessionNames.SleepPost{1},REMEpoch))),25);
end
close
end

end

%%

zrh = hilbert(Data(Filh));
phzrh = atan2(imag(zrh), real(zrh));
phzrh(phzrh < 0) = phzrh(phzrh < 0) + 2 * pi;
phasehTsd = tsd(Range(Filh), phzrh);

zrb = hilbert(Data(Filb));
phzrb = atan2(imag(zrb), real(zrb));
phzrb(phzrb < 0) = phzrb(phzrb < 0) + 2 * pi;
phasebTsd = tsd(Range(Filb), phzrb);

zrhb = hilbert(Data(Filhb));
phzrhb = atan2(imag(zrhb), real(zrhb));
phzrhb(phzrhb < 0) = phzrhb(phzrhb < 0) + 2 * pi;
phasehbTsd = tsd(Range(Filhb), phzrhb);

zrbh = hilbert(Data(Filbh));
phzrbh = atan2(imag(zrbh), real(zrbh));
phzrbh(phzrbh < 0) = phzrbh(phzrbh < 0) + 2 * pi;
phasebhTsd = tsd(Range(Filbh), phzrbh);

[h1,x1,x2]=hist2d(Data(Restrict(phasebTsd,and(SessionNames.SleepPre{1},REMEpoch))),Data(Restrict(phasehTsd,and(SessionNames.SleepPre{1},REMEpoch))),[0.1:0.1:2*pi+0.1],[0.1:0.1:2*pi+0.1]);
[h2,x1,x2]=hist2d(Data(Restrict(phasebTsd,and(cond,FreezeEpoch))),Data(Restrict(phasehTsd,and(cond,FreezeEpoch))),[0.1:0.1:2*pi+0.1],[0.1:0.1:2*pi+0.1]);
[h3,x1,x2]=hist2d(Data(Restrict(phasebTsd,and(SessionNames.SleepPost{1},REMEpoch))),Data(Restrict(phasehTsd,and(SessionNames.SleepPost{1},REMEpoch))),[0.1:0.1:2*pi+0.1],[0.1:0.1:2*pi+0.1]);

[h1a,x1,x2]=hist2d(Data(Restrict(phasebTsd,and(SessionNames.SleepPre{1},REMEpoch))),Data(Restrict(phasehbTsd,and(SessionNames.SleepPre{1},REMEpoch))),[0.1:0.1:2*pi+0.1],[0.1:0.1:2*pi+0.1]);
[h2a,x1,x2]=hist2d(Data(Restrict(phasebTsd,and(cond,FreezeEpoch))),Data(Restrict(phasehbTsd,and(cond,FreezeEpoch))),[0.1:0.1:2*pi+0.1],[0.1:0.1:2*pi+0.1]);
[h3a,x1,x2]=hist2d(Data(Restrict(phasebTsd,and(SessionNames.SleepPost{1},REMEpoch))),Data(Restrict(phasehbTsd,and(SessionNames.SleepPost{1},REMEpoch))),[0.1:0.1:2*pi+0.1],[0.1:0.1:2*pi+0.1]);

[h1b,x1,x2]=hist2d(Data(Restrict(phasebhTsd,and(SessionNames.SleepPre{1},REMEpoch))),Data(Restrict(phasehTsd,and(SessionNames.SleepPre{1},REMEpoch))),[0.1:0.1:2*pi+0.1],[0.1:0.1:2*pi+0.1]);
[h2b,x1,x2]=hist2d(Data(Restrict(phasebhTsd,and(cond,FreezeEpoch))),Data(Restrict(phasehTsd,and(cond,FreezeEpoch))),[0.1:0.1:2*pi+0.1],[0.1:0.1:2*pi+0.1]);
[h3b,x1,x2]=hist2d(Data(Restrict(phasebhTsd,and(SessionNames.SleepPost{1},REMEpoch))),Data(Restrict(phasehTsd,and(SessionNames.SleepPost{1},REMEpoch))),[0.1:0.1:2*pi+0.1],[0.1:0.1:2*pi+0.1]);


smo=0.7;

figure, 
subplot(3,3,1), imagesc(x1,x2,SmoothDec(h1(3:end-2,3:end-2),[smo,smo])), axis xy
subplot(3,3,2), imagesc(x1,x2,SmoothDec(h2(3:end-2,3:end-2),[smo,smo])), axis xy, title(pwd)
subplot(3,3,3), imagesc(x1,x2,SmoothDec(h3(3:end-2,3:end-2),[smo,smo])), axis xy
subplot(3,3,4), imagesc(x1,x2,SmoothDec(h1a(3:end-2,3:end-2),[smo,smo])), axis xy
subplot(3,3,5), imagesc(x1,x2,SmoothDec(h2a(3:end-2,3:end-2),[smo,smo])), axis xy
subplot(3,3,6), imagesc(x1,x2,SmoothDec(h3a(3:end-2,3:end-2),[smo,smo])), axis xy
subplot(3,3,7), imagesc(x1,x2,SmoothDec(h1b(3:end-2,3:end-2),[smo,smo])), axis xy
subplot(3,3,8), imagesc(x1,x2,SmoothDec(h2b(3:end-2,3:end-2),[smo,smo])), axis xy
subplot(3,3,9), imagesc(x1,x2,SmoothDec(h3b(3:end-2,3:end-2),[smo,smo])), axis xy
% 
% figure, 
% subplot(1,3,1), imagesc(x1,x2,SmoothDec(h1(3:end-2,3:end-2),[smo,smo])), axis xy
% subplot(1,3,2), imagesc(x1,x2,SmoothDec(h2(3:end-2,3:end-2),[smo,smo])), axis xy
% subplot(1,3,3), imagesc(x1,x2,SmoothDec(h3(3:end-2,3:end-2),[smo,smo])), axis xy

if spikeanalysis
i=i+1;
[h1,x1,x2]=hist2d(Data(Restrict(Phb{i},and(SessionNames.SleepPre{1},REMEpoch))),Data(Restrict(Phh{i},and(SessionNames.SleepPre{1},REMEpoch))),[0.1:0.1:2*pi+0.1],[0.1:0.1:2*pi+0.1]);
[h2,x1,x2]=hist2d(Data(Restrict(Phb{i},and(cond,FreezeEpoch))),Data(Restrict(Phh{i},and(cond,FreezeEpoch))),[0.2:0.1:2*pi+0.1],[0.2:0.1:2*pi+0.1]);
[h3,x1,x2]=hist2d(Data(Restrict(Phb{i},and(SessionNames.SleepPost{1},REMEpoch))),Data(Restrict(Phh{i},and(SessionNames.SleepPost{1},REMEpoch))),[0.1:0.1:2*pi+0.1],[0.1:0.1:2*pi+0.1]);
figure, 
subplot(1,3,1), imagesc(x1,x2,SmoothDec(h1(2:end,2:end),[1,1])), axis xy
subplot(1,3,2), imagesc(x1,x2,SmoothDec(h2(2:end,2:end),[1,1])), axis xy
subplot(1,3,3), imagesc(x1,x2,SmoothDec(h3(2:end,2:end),[1,1])), axis xy

end




%%

if spikeanalysis
figure, 
subplot(2,3,1), plot(mub(:,1),mub(:,3),'k.','markersize',10)
subplot(2,3,2), plot(mub(:,2),mub(:,3),'k.','markersize',10)
subplot(2,3,3), plot(mub(:,2),mub(:,3)-mub(:,1),'k.','markersize',10)
subplot(2,3,4), plot(muh(:,1),muh(:,3),'k.','markersize',10)
subplot(2,3,5), plot(muh(:,2),muh(:,3),'k.','markersize',10)
subplot(2,3,6), plot(muh(:,2),muh(:,3)-muh(:,1),'k.','markersize',10)


figure, 
subplot(2,3,1), plot(mub(find(pvalb(:,1)<0.05),1),mub(find(pvalb(:,1)<0.05),3),'k.','markersize',10)
subplot(2,3,2), plot(mub(find(pvalb(:,1)<0.05),2),mub(find(pvalb(:,1)<0.05),3),'k.','markersize',10)
subplot(2,3,3), plot(mub(find(pvalb(:,1)<0.05),2),mub(find(pvalb(:,1)<0.05),3)-mub(find(pvalb(:,1)<0.05),1),'k.','markersize',10)
subplot(2,3,4), plot(muh(find(pvalh(:,1)<0.05),1),muh(find(pvalh(:,1)<0.05),3),'k.','markersize',10)
subplot(2,3,5), plot(muh(find(pvalh(:,1)<0.05),2),muh(find(pvalh(:,1)<0.05),3),'k.','markersize',10)
subplot(2,3,6), plot(muh(find(pvalh(:,1)<0.05),2),muh(find(pvalh(:,1)<0.05),3)-muh(find(pvalh(:,1)<0.05),1),'k.','markersize',10)


figure, 
subplot(2,3,1), plot(Kappab(:,1),Kappab(:,3),'k.','markersize',10)
subplot(2,3,2), plot(Kappab(:,2),Kappab(:,3),'k.','markersize',10)
subplot(2,3,3), plot(Kappab(:,2),Kappab(:,3)-Kappab(:,1),'k.','markersize',10)
subplot(2,3,4), plot(Kappah(:,1),Kappah(:,3),'k.','markersize',10)
subplot(2,3,5), plot(Kappah(:,2),Kappah(:,3),'k.','markersize',10)
subplot(2,3,6), plot(Kappah(:,2),Kappah(:,3)-Kappah(:,1),'k.','markersize',10)

end

%%
% 
% function [temp,temp2,Qtsd,Qf,idsigpos,idsigneg,Epoch]=FunctionPfcActivityFreezing(nam,freq,idsigpos,idsigneg)
% 
% res=pwd;
% try
%     nam;
% catch
%     nam='bulb_deep';
% end
% try
%     freq;
% catch
%     freq=[3 5];
% end
% 
% ppc=1;
%  
% clear LFP
% eval(['tempchBulb=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
% %tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
% chBulb=tempchBulb.channel;
% eval(['load(''',res,'','/LFPData/LFP',num2str(chBulb),'.mat'');'])
% 
% 
% load behavResources FreezeEpoch
% load SpikeData S
% rgg=Range(LFP);
% 
% %%
% %---------------------------------------------
% %Epoch=intervalSet(rgg(1),rgg(end));
% %Epoch=Epoch-FreezeEpoch;
% Epoch=FreezeEpoch;
% S2=Restrict(S,Epoch);
% %---------------------------------------------
% 
% %%
% Fil=FilterLFP(LFP,freq,2048);
% [tPeaks,Peaks]=FindMaxPeaks([Range(Fil),Data(Fil)]);
% [tPeaks2,Peaks2]=FindMaxPeaks([Range(Restrict(Fil,Epoch)),Data(Restrict(Fil,Epoch))]);
% 
% clear h
% clear b
% for i=1:length(S)
% [h(i,:),b]=hist(Range(S{i}),tPeaks);
% end
% Q=zscore(h');
% 
% %%
% 
% Qtsd=tsd(b,Q);
% [Qf,idF]=Restrict(Qtsd,FreezeEpoch);
% Freez=zeros(1,size(Q,1));
% Freez(idF)=1;
% 
% %%
% clear X r R
% for i=1:size(Q,2)
%     [X(i,:),lag]=xcorr(Q(:,i),Freez,300,'coef');
%     [r,p]=corrcoef(Freez,Q(:,i));
%     R(i,1)=r(2,1);
%     R(i,2)=p(2,1);
% end
% [BE,Idx]=sort(R(:,1));
% 
% try
% idsigpos;
% catch
% idsigpos=find(R(:,1)<0&R(:,2)<0.05);  
% end
% 
% try
% idsigneg;
% catch
% idsigneg=find(R(:,1)>0&R(:,2)<0.05); 
% end
% 
% Xz=SmoothDec(X,[0.01,2]);
% 
% clear idmax idmin idmai
% for i=1:length(S)
%     [Ma,idmax(i)]=max(Xz(i,:));
%     [Mi,idmin(i)]=min(Xz(i,:));
%     if abs(Ma)>abs(Mi)
%         idmai(i)=idmax(i);
%         Mai(i)=Ma;
%     else
%         idmai(i)=idmin(i);
%         Mai(i)=Mi;
%     end
% end
%    
% [BE,idd]=sort(idmax);
% 
% % WaveEpoch=intervalSet(tPeaks(1:end),[tPeaks(2:end);tPeaks(end)+0.2E4]);
% WaveEpoch=intervalSet(tPeaks2(1:end),[tPeaks2(2:end);tPeaks2(end)+0.2E4]);
% Du=DurationEpoch(WaveEpoch);
% WaveEpoch=subset(WaveEpoch,find(Du<5000));
% [BE,idx]=sort(Peaks2(find(Du<5000)));
% 
% clear temp
% % for k=1:10
% %     i=Idx(k);
%     %i=idx(end-k:end);
% for k=1:length(idsigpos)
%     i=idsigpos(k);
%     temp(k,1)=length(Range(Restrict(S2{i},subset(WaveEpoch,sort(idx(1:floor(length(idx)/5)))))))/mean(DurationEpoch(subset(WaveEpoch,sort(idx(1:floor(length(idx)/5))))));
%     temp(k,2)=length(Range(Restrict(S2{i},subset(WaveEpoch,sort(idx(floor(length(idx)/5):2*floor(length(idx)/5)))))))/mean(DurationEpoch(subset(WaveEpoch,sort(idx(floor(length(idx)/5):2*floor(length(idx)/5))))));
%     temp(k,3)=length(Range(Restrict(S2{i},subset(WaveEpoch,sort(idx(2*floor(length(idx)/5):3*floor(length(idx)/5)))))))/mean(DurationEpoch(subset(WaveEpoch,sort(idx(2*floor(length(idx)/5):3*floor(length(idx)/5))))));
%     temp(k,4)=length(Range(Restrict(S2{i},subset(WaveEpoch,sort(idx(3*floor(length(idx)/5):4*floor(length(idx)/5)))))))/mean(DurationEpoch(subset(WaveEpoch,sort(idx(3*floor(length(idx)/5):4*floor(length(idx)/5))))));
%     temp(k,5)=length(Range(Restrict(S2{i},subset(WaveEpoch,sort(idx(4*floor(length(idx)/5):5*floor(length(idx)/5)))))))/mean(DurationEpoch(subset(WaveEpoch,sort(idx(4*floor(length(idx)/5):5*floor(length(idx)/5))))));
% end
% 
% clear temp2
% % for k=1:10
% %     %i=idx(k);
% %     i=Idx(end-k:end);
% for k=1:length(idsigneg)
%     i=idsigneg(k);    
%     temp2(k,1)=length(Range(Restrict(S2{i},subset(WaveEpoch,sort(idx(1:floor(length(idx)/5)))))))/mean(DurationEpoch(subset(WaveEpoch,sort(idx(1:floor(length(idx)/5))))));
%     temp2(k,2)=length(Range(Restrict(S2{i},subset(WaveEpoch,sort(idx(floor(length(idx)/5):2*floor(length(idx)/5)))))))/mean(DurationEpoch(subset(WaveEpoch,sort(idx(floor(length(idx)/5):2*floor(length(idx)/5))))));
%     temp2(k,3)=length(Range(Restrict(S2{i},subset(WaveEpoch,sort(idx(2*floor(length(idx)/5):3*floor(length(idx)/5)))))))/mean(DurationEpoch(subset(WaveEpoch,sort(idx(2*floor(length(idx)/5):3*floor(length(idx)/5))))));
%     temp2(k,4)=length(Range(Restrict(S2{i},subset(WaveEpoch,sort(idx(3*floor(length(idx)/5):4*floor(length(idx)/5)))))))/mean(DurationEpoch(subset(WaveEpoch,sort(idx(3*floor(length(idx)/5):4*floor(length(idx)/5))))));
%     temp2(k,5)=length(Range(Restrict(S2{i},subset(WaveEpoch,sort(idx(4*floor(length(idx)/5):5*floor(length(idx)/5)))))))/mean(DurationEpoch(subset(WaveEpoch,sort(idx(4*floor(length(idx)/5):5*floor(length(idx)/5))))));
% end
% 
% try
%     temp;
% catch
%     temp=[];
% end
% try
%     temp2;
% catch
%     temp2=[];
% end
% 
% 
% 
