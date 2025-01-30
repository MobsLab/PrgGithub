clear all
MiceNumber=[490,507,508,509,510,512,514];
SessNames={'UMazeCond'};
Dir = PathForExperimentsEmbReact(SessNames{1});
nbin=30;
nmouse=1;
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
            FreezeEpoch=Behav.FreezeAccEpoch;
            ShockEp=dropShortIntervals(and(FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch,5*1e4);
            SafeEp=dropShortIntervals(and(FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch,5*1e4);
            DurEp.Shock(nmouse,ddd)=sum(Stop(ShockEp,'s')-Start(ShockEp,'s'));
            DurEp.Safe(nmouse,ddd)=sum(Stop(SafeEp,'s')-Start(SafeEp,'s'));
            
            load('InstFreqAndPhase_BNeuronPhaseLocking.mat')

            for sp=1:length(S)
                
                % All freezing
                PhasesSpikes.All{nmouse}{sp}{ddd} = Data(Restrict(PhaseSpikes.WV{sp}.Transf,Behav.FreezeEpoch));
                
                % Only shock side freezing
                PhasesSpikes.Shock{nmouse}{sp}{ddd} = Data(Restrict(PhaseSpikes.WV{sp}.Transf,ShockEp));
                
                % Only safe side freezing
                PhasesSpikes.Safe{nmouse}{sp}{ddd} = Data(Restrict(PhaseSpikes.WV{sp}.Transf,SafeEp));
                
                
            end
        end
        nmouse=nmouse+1;
    end
end




clear Kappa mu
for nmouse=1:length(PhasesSpikes.Safe)
    MaxTime=0;
    clear AllS
    
    for sp=1:length(PhasesSpikes.Safe{nmouse})
        
        % Get all safe spike phases
        AllSpPhas.Safe=[];
        for ddd=1:length(PhasesSpikes.Safe{nmouse}{sp})
            try
                AllSpPhas.Safe=[AllSpPhas.Safe;PhasesSpikes.Safe{nmouse}{sp}{ddd}];
            end
        end
        
        % Get all shock spike phases
        AllSpPhas.Shock=[];
        for ddd=1:length(Dir.path{nmouse})
            try
                AllSpPhas.Shock=[AllSpPhas.Shock;PhasesSpikes.Shock{nmouse}{sp}{ddd}];
            end
        end
        
        [val,ind]=min([length(AllSpPhas.Shock),length(AllSpPhas.Safe)]);
        if not(isempty(AllSpPhas.Safe))|not(isempty(AllSpPhas.Shock))
            if ind==1
                AllSpPhas.Safe=randsample(AllSpPhas.Safe,val);
            else
                AllSpPhas.Shock=randsample(AllSpPhas.Shock,val);
            end
        end
        
        
        if not(isempty(AllSpPhas.Safe))
            [mu{nmouse}.Safe(sp), Kappa{nmouse}.Safe(sp), pval{nmouse}.Safe(sp), Rmean, delta, sigma,confDw,confUp] = CircularMean(AllSpPhas.Safe);
        else
            Kappa{nmouse}.Safe(sp)=NaN;
            mu{nmouse}.Safe(sp)=NaN;
            pval{nmouse}.Safe(sp)=NaN;
        end
        
        if not(isempty(AllSpPhas.Shock))
            [mu{nmouse}.Shock(sp), Kappa{nmouse}.Shock(sp), pval{nmouse}.Shock(sp), Rmean, delta, sigma,confDw,confUp] = CircularMean(AllSpPhas.Shock);
        else
            Kappa{nmouse}.Shock(sp)=NaN;
            mu{nmouse}.Shock(sp)=NaN;
            pval{nmouse}.Shock(sp)=NaN;
        end
    end
end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis
save('PFCUnitsResponseToOBPhaseTwoFZ.mat','Kappa','mu','pval')
