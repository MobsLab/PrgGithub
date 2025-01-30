% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
% Get directories
CtrlEphys=[253,258,254,259,394];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Frequency bands to scan through
FreqRange=[1:12;[3:14]];
% Name of possible different structures
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};
% Freq bands specific to each area - only used for NM coupling
FiltBand=[3,6;3,6;3,6;5.5,8.5;5.5,8.5;5.5,8.5;3,6];
%Where to save things
FolderName='LFPPhaseCoupling';
% Number of bootstraps for statistics
DoStats=500;
% NM Ratios of phases to try, as in Scheffer-Teixeira 2016
MNRatio=[1,1;1,1.5;1,2;1,3;1,4;1,5;1.5,1;2,1;3,1;4,1;5,1];
TimeLag=1;
[params,movingwin,suffix]=SpectrumParametersML('low');

for mm=1:length(Dir.path)-1
    mm
    clear chH chH1 chH2 Dur Mov LFPAll ChanAll
    
    cd(Dir.path{mm})
    load('behavResources.mat')
    FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
    
    load('HPC1_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    
    try,
    load('CohgramcDataL/Cohgram_PFCx_HPC1.mat')
    catch
            load('CohgramcDataL/Cohgram_PFC_HPC1.mat')

        end
    CtsdPFC=tsd(t*1e4,C);
    
    load('CohgramcDataL/Cohgram_OB1_HPC1.mat')
    CtsdOB=tsd(t*1e4,C);
    
    load('LFPCorr/AllHPC_PFCx_OB_Loc_NonLoc_Corr.mat')
    
    AllMice.Spec(mm,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
    AllMice.CohPFC(mm,:)=mean(Data(Restrict(CtsdPFC,FreezeEpoch)));
    AllMice.CohOB(mm,:)=mean(Data(Restrict(CtsdOB,FreezeEpoch)));
    try,AllMice.CorrPFC(mm,:)=CorrVals.HPC_PFC{1};catch,AllMice.CorrPFC(mm,:)=CorrVals.HPC_PFC; end
    try,AllMice.CorrOB(mm,:)=CorrVals.HPC_OB{1};catch,AllMice.CorrOB(mm,:)=CorrVals.HPC_OB; end
    
end

figure
subplot(141)
[hl,hp]=boundedline(Spectro{3},nanmean((AllMice.Spec')')',[stdError((AllMice.Spec')');stdError((AllMice.Spec')')]','alpha')
hold on
subplot(142)
[hl,hp]=boundedline(f,nanmean(AllMice.CohPFC)',[stdError(AllMice.CohPFC);stdError(AllMice.CohPFC)]','alpha')
subplot(143)
NewCorr=[];
for k=1:4
    [val,ind]=max(AllMice.CorrOB(k,:));
NewCorr=[NewCorr;zscore(AllMice.CorrOB(k,ind-800:ind+800))];
end
[hl,hp]=boundedline(TimeBin.HPC_OB{1}(1250-800:1250+800),nanmean((NewCorr)),[stdError((NewCorr));stdError((NewCorr))]','alpha')
xlim([-800 800])
subplot(144)
NewCorr=[];
for k=1:4
    [val,ind]=max(AllMice.CorrPFC(k,:));
NewCorr=[NewCorr;zscore(AllMice.CorrPFC(k,ind-800:ind+800))];
end
[hl,hp]=boundedline(TimeBin.HPC_OB{1}(1250-800:1250+800),nanmean((NewCorr)),[stdError((NewCorr));stdError((NewCorr))]','alpha')
xlim([-800 800])
