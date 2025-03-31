% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
% Get directories
CtrlEphys=[253,258,299,395,403,451,248,244,254,402];
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
FolderName='NeuronLFPCoupling';
% Number of bootstraps for statistics
DoStats=500;
% NM Ratios of phases to try, as in Scheffer-Teixeira 2016
MNRatio=[1,1;1,1.5;1,2;1,3;1,4;1,5];
nbin=30;
% Parameters for triggered spectro
MouseNum=1;
TotNeurons=0;
for mm=1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    
    load('FilteredLFP/MiniMaxiLFPHPC1.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    close all
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    MovEpoch=TotEpoch-FreezeEpoch;
    MovEpoch=MovEpoch-TotalNoiseEpoch;
    MovEpoch=dropShortIntervals(MovEpoch,3*1e4);
    FilLFPP=FilterLFP(LFP,[1 20],1024);
    dat=Data(FilLFPP);
    tps=Range(LFP);
    Amp=interp1(AllPeaks(:,1),dat(ceil(AllPeaks(:,1)*1250)),Range(LFP,'s'));
    tps(isnan(Amp))=[];
    dat(isnan(Amp))=[];
    Amp(isnan(Amp))=[];
    Err=sqrt((Amp-dat).^2./(Amp+dat).^2);
    Errtsd=tsd(tps,Err);
    TotErr(mm,1)=mean(Data(Restrict(Errtsd,MovEpoch)));
    TotErr(mm,2)=mean(Data(Restrict(Errtsd,FreezeEpoch)));
    clear Err MovEpoch FreezeEpoch dat Amp tps
        load('FilteredLFP/MiniMaxiLFPOB1.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    close all
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    MovEpoch=TotEpoch-FreezeEpoch;
    MovEpoch=MovEpoch-TotalNoiseEpoch;
    MovEpoch=dropShortIntervals(MovEpoch,3*1e4);
    FilLFPP=FilterLFP(LFP,[1 20],1024);
    dat=Data(FilLFPP);
    tps=Range(LFP);
    Amp=interp1(AllPeaks(:,1),dat(ceil(AllPeaks(:,1)*1250)),Range(LFP,'s'));
    tps(isnan(Amp))=[];
    dat(isnan(Amp))=[];
    Amp(isnan(Amp))=[];
    Err=sqrt((Amp-dat).^2./(Amp+dat).^2);
    Errtsd=tsd(tps,Err);
    TotErr(mm,3)=mean(Data(Restrict(Errtsd,MovEpoch)));
    TotErr(mm,4)=mean(Data(Restrict(Errtsd,FreezeEpoch)));
end
figure
g=bar([1:4],mean(TotErr)); hold on
set(g,'FaceColor','w','EdgeColor','w')
plotSpread(TotErr,'distributionColors',{'r','r','b','b'},'showMM',2)
[p(1),h]=signrank(TotErr(:,1),TotErr(:,2));
[p(2),h]=signrank(TotErr(:,3),TotErr(:,4));
sigstar({{1,2},{3,4}},p)
set(gca,'Layer','top','XTickLabel',{'HPCMov','HPCFz','OBMov','OBFz'})
box off
ylabel('Mean square err')