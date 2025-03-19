% 14.02.2016
% code donné par Sophie pour récupéré l'information "temps des stim" pour
% les souris ayant subi la rampe sur une journée (stim à différentes
% fréquences pendant le sommeil - janvier 2017)

clear all


% FileName{1}='/media/DataMOBS59/OptoSleepStim/Mouse363/20161201';
% FileName{2}='/media/DataMOBS59/OptoSleepStim/Mouse363/20161201';
% FileName{3}='/media/DataMOBS59/OptoSleepStim/Mouse459/20161123';
% FileName{4}='/media/DataMOBS59/OptoSleepStim/Mouse458/20161117';
% FileName{5}='/media/DataMOBS59/OptoSleepStim/Mouse458/20161116';
% 
% 
% FileName{6}='/media/DataMOBS60/OptoSleepStim/Mouse465/20170126/Mouse465-OptoSleepstimramp_170126_082254';
% FileName{7}='/media/DataMOBS60/OptoSleepStim/Mouse465/20170127/Mouse465-OptoSleepstimramp_170127_084632';
% 
% 
% FileName{8}='/media/MOBS67/Mouse466/20170130';
% FileName{9}='/media/MOBS67/Mouse466/20170131/Mouse466OptoRamp_170131_090353';

% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';

FileName={
'/media/mobsrick/DataMOBs71/Mouse-538/06072017_SleepStim/FEAR-Mouse-538-06072017';
'/media/mobsrick/DataMOBs71/Mouse-538/07072017_SleepStim/FEAR-Mouse-538-07072017'
};

for mm=1:length(FileName)
    mm
    clear StimInfo
    cd(FileName{mm})
    load('LFPData/DigInfo4.mat')
    LaserOn=thresholdIntervals(DigTSD,0.9,'Direction','Above');
    LaserOn=mergeCloseIntervals(LaserOn,5*1e4);
    StimInfo.StartTime=Start(LaserOn,'s');
    StimInfo.StopTime=Stop(LaserOn,'s');
    dt=median(diff(Range(DigTSD,'s')));

    for k=1:length(StimInfo.StartTime)
        dattemp=Data(Restrict(DigTSD,subset(LaserOn,k)));
        StimInfo.Freq(k,1)=round(1./(median(diff(find(diff(dattemp)==1)))*dt));
    end
    
    save('StimInfo.mat','StimInfo', 'LaserOn')
end

   