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
for mm=6
    Dir.path{mm}
    cd(Dir.path{mm})
    
    clear chH chB chP
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    load('BreathingInfo.mat')
    FreezeEpoch=FreezeEpoch-BreathNoiseEpoch;
    load('LFPData/DigInfo2.mat')
    SndEp1=thresholdIntervals(DigTSD,0.8,'Direction','Above');
    SndEp1=mergeCloseIntervals(SndEp1,2*1e4);
    load('LFPData/DigInfo3.mat')
    SndEp2=thresholdIntervals(DigTSD,0.8,'Direction','Above');
    SndEp2=mergeCloseIntervals(SndEp2,2*1e4);
    SndEp=or(SndEp2,SndEp1);
    FreezeEpoch=FreezeEpoch-SndEp;
    FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
    % Look at HPC channels used for local activity
    load('LFPData/InfoLFP.mat')
    clear LFP, load('LFPData/LocalHPCActivity.mat')
    LFPAll.LocHPC=LFP;
    
    HPCChannels=find(~cellfun(@isempty,strfind(InfoLFP.structure,'dHPC')));
    HPCChannels=InfoLFP.channel(HPCChannels(Chans));
    chH1=HPCChannels(1);
    clear LFP, load(['LFPData/LFP',num2str(chH1),'.mat']);
    LFPAll.HPC1=LFP;
    chH2=HPCChannels(2);
    clear LFP, load(['LFPData/LFP',num2str(chH2),'.mat']);
    LFPAll.HPC2=LFP;
    
    load('ChannelsToAnalyse/Bulb_deep.mat')
    chB=channel;
    clear LFP, load(['LFPData/LFP',num2str(channel),'.mat']);
    LFPAll.OB=LFP;
    
    [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB,LFPAll.LocHPC,FreqRange,FreezeEpoch,500,0);
    save OBHPCPhaseCouplingLoc.mat Index IndexRand Phase
    clear Index IndexRand Phase
    chH=chH1;
    [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB,LFPAll.HPC1,FreqRange,FreezeEpoch,500,0);
    save OBHPCPhaseCoupling1.mat Index IndexRand Phase chH
    clear Index IndexRand Phase
    chH=chH2;
    [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(LFPAll.OB,LFPAll.HPC2,FreqRange,FreezeEpoch,500,0);
    save OBHPCPhaseCoupling2.mat Index IndexRand Phase chH
    clear Index IndexRand Phase

    for f=1:size(FreqRange,2)
        FilLFP=FilterLFP(LFPAll.HPC1,FreqRange(:,f),1024);
        [ph{f,1},mu{f,1}, Kappa{f,1}, pval{f,1},~,~]=ModulationThetaCorrection(Breathtsd,FilLFP,FreezeEpoch,30,0);
    end
    save RespiHPCCoupling1.mat ph mu Kappa pval
    clear ph mu Kappa pval
    for f=1:size(FreqRange,2)
        FilLFP=FilterLFP(LFPAll.HPC2,FreqRange(:,f),1024);
        [ph{f,1},mu{f,1}, Kappa{f,1}, pval{f,1},~,~]=odulationThetaCorrection(Breathtsd,FilLFP,FreezeEpoch,30);
    end
    save RespiHPCCoupling2.mat ph mu Kappa pval
    clear ph mu Kappa pval
    for f=1:size(FreqRange,2)
        FilLFP=FilterLFP(LFPAll.LocHPC,FreqRange(:,f),1024);
        [ph{f,1},mu{f,1}, Kappa{f,1}, pval{f,1},~,~]=ModulationThetaCorrection(Breathtsd,FilLFP,FreezeEpoch,30);
    end
    save RespiHPCCouplingLoc.mat ph mu Kappa pval
    clear ph mu Kappa pval
    
    clear LFPAll FreezeEpoch Breathtsd
    
end

%%% Figure
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
mouse=1;
for mm=3:6
    Dir.path{mm}
    cd(Dir.path{mm})
    if exist('OBHPCPhaseCoupling1.mat')>0
        load('RespiHPCCoupling1.mat')
        KappaRem.HPC1(mouse,:)=[Kappa{:}];
        load('RespiHPCCoupling2.mat')
        KappaRem.HPC2(mouse,:)=[Kappa{:}];
        load('RespiHPCCouplingLoc.mat')
        KappaRem.HPCLoc(mouse,:)=[Kappa{:}];
        mouse=mouse+1;
    end
end

plot(mean(FreqRange),mean(KappaRem.HPC1),'b'), hold on
plot(mean(FreqRange),mean(KappaRem.HPC2),'b'), hold on
plot(mean(FreqRange),mean(KappaRem.HPCLoc),'r'), hold on
[hl,hp]=boundedline(mean(FreqRange),mean(KappaRem.HPC1),[stdError(KappaRem.HPC1);stdError(KappaRem.HPC1)]','alpha');
[hl,hp]=boundedline(mean(FreqRange),mean(KappaRem.HPC2),[stdError(KappaRem.HPC2);stdError(KappaRem.HPC2)]','alpha');
[hl,hp]=boundedline(mean(FreqRange),mean(KappaRem.HPCLoc),[stdError(KappaRem.HPCLoc);stdError(KappaRem.HPCLoc)]','alpha','r');
box off
xlabel('Frequency'), ylabel('mean Kappa')
legend('HPC-1','HPC-2','HPC Local')
