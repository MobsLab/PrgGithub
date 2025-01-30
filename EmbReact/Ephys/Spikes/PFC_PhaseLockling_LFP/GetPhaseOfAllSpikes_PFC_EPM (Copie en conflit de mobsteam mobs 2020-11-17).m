clear all
MiceNumber=[490,507,508,509,510,512,514];
SessNames={'EPM'};
Dir = PathForExperimentsEmbReact(SessNames{1});

nbin=30;
nmouse=1;

SpeedLim = 10;
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

            OpenEp=dropShortIntervals(Behav.ZoneEpoch{1},5*1e4);
            ClosedEp=dropShortIntervals(Behav.ZoneEpoch{2},5*1e4);
            
            if MovLim
                MovEpoch = thresholdIntervals(Behav.Vtsd,SpeedLim,'Direction','Above');
                MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4);
                OpenEp = and(OpenEp,MovEpoch);
                ClosedEp = and(ClosedEp,MovEpoch);
            end
            
            DurEp.Open(nmouse,ddd)=sum(Stop(OpenEp,'s')-Start(OpenEp,'s'));
            DurEp.Close(nmouse,ddd)=sum(Stop(ClosedEp,'s')-Start(ClosedEp,'s'));
            
%             load('InstFreqAndPhase_HNeuronPhaseLocking.mat')
            load('InstFreqAndPhase_BNeuronPhaseLocking.mat')

            for sp=1:length(S)
                
               
                % Only open arm
                PhasesSpikes.Open{nmouse}{sp}{ddd} = Data(Restrict(PhaseSpikes.WV{sp}.Transf,OpenEp));
                
                % Only closed arm
                PhasesSpikes.Closed{nmouse}{sp}{ddd} = Data(Restrict(PhaseSpikes.WV{sp}.Transf,ClosedEp));
                
                
            end
        end
        nmouse=nmouse+1;
    end
end




clear Kappa mu
for nmouse=1:length(PhasesSpikes.Closed)
    MaxTime=0;
    clear AllS
    
    for sp=1:length(PhasesSpikes.Closed{nmouse})
        
        % Get all Closed spike phases
        AllSpPhas.Closed=[];
        for ddd=1:length(PhasesSpikes.Closed{nmouse}{sp})
            try
                AllSpPhas.Closed=[AllSpPhas.Closed;PhasesSpikes.Closed{nmouse}{sp}{ddd}];
            end
        end
        
        % Get all Open spike phases
        AllSpPhas.Open=[];
        for ddd=1:length(Dir.path{nmouse})
            try
                AllSpPhas.Open=[AllSpPhas.Open;PhasesSpikes.Open{nmouse}{sp}{ddd}];
            end
        end
        
        [val,ind]=min([length(AllSpPhas.Open),length(AllSpPhas.Closed)]);
        if not(isempty(AllSpPhas.Closed))|not(isempty(AllSpPhas.Open))
            if ind==1
                AllSpPhas.Closed=randsample(AllSpPhas.Closed,val);
            else
                AllSpPhas.Open=randsample(AllSpPhas.Open,val);
            end
        end
        
        
        if not(isempty(AllSpPhas.Closed))
            [mu{nmouse}.Closed(sp), Kappa{nmouse}.Closed(sp), pval{nmouse}.Closed(sp), Rmean, delta, sigma,confDw,confUp] = CircularMean(AllSpPhas.Closed);
        else
            Kappa{nmouse}.Closed(sp)=NaN;
            mu{nmouse}.Closed(sp)=NaN;
            pval{nmouse}.Closed(sp)=NaN;
        end
        
        if not(isempty(AllSpPhas.Open))
            [mu{nmouse}.Open(sp), Kappa{nmouse}.Open(sp), pval{nmouse}.Open(sp), Rmean, delta, sigma,confDw,confUp] = CircularMean(AllSpPhas.Open);
        else
            Kappa{nmouse}.Open(sp)=NaN;
            mu{nmouse}.Open(sp)=NaN;
            pval{nmouse}.Open(sp)=NaN;
        end
    end
end

if MovLim==0
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis
save('PFCUnitsResponseToOBPhaseEPM.mat','Kappa','mu','pval')
else
 cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis
save('PFCUnitsResponseToOBPhaseEPMMovLim.mat','Kappa','mu','pval')   
end


%%
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis
load('PFCUnitsResponseToOBPhaseEPM.mat','Kappa','mu','pval')

KappaAllUnits.Open = [];
KappaAllUnits.Closed = [];
MuAllUnits.Open = [];
MuAllUnits.Closed = [];


for mm = 1:length(Kappa)
    GoodUnits = find(or(pval{mm}.Open<0.05,pval{mm}.Closed<0.05));
    NumUnits.Open(mm) = sum(pval{mm}.Open<0.05 & pval{mm}.Closed>0.05)./sum(pval{mm}.Open>0);
    NumUnits.Closed(mm) = sum(pval{mm}.Closed<0.05 & pval{mm}.Open>0.05)./sum(pval{mm}.Closed>0);
    NumUnits.Both(mm) = sum(pval{mm}.Closed<0.05 & pval{mm}.Open<0.05)./sum(pval{mm}.Closed>0);
        NumUnits.None(mm) = sum(pval{mm}.Closed>0.05 & pval{mm}.Open>0.05)./sum(pval{mm}.Closed>0);

    KappaAllUnits.Open = [KappaAllUnits.Open,Kappa{mm}.Open(GoodUnits)];
    KappaAllUnits.Closed = [KappaAllUnits.Closed,Kappa{mm}.Closed(GoodUnits)];
    MuAllUnits.Open = [MuAllUnits.Open,mu{mm}.Open(GoodUnits)];
    MuAllUnits.Closed = [MuAllUnits.Closed,mu{mm}.Closed(GoodUnits)];
    
end

figure
Cols = {UMazeColors('shock'),UMazeColors('safe')};
MakeSpreadAndBoxPlot_SB({KappaAllUnits.Open,KappaAllUnits.Closed},Cols,[1,2])
[p,h5,stats] = signrank(KappaAllUnits.Open,KappaAllUnits.Closed)
sigstar({{1,2}},p),
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:2,'XTickLabel',{'Open','Closed'})
ylabel('Kappa')

figure
pie([nanmean(NumUnits.Open),nanmean(NumUnits.Both),nanmean(NumUnits.Closed),nanmean(NumUnits.None)])
colormap([UMazeColors('shock');UMazeColors('center');UMazeColors('safe');[1 1 1]])

figure
subplot(3,3,[2,3,5,6])
plot(MuAllUnits.Closed,MuAllUnits.Open,'.','MarkerSize',10,'color','k'), hold on
plot(MuAllUnits.Closed,MuAllUnits.Open+2*pi,'.','MarkerSize',10,'color','k')
plot(MuAllUnits.Closed+2*pi,MuAllUnits.Open,'.','MarkerSize',10,'color','k')
plot(MuAllUnits.Closed+2*pi,MuAllUnits.Open+2*pi,'.','MarkerSize',10,'color','k')
axis tight
set(gca,'LineWidth',2,'FontSize',15)

subplot(3,3,[1,4])
[Y,X] = hist([MuAllUnits.Open,MuAllUnits.Open+2*pi],[0:4*pi/40:4*pi]);
stairs(Y,X,'linewidth',3,'color',UMazeColors('shock'))
axis tight
set(gca,'LineWidth',2,'FontSize',15)
box off
ylabel('Phase')

subplot(3,3,[8,9])
[Y,X] = hist([MuAllUnits.Closed,MuAllUnits.Closed+2*pi],[0:4*pi/40:4*pi]);
stairs(X,Y,'linewidth',3,'color',UMazeColors('safe'))
axis tight
set(gca,'LineWidth',2,'FontSize',15)
box off
xlabel('Phase')
[p, f] = circ_ktest(MuAllUnits.Closed, MuAllUnits.Open);

