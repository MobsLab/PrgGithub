%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
directoryName_Mouse243_140ms=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150421/Breath-Mouse-243-21042015');               % 21-04-2015
directoryName_Mouse243_200ms=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243');  % 17-04-2015
directoryName_Mouse243_320ms=('/media/DataMOBs28/Mice-243-244/20150423/Breath-Mouse-243-23042015');                                          % 23-04-2015

directoryName_Mouse244_140ms=('/media/DataMOBs28/Mice-243-244/20150422/Breath-Mouse-244-22042015');                                          % 22-04-2015
directoryName_Mouse244_200ms=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244');  % 16-04-2015
directoryName_Mouse244_320ms=('/media/DataMOBs28/Mice-243-244/20150424/Breath-Mouse-244-24042015');                                          % 24-04-2015
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                               LOAD DELTA & EPOCH
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

struct='PaCx';
% <><><><><><><><><><><><><><>  Mouse 243  <><><><><><><><><><><><><><><><><><><>
cd([directoryName_Mouse243_140ms])
res=pwd;
load behavResources
EpochSleep1=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
EpochDelta1=intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);
EpochSleep2=intervalSet(tpsdeb{3}*1E4,tpsfin{4}*1E4);
EpochDelta2=intervalSet(tpsdeb{5}*1E4,tpsfin{5}*1E4);
EpochSleep3=intervalSet(tpsdeb{6}*1E4,tpsfin{6}*1E4);
load([res,'/newDelta',struct]);
Delta_M243_140ms=ts(tDelta);
Delta_M243_140ms_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M243_140ms_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M243_140ms_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M243_140ms_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M243_140ms_Delta2=Restrict(ts(tDelta),EpochDelta2);

cd([directoryName_Mouse243_320ms])
res=pwd;
load behavResources
EpochSleep1=intervalSet(tpsdeb{1}*1E4,tpsfin{2}*1E4);
EpochDelta1=intervalSet(tpsdeb{3}*1E4,tpsfin{3}*1E4);
EpochSleep2=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
EpochDelta2=intervalSet(tpsdeb{5}*1E4,tpsfin{5}*1E4);
EpochSleep3=intervalSet(tpsdeb{6}*1E4,tpsfin{6}*1E4);
load([res,'/newDelta',struct]);
Delta_M243_320ms=ts(tDelta);
Delta_M243_320ms_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M243_320ms_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M243_320ms_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M243_320ms_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M243_320ms_Delta2=Restrict(ts(tDelta),EpochDelta2);

% <><><><><><><><><><><><><><>  Mouse 244  <><><><><><><><><><><><><><><><><><><>
cd([directoryName_Mouse244_140ms])
res=pwd;
load behavResources
EpochSleep1=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
EpochDelta1=intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);
EpochSleep2=intervalSet(tpsdeb{3}*1E4,tpsfin{3}*1E4);
EpochDelta2=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
EpochSleep3=intervalSet(tpsdeb{5}*1E4,tpsfin{5}*1E4);
load([res,'/newDelta',struct]);
Delta_M244_140ms=ts(tDelta);
Delta_M244_140ms_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M244_140ms_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M244_140ms_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M244_140ms_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M244_140ms_Delta2=Restrict(ts(tDelta),EpochDelta2);

cd([directoryName_Mouse244_320ms])
res=pwd;
load behavResources
EpochSleep1=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);
EpochDelta1=intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);
EpochSleep2=intervalSet(tpsdeb{3}*1E4,tpsfin{3}*1E4);
EpochDelta2=intervalSet(tpsdeb{4}*1E4,tpsfin{4}*1E4);
EpochSleep3=intervalSet(tpsdeb{5}*1E4,tpsfin{5}*1E4);
load([res,'/newDelta',struct]);
Delta_M244_320ms=ts(tDelta);
Delta_M244_320ms_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M244_320ms_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M244_320ms_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M244_320ms_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M244_320ms_Delta2=Restrict(ts(tDelta),EpochDelta2);


% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                     FIND RHYTHMS
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% <><><><><><><><><><><><><><>  Mouse 243  <><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M243_140ms,'s'));
[h_M243_140ms,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_140ms,0.6);
d=diff(Range(Restrict(Delta_M243_140ms,BurstDeltaEpoch),'s'));
[hBurst_M243_140ms,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_140ms_Sleep1,'s'));
[h_M243_140ms_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_140ms_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M243_140ms_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M243_140ms_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_140ms_Sleep2,'s'));
[h_M243_140ms_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_140ms_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M243_140ms_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M243_140ms_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_140ms_Sleep3,'s'));
[h_M243_140ms_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_140ms_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M243_140ms_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M243_140ms_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_140ms_Delta1,'s'));
[h_M243_140ms_Delta1,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_140ms_Delta1,0.6);
d=diff(Range(Restrict(Delta_M243_140ms_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M243_140ms_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_140ms_Delta2,'s'));
[h_M243_140ms_Delta2,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_140ms_Delta2,0.6);
d=diff(Range(Restrict(Delta_M243_140ms_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M243_140ms_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M243_320ms,'s'));
[h_M243_320ms,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_320ms,0.6);
d=diff(Range(Restrict(Delta_M243_320ms,BurstDeltaEpoch),'s'));
[hBurst_M243_320ms,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_320ms_Sleep1,'s'));
[h_M243_320ms_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_320ms_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M243_320ms_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M243_320ms_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_320ms_Sleep2,'s'));
[h_M243_320ms_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_320ms_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M243_320ms_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M243_320ms_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_320ms_Sleep3,'s'));
[h_M243_320ms_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_320ms_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M243_320ms_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M243_320ms_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_320ms_Delta1,'s'));
[h_M243_320ms_Delta1,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_320ms_Delta1,0.6);
d=diff(Range(Restrict(Delta_M243_320ms_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M243_320ms_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_320ms_Delta2,'s'));
[h_M243_320ms_Delta2,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_320ms_Delta2,0.6);
d=diff(Range(Restrict(Delta_M243_320ms_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M243_320ms_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

% <><><><><><><><><><><><><><>  Mouse 244  <><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M244_140ms,'s'));
[h_M244_140ms,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_140ms,0.6);
d=diff(Range(Restrict(Delta_M244_140ms,BurstDeltaEpoch),'s'));
[hBurst_M244_140ms,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_140ms_Sleep1,'s'));
[h_M244_140ms_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_140ms_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M243_140ms_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M244_140ms_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_140ms_Sleep2,'s'));
[h_M244_140ms_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_140ms_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M243_140ms_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M244_140ms_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_140ms_Sleep3,'s'));
[h_M244_140ms_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_140ms_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M243_140ms_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M244_140ms_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_140ms_Delta1,'s'));
[h_M244_140ms_Delta1,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_140ms_Delta1,0.6);
d=diff(Range(Restrict(Delta_M243_140ms_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M244_140ms_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_140ms_Delta2,'s'));
[h_M244_140ms_Delta2,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_140ms_Delta2,0.6);
d=diff(Range(Restrict(Delta_M243_140ms_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M244_140ms_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M244_320ms,'s'));
[h_M244_320ms,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_320ms,0.6);
d=diff(Range(Restrict(Delta_M244_320ms,BurstDeltaEpoch),'s'));
[hBurst_M244_320ms,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_320ms_Sleep1,'s'));
[h_M244_320ms_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_320ms_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M244_320ms_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M244_320ms_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_320ms_Sleep2,'s'));
[h_M244_320ms_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_320ms_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M244_320ms_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M244_320ms_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_320ms_Sleep3,'s'));
[h_M244_320ms_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_320ms_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M244_320ms_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M244_320ms_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_320ms_Delta1,'s'));
[h_M244_320ms_Delta1,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_320ms_Delta1,0.6);
d=diff(Range(Restrict(Delta_M244_320ms_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M244_320ms_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_320ms_Delta2,'s'));
[h_M244_320ms_Delta2,b1]=hist(d,[-0.01:0.02:3.1]);clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_320ms_Delta2,0.6);
d=diff(Range(Restrict(Delta_M244_320ms_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M244_320ms_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                             MEAN AND PLOT BURST QUANTITY
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
Burst_M243=[mean(hBurst_M243_Sleep1(1:30),2);mean(hBurst_M243_Delta1(1:30),2);mean(hBurst_M243_Sleep2(1:30),2);mean(hBurst_M243_Delta1(1:30),2);mean(hBurst_M243_Sleep3(1:30),2)];
Burst_M243_140ms=[mean(hBurst_M243_140ms_Sleep1(1:30),2);mean(hBurst_M243_140ms_Delta1(1:30),2);mean(hBurst_M243_140ms_Sleep2(1:30),2);mean(hBurst_M243_140ms_Delta2(1:30),2);mean(hBurst_M243_140ms_Sleep3(1:30),2)];
Burst_M243_320ms=[mean(hBurst_M243_320ms_Sleep1(1:30),2);mean(hBurst_M243_320ms_Delta1(1:30),2);mean(hBurst_M243_320ms_Sleep2(1:30),2);mean(hBurst_M243_320ms_Delta2(1:30),2);mean(hBurst_M243_320ms_Sleep3(1:30),2)];
Burst_M243_all=[Burst_M243,Burst_M243_140ms,Burst_M243_320ms];

Burst_M244=[mean(hBurst_M244_Sleep1(1:30),2);mean(hBurst_M244_Delta1(1:30),2);mean(hBurst_M244_Sleep2(1:30),2);mean(hBurst_M244_Delta1(1:30),2);mean(hBurst_M244_Sleep3(1:30),2)];
Burst_M244_140ms=[mean(hBurst_M244_140ms_Sleep1(1:30),2);mean(hBurst_M244_140ms_Delta1(1:30),2);mean(hBurst_M244_140ms_Sleep2(1:30),2);mean(hBurst_M244_140ms_Delta2(1:30),2);mean(hBurst_M244_140ms_Sleep3(1:30),2)];
Burst_M244_320ms=[mean(hBurst_M244_320ms_Sleep1(1:30),2);mean(hBurst_M244_320ms_Delta1(1:30),2);mean(hBurst_M244_320ms_Sleep2(1:30),2);mean(hBurst_M244_320ms_Delta2(1:30),2);mean(hBurst_M244_320ms_Sleep3(1:30),2)];
Burst_M244_all=[Burst_M244,Burst_M244_140ms,Burst_M244_320ms];

figure('color',[1 1 1]), 
hold on, subplot(2,1,1)
hold on, bar(Burst_M243_all)
hold on, title('Burst quantity - Mouse 243')
hold on, subplot(2,1,2)
hold on, bar(Burst_M244_all)
hold on, title('Burst quantity - Mouse 244')

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                             MEAN AND PLOT DELTA QUANTITY
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
QDelta_M243_Sleep1=mean([length(Delta_M243_Day1_Sleep1),length(Delta_M243_Day3_Sleep1),length(Delta_M243_Day5_Sleep1)],2);
QDelta_M243_Sleep2=mean([length(Delta_M243_Day1_Sleep2),length(Delta_M243_Day2_Sleep2),length(Delta_M243_Day3_Sleep2),length(Delta_M243_Day4_Sleep2),length(Delta_M243_Day5_Sleep2)],2);
QDelta_M243_Sleep3=mean([length(Delta_M243_Day1_Sleep3),length(Delta_M243_Day2_Sleep3),length(Delta_M243_Day3_Sleep3),length(Delta_M243_Day4_Sleep3),length(Delta_M243_Day5_Sleep3)],2);
QDelta_M243_Delta1=mean([length(Delta_M243_Day1_Delta1),length(Delta_M243_Day2_Delta1),length(Delta_M243_Day3_Delta1),length(Delta_M243_Day4_Delta1),length(Delta_M243_Day5_Delta1)],2);
QDelta_M243_Delta2=mean([length(Delta_M243_Day1_Delta2),length(Delta_M243_Day2_Delta2),length(Delta_M243_Day3_Delta2),length(Delta_M243_Day4_Delta2),length(Delta_M243_Day5_Delta2)],2);
QDelta_M243=[QDelta_M243_Sleep1;QDelta_M243_Delta1;QDelta_M243_Sleep2;QDelta_M243_Delta2;QDelta_M243_Sleep3];

QDelta_M244_Sleep1=mean([length(Delta_M244_Day1_Sleep1),length(Delta_M244_Day2_Sleep1),length(Delta_M244_Day3_Sleep1),length(Delta_M244_Day4_Sleep1),length(Delta_M243_Day5_Sleep1)],2);
QDelta_M244_Sleep2=mean([length(Delta_M244_Day1_Sleep2),length(Delta_M244_Day2_Sleep2),length(Delta_M244_Day3_Sleep2),length(Delta_M244_Day4_Sleep2),length(Delta_M243_Day5_Sleep2)],2);
QDelta_M244_Sleep3=mean([length(Delta_M244_Day1_Sleep3),length(Delta_M244_Day2_Sleep3),length(Delta_M244_Day3_Sleep3),length(Delta_M244_Day4_Sleep3),length(Delta_M243_Day5_Sleep3)],2);
QDelta_M244_Delta1=mean([length(Delta_M244_Day1_Delta1),length(Delta_M244_Day2_Delta1),length(Delta_M244_Day3_Delta1),length(Delta_M244_Day4_Delta1),length(Delta_M243_Day5_Delta1)],2);
QDelta_M244_Delta2=mean([length(Delta_M244_Day1_Delta2),length(Delta_M244_Day2_Delta2),length(Delta_M244_Day3_Delta2),length(Delta_M244_Day4_Delta2),length(Delta_M243_Day5_Delta2)],2);

QDelta_M244=[QDelta_M244_Sleep1;QDelta_M244_Delta1;QDelta_M244_Sleep2;QDelta_M244_Delta2;QDelta_M244_Sleep3];
QDelta_M243=[QDelta_M243_Sleep1;QDelta_M243_Delta1;QDelta_M243_Sleep2;QDelta_M243_Delta2;QDelta_M243_Sleep3];
QDelta_M243_140ms=[length(Delta_M243_140ms_Sleep1);length(Delta_M243_140ms_Delta1);length(Delta_M243_140ms_Sleep2);length(Delta_M243_140ms_Delta2);length(Delta_M243_140ms_Sleep3)];
QDelta_M243_320ms=[length(Delta_M243_320ms_Sleep1);length(Delta_M243_320ms_Delta1);length(Delta_M243_320ms_Sleep2);length(Delta_M243_320ms_Delta2);length(Delta_M243_320ms_Sleep3)];
QDelta_M243_all=[QDelta_M243,QDelta_M243_140ms,QDelta_M243_320ms];

QDelta_M244=[QDelta_M244_Sleep1;QDelta_M244_Delta1;QDelta_M244_Sleep2;QDelta_M244_Delta2;QDelta_M244_Sleep3];
QDelta_M244_140ms=[length(Delta_M244_140ms_Sleep1);length(Delta_M244_140ms_Delta1);length(Delta_M244_140ms_Sleep2);length(Delta_M244_140ms_Delta2);length(Delta_M244_140ms_Sleep3)];
QDelta_M244_320ms=[length(Delta_M244_320ms_Sleep1);length(Delta_M244_320ms_Delta1);length(Delta_M244_320ms_Sleep2);length(Delta_M244_320ms_Delta2);length(Delta_M244_320ms_Sleep3)];
QDelta_M244_all=[QDelta_M244,QDelta_M244_140ms,QDelta_M244_320ms];

figure('color',[1 1 1]), 
hold on, subplot(2,1,1)
hold on, bar(QDelta_M243_all)
hold on, title('Delta quantity - Mouse 243')
hold on, subplot(2,1,2)
hold on, bar(QDelta_M244_all)
hold on, title('Delta quantity - Mouse 244')


% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                             MEAN AND PLOT DELTA QUANTITY
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% Delta_M243=[mean(h_M243_Sleep1(1:155),2);mean(h_M243_Delta1(1:155),2);mean(h_M243_Sleep2(1:155),2);mean(h_M243_Delta1(1:155),2);mean(h_M243_Sleep3(1:155),2)];
% Delta_M243_140ms=[mean(h_M243_140ms_Sleep1(1:155),2);mean(h_M243_140ms_Delta1(1:155),2);mean(h_M243_140ms_Sleep2(1:155),2);mean(h_M243_140ms_Delta2(1:155),2);mean(h_M243_140ms_Sleep3(1:155),2)];
% Delta_M243_320ms=[mean(h_M243_320ms_Sleep1(1:155),2);mean(h_M243_320ms_Delta1(1:155),2);mean(h_M243_320ms_Sleep2(1:155),2);mean(h_M243_320ms_Delta2(1:155),2);mean(h_M243_320ms_Sleep3(1:155),2)];
% Delta_M243_all=[Delta_M243,Delta_M243_140ms,Delta_M243_320ms];
% 
% Delta_M244=[mean(h_M244_Sleep1(1:155),2);mean(h_M244_Delta1(1:155),2);mean(h_M244_Sleep2(1:155),2);mean(h_M244_Delta1(1:155),2);mean(h_M244_Sleep3(1:155),2)];
% Delta_M244_140ms=[mean(h_M244_140ms_Sleep1(1:155),2);mean(h_M244_140ms_Delta1(1:155),2);mean(h_M244_140ms_Sleep2(1:155),2);mean(h_M244_140ms_Delta2(1:155),2);mean(h_M244_140ms_Sleep3(1:155),2)];
% Delta_M244_320ms=[mean(h_M244_320ms_Sleep1(1:155),2);mean(h_M244_320ms_Delta1(1:155),2);mean(h_M244_320ms_Sleep2(1:155),2);mean(h_M244_320ms_Delta2(1:155),2);mean(h_M244_320ms_Sleep3(1:155),2)];
% Delta_M244_all=[Delta_M244,Delta_M244_140ms,Delta_M244_320ms];
% 
% figure('color',[1 1 1]), 
% hold on, subplot(2,1,1)
% hold on, bar(Delta_M243_all)
% hold on, subplot(2,1,2)
% hold on, bar(Delta_M244_all)

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                              MEAN AND PLOT DELTA RHYTHMS
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

plo=1;
if plo==1
    figure('color',[1 1 1]),
    hold on, subplot(2,3,[1 4]),
    hold on, plot(b1,smooth(h_M243_All,3),'linewidth',1,'color','k')
    hold on, plot(b1,smooth(h_M243_140ms,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 300])
    hold on, line([0.3 0.3],[0 300],'color','k')
    hold on, title([struct,'Mouse 243 - delay: 140ms - All Day'])
    hold on, legend(['Basal Sleep'],['Delta Sleep'])
    hold on, subplot(2,3,2),
    hold on, plot(b1,smooth(h_M243_Sleep1,3),'linewidth',1,'color','b')
    hold on, plot(b1,smooth(h_M243_140ms_Sleep1,3),'linewidth',2,'color','b')
    hold on, plot(b1,smooth(h_M243_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M243_140ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 80])
    hold on, line([0.3 0.3],[0 80],'color','k')
    hold on, legend(['Basal PRE'],['Delta PRE'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Morning Session (8h-14h)'])
    hold on, subplot(2,3,5),
    hold on, plot(b1,smooth(h_M243_Sleep2,3),'linewidth',1,'color','g')
    hold on, plot(b1,smooth(h_M243_140ms_Sleep2,3),'linewidth',2,'color','g')
    hold on, plot(b1,smooth(h_M243_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M243_140ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 80])
    hold on, line([0.3 0.3],[0 80],'color','k')
    hold on, legend(['Basal POST'],['Delta POST'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Morning Session (8h-14h)'])
    hold on, subplot(2,3,3),
    hold on, plot(b1,smooth(h_M243_Sleep2,3),'linewidth',1,'color','b')
    hold on, plot(b1,smooth(h_M243_140ms_Sleep2,3),'linewidth',2,'color','b')
    hold on, plot(b1,smooth(h_M243_Delta2,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M243_140ms_Delta2,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 80])
    hold on, line([0.3 0.3],[0 80],'color','k')
    hold on, legend(['Basal PRE'],['Delta PRE'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Afternoon Session (8h-14h)'])
    hold on, subplot(2,3,6),
    hold on, plot(b1,smooth(h_M243_Sleep3,3),'linewidth',1,'color','g')
    hold on, plot(b1,smooth(h_M243_140ms_Sleep3,3),'linewidth',2,'color','g')
    hold on, plot(b1,smooth(h_M243_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M243_140ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 80])
    hold on, line([0.3 0.3],[0 80],'color','k')
    hold on, legend(['Basal POST'],['Delta POST'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Afternoon Session (12h-18h)'])
    
    figure('color',[1 1 1]),
    hold on, subplot(2,3,[1 4]),
    hold on, plot(b1,smooth(h_M243_All,3),'linewidth',1,'color','k')
    hold on, plot(b1,smooth(h_M243_320ms,3),'linewidth',1,'color','r')
    hold on, xlim([0 3]), ylim([0 450])
    hold on, line([0.48 0.48],[0 450],'color','k')
    hold on, title([struct,'Mouse 243 - delay: 320ms - All Day'])
    hold on, legend(['Basal Sleep'],['Delta Sleep'])
    hold on, subplot(2,3,2),
    hold on, plot(b1,smooth(h_M243_Sleep1,3),'linewidth',1,'color','b')
    hold on, plot(b1,smooth(h_M243_320ms_Sleep1,3),'linewidth',2,'color','b')
    hold on, plot(b1,smooth(h_M243_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M243_320ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 80])
    hold on, line([0.48 0.48],[0 80],'color','k')
    hold on, legend(['Basal PRE'],['Delta PRE'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Morning Session (8h-14h)'])
    hold on, subplot(2,3,5),
    hold on, plot(b1,smooth(h_M243_Sleep2,3),'linewidth',1,'color','g')
    hold on, plot(b1,smooth(h_M243_320ms_Sleep2,3),'linewidth',2,'color','g')
    hold on, plot(b1,smooth(h_M243_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M243_320ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 80])
    hold on, line([0.48 0.48],[0 80],'color','k')
    hold on, legend(['Basal POST'],['Delta POST'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Morning Session (8h-14h)'])
    hold on, subplot(2,3,3),
    hold on, plot(b1,smooth(h_M243_Sleep2,3),'linewidth',1,'color','b')
    hold on, plot(b1,smooth(h_M243_320ms_Sleep2,3),'linewidth',2,'color','b')
    hold on, plot(b1,smooth(h_M243_Delta2,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M243_320ms_Delta2,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 80])
    hold on, line([0.48 0.48],[0 80],'color','k')
    hold on, legend(['Basal PRE'],['Delta PRE'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Afternoon Session (8h-14h)'])
    hold on, subplot(2,3,6),
    hold on, plot(b1,smooth(h_M243_Sleep3,3),'linewidth',1,'color','g')
    hold on, plot(b1,smooth(h_M243_320ms_Sleep3,3),'linewidth',2,'color','g')
    hold on, plot(b1,smooth(h_M243_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M243_320ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 2]), ylim([0 80])
    hold on, line([0.48 0.48],[0 80],'color','k')
    hold on, legend(['Basal POST'],['Delta POST'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Afternoon Session (12h-18h)'])
    
    
    
    figure('color',[1 1 1]),
    hold on, subplot(2,3,[1 4]),
    hold on, plot(b1,smooth(h_M244_All,3),'linewidth',1,'color','k')
    hold on, plot(b1,smooth(h_M244_140ms,3),'linewidth',1,'color','r')
    hold on, xlim([0 3]), ylim([0 450])
    hold on, line([0.3 0.3],[0 300],'color','k')
    hold on, title([struct,'Mouse 244 - delay: 140ms - All Day'])
    hold on, legend(['Basal Sleep'],['Delta Sleep'])
    hold on, subplot(2,3,2),
    hold on, plot(b1,smooth(h_M244_Sleep1,3),'linewidth',1,'color','b')
    hold on, plot(b1,smooth(h_M244_140ms_Sleep1,3),'linewidth',2,'color','b')
    hold on, plot(b1,smooth(h_M244_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M244_140ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 150])
    hold on, line([0.3 0.3],[0 105],'color','k')
    hold on, legend(['Basal PRE'],['Delta PRE'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Morning Session (8h-14h)'])
    hold on, subplot(2,3,5),
    hold on, plot(b1,smooth(h_M244_Sleep2,3),'linewidth',1,'color','g')
    hold on, plot(b1,smooth(h_M244_140ms_Sleep2,3),'linewidth',2,'color','g')
    hold on, plot(b1,smooth(h_M244_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M244_140ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 150])
    hold on, line([0.3 0.3],[0 150],'color','k')
    hold on, legend(['Basal POST'],['Delta POST'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Morning Session (8h-14h)'])
    hold on, subplot(2,3,3),
    hold on, plot(b1,smooth(h_M244_Sleep2,3),'linewidth',1,'color','b')
    hold on, plot(b1,smooth(h_M244_140ms_Sleep2,3),'linewidth',2,'color','b')
    hold on, plot(b1,smooth(h_M244_Delta2,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M244_140ms_Delta2,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 150])
    hold on, line([0.3 0.3],[0 150],'color','k')
    hold on, legend(['Basal PRE'],['Delta PRE'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Afternoon Session (8h-14h)'])
    hold on, subplot(2,3,6),
    hold on, plot(b1,smooth(h_M244_Sleep3,3),'linewidth',1,'color','g')
    hold on, plot(b1,smooth(h_M244_140ms_Sleep3,3),'linewidth',2,'color','g')
    hold on, plot(b1,smooth(h_M244_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M244_140ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 150])
    hold on, line([0.3 0.3],[0 150],'color','k')
    hold on, legend(['Basal POST'],['Delta POST'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Afternoon Session (12h-18h)'])
    
    figure('color',[1 1 1]),
    hold on, subplot(2,3,[1 4]),
    hold on, plot(b1,smooth(h_M244_All,3),'linewidth',1,'color','k')
    hold on, plot(b1,smooth(h_M244_320ms,3),'linewidth',1,'color','r')
    hold on, xlim([0 2]), ylim([0 450])
    hold on, line([0.48 0.48],[0 450],'color','k')
    hold on, title([struct,'Mouse 244 - delay: 320ms - All Day'])
    hold on, legend(['Basal Sleep'],['Delta Sleep'])
    hold on, subplot(2,3,2),
    hold on, plot(b1,smooth(h_M244_Sleep1,3),'linewidth',1,'color','b')
    hold on, plot(b1,smooth(h_M244_320ms_Sleep1,3),'linewidth',2,'color','b')
    hold on, plot(b1,smooth(h_M244_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M244_320ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 150])
    hold on, line([0.48 0.48],[0 150],'color','k')
    hold on, legend(['Basal PRE'],['Delta PRE'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Morning Session (8h-14h)'])
    hold on, subplot(2,3,5),
    hold on, plot(b1,smooth(h_M244_Sleep2,3),'linewidth',1,'color','g')
    hold on, plot(b1,smooth(h_M244_320ms_Sleep2,3),'linewidth',2,'color','g')
    hold on, plot(b1,smooth(h_M244_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M244_320ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 150])
    hold on, line([0.48 0.48],[0 150],'color','k')
    hold on, legend(['Basal POST'],['Delta POST'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Morning Session (8h-14h)'])
    hold on, subplot(2,3,3),
    hold on, plot(b1,smooth(h_M244_Sleep2,3),'linewidth',1,'color','b')
    hold on, plot(b1,smooth(h_M244_320ms_Sleep2,3),'linewidth',2,'color','b')
    hold on, plot(b1,smooth(h_M244_Delta2,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M244_320ms_Delta2,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 150])
    hold on, line([0.48 0.48],[0 150],'color','k')
    hold on, legend(['Basal PRE'],['Delta PRE'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Afternoon Session (8h-14h)'])
    hold on, subplot(2,3,6),
    hold on, plot(b1,smooth(h_M244_Sleep3,3),'linewidth',1,'color','g')
    hold on, plot(b1,smooth(h_M244_320ms_Sleep3,3),'linewidth',2,'color','g')
    hold on, plot(b1,smooth(h_M244_Delta1,3),'linewidth',1,'color','r')
    hold on, plot(b1,smooth(h_M244_320ms_Delta1,3),'linewidth',2,'color','r')
    hold on, xlim([0 3]), ylim([0 150])
    hold on, line([0.48 0.48],[0 150],'color','k')
    hold on, legend(['Basal POST'],['Delta POST'],['Basal noTone'],['Delta Tone'])
    hold on, title([struct,'Afternoon Session (12h-18h)'])
end

