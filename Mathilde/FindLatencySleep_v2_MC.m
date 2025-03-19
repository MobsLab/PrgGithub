function [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_v2_MC(Wake,SWSEpoch,REMEpoch,mindurREM,mindurSWS);

%%bouts duration
[durSWS,durTSWS] = DurationEpoch(SWSEpoch);
[durREM,durTREM] = DurationEpoch(REMEpoch);

%%get starts of each bouts
st_sws = Start(SWSEpoch);
st_rem = Start(REMEpoch);
st_wake = Start(Wake);

%%get index of episodes longer than the minumum duration that has been set
idx_sws = find(durSWS>mindurSWS*1e4);
idx_rem = find(durREM>mindurREM*1e4);

%%get latency
%%SWS latency : beginning of the recording up to the first sleep
tpsFirstSWS = st_sws(idx_sws(1))-st_wake(1);
%%REM latency : first sleep up to the first REM
tpsFirstREM = st_rem(idx_rem(1))-st_sws(idx_sws(1)); %%conversion en sec then hour


