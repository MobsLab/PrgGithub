   


% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_00
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPre_01
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_00
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-CondWallShock_01
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_00
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_01
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_04
% cd /media/nas5/ProjetReversalBehavior/Data/M913/20190529/Reversal/ERC-Mouse-913-29052019-TestPost_05

% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPre_01
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPre_02
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_03
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-CondWallShock_04
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_03
% cd /media/nas5/Projeload behavResources PosMat mask Ratio_IMAonREAL FreezeEpoch MouseTemp frame_limitstReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_04
% cd /media/nas5/ProjetReversalBehavior/Data/M934/20190612/Reversal/ERC-Mouse-934-12062019-TestPost_05

% cd /media/nas5/ProjetReversalBehavior/Data/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_02
% cd /media/nas5/ProjetReversalBehavior/Data/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_03
% cd /media/nas5/ProjetReversalBehavior/Data/M935/20160613/ReversalControl/ERC-Mouse-935-13062019-CondWallShock_04





Temp_tail=Temp_tail-nanmedian(Temp_tail);
Temp_body=Temp_body-nanmedian(Temp_body);

% Temp_tail=Temp_tail*(frame_limits(2)-frame_limits(1))+frame_limits(1);
% Temp_body=Temp_body*(frame_limits(2)-frame_limits(1))+frame_limits(1);

Temp_tail(Temp_tail>15)=nan;
Temp_body(Temp_tail>15)=nan;
Temp_time(Temp_tail>15)=nan;
Temp_PosX(Temp_tail>15)=nan;
Temp_PosY(Temp_tail>15)=nan;

Temp_tail(Temp_body>15)=nan;
Temp_body(Temp_body>15)=nan;
Temp_time(Temp_body>15)=nan;
Temp_PosX(Temp_body>15)=nan;
Temp_PosY(Temp_body>15)=nan;

% TempOutput(isnan(ValuesInput))=[];
% ValuesInput(isnan(ValuesInput))=[];
% MouseTemp1 = (MouseTemp*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
% MouseTemp_InDegrees = interp1(ValuesIload behavResources PosMat mask Ratio_IMAonREAL FreezeEpoch MouseTemp frame_limitsnput,TempOutput, MouseTemp1(:,2));
    
figure, 
subplot(3,4,1:2), hold on, plot(Temp_time,Temp_body,'-','color',[0.7 0.7 0.7]), scatter(Temp_time,Temp_body,40,Temp_time,'filled')
plot(PosMat(PosMat(:,4)==1,1),-6+PosMat(PosMat(:,4)==1,4),'ro','markerfacecolor','r')
subplot(3,4,5:6), hold on, plot(Temp_time,Temp_tail,'k-'), scatter(Temp_time,Temp_tail,40,Temp_time,'filled')
plot(PosMat(PosMat(:,4)==1,1),-6+PosMat(PosMat(:,4)==1,4),'ro','markerfacecolor','r')
subplot(3,4,9:10), plot(Temp_time,Ratio_IMAonREAL*Temp_PosX,'r.-')
hold on, plot(Temp_time,Ratio_IMAonREAL*Temp_PosY,'b.-')
plot(PosMat(PosMat(:,4)==1,1),PosMat(PosMat(:,4)==1,4),'ro','markerfacecolor','r')
subplot(3,4,[3 4 7 8 11 12]), hold on, plot(Ratio_IMAonREAL*Temp_PosX,Ratio_IMAonREAL*Temp_PosY,'-','color',[0.7 0.7 0.7]), scatter(Ratio_IMAonREAL*Temp_PosX,Ratio_IMAonREAL*Temp_PosY,40,Temp_tail,'filled'), colorbar
plot(Ratio_IMAonREAL*PosMat(PosMat(:,4)==1,2),Ratio_IMAonREAL*PosMat(PosMat(:,4)==1,3),'r*','markersize',20)


clear all
figure
load('behavResources.mat')
load('ManualTemp.mat')

load('/home/mobsmorty/Dropbox/Kteam/IRCameraCalibration/CalibrationIR_August2018.mat');
TempOutput(isnan(ValuesInput))=[];
ValuesInput(isnan(ValuesInput))=[];
Temp_body = double(Temp_body)/256;
Temp_body1 = (Temp_body*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
Temp_body1 = naninterp(Temp_body1);
Temp_body_InDegrees = interp1(ValuesInput,TempOutput, Temp_body1);

Temp_tail = double(Temp_tail)/256;
Temp_tail1 = (Temp_tail*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
Temp_tail1 = naninterp(Temp_tail1);
Temp_tail_InDegrees = interp1(ValuesInput,TempOutput, Temp_tail1);


subplot(231)
plot(Temp_time,Temp_tail_InDegrees)
hold on
plot(Temp_time,Temp_body_InDegrees)
legend('tail','body','speed')
yyaxis right
plot(Range(Vtsd,'s'),Data(Vtsd))
%Creates the new mask
stats = regionprops(mask, 'Area');
tempmask=mask;
AimArea=stats.Area*FracArea;
ActArea=stats.Area;
while AimArea<ActArea
    tempmask=imerode(tempmask,strel('disk',1));
    stats = regionprops(tempmask, 'Area');
    ActArea=stats.Area;
end
aux=bwboundaries(tempmask);
new_mask=aux{1}./Ratio_IMAonREAL;
subplot(234)
BodyTemptsd = tsd(Temp_time*1e4,Temp_body_InDegrees');
TotEpoch = intervalSet(0,max(Range(BodyTemptsd)));
nhist({Data(Restrict(BodyTemptsd,FreezeEpoch)),Data(Restrict(BodyTemptsd,TotEpoch-FreezeEpoch))},'binfactor',7,'noerror')
legend('freeze','nofreeze')
xlabel('temp')

[xmin,xmax] = bounds(new_mask(:,2));
[ymin,ymax] = bounds(new_mask(:,1));
subplot(132)
plot(new_mask(:,2),new_mask(:,1),'k','LineWidth',2)
hold on
scatter(Temp_PosX,Temp_PosY,15,Temp_body_InDegrees,'filled')
title('body temp')
subplot(133)
plot(new_mask(:,2),new_mask(:,1),'k','LineWidth',2)
hold on
scatter(Temp_PosX,Temp_PosY,15,Temp_body_InDegrees,'filled')
title('tail temp')


