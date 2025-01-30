
Dir_SensoryExposCD1cage1 = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO');
Dir_SensoryExposCD1cage2 = PathForExperiments_SD_MC('SensoryExposureCD1cage');
Dir_SensoryExposCD1cage2 = RestrictPathForExperiment(Dir_SensoryExposCD1cage2, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy
Dir_SensoryExposCD1cage4 = PathForExperiments_SD_MC('SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_CNOInjection');
Dir_SensoryExposCD1cage5 = PathForExperiments_SD_MC('SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_SalineInjection');
Dir_SensoryExposCD1cage6 = PathForExperiments_SD_MC('SensoryExposureCD1cage_noDREADD_BM_mice_CNOInjection');
Dir_SensoryExposCD1cage7 = PathForExperiments_SD_MC('SensoryExposureCD1cage_inhibDREADD_PFC_CNOInjection');
Dir_SensoryExposCD1cage7 = RestrictPathForExperiment(Dir_SensoryExposCD1cage7,'nMice',[1196 1197 1237 1238]);%1238
Dir_SensoryExposCD1cage_a = MergePathForExperiment(Dir_SensoryExposCD1cage1, Dir_SensoryExposCD1cage2);
Dir_SensoryExposCD1cage_b = MergePathForExperiment(Dir_SensoryExposCD1cage4, Dir_SensoryExposCD1cage5);
Dir_SensoryExposCD1cage_c = MergePathForExperiment(Dir_SensoryExposCD1cage6, Dir_SensoryExposCD1cage7);
Dir_SensoryExposCD1cage_A = MergePathForExperiment(Dir_SensoryExposCD1cage_a, Dir_SensoryExposCD1cage_b);
Dir_SensoryExposCD1cage = MergePathForExperiment(Dir_SensoryExposCD1cage_A, Dir_SensoryExposCD1cage_c);



%%SENSORY EXPO C57
Dir_SensoryExposC57cage1 = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO');
Dir_SensoryExposC57cage2 = PathForExperiments_SD_MC('SensoryExposureC57cage');
Dir_SensoryExposC57cage2 = RestrictPathForExperiment(Dir_SensoryExposC57cage2, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy
Dir_SensoryExposC57cage4 = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_CNOInjection');
Dir_SensoryExposC57cage5 = PathForExperiments_SD_MC('SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_SalineInjection');
Dir_SensoryExposC57cage6 = PathForExperiments_SD_MC('SensoryExposureC57cage_noDREADD_BM_mice_CNOInjection');
Dir_SensoryExposC57cage7 = PathForExperiments_SD_MC('SensoryExposureC57cage_inhibDREADD_PFC_CNOInjection');
Dir_SensoryExposC57cage7 = RestrictPathForExperiment(Dir_SensoryExposC57cage7,'nMice',[1196 1197 1237 1238]);%1238
Dir_SensoryExposC57cage_a = MergePathForExperiment(Dir_SensoryExposC57cage1, Dir_SensoryExposC57cage2);
Dir_SensoryExposC57cage_b = MergePathForExperiment(Dir_SensoryExposC57cage4, Dir_SensoryExposC57cage5);
Dir_SensoryExposC57cage_c = MergePathForExperiment(Dir_SensoryExposC57cage6, Dir_SensoryExposC57cage7);
Dir_SensoryExposC57cage_A = MergePathForExperiment(Dir_SensoryExposC57cage_a, Dir_SensoryExposC57cage_b);
Dir_SensoryExposC57cage = MergePathForExperiment(Dir_SensoryExposC57cage_A, Dir_SensoryExposC57cage_c);



%%SLEEP POST SD
Dir_SleepPostSD1 = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_retroCre_PFC_VLPO_CNOInjection');
Dir_SleepPostSD2 = PathForExperiments_SD_MC('SleepPostSD');
Dir_SleepPostSD2 = RestrictPathForExperiment(Dir_SleepPostSD2, 'nMice', [1148 1149 1150 1217 1218 1219 1220]); %restrict to mice with Ephy
Dir_SleepPostSD4 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection');
Dir_SleepPostSD5 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
Dir_SleepPostSD6 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
Dir_SleepPostSD7 = PathForExperiments_SD_MC('SleepPostSD_inhibDREADD_PFC_CNOInjection');
Dir_SleepPostSD7 = RestrictPathForExperiment(Dir_SleepPostSD7,'nMice',[1196 1197 1237 1238]);%1238
Dir_SleepPostSD_a = MergePathForExperiment(Dir_SleepPostSD1, Dir_SleepPostSD2);
Dir_SleepPostSD_b = MergePathForExperiment(Dir_SleepPostSD4, Dir_SleepPostSD5);
Dir_SleepPostSD_c = MergePathForExperiment(Dir_SleepPostSD6, Dir_SleepPostSD7);
Dir_SleepPostSD_A = MergePathForExperiment(Dir_SleepPostSD_a, Dir_SleepPostSD_b);
Dir_SleepPostSD = MergePathForExperiment(Dir_SleepPostSD_A, Dir_SleepPostSD_c);
