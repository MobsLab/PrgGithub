%% Figrues used for final Fig5

clear all, close all
% Look at Freezing-related activity
m=1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SoundTest/';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160810/Sleep/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SoundTest/';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160810/Sleep/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_SoundTest/';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160818/Sleep/';
m=m+1;
Filename{m,1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SoundTest/';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160818/Sleep/';


for mm = 1 :4
    cd(Filename{mm,1})
load('behavResources_SB.mat')
CSMoins_Per = intervalSet(TTLInfo.CSMoinsTimes,TTLInfo.CSMoinsTimes+30*1e4);
CSPlus_Per = intervalSet(TTLInfo.CSPlusTimes,TTLInfo.CSPlusTimes+30*1e4);

Fz_CSMoins(mm) = length(Data(Restrict(Behav.Xtsd,and(Behav.FreezeEpoch,CSMoins_Per))))./...
    length(Data(Restrict(Behav.Xtsd,CSMoins_Per)));
Fz_CSPlus(mm) = length(Data(Restrict(Behav.Xtsd,and(Behav.FreezeEpoch,CSPlus_Per))))./...
    length(Data(Restrict(Behav.Xtsd,CSPlus_Per)));

end

nanmean(Fz_CSMoins), stdError(Fz_CSMoins)
nanmean(Fz_CSPlus), stdError(Fz_CSPlus)