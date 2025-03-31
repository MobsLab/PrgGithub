clear all
close all
load('behavResources_SB.mat')
load('TailTemperatureCurve.mat')

Videotimes=Range(Behav.Xtsd);
VideoTimes=Videotimes(1:length(TemperatureCurve));
Behav.TailTemperatureTSD=tsd(VideoTimes,TemperatureCurve');

% afficher des lignes en pointillés au début de chaque période de freezing
%Start=Start(and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{1})).*(1.5e-3);
%hold on
%h = vline(Start,'g');

% Mean Temperature during shock zone freezing 
TempShockFreeze=mean(Data(Restrict(Behav.TailTemperatureTSD,and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{1}))));
plot(Data(Restrict(Behav.TailTemperatureTSD,and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{1}))))

hold on

% Mean Temperature during safe zone freezing 
TempSafeFreeze=mean(Data(Restrict(Behav.TailTemperatureTSD,and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{2}))));
plot(Data(Restrict(Behav.TailTemperatureTSD,and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{2}))));hold on

% Mean Temperature during freezing 
TempFreeze=mean(Data(Restrict(Behav.TailTemperatureTSD,Behav.FreezeAccEpoch)));
plot(Data(Restrict(Behav.TailTemperatureTSD,Behav.FreezeAccEpoch)))

TempShockZone=mean(Data(Restrict(Behav.TailTemperatureTSD,Behav.ZoneEpoch{1})));
TempSafeZone=mean(Data(Restrict(Behav.TailTemperatureTSD,Behav.ZoneEpoch{2})));
AvgTemp=mean(Data(Behav.TailTemperatureTSD));

TempResults.Names={'TempShockFreeze','TempSafeFreeze','TempFreeze','TempShockZone','TempSafeZone','AvgTemp'};
TempResults.Values=[TempShockFreeze,TempSafeFreeze,TempFreeze,TempShockZone,TempSafeZone,AvgTemp];
save('TailTemperatureCurve.mat','TempResults','-append');