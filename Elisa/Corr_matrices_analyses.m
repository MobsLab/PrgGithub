%% Saline

load('/home/mobs/Desktop/Elisa/Matlab_variables/model_results_saline_2.mat')

mice = {'M688', 'M777', 'M849', 'M1144', 'M1146', 'M1147', 'M1170', 'M1171', 'M9184', 'M9205', 'M1391', 'M1392', 'M1394', 'M1224', 'M1225', 'M1226', 'M739', 'M779', 'M893', 'M1189', 'M1393'};
var = {'beta_hab', 'thigmotaxis_hab', 'direct_persist_hab', 'immobility_hab', 'p1_hab', 'p2_hab', 'p3_hab', 'gamma_hab', 'k_hab', 'bp_hab', 'Wm_hab', 'Wnm_hab', 'beta_pre', 'thigmotaxis_pre', 'direct_persist_pre', 'immobility_pre', 'p1_pre', 'p2_pre', 'p3_pre', 'gamma_pre', 'k_pre', 'bp_pre', 'Wm_pre', 'Wnm_pre', 'beta_post', 'thigmotaxis_post', 'direct_persist_post', 'immobility_post', 'p1_post', 'p2_post', 'p3_post', 'gamma_post', 'k_post', 'bp_post', 'Wm_post', 'Wnm_post', 'B_all_stim_free', 'B_all_freez_cond_all', 'B_diff_occup_shock_zone', 'B_thigmo_cond_free', 'B_learning_rate', 'B_thigmo_hab', 'B_immobility_hab', 'B_thigmo_pre', 'B_immobility_pre', 'B_thigmo_post', 'B_immobility_post'};

Correlations_Matrices_Data_BM(saline', mice, var)

%% Conditioned exploration - NEGATIVE

load('/home/mobs/Desktop/Elisa/Matlab_variables/conditioning_explo_results_neg_1shockzone.mat')

mice = {'Mouse1117', 'Mouse1161', 'Mouse1162', 'Mouse1168', 'Mouse1182', 'Mouse1186', 'Mouse1239', 'Mouse797', 'Mouse798', 'Mouse828', 'Mouse861', 'Mouse882', 'Mouse906', 'Mouse911', 'Mouse912', 'Mouse977', 'Mouse994', 'Mouse1230-1', 'Mouse1230-2'};
var = {'W-values', 'alpha', 'discount-rate', 'replay-buffer-size', 'B-stim-cond', 'B-diff-occup-sz', 'B-latency-sz'};

Correlations_Matrices_Data_BM(conditioning_explo_results_neg_1shockzone', mice, var)
