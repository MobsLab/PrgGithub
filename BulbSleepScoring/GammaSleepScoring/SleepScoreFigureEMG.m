function SleepScoreFigureEMG(filename,PlotEp)

try
    filename;
catch
    filename=[pwd,'/'];
end

load(strcat(filename,'StateEpochEMGSB'))

load(strcat(filename,'B_High_Spectrum.mat'));
sptsdB=tsd(Spectro{2}*1e4,Spectro{1});
fB=Spectro{3};
clear Spectro
load(strcat(filename,'H_Low_Spectrum.mat'))
sptsdH=tsd(Spectro{2}*1e4,Spectro{1});
fH=Spectro{3};
clear Spectro

try
    ghi_new=Restrict(EMGData,PlotEp);
    theta_new=Restrict(smooth_Theta,PlotEp);
catch
    ghi_new=EMGData;
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



h=figure;

% phase space
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

% had to change the code to accomodate new functions in Matlab 2016 - SB
% 09/2016
try
    legend('REM','SWS','Wake')
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
    [a,icons,plots,legend_text]=legend('REM','SWS','Wake');
    set(icons(5),'MarkerSize',20)
    set(icons(7),'MarkerSize',20)
    set(icons(9),'MarkerSize',20)
end
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
[theText, rawN, x] =nhist(log(Data(EMGData)),'maxx',max(log(Data(EMGData))),'noerror','xlabel','Gamma power','ylabel',[]);
line([log(EMG_thresh) log(EMG_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',xs)
try
saveFigure(h,'SleepScoringEMG',filename)
catch
    saveFigure(h.Number,'SleepScoringEMG',filename)
end

[aft_cell,bef_cell]=transEpoch(wakeper,REMEpoch);

disp( ' ')
disp(strcat('wake to REM transitions :',num2str(size(Start(aft_cell{1,2}),1))))
disp( ' ')

end