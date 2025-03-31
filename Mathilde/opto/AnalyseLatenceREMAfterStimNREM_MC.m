
Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz');
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');

% Dir{2} = RestrictPathForExperiment(Dir{2}, 'nMice', [1074 675 733 1136 1137]);% %%1109  648 1076


% Dir{2} = RestrictPathForExperiment(Dir{2}, 'nMice', [675 733 1137 1074 1136]);%1109  remettre 648?

Dir{2} = RestrictPathForExperiment(Dir{2}, 'nMice', [675 733 1137 1136 648 1074]);%

number=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    if exist('SleepScoring_OBGamma.mat')
        a{i}=load('SleepScoring_OBGamma.mat', 'WakeWiNoise','REMEpochWiNoise','SWSEpochWiNoise');
    else
        a{i}=load('SleepScoring_Accelero.mat', 'WakeWiNoise','REMEpochWiNoise','SWSEpochWiNoise');
    end
    
    latencyREMAfterStimNREM = LatencyREMAfterStimulationInSWS_MC(a{i}.WakeWiNoise,a{i}.SWSEpochWiNoise,a{i}.REMEpochWiNoise);
    dataLatencyToSWS{i}=latencyREMAfterStimNREM;
    
    for k=1:length(dataLatencyToSWS)
        AvLatencyToSWS_med(k)=nanmedian(dataLatencyToSWS{k}(:),1);
        AvLatencyToSWS_mean(k)=nanmean(dataLatencyToSWS{k}(:),1);

    end
    
%     MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end

%%

numberOpto=1;
for j=1:length(Dir{2}.path)
    cd(Dir{2}.path{j}{1});
    if exist('SleepScoring_OBGamma.mat')
        b{j}=load('SleepScoring_OBGamma.mat', 'WakeWiNoise','REMEpochWiNoise','SWSEpochWiNoise');
    else
        b{j}=load('SleepScoring_Accelero.mat', 'WakeWiNoise','REMEpochWiNoise','SWSEpochWiNoise');
    end
    
    latencyREMAfterStimNREM = LatencyREMAfterStimulationInSWS_MC(b{j}.WakeWiNoise,b{j}.SWSEpochWiNoise,b{j}.REMEpochWiNoise);
    dataLatencyToSWSopto{j}=latencyREMAfterStimNREM;
    
    for k=1:length(dataLatencyToSWSopto)
        AvLatencyToSWSopto_med(k)=nanmedian(dataLatencyToSWSopto{k}(:),1);
                AvLatencyToSWSopto_mean(k)=nanmean(dataLatencyToSWSopto{k}(:),1);

    end
    
%     MouseId(numberOpto) = Dir{2}.nMice{j} ;
    numberOpto=numberOpto+1;
end

%%
% figure,hist(AvLatencyToSWSopto)
% figure,hist(AvLatencyToSWS)
col_ctrl=[.8 .8 .8];
% col_chr2=[.4 .8 1];
col_chr2=[.4 .4 .4];

figure,subplot(221),PlotErrorBarN_KJ({AvLatencyToSWS_med/1e4 AvLatencyToSWSopto_med/1e4},'newfig',0,'Paired',0,'ShowSigstar','sig');
makepretty
xticks([1:2]); xticklabels({'mCherry','ChR2'});
p=ranksum(AvLatencyToSWS_med/1e4, AvLatencyToSWSopto_med/1e4);
title(['p=', num2str(p)])

subplot(222),MakeSpreadAndBoxPlot2_SB({AvLatencyToSWS_med/1e4, AvLatencyToSWSopto_med/1e4},{col_ctrl, col_chr2},[1:2],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:2]); xticklabels({'mCherry','ChR2'});
xtickangle(0)
makepretty
p=ranksum(AvLatencyToSWS_med/1e4, AvLatencyToSWSopto_med/1e4);
title(['p=', num2str(p)])

subplot(223),PlotErrorBarN_KJ({AvLatencyToSWS_mean/1e4 AvLatencyToSWSopto_mean/1e4},'newfig',0,'Paired',0,'ShowSigstar','sig');
makepretty
xticks([1:2]); xticklabels({'mCherry','ChR2'});
p=ranksum(AvLatencyToSWS_mean/1e4, AvLatencyToSWSopto_mean/1e4);
title(['p=', num2str(p)])

subplot(224),MakeSpreadAndBoxPlot2_SB({AvLatencyToSWS_mean/1e4, AvLatencyToSWSopto_mean/1e4},{col_ctrl, col_chr2},[1:2],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:2]); xticklabels({'mCherry','ChR2'});
xtickangle(0)
makepretty
p=ranksum(AvLatencyToSWS_mean/1e4, AvLatencyToSWSopto_mean/1e4);
title(['p=', num2str(p)])
%%
% AvLatencyToSWSopto_sorted=sort(AvLatencyToSWSopto_med);
% AvLatencyToSWS_sorted=sort(AvLatencyToSWS_med);
% 
% 
% figure,MakeSpreadAndBoxPlot2_SB({AvLatencyToSWS_sorted(1:3)/1e4, AvLatencyToSWSopto_sorted/1e4},{},[1:2],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:2]); xticklabels({'CTRL','CHR2'});