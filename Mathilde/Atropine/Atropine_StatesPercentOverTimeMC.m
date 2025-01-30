%% input dir
% DirAtropineMC = PathForExperimentsAtropine_MC('Atropine');

% DirBaselineMC = PathForExperimentsAtropine_MC('BaselineSleep');
DirAtropineMC = PathForExperimentsAtropine_MC('CNO_Atropine_DreaddMouse');


DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);

%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);

% DirAtropineTG = PathForExperiments_TG('atropine_Atropine');
% DirBaselineTG = PathForExperiments_TG('atropine_Baseline');

% DirBaseline = MergePathForExperiment(DirBaselineMC, DirBaselineTG);
% DirAtropine = MergePathForExperiment(DirAtropineMC, DirAtropineTG);

% DirCNOSalineCtrlMC = PathForExperimentsAtropine_MC('CNO_Saline_CtrlMouse');
% DirCNOAtropineMC = PathForExperimentsAtropine_MC('CNO_Atropine_DreaddMouse');

%%

for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    load SleepScoring_OBGamma Wake REMEpoch SWSEpoch
    Density_SWS_Baseline{i}=DensitySleepStage_MC(Wake,SWSEpoch,REMEpoch,'sws',90);
    Density_REM_Baseline{i}=DensitySleepStage_MC(Wake,SWSEpoch,REMEpoch,'rem',90);
    Density_Wake_Baseline{i}=DensitySleepStage_MC(Wake,SWSEpoch,REMEpoch,'wake',90);
    clear Wake REMEpoch SWSEpoch
end

for j=1:length(DirAtropineMC.path)
    cd(DirAtropineMC.path{j}{1});
    load SleepScoring_OBGamma Wake REMEpoch SWSEpoch
    Density_SWS_Atropine{j}=DensitySleepStage_MC(Wake,SWSEpoch,REMEpoch,'sws',90);
    Density_REM_Atropine{j}=DensitySleepStage_MC(Wake,SWSEpoch,REMEpoch,'rem',90);
    Density_Wake_Atropine{j}=DensitySleepStage_MC(Wake,SWSEpoch,REMEpoch,'wake',90);
    clear Wake REMEpoch SWSEpoch
end

%%
same_len = 346;

for i=1:length(DirSaline.path)
    dataDensitySWS_Baseline{i} = Data(Density_SWS_Baseline{i});
    dataDensityREM_Baseline{i} = Data(Density_REM_Baseline{i});
    dataDensityWake_Baseline{i} = Data(Density_Wake_Baseline{i});
end
for ii=1:length(DirSaline.path)
avData_densitySWS_basal(ii,:) = dataDensitySWS_Baseline{ii}(1:same_len,:);
avData_densityREM_basal(ii,:) = dataDensityREM_Baseline{ii}(1:same_len,:);
avData_densityWake_basal(ii,:) = dataDensityWake_Baseline{ii}(1:same_len,:);
end

for j=1:length(DirAtropineMC.path)
    dataDensitySWS_Atropine{j} = Data(Density_SWS_Atropine{j});
    dataDensityREM_Atropine{j} = Data(Density_REM_Atropine{j});
    dataDensityWake_Atropine{j} = Data(Density_Wake_Atropine{j});
end
for jj=1:length(DirAtropineMC.path)
avData_densitySWS_atropine(jj,:) = dataDensitySWS_Atropine{jj}(1:same_len,:);
avData_densityREM_atropine(jj,:) = dataDensityREM_Atropine{jj}(1:same_len,:);
avData_densityWake_atropine(jj,:) = dataDensityWake_Atropine{jj}(1:same_len,:);
end
% %%
% figure, subplot(211), plot(Range(Density_SWS_Baseline{1},'s'), mean(dataDensitySWS_Baseline,2),'b','linewidth',2), hold on
% plot(Range(Density_SWS_Baseline{1},'s'), mean(dataDensityREM_Baseline,2),'r','linewidth',2)
% plot(Range(Density_SWS_Baseline{1},'s'), mean(dataDensityWake_Baseline,2),'k','linewidth',2)
% ylabel('Percentage (%)')
% title('baseline')
% 
% subplot(212), plot(Range(Density_SWS_Atropine{1},'s'), mean(dataDensitySWS_Atropine,2),'b','linewidth',2), hold on
% plot(Range(Density_SWS_Atropine{1},'s'), mean(dataDensityREM_Atropine,2),'r','linewidth',2)
% plot(Range(Density_SWS_Atropine{1},'s'), mean(dataDensityWake_Atropine,2),'k','linewidth',2)
% ylabel('Percentage (%)')
% xlabel('Time (s)')
% title('atropine')
% legend({'NREM','REM','Wake'})


%%
% test=Range(NewtsdZT);
% vecTimeDay = GetTimeOfTheDay_MC(Range(NewtsdZT),0);
% 
% 

t = Range(Density_SWS_Baseline{1},'s');
t = t(1:same_len,:);

figure
subplot(211)
hold on
shadedErrorBar(t, nanmean(avData_densityWake_basal), stdError(avData_densityWake_basal), 'k', 1);
shadedErrorBar(t, nanmean(avData_densitySWS_basal), stdError(avData_densitySWS_basal), 'b', 1);
shadedErrorBar(t, nanmean(avData_densityREM_basal), stdError(avData_densityREM_basal), 'r', 1);
ylabel('Percentage (%)')
title('saline')
makepretty
subplot(212)
hold on
shadedErrorBar(t, nanmean(avData_densityWake_atropine), stdError(avData_densityWake_atropine), 'k', 1);
shadedErrorBar(t, nanmean(avData_densitySWS_atropine), stdError(avData_densitySWS_atropine), 'b', 1);
shadedErrorBar(t, nanmean(avData_densityREM_atropine), stdError(avData_densityREM_atropine), 'r', 1);
ylabel('Percentage (%)')
xlabel('Time (s)')
title('atropine')
legend({'NREM','REM','Wake'})
makepretty