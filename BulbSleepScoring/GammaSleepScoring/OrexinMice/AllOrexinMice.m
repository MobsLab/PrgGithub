% List of mice to use for sleep scoring analysis (not all have EMG)
m=1;
filename2{m}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h/';
m=2;
filename2{m}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse570/20171019-BasalSleep-8-20h/';
m=3;
filename2{m}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse554/July 2017/BasalSleep_19072017/OREXIN-Mouse-554-19072017/';

% Some simple info
for file=1:m
    cd(filename2{file})
    load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake')
    TotalLength(file)=max([max(Stop(SWSEpoch)),max(Stop(REMEpoch)),max(Stop(Wake))]);
    SleepDur(file)=sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch));
end

