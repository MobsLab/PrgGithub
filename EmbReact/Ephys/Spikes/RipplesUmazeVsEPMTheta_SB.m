%% Get response to ripples
clear all
SessionNames = {'UMazeCond'};
Binsize = 0.01*1e4;
MiceNumber=[490,507,508,509,514];
vals = [-1:0.05:1];
TimeAroundDelta = 0.2*1e4;

for ss=1:length(SessionNames)
    RippleTriggeredSpikes.(SessionNames{ss}) = [];
    RippleTriggeredSpikesNoDelta.(SessionNames{ss}) = [];
    NeuroInfo.(SessionNames{ss}) = [];
end

for mm=1:length(MiceNumber)
    DirTemp = GetAllMouseTaskSessions(MiceNumber(mm));
    
    
    for ss=1:length(SessionNames)
        
        % Find the session files
        x1 = strfind(DirTemp,[SessionNames{ss} filesep]);
        ToKeep = find(~cellfun(@isempty,x1));
        Dir.(SessionNames{ss}) = DirTemp(ToKeep);
        
        cd(Dir.(SessionNames{ss}){1})
        load('ChannelsToAnalyse/dHPC_rip.mat')
        
        % Load the ripples, spikes and epochs
        Ripples = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'ripples');
        Deltas = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'deltawaves');
        Spikes = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'spikes');
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes = Spikes(numNeurons);
        SleepEpochs = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','sleepstates'); % wake - nrem -rem
        LinPos= ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'linearposition');
        FreezeEpoch = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','freezeepoch');
        
        Q = MakeQfromS(Spikes,Binsize);
        
        RipplesRest = Restrict(Ripples,thresholdIntervals(LinPos,0.6,'Direction','Above'));
        
        
        RippleSpiking = []; RippleSpiking2 = [];
        clear FRRateInfo
        QDat = Data(Q);
        
        for nn = 1:length(numNeurons)
            QOneNeur = tsd(Range(Q),QDat(:,nn));
            
            [M,T] = PlotRipRaw(QOneNeur,Range(RipplesRest,'s'),400,0,0);
            RippleSpiking = [RippleSpiking,(M(:,2))];
            
            tpsrip = M(:,1);
            
            % Get some general firing rate info to do zscore fairly
            FRRateInfo(nn,:) = [nanmean(Data(Restrict(QOneNeur,FreezeEpoch))),nanstd(Data(Restrict(QOneNeur,FreezeEpoch)))];
            
        end
        
        [val,ind] = max(RippleSpiking);
        [C,I] = sort(ind);
        RippleTriggeredSpikes.(SessionNames{ss}) = [RippleTriggeredSpikes.(SessionNames{ss}),RippleSpiking];
        RippleTriggeredSpikesNoDelta.(SessionNames{ss}) = [RippleTriggeredSpikesNoDelta.(SessionNames{ss}),RippleSpiking2];
        NeuroInfo.(SessionNames{ss}) = [NeuroInfo.(SessionNames{ss});full(FRRateInfo)];
        NumNeur(mm) = length(numNeurons);
    end
end


%% Get theta phase lockking
MiceNumber_EPM = [490,507,508,509,510,512,514];

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis
load('PFCUnitsResponseToHPCPhaseEPMMovLim.mat','Kappa','mu','pval')

Kappa{1}.Open = Kappa{1}.Open(numNeurons);
Kappa{1}.Closed = Kappa{1}.Closed(numNeurons);
mu{1}.Open = mu{1}.Open(numNeurons);
mu{1}.Closed = mu{1}.Closed(numNeurons);
pval{1}.Open = pval{1}.Open(numNeurons);
pval{1}.Closed = pval{1}.Closed(numNeurons);


KappaAllUnits.Open = [];
KappaAllUnits.Closed = [];
MuAllUnits.Open = [];
MuAllUnits.Closed = [];
PvalAllUnits.Open = [];
PvalAllUnits.Closed = [];



for mm = [1:4,7]
    KappaAllUnits.Open = [KappaAllUnits.Open,Kappa{mm}.Open];
    KappaAllUnits.Closed = [KappaAllUnits.Closed,Kappa{mm}.Closed];
    MuAllUnits.Open = [MuAllUnits.Open,mu{mm}.Open];
    MuAllUnits.Closed = [MuAllUnits.Closed,mu{mm}.Closed];
    PvalAllUnits.Open = [PvalAllUnits.Open,pval{mm}.Closed];
    PvalAllUnits.Closed = [PvalAllUnits.Closed,pval{mm}.Open];
    
end


figure
subplot(221)
A = ZScoreWiWindowSB(RippleTriggeredSpikes.(SessionNames{1})(:,PvalAllUnits.Open<0.05)',[1:30]);A = A(:,20:60)';
B = ZScoreWiWindowSB(RippleTriggeredSpikes.(SessionNames{1})(:,PvalAllUnits.Open>0.05)',[1:30]);B = B(:,20:60)';
hold on
errorbar(tpsrip(20:60),nanmean(A'),stdError(A'),'r','linewidth',2)
errorbar(tpsrip(20:60),nanmean(B'),stdError(B'),'k','linewidth',2)
title('Open theta')
ylabel('ZScore val')
set(gca,'XTick',[1:2],'XTickLabel',{'Sig','NoSig'})
set(gca,'LineWidth',2,'FontSize',15)

subplot(223)
PlotErrorBarN_KJ({nanmean(A(20:30,:)),nanmean(B(20:30,:))},'paired',0,'newfig',0,'showPoints',0)
title('Open theta')
ylabel('ZScore val')
set(gca,'XTick',[1:2],'XTickLabel',{'Sig','NoSig'})
set(gca,'LineWidth',2,'FontSize',15)
%ylim([-0.05 0.7])


subplot(222)
A = ZScoreWiWindowSB(RippleTriggeredSpikes.(SessionNames{1})(:,PvalAllUnits.Closed<0.05)',[1:30]);A = A(:,20:60)';
B = ZScoreWiWindowSB(RippleTriggeredSpikes.(SessionNames{1})(:,PvalAllUnits.Closed>0.05)',[1:30]);B = B(:,20:60)';
hold on
errorbar(tpsrip(20:60),nanmean(A'),stdError(A'),'r','linewidth',2)
errorbar(tpsrip(20:60),nanmean(B'),stdError(B'),'k','linewidth',2)
title('Closed theta')
ylabel('ZScore val')
set(gca,'XTick',[1:2],'XTickLabel',{'Sig','NoSig'})
set(gca,'LineWidth',2,'FontSize',15)

subplot(224)
PlotErrorBarN_KJ({nanmean(A(20:25,:)),nanmean(B(20:25,:))},'paired',0,'newfig',0,'showPoints',0)
title('Closed theta')
ylabel('ZScore val')
set(gca,'XTick',[1:2],'XTickLabel',{'Sig','NoSig'})
set(gca,'LineWidth',2,'FontSize',15)
%ylim([-0.05 0.7])


%%
subplot(311)
A = SmoothDec(zscore(RippleTriggeredSpikes.(SessionNames{1})(20:60,:)),[0.1 1]);
[val] = mean(A(20:25,:));
[C,I] = sort(val);

imagesc(tpsrip(20:60),1:length(I),SmoothDec(zscore(RippleTriggeredSpikes.(SessionNames{1})(20:60,I)),[0.1 1])')
line([0 0],ylim,'linewidth',2,'color','w')
clim([-1.5 1.5])
hold on
if ss1==1
    ylabel('Neuron number')
end
yyaxis right
plot(tpsrip(20:60),nanmean((RippleTriggeredSpikes.(SessionNames{1})(20:60,I))'),'k')
title('All ripples sorted by response')
xlabel('Time to ripple (s)')

subplot(323)
[C,I] = sort(KappaAllUnits.Open);
imagesc(tpsrip(20:60),1:length(I),SmoothDec(zscore(RippleTriggeredSpikes.(SessionNames{1})(20:60,I)),[0.1 1])')
line([0 0],ylim,'linewidth',2,'color','w')
clim([-1.5 1.5])
title('Ripples sorted by Open theta Kappa')
xlabel('Time to ripple (s)')

subplot(324)
[C,I] = sort(KappaAllUnits.Closed);
imagesc(tpsrip(20:60),1:length(I),SmoothDec(zscore(RippleTriggeredSpikes.(SessionNames{1})(20:60,I)),[0.1 1])')
line([0 0],ylim,'linewidth',2,'color','w')
clim([-1.5 1.5])
title('Ripples sorted by Closed theta Kappa')
xlabel('Time to ripple (s)')

subplot(325)
hold on
plot(tpsrip(20:60),runmean(nanmean(zscore(RippleTriggeredSpikes.(SessionNames{1})(20:60,PvalAllUnits.Open<0.05))'),2),'r')
plot(tpsrip(20:60),runmean(nanmean(zscore(RippleTriggeredSpikes.(SessionNames{1})(20:60,PvalAllUnits.Open>0.05))'),2),'k')
legend('Sig','NoSig')
xlabel('Time to ripple (s)')
title('Open theta')
ylim([-0.4 0.4])

subplot(326)
hold on
plot(tpsrip(20:60),runmean(nanmean(zscore(RippleTriggeredSpikes.(SessionNames{1})(20:60,PvalAllUnits.Closed<0.05))'),2),'r')
plot(tpsrip(20:60),runmean(nanmean(zscore(RippleTriggeredSpikes.(SessionNames{1})(20:60,PvalAllUnits.Closed>0.05))'),2),'k')
legend('Sig','NoSig')
xlabel('Time to ripple (s)')
title('Closed theta')
ylim([-0.4 0.4])
