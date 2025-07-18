clear all
MiceNumber=[490,507,508,509,510,512,514];
epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
SessionNames = {'UMazeCond'};
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';

Dir{1} = PathForExperimentsEmbReact(SessionNames{1});

for sess=1:length(SessionNames)
    for mm=7%length(MiceNumber)
        for d=1:length(Dir{sess}.path)
            if Dir{sess}.ExpeInfo{d}{1}.nmouse==MiceNumber(mm)
                tps=0;
                clear Snew ZoneEpoch ZoneEpoch_Run  RunningEpochNew
                RunningEpochNew=intervalSet([],[]);
                for ep=1:5
                    ZoneEpoch{ep}=intervalSet([],[]);
                end
                
                for dd=1:length(Dir{sess}.path{d})
                    cd(Dir{sess}.path{d}{dd})
                    disp(Dir{sess}.path{d}{dd})
                    load('SpikeData.mat')
                    load('behavResources_SB.mat')
                    load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
                    load('LFPData/LFP0.mat')
                    tpsmax=max(Range(LFP));
                    TotalNoiseEpoch=TotalNoiseEpoch-TTLInfo.StimEpoch;
                    
                    % Get running period
                    [RunningEpoch,RunSpeed]=GetRunPer(Behav.Xtsd,Behav.Ytsd,4,0);
                    RunningEpoch=RunningEpoch-TotalNoiseEpoch;
                    for sp=1:length(S)
                        if dd==1
                            Snew{sp}=S{sp};
                        else
                            Snew{sp}=ts([Range(Snew{sp});Range(S{sp})+tps]);
                        end
                    end
                    
                    RunningEpochNew=intervalSet([Start(RunningEpochNew);Start(RunningEpoch)+tps],...
                        [Stop(RunningEpochNew);Stop(RunningEpoch)+tps]);
                    for ep=1:5
                        ZoneEpoch{ep} = intervalSet([Start(ZoneEpoch{ep});Start(Behav.ZoneEpoch{ep})+tps],...
                            [Stop(ZoneEpoch{ep});Stop(Behav.ZoneEpoch{ep})+tps]);
                    end
                    tps=tpsmax+tps;
                end
                
                % Create epochs for analysis
                for ep=1:5
                    ZoneEpoch_Run{ep} = and(ZoneEpoch{ep},RunningEpochNew);
                    EpochDur.All{mm,sess}(ep) = sum(Stop(ZoneEpoch{ep},'s')-Start(ZoneEpoch{ep},'s'));
%                     EpochDur.un{mm,sess}(ep) = sum(Stop(ZoneEpoch_Run{ep},'s')-Start(ZoneEpoch_Run{ep},'s'));
                end
                
                for sp = 1 : length(S)
                    % Run only
                    EpochFR{mm,sess}(sp).Run = Compare_FR_between_epoch(Snew{sp},ZoneEpoch_Run,num_bootstraps,'epoch_names',epoch_names,'pairs_to_compare',[1,2]);
                end
                
            end
        end
        
        save([SaveFolder 'Firing_RunCond_NewRandomisation_',num2str(mm),'.mat'],'EpochDur','EpochFR')
        clear EpochDur EpochFR
    end
end
