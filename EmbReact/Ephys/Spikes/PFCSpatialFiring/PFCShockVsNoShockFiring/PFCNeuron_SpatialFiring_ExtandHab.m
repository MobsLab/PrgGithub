if 0
clear all
MiceNumber=[490,507,508,509,510,512,514];
epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
SessionNames = {'Extinction'};
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';

Dir{1} = PathForExperimentsEmbReact(SessionNames{1});

for sess=1%:length(SessionNames)
    for mm=7:length(MiceNumber)
        for d=1:length(Dir{sess}.path)
            if Dir{sess}.ExpeInfo{d}{1}.nmouse==MiceNumber(mm)
                cd(Dir{sess}.path{d}{1})
                disp(Dir{sess}.path{d}{1})
                load('SpikeData.mat')
                load('behavResources_SB.mat')
                load('StateEpochSB.mat','Epoch','TotalNoiseEpoch')
                
                % Get running period
                [RunningEpoch,RunSpeed]=GetRunPer(Behav.Xtsd,Behav.Ytsd,4,0);
                
                % Create epochs for analysis
                for ep=1:5
                    ZoneEpoch_All{ep} = Behav.ZoneEpoch{ep}-TotalNoiseEpoch;
                    ZoneEpoch_Run{ep} = and(Behav.ZoneEpoch{ep},RunningEpoch)-TotalNoiseEpoch;
                    EpochDur.All{mm,sess}(ep) = sum(Stop(ZoneEpoch_All{ep},'s')-Start(ZoneEpoch_All{ep},'s'));
                    EpochDur.Run{mm,sess}(ep) = sum(Stop(ZoneEpoch_Run{ep},'s')-Start(ZoneEpoch_Run{ep},'s'));
                    EpochSpeed.All{mm,sess}(ep) = nanmean(Data(Restrict(Behav.Vtsd,ZoneEpoch_All{ep})));
                    EpochSpeed.Run{mm,sess}(ep) =  nanmean(Data(Restrict(Behav.Vtsd,ZoneEpoch_Run{ep})));
                end
                for sp = 1 : length(S)
                    
                    % Run only
                    EpochFR{mm,sess}(sp).Run = Compare_FR_between_epoch(S{sp},ZoneEpoch_Run,num_bootstraps,'epoch_names',epoch_names,'pairs_to_compare',[1,2]);
                end
                
            end
        end
    end
    save([SaveFolder 'Firing_Ext_NewRandomisation.mat'],'EpochDur','EpochSpeed','EpochFR')
end
end


