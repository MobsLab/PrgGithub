clear all

% 1) SVM score shock tot
% 2) SVM score safe tot
% 3) SVM score shock end
% 4) SVM score safe end
% 5) % SVM safe in safe

% 6) Breathing shock tot
% 7) Breathing safe tot
% 8) Breathing shock end
% 9) Breathing safe end
% 10) % Breathing safe in safe

% 11) Shocks number
% 12) Occupancy shock
% 13) SZ entries

load('/media/nas7/ProjetEmbReact/DataEmbReact/SVMScores_Saline_all.mat')

MAT(1,:) = SVM_score_FzShock_Cond;
MAT(2,:) = SVM_score_FzSafe_Cond;
MAT(3,:) = nanmean(SVM_score_FzShock_Cond_interp(:,91:100)');
MAT(4,:) = nanmean(SVM_score_FzSafe_Cond_interp(:,91:100)');
MAT(5,:) = sum(SVM_score_FzSafe_Cond_interp'<-.2)./100;
MAT(5,isnan(MAT(4,:))) = NaN;

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/OB_Spec.mat', 'Freq_Max1', 'Freq_Max2')
load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/TemporalEvolution_Data.mat', 'DATA_shock', 'DATA_safe')
load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/TemporalEvolution_Data.mat', 'Prop_safeSafe')

MAT(6,:) = Freq_Max1;
MAT(7,:) = Freq_Max2;
MAT(8,:) = nanmean(DATA_shock.respi_freq_bm(:,91:100)');
MAT(9,:) = nanmean(DATA_safe.respi_freq_bm(:,91:100)');
MAT(10,:) = Prop_safeSafe;

load('/media/nas7/ProjetEmbReact/DataEmbReact/Behaviour_all_saline.mat')

MAT(11,:) = StimDensity.Cond{1};
MAT(12,:) = ShockZone_Occupancy.Cond{1};
MAT(13,:) = ShockZoneEntries_Density.Cond{1};


%% SB modifications
% Sleep
Prop = GetSleepInfo_ForGLMUMaze;
MAT(14,:) = Prop.Sleep{2};
MAT(15,:) = Prop.REM{2};

% TestPost
 [Thigmo_score,Latency_Shock,Latency_Safe,SafeZone_Occupancy,ShockZone_Occupancy,ShockZoneEntries_Density,SafeZoneEntries_Density] = GetTestPostInfo_ForGLMUmaze
i=15;
i=i+1;MAT(i,:) = Thigmo_score.TestPost{1};
i=i+1;MAT(i,:) = Latency_Shock.TestPost{1};
i=i+1;MAT(i,:) = Latency_Safe.TestPost{1};
i=i+1;MAT(i,:) = SafeZone_Occupancy.TestPost{1};
i=i+1;MAT(i,:) = ShockZone_Occupancy.TestPost{1};
i=i+1;MAT(i,:) = ShockZoneEntries_Density.TestPost{1};
i=i+1;MAT(i,:) = SafeZoneEntries_Density.TestPost{1};


Labels = {'SVM score shock tot','SVM score safe tot','SVM score shock end','SVM score safe end','Prop Safe Safe','Breathing shock tot',...
    'Breathing safe tot','Breathing shock end','Breathing safe end','Breathing safe in safe','Shocks number',...
'Occupancy shock','SZ entries',...
'PropSleep','PropREM',...
'Post Thigmo','PostLatSk','PostLatSf','PostSfOcc','PostSkOcc','PostSkEnter','PostSfEnter'};

save('/media/nas7/ProjetEmbReact/DataEmbReact/Data_for_SB/DATA_GLM_Physio_Behav.mat','Labels','MAT')














% 1) SVM score shock tot
% 2) SVM score safe tot
% 3) SVM score shock end
% 4) SVM score safe end
% 5) % SVM safe in safe

% 6) Breathing shock tot
% 7) Breathing safe tot
% 8) Breathing shock end
% 9) Breathing safe end
% 10) % Breathing safe in safe

% 11) Shocks number
% 12) Occupancy shock
% 13) SZ entries