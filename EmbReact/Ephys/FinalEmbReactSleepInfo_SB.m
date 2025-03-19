SaveFigPlace= '/home/mobsmorty/Dropbox/Mobs_member/SophieBagur/Figures/SleepAllMiceUMaze';
SessNames={'SleepPreUMaze' 'SleepPostUMaze' 'SleepPre_EyeShock' 'SleepPost_EyeShock' 'SleepPreSound' 'SleepPostSound' 'SleepPostEPM' 'SleepPreEPM',...
    'SleepPre_PreDrug' 'SleepPost_PreDrug' 'SleepPost_PostDrug'};


for ss=1:length(SessNames)
    
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
                    cd(Dir.path{d}{dd})
                    disp(Dir.path{d}{dd})

                    
                    PosSlash = findstr(Dir.path{d}{dd},'/');
                    SessionIDMouse = Dir.path{d}{dd}(PosSlash(end-1)+1:PosSlash(end)-1);
                    
                    SleepScoring_Accelero_OBgamma('recompute',1)
                    
                    %% Sleep event
                    disp('getting sleep signals')
                    CreateSleepSignals('recompute',1,'scoring','ob');
                    
                    %% Substages
                    disp('getting sleep stages')
                    [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','ob');
                    save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
                    [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
                    save('SleepSubstages', 'Epoch', 'NameEpoch')
                    
                    %% Id figure 1
                    disp('making ID fig1')
                    MakeIDSleepData
                    PlotIDSleepData('scoring','ob');
                    saveas(1,'IDFig1.png')
                    saveas(1,[SaveFigPlace filesep SessionIDMouse filesep 'IDFig1.png'])
                    close all
                    
                    %% Id figure 2
                    disp('making ID fig2')
                    MakeIDSleepData2('scoring','ob');
                    PlotIDSleepData2('scoring','ob');
                    saveas(1,'IDFig2.png')
                    saveas(2,[SaveFigPlace filesep SessionIDMouse filesep 'IDFig2.png'])

                    MakeData_CorticalClusters
%                     channelsUsed = GetDifferentLocationStructure('PFCx');
%                     load('IdFigureData2.mat','down_curves');
%                     load('ChannelsToAnalyse/PFCx_clusters.mat','clusters','channels')
%                     cols = lines(5);
%                     for l = 1:5
%                        plot(-2:0.1:-1,-2:0.1:-1,'color',cols(l,:)), hold on
%                     end
%                     for k = 1:length(channelsUsed)
%                         ch = find(channels==channelsUsed(k));
%                         plot(down_curves{k}(:,1),down_curves{k}(:,2),'color',cols(clusters(ch),:)), hold on
%                     end
%                     xlim([-0.8 0.8])
%                     legend({'1','2','3','4','5'})



                    
                    
                    close all
        end
    end
end
