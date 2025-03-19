clear all, %close all
FreqRange=[3,6];
OutFreqRange=[6,12];
cols=[0,0,0;0.5,0.5,0.5]
itstheStop=0;
% Get data
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('BBXAllData');
SaveFigFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Figure1/05-Aug-2017/';
% Date=date;
% SaveFigFolder=[SaveFigFolder,Date,filesep];
DurMergeMin=4*1e4;
n=1;
[params,movingwin,suffix]=SpectrumParametersML('low');

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
    load(['PFCx_Low_Spectrum.mat'])
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    [Spec.PFC{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Stop(FreezeEpoch)),200,100,0,0,0);
    chP=ch;
    load(['H_Low_Spectrum.mat'])
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    [Spec.HPC{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Stop(FreezeEpoch)),200,100,0,0,0);
    chH=ch;
    
    % Coherence
    % Coherence
    AllCombi=combnk([chP,chH],2);
    Struc={'PFC','HPC'};
    AllCombiNums=combnk([1,2,3],2);
    for st=1:size(AllCombi,1)
        NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllCombi(st,1)),'_',num2str(AllCombi(st,2)),'.mat'];
        load(NameTemp1);
        Ctsd=tsd(t*1e4,C);
        ICtsd=tsd(t*1e4,imag(S12./sqrt(S1.*S2)));
        Angtsd=tsd(t*1e4,angle(S12./sqrt(S1.*S2)));
        fC=f;
        StucCombi=[Struc{AllCombiNums(st,1)},'_',Struc{AllCombiNums(st,2)}];
        [Coh.(StucCombi){m},S,t]=AverageSpectrogram(Ctsd,fC,ts(Stop(FreezeEpoch)),200,100,0,0,0);
        [ICoh.(StucCombi){m},S,t]=AverageSpectrogram(ICtsd,fC,ts(Stop(FreezeEpoch)),200,100,0,0,0);
        clear C
    end
    
end

% close all
ClimsToUse={[0 0.00013];[0 0.00013]}
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
    if itstheStop
        for k=1:size(Power4hzBand,1)
            Power4hzBand(k,:)=ZScoreWiWindowSB(Power4hzBand(k,:),[1:floor(length(T)/2)-1] );
        end
    else
        for k=1:size(Power4hzBand,1)
            Power4hzBand(k,:)=ZScoreWiWindowSB(Power4hzBand(k,:),[floor(length(T)/2):length(T)]);
        end
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
        saveas(fig,[SaveFigFolder,'TriggeredSpectroStopFZ',Struc{sp},'BBX.fig'])
        saveas(fig,[SaveFigFolder,'TriggeredSpectroStopFZ',Struc{sp},'BBX.png']), close all
end

ClimsToUse={[0.4 0.85]}
for st=1:size(AllCombi,1)
    fig=figure;
    clear AllM Power4hzBand
    StucCombi=[Struc{AllCombiNums(st,1)},'_',Struc{AllCombiNums(st,2)}];
    for m=1:length(KeepFirstSessionOnly)
        AllM(m,:,:)=Coh.(StucCombi){m};
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
    title(strrep(StucCombi,'_','-'))
    subplot(4,1,4)
    Power4hzBand=squeeze(mean(AllM(:,find(Spectro{3}<3,1,'last'):find(Spectro{3}<6,1,'last'),:),2));
    Power4hzBand=Power4hzBand(:, find(t<-4000,1,'last'): find(t<4000,1,'last'))
    T=t(find(t<=-4000,1,'last'): find(t<=4000,1,'last'))/1e3;
    if itstheStop
        for k=1:size(Power4hzBand,1)
            Power4hzBand(k,:)=ZScoreWiWindowSB(Power4hzBand(k,:),[1:floor(length(T)/2)-1] );
        end
    else
        for k=1:size(Power4hzBand,1)
            Power4hzBand(k,:)=ZScoreWiWindowSB(Power4hzBand(k,:),[floor(length(T)/2):length(T)]);
        end
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
        saveas(fig,[SaveFigFolder,'TriggeredCohStopFZ',strrep(StucCombi,'_','-'),'BBX.fig'])
        saveas(fig,[SaveFigFolder,'TriggeredCohStopFZ',strrep(StucCombi,'_','-'),'BBX.png']), close all
end

ClimsToUse={[0 0.4]}
for st=1:size(AllCombi,1)
    fig=figure;
    clear AllM Power4hzBand
    StucCombi=[Struc{AllCombiNums(st,1)},'_',Struc{AllCombiNums(st,2)}];
    for m=1:length(KeepFirstSessionOnly)
        AllM(m,:,:)=abs(ICoh.(StucCombi){m});
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
    title(strrep(StucCombi,'_','-'))
    subplot(4,1,4)
    Power4hzBand=squeeze(mean(AllM(:,find(Spectro{3}<3,1,'last'):find(Spectro{3}<6,1,'last'),:),2));
    Power4hzBand=Power4hzBand(:, find(t<-4000,1,'last'): find(t<4000,1,'last'))
    T=t(find(t<=-4000,1,'last'): find(t<=4000,1,'last'))/1e3;
    if itstheStop
        for k=1:size(Power4hzBand,1)
            Power4hzBand(k,:)=ZScoreWiWindowSB(Power4hzBand(k,:),[1:floor(length(T)/2)-1] );
        end
    else
        for k=1:size(Power4hzBand,1)
            Power4hzBand(k,:)=ZScoreWiWindowSB(Power4hzBand(k,:),[floor(length(T)/2):length(T)]);
        end
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
        saveas(fig,[SaveFigFolder,'TriggeredImagCohStopFZ',strrep(StucCombi,'_','-'),'BBX.fig'])
        saveas(fig,[SaveFigFolder,'TriggeredImagCohStopFZ',strrep(StucCombi,'_','-'),'BBX.png']), close all
end
