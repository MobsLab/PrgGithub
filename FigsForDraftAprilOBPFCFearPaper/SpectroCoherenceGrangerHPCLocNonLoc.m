% This code generates pannels used in april draft
% It generates Fig1G,H,2A,4A
% Modified In August 2017
clear all, close all
% Get data

[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlHPCLocalOnly')
% Where to save
SaveFigFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Figure1/';
Date=date;
SaveFigFolder=[SaveFigFolder,Date,filesep];

% Get parameters
Cols1=[0,109,219;146,146,146]/263;
Cols2=[0,146,146;189,109,255]/263;
[params,movingwin,suffix]=SpectrumParametersML('low');
order=16;
paramsGranger.trialave=0;
paramsGrangerparamsGranger.err=[1 0.0500];
paramsGranger.pad=2;
paramsGranger.fpass=[0.1 80];
paramsGranger.tapers=[3 5];
paramsGranger.Fs=250;
paramsGranger.err=[1 0.05];
movingwinGranger=[3 0.2];

n=1;
StrucNames={'HPC','OB','PFCx'};
for mm=KeepFirstSessionOnly
    disp(Dir.path{(mm)})
    
    cd(Dir.path{(mm)})
    clear chH chB chP
    load('behavResources.mat')
    disp(num2str(sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))))
    
    tpsmax=max(Range(Movtsd));
    try,
        load('StateEpochSB.mat')
        TotEpoch=intervalSet(0,tpsmax)-TotalNoiseEpoch;
    catch
        TotEpoch=intervalSet(0,tpsmax);
    end
    
        
    clear  Sptsd Spectro
    try,load('HPCLoc_Low_Spectrum.mat'), catch, load('HLoc_Low_Spectrum.mat'), 
    movefile('HLoc_Low_Spectrum.mat','HPCLoc_Low_Spectrum.mat')
    end
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.HPCLoc(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.HPCLoc(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    fS=Spectro{3};
    chH=ch;
    
    load('HPC1_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.HPC1(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.HPC1(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    fS=Spectro{3};
    
    load('HPC2_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    Spec.Fz.HPC2(n,:)=(nanmean(log(Data(Restrict(Sptsd,FreezeEpoch)))));
    Spec.NoFz.HPC2(n,:)=(nanmean(log(Data(Restrict(Sptsd,TotEpoch-FreezeEpoch)))));
    fS=Spectro{3};


    % Coherence
    CoherencePairs={'PFC_HPCLoc','PFC_HPC1','PFC_HPC2','HPCLoc_OB1','HPC1_OB1','HPC2_OB1'};
    for st=1:size(CoherencePairs,2)
        load(['CohgramcDataL/Cohgram_',CoherencePairs{st},'.mat'])
        Ctsd=tsd(t*1e4,C);
        ICtsd=tsd(t*1e4,imag(S12./sqrt(S1.*S2)));
        temp=nanmean(Data(Restrict(Ctsd,FreezeEpoch)));
        eval(['Coh.Fz.',CoherencePairs{st},'(n,:)=temp;']);
        temp=nanmean(Data(Restrict(Ctsd,TotEpoch-FreezeEpoch)));
        eval(['Coh.NoFz.',CoherencePairs{st},'(n,:)=temp;']);
        temp=abs(nanmean(Data(Restrict(ICtsd,FreezeEpoch))));
        eval(['ICoh.Fz.',CoherencePairs{st},'(n,:)=temp;']);
        temp=abs(nanmean(Data(Restrict(ICtsd,TotEpoch-FreezeEpoch))));
        eval(['ICoh.NoFz.',CoherencePairs{st},'(n,:)=temp;']);
        fC=f;
        clear C
    end
    
    GrangerPairs={'HPC1_OB1','HPC2_OB1','HPCLoc_OB1','HPC1_PFC','HPC2_PFC','HPCLoc_PFC'};
    GrangerPairsInv={'OB1_HPC1','OB1_HPC2','OB1_HPCLoc','PFC_HPC1','PFC_HPC2','PFC_HPCLoc'};
    for st=1:size(GrangerPairs,2)
        load(['GrangerData/Granger_Fz_',GrangerPairs{st},'.mat'])
        Granger.Fz.(GrangerPairs{st})(n,:)=Fx2y;
        Granger.Fz.(GrangerPairsInv{st})(n,:)=Fy2x;
        clear Fx2y Fx2y
        
        load(['GrangerData/Granger_NoFz_',GrangerPairs{st},'.mat'])
        Granger.NoFz.(GrangerPairs{st})(n,:)=Fx2y;
        Granger.NoFz.(GrangerPairsInv{st})(n,:)=Fy2x;
        clear Fx2y Fx2y
    end
 
    clear FreezeEpoch TotEpoch Sptsd Spectro TotalNoiseEpoch
    n=n+1;
    
end

BandLimsS=[find(fS<3,1,'last'):find(fS<6,1,'last')];
BandLimsC=[find(fC<3,1,'last'):find(fC<6,1,'last')];
OtherFreq=[1:length(fS)];OtherFreq(ismember(OtherFreq,BandLimsS))=[];
OtherFreqC=[1:length(fC)];OtherFreq(ismember(OtherFreq,BandLimsC))=[];
BandLimsG=[find(freqBin<3,1,'last'):find(freqBin<6,1,'last')];
OtherFreqG=[1:length(freqBin)];OtherFreq(ismember(OtherFreqG,BandLimsG))=[];

%% Spectra
HPCElecs={'HPC1','HPC2','HPCLoc'}
% HPC Spectra
fig=figure;
for hh=1:3
    subplot(1,3,hh)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fS,nanmean(Spec.Fz.(HPCElecs{hh})),[stdError(Spec.Fz.(HPCElecs{hh}));stdError(Spec.Fz.(HPCElecs{hh}))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fS,nanmean(Spec.NoFz.(HPCElecs{hh})),[stdError(Spec.NoFz.(HPCElecs{hh}));stdError(Spec.NoFz.(HPCElecs{hh}))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Power - log scale')
ylim([6 13])
set(gca,'Layer','top')
title((HPCElecs{hh}))
ValsFz{hh}=nanmean(Spec.Fz.(HPCElecs{hh})(:,BandLimsS)')./nanmean(Spec.Fz.(HPCElecs{hh})(:,OtherFreq)');
ValsNoFz{hh}=nanmean(Spec.NoFz.(HPCElecs{hh})(:,BandLimsS)')./nanmean(Spec.NoFz.(HPCElecs{hh})(:,OtherFreq)');
end
saveas(fig,[SaveFigFolder,'MeanSpecHPCLocVsNonLoc.png']),
saveas(fig,[SaveFigFolder,'MeanSpecHPCLocVsNonLoc.fig']), close all

fig=figure;
for hh=1:3
    subplot(1,3,hh)
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz{hh}),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz{hh}),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz{hh},ValsFz{hh}},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p{hh},h{hh},stats{hh}]=signrank(ValsNoFz{hh},ValsFz{hh});
H=sigstar({[1,2]},p{hh});set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'FontSize',14, 'YTick',[0.9:0.05:1.4])
set(gca,'XTickLabel',{'NoFz','Fz'})
title((HPCElecs{hh}))
ylim([1 1.3])
xlim([0.5 2.5])
end
saveas(fig,[SaveFigFolder,'MeanSpecHPCLocVsNonLocQuantif.fig']), close all
save([SaveFigFolder,'MeanSpecHPCLocVsNonLocQuantif.mat'],'p','h','stats'), close all, clear p h stats

%Coh PFC HPC
HPCElecs={'PFC_HPC1','PFC_HPC2','PFC_HPCLoc'}
fig=figure;
for hh=1:3
    subplot(1,3,hh)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(Coh.Fz.(HPCElecs{hh})),[stdError(Coh.Fz.(HPCElecs{hh}));stdError(Coh.Fz.(HPCElecs{hh}))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(Coh.NoFz.(HPCElecs{hh})),[stdError(Coh.NoFz.(HPCElecs{hh}));stdError(Coh.NoFz.(HPCElecs{hh}))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Coherence')
ylim([0.4 1])
set(gca,'Layer','top')
ValsFz{hh}=nanmean(Coh.Fz.(HPCElecs{hh})(:,BandLimsC)');
ValsNoFz{hh}=nanmean(Coh.NoFz.(HPCElecs{hh})(:,BandLimsC)');
title((HPCElecs{hh}))
end
saveas(fig,[SaveFigFolder,'MeanCohPFCHPCLocVsNonLoc.png'])
saveas(fig,[SaveFigFolder,'MeanCohPFCHPCLocVsNonLoc.fig']), close all

fig=figure;
for hh=1:3
    subplot(1,3,hh)
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz{hh}),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz{hh}),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz{hh},ValsFz{hh}},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p{hh},h{hh},stats{hh}]=signrank(ValsNoFz{hh},ValsFz{hh});
H=sigstar({[1,2]},p{hh});set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
title((HPCElecs{hh}))
ylim([0.4 0.8]),xlim([0.5 2.5])
end
saveas(fig,[SaveFigFolder,'MeanCohPFCHPCLocVsNonLocQuantif.fig']), close all
save([SaveFigFolder,'MeanCohPFCHPCLocVsNonLocQuantif.mat'],'p','h','stats'), close all, clear p h stats


%Coh OB HPC

HPCElecs={'HPC1_OB1','HPC2_OB1','HPCLoc_OB1'}
fig=figure;
for hh=1:3
    subplot(1,3,hh)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(Coh.Fz.(HPCElecs{hh})),[stdError(Coh.Fz.(HPCElecs{hh}));stdError(Coh.Fz.(HPCElecs{hh}))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(Coh.NoFz.(HPCElecs{hh})),[stdError(Coh.NoFz.(HPCElecs{hh}));stdError(Coh.NoFz.(HPCElecs{hh}))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Coherence')
ylim([0.4 0.8])
set(gca,'Layer','top')
ValsFz{hh}=nanmean(Coh.Fz.(HPCElecs{hh})(:,BandLimsC)');
ValsNoFz{hh}=nanmean(Coh.NoFz.(HPCElecs{hh})(:,BandLimsC)');
title((HPCElecs{hh}))
end
saveas(fig,[SaveFigFolder,'MeanCohOBHPCLocVsNonLoc.png'])
saveas(fig,[SaveFigFolder,'MeanCohOBHPCLocVsNonLoc.fig']), close all

fig=figure;
for hh=1:3
    subplot(1,3,hh)
    line([0.7 1.3],[1 1]*nanmedian(ValsNoFz{hh}),'color','k','linewidth',2), hold on
    line([1.7 2.3],[1 1]*nanmedian(ValsFz{hh}),'color','k','linewidth',2)
    handlesplot=plotSpread({ValsNoFz{hh},ValsFz{hh}},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
    set(handlesplot{1},'MarkerSize',20)
    [p{hh},h{hh},stats{hh}]=signrank(ValsNoFz{hh},ValsFz{hh});
    H=sigstar({[1,2]},p{hh});set(H(1),'Color','w');set(H(2),'FontSize',14)
    set(gca,'XTickLabel',{'NoFz','Fz'})
    set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
    title((HPCElecs{hh}))
    ylim([0.4 0.8]),xlim([0.5 2.5])
end
saveas(fig,[SaveFigFolder,'MeanCohOBHPCLocVsNonLocQuantif.fig']), close all
save([SaveFigFolder,'MeanCohOBHPCLocVsNonLocQuantif.mat'],'p','h','stats'), close all, clear p h stats

%% Granger 
% Granger Fz OB HPC
GrangerPairs={'HPC1_OB1','HPC2_OB1','HPCLoc_OB1','HPC1_PFC','HPC2_PFC','HPCLoc_PFC'};
GrangerPairsInv={'OB1_HPC1','OB1_HPC2','OB1_HPCLoc','PFC_HPC1','PFC_HPC2','PFC_HPCLoc'};
fig=figure;
for hh=1:3
    subplot(1,3,hh)
    plot(freqBin,nanmean(Granger.Fz.(GrangerPairs{hh})),'k:','linewidth',3), hold on
plot(freqBin,nanmean(Granger.Fz.(GrangerPairsInv{hh})),'k','linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.(GrangerPairs{hh})),[stdError(Granger.Fz.(GrangerPairs{hh}));stdError(Granger.Fz.(GrangerPairs{hh}))]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.(GrangerPairsInv{hh})),[stdError(Granger.Fz.(GrangerPairsInv{hh}));stdError(Granger.Fz.(GrangerPairsInv{hh}))]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
legend({strrep(GrangerPairs{hh},'_','-'),strrep(GrangerPairsInv{hh},'_','-')})
end
saveas(fig,[SaveFigFolder,'GrangerOBHPCLocVsNonLocFz.fig']), 
saveas(fig,[SaveFigFolder,'GrangerOBHPCLocVsNonLocFz.png']), close all

% Granger NoFz OB HPC
GrangerPairs={'HPC1_OB1','HPC2_OB1','HPCLoc_OB1','HPC1_PFC','HPC2_PFC','HPCLoc_PFC'};
GrangerPairsInv={'OB1_HPC1','OB1_HPC2','OB1_HPCLoc','PFC_HPC1','PFC_HPC2','PFC_HPCLoc'};
fig=figure;
for hh=1:3
    subplot(1,3,hh)
    plot(freqBin,nanmean(Granger.NoFz.(GrangerPairs{hh})),'k:','linewidth',3), hold on
plot(freqBin,nanmean(Granger.NoFz.(GrangerPairsInv{hh})),'k','linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.(GrangerPairs{hh})),[stdError(Granger.NoFz.(GrangerPairs{hh}));stdError(Granger.NoFz.(GrangerPairs{hh}))]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.(GrangerPairsInv{hh})),[stdError(Granger.NoFz.(GrangerPairsInv{hh}));stdError(Granger.NoFz.(GrangerPairsInv{hh}))]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
legend({strrep(GrangerPairs{hh},'_','-'),strrep(GrangerPairsInv{hh},'_','-')})
end
saveas(fig,[SaveFigFolder,'GrangerOBHPCLocVsNonLocNoFz.fig']), 
saveas(fig,[SaveFigFolder,'GrangerOBHPCLocVsNonLocNoFz.png']), close all


% Granger Fz PFC HPC
GrangerPairs={'HPC1_OB1','HPC2_OB1','HPCLoc_OB1','HPC1_PFC','HPC2_PFC','HPCLoc_PFC'};
GrangerPairsInv={'OB1_HPC1','OB1_HPC2','OB1_HPCLoc','PFC_HPC1','PFC_HPC2','PFC_HPCLoc'};
fig=figure;
for hh=4:6
    subplot(1,3,hh-3)
    plot(freqBin,nanmean(Granger.Fz.(GrangerPairs{hh})),'k:','linewidth',3), hold on
plot(freqBin,nanmean(Granger.Fz.(GrangerPairsInv{hh})),'k','linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.(GrangerPairs{hh})),[stdError(Granger.Fz.(GrangerPairs{hh}));stdError(Granger.Fz.(GrangerPairs{hh}))]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.Fz.(GrangerPairsInv{hh})),[stdError(Granger.Fz.(GrangerPairsInv{hh}));stdError(Granger.Fz.(GrangerPairsInv{hh}))]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
legend({strrep(GrangerPairs{hh},'_','-'),strrep(GrangerPairsInv{hh},'_','-')})
end
saveas(fig,[SaveFigFolder,'GrangerPFCHPCLocVsNonLocFz.fig']), 
saveas(fig,[SaveFigFolder,'GrangerPFCHPCLocVsNonLocFz.png']), close all

% Granger NoFz PFC HPC
GrangerPairs={'HPC1_OB1','HPC2_OB1','HPCLoc_OB1','HPC1_PFC','HPC2_PFC','HPCLoc_PFC'};
GrangerPairsInv={'OB1_HPC1','OB1_HPC2','OB1_HPCLoc','PFC_HPC1','PFC_HPC2','PFC_HPCLoc'};
fig=figure;
for hh=4:6
    subplot(1,3,hh-3)
    plot(freqBin,nanmean(Granger.NoFz.(GrangerPairs{hh})),'k:','linewidth',3), hold on
plot(freqBin,nanmean(Granger.NoFz.(GrangerPairsInv{hh})),'k','linewidth',3)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.(GrangerPairs{hh})),[stdError(Granger.NoFz.(GrangerPairs{hh}));stdError(Granger.NoFz.(GrangerPairs{hh}))]','alpha'),hold on
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3,'linestyle',':')
set(hp,'FaceColor',Cols1(2,:))
[hl,hp]=boundedline(freqBin,nanmean(Granger.NoFz.(GrangerPairsInv{hh})),[stdError(Granger.NoFz.(GrangerPairsInv{hh}));stdError(Granger.NoFz.(GrangerPairsInv{hh}))]','alpha');
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',3)
set(hp,'FaceColor',Cols1(2,:))
xlim([0 20]),ylim([0 0.35])
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('Granger causality')
set(gca,'Layer','top')
legend({strrep(GrangerPairs{hh},'_','-'),strrep(GrangerPairsInv{hh},'_','-')})
end
saveas(fig,[SaveFigFolder,'GrangerPFCHPCLocVsNonLocFz.fig']), 
saveas(fig,[SaveFigFolder,'GrangerPFCHPCLocVsNonLocFz.png']), close all



%ICoh PFC HPC
HPCElecs={'PFC_HPC1','PFC_HPC2','PFC_HPCLoc'}
fig=figure;
for hh=1:3
    subplot(1,3,hh)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(ICoh.Fz.(HPCElecs{hh})),[stdError(ICoh.Fz.(HPCElecs{hh}));stdError(ICoh.Fz.(HPCElecs{hh}))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(ICoh.NoFz.(HPCElecs{hh})),[stdError(ICoh.NoFz.(HPCElecs{hh}));stdError(ICoh.NoFz.(HPCElecs{hh}))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('ICoherence')
ylim([0 1])
set(gca,'Layer','top')
ValsFz{hh}=nanmean(ICoh.Fz.(HPCElecs{hh})(:,BandLimsC)');
ValsNoFz{hh}=nanmean(ICoh.NoFz.(HPCElecs{hh})(:,BandLimsC)');
title((HPCElecs{hh}))
end
saveas(fig,[SaveFigFolder,'MeanICohPFCHPCLocVsNonLoc.png'])
saveas(fig,[SaveFigFolder,'MeanICohPFCHPCLocVsNonLoc.fig']), close all

fig=figure;
for hh=1:3
    subplot(1,3,hh)
line([0.7 1.3],[1 1]*nanmedian(ValsNoFz{hh}),'color','k','linewidth',2), hold on
line([1.7 2.3],[1 1]*nanmedian(ValsFz{hh}),'color','k','linewidth',2)
handlesplot=plotSpread({ValsNoFz{hh},ValsFz{hh}},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
set(handlesplot{1},'MarkerSize',20)
[p{hh},h{hh},stats{hh}]=signrank(ValsNoFz{hh},ValsFz{hh});
H=sigstar({[1,2]},p{hh});set(H(1),'Color','w');set(H(2),'FontSize',14)
set(gca,'XTickLabel',{'NoFz','Fz'})
set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
title((HPCElecs{hh}))
ylim([0.4 0.8]),xlim([0.5 2.5])
end
saveas(fig,[SaveFigFolder,'MeanICohPFCHPCLocVsNonLocQuantif.fig']), close all
save([SaveFigFolder,'MeanICohPFCHPCLocVsNonLocQuantif.mat'],'p','h','stats'), close all, clear p h stats


%ICoh OB HPC

HPCElecs={'HPC1_OB1','HPC2_OB1','HPCLoc_OB1'}
fig=figure;
for hh=1:3
    subplot(1,3,hh)
patch([3 3 6 6],[0,20,20,0],[1 1 1]*0.95,'EdgeColor',[1 1 1]*0.95),hold on
[hl,hp]=boundedline(fC,nanmean(ICoh.Fz.(HPCElecs{hh})),[stdError(ICoh.Fz.(HPCElecs{hh}));stdError(ICoh.Fz.(HPCElecs{hh}))]','alpha'),hold on
set(hl,'Color',Cols1(1,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(1,:))
[hl,hp]=boundedline(fC,nanmean(ICoh.NoFz.(HPCElecs{hh})),[stdError(ICoh.NoFz.(HPCElecs{hh}));stdError(ICoh.NoFz.(HPCElecs{hh}))]','alpha')
set(hl,'Color',Cols1(2,:)*0.7,'linewidth',2)
set(hp,'FaceColor',Cols1(2,:))
box off
box off
set(gca,'FontSize',14)
xlabel('Frequency (Hz)')
ylabel('ICoherence')
ylim([0 0.8])
set(gca,'Layer','top')
ValsFz{hh}=nanmean(ICoh.Fz.(HPCElecs{hh})(:,BandLimsC)');
ValsNoFz{hh}=nanmean(ICoh.NoFz.(HPCElecs{hh})(:,BandLimsC)');
title((HPCElecs{hh}))
end
saveas(fig,[SaveFigFolder,'MeanICohOBHPCLocVsNonLoc.png'])
saveas(fig,[SaveFigFolder,'MeanICohOBHPCLocVsNonLoc.fig']), close all

fig=figure;
for hh=1:3
    subplot(1,3,hh)
    line([0.7 1.3],[1 1]*nanmedian(ValsNoFz{hh}),'color','k','linewidth',2), hold on
    line([1.7 2.3],[1 1]*nanmedian(ValsFz{hh}),'color','k','linewidth',2)
    handlesplot=plotSpread({ValsNoFz{hh},ValsFz{hh}},'distributionColors',[Cols1(2,:);Cols1(1,:)]); hold on
    set(handlesplot{1},'MarkerSize',20)
    [p{hh},h{hh},stats{hh}]=signrank(ValsNoFz{hh},ValsFz{hh});
    H=sigstar({[1,2]},p{hh});set(H(1),'Color','w');set(H(2),'FontSize',14)
    set(gca,'XTickLabel',{'NoFz','Fz'})
    set(gca,'FontSize',14, 'YTick',[0.1:0.1:1.4])
    title((HPCElecs{hh}))
    ylim([0.4 0.8]),xlim([0.5 2.5])
end
saveas(fig,[SaveFigFolder,'MeanICohOBHPCLocVsNonLocQuantif.fig']), close all
save([SaveFigFolder,'MeanICohOBHPCLocVsNonLocQuantif.mat'],'p','h','stats'), close all, clear p h stats