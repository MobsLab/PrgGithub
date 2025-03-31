
Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz');
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');

number=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    if exist('SleepScoring_OBGamma.mat')
        a{i}=load('SleepScoring_OBGamma.mat', 'WakeWiNoise','REMEpochWiNoise','SWSEpochWiNoise');
    else
        a{i}=load('SleepScoring_Accelero.mat', 'WakeWiNoise','REMEpochWiNoise','SWSEpochWiNoise');
    end
    
    latencyToSWS=LatencyREMtoNREMafterOpto_MC(a{i}.WakeWiNoise,a{i}.SWSEpochWiNoise,a{i}.REMEpochWiNoise);
    dataLatencyToSWS{i}=latencyToSWS;
    
    for k=1:length(dataLatencyToSWS)
        AvLatencyToSWS(k)=nanmean(dataLatencyToSWS{k}(:),1);
    end
    
    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end



numberOpto=1;
for j=1:length(Dir{2}.path)
    cd(Dir{2}.path{j}{1});
    if exist('SleepScoring_OBGamma.mat')
        b{j}=load('SleepScoring_OBGamma.mat', 'WakeWiNoise','REMEpochWiNoise','SWSEpochWiNoise');
    else
        b{j}=load('SleepScoring_Accelero.mat', 'WakeWiNoise','REMEpochWiNoise','SWSEpochWiNoise');
    end
    
    latencyToSWSopto=LatencyREMtoNREMafterOpto_MC(b{j}.WakeWiNoise,b{j}.SWSEpochWiNoise,b{j}.REMEpochWiNoise);
    dataLatencyToSWSopto{j}=latencyToSWSopto;
    
    for k=1:length(dataLatencyToSWSopto)
        AvLatencyToSWSopto(k)=nanmean(dataLatencyToSWSopto{k}(:),1);
    end
    
    MouseId(numberOpto) = Dir{2}.nMice{j} ;
    numberOpto=numberOpto+1;
end


% figure,hist(AvLatencyToSWSopto)
% figure,hist(AvLatencyToSWS)
%%
figure,PlotErrorBarN_KJ({AvLatencyToSWS AvLatencyToSWSopto},'newfig',0,'Paired',0,'ShowSigstar','sig');


figure,MakeSpreadAndBoxPlot2_SB({AvLatencyToSWS, AvLatencyToSWSopto},{},[1:2],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:2]); xticklabels({'CTRL','CHR2'});

% figure,plot(cumsum(AvLatencyToSWS/sum(AvLatencyToSWS)),'k','LineWidth',2), hold on
% plot(cumsum(AvLatencyToSWSopto/sum(AvLatencyToSWSopto)),'b','LineWidth',2)
% legend('control','opto')

%%
AvLatencyToSWSopto_sorted=sort(AvLatencyToSWSopto);
AvLatencyToSWS_sorted=sort(AvLatencyToSWS);


figure,MakeSpreadAndBoxPlot2_SB({AvLatencyToSWS_sorted, AvLatencyToSWSopto_sorted(1:6)},{},[1:2],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:2]); xticklabels({'CTRL','CHR2'});