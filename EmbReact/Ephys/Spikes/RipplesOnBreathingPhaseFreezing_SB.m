clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,510,512,514];

Binsize = 0.1*1e4;
SpeedLim = 2;

for mm=1:length(MiceNumber)
    mm
    clear Dir
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'UMazeCond');
    ToKeep = find(~cellfun(@isempty,x1));
    Dir = Dir(ToKeep);
    Ripples = ConcatenateDataFromFolders_SB(Dir,'ripples');
    if not(isempty(Range(Ripples)))
        Spikes = ConcatenateDataFromFolders_SB(Dir,'spikes');
        cd(Dir{1})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes = Spikes(numNeurons);
        
        load('ChannelsToAnalyse/Bulb_deep.mat')
        channel_OB = channel;
        load('ChannelsToAnalyse/dHPC_rip.mat')
        channel_HPC = channel;
        

        % Epochs
        NoiseEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepochclosestims');
        FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
        StimEpoch= ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
        
        LinPos = ConcatenateDataFromFolders_SB(Dir,'linearposition');
        LFP_OB = ConcatenateDataFromFolders_SB(Dir,'lfp','ChanNumber',channel_OB);
        LFP_HPC = ConcatenateDataFromFolders_SB(Dir,'lfp','ChanNumber',channel_HPC);
        Vtsd = ConcatenateDataFromFolders_SB(Dir,'speed');
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4);
        PhaseOB = ConcatenateDataFromFolders_SB(Dir,'instphase','suffix_instphase','B');
        
        % Clean epochs
        TotEpoch = intervalSet(0,max(Range(LFP_OB)));
        TotEpoch = TotEpoch-NoiseEpoch;
        FreezeEpoch = FreezeEpoch-NoiseEpoch;
        MovEpoch = MovEpoch - NoiseEpoch;
        
        Ripples = Restrict(Ripples,TotEpoch);
        Ripples = Restrict(Ripples,thresholdIntervals(LinPos,0.6,'Direction','Above'));
        
        
        subplot(3,length(MiceNumber),mm)
        % Get phase of Ripples relative to OB
        [Y,X] = hist(Data(Restrict(PhaseOB,ts(Range(Ripples)))),20);
        Y = Y/sum(Y);
        bar([X,X+2*pi-X(1)/2],[Y,Y],'FaceColor','k')
        xlabel('Breathing phase')
        ylabel('Ripple count')
        box off
        set(gca,'FontSize',15,'Linewidth',2)
        RemHistRipples(mm,:) = Y;
        title(['Mouse ' num2str(MiceNumber(mm))])
        AllRipPhase{mm} = Data(Restrict(PhaseOB,ts(Range(Ripples))));
        
        rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/FMAToolbox/General/')
        rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
        [mu(mm), Kappa(mm), pval(mm)] = CircularMean(Data(Restrict(PhaseOB,ts(Range(Ripples)))));
        addpath(genpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats'))
        addpath(genpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/FMAToolbox/General/'))

        % Trigger OB on tipples
        [M_OB,T_OB] = PlotRipRaw(LFP_OB,Range(Ripples,'s'),1000,0,0);
        [M_HPC,T_HPC] = PlotRipRaw(LFP_HPC,Range(Ripples,'s'),1000,0,0);
        
        subplot(3,length(MiceNumber),mm+length(MiceNumber))
        plot(M_HPC(:,1),M_HPC(:,2),'linewidth',2,'color',[0.6 0.6 0.6]), hold on
        plot(M_OB(:,1),M_OB(:,2),'linewidth',2,'color','k')
        xlabel('time to ripple (s)')
        box off
        set(gca,'FontSize',15,'Linewidth',2)
        RemTrigOB(mm,:) = M_OB(:,2);
        
        subplot(3,length(MiceNumber),mm+2*length(MiceNumber))
        imagesc(M_OB(:,1),1:size(T_OB,1),zscore(T_OB')')
        set(gca,'FontSize',15,'Linewidth',2)
        xlabel('time to ripple (s)')
        clim([-2.5 2.5])


    end
end

figure
subplot(131)
% RemTrigOB(4,:)=RemTrigOB(4,:)*NaN;
RemTrigOB(5,:)=RemTrigOB(5,:)*NaN;
RemTrigOB(6,:)=RemTrigOB(6,:)*NaN;
shadedErrorBar(M_OB(:,1),runmean(nanmean(RemTrigOB),10),runmean(stdError(RemTrigOB),10))
xlabel('time to ripple (s)')
box off
set(gca,'FontSize',15,'Linewidth',2)
title('OB triggered on ripples (n=5)')

subplot(132)
% RemHistRipples(4,:)=RemHistRipples(4,:)*NaN;
RemHistRipples(5,:)=RemHistRipples(5,:)*NaN;
RemHistRipples(6,:)=RemHistRipples(6,:)*NaN;
shadedErrorBar([X,X+2*pi-X(1)/2],[nanmean(RemHistRipples),nanmean(RemHistRipples)],[stdError(RemHistRipples),stdError(RemHistRipples)])
hold on
plot(mu([1,2,3,4,7]),0.11+[1:5]*0.002,'k*')
plot(mu([1,2,3,4,7])+2*pi,0.11+[1:5]*0.002,'k*')
xlabel('Breathing phase')
ylabel('Ripple count')
box off
set(gca,'FontSize',15,'Linewidth',2)
title('Phase of ripples - av. over animals (n=5)')

subplot(133)
[Y,X] = hist(AllPhase,20);
Y = Y/sum(Y);
bar([X,X+2*pi-X(1)/2],[Y,Y],'FaceColor','k')
xlabel('Breathing phase')
ylabel('Ripple count')
box off
set(gca,'FontSize',15,'Linewidth',2)
title('Phase of all ripples (n=518)')

AllPhase = [];
for k=1:7
AllPhase = [AllPhase;AllRipPhase{k}];
end