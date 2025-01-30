function [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=Get_proba_timebins_Overtime_MC_version2_VF(Wake,SWSEpoch,REMEpoch,tempbin,time_st,time_en)

tempbin=tempbin*1E4;
SleepStage=PlotSleepStage(Wake,SWSEpoch,REMEpoch);close

tps=Range(SleepStage);
rg = [(time_st:tempbin:time_en)];

epoch1 = intervalSet(rg(1), rg(2));
epoch2 = intervalSet(rg(2), rg(3));
epoch3 = intervalSet(rg(3), rg(4));
epoch4 = intervalSet(rg(4), rg(5));
epoch5 = intervalSet(rg(5), rg(6));
epoch6 = intervalSet(rg(6), rg(7));
epoch7 = intervalSet(rg(7), rg(8));
epoch8 = intervalSet(rg(8), rg(9));
epoch9 = intervalSet(rg(9), tps(end));


[P_S_S1, P_S_R1, P_S_W1, P_R_R1, P_R_S1, P_R_W1, P_W_W1, P_W_S1, P_W_R1] = Get_transition_probabilities_MC_VF(SWSEpoch,REMEpoch,Wake,epoch1);
[P_S_S2, P_S_R2, P_S_W2, P_R_R2, P_R_S2, P_R_W2, P_W_W2, P_W_S2, P_W_R2] = Get_transition_probabilities_MC_VF(SWSEpoch,REMEpoch,Wake,epoch2);
[P_S_S3, P_S_R3, P_S_W3, P_R_R3, P_R_S3, P_R_W3, P_W_W3, P_W_S3, P_W_R3] = Get_transition_probabilities_MC_VF(SWSEpoch,REMEpoch,Wake,epoch3);
[P_S_S4, P_S_R4, P_S_W4, P_R_R4, P_R_S4, P_R_W4, P_W_W4, P_W_S4, P_W_R4] = Get_transition_probabilities_MC_VF(SWSEpoch,REMEpoch,Wake,epoch4);
[P_S_S5, P_S_R5, P_S_W5, P_R_R5, P_R_S5, P_R_W5, P_W_W5, P_W_S5, P_W_R5] = Get_transition_probabilities_MC_VF(SWSEpoch,REMEpoch,Wake,epoch5);
[P_S_S6, P_S_R6, P_S_W6, P_R_R6, P_R_S6, P_R_W6, P_W_W6, P_W_S6, P_W_R6] = Get_transition_probabilities_MC_VF(SWSEpoch,REMEpoch,Wake,epoch6);
[P_S_S7, P_S_R7, P_S_W7, P_R_R7, P_R_S7, P_R_W7, P_W_W7, P_W_S7, P_W_R7] = Get_transition_probabilities_MC_VF(SWSEpoch,REMEpoch,Wake,epoch7);
[P_S_S8, P_S_R8, P_S_W8, P_R_R8, P_R_S8, P_R_W8, P_W_W8, P_W_S8, P_W_R8] = Get_transition_probabilities_MC_VF(SWSEpoch,REMEpoch,Wake,epoch8);
[P_S_S9, P_S_R9, P_S_W9, P_R_R9, P_R_S9, P_R_W9, P_W_W9, P_W_S9, P_W_R9] = Get_transition_probabilities_MC_VF(SWSEpoch,REMEpoch,Wake,epoch9);



trans_REM_to_REM = [P_R_R1 P_R_R2 P_R_R3 P_R_R4 P_R_R5 P_R_R6 P_R_R7 P_R_R8 P_R_R9];
trans_REM_to_SWS = [P_R_S1 P_R_S2 P_R_S3 P_R_S4 P_R_S5 P_R_S6 P_R_S7 P_R_S8 P_R_S9];
trans_REM_to_WAKE = [P_R_W1 P_R_W2 P_R_W3 P_R_W4 P_R_W5 P_R_W6 P_R_W7 P_R_W8 P_R_W9];
trans_SWS_to_REM = [P_S_R1 P_S_R2 P_S_R3 P_S_R4 P_S_R5 P_S_R6 P_S_R7 P_S_R8 P_S_R9];
trans_SWS_to_SWS = [P_S_S1 P_S_S2 P_S_S3 P_S_S4 P_S_S5 P_S_S6 P_S_S7 P_S_S8 P_S_S9];
trans_SWS_to_WAKE = [P_S_W1 P_S_W2 P_S_W3 P_S_W4 P_S_W5 P_S_W6 P_S_W7 P_S_W8 P_S_W9];
trans_WAKE_to_REM = [P_W_R1 P_W_R2 P_W_R3 P_W_R4 P_W_R5 P_W_R6 P_W_R7 P_W_R8 P_W_R9];
trans_WAKE_to_SWS = [P_W_S1 P_W_S2 P_W_S3 P_W_S4 P_W_S5 P_W_S6 P_W_S7 P_W_S8 P_W_S9];
trans_WAKE_to_WAKE = [P_W_W1 P_W_W2 P_W_W3 P_W_W4 P_W_W5 P_W_W6 P_W_W7 P_W_W8 P_W_W9];


end 

