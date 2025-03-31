clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_SleepPost_PreDrug
disp('load scoring')
load('StateEpochSB.mat')
TotalEpoch=intervalSet(0*1e4,max(Range(smooth_ghi)));
TotalEpoch = TotalEpoch-TotalNoiseEpoch;
ghi_new=Restrict(smooth_ghi,TotalEpoch);
theta_new=Restrict(smooth_Theta,TotalEpoch);

t=Range(theta_new);
ti=t(5:500:end);
ghi_new=(Restrict(ghi_new,ts(ti)));
theta_new=(Restrict(theta_new,ts(ti)));
begin=Start(TotalEpoch)/1e4;
begin=begin(1);
endin=Stop(TotalEpoch)/1e4;
endin=endin(end);

disp('load spectra')
load('B_High_Spectrum.mat')
Spectro_B = Spectro;
sptsdB=tsd(Spectro_B{2}*1e4,Spectro_B{1});
fB=Spectro{3};
load(['LFPData/LFP',num2str(6),'.mat'])
LFPB1 = FilterLFP(LFP,[1 200],1024);
load(['LFPData/LFP',num2str(7),'.mat'])
LFPB2 = FilterLFP(LFP,[1 200],1024);
load('HDeep_Low_Spectrum.mat')
Spectro_H = Spectro;
sptsdH=tsd(Spectro_H{2}*1e4,Spectro_H{1});
fH=Spectro{3};
load(['LFPData/LFP',num2str(3),'.mat'])
LFPH1 = FilterLFP(LFP,[1 200],1024);
load(['LFPData/LFP',num2str(0),'.mat'])
LFPH2 = FilterLFP(LFP,[1 200],1024);
load(['LFPData/LFP',num2str(2),'.mat'])
LFPH3 = FilterLFP(LFP,[1 200],1024);
load('LFPData/LFP27.mat')
LFPE = FilterLFP(LFP,[1 500],1024);
load('LFPData/LFP8.mat')
LFPP1 = FilterLFP(LFP,[1 200],1024);
load('LFPData/LFP10.mat')
LFPP2 = FilterLFP(LFP,[1 200],1024);

figure
PS = subplot(2,5,[1,2,6,7]);
PS.Position = [0.05 0.11 0.35 0.81]
try
    remtheta=(Restrict(theta_new,And(PlotEp,REMEpoch)));
catch
    remtheta=(Restrict(theta_new,REMEpoch));
end
ghi_new_r=Restrict(ghi_new,ts(Range(remtheta)));
plot(log(Data(ghi_new_r)),log(Data(remtheta)),'.','color',[1 0.2 0.2],'MarkerSize',3);
hold on
try
    sleeptheta=(Restrict(theta_new,And(PlotEp,SWSEpoch)));
catch
    sleeptheta=(Restrict(theta_new,SWSEpoch));
end
ghi_new_s=Restrict(ghi_new,ts(Range(sleeptheta)));
plot(log(Data(ghi_new_s)),log(Data(sleeptheta)),'.','color',[0.4 0.5 1],'MarkerSize',3);
waketheta=(Restrict(theta_new,Wake));
ghi_new_w=Restrict(ghi_new,ts(Range(waketheta)));
plot(log(Data(ghi_new_w)),log(Data(waketheta)),'.','color',[0.6 0.6 0.6],'MarkerSize',3);
Worm = plot(log(Data(Restrict(ghi_new,intervalSet(5*1e4,15*1e4)))),log(Data(Restrict(theta_new,intervalSet(5*1e4,15*1e4)))),'linewidth',2,'color','k');

try
    legend('REM','NREM','Wake')
    l=findobj(gcf,'tag','legend');
    a=get(l,'children');
    try
        set(a(1),'markersize',20); % This line changes the legend marker size
        set(a(4),'markersize',20); % This line changes the legend marker size
        set(a(7),'markersize',20); % This line changes the legend marker size
    catch
        set(a(5),'markersize',20); % This line changes the legend marker size
        set(a(8),'markersize',20); % This line changes the legend marker size
        set(a(11),'markersize',20); % This line changes the legend marker size
    end
catch
    [a,icons,plots,legend_text]=legend('REM','NREM','Wake');
    set(icons(5),'MarkerSize',20)
    set(icons(7),'MarkerSize',20)
    set(icons(9),'MarkerSize',20)
end
xlabel('OB Gamma Power')
ylabel('HPC theta / delta ratio')
set(gca,'FontSize',12)

SB{1} = subplot(6,5,[3,4,5,8,9,10]);
SB{1}.Position = [0.45 0.55 0.5 0.3];
plot(Range(LFPE,'s'),Data(LFPE)+1700,'k','color',[0.6 0 0])
hold on
plot(Range(LFPP1,'s'),Data(LFPP1)*2-4000,'color',[1 0.6 0.2])
plot(Range(LFPP2,'s'),Data(LFPP2)*2-7000,'color',[0.8 0.4 0.1])
% plot(tDelta/1e4,-4000,'r*')

plot(Range(LFPH1,'s'),Data(LFPH1)*1.5-15000,'color',[0.2 0.8 0.8])
plot(Range(LFPH1,'s'),Data(LFPH2)*1.5-19000,'color',[0.2 0.8 0.8])
plot(Range(LFPH1,'s'),Data(LFPH3)*1.5-24000,'color',[0.2 0.8 0.8])

plot(Range(LFPH1,'s'),Data(LFPB1)*1.5-37000,'color',[0 0 0.8])
plot(Range(LFPH1,'s'),Data(LFPB2)*1.5-43000,'color',[0 0 0.8])

FrameDur = line([0+1.3 0+1.8],[-55500 -55500],'color','k','linewidth',3);
FrameDur_txt = text(0+1.45,-52500,'500ms');
set(gca,'XTick',[],'YTick',[-40000 -22000 -6500 1500],'YTickLabel',{'OB','HPC','PFC','EKG'});
ylim([-59000 9000])
set(gca,'FontSize',14)

SB{2} = subplot(6,5,[13,14,15,18,19,20]);
SB{2}.Position = [0.45 0.35 0.5 0.22];
try
    datb=Data(sptsdB);
    for k=1:size(datb,2)
        datbnew(:,k)=runmean(datb(:,k),100);
    end
    imagesc(Range(sptsdB,'s'),fB,10*log10(datbnew')), axis xy, %caxis([25 50]);
    hold on
    line([begin endin],[94 94],'linewidth',10,'color','w')
    sleepstart=Start(REMEpoch);
    sleepstop=Stop(REMEpoch);
    for k=1:length(sleepstart)
        line([sleepstart(k)/1e4 sleepstop(k)/1e4],[94 94],'color',[1 0.2 0.2],'linewidth',5);
    end
    sleepstart=Start(SWSEpoch);
    sleepstop=Stop(SWSEpoch);
    for k=1:length(sleepstart)
        line([sleepstart(k)/1e4 sleepstop(k)/1e4],[94 94],'color',[0.4 0.5 1],'linewidth',5);
    end
    sleepstart=Start(Wake);
    sleepstop=Stop(Wake);
    for k=1:length(sleepstart)
        line([sleepstart(k)/1e4 sleepstop(k)/1e4],[94 94],'color',[0.6 0.6 0.6],'linewidth',5);
    end
catch
    title('No High OB spectrum')
end
ylabel('Frequency (Hz)')
clim([26 54])
yyaxis right
plot(Range(smooth_ghi,'s'),Data(smooth_ghi),'k','linewidth',2)
ylim([0 5000])
GammaLine1 = line([1 1],ylim,'linewidth',2,'color','k');
GammaLine2 = line([10 10],ylim,'linewidth',2,'color','k');
line(xlim,[1 1]*gamma_thresh,'linewidth',2,'color','r')
ylabel('Gamma power')
xlabel('Time (s)')
set(gca,'FontSize',12)


% SB{3} = subplot(6,5,[18,19,20]);
% SB{3}.Position = [0.45 0.31 0.5 0.13];
% hold on
% plot(Range(LFPH1,'s'),Data(LFPH1),'k')
% plot(Range(LFPH1,'s'),Data(LFPH2)-8000,'k')
% plot(Range(LFPH1,'s'),Data(LFPH3)-16000,'k')
% set(gca,'XTick',[],'YTick',[])
% title('HPC')
% ylim([-20000 20000])
% 
SB{4} = subplot(6,5,[23,24,25,28,29,30]);
SB{4}.Position = [0.45 0.08 0.5 0.22];
imagesc(Range(sptsdH,'s'),fH,10*log10(Data(sptsdH))'), axis xy, %caxis([20 65]);
hold on
line([begin endin],[19 19],'linewidth',10,'color','w')
sleepstart=Start(REMEpoch);
sleepstop=Stop(REMEpoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[19 19],'color',[1 0.2 0.2],'linewidth',5);
end
sleepstart=Start(SWSEpoch);
sleepstop=Stop(SWSEpoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[19 19],'color',[0.4 0.5 1],'linewidth',5);
end
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[19 19],'color',[0.6 0.6 0.6],'linewidth',5);
end
clim([34 62])
ylabel('Frequency (Hz)')
ThetaLine1 = line([1 1],ylim,'linewidth',2,'color','k');
ThetaLine2 = line([10 10],ylim,'linewidth',2,'color','k');
yyaxis right
plot(Range(smooth_Theta,'s'),Data(smooth_Theta),'k','linewidth',2)
ylim([0 30])
line(xlim,[1 1]*theta_thresh,'linewidth',2,'color','r')
ylim([0 35])
ylabel('Theta/Delta Ratio')
xlabel('Time (s)')
set(gca,'FontSize',12)



writerObj = VideoWriter(['TestSleepScoringVideo_VFinFin']);
writerObj.FrameRate = 5;
writerObj.Quality = 20;

open(writerObj);

State= {'NREM','REM','Wake'};
for k = 1 :2: 1750
    CentreValue = 500+k;
    
    set(gcf,'CurrentAxes',PS)
    set(Worm,'XData',runmean(log(Data(Restrict(ghi_new,intervalSet((CentreValue-5)*1e4,(CentreValue+5)*1e4)))),3),...
        'YData',runmean(log(Data(Restrict(theta_new,intervalSet((CentreValue-5)*1e4,(CentreValue+5)*1e4)))),3));
    
    LitEpoch = intervalSet((CentreValue-5)*1e4,(CentreValue+5)*1e4);
    SWS_overlap = sum(Stop(and(LitEpoch,SWSEpoch))-Start(and(LitEpoch,SWSEpoch)));
    if isempty(SWS_overlap), SWS_overlap = 0; end
    REM_overlap = sum(Stop(and(LitEpoch,REMEpoch))-Start(and(LitEpoch,REMEpoch)));
    if isempty(REM_overlap), REM_overlap = 0; end
    Wake_overlap = sum(Stop(and(LitEpoch,Wake))-Start(and(LitEpoch,Wake)));
    if isempty(Wake_overlap), Wake_overlap = 0; end
    [val,ind] = max([SWS_overlap,REM_overlap,Wake_overlap]);
    
    set(gcf,'CurrentAxes',SB{1})
    xlim([CentreValue-3 CentreValue+3])
    title(State{ind})
    FrameDur.XData = [CentreValue+1.3 CentreValue+1.8];
    FrameDur_txt.Position = [CentreValue+1.45 -52500 0];
    
    set(gcf,'CurrentAxes',SB{2})
    %     xlim([CentreValue-250 CentreValue+250])
    xlim([0 2250])
    set(GammaLine1,'XData',[CentreValue-2 CentreValue-2])
    set(GammaLine2,'XData',[CentreValue+2 CentreValue+2])
    
    
    %     set(gcf,'CurrentAxes',SB{3})
    %     xlim([CentreValue-2 CentreValue+2])
    
    set(gcf,'CurrentAxes',SB{4})
    %     xlim([CentreValue-250 CentreValue+250])
    xlim([0 2250])
    set(ThetaLine1,'XData',[CentreValue-2 CentreValue-2])
    set(ThetaLine2,'XData',[CentreValue+2 CentreValue+2])
%     pause(0)
        writeVideo(writerObj,getframe(3));
end

close(writerObj);

