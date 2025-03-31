clear all, %close all
FreqRange=[3,6];
OutFreqRange=[6,12];
cols=[0,0,0;0.5,0.5,0.5]

% Get data
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlHPCLocalOnly')
% Where to save
SaveFigFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Figure1/05-Aug-2017/';
% Date=date;
% SaveFigFolder=[SaveFigFolder,Date,filesep];
DurMergeMin=4*1e4;
n=1;

for m=1:length(KeepFirstSessionOnly)
    mm=KeepFirstSessionOnly(m);
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    clear TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch
    load('behavResources.mat')
    load('StateEpochSB.mat')
    if exist('FreezeAccEpoch')
        FreezeEpoch=FreezeAccEpoch;
    end
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    FreezeEpoch=dropShortIntervals(FreezeEpoch,DurMergeMin);
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,DurMergeMin);
    
    try,load('HPCLoc_Low_Spectrum.mat'), catch, load('HLoc_Low_Spectrum.mat'),
        movefile('HLoc_Low_Spectrum.mat','HPCLoc_Low_Spectrum.mat')
    end
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    fS=Spectro{3};
    [Spec.HPCLoc{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Stop(FreezeEpoch)),200,100,0,0,0);
    
    load('HPC1_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    [Spec.HPC1{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Stop(FreezeEpoch)),200,100,0,0,0);
    
    load('HPC2_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    [Spec.HPC2{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Stop(FreezeEpoch)),200,100,0,0,0);
    
        load(['PFCx_Low_Spectrum.mat'])
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    [Spec.PFC{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Stop(FreezeEpoch)),200,100,0,0,0);
    chP=ch;
    load(['B_Low_Spectrum.mat'])
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    [Spec.B{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Stop(FreezeEpoch)),200,100,0,0,0);
    chB=ch;

    
    % Coherence
    CoherencePairs={'PFC_HPCLoc','PFC_HPC1','PFC_HPC2','HPCLoc_OB1','HPC1_OB1','HPC2_OB1'};
    for st=1:size(CoherencePairs,2)
        load(['CohgramcDataL/Cohgram_',CoherencePairs{st},'.mat'])
        Ctsd=tsd(t*1e4,C);
        ICtsd=tsd(t*1e4,imag(S12./sqrt(S1.*S2)));
        fC=f;
        [Coh.(CoherencePairs{st}){m},S,t]=AverageSpectrogram(Ctsd,fC,ts(Stop(FreezeEpoch)),200,100,0,0,0);
        [ICoh.(CoherencePairs{st}){m},S,t]=AverageSpectrogram(ICtsd,fC,ts(Stop(FreezeEpoch)),200,100,0,0,0);
        clear C
    end
    
end

close all
Struc={'HPC1','HPC2','HPCLoc','B','PFC'};
ClimsToUse={[0 0.00013];[0 0.00013];[0 0.00013];[0 0.00013];[0 0.00017]}
for sp=1:length(Struc)
    fig=figure;
    clear AllM Power4hzBand
    for m=1:length(KeepFirstSessionOnly)
        AllM(m,:,:)=Spec.(Struc{sp}){m}./sum(sum(Spec.(Struc{sp}){m}(find(Spectro{3}<2,1,'last'):end,:)));
    end
    subplot(4,1,[1,2,3])
    imagesc(t/1e3,Spectro{3},squeeze(mean(AllM,1))), axis xy
    xlim([-4 4])
    ylim([0.5 20])
    set(gca,'clim',(ClimsToUse{sp}))
    line(xlim, [3 3],'color','k')
    line(xlim, [6 6],'color','k')
    line([0 0],ylim,'color','w','linestyle',':','linewidth',2)
    ylabel('Frequency')
    title(Struc{sp})
    subplot(4,1,4)
    Power4hzBand=squeeze(mean(AllM(:,find(Spectro{3}<3,1,'last'):find(Spectro{3}<5,1,'last'),:),2));
    Power4hzBand=Power4hzBand(:, find(t<-4000,1,'last'): find(t<4000,1,'last'))
    T=t(find(t<=-4000,1,'last'): find(t<=4000,1,'last'))/1e3;
    for k=1:size(Power4hzBand,1)
        Power4hzBand(k,:)=ZScoreWiWindowSB(Power4hzBand(k,:),[1:floor(length(T)/2)-1] );
    end
    [hl,hp]=boundedline(T,nanmean(Power4hzBand),[stdError(Power4hzBand);stdError(Power4hzBand)]');
    set(hl,'Color',[0.6 0.6 0.6]*0.5,'linewidth',2)
    set(hp,'FaceColor',[0.6 0.6 0.6])
    xlim([-4 4])
    ylim([-5 17])
    line(xlim,[0 0],'color','k','linewidth',1)
    line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
    line([0 4],15*[1 1],'color',[0 0.29 0.58],'linewidth',4)
    xlabel('time to FZ onset (s)')
    ylabel('3-6 power zscore')
    saveas(fig,[SaveFigFolder,'TriggeredSpectroStopFZ',Struc{sp},'LocVsNonLoc.fig'])
    saveas(fig,[SaveFigFolder,'TriggeredSpectroStopFZ',Struc{sp},'LocVsNonLoc.png']), close all
end

ClimsToUse={[0.35 0.7];[0.35 0.7];[0.35 0.7];[0.35 0.7];[0.35 0.7];[0.35 0.7]};
for st=1:size(CoherencePairs,2)
    fig=figure;
    clear AllM Power4hzBand
    for m=1:length(KeepFirstSessionOnly)
        AllM(m,:,:)=Coh.(CoherencePairs{st}){m};
    end
    subplot(4,1,[1,2,3])
    imagesc(t/1e3,fC,squeeze(mean(AllM,1))), axis xy
    xlim([-4 4])
    ylim([0.5 20])
    %     set(gca,'clim',(ClimsToUse{st}))
    line(xlim, [3 3],'color','k')
    line(xlim, [6 6],'color','k')
    line([0 0],ylim,'color','w','linestyle',':','linewidth',2)
    ylabel('Frequency')
    title(strrep(CoherencePairs{st},'_','-'))
    subplot(4,1,4)
    Power4hzBand=squeeze(mean(AllM(:,find(Spectro{3}<3,1,'last'):find(Spectro{3}<6,1,'last'),:),2));
    Power4hzBand=Power4hzBand(:, find(t<-4000,1,'last'): find(t<4000,1,'last'))
    T=t(find(t<=-4000,1,'last'): find(t<=4000,1,'last'))/1e3;
    for k=1:size(Power4hzBand,1)
        Power4hzBand(k,:)=ZScoreWiWindowSB(Power4hzBand(k,:),[1:floor(length(T)/2)-1] );
    end
    [hl,hp]=boundedline(T,nanmean(Power4hzBand),[stdError(Power4hzBand);stdError(Power4hzBand)]');
    set(hl,'Color',[0.6 0.6 0.6]*0.5,'linewidth',2)
    set(hp,'FaceColor',[0.6 0.6 0.6])
    xlim([-4 4])
    ylim([-5 5])
    line(xlim,[0 0],'color','k','linewidth',1)
    line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
    line([0 4],15*[1 1],'color',[0 0.29 0.58],'linewidth',4)
    xlabel('time to FZ onset (s)')
    ylabel('3-6 power zscore')
    saveas(fig,[SaveFigFolder,'TriggeredCohStopFZ',strrep(CoherencePairs{st},'_','-'),'LocVsNonLoc.fig'])
    saveas(fig,[SaveFigFolder,'TriggeredCohStopFZ',strrep(CoherencePairs{st},'_','-'),'LocVsNonLoc.png']), close all
    
end



 ClimsToUse={[0 0.35];[0 0.35];[0 0.35];[0 0.35];[0 0.35];[0 0.35]};
for st=1:size(CoherencePairs,2)
    fig=figure;
    clear AllM Power4hzBand
    for m=1:length(KeepFirstSessionOnly)
        AllM(m,:,:)=abs(ICoh.(CoherencePairs{st}){m});
    end
    subplot(4,1,[1,2,3])
    imagesc(t/1e3,fC,squeeze(mean(AllM,1))), axis xy
    xlim([-4 4])
    ylim([0.5 20])
        set(gca,'clim',(ClimsToUse{st}))
    line(xlim, [3 3],'color','k')
    line(xlim, [6 6],'color','k')
    line([0 0],ylim,'color','w','linestyle',':','linewidth',2)
    ylabel('Frequency')
    title(strrep(CoherencePairs{st},'_','-'))
    subplot(4,1,4)
    Power4hzBand=squeeze(mean(AllM(:,find(Spectro{3}<3,1,'last'):find(Spectro{3}<6,1,'last'),:),2));
    Power4hzBand=Power4hzBand(:, find(t<-4000,1,'last'): find(t<4000,1,'last'))
    T=t(find(t<=-4000,1,'last'): find(t<=4000,1,'last'))/1e3;
    for k=1:size(Power4hzBand,1)
        Power4hzBand(k,:)=ZScoreWiWindowSB(Power4hzBand(k,:),[1:floor(length(T)/2)-1] );
    end
    [hl,hp]=boundedline(T,nanmean(Power4hzBand),[stdError(Power4hzBand);stdError(Power4hzBand)]');
    set(hl,'Color',[0.6 0.6 0.6]*0.5,'linewidth',2)
    set(hp,'FaceColor',[0.6 0.6 0.6])
    xlim([-4 4])
    ylim([-5 5])
    line(xlim,[0 0],'color','k','linewidth',1)
    line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
    line([0 4],15*[1 1],'color',[0 0.29 0.58],'linewidth',4)
    xlabel('time to FZ onset (s)')
    ylabel('3-6 power zscore')
    saveas(fig,[SaveFigFolder,'TriggeredImagCohStopFZ',strrep(CoherencePairs{st},'_','-'),'LocVsNonLoc.fig'])
    saveas(fig,[SaveFigFolder,'TriggeredImagCohStopFZ',strrep(CoherencePairs{st},'_','-'),'LocVsNonLoc.png']), close all
    
end

