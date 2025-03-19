clear all, %close all
FreqRange=[3,6];
OutFreqRange=[6,12];
cols=[0,0,0;0.5,0.5,0.5]

% Get data
OBXEphys=[230,291,297,298];
CtrlEphys=[242,248,244,253,254,259,299,394,395,402,403,450,451];

% Excluded mice (too much noise)=258
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
KeepFirstSessionOnly=[1,3,4,6,7:length(Dir.path)];
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
    load(['PFCx_Low_Spectrum.mat'])
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    [M{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Start(FreezeEpoch)),200,100,0,0,0);
end

figure
for m=1:length(KeepFirstSessionOnly)
    AllM(m,:,:)=M{m}./sum(sum(M{m}(30:end,:)));
end
subplot(4,2,[1,3,5])
imagesc(t/1e3,Spectro{3},squeeze(mean(AllM,1))), axis xy
line([0 4],15*[1 1],'color','w','linewidth',10)
line([0 4],15*[1 1],'color',[0 0.29 0.58],'linewidth',8)
xlim([-4 4])
ylim([2.5 20])
clim([0 0.00017])
line(xlim, [3 3],'color','k')
line(xlim, [6 6],'color','k')
line([0 0],ylim,'color','w','linestyle',':','linewidth',2)
subplot(4,2,7)
Power4hzBand=squeeze(mean(AllM(:,find(Spectro{3}<4,1,'last'):find(Spectro{3}<6,1,'last'),:),2));
Power4hzBand=Power4hzBand(:, find(t<-4000,1,'last'): find(t<4000,1,'last'))
T=t(find(t<=-4000,1,'last'): find(t<=4000,1,'last'))/1e3;
for k=1:size(Power4hzBand,1)
Power4hzBand(k,:)=ZScoreWiWindowSB(Power4hzBand(k,:),[1:floor(length(T)/2)-1] );
end
[hl,hp]=boundedline(T,nanmean(Power4hzBand),[stdError(Power4hzBand);stdError(Power4hzBand)]')
set(hl,'Color',[0.6 0.6 0.6]*0.5,'linewidth',2)
set(hp,'FaceColor',[0.6 0.6 0.6])
xlim([-4 4])
ylim([-5 17])
line(xlim,[0 0],'color','k','linewidth',1)
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
line([0 4],15*[1 1],'color',[0 0.29 0.58],'linewidth',4)

% Get data
OBXEphys=[230,291,297,298];

Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',OBXEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
KeepFirstSessionOnly=[1,2,3,4];

clear M

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
    [M{m},S,t]=AverageSpectrogram(Sptsd,Spectro{3},ts(Start(FreezeEpoch)),200,100,0,0,0);
end
clear AllM Power4hzBand
for m=1:length(KeepFirstSessionOnly)
    AllM(m,:,:)=M{m}./sum(sum(M{m}(30:end,:)));
end
subplot(4,2,[1,3,5]+1)
imagesc(t/1e3,Spectro{3},squeeze(mean(AllM,1))), axis xy
line([0 4],15*[1 1],'color','w','linewidth',10)
line([0 4],15*[1 1],'color',[0 0.29 0.58],'linewidth',8)
xlim([-4 4])
ylim([2.5 20])
clim([0 0.00017])
line(xlim, [3 3],'color','k')
line(xlim, [6 6],'color','k')
line([0 0],ylim,'color','w','linestyle',':','linewidth',2)
subplot(4,2,8)
Power4hzBand=squeeze(mean(AllM(:,find(Spectro{3}<3,1,'last'):find(Spectro{3}<6,1,'last'),:),2));
Power4hzBand=Power4hzBand(:, find(t<-4000,1,'last'): find(t<4000,1,'last'))
T=t(find(t<=-4000,1,'last'): find(t<=4000,1,'last'))/1e3;
for k=1:size(Power4hzBand,1)
Power4hzBand(k,:)=ZScoreWiWindowSB(Power4hzBand(k,:),[1:floor(length(T)/2)-1] );
end
[hl,hp]=boundedline(T,nanmean(Power4hzBand),[stdError(Power4hzBand);stdError(Power4hzBand)]')
set(hl,'Color',[0.6 0.6 0.6]*0.5,'linewidth',2)
set(hp,'FaceColor',[0.6 0.6 0.6])
xlim([-4 4])
ylim([-5 17])
line(xlim,[0 0],'color','k','linewidth',1)
line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
line([0 4],15*[1 1],'color',[0 0.29 0.58],'linewidth',4)