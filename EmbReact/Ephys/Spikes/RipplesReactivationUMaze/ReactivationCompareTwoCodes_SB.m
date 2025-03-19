close all
clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.2*1e4;
MiceNumber=[490,507,508,509,514];
num = 1;
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples

clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
for mm=1:length(MiceNumber)
    mm
    
    clear eigenvalues Spikes StimEpoch Ripples StimEpoch
    load(['RippleReactInfo_M',num2str(MiceNumber(mm)),'.mat'])
    Q = MakeQfromS(Spikes,Binsize);
    
    
    
    % Define the template epochs
    StimEpochToRemove = intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4);
    RipEpochToRemove = intervalSet(Range(Ripples)-0.2*1e4,Range(Ripples)+0.4*1e4);
    TotEpoch = intervalSet(0,max(Range(Vtsd)));
    Ripples = Restrict(Ripples,TotEpoch-NoiseEpoch);
    Ripples = Restrict(Ripples,thresholdIntervals(LinPos,0.6,'Direction','Above'));
    
    % Define template epochs
    clear Epoch
    Epoch.Shock=thresholdIntervals(LinPos,0.2,'Direction','Below')-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.ShockMov=and(MovEpoch,Epoch.Shock)-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.Poststim=intervalSet(Start(StimEpoch),Start(StimEpoch)+3*1e4)-StimEpochToRemove;
    Epoch.PreStim=intervalSet(Start(StimEpoch)-3*1e4,Start(StimEpoch))-StimEpochToRemove;
    Epoch.ShockFreeze=and(FreezeEpoch,Epoch.Shock)-or(StimEpochToRemove,RipEpochToRemove);
    
    Epoch.Safe=thresholdIntervals(LinPos,0.8,'Direction','Above')-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.SafeMov=and(MovEpoch,Epoch.Safe)-or(StimEpochToRemove,RipEpochToRemove);
    Epoch.PostRipples=mergeCloseIntervals(intervalSet(Range(Ripples)-0.05*1e4,Range(Ripples)+0.12*1e4),0.1*1e4)-StimEpochToRemove;
    Epoch.PreRipples=(mergeCloseIntervals(intervalSet(Range(Ripples)-0.85*1e4,Range(Ripples)-0.72*1e4),0.1*1e4)-StimEpochToRemove)-Epoch.PostRipples;
    Epoch.SafeFreeze=and(FreezeEpoch,Epoch.Safe)-or(StimEpochToRemove,RipEpochToRemove);
    EpochNames = fieldnames(Epoch);
    
    clear templates correlations eigenvalues eigenvectors lambdaMax DatPoints GlobalCorr
    
    for k = 1:length(EpochNames)
        try
            QTemplate = Restrict(Q,Epoch.(EpochNames{k}));
            DatTemplate = (Data(QTemplate)')';
            DatAll = Data(Q);
            
            % get rid of neurons with no spikes at all
            badGuys = find(sum(DatTemplate)==0);
            DatTemplate(:,badGuys) = [];
            DatAll(:,badGuys) = [];
            DatAll = full(DatAll);
            DatTemplate = full(DatTemplate);
            
            DatPoints.(EpochNames{k}) = size(DatTemplate,1);
            
            [templates.(EpochNames{k}),correlations.(EpochNames{k}),eigenvalues.(EpochNames{k}),eigenvectors.(EpochNames{k}),lambdaMax.(EpochNames{k})] = ActivityTemplates_SB(DatTemplate,0);
            strength = ReactivationStrength_SB(DatAll,templates.(EpochNames{k}));
            Rem = [];
            for comp = 1:size(templates.(EpochNames{k}),3)
                Strtsd = tsd(Range(Q),strength(:,comp));
                [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),3000,0,0);
                Remp(comp,:) = M(:,2);
            end
            plot(M(:,1),nanmean(Remp),'r','linewidth',2)
            hold on
            
            [R,phi] = ReactStrength(DatTemplate,DatAll);
            for comp = 1:size(templates.(EpochNames{k}),3)
                Strtsd = tsd(Range(Q),R(:,comp));
                [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),3000,0,0);
                RempAd(comp,:) = M(:,2);
            end
            plot(M(:,1),nanmean(RempAd),'--b')
            title((EpochNames{k}))
            
            keyboard
            hold off
        catch
            disp('failed')
            keyboard
        end
    end
    
end
