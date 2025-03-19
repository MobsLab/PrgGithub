function [REMEpoch,SWSEpoch,wakeper,REMEpoch1,SWSEpoch1,Wake1,smooth_ghi]=FindBehavEpochsDiffDaysNoPeakAlign(mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename,gamma_thresh_temp,theta_thresh_temp,fignum)
cd(filename)
load('StateEpochSB.mat')
TotNoiseEpoch=or(NoiseEpoch,GndNoiseEpoch);
try
    TotNoiseEpoch=or(TotNoiseEpoch,WeirdNoiseEpoch)
end
r=Range(smooth_ghi);
TotalEpoch=intervalSet(0*1e4,r(end));
TotalEpoch=TotalEpoch-TotNoiseEpoch;
SWSEpoch1=SWSEpoch-TotNoiseEpoch;
REMEpoch1=REMEpoch-TotNoiseEpoch;
Wake1=wakeper-TotNoiseEpoch;

clear SWSEpoch REMEpoch wakeper
smooth_ghi=Restrict(smooth_ghi,TotalEpoch);
ghi_new=Restrict(smooth_ghi,TotalEpoch);
theta_new=Restrict(smooth_Theta,TotalEpoch);
gamma_thresh_temp=gamma_thresh_temp;
theta_thresh_temp=theta_thresh_temp;

clear sleepper
sleepper=thresholdIntervals(smooth_ghi,gamma_thresh_temp,'Direction','Below');
sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
sleepper=dropShortIntervals(sleepper,mindur*1e4);
clear ThetaEpoch
ThetaEpoch=thresholdIntervals(smooth_Theta,theta_thresh_temp,'Direction','Above');
ThetaEpoch=mergeCloseIntervals(ThetaEpoch,ThetaI(1)*1E4);
ThetaEpoch=dropShortIntervals(ThetaEpoch,ThetaI(2)*1E4);

% We presume that after a REM phase (ie theta during sleep), the end of the
% sleep phase is aligned with the end of REM
tep=Start(ThetaEpoch);
tep2=Stop(ThetaEpoch);
sep=Stop(sleepper);
for t=1:length(Start(ThetaEpoch))
    t1=ts(tep(t));
    t2=Restrict(t1,sleepper);
    if length(t2)~=0
        t3=tep2(t);
        [dur,num]=min(abs(sep-t3));
        if dur<5*1e4
            sep(num)=t3;
        end
    end
end
str=Start(sleepper);
str((Start(sleepper)<sep==0))=[];
sep((Start(sleepper)<sep==0))=[];
sleepper=intervalSet(str,sep);

sep=Start(sleepper);
for t=1:length(Start(ThetaEpoch))
    t1=ts(tep2(t));
    t2=Restrict(t1,sleepper);
    if length(t2)~=0
        t3=tep2(t);
        [dur,num]=min(abs(sep-t3));
        if dur<5*1e4
            sep(num)=t3;
        end
    end
end
str=Stop(sleepper);
str((Stop(sleepper)>sep==0))=[];
sep((Stop(sleepper)>sep==0))=[];
sleepper=intervalSet(sep,Stop(sleepper));

wakeper=TotalEpoch-sleepper;
wakeper=dropShortIntervals(wakeper,mindur*1e4); % wake per near noise
TotSleep=sleepper;
TotWake=wakeper;
TotSleep=CleanUpEpoch(TotSleep);
TotWake=CleanUpEpoch(TotWake);
REMEpoch=and(sleepper,ThetaEpoch);
SWSEpoch=sleepper-REMEpoch;
SWSEpoch=CleanUpEpoch(SWSEpoch);
REMEpoch=CleanUpEpoch(REMEpoch);

%
% try
% REMEpoch=REMEpoch-TotalNoiseEpoch;
% end
% try
% SWSEpoch=SWSEpoch-TotalNoiseEpoch;
% end


%we're going to presume that the noise during waking is waking so as to
%find microarousals etc
noiswakeper=TotalEpoch-sleepper;
noiswakeper=CleanUpEpoch(noiswakeper);
noiswakeper=dropShortIntervals(noiswakeper,mindur*1e4); % wake per near noise

MicroWake=SandwichEpoch(noiswakeper,sleepper,mw_dur*1e4,sl_dur*1e4);
MicroSleep=SandwichEpoch(sleepper,noiswakeper,ms_dur*1e4,wa_dur*1e4);
MicroWake=CleanUpEpoch(MicroWake);
MicroSleep=CleanUpEpoch(MicroSleep);

noiswakeper=noiswakeper-MicroWake;
Sleep=sleepper-MicroSleep;
noiswakeper=CleanUpEpoch(noiswakeper);
sleepper=CleanUpEpoch(sleepper);

strWake=getshortintervals(noiswakeper,mw_dur*1e4);
strSleep=getshortintervals(sleepper,ms_dur*1e4);
strWake=CleanUpEpoch(strWake);
strSleep=CleanUpEpoch(strSleep);

MicroWake=MicroWake-NoiseEpoch-GndNoiseEpoch;

% modif KB-------------------
try
    MicroWake=MicroWake-TotalNoiseEpoch;
end
% modif KB-------------------


strSleep=CleanUpEpoch(strSleep);
MicroWake=CleanUpEpoch(MicroWake);
strWake=strWake-NoiseEpoch; strWake=CleanUpEpoch(strWake);
strWake=strWake-GndNoiseEpoch; strWake=CleanUpEpoch(strWake);

% modif KB-------------------
try
    strWake=strWake-TotalNoiseEpoch; strWake=CleanUpEpoch(strWake);
end
% modif KB-------------------

Wake=wakeper-strWake; Wake=CleanUpEpoch(Wake);
Wake=Wake-MicroWake; Wake=CleanUpEpoch(Wake);
Sleep=Sleep-strSleep; Sleep=CleanUpEpoch(Sleep);
[aft_cell,bef_cell]=transEpoch(wakeper,REMEpoch);

disp( ' ')
disp(strcat('wake to REM transitions :',num2str(size(Start(aft_cell{1,2}),1))))


% modif KB-------------------
try
    [aft_cell,bef_cell]=transEpoch(TotalNoiseEpoch,Sleep);
catch
    [aft_cell,bef_cell]=transEpoch(or(NoiseEpoch,GndNoiseEpoch),Sleep);
    disp('**********  not all Noise Epoch ************')
end
% modif KB-------------------



nsleep=and(aft_cell{1,2},bef_cell{1,2});
disp(strcat('noise periods during sleep :',num2str(size(Start(nsleep)/1e4,1))))
disp( ' ')

figurerecap=figure;
t=Range(theta_new);
ti=t(5:1200:end);
ghi_new=(Restrict(ghi_new,ts(ti)));
theta_new=(Restrict(theta_new,ts(ti)));
subplot(3,3,[2,3,5,6])
remtheta=(Restrict(theta_new,REMEpoch));
ghi_new_r=Restrict(ghi_new,ts(Range(remtheta)));
plot(log(Data(ghi_new_r)),log(Data(remtheta)),'.','color',[1 0.2 0.2],'MarkerSize',1);
hold on
sleeptheta=(Restrict(theta_new,SWSEpoch));
ghi_new_s=Restrict(ghi_new,ts(Range(sleeptheta)));
plot(log(Data(ghi_new_s)),log(Data(sleeptheta)),'.','color',[0.4 0.5 1],'MarkerSize',1);
waketheta=(Restrict(theta_new,Wake));
ghi_new_w=Restrict(ghi_new,ts(Range(waketheta)));
plot(log(Data(ghi_new_w)),log(Data(waketheta)),'.','color',[0.6 0.6 0.6],'MarkerSize',1);

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
[theText, rawN, x] =nhist(log(Data(smooth_ghi)),'maxx',max(log(Data(smooth_ghi))),'noerror','xlabel','Gamma power','ylabel',[]);
line([log(gamma_thresh) log(gamma_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',xs)
subplot(3,3,[1,4])
line([log(theta_thresh_temp) log(theta_thresh_temp)],[0 max(rawN)],'linewidth',4,'color','b')
subplot(3,3,[8,9])
line([log(gamma_thresh_temp) log(gamma_thresh_temp)],[0 max(rawN)],'linewidth',4,'color','b')

saveas(figurerecap,['CompareThreshNightDay' ,num2str(fignum),'.fig'])
saveas(figurerecap,['CompareThreshNightDay' ,num2str(fignum),'.png'])

close all
end