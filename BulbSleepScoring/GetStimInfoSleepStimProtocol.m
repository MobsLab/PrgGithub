clear all
FileName{1}='/media/bench/DataMOBS59/ProjectOBStim/Mouse459/20161124';
FileName{2}='/media/bench/DataMOBS59/ProjectOBStim/Mouse459/20161125';
FileName{3}='/media/bench/DataMOBS59/ProjectOBStim/Mouse458/20161119';
FileName{4}='/media/bench/DataMOBS59/ProjectOBStim/Mouse458/20161120';

for mm=1:4
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
    
    save('StimInfo.mat','StimInfo')
end

   