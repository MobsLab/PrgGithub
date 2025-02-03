%-- Unknown date --%
t(f,SmoothDec(10*log10(S),10))
xlim([0 300])
figure, plot(f,SmoothDec(10*log10(S),40))
figure, plot(f(1:10:end),SmoothDec(10*log10(S(1:10:end)),3))
figure, plot(f(1:10:end),SmoothDec(10*log10(S(1:10:end)),10))
xlim([0 300])
xlim([0 30])
figure, plot(f(1:10:end),SmoothDec(10*log10(S(1:10:end)),3))
xlim([0 30])
dataREM=Data(Restrict(LFP{1},subset(REMEpoch,1)));
[S,f]=mtspectrumc(dataREM-mean(dataREM),params);
figure, plot(f,10*log10(S)), xlim([0 300])
params.tapers=[20 39];
[S,f]=mtspectrumc(dataREM-mean(dataREM),params);
figure, plot(f,10*log10(S)), xlim([0 300])
params.tapers=[3 5];
[S,f]=mtspectrumc(dataREM-mean(dataREM),params);
figure, plot(f,10*log10(S)), xlim([0 300])
xlim([0 30])
params.tapers=[10 19];
[S,f]=mtspectrumc(dataREM-mean(dataREM),params);
figure, plot(f,10*log10(S)), xlim([0 300])
xlim([0 30])
dataREM=Data(Restrict(LFP{1},subset(REMEpoch,2)));
[S,f]=mtspectrumc(dataREM-mean(dataREM),params);
figure, plot(f,10*log10(S)), xlim([0 300])
xlim([0 30])
dataREM=Data(Restrict(LFP{1},subset(REMEpoch,3)));
[S,f]=mtspectrumc(dataREM-mean(dataREM),params);
figure, plot(f,10*log10(S)), xlim([0 300])
xlim([0 30])
xlim([0 300])
mean(dataREM)
dataREM=Data(Restrict(LFP{1},subset(REMEpoch,4)));
[S,f]=mtspectrumc(dataREM-mean(dataREM),params);
figure, plot(f,10*log10(S)), xlim([0 300])
dataREM=Data(Restrict(LFP{1},subset(REMEpoch,3)));
[S,f]=mtspectrumc(dataREM-mean(dataREM),params);
figure, plot(f,10*log10(S)), xlim([0 300])
xlim([1 300])
xlim([2 300])
dataSWS=Data(Restrict(LFP{1},subset(SWSEpoch,3)));
[S,f]=mtspectrumc(dataREM-mean(dataSWS),params);
figure, plot(f,10*log10(S)), xlim([0 300])
[S,f]=mtspectrumc(dataSWS-mean(dataSWS),params);
figure, plot(f,10*log10(S)), xlim([0 300])
close all
params.tapers=[5 9];
[Ss,fs]=mtspectrumc(dataSWS-mean(dataSWS),params);
[Sr,fr]=mtspectrumc(dataREM-mean(dataREM),params);
figure, hold on, plot(fs,10*log10(Ss)),plot(fr,10*log10(Sr),'r'), xlim([0 300])
length(fs)
f=resample(f,1,100);
S=resample(S,1,100);
length(f)
figure, plot(f,10*log10(S)), xlim([0 300])
figure, plot(f,10*log10(smooth(S,4))), xlim([0 300])
figure, plot(f,10*log10(smooth(S,10))), xlim([0 300])
fs=resample(fs,1,100);
Ss=resample(Ss,1,100);
fr=resample(fr,1,100);
Sr=resample(Sr,1,100);
figure, hold on, plot(fs,10*log10(SmoothDec(Ss,3))),plot(fr,10*log10(SmoothDec(Sr,3)),'r'), xlim([0 300])
dataREM2=Data(Restrict(LFP{2},subset(REMEpoch,3)));
[Cr,fr]=coherencyc(dataREM,dataREM2,params);
figure, plot(fr,Cr)
help coherencyc
[Cr,phir,S12r,S1r,S2r,fr]=coherencyc(dataREM,dataREM2,params);
figure, plot(fr,Cr)
figure, plot(resample(fr,1,100),resample(Cr,1,100))
xlim([0 300])
figure, plot(resample(fr,1,100),resample(phir,1,100))
dataREM2=Data(Restrict(LFP{3},subset(REMEpoch,3)));
[Cr,phir,S12r,S1r,S2r,fr]=coherencyc(dataREM,dataREM2,params);
figure, plot(resample(fr,1,100),resample(Cr,1,100))
figure, plot(resample(fr,1,100),resample(phir,1,100))
xlim([0 300])
[c, v, n] = ft_connectivity_ppc(input, varargin)
edit ft_connectivity_ppc
LoadPATHKB
edit ft_connectivity_ppc
[c, v, n] = ft_connectivity_ppc(input, varargin)
LoadPATHKB
load('/Users/karimbenchenane/Dropbox/Kteam/PrgMatlab/coherence/data.mat')
close all
LFPt=LFP;
cd /Users/karimbenchenane/Documents/Data/DataEnCours/DataBulbCP/BULB-Mouse-51-10012013
load LFPAuCx
LFPt{4}=LFP{1};
LFPt{5}=LFP{2};
LFPt{6}=LFP{3};
dataSWS=Data(Restrict(LFP{1},subset(SWSEpoch,3)));
dataSWS2=Data(Restrict(LFP{5},subset(SWSEpoch,3)));
dataSWS=Data(Restrict(LFPt{1},subset(SWSEpoch,3)));
dataSWS2=Data(Restrict(LFPt{5},subset(SWSEpoch,3)));
[Cr,phir,S12r,S1r,S2r,fr]=coherencyc(dataSWS,dataSWS2,params);
figure, plot(resample(fr,1,100),resample(Cr,1,100))
xlim([0 250])
xlim([0 220])
figure, plot(resample(fr,1,100),resample(10*log10(S1r),1,100))
figure, plot(resample(fr,1,100),resample(10*log10(S1r),1,100)), xlim([0 220])
figure, plot(resample(fr,1,100),resample(10*log10(S2r),1,100)), xlim([0 220])
figure, plot(resample(fr,1,100),resample(10*log10(S1r),1,100)), xlim([0 220])
hold on, plot(resample(fr,1,100),resample(10*log10(S2r),1,100),'r'), xlim([0 220])
hold on, plot(resample(log10(fr),1,100),resample(10*log10(S2r),1,100),'r'), xlim([0 220])
figure, plot(resample(log10(fr),1,100),resample(10*log10(S1r),1,100)), xlim([0 220])
hold on, plot(resample(log10(fr),1,100),resample(10*log10(S2r),1,100),'r'), xlim([0 220])
hold on, plot(resample(log10(fr),1,100),resample(10*log10(S2r),1,100),'r'), xlim([0 22])
hold on, plot(resample(log10(fr),1,100),resample(10*log10(S2r),1,100),'r'), xlim([0 5])
figure, plot(resample(10*log10(fr),1,100),resample(10*log10(S1r),1,100)), xlim([0 220])
hold on, plot(resample(10*log10(fr),1,100),resample(10*log10(S2r),1,100),'r'), xlim([0 5])
hold on, plot(resample(10*log10(fr),1,100),resample(10*log10(S2r),1,100),'r'), xlim([0 50])
params.tapers=[3 5];
[Cr,phir,S12r,S1r,S2r,fr]=coherencyc(dataSWS,dataSWS2,params);
figure, plot(resample(10*log10(fr),1,100),resample(10*log10(S1r),1,100)), xlim([0 220])
hold on, plot(resample(10*log10(fr),1,100),resample(10*log10(S2r),1,100),'r'), xlim([0 50])
params.tapers=[10 19];
[Cr,phir,S12r,S1r,S2r,fr]=coherencyc(dataSWS,dataSWS2,params);
figure, plot(resample(10*log10(fr),1,100),resample(10*log10(S1r),1,100)), xlim([0 220])
hold on, plot(resample(10*log10(fr),1,100),resample(10*log10(S2r),1,100),'r'), xlim([0 50])
dataSWS2=Data(Restrict(LFPt{6},subset(SWSEpoch,3)));
[Cr,phir,S12r,S1r,S2r,fr]=coherencyc(dataSWS,dataSWS2,params);
figure, plot(resample(fr,1,100),resample(Cr,1,100))
xlim([0 220])
figure, plot(resample(fr,1,100),SmoothDec(resample(Cr,1,100),3))
xlim([0 220])
figure, plot(resample(fr,1,100),SmoothDec(resample(Cr,1,100),2))
xlim([0 220])
figure, plot(resample(fr,1,10),SmoothDec(resample(Cr,1,10),2))
xlim([0 220])
params.tapers=[30 59];
[Cr,phir,S12r,S1r,S2r,fr]=coherencyc(dataSWS,dataSWS2,params);
figure, plot(resample(fr,1,10),SmoothDec(resample(Cr,1,10),2))
xlim([0 220])
figure, plot(resample(fr,1,10),SmoothDec(resample(Cr,1,10),10))
xlim([0 220])
figure, plot(resample(fr,1,100),SmoothDec(resample(Cr,1,100),2))
xlim([0 220])
figure, plot(resample(fr,1,100),SmoothDec(resample(Cr,1,100),4))
xlim([0 220])
%-- 23/02/13 20:59 --%
LoadPATHKB
FiringRateRemapping
clear
FigureSuppREactivationMFB
PlaceField(Restrict(S{3},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
clear
load SpikeData
load behavResources
NeuronNum=6;
SessionPlaceCells=[7 9 11];
EpochCtrl1=intervalSet(tpsdeb{7}*1E4,tpsfin{7}*1E4);
EpochCtrl2=intervalSet(tpsdeb{9}*1E4,tpsfin{9}*1E4);
EpochCtrl=or(EpochCtrl1,EpochCtrl2);
EpochCtrl3=intervalSet(tpsdeb{11}*1E4,tpsfin{11}*1E4);
EpochCtrl=or(EpochCtrl,EpochCtrl3);
EpochSleep=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);
PlaceField(Restrict(S{7},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
PlaceField(Restrict(S{6},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
PlaceField(Restrict(S{8},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
PlaceField(Restrict(S{9},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
close all
PlaceField(Restrict(S{6},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
PlaceField(Restrict(S{19},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
PlaceField(Restrict(S{2},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
cd([filename,'Mouse035/20120515'])
clear
filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd([filename,'Mouse035/20120515'])
load behavResources
namePos'
cd([filename,'Mouse042/20120801'])
load behavResources
namePos'
clear
close all
cd([filename,'Mouse035/20120515'])
load behavResources
load stimMFB
load SpikeData
NeuronNum=23;
SessionPlaceCells=[3 4];
EpochCtrl=intervalSet(tpsdeb{3}*1E4,tpsfin{4}*1E4);
%EpochSleep=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);
EpochSleep=intervalSet(tpsdeb{7}*1E4,tpsfin{9}*1E4);
filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd([filename,'Mouse035/20120515'])
load behavResources
load stimMFB
load SpikeData
NeuronNum=23;
SessionPlaceCells=[3 4];
EpochCtrl=intervalSet(tpsdeb{3}*1E4,tpsfin{4}*1E4);
%EpochSleep=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);
EpochSleep=intervalSet(tpsdeb{7}*1E4,tpsfin{9}*1E4);
for a=1:length(S)
param1=20;param2=200;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);
% figure('color',[1 1 1]), hold on, bar(Bwa,Cwa,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Wake ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])
% PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
% PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
param1=5;param2=100;
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2);
% figure('color',[1 1 1]), hold on, bar(Bsl,Csl,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Sleep ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])
CrSl(b,1)=mean(Csl([[1:20],[80:100]]));
CrSl(b,2)=mean(Csl([40:60]));
CrSl(b,3)=a;
Crwa(b,1)=mean(Cwa([[1:50],[150:200]]));
Crwa(b,2)=mean(Cwa([98:102]));
Crwa(b,3)=a;
b=b+1;
close all
end
b=1;
for a=1:length(S)
param1=20;param2=200;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);
% figure('color',[1 1 1]), hold on, bar(Bwa,Cwa,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Wake ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])
% PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
% PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
param1=5;param2=100;
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2);
% figure('color',[1 1 1]), hold on, bar(Bsl,Csl,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Sleep ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])
CrSl(b,1)=mean(Csl([[1:20],[80:100]]));
CrSl(b,2)=mean(Csl([40:60]));
CrSl(b,3)=a;
Crwa(b,1)=mean(Cwa([[1:50],[150:200]]));
Crwa(b,2)=mean(Cwa([98:102]));
Crwa(b,3)=a;
b=b+1;
close all
end
for a=1:length(S)
param1=20;param2=200;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);
% figure('color',[1 1 1]), hold on, bar(Bwa,Cwa,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Wake ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])
% PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
% PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
param1=5;param2=100;
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2);
% figure('color',[1 1 1]), hold on, bar(Bsl,Csl,1,'k'), yl=ylim; line([0 0],yl,'color','r'), xlim([-param1*param2/2 param1*param2/2]), title(['CrossCorrelogram Sleep ', cellnames{NeuronNum}, ' vs. ', cellnames{a}])
CrSl(b,1)=mean(Csl([[1:20],[80:100]]));
CrSl(b,2)=mean(Csl([40:60]));
CrSl(b,3)=a;
Crwa(b,1)=mean(Cwa([[1:50],[150:200]]));
Crwa(b,2)=mean(Cwa([98:102]));
Crwa(b,3)=a;
b=b+1;
close all
end
edit FigureSuppREactivationMFB
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{2},EpochCtrl)),param1,param2);
figure, plot(Bwa,Cwa)
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{3},EpochCtrl)),param1,param2);
figure, plot(Bwa,Cwa)
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{3},EpochCtrl)),param1,param2);figure, plot(Bwa,Cwa)
a
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{3},EpochCtrl)),param1,param2);figure, plot(Bwa,Cwa)
close all
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{3},EpochCtrl)),param1,param2);plot(Bwa,Cwa)
NeuronNum
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa)
a=3;
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa)
a
PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
PlaceField(Restrict(S{NumNeuron},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
map=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
figure, imagesc(map.rate)
figure('color',[1 1 1]), imagesc(map.rate), axis xy
mapN=PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
figure('color',[1 1 1]), imagesc(mapN.rate), axis xy
figure('color',[1 1 1]), plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bwa,smooth(Cwa,3)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bsl,smooth(Csl,3)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bwa,smooth(Cwa,3)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
hold on , plot(Bsl,smooth(Csl,3)','r','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
param1=5;param2=200;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bwa,smooth(Cwa,3)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bsl,smooth(Csl,3)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
close all
figure('color',[1 1 1]), plot(Bsl/10,smooth(Csl,3)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bwa/10,smooth(Cwa,3)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
close all
figure('color',[1 1 1]), plot(Bsl,smooth(Csl,3)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bwa,smooth(Cwa,3)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
param1=20;param2=200;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
param1=5;param2=200;
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bwa,smooth(Cwa,3)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bsl,smooth(Csl,3)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bsl,smooth(Csl,5)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bsl,smooth(Csl,0.1)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bsl,smooth(Csl,0)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bsl,smooth(Csl,1)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
param1=5;param2=100;
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bsl,smooth(Csl,1)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), plot(Bwa,smooth(Cwa,0.1)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure, imagesc(map.rate)
figure('color',[1 1 1]), imagesc(map.rate), axis xy
figure('color',[1 1 1]), imagesc(mapN.rate), axis xy
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]), imagesc(mapN.rate), axis xy
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
a
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
a=1;
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
a=a+1; [Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
a
figure('color',[1 1 1]), imagesc(map2.rate), axis xy
figure('color',[1 1 1]), imagesc(map.rate), axis xy
edit saveFigure
%-- 25/02/13 15:29 --%
LoadPATHKB




a=10;
smo=10;
param1=20;param2=200;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake')
figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep')
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake')
figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep')

smo=5;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake')
figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep')
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake')
figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep')

smo=10;
param1=5;param2=600;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake')
figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep')
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake')
figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep')

smo=5;
[Cwa,Bwa]=CrossCorr(Range(Restrict(S{NeuronNum},EpochCtrl)),Range(Restrict(S{a},EpochCtrl)),param1,param2);%plot(Bwa,Cwa','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
[Csl,Bsl]=CrossCorr(Range(Restrict(S{NeuronNum},EpochSleep)),Range(Restrict(S{a},EpochSleep)),param1,param2); %figure, plot(Bsl,Csl','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r')
figure('color',[1 1 1]),  plot(Bwa,smooth(Cwa,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('wake')
figure('color',[1 1 1]),  plot(Bsl,smooth(Csl,smo)','k','linewidth',2), yl=ylim; line([0 0],yl,'color','r'), title('sleep')
figure('color',[1 1 1]),  bar(Bwa,smooth(Cwa,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('wake')
figure('color',[1 1 1]),  bar(Bsl,smooth(Csl,smo),1,'k'), yl=ylim; line([0 0],yl,'color','r'), title('sleep')


map=PlaceField(Restrict(S{NeuronNum},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));close
map2=PlaceField(Restrict(S{a},EpochCtrl), Restrict(X,EpochCtrl),Restrict(Y,EpochCtrl));close
figure('color',[1 1 1]), imagesc(map2.rate), axis xy
figure('color',[1 1 1]), imagesc(map.rate), axis xy


