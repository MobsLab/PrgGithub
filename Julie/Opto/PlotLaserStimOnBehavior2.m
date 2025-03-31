% similar to PlotLaserStimOnBehavior (07.07.2016) but for mouse 367 and 363
% 17.08.016

% /media/DataMobs31/OPTO_CHR2_DATA/behavior_matlab/FEAR-Mouse-367-17072016-01-EXT-24-laser10Hz
th_immob=1; % default 1
thtps_immob=2;

% ouvrir FigBilan.fig, 1er subplot
set(gcf,'Position',[1987         368        1768         564])
ylim([-3 40])
load Behavior.mat

% load TTL qui contient les CS- (valeur 3) et les CS+ (valeur 4) 

%line([TTL2(TTL2(:,2)==3,1) TTL2(TTL2(:,2)==3,1)+5],zeros(size(TTL2(TTL2(:,2)==3,:))),'Color','g','LineWidth',3)
%line([TTL(TTL(:,2)==4,1) TTL(TTL(:,2)==4,1)+5],zeros(size(TTL(TTL(:,2)==4,:))),'Color','r','LineWidth',3)
%line([TTL(TTL(:,2)==6,1) TTL(TTL(:,2)==7,1)],-1*ones(size(TTL(TTL(:,2)==6,:))),'Color','b','LineWidth',3, 'LineStyle','-')

%plot([TTL2(TTL2(:,2)==3,1) TTL2(TTL2(:,2)==3,1)+5],zeros(size(TTL2(TTL2(:,2)==3,:))),'Color','k','LineWidth',3)
%plot([TTL(TTL(:,2)==4,1) TTL(TTL(:,2)==4,1)+5],zeros(size(TTL(TTL(:,2)==4,:))),'Color','r','LineWidth',3)

CSminus=TTL(:,2)==4;
CSplus=TTL(:,2)==3;
plot([TTL(CSminus,1) TTL(CSminus,1)+1],-1*ones(size(CSminus,2),2),'Color','k','LineWidth',3)
plot([TTL(CSplus,1) TTL(CSplus,1)+1],-1*ones(size(CSplus,2),2),'Color','r','LineWidth',3)
CSminusInt=intervalSet(TTL(CSminus,1)*1E4, (TTL(CSminus,1)+60)*1E4);
CSplusInt=intervalSet(TTL(CSplus,1)*1E4, (TTL(CSplus,1)+60)*1E4);

% plot les stim laser
StartStimON=TTL(:,2)==6;
StartEndON=TTL(:,2)==7;
b= TTL(StartEndON,1);
a=TTL(StartStimON,1);
laserON=intervalSet(a*1E4,b*1E4);
laserOFF_CSminus_ctrlPer=diff(CSminusInt,laserON);
laserOFF_CSplus_ctrlPer=diff(CSplusInt,laserON);
% plot([TTL(TTL(:,2)==6,1) TTL(TTL(:,2)==7,1)],-1*ones(size(TTL(TTL(:,2)==6,:))),'Color','b','LineWidth',3, 'LineStyle','-')
% 
% plot([TTL(StartStimON,1) TTL(StartEndON,1)],zeros(size(TTL(StartStimON,:))),'Color','b','LineWidth',3, 'LineStyle','-')
% plot([TTL(StartStimON,1) TTL(StartEndON,1)],zeros(size(TTL(StartStimON,:))),'*b','LineWidth',3, 'LineStyle','-')

for k=1:length(a)
    %plot([TTL(StartStimON(k),1) TTL(StartEndON(k),1)],[0 0],':r','LineWidth',3, 'LineStyle',':')
    %line([TTL(StartStimON(k),1) TTL(StartEndON(k),1)],[10 10],'Color','r','LineWidth',3, 'LineStyle',':')
     line([a(k) b(k)],[-2 -2],'Color','k','LineWidth',3, 'LineStyle',':')
end
title FEAR-Mouse-363-17072016-01-EXT-24-laser10Hz
title FEAR-Mouse-363-18072016-01-EXT-48-laser10Hz
title FEAR-Mouse-363-19072016-01-EXT-72-laser4Hz

title FEAR-Mouse-367-19072016-01-EXT-72-laser4Hz
title FEAR-Mouse-367-17072016-01-EXT-24-laser10Hz
title FEAR-Mouse-367-18072016-01-EXT48
saveas(gcf,'FigBilan_mep.fig')
saveas(gcf,'FigBilan_mep.png')