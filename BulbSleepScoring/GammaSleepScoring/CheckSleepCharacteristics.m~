function CheckSleepCharacteristics(filename,Epoch,chH,struct)

TRS=[400/1001:400/1001:800]-400;
scrsz = get(0,'ScreenSize');
load(strcat(filename,'StateEpochSB.mat'))
load(strcat('LFPData/LFP',num2str(chH),'.mat'));
Rip=FindRipplesKarim(LFP,Epoch);
Ripples=tsd(Rip(:,2)*1E4,Rip(:,2)*1E4);
[MSR,TSR]=PlotRipRaw(LFP,Data(Restrict(Ripples,SWSEpoch))/1e4,50); close;
[MWR,TWR]=PlotRipRaw(LFP,Data(Restrict(Ripples,Wake))/1e4,50); close;
[MRR,TRR]=PlotRipRaw(LFP,Data(Restrict(Ripples,REMEpoch))/1e4,50); close;
[MTOTR,TTOTR]=PlotRipRaw(LFP,Data((Ripples))/1e4,50); close;
DT=50/125;
timeR=[DT:DT:50]-25;
Filsp=FilterLFP(Restrict(LFP,Epoch),[120 200],1024);
HilRip=hilbert(Data(Filsp));
HRip=tsd(Range(Filsp),abs(HilRip));

try
eval(['load(''ChannelsToAnalyse/',struct,'_sup.mat'')'])
ch=channel;
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
catch
    eval(['load(''ChannelsToAnalyse/',struct,'_deep.mat'')'])
ch=channel;
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
end
    
    [Spi,SWA,stdev]=FindSpindlesKarimNew(LFP,[10 15],Epoch);
Spindles=tsd(Spi(:,2)*1E4,Spi(:,2)*1E4);

[MS,TS]=PlotRipRaw(LFP,Data(Restrict(Spindles,SWSEpoch))/1e4,1000); close;
[MW,TW]=PlotRipRaw(LFP,Data(Restrict(Spindles,Wake))/1e4,1000); close;
if size(Data(Restrict(Spindles,REMEpoch)),1)>2
[MR,TR]=PlotRipRaw(LFP,Data(Restrict(Spindles,REMEpoch))/1e4,1000); close;
else
    MR=[];
    TR=[];
end
[MTOT,TTOT]=PlotRipRaw(LFP,Data((Spindles))/1e4,1000); close;
DT=1000/2501;
timeS=[DT:DT:1000]-500;

try
    [tDeltaT2,tDeltaP2]=FindDeltaWaves(struct,Epoch);
Delta=tsd(Range(tDeltaT2),Range(tDeltaT2));
eval(['load(''ChannelsToAnalyse/',struct,'_deep.mat'')'])
ch=channel;
eval(['load(''ChannelsToAnalyse/',struct,'_sup.mat'')'])
ch2=channel;
eval(['load(''LFPData/LFP',num2str(ch),'.mat'')'])
eegDeep=LFP;
eval(['load(''LFPData/LFP',num2str(ch2),'.mat'')'])
eegSup=LFP;
[MDSs,TDSs]=PlotRipRaw(eegSup,Data(Restrict(Delta,SWSEpoch))/1e4,500); close;
[MDSd,TDSd]=PlotRipRaw(eegDeep,Data(Restrict(Delta,SWSEpoch))/1e4,500); close;
[MDRs,TDRs]=PlotRipRaw(eegSup,Data(Restrict(Delta,REMEpoch))/1e4,500); close;
[MDRd,TDRd]=PlotRipRaw(eegDeep,Data(Restrict(Delta,REMEpoch))/1e4,500); close;
[MDWs,TDWs]=PlotRipRaw(eegSup,Data(Restrict(Delta,Wake))/1e4,500); close;
[MDWd,TDWd]=PlotRipRaw(eegDeep,Data(Restrict(Delta,Wake))/1e4,500); close;
[MDTs,TDTs]=PlotRipRaw(eegSup,Data(Delta)/1e4,500); close;
[MDTd,TDTd]=PlotRipRaw(eegDeep,Data(Delta)/1e4,500); close;
DT=500/1251;
timeD=[DT:DT:500]-250;
DeltaWave=1;
catch
    DeltaWave=0;
end

num=3;
RemCell=DivideEpoch(REMEpoch,num);
SWSCell=DivideEpoch(SWSEpoch,num);
WakeCell=DivideEpoch(Wake,num);
f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);

ha=tight_subplot(3,7,[.05 .01],[.1 .1],[.05 .1]);
for k=1:num
    subplot(ha(1))
    if DeltaWave
line([1+(k-1) 1+(k-1)], [0 size(Data(Restrict(Delta,SWSCell{1,k})),1)/(size(Data(Restrict(LFP,SWSCell{1,k})),1)*8e-4)],'color',[0 0.8 1],'linewidth',10)
line([6+(k-1) 6+(k-1)], [0 size(Data(Restrict(Delta,RemCell{1,k})),1)/(size(Data(Restrict(LFP,RemCell{1,k})),1)*8e-4)],'color',[0.8 0.2 0.1],'linewidth',10)
line([11+(k-1) 11+(k-1)], [0 size(Data(Restrict(Delta,WakeCell{1,k})),1)/(size(Data(Restrict(LFP,WakeCell{1,k})),1)*8e-4)],'color',[0.2 0.2 0.2],'linewidth',10)
 ylabel('occurence per sec')
 title('Delta Wave')
set(gca,'XTick',[2 7 12],'XTickLabel',{'SWS','REM','Wake'})
    end
    
   subplot(ha(8))
line([1+(k-1) 1+(k-1)], [0 size(Data(Restrict(Spindles,SWSCell{1,k})),1)/(size(Data(Restrict(LFP,SWSCell{1,k})),1)*8e-4)],'color',[0 0.8 1],'linewidth',10)
line([6+(k-1) 6+(k-1)], [0 size(Data(Restrict(Spindles,RemCell{1,k})),1)/(size(Data(Restrict(LFP,RemCell{1,k})),1)*8e-4)],'color',[0.8 0.2 0.1],'linewidth',10)
line([11+(k-1) 11+(k-1)], [0 size(Data(Restrict(Spindles,WakeCell{1,k})),1)/(size(Data(Restrict(LFP,WakeCell{1,k})),1)*8e-4)],'color',[0.2 0.2 0.2],'linewidth',10)
ylabel('occurence per sec')
 title('Spindles')
 set(gca,'XTick',[2 7 12],'XTickLabel',{'SWS','REM','Wake'})

subplot(ha(15))
line([1+(k-1) 1+(k-1)], [0 size(Data(Restrict(Ripples,SWSCell{1,k})),1)/(size(Data(Restrict(LFP,SWSCell{1,k})),1)*8e-4)],'color',[0 0.8 1],'linewidth',10)
line([6+(k-1) 6+(k-1)], [0 size(Data(Restrict(Ripples,RemCell{1,k})),1)/(size(Data(Restrict(LFP,RemCell{1,k})),1)*8e-4)],'color',[0.8 0.2 0.1],'linewidth',10)
line([11+(k-1) 11+(k-1)], [0 size(Data(Restrict(Ripples,WakeCell{1,k})),1)/(size(Data(Restrict(LFP,WakeCell{1,k})),1)*8e-4)],'color',[0.2 0.2 0.2],'linewidth',10)
ylabel('occurence per sec')
title('Ripples')
set(gca,'XTick',[2 7 12],'XTickLabel',{'SWS','REM','Wake'})

end


% subplot(3,3,3)
% line([1 1], [0 size(Data(Restrict(Delta,MicroWake)),1)/(size(Data(Restrict(LFP,MicroWake)),1)*8e-4)],'color',[0.2 0.2 0.2],'linewidth',25)
% line([2 2], [0 size(Data(Restrict(Delta,MicroSleep)),1)/(size(Data(Restrict(LFP,MicroSleep)),1)*8e-4)],'color',[0 0.8 1],'linewidth',25)
% subplot(3,3,6)
% line([1 1], [0 size(Data(Restrict(Spindles,MicroWake)),1)/(size(Data(Restrict(LFP,MicroWake)),1)*8e-4)],'color',[0.2 0.2 0.2],'linewidth',25)
% line([2 2], [0 size(Data(Restrict(Spindles,MicroSleep)),1)/(size(Data(Restrict(LFP,MicroSleep)),1)*8e-4)],'color',[0 0.8 1],'linewidth',25)
% subplot(3,3,9)
% line([1 1], [0 size(Data(Restrict(Ripples,MicroWake)),1)/(size(Data(Restrict(LFP,MicroWake)),1)*8e-4)],'color',[0.2 0.2 0.2],'linewidth',25)
% line([2 2], [0 size(Data(Restrict(Ripples,MicroSleep)),1)/(size(Data(Restrict(LFP,MicroSleep)),1)*8e-4)],'color',[0 0.8 1],'linewidth',25)

% 
% f=figure;
% subplot(371)
% line([1 1], [0 size(Data(Restrict(Delta,SWSEpoch)))/(size(Data(Restrict(LFP,SWSEpoch)))*8e-4)],'color',[0 0.8 1],'linewidth',25)
% hold on
% line([3 3], [0 size(Data(Restrict(Delta,REMEpoch)))/(size(Data(Restrict(LFP,REMEpoch)))*8e-4)],'color',[0.8 0.2 0.1],'linewidth',25)
% line([5 5], [0 size(Data(Restrict(Delta,Wake)))/(size(Data(Restrict(LFP,Wake)))*8e-4)],'color',[0.2 0.2 0.2],'linewidth',25)
% title('Delta Wave')
% xlim([0 6])
% ylabel('occurence per sec')
% set(gca,'XTick',[1 3 5],'XTickLabel',{'SWS','REM','Wake'})
% subplot(378)
% line([1 1], [0 size(Data(Restrict(Spindles,SWSEpoch)))/(size(Data(Restrict(LFP,SWSEpoch)))*8e-4)],'color',[0 0.8 1],'linewidth',25)
% hold on
% line([3 3], [0 size(Data(Restrict(Spindles,REMEpoch)))/(size(Data(Restrict(LFP,REMEpoch)))*8e-4)],'color',[0.8 0.2 0.1],'linewidth',25)
% line([5 5], [0 size(Data(Restrict(Spindles,Wake)))/(size(Data(Restrict(LFP,Wake)))*8e-4)],'color',[0.2 0.2 0.2],'linewidth',25)
% title('Spindles')
% ylabel('occurence per sec')
% set(gca,'XTick',[1 3 5],'XTickLabel',{'SWS','REM','Wake'})
% xlim([0 6])
% subplot(3,7,15)
% line([1 1], [0 size(Data(Restrict(Ripples,SWSEpoch)))/(size(Data(Restrict(LFP,SWSEpoch)))*8e-4)],'color',[0 0.8 1],'linewidth',25)
% hold on
% line([3 3], [0 size(Data(Restrict(Ripples,REMEpoch)))/(size(Data(Restrict(LFP,REMEpoch)))*8e-4)],'color',[0.8 0.2 0.1],'linewidth',25)
% line([5 5], [0 size(Data(Restrict(Ripples,Wake)))/(size(Data(Restrict(LFP,Wake)))*8e-4)],'color',[0.2 0.2 0.2],'linewidth',25)
% title('Ripples')
% set(gca,'XTick',[1 3 5],'XTickLabel',{'SWS','REM','Wake'})
% ylabel('occurence per sec')
% xlim([0 6])



subplot(472)
    if DeltaWave

[C, B] = CrossCorr(Spi(:,2), Range(tDeltaT2)/1e4, 0.2, 50);
plot(B,C)
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
title('Delta wave rel to Spindle')
subplot(473)
[C, B] = CrossCorr(Rip(:,2), Range(tDeltaT2)/1e4, 0.2, 50);
plot(B,C)
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
title('Delta wave rel to Ripple')
    end
    
subplot(474)
[C, B] = CrossCorr(Spi(:,2), Rip(:,2), 0.2, 50);
plot(B,C)
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
title('Ripple rel to Spindle')
subplot(475)
plot(timeS,MTOT(:,2))
hold on
[M,T]=PlotRipRaw(HRip,Data(Spindles)/1e4,400);close;
TRS=[800/size(M,1):800/size(M,1):800]-400;
plot(TRS,M(:,2)-1000,'linewidth',2,'color','k');
title('Average Spindle Form')
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
subplot(476)
plot(timeR,MTOTR(:,2))
title('Average Ripple Form')
    if DeltaWave
subplot(477)
plot(timeD,MDTs(:,2))
hold on
plot(timeD,MDTd(:,2),'linewidth',2)
title('Average Delta Form')
    end

SpS=Data(Restrict(Spindles,SWSEpoch))/1e4;
RiS=Data(Restrict(Ripples,SWSEpoch))/1e4;
    if DeltaWave

DeS=Data(Restrict(Delta,SWSEpoch))/1e4;
subplot(479)
[C, B] = CrossCorr(SpS, DeS, 0.2, 50);
plot(B,C,'color',[0 0.8 1])
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
subplot(4,7,10)
[C, B] = CrossCorr(RiS, DeS, 0.2, 50);
plot(B,C,'color',[0 0.8 1])
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
    end
subplot(4,7,11)
[C, B] = CrossCorr(SpS, RiS, 0.2, 50);
plot(B,C,'color',[0 0.8 1])
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
subplot(4,7,12)
plot(timeS,MS(:,2),'color',[0 0.8 1])
hold on
[M,T]=PlotRipRaw(HRip,SpS,400);close;
TRS=[800/size(M,1):800/size(M,1):800]-400;
plot(TRS,M(:,2)-1000,'linewidth',2,'color','k');
subplot(4,7,13)
plot(timeR,MSR(:,2),'color',[0 0.8 1])
if DeltaWave
subplot(4,7,14)
plot(timeD,MDSs(:,2),'color',[0 0.8 1])
hold on
plot(timeD,MDSd(:,2),'linewidth',2,'color',[0 0.8 1])
end


SpR=Data(Restrict(Spindles,REMEpoch))/1e4;
RiR=Data(Restrict(Ripples,REMEpoch))/1e4;
    if DeltaWave
DeR=Data(Restrict(Delta,REMEpoch))/1e4;
subplot(4,7,16)
[C, B] = CrossCorr(SpR, DeR, 0.2, 50);
plot(B,C,'color',[0.8 0.2 0.1])
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
subplot(4,7,17)
[C, B] = CrossCorr(RiR, DeR, 0.2, 50);
plot(B,C,'color',[0.8 0.2 0.1])
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
    end
subplot(4,7,18)
[C, B] = CrossCorr(SpR, RiR, 0.2, 50);
plot(B,C,'color',[0.8 0.2 0.1])
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
subplot(4,7,19)
plot(timeS,MR(:,2),'color',[0.8 0.2 0.1])
hold on
[M,T]=PlotRipRaw(HRip,SpR,400);close;
TRS=[800/size(M,1):800/size(M,1):800]-400;
plot(TRS,M(:,2)-1000,'linewidth',2,'color','k');
subplot(4,7,20)
plot(timeR,MRR(:,2),'color',[0.8 0.2 0.1])
    if DeltaWave
subplot(4,7,21)
plot(timeD,MDRs(:,2),'color',[0.8 0.2 0.1])
hold on
plot(timeD,MDRd(:,2),'linewidth',2,'color',[0.8 0.2 0.1])
    end

SpW=Data(Restrict(Spindles,Wake))/1e4;
RiW=Data(Restrict(Ripples,Wake))/1e4;
    if DeltaWave
DeW=Data(Restrict(Delta,Wake))/1e4;
subplot(4,7,23)
[C, B] = CrossCorr(SpW, DeW, 0.2, 50);
plot(B,C,'color',[0.2 0.2 0.2])
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
subplot(4,7,24)
[C, B] = CrossCorr(RiW, DeW, 0.2, 50);
plot(B,C,'color',[0.2 0.2 0.2])
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
    end
    subplot(4,7,25)
[C, B] = CrossCorr(SpW, RiW, 0.2, 50);
plot(B,C,'color',[0.2 0.2 0.2])
a=ylim;
hold on
line([0 0],[a(1) a(2)],'LineStyle','--','color','k')
subplot(4,7,26)
plot(timeS,MW(:,2),'color',[0.2 0.2 0.2])
hold on
[M,T]=PlotRipRaw(HRip,SpW,400);close;
TRS=[800/size(M,1):800/size(M,1):800]-400;
plot(TRS,M(:,2)-1000,'linewidth',2,'color','k');
subplot(4,7,27)
plot(timeR,MWR(:,2),'color',[0.2 0.2 0.2])
    if DeltaWave

subplot(4,7,28)
plot(timeD,MDWs(:,2),'color',[0.2 0.2 0.2])
hold on
plot(timeD,MDWd(:,2),'linewidth',2,'color',[0.2 0.2 0.2])
    end




saveFigure(f,strcat('SleepChecking-',struct),filename)
saveas(f,strcat(filename,'SleepChecking-',struct,'.fig'))
if DeltaWave
save(strcat(filename,'SleepInfo-',struct,'.mat'),'Ripples', 'Spindles','tDeltaT2','tDeltaP2');
else
save(strcat(filename,'SleepInfo-',struct,'.mat'),'Ripples', 'Spindles');
end

end