clear all

% /media/DataMOBsRAIDN/ProjectEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedSafe_PostDrug/Cond1/raw/FEAR-Mouse-688-09022018-CondWallSafe_02/
% /media/DataMOBsRAIDN/ProjectEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedSafe_PostDrug/Cond2/raw/FEAR-Mouse-688-09022018-CondWallSafe_03/
% 
% /media/DataMOBsRAIDN/ProjectEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedShock_PostDrug/Cond2/raw/FEAR-Mouse-688-09022018-CondWallShock_03/
% /media/DataMOBsRAIDN/ProjectEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedShock_PostDrug/Cond1/raw/FEAR-Mouse-688-09022018-CondWallShock_02/

%cd(['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedShock_PreDrug/Cond1/raw/FEAR-Mouse-739-29052018-CondWallShock_00/'])
% cd(['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_ExtinctionBlockedShock_PostDrug/Ext1/raw/FEAR-Mouse-739-29052018-BlockedWall_02/'])


CondSafe = [2 3]
figure
for i = 1:2
cd(['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedSafe_PostDrug/Cond',num2str(i),'/raw/FEAR-Mouse-688-09022018-CondWallSafe_0',num2str(CondSafe(i)),'/'])
subplot(2,2,i)
% try

load('ManualTemp.mat')
plot(Temp_time,(Temp_body_InDegrees))
hold on
plot(Temp_time,(Temp_eye_InDegrees))
plot(Temp_time,(Temp_tail_InDegrees))
ylim([24 38])
ylabel('temperature (°C)')
xlabel('time (s)')
% end

Temp_body_safe(i,:)= interp1(Temp_time,naninterp(Temp_body_InDegrees),[5:10:300]);
Temp_tail_safe(i,:)= interp1(Temp_time,naninterp(Temp_tail_InDegrees),[5:10:300]);
Temp_eye_safe(i,:)= interp1(Temp_time,naninterp(Temp_eye_InDegrees),[5:10:300]);
load('behavResources.mat')
Numer = sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2);
Denom = diff(Range(Xtsd,'s'));

tps = Range(Xtsd);
tps = tps(1:end-1);
Vtsd = tsd(tps,Numer./Denom);

% Qty_Of_Mov_mtzl(i,:) = interp1(Range(Imdifftsd,'s'),naninterp(Data(Imdifftsd)),[5:10:895]);
% Speed_mtzl(i,:) = interp1(Range(Vtsd,'s'),naninterp(Data(Vtsd)),[5:10:895]);
% Speed_Mov_mtzl(i,:) = interp1(Range(Vtsd,'s'),naninterp(Data(Vtsd)),[5:1:895]);
% Speed_Mov_mtzl(i,Speed_Mov_mtzl(i,:)<2)=NaN; 
% Speed_Mov_mtzl(i,Speed_Mov_mtzl(i,:)>40)=NaN; 

end




CondShock = [2 3]
for j = 1: length(CondShock)
    
cd(['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedShock_PostDrug/Cond',num2str(j),'/raw/FEAR-Mouse-688-09022018-CondWallShock_0',num2str(CondShock(j)),'/'])
subplot(2,2,j+2)
try

load('ManualTemp.mat')
plot(Temp_time,(Temp_body_InDegrees))
hold on
plot(Temp_time,(Temp_eye_InDegrees))
plot(Temp_time,(Temp_tail_InDegrees))
ylim([24 38])
ylabel('temperature (°C)')
xlabel('time (s)')
end

Temp_body_shock(j,:) = interp1(Temp_time,naninterp(Temp_body_InDegrees),[5:10:300]);
Temp_tail_shock(j,:) = interp1(Temp_time,naninterp(Temp_tail_InDegrees),[5:10:300]);
Temp_eye_shock(j,:) = interp1(Temp_time,naninterp(Temp_eye_InDegrees),[5:10:300]);
load('behavResources.mat')
Numer = sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2);
Denom = diff(Range(Xtsd,'s'));

tps = Range(Xtsd);
tps = tps(1:end-1);
Vtsd = tsd(tps,Numer./Denom);

% Qty_Of_Mov_mtzl(i,:) = interp1(Range(Imdifftsd,'s'),naninterp(Data(Imdifftsd)),[5:10:895]);
% Speed_mtzl(i,:) = interp1(Range(Vtsd,'s'),naninterp(Data(Vtsd)),[5:10:895]);
% Speed_Mov_mtzl(i,:) = interp1(Range(Vtsd,'s'),naninterp(Data(Vtsd)),[5:1:895]);
% Speed_Mov_mtzl(i,Speed_Mov_mtzl(i,:)<2)=NaN; 
% Speed_Mov_mtzl(i,Speed_Mov_mtzl(i,:)>40)=NaN; 

end






 
