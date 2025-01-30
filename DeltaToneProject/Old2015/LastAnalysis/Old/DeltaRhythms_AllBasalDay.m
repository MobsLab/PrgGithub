% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
directoryName_Mouse243_Day1=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse243');
directoryName_Mouse244_Day1=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244');
directoryName_Mouse243_Day2=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse243');
directoryName_Mouse244_Day2=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244');
directoryName_Mouse243_Day3=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243');
directoryName_Mouse244_Day3=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244');
directoryName_Mouse243_Day4=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243');
directoryName_Mouse244_Day4=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244');
directoryName_Mouse243_Day5=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243');
directoryName_Mouse244_Day5=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244');
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>



% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                               LOAD DELTA & EPOCH
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

struct='PaCx';
% <><><><><><><><><><><><><><>  Mouse 243  <><><><><><><><><><><><><><><><><><><>
cd([directoryName_Mouse243_Day1])
res=pwd;
load behavResources
Beg=0;End=tpsfin{size(tpsfin,2)}*1E4;
EpochSleep1=intervalSet((End/5)*0,(End/5)*1);
EpochDelta1=intervalSet((End/5)*1,(End/5)*2);
EpochSleep2=intervalSet((End/5)*2,(End/5)*3);
EpochDelta2=intervalSet((End/5)*3,(End/5)*4);
EpochSleep3=intervalSet((End/5)*4,(End/5)*5);
load([res,'/newDelta',struct]);
Delta_M243_Day1=ts(tDelta);
Delta_M243_Day1_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M243_Day1_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M243_Day1_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M243_Day1_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M243_Day1_Delta2=Restrict(ts(tDelta),EpochDelta2);


cd([directoryName_Mouse243_Day2])
res=pwd;
load behavResources
Beg=0;End=tpsfin{size(tpsfin,2)}*1E4;
EpochSleep1=intervalSet((End/5)*0,(End/5)*1);
EpochDelta1=intervalSet((End/5)*1,(End/5)*2);
EpochSleep2=intervalSet((End/5)*2,(End/5)*3);
EpochDelta2=intervalSet((End/5)*3,(End/5)*4);
EpochSleep3=intervalSet((End/5)*4,(End/5)*5);
load([res,'/newDelta',struct]);
Delta_M243_Day2=ts(tDelta);
Delta_M243_Day2_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M243_Day2_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M243_Day2_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M243_Day2_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M243_Day2_Delta2=Restrict(ts(tDelta),EpochDelta2);

cd([directoryName_Mouse243_Day3])
res=pwd;
load behavResources
Beg=0;End=tpsfin{size(tpsfin,2)}*1E4;
EpochSleep1=intervalSet((End/5)*0,(End/5)*1);
EpochDelta1=intervalSet((End/5)*1,(End/5)*2);
EpochSleep2=intervalSet((End/5)*2,(End/5)*3);
EpochDelta2=intervalSet((End/5)*3,(End/5)*4);
EpochSleep3=intervalSet((End/5)*4,(End/5)*5);
load([res,'/newDelta',struct]);
Delta_M243_Day3=ts(tDelta);
Delta_M243_Day3_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M243_Day3_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M243_Day3_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M243_Day3_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M243_Day3_Delta2=Restrict(ts(tDelta),EpochDelta2);

cd([directoryName_Mouse243_Day4])
res=pwd;
load behavResources
Beg=0;End=tpsfin{size(tpsfin,2)}*1E4;
EpochSleep1=intervalSet((End/5)*0,(End/5)*1);
EpochDelta1=intervalSet((End/5)*1,(End/5)*2);
EpochSleep2=intervalSet((End/5)*2,(End/5)*3);
EpochDelta2=intervalSet((End/5)*3,(End/5)*4);
EpochSleep3=intervalSet((End/5)*4,(End/5)*5);
load([res,'/newDelta',struct]);
Delta_M243_Day4=ts(tDelta);
Delta_M243_Day4_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M243_Day4_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M243_Day4_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M243_Day4_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M243_Day4_Delta2=Restrict(ts(tDelta),EpochDelta2);

cd([directoryName_Mouse243_Day5])
res=pwd;
load behavResources
Beg=0;End=tpsfin{size(tpsfin,2)}*1E4;
EpochSleep1=intervalSet((End/5)*0,(End/5)*1);
EpochDelta1=intervalSet((End/5)*1,(End/5)*2);
EpochSleep2=intervalSet((End/5)*2,(End/5)*3);
EpochDelta2=intervalSet((End/5)*3,(End/5)*4);
EpochSleep3=intervalSet((End/5)*4,(End/5)*5);
load([res,'/newDelta',struct]);
Delta_M243_Day5=ts(tDelta);
Delta_M243_Day5_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M243_Day5_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M243_Day5_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M243_Day5_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M243_Day5_Delta2=Restrict(ts(tDelta),EpochDelta2);

% <><><><><><><><><><><><><><>  Mouse 244  <><><><><><><><><><><><><><><><>
cd([directoryName_Mouse244_Day1])
res=pwd;
load behavResources
Beg=0;End=tpsfin{size(tpsfin,2)}*1E4;
EpochSleep1=intervalSet((End/5)*0,(End/5)*1);
EpochDelta1=intervalSet((End/5)*1,(End/5)*2);
EpochSleep2=intervalSet((End/5)*2,(End/5)*3);
EpochDelta2=intervalSet((End/5)*3,(End/5)*4);
EpochSleep3=intervalSet((End/5)*4,(End/5)*5);
load([res,'/newDelta',struct]);
Delta_M244_Day1=ts(tDelta);
Delta_M244_Day1_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M244_Day1_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M244_Day1_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M244_Day1_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M244_Day1_Delta2=Restrict(ts(tDelta),EpochDelta2);


cd([directoryName_Mouse244_Day2])
res=pwd;
load behavResources
Beg=0;End=tpsfin{size(tpsfin,2)}*1E4;
EpochSleep1=intervalSet((End/5)*0,(End/5)*1);
EpochDelta1=intervalSet((End/5)*1,(End/5)*2);
EpochSleep2=intervalSet((End/5)*2,(End/5)*3);
EpochDelta2=intervalSet((End/5)*3,(End/5)*4);
EpochSleep3=intervalSet((End/5)*4,(End/5)*5);
load([res,'/newDelta',struct]);
Delta_M244_Day2=ts(tDelta);
Delta_M244_Day2_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M244_Day2_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M244_Day2_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M244_Day2_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M244_Day2_Delta2=Restrict(ts(tDelta),EpochDelta2);

cd([directoryName_Mouse244_Day3])
res=pwd;
load behavResources
Beg=0;End=tpsfin{size(tpsfin,2)}*1E4;
EpochSleep1=intervalSet((End/5)*0,(End/5)*1);
EpochDelta1=intervalSet((End/5)*1,(End/5)*2);
EpochSleep2=intervalSet((End/5)*2,(End/5)*3);
EpochDelta2=intervalSet((End/5)*3,(End/5)*4);
EpochSleep3=intervalSet((End/5)*4,(End/5)*5);
load([res,'/newDelta',struct]);
Delta_M244_Day3=ts(tDelta);
Delta_M244_Day3_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M244_Day3_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M244_Day3_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M244_Day3_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M244_Day3_Delta2=Restrict(ts(tDelta),EpochDelta2);

cd([directoryName_Mouse244_Day4])
res=pwd;
load behavResources
Beg=0;End=tpsfin{size(tpsfin,2)}*1E4;
EpochSleep1=intervalSet((End/5)*0,(End/5)*1);
EpochDelta1=intervalSet((End/5)*1,(End/5)*2);
EpochSleep2=intervalSet((End/5)*2,(End/5)*3);
EpochDelta2=intervalSet((End/5)*3,(End/5)*4);
EpochSleep3=intervalSet((End/5)*4,(End/5)*5);
load([res,'/newDelta',struct]);
Delta_M244_Day4=ts(tDelta);
Delta_M244_Day4_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M244_Day4_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M244_Day4_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M244_Day4_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M244_Day4_Delta2=Restrict(ts(tDelta),EpochDelta2);

cd([directoryName_Mouse244_Day5])
res=pwd;
load behavResources
Beg=0;End=tpsfin{size(tpsfin,2)}*1E4;
EpochSleep1=intervalSet((End/5)*0,(End/5)*1);
EpochDelta1=intervalSet((End/5)*1,(End/5)*2);
EpochSleep2=intervalSet((End/5)*2,(End/5)*3);
EpochDelta2=intervalSet((End/5)*3,(End/5)*4);
EpochSleep3=intervalSet((End/5)*4,(End/5)*5);
load([res,'/newDelta',struct]);
Delta_M244_Day5=ts(tDelta);
Delta_M244_Day5_Sleep1=Restrict(ts(tDelta),EpochSleep1);
Delta_M244_Day5_Sleep2=Restrict(ts(tDelta),EpochSleep2);
Delta_M244_Day5_Sleep3=Restrict(ts(tDelta),EpochSleep3);
Delta_M244_Day5_Delta1=Restrict(ts(tDelta),EpochDelta1);
Delta_M244_Day5_Delta2=Restrict(ts(tDelta),EpochDelta2);

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                     FIND RHYTHMS
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% <><><><><><><><><><><><><><>  Mouse 243  <><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M243_Day1,'s'));
[h_M243_Day1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day1,0.6);
d=diff(Range(Restrict(Delta_M243_Day1,BurstDeltaEpoch),'s'));
[hBurst_M243_Day1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_Day1_Sleep1,'s'));
[h_M243_Day1_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day1_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M243_Day1_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M243_Day1_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d 
end

d=diff(Range(Delta_M243_Day1_Sleep2,'s'));
[h_M243_Day1_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try [BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day1_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M243_Day1_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M243_Day1_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day1_Sleep3,'s'));
[h_M243_Day1_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day1_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M243_Day1_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M243_Day1_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day1_Delta1,'s'));
[h_M243_Day1_Delta1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day1_Delta1,0.6);
d=diff(Range(Restrict(Delta_M243_Day1_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M243_Day1_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day1_Delta2,'s'));
[h_M243_Day1_Delta2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day1_Delta2,0.6);
d=diff(Range(Restrict(Delta_M243_Day1_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M243_Day1_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M243_Day2,'s'));
[h_M243_Day2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day2,0.6);
d=diff(Range(Restrict(Delta_M243_Day2,BurstDeltaEpoch),'s'));
[hBurst_M243_Day2,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day2_Sleep1,'s'));
[h_M243_Day2_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day2_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M243_Day2_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M243_Day2_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day2_Sleep2,'s'));
[h_M243_Day2_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day2_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M243_Day2_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M243_Day2_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day2_Sleep3,'s'));
[h_M243_Day2_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day2_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M243_Day2_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M243_Day2_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day2_Delta1,'s'));
[h_M243_Day2_Delta1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day2_Delta1,0.6);
d=diff(Range(Restrict(Delta_M243_Day2_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M243_Day2_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day2_Delta2,'s'));
[h_M243_Day2_Delta2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try [BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day2_Delta2,0.6);
d=diff(Range(Restrict(Delta_M243_Day2_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M243_Day2_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M243_Day3,'s'));
[h_M243_Day3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try [BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day3,0.6);
d=diff(Range(Restrict(Delta_M243_Day3,BurstDeltaEpoch),'s'));
[hBurst_M243_Day3,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day3_Sleep1,'s'));
[h_M243_Day3_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day3_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M243_Day3_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M243_Day3_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day3_Sleep2,'s'));
[h_M243_Day3_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day3_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M243_Day3_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M243_Day3_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day3_Sleep3,'s'));
[h_M243_Day3_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day3_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M243_Day3_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M243_Day3_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day3_Delta1,'s'));
[h_M243_Day3_Delta1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day3_Delta1,0.6);
d=diff(Range(Restrict(Delta_M243_Day3_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M243_Day3_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day3_Delta2,'s'));
[h_M243_Day3_Delta2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day3_Delta2,0.6);
d=diff(Range(Restrict(Delta_M243_Day3_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M243_Day3_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M243_Day4,'s'));
[h_M243_Day4,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day4,0.6);
d=diff(Range(Restrict(Delta_M243_Day4,BurstDeltaEpoch),'s'));
[hBurst_M243_Day4,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day4_Sleep1,'s'));
[h_M243_Day4_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day4_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M243_Day4_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M243_Day4_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day4_Sleep2,'s'));
[h_M243_Day4_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day4_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M243_Day4_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M243_Day4_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day4_Sleep3,'s'));
[h_M243_Day4_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day4_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M243_Day4_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M243_Day4_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day4_Delta1,'s'));
[h_M243_Day4_Delta1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day4_Delta1,0.6);
d=diff(Range(Restrict(Delta_M243_Day4_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M243_Day4_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day4_Delta2,'s'));
[h_M243_Day4_Delta2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day4_Delta2,0.6);
d=diff(Range(Restrict(Delta_M243_Day4_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M243_Day4_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M243_Day5,'s'));
[h_M243_Day5,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day5,0.6);
d=diff(Range(Restrict(Delta_M243_Day5,BurstDeltaEpoch),'s'));
[hBurst_M243_Day5,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day5_Sleep1,'s'));
[h_M243_Day5_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day5_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M243_Day5_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M243_Day5_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day5_Sleep2,'s'));
[h_M243_Day5_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day5_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M243_Day5_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M243_Day5_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end

d=diff(Range(Delta_M243_Day5_Sleep3,'s'));
[h_M243_Day5_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
try[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day5_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M243_Day5_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M243_Day5_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d
end
d=diff(Range(Delta_M243_Day5_Delta1,'s'));
[h_M243_Day5_Delta1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day5_Delta1,0.6);
d=diff(Range(Restrict(Delta_M243_Day5_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M243_Day5_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M243_Day5_Delta2,'s'));
[h_M243_Day5_Delta2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M243_Day5_Delta2,0.6);
d=diff(Range(Restrict(Delta_M243_Day5_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M243_Day5_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

% <><><><><><><><><><><><><><>  Mouse 244  <><><><><><><><><><><><><><><><>

d=diff(Range(Delta_M244_Day1,'s'));
[h_M244_Day1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day1,0.6);
d=diff(Range(Restrict(Delta_M244_Day1,BurstDeltaEpoch),'s'));
[hBurst_M244_Day1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day1_Sleep1,'s'));
[h_M244_Day1_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day1_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M244_Day1_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M244_Day1_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day1_Sleep2,'s'));
[h_M244_Day1_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day1_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M244_Day1_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M244_Day1_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day1_Sleep3,'s'));
[h_M244_Day1_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day1_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M244_Day1_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M244_Day1_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day1_Delta1,'s'));
[h_M244_Day1_Delta1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day1_Delta1,0.6);
d=diff(Range(Restrict(Delta_M244_Day1_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M244_Day1_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day1_Delta2,'s'));
[h_M244_Day1_Delta2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day1_Delta2,0.6);
d=diff(Range(Restrict(Delta_M244_Day1_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M244_Day1_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M244_Day2,'s'));
[h_M244_Day2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day2,0.6);
d=diff(Range(Restrict(Delta_M244_Day2,BurstDeltaEpoch),'s'));
[hBurst_M244_Day2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day1_Sleep1,'s'));
[h_M244_Day2_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day2_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M244_Day1_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M244_Day2_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day1_Sleep2,'s'));
[h_M244_Day2_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day2_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M244_Day1_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M244_Day2_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day1_Sleep3,'s'));
[h_M244_Day2_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day2_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M244_Day1_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M244_Day2_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day1_Delta1,'s'));
[h_M244_Day2_Delta1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day2_Delta1,0.6);
d=diff(Range(Restrict(Delta_M244_Day1_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M244_Day2_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day1_Delta2,'s'));
[h_M244_Day2_Delta2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day2_Delta2,0.6);
d=diff(Range(Restrict(Delta_M244_Day1_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M244_Day2_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M244_Day3,'s'));
[h_M244_Day3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day3,0.6);
d=diff(Range(Restrict(Delta_M244_Day3,BurstDeltaEpoch),'s'));
[hBurst_M244_Day3,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day3_Sleep1,'s'));
[h_M244_Day3_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day3_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M244_Day3_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M244_Day3_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day3_Sleep2,'s'));
[h_M244_Day3_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day3_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M244_Day3_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M244_Day3_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day3_Sleep3,'s'));
[h_M244_Day3_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day3_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M244_Day3_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M244_Day3_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day3_Delta1,'s'));
[h_M244_Day3_Delta1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day3_Delta1,0.6);
d=diff(Range(Restrict(Delta_M244_Day3_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M244_Day3_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day3_Delta2,'s'));
[h_M244_Day3_Delta2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day3_Delta2,0.6);
d=diff(Range(Restrict(Delta_M244_Day3_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M244_Day3_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M244_Day4,'s'));
[h_M244_Day4,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day4,0.6);
d=diff(Range(Restrict(Delta_M244_Day4,BurstDeltaEpoch),'s'));
[hBurst_M244_Day4,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day4_Sleep1,'s'));
[h_M244_Day4_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day4_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M244_Day4_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M244_Day4_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day4_Sleep2,'s'));
[h_M244_Day4_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day4_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M244_Day4_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M244_Day4_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day4_Sleep3,'s'));
[h_M244_Day4_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day4_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M244_Day4_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M244_Day4_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day4_Delta1,'s'));
[h_M244_Day4_Delta1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day4_Delta1,0.6);
d=diff(Range(Restrict(Delta_M244_Day4_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M244_Day4_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day4_Delta2,'s'));
[h_M244_Day4_Delta2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day4_Delta2,0.6);
d=diff(Range(Restrict(Delta_M244_Day4_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M244_Day4_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
d=diff(Range(Delta_M244_Day5,'s'));
[h_M244_Day5,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day5,0.6);
d=diff(Range(Restrict(Delta_M244_Day5,BurstDeltaEpoch),'s'));
[hBurst_M244_Day5,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day5_Sleep1,'s'));
[h_M244_Day5_Sleep1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day5_Sleep1,0.6);
d=diff(Range(Restrict(Delta_M244_Day5_Sleep1,BurstDeltaEpoch),'s'));
[hBurst_M244_Day5_Sleep1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day5_Sleep2,'s'));
[h_M244_Day5_Sleep2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day5_Sleep2,0.6);
d=diff(Range(Restrict(Delta_M244_Day5_Sleep2,BurstDeltaEpoch),'s'));
[hBurst_M244_Day5_Sleep2,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day5_Sleep3,'s'));
[h_M244_Day5_Sleep3,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day5_Sleep3,0.6);
d=diff(Range(Restrict(Delta_M244_Day5_Sleep3,BurstDeltaEpoch),'s'));
[hBurst_M244_Day5_Sleep3,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day5_Delta1,'s'));
[h_M244_Day5_Delta1,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day5_Delta1,0.6);
d=diff(Range(Restrict(Delta_M244_Day5_Delta1,BurstDeltaEpoch),'s'));
[hBurst_M244_Day5_Delta1,b2]=hist(d, [-0.01:0.02:3.1]); clear d

d=diff(Range(Delta_M244_Day5_Delta2,'s'));
[h_M244_Day5_Delta2,b1]=hist(d,[-0.01:0.02:3.1]); clear d
[BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta_M244_Day5_Delta2,0.6);
d=diff(Range(Restrict(Delta_M244_Day5_Delta2,BurstDeltaEpoch),'s'));
[hBurst_M244_Day5_Delta2,b2]=hist(d, [-0.01:0.02:3.1]); clear d


% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                     MEAN ALL THAT
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% Delta Quantity
QDelta_M243_Sleep1=mean([length(Delta_M243_Day1_Sleep1),length(Delta_M243_Day3_Sleep1),length(Delta_M243_Day5_Sleep1)],2);
QDelta_M243_Sleep1=mean([length(Delta_M243_Day1_Sleep1),length(Delta_M243_Day2_Sleep1),length(Delta_M243_Day3_Sleep1),length(Delta_M243_Day4_Sleep1),length(Delta_M243_Day5_Sleep1)],2);
QDelta_M243_Sleep2=mean([length(Delta_M243_Day1_Sleep2),length(Delta_M243_Day2_Sleep2),length(Delta_M243_Day3_Sleep2),length(Delta_M243_Day4_Sleep2),length(Delta_M243_Day5_Sleep2)],2);
QDelta_M243_Sleep3=mean([length(Delta_M243_Day1_Sleep3),length(Delta_M243_Day2_Sleep3),length(Delta_M243_Day3_Sleep3),length(Delta_M243_Day4_Sleep3),length(Delta_M243_Day5_Sleep3)],2);
QDelta_M243_Delta1=mean([length(Delta_M243_Day1_Delta1),length(Delta_M243_Day2_Delta1),length(Delta_M243_Day3_Delta1),length(Delta_M243_Day4_Delta1),length(Delta_M243_Day5_Delta1)],2);
QDelta_M243_Delta2=mean([length(Delta_M243_Day1_Delta2),length(Delta_M243_Day2_Delta2),length(Delta_M243_Day3_Delta2),length(Delta_M243_Day4_Delta2),length(Delta_M243_Day5_Delta2)],2);
QDelta_M243=[QDelta_M243_Sleep1;QDelta_M243_Delta1;QDelta_M243_Sleep2;QDelta_M243_Delta2;QDelta_M243_Sleep3];

QDelta_M244_all=mean([length(Delta_M244_Day1),length(Delta_M244_Day2),length(Delta_M244_Day3),length(Delta_M244_Day4),length(Delta_M244_Day5)],2);
QDelta_M244_Sleep1=mean([length(Delta_M244_Day1_Sleep1),length(Delta_M244_Day2_Sleep1),length(Delta_M244_Day3_Sleep1),length(Delta_M244_Day4_Sleep1),length(Delta_M243_Day5_Sleep1)],2);
QDelta_M244_Sleep2=mean([length(Delta_M244_Day1_Sleep2),length(Delta_M244_Day2_Sleep2),length(Delta_M244_Day3_Sleep2),length(Delta_M244_Day4_Sleep2),length(Delta_M243_Day5_Sleep2)],2);
QDelta_M244_Sleep3=mean([length(Delta_M244_Day1_Sleep3),length(Delta_M244_Day2_Sleep3),length(Delta_M244_Day3_Sleep3),length(Delta_M244_Day4_Sleep3),length(Delta_M243_Day5_Sleep3)],2);
QDelta_M244_Delta1=mean([length(Delta_M244_Day1_Delta1),length(Delta_M244_Day2_Delta1),length(Delta_M244_Day3_Delta1),length(Delta_M244_Day4_Delta1),length(Delta_M243_Day5_Delta1)],2);
QDelta_M244_Delta2=mean([length(Delta_M244_Day1_Delta2),length(Delta_M244_Day2_Delta2),length(Delta_M244_Day3_Delta2),length(Delta_M244_Day4_Delta2),length(Delta_M243_Day5_Delta2)],2);
QDelta_M244=[QDelta_M244_Sleep1;QDelta_M244_Delta1;QDelta_M244_Sleep2;QDelta_M244_Delta2;QDelta_M244_Sleep3];

% Delta Distribution
h_M243_All=mean([h_M243_Day1;h_M243_Day2;h_M243_Day3;h_M243_Day4;h_M243_Day5],1);
h_M243_Sleep1=mean([h_M243_Day1_Sleep1;h_M243_Day2_Sleep1;h_M243_Day3_Sleep1;h_M243_Day4_Sleep1;h_M243_Day5_Sleep1],1);
h_M243_Sleep2=mean([h_M243_Day1_Sleep2;h_M243_Day2_Sleep2;h_M243_Day3_Sleep2;h_M243_Day4_Sleep2;h_M243_Day5_Sleep2],1);
h_M243_Sleep3=mean([h_M243_Day1_Sleep3;h_M243_Day2_Sleep3;h_M243_Day3_Sleep3;h_M243_Day4_Sleep3;h_M243_Day5_Sleep3],1);
h_M243_Delta1=mean([h_M243_Day1_Delta1;h_M243_Day2_Delta1;h_M243_Day3_Delta1;h_M243_Day4_Delta1;h_M243_Day5_Delta1],1);
h_M243_Delta2=mean([h_M243_Day1_Delta2;h_M243_Day2_Delta2;h_M243_Day3_Delta2;h_M243_Day4_Delta2;h_M243_Day5_Delta2],1);
h_M244_All=mean([h_M244_Day1;h_M244_Day2;h_M244_Day3;h_M244_Day4;h_M244_Day5],1);
h_M244_Sleep1=mean([h_M244_Day1_Sleep1;h_M244_Day2_Sleep1;h_M244_Day3_Sleep1;h_M244_Day4_Sleep1;h_M244_Day5_Sleep1],1);
h_M244_Sleep2=mean([h_M244_Day1_Sleep2;h_M244_Day2_Sleep2;h_M244_Day3_Sleep2;h_M244_Day4_Sleep2;h_M244_Day5_Sleep2],1);
h_M244_Sleep3=mean([h_M244_Day1_Sleep3;h_M244_Day2_Sleep3;h_M244_Day3_Sleep3;h_M244_Day4_Sleep3;h_M244_Day5_Sleep3],1);
h_M244_Delta1=mean([h_M244_Day1_Delta1;h_M244_Day2_Delta1;h_M244_Day3_Delta1;h_M244_Day4_Delta1;h_M244_Day5_Delta1],1);
h_M244_Delta2=mean([h_M244_Day1_Delta2;h_M244_Day2_Delta2;h_M244_Day3_Delta2;h_M244_Day4_Delta2;h_M244_Day5_Delta2],1);

% Delta Burst distribution
hBurst_M243_All=mean([hBurst_M243_Day1;hBurst_M243_Day2;hBurst_M243_Day3;hBurst_M243_Day4;hBurst_M243_Day5],1);
try hBurst_M243_Sleep1=mean([hBurst_M243_Day1_Sleep1;hBurst_M243_Day2_Sleep1;hBurst_M243_Day3_Sleep1;hBurst_M243_Day4_Sleep1;hBurst_M243_Day5_Sleep1],1);
catch hBurst_M243_Sleep1=mean([hBurst_M243_Day1_Sleep1;hBurst_M243_Day3_Sleep1;hBurst_M243_Day5_Sleep1],1);
end
hBurst_M243_Sleep2=mean([hBurst_M243_Day1_Sleep2;hBurst_M243_Day2_Sleep2;hBurst_M243_Day3_Sleep2;hBurst_M243_Day4_Sleep2;hBurst_M243_Day5_Sleep2],1);
hBurst_M243_Sleep3=mean([hBurst_M243_Day1_Sleep3;hBurst_M243_Day2_Sleep3;hBurst_M243_Day3_Sleep3;hBurst_M243_Day4_Sleep3;hBurst_M243_Day5_Sleep3],1);
hBurst_M243_Delta1=mean([hBurst_M243_Day1_Delta1;hBurst_M243_Day2_Delta1;hBurst_M243_Day3_Delta1;hBurst_M243_Day4_Delta1;hBurst_M243_Day5_Delta1],1);
hBurst_M243_Delta2=mean([hBurst_M243_Day1_Delta2;hBurst_M243_Day2_Delta2;hBurst_M243_Day3_Delta2;hBurst_M243_Day4_Delta2;hBurst_M243_Day5_Delta2],1);

hBurst_M244_All=mean([hBurst_M244_Day1;hBurst_M244_Day2;hBurst_M244_Day3;hBurst_M244_Day4;hBurst_M244_Day5],1);
hBurst_M244_Sleep1=mean([hBurst_M244_Day1_Sleep1;hBurst_M244_Day2_Sleep1;hBurst_M244_Day3_Sleep1;hBurst_M244_Day4_Sleep1;hBurst_M244_Day5_Sleep1],1);
hBurst_M244_Sleep2=mean([hBurst_M244_Day1_Sleep2;hBurst_M244_Day2_Sleep2;hBurst_M244_Day3_Sleep2;hBurst_M244_Day4_Sleep2;hBurst_M244_Day5_Sleep2],1);
hBurst_M244_Sleep3=mean([hBurst_M244_Day1_Sleep3;hBurst_M244_Day2_Sleep3;hBurst_M244_Day3_Sleep3;hBurst_M244_Day4_Sleep3;hBurst_M244_Day5_Sleep3],1);
hBurst_M244_Delta1=mean([hBurst_M244_Day1_Delta1;hBurst_M244_Day2_Delta1;hBurst_M244_Day3_Delta1;hBurst_M244_Day4_Delta1;hBurst_M244_Day5_Delta1],1);
hBurst_M244_Delta2=mean([hBurst_M244_Day1_Delta2;hBurst_M244_Day2_Delta2;hBurst_M244_Day3_Delta2;hBurst_M244_Day4_Delta2;hBurst_M244_Day5_Delta2],1);

% Delta Burst Quantity
Burst_M243=[mean(hBurst_M243_Sleep1(1:30),2);mean(hBurst_M243_Delta1(1:30),2);mean(hBurst_M243_Sleep2(1:30),2);mean(hBurst_M243_Delta1(1:30),2);mean(hBurst_M243_Sleep3(1:30),2)];
Burst_M244=[mean(hBurst_M244_Sleep1(1:30),2);mean(hBurst_M244_Delta1(1:30),2);mean(hBurst_M244_Sleep2(1:30),2);mean(hBurst_M244_Delta1(1:30),2);mean(hBurst_M244_Sleep3(1:30),2)];

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                                     PLOT ALL THAT
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
plo=0;
if plo==1
    figure('color',[1 1 1]),
    subplot(2,5,1), plot(b1,smooth(h1a,3),'k','linewidth',2), hold on, plot(b2,smooth(h2a,3),'r'), xlim([0 3])
    title([struct,'Delta M244 Day1'])
    line([0.3 0.3],[0 250])
    line([0.48 0.48],[0 250])
    line([0.65 0.65],[0 250])
    line([0.85 0.85],[0 250])
    subplot(2,5,2), plot(b1,smooth(h1b,3),'k','linewidth',2), hold on, plot(b2,smooth(h2b,3),'r'), xlim([0 3])
    title([struct,'Delta M244 Day2'])
    line([0.3 0.3],[0 250])
    line([0.48 0.48],[0 250])
    line([0.65 0.65],[0 250])
    line([0.85 0.85],[0 250])
    subplot(2,5,3),  plot(b1,smooth(h1c,3),'k','linewidth',2), hold on, plot(b2,smooth(h2c,3),'r'), xlim([0 3])
    title([struct,'Delta M244 Day3'])
    line([0.3 0.3],[0 250])
    line([0.48 0.48],[0 250])
    line([0.65 0.65],[0 250])
    line([0.85 0.85],[0 250])
    subplot(2,5,4),  plot(b1,smooth(h1d,3),'k','linewidth',2), hold on, plot(b2,smooth(h2d,3),'r'), xlim([0 3])
    title([struct,'Delta M244 Day4'])
    line([0.3 0.3],[0 250])
    line([0.48 0.48],[0 250])
    line([0.65 0.65],[0 250])
    line([0.85 0.85],[0 250])
    subplot(2,5,5),  plot(b1,smooth(h1e,3),'k','linewidth',2), hold on, plot(b2,smooth(h2e,3),'r'), xlim([0 3])
    title([struct,'Delta M244 Day5'])
    line([0.3 0.3],[0 250])
    line([0.48 0.48],[0 250])
    line([0.65 0.65],[0 250])
    line([0.85 0.85],[0 250])
    
    subplot(2,5,6),  plot(b1,smooth(h1f,3),'k','linewidth',2), hold on, plot(b2,smooth(h2f,3),'r'), xlim([0 3])
    title([struct,'Delta M243 Day1'])
    line([0.3 0.3],[0 250])
    line([0.48 0.48],[0 250])
    line([0.65 0.65],[0 250])
    line([0.85 0.85],[0 250])
    subplot(2,5,7),  plot(b1,smooth(h1g,3),'k','linewidth',2), hold on, plot(b2,smooth(h2g,3),'r'), xlim([0 3])
    title([struct,'Delta M243 Day1'])
    line([0.3 0.3],[0 250])
    line([0.48 0.48],[0 250])
    line([0.65 0.65],[0 250])
    line([0.85 0.85],[0 250])
    subplot(2,5,8),  plot(b1,smooth(h1h,3),'k','linewidth',2), hold on, plot(b2,smooth(h2h,3),'r'), xlim([0 3])
    title([struct,'Delta M243 Day3'])
    line([0.3 0.3],[0 250])
    line([0.48 0.48],[0 250])
    line([0.65 0.65],[0 250])
    line([0.85 0.85],[0 250])
    subplot(2,5,9),  plot(b1,smooth(h1i,3),'k','linewidth',2), hold on, plot(b2,smooth(h2i,3),'r'), xlim([0 3])
    title([struct,'Delta M243 Day4'])
    line([0.3 0.3],[0 250])
    line([0.48 0.48],[0 250])
    line([0.65 0.65],[0 250])
    line([0.85 0.85],[0 250])
    subplot(2,5,10),  plot(b1,smooth(h1j,3),'k','linewidth',2), hold on, plot(b2,smooth(h2j,3),'r'), xlim([0 3])
    title([struct,'Delta M243 Day5'])
    line([0.3 0.3],[0 250])
    line([0.48 0.48],[0 250])
    line([0.65 0.65],[0 250])
    line([0.85 0.85],[0 250])
end

