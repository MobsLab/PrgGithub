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
    load('StateEpoch.mat','MovEpoch')
    StrtMovEpoch=Start(MovEpoch,'s');
    load('StateEpochSB.mat','Wake')
    StrtWake=Start(Wake,'s');
    
    for k=1:length(StimInfo.StartTime)
        dattemp=Data(Restrict(DigTSD,subset(LaserOn,k)));
        StimInfo.Freq(k,1)=round(1./(median(diff(find(diff(dattemp)==1)))*dt));
        NextMov=StrtMovEpoch-StimInfo.StartTime(k);
        NextMov(NextMov<0)=[];
        if isempty(NextMov)
            StimInfo.MovLatency(k,1)=NaN;
        else
            StimInfo.MovLatency(k,1)=min(NextMov);
        end
        
        NextMov=StrtWake-StimInfo.StartTime(k);
        NextMov(NextMov<0)=[];
        if isempty(NextMov)
            StimInfo.GammaLatency(k,1)=NaN;
        else
            StimInfo.GammaLatency(k,1)=min(NextMov);
        end
    end
    
    load('behavResources.mat')
    [M.Acc.F12Hz{mm},T.Acc.F12Hz{mm}]=PlotRipRaw(MovAcctsd,StimInfo.StartTime(StimInfo.Freq==12),500*1e3,1,0);
    [M.Acc.F62Hz{mm},T.Acc.F62Hz{mm}]=PlotRipRaw(MovAcctsd,StimInfo.StartTime(StimInfo.Freq==62),500*1e3,1,0);
    [M.Acc.F36Hz{mm},T.Acc.F36Hz{mm}]=PlotRipRaw(MovAcctsd,StimInfo.StartTime(StimInfo.Freq==36),500*1e3,1,0);
    
    load('H_Low_Spectrum.mat')
    HipSync=tsd(Spectro{2}*1e4,mean(Spectro{1}')');
    [M.Hip.F12Hz{mm},T.Hip.F12Hz{mm}]=PlotRipRaw(HipSync,StimInfo.StartTime(StimInfo.Freq==12),500*1e3,1,0);
    [M.Hip.F62Hz{mm},T.Hip.F62Hz{mm}]=PlotRipRaw(HipSync,StimInfo.StartTime(StimInfo.Freq==62),500*1e3,1,0);
    [M.Hip.F36Hz{mm},T.Hip.F36Hz{mm}]=PlotRipRaw(HipSync,StimInfo.StartTime(StimInfo.Freq==36),500*1e3,1,0);
    
    StimInfoKeep{mm}=StimInfo;
    
end

lat12=[];lat62=[];lat36=[];
for mm=1:4
   lat12=[lat12;StimInfoKeep{mm}.GammaLatency(StimInfoKeep{mm}.Freq==12)];
   lat62=[lat62;StimInfoKeep{mm}.GammaLatency(StimInfoKeep{mm}.Freq==62)];
   lat36=[lat36;StimInfoKeep{mm}.GammaLatency(StimInfoKeep{mm}.Freq==36)];
end

lat12(lat12>600)=[];
lat62(lat62>600)=[];
lat36(lat36>600)=[];


Acc12=[];Acc36=[];Acc62=[];
Hip12=[];Hip36=[];Hip62=[];
for mm=1:4
  Acc12=[Acc12;T.Acc.F12Hz{mm}];
  Acc36=[Acc36;T.Acc.F36Hz{mm}];
  Acc62=[Acc62;T.Acc.F62Hz{mm}];

  Hip12=[Hip12;T.Hip.F12Hz{mm}];
  Hip36=[Hip36;T.Hip.F36Hz{mm}];
  Hip62=[Hip62;T.Hip.F62Hz{mm}];
    
end
