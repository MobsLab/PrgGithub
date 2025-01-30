figname=figure;set(figname,'color',[1 1 1],'Position',[1 1 1600 600])

load('StateEpochSB')
ghi_new=Restrict(smooth_ghi,PlotEp);
theta_new=Restrict(smooth_Theta,PlotEp);
%need to think about this
t=Range(theta_new);
ti=t(5:600:end);
ghi_new=(Restrict(ghi_new,ts(ti)));
theta_new=(Restrict(theta_new,ts(ti)));
begin=Start(PlotEp)/1e4;
begin=begin(1);
endin=Stop(PlotEp)/1e4;
endin=endin(end);
subplot(6,12,[22:24,34:36,46:48])
remtheta=(Restrict(theta_new,And(PlotEp,REMEpoch)));
ghi_new_r=Restrict(ghi_new,ts(Range(remtheta)));
plot(log(Data(ghi_new_r)),log(Data(remtheta)),'.','color',[1 0.2 0.2],'MarkerSize',1);
hold on
sleeptheta=(Restrict(theta_new,And(PlotEp,SWSEpoch)));
ghi_new_s=Restrict(ghi_new,ts(Range(sleeptheta)))
plot(log(Data(ghi_new_s)),log(Data(sleeptheta)),'.','color',[0.4 0.5 1],'MarkerSize',1);
waketheta=(Restrict(theta_new,Wake));
ghi_new_w=Restrict(ghi_new,ts(Range(waketheta)));
plot(log(Data(ghi_new_w)),log(Data(waketheta)),'.','color',[0.6 0.6 0.6],'MarkerSize',1);
legend('REM','SWS','Wake')
l=findobj(gcf,'tag','legend')
a=get(l,'children');
set(a(1),'markersize',20); % This line changes the legend marker size
set(a(4),'markersize',20); % This line changes the legend marker size
set(a(7),'markersize',20); % This line changes the legend marker size
axphase=gca;
ys=get(axphase,'Ylim');
xs=get(axphase,'Xlim');
box on
set(gca,'XTick',[],'YTick',[])
title('gamma scoring')
subplot(6,12,[21,33,45])
[theText, rawN, x] =nhist(log(Data(Restrict(smooth_Theta,sleepper))),'maxx',max(log(Data(Restrict(smooth_Theta,sleepper)))),'noerror','xlabel','Theta power','ylabel',[]); axis xy
view(90,-90)
line([log(theta_thresh) log(theta_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',ys)
subplot(6,12,[58:60])
[theText, rawN, x] =nhist(log(Data(smooth_ghi)),'maxx',max(log(Data(smooth_ghi))),'noerror','xlabel','Gamma power','ylabel',[]);
line([log(gamma_thresh) log(gamma_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',xs)
load('StateEpoch.mat')
subplot(6,12,[22:24,34:36,46:48]-8)
remtheta=(Restrict(theta_new,And(PlotEp,REMEpoch)));
ghi_new_r=Restrict(ghi_new,ts(Range(remtheta)));
plot(log(Data(ghi_new_r)),log(Data(remtheta)),'.','color',[1 0.2 0.2],'MarkerSize',1);
hold on
sleeptheta=(Restrict(theta_new,And(PlotEp,SWSEpoch)));
ghi_new_s=Restrict(ghi_new,ts(Range(sleeptheta)))
plot(log(Data(ghi_new_s)),log(Data(sleeptheta)),'.','color',[0.4 0.5 1],'MarkerSize',1);
waketheta=(Restrict(theta_new,MovEpoch));
ghi_new_w=Restrict(ghi_new,ts(Range(waketheta)));
plot(log(Data(ghi_new_w)),log(Data(waketheta)),'.','color',[0.6 0.6 0.6],'MarkerSize',1);
legend('REM','SWS','Wake')
l=findobj(gcf,'tag','legend')
a=get(l,'children');
set(a{1}(1),'markersize',20); % This line changes the legend marker size
set(a{1}(4),'markersize',20); % This line changes the legend marker size
set(a{1}(7),'markersize',20); % This line changes the legend marker size
axphase=gca;
ys=get(axphase,'Ylim');
xs=get(axphase,'Xlim');
box on
set(gca,'XTick',[],'YTick',[])
title('Mvmt scoring')
subplot(6,12,[21,33,45]-8)
[theText, rawN, x] =nhist(log(Data(Restrict(smooth_Theta,sleepper))),'maxx',max(log(Data(Restrict(smooth_Theta,sleepper)))),'noerror','xlabel','Theta power','ylabel',[]); axis xy
view(90,-90)
line([log(theta_thresh) log(theta_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',ys)
subplot(6,12,[58:60]-8)
[theText, rawN, x] =nhist(log(Data(smooth_ghi)),'maxx',max(log(Data(smooth_ghi))),'noerror','xlabel','Gamma power','ylabel',[]);
line([log(gamma_thresh) log(gamma_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',xs)
subplot(6,12,[22:24,34:36,46:48]-5)
[Y,X]=hist(log(Data(ghi_new_r)),100);
plot(X,Y/sum(Y),'linewidth',3)
title('Distrib gamma in REM')
name=cd;
saveFigure(figname,[name(end-21:end) 'CompScoring'],'/home/vador/Dropbox/MOBS_workingON/Sophie/SleepScoringComp/')
close all
