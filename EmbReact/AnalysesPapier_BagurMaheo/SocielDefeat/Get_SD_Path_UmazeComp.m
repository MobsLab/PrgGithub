function [Dir_CD1_CD1cage,Dir_CD1_C57cage,Dir_Sleep_CD1InCage,Dir_Sleep_CD1NOTInCage,Dir_Sleep_Ctrl,...
    Info_CD1_CD1cage,Info_CD1_C57cage,Info_Sleep_CD1InCage,Info_Sleep_CD1NOTInCage,Info_Sleep_Ctrl] = Get_SD_Path_UmazeComp;


% WiSleep : % whether these mice have usable sleep after
% WiEPM : % whether these mice have usable EPM after
Keep2ndSD = 1; % if we keep second social defeat

%% Exposure to CD1 in CD1 cage
i=0;
i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage');
Info_CD1_CD1cage.WiSleep(i) = 1;
Info_CD1_CD1cage.WiEPM(i) = 0;
Info_CD1_CD1cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_tetrodesPFC');
Info_CD1_CD1cage.WiSleep(i) = 0;
Info_CD1_CD1cage.WiEPM(i) = 1;
Info_CD1_CD1cage.FirstSecond(i) = 1;

if Keep2ndSD
i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_secondSD_tetrodesPFC');
Info_CD1_CD1cage.WiSleep(i) = 0;
Info_CD1_CD1cage.WiEPM(i) = 1;
Info_CD1_CD1cage.FirstSecond(i) = 2;
end

if Keep2ndSD
i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_secondSD_firstOneSensoryExpo_tetrodesPFC');
Info_CD1_CD1cage.WiSleep(i) = 0;
Info_CD1_CD1cage.WiEPM(i) = 1;
Info_CD1_CD1cage.FirstSecond(i) = 2;
end

% Careful same mice twice
i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_PART1');
Info_CD1_CD1cage.WiSleep(i) = 1;
Info_CD1_CD1cage.WiEPM(i) = 0;
Info_CD1_CD1cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_PART2');
Info_CD1_CD1cage.WiSleep(i) = 1;
Info_CD1_CD1cage.WiEPM(i) = 0;
Info_CD1_CD1cage.FirstSecond(i) = 1;

%

i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO');
Info_CD1_CD1cage.WiSleep(i) = 0;
Info_CD1_CD1cage.WiEPM(i) = 0;
Info_CD1_CD1cage.FirstSecond(i) = 1;


i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO_tetrodesPFC');
Info_CD1_CD1cage.WiSleep(i) = 1;
Info_CD1_CD1cage.WiEPM(i) = 0;
Info_CD1_CD1cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_SalineInjection');
Info_CD1_CD1cage.WiSleep(i) = 1;
Info_CD1_CD1cage.WiEPM(i) = 0;
Info_CD1_CD1cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_noDREADD_BM_mice_SalineInjection');
Info_CD1_CD1cage.WiSleep(i) = 1;
Info_CD1_CD1cage.WiEPM(i) = 0;
Info_CD1_CD1cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_PFC_CNOInjection');
Info_CD1_CD1cage.WiSleep(i) = 0;
Info_CD1_CD1cage.WiEPM(i) = 0;
Info_CD1_CD1cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_CRH_VLPO_CNOInjection');
Info_CD1_CD1cage.WiSleep(i) = 0;
Info_CD1_CD1cage.WiEPM(i) = 0;
Info_CD1_CD1cage.FirstSecond(i) = 1;

if Keep2ndSD
i=i+1; Dir_CD1_CD1cage{i} = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_CRH_VLPO_SalineInjection_secondrun');
Info_CD1_CD1cage.WiSleep(i) = 1;
Info_CD1_CD1cage.WiEPM(i) = 0;   
Info_CD1_CD1cage.FirstSecond(i) = 2;
end


%% Exposure to CD1 in C57 cage
i=0;
i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage');
Info_CD1_C57cage.WiSleep(i) = 1;
Info_CD1_C57cage.WiEPM(i) = 0;
Info_CD1_C57cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage_tetrodesPFC');
Info_CD1_C57cage.WiSleep(i) = 0;
Info_CD1_C57cage.WiEPM(i) = 1;
Info_CD1_C57cage.FirstSecond(i) = 1;

if Keep2ndSD
    i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage_secondSD_tetrodesPFC');
    Info_CD1_C57cage.WiSleep(i) = 0;
    Info_CD1_C57cage.WiEPM(i) = 1;
    Info_CD1_C57cage.FirstSecond(i) = 2;

end

if Keep2ndSD
    i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage_secondSD_firstOneSensoryExpo_tetrodesPFC');
    Info_CD1_C57cage.WiSleep(i) = 0;
    Info_CD1_C57cage.WiEPM(i) = 1;
    Info_CD1_C57cage.FirstSecond(i) = 2;
end

i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO');
Info_CD1_C57cage.WiSleep(i) = 0;
Info_CD1_C57cage.WiEPM(i) = 0;
Info_CD1_C57cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO_tetrodesPFC');
Info_CD1_C57cage.WiSleep(i) = 1;
Info_CD1_C57cage.WiEPM(i) = 0;
Info_CD1_C57cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_CNOInjection');
Info_CD1_C57cage.WiSleep(i) = 0;
Info_CD1_C57cage.WiEPM(i) = 0;
Info_CD1_C57cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_SalineInjection');
Info_CD1_C57cage.WiSleep(i) = 1;
Info_CD1_C57cage.WiEPM(i) = 0;
Info_CD1_C57cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage_noDREADD_BM_mice_SalineInjection');
Info_CD1_C57cage.WiSleep(i) = 1;
Info_CD1_C57cage.WiEPM(i) = 0;
Info_CD1_C57cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_PFC_CNOInjection');
Info_CD1_C57cage.WiSleep(i) = 0;
Info_CD1_C57cage.WiEPM(i) = 0;
Info_CD1_C57cage.FirstSecond(i) = 1;

i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_CRH_VLPO_CNOInjection');
Info_CD1_C57cage.WiSleep(i) = 0;
Info_CD1_C57cage.WiEPM(i) = 0;
Info_CD1_C57cage.FirstSecond(i) = 1;

if Keep2ndSD
    i=i+1; Dir_CD1_C57cage{i} = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_CRH_VLPO_SalineInjection_secondrun');
    Info_CD1_C57cage.WiSleep(i) = 1;
    Info_CD1_C57cage.WiEPM(i) = 0;
    Info_CD1_C57cage.FirstSecond(i) = 2;
end

%% C57 post-encounter sleep, CD1 was in C57 cage
i=0;
i=i+1; Dir_Sleep_CD1InCage{i} = PathForExperiments_SD_MC('SleepPostSD');
Info_Sleep_CD1InCage.WiSleep(i) = 1;
Info_Sleep_CD1InCage.WiEPM(i) = 0;

i=i+1; Dir_Sleep_CD1InCage{i} = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_retroCre_PFC_VLPO_tetrodesPFC_SalineInjection');
Info_Sleep_CD1InCage.WiSleep(i) = 1;
Info_Sleep_CD1InCage.WiEPM(i) = 0;

i=i+1; Dir_Sleep_CD1InCage{i} = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
Info_Sleep_CD1InCage.WiSleep(i) = 1;
Info_Sleep_CD1InCage.WiEPM(i) = 0;

i=i+1; Dir_Sleep_CD1InCage{i} = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
Info_Sleep_CD1InCage.WiSleep(i) = 1;
Info_Sleep_CD1InCage.WiEPM(i) = 0;

i=i+1; Dir_Sleep_CD1InCage{i} = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_CRH_VLPO_SalineInjection_secondrun');
Info_Sleep_CD1InCage.WiSleep(i) = 1;
Info_Sleep_CD1InCage.WiEPM(i) = 0;

%% C57 post-encounter sleep, CD1 was never in C57 cage
i=0;
i=i+1; Dir_Sleep_CD1NOTInCage{i} = PathForExperiments_SD_MC('SleepPostSD_safe');
Info_Sleep_CD1NOTInCage.WiSleep(i) = 1;
Info_Sleep_CD1NOTInCage.WiEPM(i) = 0;

%% Control experiments, no SDS
i=0;
i=i+1; Dir_Sleep_Ctrl{i} = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_Sleep_Ctrl{i}=RestrictPathForExperiment(Dir_Sleep_Ctrl{i},'nMice',[1423 1424 1425 1426 1433 1434 1449 1450 1451 1414 1439 1440 1437]);
Info_Sleep_Ctrl.WiSleep(i) = 1;
Info_Sleep_Ctrl.WiEPM(i) = 0;


