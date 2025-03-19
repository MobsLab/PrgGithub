function [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=Get_proba_timebins_OverTimeWindows_MC_version2_vf(Wake,SWSEpoch,REMEpoch,tempbin,time_st,time_en)

tempbin=tempbin*1E4;
SleepStage=PlotSleepStage(Wake,SWSEpoch,REMEpoch);close

tps=Range(SleepStage);
rg = [(time_st:tempbin:time_en)];

epoch1 = intervalSet(time_st, time_en);



[P_S_S1, P_S_R1, P_S_W1, P_R_R1, P_R_S1, P_R_W1, P_W_W1, P_W_S1, P_W_R1] = Get_transition_probabilities_MC_VF(SWSEpoch,REMEpoch,Wake,epoch1);




trans_REM_to_REM = [P_R_R1];
trans_REM_to_SWS = [P_R_S1];
trans_REM_to_WAKE = [P_R_W1];
trans_SWS_to_REM = [P_S_R1];
trans_SWS_to_SWS = [P_S_S1];
trans_SWS_to_WAKE = [P_S_W1];
trans_WAKE_to_REM = [P_W_R1 ];
trans_WAKE_to_SWS = [P_W_S1];
trans_WAKE_to_WAKE = [P_W_W1];


end 

