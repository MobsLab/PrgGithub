SessNames={'EPM','Habituation','TestPre','UMazeCond','TestPost','Extinction','SoundHab','SoundCond','SoundTest',...
    'Habituation_EyeShockTempProt'};%,'SleepPreUMaze','SleepPostUMaze','SleepPreSound','SleepPostSound'};

MiceNumber=[490,507,508,509,510,512,514];
rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/FMAToolbox/General/')
rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
FilterBands = [1:1:13;3:1:15];

for ss=1:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            
            for ddd=1:length(Dir.path{dd})
                
                cd(Dir.path{dd}{ddd})
                disp(Dir.path{dd}{ddd})

                mkdir('RayleighFreqAnalysis')
                load('SpikeData.mat')
                load('StateEpochSB.mat','Epoch')
                
                load('behavResources_SB.mat','Behav')
                FreezeEpoch = Behav.FreezeAccEpoch;
                
                NoFreezeEpoch = Epoch- FreezeEpoch;
                clear Epoch
                FileToLoad = {};
                if exist('LFPData/LocalBulb_left_Activity.mat')>0
                    FileToLoad = [FileToLoad,'LFPData/LocalBulb_left_Activity.mat'];
                end
                if exist('LFPData/LocalBulb_right_Activity.mat')>0
                    FileToLoad = [FileToLoad,'LFPData/LocalBulb_right_Activity.mat'];
                end
                if exist('LFPData/LocalHPC_left_Activity.mat')>0
                    FileToLoad = [FileToLoad,'LFPData/LocalHPC_left_Activity.mat'];
                end
                if exist('LFPData/LocalHPC_right_Activity.mat')>0
                    FileToLoad = [FileToLoad,'LFPData/LocalHPC_right_Activity.mat'];
                end
                load('ChannelsToAnalyse/Bulb_deep.mat')
                FileToLoad = [FileToLoad,['LFPData/LFP',num2str(channel),'.mat']];
                load('ChannelsToAnalyse/PFCx_deep.mat')
                FileToLoad = [FileToLoad,['LFPData/LFP',num2str(channel),'.mat']];
                try,load('ChannelsToAnalyse/dHPC_rip.mat')
                FileToLoad = [FileToLoad,['LFPData/LFP',num2str(channel),'.mat']];
                end
                try,load('ChannelsToAnalyse/dHPC_deep.mat')
                FileToLoad = [FileToLoad,['LFPData/LFP',num2str(channel),'.mat']];
                end
                
                for ff =  1:length(FileToLoad)
%                     if not(exist(['RayleighFreqAnalysis/Rayleigh_BandWidth_' FileToLoad{ff}(9:end-4) 'Spike.mat']))
                        disp(Dir.path{dd}{ddd})
                    tic
                    load(FileToLoad{ff})
                    disp(FileToLoad{ff})
                    [HS,PhaseSpikes,ModInfo,PhaseLFP]=RayleighFreq_SB(Restrict(LFP,NoFreezeEpoch),Restrict(S,NoFreezeEpoch),'FilterBands',FilterBands);
                    Epoch = NoFreezeEpoch;
                    save(['RayleighFreqAnalysis/Rayleigh_BandWidth_NoFz' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','Epoch','PhaseSpikes','ModInfo','FilterBands','-v7.3')
                    clear('HS','PhaseSpikes','ModInfo','PhaseLFP')
                    
                    if not(isempty(Start(FreezeEpoch)))
                        [HS,PhaseSpikes,ModInfo,PhaseLFP]=RayleighFreq_SB(Restrict(LFP,FreezeEpoch),Restrict(S,FreezeEpoch),'FilterBands',FilterBands);
                        Epoch = FreezeEpoch;
                        save(['RayleighFreqAnalysis/Rayleigh_BandWidth_FreezingOnly' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','PhaseSpikes','Epoch','ModInfo','FilterBands','PhaseLFP','-v7.3')
                        clear('HS','PhaseSpikes','ModInfo','PhaseLFP')
                    end
                    clear LFP
                    toc
%                     end
                end
                
                clear S Epoch FileToLoad FreezeEpoch
            end
        end
    end
end


%% Make one file with all the freezing data
clear all
SessNames={'UMazeCond'};
MiceNumber=[490,507,508,509,510,512,514];
for ss=1
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    for dd=1:length(Dir.path)
        
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            clear AllPhases
            
            % For each mouse collect all the phases of the spikes
            for ddd=1:length(Dir.path{dd})
                cd(Dir.path{dd}{ddd})
                disp(Dir.path{dd}{ddd})

                % Get the LFPs that are there
                FileToLoad = {};
                if exist('LFPData/LocalBulb_left_Activity.mat')>0
                    FileToLoad = [FileToLoad,'LFPData/LocalBulb_left_Activity.mat'];
                end
                if exist('LFPData/LocalBulb_right_Activity.mat')>0
                    FileToLoad = [FileToLoad,'LFPData/LocalBulb_right_Activity.mat'];
                end
                if exist('LFPData/LocalHPC_left_Activity.mat')>0
                    FileToLoad = [FileToLoad,'LFPData/LocalHPC_left_Activity.mat'];
                end
                if exist('LFPData/LocalHPC_right_Activity.mat')>0
                    FileToLoad = [FileToLoad,'LFPData/LocalHPC_right_Activity.mat'];
                end
                load('ChannelsToAnalyse/Bulb_deep.mat')
                FileToLoad = [FileToLoad,['LFPData/LFP',num2str(channel),'.mat']];
                load('ChannelsToAnalyse/PFCx_deep.mat')
                FileToLoad = [FileToLoad,['LFPData/LFP',num2str(channel),'.mat']];
                try,load('ChannelsToAnalyse/dHPC_rip.mat')
                    FileToLoad = [FileToLoad,['LFPData/LFP',num2str(channel),'.mat']];
                end
                try,load('ChannelsToAnalyse/dHPC_deep.mat')
                    FileToLoad = [FileToLoad,['LFPData/LFP',num2str(channel),'.mat']];
                end
                
                
                % Concatenate the spikes
                for ff=1:length(FileToLoad)
                    load(['RayleighFreqAnalysis/Rayleigh_BandWidth_FreezingOnly' FileToLoad{ff}(9:end-4) 'Spike.mat'])
                    if ddd == 1
                        for neur = 1:length(PhaseSpikes.Transf)
                            if min(size((PhaseSpikes.Transf{neur})))>2
                                AllPhases.(FileToLoad{ff}(9:end-4)).Transf{neur} = Data(PhaseSpikes.Transf{neur});
                                AllPhases.(FileToLoad{ff}(9:end-4)).Nontransf{neur} = Data(PhaseSpikes.Nontransf{neur});
                            else
                                AllPhases.(FileToLoad{ff}(9:end-4)).Transf{neur} = [];
                                AllPhases.(FileToLoad{ff}(9:end-4)).Nontransf{neur} = [];
                                
                            end
                        end
                    else
                        for neur = 1:length(PhaseSpikes.Transf)
                            try
                            AllPhases.(FileToLoad{ff}(9:end-4)).Transf{neur} = [AllPhases.(FileToLoad{ff}(9:end-4)).Transf{neur};Data(PhaseSpikes.Transf{neur})];
                            AllPhases.(FileToLoad{ff}(9:end-4)).Nontransf{neur} = [AllPhases.(FileToLoad{ff}(9:end-4)).Nontransf{neur};Data(PhaseSpikes.Nontransf{neur})];
                            end
                        end
                    end
                end
                
            end
            
            cd ..
            disp(cd)
            for ff=1:length(FileToLoad)
                clear PhaseSpikes
                PhaseSpikes.Transf = AllPhases.(FileToLoad{ff}(9:end-4)).Transf;
                PhaseSpikes.Nontransf = AllPhases.(FileToLoad{ff}(9:end-4)).Nontransf;
                for neur = 1:length(PhaseSpikes.Transf)
                    [HS{neur},ModInfoTemp.Transf{neur}] = MakeRayleighFigure_SB(PhaseSpikes.Transf{neur},FilterBands,'doplot',0);
                    ModInfo.mu.Transf(:,neur) = ModInfoTemp.Transf{neur}.mu;
                    ModInfo.Kappa.Transf(:,neur) = ModInfoTemp.Transf{neur}.Kappa;
                    ModInfo.pval.Transf(:,neur) = ModInfoTemp.Transf{neur}.pval;
                    ModInfo.Rmean.Transf(:,neur) = ModInfoTemp.Transf{neur}.Rmean;

                    [~,ModInfoTemp.Nontransf{neur}] = MakeRayleighFigure_SB(PhaseSpikes.Nontransf{neur},FilterBands,'doplot',0);
                    ModInfo.mu.Nontransf(:,neur) = ModInfoTemp.Nontransf{neur}.mu;
                    ModInfo.Kappa.Nontransf(:,neur) = ModInfoTemp.Nontransf{neur}.Kappa;
                    ModInfo.pval.Nontransf(:,neur) = ModInfoTemp.Nontransf{neur}.pval;
                    ModInfo.Rmean.Nontransf(:,neur) = ModInfoTemp.Nontransf{neur}.Rmean;

                end
                mkdir('RayleighFreqAnalysis')
                save(['RayleighFreqAnalysis/Rayleigh_BandWidth_FreezingOnly' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','PhaseSpikes','ModInfo','FilterBands','-v7.3')
                clear ModInfo HS PhaseSpikes ModInfoTemp
            end
        end
    end
end


