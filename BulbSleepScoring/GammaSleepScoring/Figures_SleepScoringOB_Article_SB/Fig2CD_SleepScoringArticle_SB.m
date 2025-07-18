cd /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/
try
    filename;
catch
    filename=[pwd,'/'];
end

load(strcat(filename,'StateEpochSB'))

load(strcat(filename,'B_High_Spectrum.mat'));
sptsdB=tsd(Spectro{2}*1e4,Spectro{1});
fB=Spectro{3};
clear Spectro
load(strcat(filename,'H_Low_Spectrum.mat'))
sptsdH=tsd(Spectro{2}*1e4,Spectro{1});
fH=Spectro{3};
clear Spectro

try
    ghi_new=Restrict(smooth_ghi,PlotEp);
    theta_new=Restrict(smooth_Theta,PlotEp);
catch
    ghi_new=smooth_ghi;
    theta_new=smooth_Theta;   
end

%need to think about this
t=Range(theta_new);
ti=t(5:1200:end);
ghi_new=(Restrict(ghi_new,ts(ti)));
theta_new=(Restrict(theta_new,ts(ti)));

try
begin=Start(PlotEp)/1e4;
begin=begin(1);
endin=Stop(PlotEp)/1e4;
endin=endin(end);
catch
    begin=t(1)/1e4;
    endin=t(end)/1e4;
end




% HPC spectrum
h=figure;
set(h,'color',[1 1 1],'Position',[1 1 1600 600])
subplot(7,1,[1:2])
rg=Range(sptsdH,'s');rg=rg(1:50:end);
datH=Data(sptsdH);datH=datH(1:50:end,:);

imagesc(rg,fH,10*log10(datH')), axis xy, caxis([30 65]);
xlim([begin endin])
set(gca,'XTick',[],'TickLength',[0 0])

subplot(7,1,[3])
try
plot(Range(Restrict(theta_new,PlotEp),'s'),Data(Restrict(theta_new,PlotEp)),'linewidth',1,'color','k')
catch
plot(Range(theta_new,'s'),Data(theta_new),'linewidth',1,'color','k')    
end
xlim([begin endin]),set(gca,'XTick',[],'TickLength',[0 0])
ylim([0 15])

% OB spectrum
% h=figure;
% set(h,'color',[1 1 1],'Position',[1 1 1600 600])
subplot(7,1,[4:5])
datb=Data(sptsdB);
clear datbnew
rg=Range(sptsdB,'s');rg=rg(1:20:end);
datbnew=datb(1:20:end,:);

for k=1:size(datb,2)
    datbnew(:,k)=runmean(datbnew(:,k),2);
end
imagesc(rg(1:20:end),fB,10*log10(datbnew(1:20:end,:)')), axis xy, caxis([25 50]);
set(gca,'XTick',[],'TickLength',[0 0])
xlim([begin endin])

subplot(7,1,6)
try
plot(Range(Restrict(ghi_new,PlotEp),'s'),Data(Restrict(ghi_new,PlotEp)),'linewidth',1,'color','k')
catch
 plot(Range(ghi_new,'s'),Data(ghi_new),'linewidth',1,'color','k')   
end
xlim([begin endin]), ylim([0 3000])
set(gca,'XTick',[],'TickLength',[0 0])

subplot(7,1,7)

PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[1 1],[],1);
xlim([begin endin])
set(gca,'TickLength',[0 0],'XTick',[0:3600:25000],'XTickLabel',{'0','1','2','3','4','5','6'})
    set(gca,'ytick',[2:5])
    set(gca,'yticklabel',{'SWS','','REM','Wake'})
ylim([1 6])


figure
subplot(3,3,[2,3,5,6])
try
remtheta=(Restrict(theta_new,And(PlotEp,REMEpoch)));
catch
    remtheta=(Restrict(theta_new,REMEpoch));
end
ghi_new_r=Restrict(ghi_new,ts(Range(remtheta)));
plot(log(Data(ghi_new_r)),log(Data(remtheta)),'.','color',[1 0.2 0.2],'MarkerSize',1);
hold on
try
sleeptheta=(Restrict(theta_new,And(PlotEp,SWSEpoch)));
catch
    sleeptheta=(Restrict(theta_new,SWSEpoch));
end
ghi_new_s=Restrict(ghi_new,ts(Range(sleeptheta)));
plot(log(Data(ghi_new_s)),log(Data(sleeptheta)),'.','color',[0.4 0.5 1],'MarkerSize',1);
waketheta=(Restrict(theta_new,Wake));
ghi_new_w=Restrict(ghi_new,ts(Range(waketheta)));
plot(log(Data(ghi_new_w)),log(Data(waketheta)),'.','color',[0.6 0.6 0.6],'MarkerSize',1);
axphase=gca;
ys=get(axphase,'Ylim');
xs=get(axphase,'Xlim');
box on
set(gca,'XTick',[],'YTick',[])
subplot(3,3,[1,4])
[theText, rawN, x] =nhist(log(Data(Restrict(smooth_Theta,sleepper))),'maxx',max(log(Data(Restrict(smooth_Theta,sleepper)))),'noerror','xlabel','Theta power','ylabel',[]); axis xy
view(90,-90)
line([log(theta_thresh) log(theta_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',ys)

subplot(3,3,[8,9])
[theText, rawN, x] =nhist(log(Data(smooth_ghi)),'maxx',max(log(Data(smooth_ghi))),'noerror','xlabel','Gamma power','ylabel',[]);
line([log(gamma_thresh) log(gamma_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',xs)

