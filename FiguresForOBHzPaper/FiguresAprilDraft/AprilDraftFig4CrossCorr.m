% This code generates pannels used in april draft
% It generates Fig4L
% This code hasn't been adapted for use with the information on the server
% in Paris yet and only works on harddrives in Montreal

clear all
% Get directories
CtrlEphys=[253,258,254,259,394];
Dir=PathForExperimentFEARMac('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');

% Name of possible different structures
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};


% Where to save
SaveFigFolder='/Users/sophiebagur/Dropbox/OB4Hz-manuscrit/FigTest/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

for mm=1:length(Dir.path)
    mm
    clear chH chH1 chH2 Dur Mov LFPAll ChanAll
    
    cd(Dir.path{mm})
    load('behavResources.mat')
    FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
    
    load('HPC1_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    
    try,load('CohgramcDataL/Cohgram_PFCx_HPC1.mat')
    catch, try, load('CohgramcDataL/Cohgram_PFC_HPC1.mat'), end
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
    try,AllMice.CorrPFCbis(mm,:)=CorrVals.HPC_PFC{2};catch,AllMice.CorrPFCbis(mm,:)=zeros(1,2499); end
    try,AllMice.CorrOBbis(mm,:)=CorrVals.HPC_OB{2};catch,AllMice.CorrOBbis(mm,:)=zeros(1,2499); end

end


fig=figure;
NewCorr=[];
for k=[1,2,4,5]
    [val,ind]=max(AllMice.CorrPFCbis(k,:));
NewCorr=[NewCorr;zscore(AllMice.CorrPFCbis(k,ind-800:ind+800))];
end
plot(TimeBin.HPC_OB{1}(1250-800:1250+800),nanmean((NewCorr)),'k','linewidth',3)
hold on
NewCorr=[];
for k=[1,2,4,5]
    [val,ind]=max(AllMice.CorrOBbis(k,:));
NewCorr=[NewCorr;zscore(AllMice.CorrOBbis(k,ind-800:ind+800))];
end
plot(TimeBin.HPC_OB{1}(1250-800:1250+800),nanmean((NewCorr)),'k','linewidth',3,'linestyle','--')
xlim([-800 800])
xlabel('Time (ms)')
ylabel('Z-scored cross correlogram')
set(gca,'XTick',[-800:400:800],'FontSize',15)
box off
saveas(fig,[SaveFolder 'CrossCorrelationDeepHPCPFC.fig']), close all


fig=figure;
NewCorr=[];
for k=1:5
    [val,ind]=max(AllMice.CorrPFC(k,:));
NewCorr=[NewCorr;zscore(AllMice.CorrPFC(k,ind-800:ind+800))];
end
plot(TimeBin.HPC_OB{1}(1250-800:1250+800),nanmean((NewCorr)),'k','linewidth',3)
hold on
NewCorr=[];
NewCorr=[];
for k=[1,2,4,5]
    [val,ind]=max(AllMice.CorrPFCbis(k,:));
NewCorr=[NewCorr;zscore(AllMice.CorrPFCbis(k,ind-800:ind+800))];
end
plot(TimeBin.HPC_OB{1}(1250-800:1250+800),nanmean((NewCorr)),'k','linewidth',3,'linestyle','--')
hold on
xlim([-800 800])
xlabel('Time (ms)')
ylabel('Z-scored cross correlogram')
set(gca,'XTick',[-800:400:800],'FontSize',15)
box off
saveas(fig,[SaveFolder 'CrossCorrelationCA1LayerPFC.fig']), close all