clear all,% close all
%% INITIATION
FreqRange=[3,6];
[params,movingwin,suffix]=SpectrumParametersML('low');
tps=[0.05:0.05:1];
timeatTransition=4;
timebefprop=0.3;
timebefxpos=timebefprop./(1+timebefprop*2);
%% DATA LOCALISATION
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlHPCLocalOnly');
SaveFolder='/media/DataMOBsRAIDN/ProjetAversion/AnalysisStartStopFreezing_LinkWith4Hz/';
NumBins=30;
Smax=log(NumBins);
for m=1:length(KeepFirstSessionOnly)
    %% Go to file location
    mm=KeepFirstSessionOnly(m);
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    clear Spec FreqBand NewMat TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch FreqBand
    clear Movtsd MovAcctsd
    %% load data
    % Epochs
    load('behavResources.mat')
    load('StateEpochSB.mat')
    if exist('FreezeAccEpoch')
        FreezeEpoch=FreezeAccEpoch;
    end
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    FreezeEpoch=and(FreezeEpoch,TotEpoch);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,4*1e4);
    FreezeEpochBis=FreezeEpoch;
    for fr_ep=1:length(Start(FreezeEpoch))
        LitEp=subset(FreezeEpoch,fr_ep);
        NotLitEp=FreezeEpoch-LitEp;
        StopEp=intervalSet(Stop(LitEp)-4*1e4,Stop(LitEp)+4*1e4);
        if not(isempty(Data(Restrict(Movtsd,and(NotLitEp,StopEp)))))
            FreezeEpochBis=FreezeEpochBis-LitEp;
        end
    end
    FreezeEpoch=CleanUpEpoch(FreezeEpochBis);
    % Inst LFP phase
    load('FilteredLFP/MiniMaxiLFPHPCLoc.mat')
    Phase_H = PhaseInterpol;
    if exist('FilteredLFP/MiniMaxiLFPOBLoc.mat')>0
        load('FilteredLFP/MiniMaxiLFPOBLoc.mat')
        Phase_B = PhaseInterpol;
    else
        load('FilteredLFP/MiniMaxiLFPOB1.mat')
        Phase_B = PhaseInterpol;
    end
    for ep=1:length(Start(FreezeEpoch))-1
        ActualEpoch=subset(FreezeEpoch,ep);
        Dur{m}(ep)=Stop(ActualEpoch,'s')-Start(ActualEpoch,'s');
        dur=Stop(ActualEpoch)-Start(ActualEpoch);
        numbins=round(dur/(2*1E4));
        epdur=(dur/2)/numbins;
        StartFactors = [-2,-1,0:numbins+1];
        for k=1:length(StartFactors)
            LittleEpoch = intervalSet(Start(ActualEpoch)+epdur*StartFactors(k),Start(ActualEpoch)+epdur*(StartFactors(k)+1));
            PhaseDiff = hist(mod(unwrap(Data(Restrict(Phase_B,LittleEpoch))) - unwrap(Data(Restrict(Phase_H,LittleEpoch))),2*pi));
            [Y1,X1]=hist(PhaseDiff,NumBins);
            Y1=Y1/sum(Y1);
            S=-nansum(Y1.*log(Y1));
            Index.Shannon{m}{ep}(k) = (Smax-S)/Smax;
            Index.VectLength{m}{ep}(k) = sqrt(sum(cos(PhaseDiff)).^2+sum(sin(PhaseDiff)).^2)/length(PhaseDiff);
        end
    end
end

AllIndOnset.Shannon = [];
AllIndOffset.Shannon = [];
AllIndNorm.Shannon = [];
AllIndOnset.VectLength = [];
AllIndOffset.VectLength = [];
AllIndNorm.VectLength = [];
AllDur = [];
for m=1:length(Index.VectLength)
for ep = 1:length(Index.VectLength{m})
if length(Index.VectLength{m}{ep})>10
AllIndOnset.Shannon = [AllIndOnset.Shannon;Index.Shannon{m}{ep}(1:5)];
AllIndOffset.Shannon = [AllIndOffset.Shannon;Index.Shannon{m}{ep}(end-4:end)];
temp = Index.Shannon{m}{ep}(3:end-2);
AllIndNorm.Shannon = [AllIndNorm.Shannon;(interp1([1/(length(temp)):1/(length(temp)):1],temp,[0.3:0.3:1]))];
AllIndOnset.VectLength = [AllIndOnset.VectLength;Index.VectLength{m}{ep}(1:5)];
AllIndOffset.VectLength = [AllIndOffset.VectLength;Index.VectLength{m}{ep}(end-4:end)];
temp = Index.VectLength{m}{ep}(3:end-2);
AllIndNorm.VectLength = [AllIndNorm.VectLength;(interp1([1/(length(temp)):1/(length(temp)):1],temp,[0.3:0.3:1]))];
AllDur = [AllDur,Dur{m}(ep)];
end
end
end

figure
subplot(221)
errorbar(-2:2,nanmean(AllIndOnset.VectLength),stdError(AllIndOnset.VectLength),'k'),hold on
errorbar(3:7,nanmean(AllIndOffset.VectLength),stdError(AllIndOffset.VectLength),'k')
ylim([0.2 0.4])
line([-0.5 -0.5],ylim,'color','k')
line([5.5 5.5],ylim,'color','k')
line([0 5],[0.37 0.37],'color','c','linewidth',3)
set(gca,'XTick',[-2:7],'XTickLabel',{'-4','-2','0','2','4','-4','-2','-0','2','4'})
xlabel('time to FZ on/off (s)')
xlim([-3 8])
ylabel('VectLength')
title('Fz onset and offset')
subplot(222)
errorbar([0.3:0.3:1],nanmean(AllIndNorm.VectLength),stdError(AllIndNorm.VectLength),'k')
xlim([0.1 1.1])
line([0.3 1],[0.37 0.37],'color','c','linewidth',3)
title('Norm Period cut in 3')
ylim([0.2 0.4])
xlabel('Prop of FZ bout')
set(gca,'XTick',[0.3:0.3:1])
subplot(223)
errorbar(-2:2,nanmean(AllIndOnset.Shannon),stdError(AllIndOnset.Shannon),'k'),hold on
errorbar(3:7,nanmean(AllIndOffset.Shannon),stdError(AllIndOffset.Shannon),'k')
ylim([0.35 0.5])
line([-0.5 -0.5],ylim,'color','k')
line([5.5 5.5],ylim,'color','k')
line([0 5],[0.47 .47],'color','c','linewidth',3)
set(gca,'XTick',[-2:7],'XTickLabel',{'-4','-2','0','2','4','-4','-2','-0','2','4'})
xlabel('time to FZ on/off (s)')
xlim([-3 8])
ylabel('ShannonEnt')
subplot(224)
errorbar([0.3:0.3:1],nanmean(AllIndNorm.Shannon),stdError(AllIndNorm.Shannon),'k')
xlim([0.1 1.1])
line([0.3 1],[0.47 0.47],'color','c','linewidth',3)
xlabel('Prop of FZ bout')
set(gca,'XTick',[0.3:0.3:1])
ylim([0.35 0.5])
figure
subplot(221)
errorbar(-2:2,nanmean(AllIndOnset.VectLength),stdError(AllIndOnset.VectLength),'k'),hold on
errorbar(3:7,nanmean(AllIndOffset.VectLength),stdError(AllIndOffset.VectLength),'k')
subplot(222)
errorbar([0.3:0.3:1],nanmean(AllIndNorm.VectLength),stdError(AllIndNorm.VectLength),'k')
xlim([0.1 1.1])
subplot(223)
errorbar(-2:2,nanmean(AllIndOnset.Shannon),stdError(AllIndOnset.Shannon),'k'),hold on
errorbar(3:7,nanmean(AllIndOffset.Shannon),stdError(AllIndOffset.Shannon),'k')
subplot(224)
errorbar([0.3:0.3:1],nanmean(AllIndNorm.Shannon),stdError(AllIndNorm.Shannon),'k')
ylim([0.25 0.55])
line([-0.5 -0.5],ylim,'color','k')
line([5.5 5.5],ylim,'color','k')
line([-0.5 -0.5],ylim,'color','k')
line([5.5 5.5],ylim,'color','k')
line([0 5],[0.5 0.5],'color','c','linewidth',3)
set(gca,'XTick',[-2:7],'XTickLabel',{'-4','-2','0','2','4','-4','-2','-0','2','4'})
xlabel('time to FZ on/off (s)')
xlim([-3 8])
ylabel('VectLength')
title('Fz onset and offset')
xlim([0.1 1.1])
line([0.3 1],[0.5 0.5],'color','c','linewidth',3)
title('Norm Period cut in 3')
xlabel('Prop of FZ bout')
set(gca,'XTick',[0.3:0.3:1])
subplot(223)
errorbar(-2:2,nanmean(AllIndOnset.Shannon),stdError(AllIndOnset.Shannon),'k'),hold on
errorbar(3:7,nanmean(AllIndOffset.Shannon),stdError(AllIndOffset.Shannon),'k')
ylim([0.6 0.6])
line([-0.5 -0.5],ylim,'color','k')
ylim([-0.6 0.6])
ylim([0.5 0.6])
line([-0.5 -0.5],ylim,'color','k')
line([5.5 5.5],ylim,'color','k')
line([0 5],[0.59 .59],'color','c','linewidth',3)
set(gca,'XTick',[-2:7],'XTickLabel',{'-4','-2','0','2','4','-4','-2','-0','2','4'})
xlabel('time to FZ on/off (s)')
xlim([-3 8])
ylabel('ShannonEnt')
ylim([0.5 0.6])
xlim([0.1 1.1])
line([0.3 1],[0.5 0.5],'color','c','linewidth',3)
xlabel('Prop of FZ bout')
set(gca,'XTick',[0.3:0.3:1])
ylim([0.35 0.5])
ylim([0.5 0.6])
line([0.3 1],[0.59 0.59],'color','c','linewidth',3)