clear all
MiceNumber=[490,507,508,509,510,512,514];
epoch_names = {'Open','Closed','Centre'};
SessionNames = {'EPM'};
num_bootstraps = 5;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';

Dir{1} = PathForExperimentsEmbReact(SessionNames{1});

for sess=1:length(SessionNames)
    for mm=1:length(MiceNumber)
        mm
        for d=1:length(Dir{sess}.path)
            if Dir{sess}.ExpeInfo{d}{1}.nmouse==MiceNumber(mm)
                tps=0;
                clear Snew ZoneEpoch ZoneEpoch_Run  RunningEpochNew
                RunningEpochNew=intervalSet([],[]);
                for ep=1:3
                    ZoneEpoch{ep}=intervalSet([],[]);
                end
                for dd=1:length(Dir{sess}.path{d})
                    cd(Dir{sess}.path{d}{dd})
                    disp(Dir{sess}.path{d}{dd})
                    load('SpikeData.mat')
                    load('behavResources_SB.mat')
                    load('StateEpochSB.mat','Wake','TotalNoiseEpoch')
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
                    for ep=1:3
                        ZoneEpoch{ep} = intervalSet([Start(ZoneEpoch{ep});Start(Behav.ZoneEpoch{ep})+tps],...
                            [Stop(ZoneEpoch{ep});Stop(Behav.ZoneEpoch{ep})+tps]);
                    end
                    tps=tpsmax+tps;
                end
                
                % Create epochs for analysis
                for ep=1:3
                    ZoneEpoch_Run{ep} = and(ZoneEpoch{ep},RunningEpochNew);
                    EpochDur.All{mm,sess}(ep) = sum(Stop(ZoneEpoch{ep},'s')-Start(ZoneEpoch{ep},'s'));
                    EpochDur.Run{mm,sess}(ep) = sum(Stop(ZoneEpoch_Run{ep},'s')-Start(ZoneEpoch_Run{ep},'s'));
                end
                
                for sp = 1 : length(S)
                    for ep=1:3
                        % Run only
                        EpochFR{mm,sess}(sp).Run.(epoch_names{ep}) = FiringRateEpoch(Snew{sp},ZoneEpoch_Run{ep});
                        % All
                        EpochFR{mm,sess}(sp).All.(epoch_names{ep}) = FiringRateEpoch(Snew{sp},ZoneEpoch{ep});
                    end
                end
                
            end
        end
        
    end
end


OpenFR = []; ClosedFr = [];
for mm=1:length(MiceNumber)
    for sp = 1 : length(EpochFR{mm,1})
        OpenFR = [OpenFR, EpochFR{mm,1}(sp).Run.Open];
        ClosedFr = [ClosedFr, EpochFR{mm,1}(sp).Run.Closed];
    end
end

SpikyNeurons = (OpenFR>1 | ClosedFr>1);


ShockFR = []; SafeFr = [];
for mm=1:length(MiceNumber)
    for sp = 1 : length(EpochFR{mm})
        ShockFR = [ShockFR, EpochFR{mm}(sp).Run.Shock.real];
        SafeFr = [SafeFr, EpochFR{mm}(sp).Run.NoShock.real];
    end
end


ShockFRFz = []; SafeFrFz = [];
for mm=1:length(MiceNumber)
    for sp = 1 : length(EpochFR{mm})
        ShockFRFz = [ShockFRFz, EpochFR{mm}(sp).Fz.Shock.real];
        SafeFrFz = [SafeFrFz, EpochFR{mm}(sp).Fz.NoShock.real];
    end
end

ModEPM = (OpenFR-ClosedFr)./(OpenFR+ClosedFr);
ModUMazeFz = (ShockFRFz-SafeFrFz)./(ShockFRFz+SafeFrFz);
ModUMaze = (ShockFR-SafeFr)./(ShockFR+SafeFr);

NotNanVals = ~(isnan(ModEPM) | isnan(ModUMaze) | isnan(ModUMazeFz));

[R1,P1] = corr(ModEPM(NotNanVals & SpikyNeurons)',ModUMaze(NotNanVals & SpikyNeurons)');
[R2,P2] = corr(ModEPM(NotNanVals  & SpikyNeurons)',ModUMazeFz(NotNanVals  & SpikyNeurons)');
[R3,P3] = corr(ModUMazeFz(NotNanVals & SpikyNeurons)',ModUMaze(NotNanVals  & SpikyNeurons)');

plot3(ModEPM(NotNanVals & SpikyNeurons)',ModUMaze(NotNanVals  & SpikyNeurons)',ModUMazeFz(NotNanVals & SpikyNeurons)','*')



