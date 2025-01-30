% Breathing Figures
% HPC couplign to breathing
% Calculate spectra,coherence and Granger
clear all
obx=0;
% Get data
close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');
numNeurons=[];
n=1;
AllCrossCorr=[];
AllMod=[];
Allp=[];
AllSp=[];
FreqRange=[1:12;[3:14]];
m=0;
for mm=[3,4,6]
    

cd(Dir.path{mm})

    m=m+1;
    load('OBHPCPhaseCoupling1.mat')
    AllCoup1.Shannon(m,:)=(diag(Index.Shannon));
    AllCoup1.VectLength(m,:)=(diag(Index.VectLength));

    load('OBHPCPhaseCoupling2.mat')
    AllCoup2.Shannon(m,:)=(diag(Index.Shannon));
    AllCoup2.VectLength(m,:)=(diag(Index.VectLength));

    load('OBHPCPhaseCouplingLoc.mat')
    AllCoupLoc.Shannon(m,:)=(diag(Index.Shannon));
    AllCoupLoc.VectLength(m,:)=(diag(Index.VectLength));

    load('RespiHPCCoupling1.mat')
    Kappa1(m,:)=[Kappa{:}];
    load('RespiHPCCoupling2.mat')
    Kappa2(m,:)=[Kappa{:}];
    load('RespiHPCCouplingLoc.mat')
    KappaLoc(m,:)=[Kappa{:}];
    
    
end

figure
subplot(311)
plot(mean(FreqRange),Kappa1,'k'), hold on
plot(mean(FreqRange),Kappa2,'k')
plot(mean(FreqRange),KappaLoc,'r')
subplot(312)
plot(mean(FreqRange),AllCoup1.Shannon,'k'), hold on
plot(mean(FreqRange),AllCoup2.Shannon,'k')
plot(mean(FreqRange),AllCoupLoc.Shannon,'r')
subplot(313)
plot(mean(FreqRange),AllCoup1.VectLength,'k'), hold on
plot(mean(FreqRange),AllCoup2.VectLength,'k')
plot(mean(FreqRange),AllCoupLoc.VectLength,'r')


