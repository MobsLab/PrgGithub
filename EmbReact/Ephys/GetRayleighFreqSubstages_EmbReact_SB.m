SessNames={'SleepPreUMaze','SleepPostUMaze','SleepPreSound','SleepPostSound'};

MiceNumber=[490,507,508,509,510,512,514];

for ss=1:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            
            for ddd=1:length(Dir.path{dd})
                
                cd(Dir.path{dd}{ddd})
                
                mkdir('RayleighFreqAnalysis')
                
                %% Get spikes
                load('SpikeData.mat')
                
                %% Get channels
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
                
                %% Get epochs
                clear EpToUse EpochNames
                load('SleepSubstages.mat')
                EpToUse = Epoch([1,2,3,4,5]);
                EpochNames = NameEpoch([1,2,3,4,5]);
                %% Define wake epoch with clean oscillations
                load('B_Low_Spectrum.mat')
                Sptsd_B = tsd(Spectro{2}*1e4,Spectro{1});
                WakeSpec = Data(Restrict(Sptsd_B,EpToUse{5}));
                WakeSpecPower = tsd(Range(Restrict(Sptsd_B,EpToUse{5})),nanmean(WakeSpec(:,40:60),2)-nanmean(WakeSpec(:,20:35),2));
                HighEpoc = thresholdIntervals(WakeSpecPower,1.5*1e5,'Direction','Above');
                HighEpoc = mergeCloseIntervals(HighEpoc,3*1e4);
                HighEpoc = dropShortIntervals(HighEpoc,1*1e4);
                EpToUse{6}  = HighEpoc;
                EpochNames{6} = 'Wake_GoodOscill';
                load('DownState.mat')
                
                load('IdFigureData.mat')
                if nb_neuron.all>30
                    down_PFCx = mergeCloseIntervals(down_PFCx,3*1e4);
                    SleepNoDown = Epoch{7}-down_PFCx;
                    SleepNoDown = dropShortIntervals(SleepNoDown,3*1e4);
                    SleepNoDown = intervalSet(Start(SleepNoDown)+1*1e4,Stop(SleepNoDown)-1e4);
                    if sum(Stop(SleepNoDown,'s')-Start(SleepNoDown,'s'))>10
                        EpToUse{7}  = SleepNoDown;
                        EpToUse{7}  = SleepNoDown;
                        EpochNames{7} = 'Sleep_NoDown';
                    end
                end
                
                FilterBands = [1:1:18;3:1:20];
                for ff =  1:length(FileToLoad)
                    clear LFP
                    load(FileToLoad{ff})
                    tic
                    for ep = 1:length(EpToUse)
                        if sum(Stop(EpToUse{ep},'s')-Start(EpToUse{ep},'s'))>10
                            disp(FileToLoad{ff})
                            if (exist(['RayleighFreqAnalysis/Rayleigh_BandWidth_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'Spike.mat']))==0
                                [HS,PhaseSpikes,ModInfo,PhaseLFP]=RayleighFreq_SB(Restrict(LFP,EpToUse{ep}),Restrict(S,EpToUse{ep}),'FilterBands',FilterBands);
                                save(['RayleighFreqAnalysis/Rayleigh_BandWidth_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','PhaseSpikes','ModInfo','FilterBands','-v7.3')
                                clear('HS','PhaseSpikes','ModInfo','PhaseLFP')
                            end
                        end
                    end
                    toc
                    clear LFP
                end
                
            end
        end
    end
end
