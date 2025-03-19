clear all
MiceNumber=[490,507,508,509,510,512,514];
% MiceNumber=[490,507,508,510,512,514];
SessNames={'EPM'};
Dir = PathForExperimentsEmbReact(SessNames{1});

nbin=30;
nmouse=1;

SpeedLim = 0.1;
MovLim = 1;

for dd=1:length(Dir.path)
    MaxTime=0;
    clear AllS
    if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
        
        %% Get all the phases of spikes during both kinds of freezing
        for ddd=1:length(Dir.path{dd})
            
            % Go to location and load data
            cd(Dir.path{dd}{ddd})
            disp(Dir.path{dd}{ddd})
            load('SpikeData.mat')
            load('behavResources_SB.mat')
            load('StateEpochSB.mat','TotalNoiseEpoch')
            
            % Define epochs
            RemovEpoch=(or(TTLInfo.StimEpoch,TotalNoiseEpoch));

            ToCenterEp=dropShortIntervals(Behav.ZoneEpoch{1},5*1e4);
            AwayCenterEp=dropShortIntervals(Behav.ZoneEpoch{2},5*1e4);
            
            Xtsd = tsd(Range(Behav.Xtsd),(Data(Behav.Xtsd) - nanmean(Data(Restrict(Behav.Xtsd,Behav.ZoneEpoch{3})))));
            Ytsd = tsd(Range(Behav.Ytsd),(Data(Behav.Ytsd) - nanmean(Data(Restrict(Behav.Ytsd,Behav.ZoneEpoch{3})))));
            
            X = [-abs(Data(Restrict(Ytsd,Behav.ZoneEpoch{2})));abs(Data(Restrict(Xtsd,Behav.ZoneEpoch{1})))];
            Y = [(Range(Restrict(Ytsd,Behav.ZoneEpoch{2})));(Range(Restrict(Xtsd,Behav.ZoneEpoch{1})))];
            A = (sortrows([Y,X]));
            LinEPM = tsd(A(:,1),A(:,2));
            
            % Closed arms
            LocSpeed = tsd(Range(Ytsd),[0;diff(runmean(abs(Data(Ytsd)),2))]);
            
            MovEpoch1 = thresholdIntervals(LocSpeed,SpeedLim,'Direction','Above');
            MovEpoch1 = mergeCloseIntervals(MovEpoch1,0.1*1e4);
            MovEpoch1 = dropShortIntervals(MovEpoch1,1*1e4);
            AwayCenter = MovEpoch1;
            
            MovEpoch2 = thresholdIntervals(LocSpeed,-SpeedLim,'Direction','Below');
            MovEpoch2 = mergeCloseIntervals(MovEpoch2,0.1*1e4);
            MovEpoch2 = dropShortIntervals(MovEpoch2,1*1e4);
            ToCenter = MovEpoch2;
            
            % Open arms
            LocSpeed = tsd(Range(Xtsd),[0;diff(runmean(abs(Data(Xtsd)),2))]);
            MovEpoch1 = thresholdIntervals(LocSpeed,SpeedLim,'Direction','Above');
            MovEpoch1 = mergeCloseIntervals(MovEpoch1,0.1*1e4);
            MovEpoch1 = dropShortIntervals(MovEpoch1,1*1e4);
            ToCenter = or(MovEpoch1,ToCenter);
            
            MovEpoch2 = thresholdIntervals(LocSpeed,-SpeedLim,'Direction','Below');
            MovEpoch2 = mergeCloseIntervals(MovEpoch2,0.1*1e4);
            MovEpoch2 = dropShortIntervals(MovEpoch2,1*1e4);
            AwayCenter = or(MovEpoch2,AwayCenter);
            
            

            clf
            plot(Range(LinEPM,'s'),(Data(LinEPM)))
            hold on
            plot(Range(Restrict(LinEPM,AwayCenter),'s'),(Data(Restrict(LinEPM,AwayCenter))))
            plot(Range(Restrict(LinEPM,ToCenter),'s'),(Data(Restrict(LinEPM,ToCenter))))
     
            %% Spectra
            load('H_Low_Spectrum.mat')
            Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
            MeanSpecH.AwayCenter(nmouse,:) = nanmean(Data(Restrict(Sptsd,AwayCenter)));
            MeanSpecH.ToCenter(nmouse,:) = nanmean(Data(Restrict(Sptsd,ToCenter)));
            
            load('B_Low_Spectrum.mat')
            Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
            MeanSpecB.AwayCenter(nmouse,:) = nanmean(Data(Restrict(Sptsd,AwayCenter)));
            MeanSpecB.ToCenter(nmouse,:) = nanmean(Data(Restrict(Sptsd,ToCenter)));

            load('B_PFCx_Low_Coherence.mat')
            Sptsd = tsd(Coherence{2}*1e4,(Coherence{1}));
            MeanSpecB_P.AwayCenter(nmouse,:) = nanmean(Data(Restrict(Sptsd,AwayCenter)));
            MeanSpecB_P.ToCenter(nmouse,:) = nanmean(Data(Restrict(Sptsd,ToCenter)));

            load('H_PFCx_Low_Coherence.mat')
            Sptsd = tsd(Coherence{2}*1e4,(Coherence{1}));
            MeanSpecH_P.AwayCenter(nmouse,:) = nanmean(Data(Restrict(Sptsd,AwayCenter)));
            MeanSpecH_P.ToCenter(nmouse,:) = nanmean(Data(Restrict(Sptsd,ToCenter)));

            load('PFCx_Low_Spectrum.mat')
            Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
            MeanSpecP.AwayCenter(nmouse,:) = nanmean(Data(Restrict(Sptsd,AwayCenter)));
            MeanSpecP.ToCenter(nmouse,:) = nanmean(Data(Restrict(Sptsd,ToCenter)));

            
            % speed
            A = {log(Data(Restrict(Behav.Vtsd,(AwayCenter)))),...
                log(Data(Restrict(Behav.Vtsd,(ToCenter))))};
            
            for i = 1:2
                A{i}(A{i}<-2.5) = [];
                [Y,X]= hist(A{i},[-3:0.2:5]);           
                SpeeDistrib{i}(nmouse,:) = Y/sum(Y);
            end

            DurEp.ToCenter(nmouse,ddd)=sum(Stop(ToCenter,'s')-Start(ToCenter,'s'));
            DurEp.AwayCenter(nmouse,ddd)=sum(Stop(AwayCenter,'s')-Start(AwayCenter,'s'));
            
            
            % Phase locking
            HPCPhase = load('InstFreqAndPhase_HNeuronPhaseLocking.mat');
            OBPhase = load('InstFreqAndPhase_BNeuronPhaseLocking.mat');

            for sp=1:length(S)
                
                NeuronWeight.ToCenter{nmouse}(sp) = FiringRateEpoch(S{sp},ToCenter);
                NeuronWeight.AwayCenter{nmouse}(sp) = FiringRateEpoch(S{sp},AwayCenter);

                % Only ToCenter arm
                PhasesSpikesH.ToCenter{nmouse}{sp}{ddd} = Data(Restrict(HPCPhase.PhaseSpikes.WV{sp}.Transf,ToCenter));
                PhasesSpikesB.ToCenter{nmouse}{sp}{ddd} = Data(Restrict(OBPhase.PhaseSpikes.WV{sp}.Transf,ToCenter));

                % Only AwayCenter arm
                PhasesSpikesH.AwayCenter{nmouse}{sp}{ddd} = Data(Restrict(HPCPhase.PhaseSpikes.WV{sp}.Transf,AwayCenter));
                PhasesSpikesB.AwayCenter{nmouse}{sp}{ddd} = Data(Restrict(OBPhase.PhaseSpikes.WV{sp}.Transf,AwayCenter));
                
            end
            
            
        end
        nmouse=nmouse+1;
    end
end


PhasesSpikes = PhasesSpikesB;

clear Kappa mu
for nmouse=1:length(PhasesSpikes.AwayCenter)
    MaxTime=0;
    clear AllS
    
    for sp=1:length(PhasesSpikes.AwayCenter{nmouse})
        
        % Get all AwayCenter spike phases
        AllSpPhas.AwayCenter=[];
        for ddd=1:length(PhasesSpikes.AwayCenter{nmouse}{sp})
            try
                AllSpPhas.AwayCenter=[AllSpPhas.AwayCenter;PhasesSpikes.AwayCenter{nmouse}{sp}{ddd}];
            end
        end
        
        % Get all ToCenter spike phases
        AllSpPhas.ToCenter=[];
        for ddd=1:length(Dir.path{nmouse})
            try
                AllSpPhas.ToCenter=[AllSpPhas.ToCenter;PhasesSpikes.ToCenter{nmouse}{sp}{ddd}];
            end
        end
        
        [val,ind]=min([length(AllSpPhas.ToCenter),length(AllSpPhas.AwayCenter)]);
        if not(isempty(AllSpPhas.AwayCenter))|not(isempty(AllSpPhas.ToCenter))
            if ind==1
                AllSpPhas.AwayCenter=randsample(AllSpPhas.AwayCenter,val);
            else
                AllSpPhas.ToCenter=randsample(AllSpPhas.ToCenter,val);
            end
        end
        
        
        if not(isempty(AllSpPhas.AwayCenter))
            [mu{nmouse}.AwayCenter(sp), Kappa{nmouse}.AwayCenter(sp), pval{nmouse}.AwayCenter(sp), Rmean, delta, sigma,confDw,confUp] = CircularMean(AllSpPhas.AwayCenter);
        else
            Kappa{nmouse}.AwayCenter(sp)=NaN;
            mu{nmouse}.AwayCenter(sp)=NaN;
            pval{nmouse}.AwayCenter(sp)=NaN;
        end
        
        if not(isempty(AllSpPhas.ToCenter))
            [mu{nmouse}.ToCenter(sp), Kappa{nmouse}.ToCenter(sp), pval{nmouse}.ToCenter(sp), Rmean, delta, sigma,confDw,confUp] = CircularMean(AllSpPhas.ToCenter);
        else
            Kappa{nmouse}.ToCenter(sp)=NaN;
            mu{nmouse}.ToCenter(sp)=NaN;
            pval{nmouse}.ToCenter(sp)=NaN;
        end
    end
end
% 
% if MovLim==0
% cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis
% save('PFCUnitsResponseToOBPhaseEPM.mat','Kappa','mu','pval')
% else
%  cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis
% save('PFCUnitsResponseToOBPhaseEPMMovLim.mat','Kappa','mu','pval')   
% end
% 
% 
% %%
% cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis
% load('PFCUnitsResponseToOBPhaseEPM.mat','Kappa','mu','pval')

KappaAllUnits.ToCenter = [];
KappaAllUnits.AwayCenter = [];
MuAllUnits.ToCenter = [];
MuAllUnits.AwayCenter = [];


for mm = 1:length(Kappa)
    GoodUnits = find(or(pval{mm}.ToCenter<0.05,pval{mm}.AwayCenter<0.05));
    
    NumUnits.ToCenter(mm) = sum(pval{mm}.ToCenter<0.05 & pval{mm}.AwayCenter>0.05)./sum(pval{mm}.ToCenter>0);
    NumUnits.AwayCenter(mm) = sum(pval{mm}.AwayCenter<0.05 & pval{mm}.ToCenter>0.05)./sum(pval{mm}.AwayCenter>0);
    NumUnits.Both(mm) = sum(pval{mm}.AwayCenter<0.05 & pval{mm}.ToCenter<0.05)./sum(pval{mm}.AwayCenter>0);
        NumUnits.None(mm) = sum(pval{mm}.AwayCenter>0.05 & pval{mm}.ToCenter>0.05)./sum(pval{mm}.AwayCenter>0);

    KappaAllUnits.ToCenter = [KappaAllUnits.ToCenter,Kappa{mm}.ToCenter(GoodUnits)];
    KappaAllUnits.AwayCenter = [KappaAllUnits.AwayCenter,Kappa{mm}.AwayCenter(GoodUnits)];
    MuAllUnits.ToCenter = [MuAllUnits.ToCenter,mu{mm}.ToCenter(GoodUnits)];
    MuAllUnits.AwayCenter = [MuAllUnits.AwayCenter,mu{mm}.AwayCenter(GoodUnits)];
    
end

figure
Cols = {UMazeColors('shock'),UMazeColors('safe')};
MakeSpreadAndBoxPlot_SB({KappaAllUnits.ToCenter,KappaAllUnits.AwayCenter},Cols,[1,2])
[p,h5,stats] = signrank(KappaAllUnits.ToCenter,KappaAllUnits.AwayCenter)
sigstar({{1,2}},p),
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:2,'XTickLabel',{'ToCenter','AwayCenter'})
ylabel('Kappa')

figure
pie([nanmean(NumUnits.ToCenter),nanmean(NumUnits.Both),nanmean(NumUnits.AwayCenter),nanmean(NumUnits.None)])
colormap([UMazeColors('shock');UMazeColors('center');UMazeColors('safe');[1 1 1]])

figure
subplot(3,3,[2,3,5,6])
plot(MuAllUnits.AwayCenter,MuAllUnits.ToCenter,'.','MarkerSize',10,'color','k'), hold on
plot(MuAllUnits.AwayCenter,MuAllUnits.ToCenter+2*pi,'.','MarkerSize',10,'color','k')
plot(MuAllUnits.AwayCenter+2*pi,MuAllUnits.ToCenter,'.','MarkerSize',10,'color','k')
plot(MuAllUnits.AwayCenter+2*pi,MuAllUnits.ToCenter+2*pi,'.','MarkerSize',10,'color','k')
axis tight
set(gca,'LineWidth',2,'FontSize',15)

subplot(3,3,[1,4])
[Y,X] = hist([MuAllUnits.ToCenter,MuAllUnits.ToCenter+2*pi],[0:4*pi/40:4*pi]);
stairs(Y,X,'linewidth',3,'color',UMazeColors('shock'))
axis tight
set(gca,'LineWidth',2,'FontSize',15)
box off
ylabel('Phase')

subplot(3,3,[8,9])
[Y,X] = hist([MuAllUnits.AwayCenter,MuAllUnits.AwayCenter+2*pi],[0:4*pi/40:4*pi]);
stairs(X,Y,'linewidth',3,'color',UMazeColors('safe'))
axis tight
set(gca,'LineWidth',2,'FontSize',15)
box off
xlabel('Phase')
[p, f] = circ_ktest(MuAllUnits.AwayCenter, MuAllUnits.ToCenter);


%% Spectra

figure

clf
subplot(2,3,1)
SpecAway = [];
SpecTo = [];
for nmouse  = 1:7
    SpecAway = [SpecAway;MeanSpecH.AwayCenter(nmouse,:)./sum(MeanSpecH.AwayCenter(nmouse,:))];
    SpecTo = [SpecTo;MeanSpecH.ToCenter(nmouse,:)./sum(MeanSpecH.ToCenter(nmouse,:))];
end
errorbar(Spectro{3},nanmean(SpecAway),stdError(SpecAway),'color','b')
hold on
errorbar(Spectro{3},nanmean(SpecTo),stdError(SpecTo),'color','r')
title('HPC')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
ylabel('Power - AU')
legend('AwayOpen','TowardsOpen')

subplot(2,3,2)
SpecAway = [];
SpecTo = [];
for nmouse  = 1:7
    SpecAway = [SpecAway;MeanSpecB.AwayCenter(nmouse,:)./sum(MeanSpecB.AwayCenter(nmouse,:))];
    SpecTo = [SpecTo;MeanSpecB.ToCenter(nmouse,:)./sum(MeanSpecB.ToCenter(nmouse,:))];
end
errorbar(Spectro{3},nanmean(SpecAway),stdError(SpecAway),'color','b')
hold on
errorbar(Spectro{3},nanmean(SpecTo),stdError(SpecTo),'color','r')
title('OB')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
ylabel('Power - AU')

subplot(2,3,3)
SpecAway = [];
SpecTo = [];
for nmouse  = 1:7
    SpecAway = [SpecAway;MeanSpecP.AwayCenter(nmouse,:)./sum(MeanSpecP.AwayCenter(nmouse,:))];
    SpecTo = [SpecTo;MeanSpecP.ToCenter(nmouse,:)./sum(MeanSpecP.ToCenter(nmouse,:))];
end
errorbar(Spectro{3},nanmean(SpecAway),stdError(SpecAway),'color','b')
hold on
errorbar(Spectro{3},nanmean(SpecTo),stdError(SpecTo),'color','r')
title('PFC')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
ylabel('Power - AU')

subplot(2,3,4)
errorbar(Spectro{3},nanmean(MeanSpecB_P.AwayCenter),stdError(MeanSpecB_P.AwayCenter),'color','b')
hold on
errorbar(Spectro{3},nanmean(MeanSpecB_P.ToCenter),stdError(MeanSpecB_P.ToCenter),'color','r')
title('OB_PFC')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
ylabel('Coherence')

subplot(2,3,5)
errorbar(Spectro{3},nanmean(MeanSpecH_P.AwayCenter),stdError(MeanSpecH_P.AwayCenter),'color','b')
hold on
errorbar(Spectro{3},nanmean(MeanSpecH_P.ToCenter),stdError(MeanSpecH_P.ToCenter),'color','r')
title('HPC_PFC')
set(gca,'Linewidth',2,'FontSize',18),xlabel('Frequency'),box off
ylabel('Coherence')

