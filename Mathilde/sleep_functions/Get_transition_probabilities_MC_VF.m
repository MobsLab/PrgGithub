function [P_S_S, P_S_R, P_S_W, P_R_R, P_R_S, P_R_W, P_W_W, P_W_S, P_W_R] = Get_transition_probabilities_MC_VF(SWSEpoch,REMEpoch,Wake, timePeriod)


[aft_cell_SR,bef_cell_SR]=transEpoch(and(SWSEpoch,timePeriod),and(REMEpoch,timePeriod));
[aft_cell_SW,bef_cell_SW]=transEpoch(and(SWSEpoch,timePeriod),and(Wake,timePeriod));
[aft_cell_RW,bef_cell_RW]=transEpoch(and(REMEpoch,timePeriod),and(Wake,timePeriod));
%     [aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
% %Start(aft_cell{1,2}) ---> beginning of all SWS that is followed by Wake
% % Start(bef_cell{1,2}) ---> beginning of all SWS that is preceded by Wake
% %Start(bef_cell{2,1})---> beginning of all Wake  that is preceded by SWS
% %Start(aft_cell{2,1})---> beginning of all Wake  that is followed by SWS



TotSWSsteps = floor(sum(Stop(and(SWSEpoch,timePeriod),'s') - Start(and(SWSEpoch,timePeriod),'s')));
SWSToRem = length(Start(aft_cell_SR{1,2}));
SWSToWake = length(Start(aft_cell_SW{1,2}));

P_S_S = (TotSWSsteps-SWSToRem-SWSToWake) / TotSWSsteps;
P_S_R = (SWSToRem) / TotSWSsteps;
P_S_W = (SWSToWake) / TotSWSsteps;

TotREMsteps = floor(sum(Stop(and(REMEpoch,timePeriod),'s') - Start(and(REMEpoch,timePeriod),'s')));
REMToSWS = length(Start(aft_cell_SR{2,1}));
REMToWake = length(Start(aft_cell_RW{1,2}));

P_R_R = (TotREMsteps-REMToSWS-REMToWake) / TotREMsteps;
P_R_S = (REMToSWS) / TotREMsteps;
P_R_W = (REMToWake) / TotREMsteps;

TotWakeSteps = floor(sum(Stop(and(Wake,timePeriod),'s') - Start(and(Wake,timePeriod),'s')));
WakeToSWS = length(Start(aft_cell_SW{2,1}));
WakeToRem = length(Start(aft_cell_RW{2,1}));

P_W_W= (TotWakeSteps-WakeToSWS-WakeToRem) / TotWakeSteps;
P_W_S = (WakeToSWS) / TotWakeSteps;
P_W_R = (WakeToRem) / TotWakeSteps;


