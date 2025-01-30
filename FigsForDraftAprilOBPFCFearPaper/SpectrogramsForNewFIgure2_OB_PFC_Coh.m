clear all, %close all
FreqRange=[3,6];
OutFreqRange=[6,12];
cols=[0,0,0;0.5,0.5,0.5]

% Get data
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlAllData');
SaveFigFolder='/home/vador/Dropbox/MOBS_workingON/OB4Hz-manuscrit/Figure1/05-Aug-2017/';
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
    [Spec.Stop.PFC{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Stop(FreezeEpoch)),200,100,0,0,0);
    [Spec.Start.PFC{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Start(FreezeEpoch)),200,100,0,0,0);

    chP=ch;
    chH=ch;
    load(['B_Low_Spectrum.mat'])
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    [Spec.Stop.B{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Stop(FreezeEpoch)),200,100,0,0,0);
    [Spec.Start.B{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Start(FreezeEpoch)),200,100,0,0,0);
    chB=ch;
    
    % Coherence
    AllCombi=combnk([chP,chB,],2);
    Struc={'PFC','B'};
    AllCombiNums=combnk([1,2],2);
    for st=1:size(AllCombi,1)
        try
        NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllCombi(st,1)),'_',num2str(AllCombi(st,2)),'.mat'];
        load(NameTemp1);
        catch
            NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllCombi(st,2)),'_',num2str(AllCombi(st,1)),'.mat'];
        load(NameTemp1);
        end
        Ctsd=tsd(t*1e4,C);
        fC=f;
        StucCombi=[Struc{AllCombiNums(st,1)},'_',Struc{AllCombiNums(st,2)}];
        [Coh.Stop.(StucCombi){m},S,t]=AverageSpectrogram(Ctsd,fC,ts(Stop(FreezeEpoch)),200,100,0,0,0);
        [Coh.Start.(StucCombi){m},S,t]=AverageSpectrogram(Ctsd,fC,ts(Start(FreezeEpoch)),200,100,0,0,0);

        clear C
    end
    
end


close all
ClimsToUse={[0 0.00018];[0 0.00017]}
LitEpochs = {'Start','Stop'};
for sp=1:length(Struc)
    for ep = 1:length(LitEpochs)
        fig=figure;
        clear AllM Power4hzBand
        for m=1:length(KeepFirstSessionOnly)
            AllM(m,:,:)=Spec.(LitEpochs{ep}).(Struc{sp}){m}./sum(sum(Spec.(LitEpochs{ep}).(Struc{sp}){m}(find(Spectro{3}<2,1,'last'):end,:)));
        end
        subplot(4,1,[1,2,3])
        imagesc(t/1e3,Spectro{3},squeeze(nanmean(AllM,1))), axis xy
        xlim([-4 4])
        ylim([0.5 20])
        set(gca,'clim',(ClimsToUse{sp}))
        line(xlim, [3 3],'color','k')
        line(xlim, [6 6],'color','k')
        line([0 0],ylim,'color','w','linestyle',':','linewidth',2)
        ylabel('Frequency')
        title(Struc{sp})
        subplot(4,1,4)
        Power4hzBand=squeeze(nanmean(AllM(:,find(Spectro{3}<3,1,'last'):find(Spectro{3}<5,1,'last'),:),2));
        Power4hzBand=Power4hzBand(:, find(t<-4000,1,'last'): find(t<4000,1,'last'))
        T=t(find(t<=-4000,1,'last'): find(t<=4000,1,'last'))/1e3;
        [hl,hp]=boundedline(T,nanmean(Power4hzBand),[stdError(Power4hzBand);stdError(Power4hzBand)]');
        set(hl,'Color',[0.6 0.6 0.6]*0.5,'linewidth',2)
        set(hp,'FaceColor',[0.6 0.6 0.6])
        xlim([-4 4])
        ylim([0 3*1e-4])
        line([0 0],ylim,'color','k','linewidth',1)
        if ep ==1
        line([0 4],2.5e-4*[1 1],'color',[0 0.29 0.58],'linewidth',4)
        else
            line([-4 0],2.5e-4*[1 1],'color',[0 0.29 0.58],'linewidth',4)
        end
        xlabel('time to FZ onset (s)')
        ylabel('3-6 power zscore')
        colormap jet
    end
end


for ep = 1:length(LitEpochs)
    fig=figure;
    clear AllM Power4hzBand
    for m=1:length(KeepFirstSessionOnly)
        AllM(m,:,:)=Coh.(LitEpochs{ep}).PFC_B{m};
    end
    subplot(4,1,[1,2,3])
    imagesc(t/1e3,Spectro{3},squeeze(nanmean(AllM,1))), axis xy
    xlim([-4 4])
    ylim([0.5 20])
    set(gca,'clim',[0.55 0.95])
    line(xlim, [3 3],'color','k')
    line(xlim, [6 6],'color','k')
    line([0 0],ylim,'color','w','linestyle',':','linewidth',2)
    ylabel('Frequency')
    title(Struc{sp})
    subplot(4,1,4)
    Power4hzBand=squeeze(nanmean(AllM(:,find(Spectro{3}<3,1,'last'):find(Spectro{3}<5,1,'last'),:),2));
    Power4hzBand=Power4hzBand(:, find(t<-4000,1,'last'): find(t<4000,1,'last'))
    T=t(find(t<=-4000,1,'last'): find(t<=4000,1,'last'))/1e3;
    [hl,hp]=boundedline(T,nanmean(Power4hzBand),[stdError(Power4hzBand);stdError(Power4hzBand)]');
    set(hl,'Color',[0.6 0.6 0.6]*0.5,'linewidth',2)
    set(hp,'FaceColor',[0.6 0.6 0.6])
    xlim([-4 4])
    ylim([0 3*1e-4])
    line([0 0],ylim,'color','k','linewidth',1)
    if ep ==1
        line([0 4],2.5e-4*[1 1],'color',[0 0.29 0.58],'linewidth',4)
    else
        line([-4 0],2.5e-4*[1 1],'color',[0 0.29 0.58],'linewidth',4)
    end
    xlabel('time to FZ onset (s)')
    ylabel('3-6 power zscore')
    colormap jet
end
