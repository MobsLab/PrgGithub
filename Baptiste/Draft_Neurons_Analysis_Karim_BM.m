
%% Karim's draft neurons

load('SpikeData.mat')
D=Data(S);
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPost/LFPData/LFP2.mat')
load('SpikeCorrected.mat')
load('StateEpochSB.mat')
edit ThetaPhase.m
edit ModulationThetaCorrection.m
Fil=FilterLFP(LFP,[5 12],1024);
[ph,mu, Kappa,pval,B,C]=ModulationTheta(S{1},Fil,REMEpoch,30,1);, JustPoltMod(Data(ph{1}),30);
[ph,mu, Kappa,pval,B,C]=ModulationTheta(S{1},Fil,REMEpoch,30,1);, JustPoltMod(Data(ph),30);
edit ModulationTheta
rmpath('/home/mobsrick/Dropbox/Kteam/PrgMatlab/FMAToolbox/General/');
rmpath('/home/mobsrick/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats/');
rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats/');
ls
rmpath('/home/Gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats/');
edit LoadPATHGV.m
addpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab')
addpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/MatFilesMarie')
rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats/');
rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats');
[ph,mu, Kappa,pval,B,C]=ModulationTheta(S{1},Fil,REMEpoch,30,1);, JustPoltMod(Data(ph),30);
[phaseTsd, ph] = firingPhaseHilbert(Fil, Restrict(S{1}, REMEpoch)) ;
ph
[phaseTsd, ph] = firingPhaseHilbert(Fil, Restrict(S{2}, REMEpoch)) ;
ph
length(RAnge(Restrict(S{2}, REMEpoch)))
length(Range(Restrict(S{2}, REMEpoch)))
RasterPlot(S)
Start(REMEpoch)
load('SpikeData.mat')
length(Range(Restrict(S{2}, REMEpoch)))
[ph,mu, Kappa,pval,B,C]=ModulationTheta(S{1},Fil,REMEpoch,30,1);, JustPoltMod(Data(ph{1}),30);
k=2; k=k+1;[ph,mu, Kappa,pval,B,C]=ModulationThetaCorrection(S{k},Fil,REMEpoch,30,1);, clf, JustPoltMod(Data(ph{1}),30);
k=2; k=k+1;[ph,mu, Kappa,pval,B,C]=ModulationThetaCorrection(S{k},Fil,REMEpoch,30);, clf, JustPoltMod(Data(ph{1}),30);
k=k+1;[ph,mu, Kappa,pval,B,C]=ModulationThetaCorrection(S{k},Fil,REMEpoch,30);, clf, JustPoltMod(Data(ph{1}),30);
k=k+1;[ph,mu, Kappa,pval,B,C]=ModulationTheta(S{k},Fil,REMEpoch,30,1);, clf, JustPoltMod(Data(ph{1}),30);
k
k=k+1;[ph,mu, Kappa,pval,B,C]=ModulationTheta(S{k},Fil,REMEpoch,30,1);, clf, JustPoltMod(Data(ph{1}),30);
LFPh=LFP;
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPost/LFPData/LFP28.mat')
Fil2=FilterLFP(LFP,[2 5],1024);
edit JustPoltMod
k=k+1;[ph,mu, Kappa,pval,B,C]=ModulationTheta(S{k},Fil,REMEpoch,30,1);
k
k=0;
k=k+1;[ph,mu, Kappa,pval,B,C]=ModulationTheta(S{k},Fil2,REMEpoch,30,1);
k=k+1;[ph,mu, Kappa,pval,B,C]=ModulationTheta(S{k},Fil2,REMEpoch,20,1);
load('H_Low_Spectrum.mat')
SpH=tsd(Spectro{2}*1E4,Spectro{1});
f=Spectro{3};
figure, plot(f,mean(Data(Restrict(SpH,REMEpoch))))
load('PFCx_Low_Spectrum.mat')
SpP=tsd(Spectro{2}*1E4,Spectro{1});
figure, plot(f,mean(Data(Restrict(SpP,REMEpoch))))
k=11;
k=k+1;[ph,mu, Kappa,pval,B,C]=ModulationTheta(S{k},Fil,REMEpoch,20,1);
[ph,mu, Kappa,pval,B,C]=ModulationTheta(S{k},Fil2,REMEpoch,20,1);
edit RayleighFreq_SB.m
[HS,Ph,ModTheta]=RayleighFreq_SB(LFPh,S{1});
[HS,Ph,ModTheta]=RayleighFreq_SB(LFPh,S{1},'doplot',1,'plotCtrl',1);
[HS,Ph,ModTheta]=RayleighFreq_SB(LFPh,S{1},'doplot',1);
[HS,Ph,ModTheta]=RayleighFreq_SB(LFPh,S{12},'doplot',1);
[HS,Ph,ModTheta]=RayleighFreq_SB(LFP,S{12},'doplot',1);
ModTheta
ModTheta.pval
ModTheta.pval.Transf
ModTheta.pval.Transf*1000
ModTheta.pval.Transfw0.05
ModTheta.pval.Transf<0.05
ModTheta.pval.NonTransf<0.05
ModTheta.pval.Nontransf<0.05
figure, imagesc(HS)
[HS,Ph,ModTheta]=RayleighFreq_SB(LFPh,Restrict(S{12},REMEpoch),'doplot',1);
ModTheta.pval.Nontransf<0.05
ModTheta.pval.Transf<0.05
ModTheta.pval.Transf
[HS,Ph,ModTheta]=RayleighFreq_SB(LFP,Restrict(S{12},REMEpoch),'doplot',1);
[HS,Ph,ModTheta]=RayleighFreq_SB(LFP,Restrict(S{24},REMEpoch),'doplot',1);
[HS,Ph,ModTheta]=RayleighFreq_SB(LFPh,Restrict(S{24},REMEpoch),'doplot',1);
close all
[HS,Ph,ModTheta]=RayleighFreq_SB(LFPh,Restrict(S,REMEpoch),'doplot',1);
figure
imagesc(ModTheta.mu)
imagesc(HS{1})
imagesc(HS{2})
imagesc(HS{3})
imagesc(HS{4})
imagesc(HS{5})
imagesc(HS{6})
imagesc(HS{7})
imagesc(HS{8})
imagesc(HS{9})
imagesc(HS{10})
imagesc(HS{11})
imagesc(HS{12})
imagesc(HS{13})
imagesc(HS{14})
imagesc(HS{15})
imagesc(HS{16})
imagesc(HS{17})
imagesc(HS{18})
imagesc(HS{19})
imagesc(HS{20})
imagesc(HS{21})
imagesc(HS{22})
imagesc(HS{23})
imagesc(HS{24})
imagesc(HS{22})
axis xy
figure; imagesc(HS{12}); axis xy
figure; imagesc(HS{13}); axis xy
figure; imagesc(HS{24}); axis xy
















