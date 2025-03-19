clear all
SessNames={'SleepPreUMaze' 'SleepPostUMaze' 'SleepPre_EyeShock',...
    'SleepPost_EyeShock' 'SleepPreSound' 'SleepPostSound',...
    'SleepPreEPM' 'SleepPostEPM' 'SleepPre_PreDrug' 'SleepPost_PostDrug' 'SleepPost_PreDrug'};

for ss=10:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    
    for dd=1:length(Dir.path)
        %        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
        
        for ddd=1:length(Dir.path{dd})
            cd(Dir.path{dd}{ddd})
            
            if not(exist('SleepSubstages.mat'))
                
                disp(Dir.path{dd}{ddd})
                try
                %% Sleep event
                CreateSleepSignals('recompute',1,'scoring','ob');
                
                %% Substages
                [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','ob');
                save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
                [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
                save('SleepSubstages', 'Epoch', 'NameEpoch')
                
                %% Id figure 1
                MakeIDSleepData
                PlotIDSleepData
                saveas(1,'IDFig1.png')
                close all
                
                %% Id figure 2
                MakeIDSleepData2
                PlotIDSleepData2
                saveas(1,'IDFig2.png')
                close all
                disp('success')
                end
            end
            
        end
    end
    %  end
end


%% Look at resulst
clear all
SessNames={'SleepPreUMaze','SleepPostUMaze','SleepPreSound','SleepPostSound'};

MiceNumber=[490,507,508,509,510,512,514];

for ss=1:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            for ddd=1:length(Dir.path{dd})
                cd(Dir.path{dd}{ddd})
                clear down_PFCx SWSEpoch deltas_PFCx
                load('IdFigureData.mat')
                load('StateEpochSB.mat','SWSEpoch')
                load('DownState.mat')
                load('DeltaWaves.mat')

                time_in_substages(5) = time_in_substages(5)./sum(time_in_substages);
                time_in_substages(1:4) = time_in_substages(1:4)./sum(time_in_substages(1:4));
                
                Prc_Nrem{ss}(find(Dir.ExpeInfo{dd}{1}.nmouse==MiceNumber),:) = time_in_substages;
                NumDown(ss,find(Dir.ExpeInfo{dd}{1}.nmouse==MiceNumber)) = length(Start(and(down_PFCx,SWSEpoch)))./sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
                NumDelta(ss,find(Dir.ExpeInfo{dd}{1}.nmouse==MiceNumber)) = length(Start(and(deltas_PFCx,SWSEpoch)))./sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));

            end
        end
    end
end

%Mouse with too few neurons
NumDown(:,2) = NaN;

figure
% for ss=1:length(SessNames)
% subplot(4,1,ss)
%     bar(Prc_Nrem{ss},'stacked')
% end
clf

for type = 1:5
AllPerc{type} = [Prc_Nrem{1}(:,type)';Prc_Nrem{2}(:,type)';Prc_Nrem{3}(:,type)';Prc_Nrem{4}(:,type)'];
AllPerc{type}(:,4) = NaN;
errorbar(1:4,nanmean(AllPerc{type}'),stdError(AllPerc{type}'),'linewidth',2)
hold on
end
set(gca,'XTick',[1:4],'XTickLabel',{'10h-12h','12h30-14h','16h-17h30','18h-19h30'})
legend('N1','N2','N3','REM','Wake')
ylabel('% total recording')
    