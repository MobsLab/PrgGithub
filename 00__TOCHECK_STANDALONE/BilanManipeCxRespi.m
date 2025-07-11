%
idxx=20:2020;

ResT=[];
Hs=[];
Hr=[];
Hw=[];
HsdKO=[];
HrdKO=[];
HwdKO=[];
a=1;
b=1;

% load LFPData RespiTSD
% load StateEpoch
% [zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(RespiTSD,[3.4*1E-3,10]);
% Res=[mean(Data(Restrict(zeroCrossTsd,SWSEpoch))) mean(Data(Restrict(zeroCrossTsd,REMEpoch))) mean(Data(Restrict(zeroCrossTsd,MovEpoch)))];
% ResT=[ResT;Res];

cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse051
load LFPData RespiTSD LFP
load StateEpoch
pwd
[zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(RespiTSD,[3.4*1E-3,10]);
Res=[mean(Data(Restrict(AmplitudeRespi,SWSEpoch))) mean(Data(Restrict(AmplitudeRespi,REMEpoch))) mean(Data(Restrict(AmplitudeRespi,MovEpoch)))];
ResT=[ResT;Res];

hs=hist(Data(Restrict(AmplitudeRespi,SWSEpoch)),[-0.05:0.001:0.25]);
Hs=hs;
hr=hist(Data(Restrict(AmplitudeRespi,REMEpoch)),[-0.05:0.001:0.25]);
Hr=hr;
hw=hist(Data(Restrict(AmplitudeRespi,MovEpoch)),[-0.05:0.001:0.25]);
Hw=hw;

rg=Range(zeroCrossTsd,'s');
tps=rg(1:2:end);
tps2=rg(2:2:end);
if length(tps)>length(tps2)
  tps=tps(end-1);  
end
% diftps=tps(2:end)-tps2(1:end-1);

[M{a,1},Mo{a,1},Mf{a,1},Ms{a,1},tpss,id{a,1}]=EffectRespiLFPBulb(RespiTSD,tps2,SWSEpoch,0,idxx);
[M{a,2},Mo{a,2},Mf{a,2},Ms{a,2},tpss,id{a,2}]=EffectRespiLFPBulb(RespiTSD,tps2,REMEpoch,0,idxx);
[M{a,3},Mo{a,3},Mf{a,3},Ms{a,3},tpss,id{a,3}]=EffectRespiLFPBulb(RespiTSD,tps2,MovEpoch,0,idxx);
% save BilanManipeCxRespi
a=a+1;

cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse060
load LFPData RespiTSD LFP
load StateEpoch
pwd
[zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(RespiTSD,[3.4*1E-3,10]);
Res=[mean(Data(Restrict(AmplitudeRespi,SWSEpoch))) mean(Data(Restrict(AmplitudeRespi,REMEpoch))) mean(Data(Restrict(AmplitudeRespi,MovEpoch)))];
ResT=[ResT;Res];

hs=hist(Data(Restrict(AmplitudeRespi,SWSEpoch)),[-0.05:0.001:0.25]);
Hs=Hs+hs;
hr=hist(Data(Restrict(AmplitudeRespi,REMEpoch)),[-0.05:0.001:0.25]);
Hr=Hr+hr;
hw=hist(Data(Restrict(AmplitudeRespi,MovEpoch)),[-0.05:0.001:0.25]);
Hw=Hw+hw;

rg=Range(zeroCrossTsd,'s');
tps=rg(1:2:end);
tps2=rg(2:2:end);
if length(tps)>length(tps2)
  tps=tps(end-1);  
end
% diftps=tps(2:end)-tps2(1:end-1);

[M{a,1},Mo{a,1},Mf{a,1},Ms{a,1},tpss,id{a,1}]=EffectRespiLFPBulb(RespiTSD,tps2,SWSEpoch,0,idxx);
[M{a,2},Mo{a,2},Mf{a,2},Ms{a,2},tpss,id{a,2}]=EffectRespiLFPBulb(RespiTSD,tps2,REMEpoch,0,idxx);
[M{a,3},Mo{a,3},Mf{a,3},Ms{a,3},tpss,id{a,3}]=EffectRespiLFPBulb(RespiTSD,tps2,MovEpoch,0,idxx);

[M2{b,1},Mo2{b,1},Mf2{b,1},Ms2{b,1},tpss2,id2{b,1}]=EffectRespiLFPBulb(LFP{10},tps2,SWSEpoch,0,idxx);
[M2{b,2},Mo2{b,2},Mf2{b,2},Ms2{b,2},tpss2,id2{b,2}]=EffectRespiLFPBulb(LFP{10},tps2,REMEpoch,0,idxx);
[M2{b,3},Mo2{b,3},Mf2{b,3},Ms2{b,3},tpss2,id2{b,3}]=EffectRespiLFPBulb(LFP{10},tps2,MovEpoch,0,idxx);
% save BilanManipeCxRespi
a=a+1;
b=b+1;

cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse061
load LFPData RespiTSD LFP
load StateEpoch
pwd
[zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(RespiTSD,[3.4*1E-3,10]);
Res=[mean(Data(Restrict(AmplitudeRespi,SWSEpoch))) mean(Data(Restrict(AmplitudeRespi,REMEpoch))) mean(Data(Restrict(AmplitudeRespi,MovEpoch)))];
ResT=[ResT;Res];
hs=hist(Data(Restrict(AmplitudeRespi,SWSEpoch)),[-0.05:0.001:0.25]);
Hs=Hs+hs;
hr=hist(Data(Restrict(AmplitudeRespi,REMEpoch)),[-0.05:0.001:0.25]);
Hr=Hr+hr;
hw=hist(Data(Restrict(AmplitudeRespi,MovEpoch)),[-0.05:0.001:0.25]);
Hw=Hw+hw;

rg=Range(zeroCrossTsd,'s');
tps=rg(1:2:end);
tps2=rg(2:2:end);
if length(tps)>length(tps2)
  tps=tps(end-1);  
end
% diftps=tps(2:end)-tps2(1:end-1);

[M{a,1},Mo{a,1},Mf{a,1},Ms{a,1},tpss,id{a,1}]=EffectRespiLFPBulb(RespiTSD,tps2,SWSEpoch,0,idxx);
[M{a,2},Mo{a,2},Mf{a,2},Ms{a,2},tpss,id{a,2}]=EffectRespiLFPBulb(RespiTSD,tps2,REMEpoch,0,idxx);
[M{a,3},Mo{a,3},Mf{a,3},Ms{a,3},tpss,id{a,3}]=EffectRespiLFPBulb(RespiTSD,tps2,MovEpoch,0,idxx);

[M2{b,1},Mo2{b,1},Mf2{b,1},Ms2{b,1},tpss2,id2{b,1}]=EffectRespiLFPBulb(LFP{13},tps2,SWSEpoch,0,idxx);
[M2{b,2},Mo2{b,2},Mf2{b,2},Ms2{b,2},tpss2,id2{b,2}]=EffectRespiLFPBulb(LFP{13},tps2,REMEpoch,0,idxx);
[M2{b,3},Mo2{b,3},Mf2{b,3},Ms2{b,3},tpss2,id2{b,3}]=EffectRespiLFPBulb(LFP{13},tps2,MovEpoch,0,idxx);
% save BilanManipeCxRespi
a=a+1;
b=b+1;

cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse054\Cx
load LFPData RespiTSD LFP
load StateEpoch
pwd
[zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(RespiTSD,[3.4*1E-3,10]);
Res=[mean(Data(Restrict(AmplitudeRespi,SWSEpoch))) mean(Data(Restrict(AmplitudeRespi,REMEpoch))) mean(Data(Restrict(AmplitudeRespi,MovEpoch)))];
ResT=[ResT;Res];
hs=hist(Data(Restrict(AmplitudeRespi,SWSEpoch)),[-0.05:0.001:0.25]);
HsdKO=hs;
hr=hist(Data(Restrict(AmplitudeRespi,REMEpoch)),[-0.05:0.001:0.25]);
HrdKO=hr;
hw=hist(Data(Restrict(AmplitudeRespi,MovEpoch)),[-0.05:0.001:0.25]);
HwdKO=hw;

rg=Range(zeroCrossTsd,'s');
tps=rg(1:2:end);
tps2=rg(2:2:end);
if length(tps)>length(tps2)
  tps=tps(end-1);  
end

%diftps=tps(2:end)-tps2(1:end-1);
% diftps=tps(2:end-1)-tps2(1:end-1);

[M{a,1},Mo{a,1},Mf{a,1},Ms{a,1},tpss,id{a,1}]=EffectRespiLFPBulb(RespiTSD,tps,SWSEpoch,0,idxx);
[M{a,2},Mo{a,2},Mf{a,2},Ms{a,2},tpss,id{a,2}]=EffectRespiLFPBulb(RespiTSD,tps2,REMEpoch,0,idxx);
[M{a,3},Mo{a,3},Mf{a,3},Ms{a,3},tpss,id{a,3}]=EffectRespiLFPBulb(RespiTSD,tps2,MovEpoch,0,idxx);
% save BilanManipeCxRespi
a=a+1;

cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse065
load LFPData RespiTSD LFP
load StateEpoch
pwd
[zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(RespiTSD,[3.4*1E-3,10]);
Res=[mean(Data(Restrict(AmplitudeRespi,SWSEpoch))) mean(Data(Restrict(AmplitudeRespi,REMEpoch))) mean(Data(Restrict(AmplitudeRespi,MovEpoch)))];
ResT=[ResT;Res];
hs=hist(Data(Restrict(AmplitudeRespi,SWSEpoch)),[-0.05:0.001:0.25]);
HsdKO=HsdKO+hs;
hr=hist(Data(Restrict(AmplitudeRespi,REMEpoch)),[-0.05:0.001:0.25]);
HrdKO=HrdKO+hr;
hw=hist(Data(Restrict(AmplitudeRespi,MovEpoch)),[-0.05:0.001:0.25]);
HwdKO=HwdKO+hw;

rg=Range(zeroCrossTsd,'s');
tps=rg(1:2:end);
tps2=rg(2:2:end);
if length(tps)>length(tps2)
  tps=tps(end-1);  
end
% diftps=tps(2:end)-tps2(1:end-1);

[M{a,1},Mo{a,1},Mf{a,1},Ms{a,1},tpss,id{a,1}]=EffectRespiLFPBulb(RespiTSD,tps2,SWSEpoch,0,idxx);
[M{a,2},Mo{a,2},Mf{a,2},Ms{a,2},tpss,id{a,2}]=EffectRespiLFPBulb(RespiTSD,tps2,REMEpoch,0,idxx);
[M{a,3},Mo{a,3},Mf{a,3},Ms{a,3},tpss,id{a,3}]=EffectRespiLFPBulb(RespiTSD,tps2,MovEpoch,0,idxx);


[M2{b,1},Mo2{b,1},Mf2{b,1},Ms2{b,1},tpss2,id2{b,1}]=EffectRespiLFPBulb(LFP{13},tps2,SWSEpoch,0,idxx);
[M2{b,2},Mo2{b,2},Mf2{b,2},Ms2{b,2},tpss2,id2{b,2}]=EffectRespiLFPBulb(LFP{13},tps2,REMEpoch,0,idxx);
[M2{b,3},Mo2{b,3},Mf2{b,3},Ms2{b,3},tpss2,id2{b,3}]=EffectRespiLFPBulb(LFP{13},tps2,MovEpoch,0,idxx);
% save BilanManipeCxRespi
a=a+1;
b=b+1;

cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro\DataPlethysmo\Mouse066
load LFPData RespiTSD LFP
load StateEpoch
pwd
[zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(RespiTSD,[3.4*1E-3,10]);
Res=[mean(Data(Restrict(AmplitudeRespi,SWSEpoch))) mean(Data(Restrict(AmplitudeRespi,REMEpoch))) mean(Data(Restrict(AmplitudeRespi,MovEpoch)))];
ResT=[ResT;Res];
hs=hist(Data(Restrict(AmplitudeRespi,SWSEpoch)),[-0.05:0.001:0.25]);
HsdKO=HsdKO+hs;
hr=hist(Data(Restrict(AmplitudeRespi,REMEpoch)),[-0.05:0.001:0.25]);
HrdKO=HrdKO+hr;
hw=hist(Data(Restrict(AmplitudeRespi,MovEpoch)),[-0.05:0.001:0.25]);
HwdKO=HwdKO+hw;

rg=Range(zeroCrossTsd,'s');
tps=rg(1:2:end);
tps2=rg(2:2:end);

if length(tps)>length(tps2)
  tps=tps(end-1);  
end
% diftps=tps(2:end)-tps2(1:end-1);
[M{a,1},Mo{a,1},Mf{a,1},Ms{a,1},tpss,id{a,1}]=EffectRespiLFPBulb(RespiTSD,tps2,SWSEpoch,0,idxx);
[M{a,2},Mo{a,2},Mf{a,2},Ms{a,2},tpss,id{a,2}]=EffectRespiLFPBulb(RespiTSD,tps2,REMEpoch,0,idxx);
[M{a,3},Mo{a,3},Mf{a,3},Ms{a,3},tpss,id{a,3}]=EffectRespiLFPBulb(RespiTSD,tps2,MovEpoch,0,idxx);

[M2{b,1},Mo2{b,1},Mf2{b,1},Ms2{b,1},tpss2,id2{b,1}]=EffectRespiLFPBulb(LFP{10},tps2,SWSEpoch,0,idxx);
[M2{b,2},Mo2{b,2},Mf2{b,2},Ms2{b,2},tpss2,id2{b,2}]=EffectRespiLFPBulb(LFP{10},tps2,REMEpoch,0,idxx);
[M2{b,3},Mo2{b,3},Mf2{b,3},Ms2{b,3},tpss2,id2{b,3}]=EffectRespiLFPBulb(LFP{10},tps2,MovEpoch,0,idxx);
% save BilanManipeCxRespi
a=a+1;
b=b+1;

ResT

figure('color',[1 1 1])
subplot(1,3,1),PlotErrorBar2(ResT(1:3,1),ResT(4:6,2),0),yl1=ylim;title('SWS')
set(gca,'xtick',[1,2])
set(gca,'xticklabel',{'wt','dKO'})
subplot(1,3,2),PlotErrorBar2(ResT(1:3,2),ResT(4:6,2),0),yl2=ylim;title('REM')
set(gca,'xtick',[1,2])
set(gca,'xticklabel',{'wt','dKO'})
subplot(1,3,3),PlotErrorBar2(ResT(1:3,3),ResT(4:6,3),0),yl3=ylim;title('Wake')
set(gca,'xtick',[1,2])
set(gca,'xticklabel',{'wt','dKO'})
subplot(1,3,1),ylim([0  max([yl1(2) yl2(2) yl3(2)])])
subplot(1,3,2),ylim([0  max([yl1(2) yl2(2) yl3(2)])])
subplot(1,3,2),ylim([0  max([yl1(2) yl2(2) yl3(2)])])



figure('color',[1 1 1]),
subplot(2,1,1),hold on
plot([-0.05:0.001:0.25],smooth(Hs/max(Hs),3),'r','linewidth',2)
plot([-0.05:0.001:0.25],smooth(Hr/max(Hr),3),'k','linewidth',2)
plot([-0.05:0.001:0.25],smooth(Hw/max(Hw),3),'b','linewidth',2)
xlim([0 0.1]),title('wt')
subplot(2,1,2),hold on
plot([-0.05:0.001:0.25],smooth(HsdKO/max(HsdKO),3),'r','linewidth',2)
plot([-0.05:0.001:0.25],smooth(HrdKO/max(HrdKO),3),'k','linewidth',2)
plot([-0.05:0.001:0.25],smooth(HwdKO/max(HwdKO),3),'b','linewidth',2)
xlim([0 0.1]),title('dKO')


figure('color',[1 1 1]),
subplot(3,1,1),hold on
plot([-0.05:0.001:0.25],smooth(Hs/max(Hs),3),'k','linewidth',2)
plot([-0.05:0.001:0.25],smooth(HsdKO/max(HsdKO),3),'r','linewidth',2)
xlim([0 0.1]),title('SWS')
subplot(3,1,2),hold on
plot([-0.05:0.001:0.25],smooth(Hr/max(Hr),3),'k','linewidth',2)
plot([-0.05:0.001:0.25],smooth(HrdKO/max(HrdKO),3),'r','linewidth',2)
xlim([0 0.1]),title('REM')
subplot(3,1,3),hold on
plot([-0.05:0.001:0.25],smooth(Hw/max(Hw),3),'k','linewidth',2)
plot([-0.05:0.001:0.25],smooth(HwdKO/max(HwdKO),3),'r','linewidth',2)
xlim([0 0.1]),title('Wake')





figure('color',[1 1 1]), 
subplot(2,3,1), plot(tpss,-mean(Mo{1,1})),title('51 SWS'),ylim([-0.04 0.04]),xlim([-5000 6000]) %hold on plot(tpss,mean(M2{1,1}),'r'), title('')
subplot(2,3,2), plot(tpss,-mean(Mo{2,1})), hold on, plot(tpss2,50*mean(Mo2{1,1}),'r'), title('60'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,3), plot(tpss,-mean(Mo{3,1})), hold on, plot(tpss2,50*mean(Mo2{2,1}),'r'), title('61'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,4), plot(tpss,-mean(Mo{4,1})), title('54'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,5), plot(tpss,-mean(Mo{5,1})), hold on, plot(tpss2,50*mean(Mo2{3,1}),'r'), title('65'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,6), plot(tpss,-mean(Mo{6,1})), hold on, plot(tpss2,50*mean(Mo2{4,1}),'r'), title('66'),ylim([-0.04 0.04]),xlim([-5000 6000])

figure('color',[1 1 1]),  
subplot(2,3,1), plot(tpss,-mean(Mo{1,2})),title('51 REM'),ylim([-0.04 0.04]),xlim([-4000 6000]) %hold on plot(tpss,mean(M2{1,1}),'r'), title('')
subplot(2,3,2), plot(tpss,-mean(Mo{2,2})), hold on, plot(tpss2,50*mean(Mo2{1,2}),'r'), title('60'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,3), plot(tpss,-mean(Mo{3,2})), hold on, plot(tpss2,50*mean(Mo2{2,2}),'r'), title('61'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,4), plot(tpss,-mean(Mo{4,2})), title('54'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,5), plot(tpss,-mean(Mo{5,2})), hold on, plot(tpss2,50*mean(Mo2{3,2}),'r'), title('65'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,6), plot(tpss,-mean(Mo{6,2})), hold on, plot(tpss2,50*mean(Mo2{4,2}),'r'), title('66'),ylim([-0.04 0.04]),xlim([-5000 6000])


figure('color',[1 1 1]),  
subplot(2,3,1), plot(tpss,-mean(Mo{1,3})),title('51 Wake'),ylim([-0.04 0.04]),xlim([-5000 6000]) %hold on plot(tpss,mean(M2{1,1}),'r'), title('')
subplot(2,3,2), plot(tpss,-mean(Mo{2,3})), hold on, plot(tpss2,50*mean(Mo2{1,3}),'r'), title('60'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,3), plot(tpss,-mean(Mo{3,3})), hold on, plot(tpss2,50*mean(Mo2{2,3}),'r'), title('61'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,4), plot(tpss,-mean(Mo{4,3})), title('54'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,5), plot(tpss,-mean(Mo{5,3})), hold on, plot(tpss2(1:end-1),50*mean(Mo2{3,3}),'r'), title('65'),ylim([-0.04 0.04]),xlim([-5000 6000])
subplot(2,3,6), plot(tpss,-mean(Mo{6,3})), hold on, plot(tpss2,50*mean(Mo2{4,3}),'r'), title('66'),ylim([-0.04 0.04]),xlim([-5000 6000])



