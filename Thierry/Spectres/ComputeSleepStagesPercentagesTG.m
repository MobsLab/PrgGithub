 function Res=ComputeSleepStagesPercentagesMC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,plo)

%
% -
% Calcul la quantité de chaque stade de sommeil dans differente périodes
% ----------------------------------------------------------------------
%
% Res=ComputeSleepStagesPercentageTotalandThird(WakeWiNoiseWiNoise,SWSEpochWiNoiseWiNoise,REMEpochWiNoise,plo)
% Res matrice (3x7)
%
% Res(1,:) donne le WakeWiNoise
% Res(2,:) donne le SWS
% Res(3,:) donne le REM

% Res(x,1) all recording
% Res(x,2) first half / pre injection
% Res(x,3) second half / post injection
% Res(x,4) restricted to 3 hours post injection
% Res(x,5) first 3 hours of the recording
% Res(x,6) end of the first 3h hours up to the end

% Res(x,7) 3 hours following first sleep episode
% Res(x,8) end of 3 hours following first sleep up to the end

try
  plo;
catch
    plo=0;
end

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

% st_epoch_pre = 0.35*1E8; %st_epoch_pre = 0.35*1E8;
% en_epoch_pre = 1.5*1E8; %en_epoch_pre = 1*1E8;
% st_epoch_post = 1.8*1E8;
% en_epoch_post = 2.6*1E8;

st_epoch_pre = 0.3*1E8; %st_epoch_pre = 0.35*1E8;
en_epoch_pre = 1.5*1E8; %en_epoch_pre = 1*1E8;
st_epoch_post = 1.65*1E8;
en_epoch_post = 2.6*1E8;

%% time periods

durtotal=max([max(End(WakeWiNoise)),max(End(SWSEpochWiNoise))]);

% epoch_preInj=intervalSet(0,en_epoch_preInj);%first half / pre injection
epoch_preInj=intervalSet(0,en_epoch_preInj);%first half / pre injection

epoch_postInj=intervalSet(st_epoch_post,durtotal);%second half / post injection

% epoch_3hPostInj=intervalSet(1.5*1E8,1.5*1E8+3*3600*1e4);%restricted to 3 hours post injection
epoch_3hPostInj=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);%restricted to 3 hours post injection


epoch_first_3h_of_recording=intervalSet(0,3*3600*1e4); %first 3 hours of the recording%%%%%%%%

% epoch_3hPost_to_the_end=intervalSet(End(epoch_3hPostInj),durtotal);%end of the first 3h hours up to the end

% %3 hours following first sleep episode
% [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(WakeWiNoiseWiNoise,SWSEpochWiNoiseWiNoise,REMEpochWiNoise,5,20); tpsFirstSleep=tpsFirstSWS;
% epoch_3hSleepy=intervalSet(tpsFirstSleep*1e4,tpsFirstSleep*1e4+3*3600*1E4);
% 
% epoch_3hSleepyEnd=intervalSet(End(epoch_3hSleepy),durtotal);%end of 3 hours following first sleep up to the end

%% compute durations for each time periods

[durWake,durTWake]=DurationEpoch(WakeWiNoise); % all recording
[durSWS,durTSWS]=DurationEpoch(SWSEpochWiNoise);
[durREM,durTREM]=DurationEpoch(REMEpochWiNoise);

[durWake_pre,durTWake_pre]=DurationEpoch(and(WakeWiNoise,epoch_preInj)); %first half / pre injection
[durSWS_pre,durTSWS_pre]=DurationEpoch(and(SWSEpochWiNoise,epoch_preInj));
[durREM_pre,durTREM_pre]=DurationEpoch(and(REMEpochWiNoise,epoch_preInj));

[durWake_allPost,durTWake_allPost]=DurationEpoch(and(WakeWiNoise,epoch_postInj));%second half / post injection
[durSWS_allPost,durTSWS_allPost]=DurationEpoch(and(SWSEpochWiNoise,epoch_postInj));
[durREM_allPost,durTREM_allPost]=DurationEpoch(and(REMEpochWiNoise,epoch_postInj));

[durWake_3hPostInj,durTWake_3hPostInj]=DurationEpoch(and(WakeWiNoise,epoch_3hPostInj));%restricted to 3 hours post injection
[durSWS_3hPostInj,durTSWS_3hPostInj]=DurationEpoch(and(SWSEpochWiNoise,epoch_3hPostInj));
[durREM_3hPostInj,durTREM_3hPostInj]=DurationEpoch(and(REMEpochWiNoise,epoch_3hPostInj));

[durWake_first_3h,durTWake_first_3h]=DurationEpoch(and(WakeWiNoise,epoch_first_3h_of_recording)); %first 3 hours of the recording
[durSWS_first_3h,durTSWS_first_3h]=DurationEpoch(and(SWSEpochWiNoise,epoch_first_3h_of_recording));
[durREM_first_3h,durTREM_first_3h]=DurationEpoch(and(REMEpochWiNoise,epoch_first_3h_of_recording));

% [durWakeWiNoise_3hPost_to_the_end,durTWakeWiNoise_3hPost_to_the_end]=DurationEpoch(and(WakeWiNoise,epoch_3hPost_to_the_end)); %end of the first 3h hours up to the end
% [durSWS_3hPost_to_the_end,durTSWS_3hPost_to_the_end]=DurationEpoch(and(SWSEpochWiNoise,epoch_3hPost_to_the_end));
% [durREM_3hPost_to_the_end,durTREM_3hPost_to_the_end]=DurationEpoch(and(REMEpochWiNoise,epoch_3hPost_to_the_end));

% [durWakeWiNoise_3hSleepy,durTWakeWiNoise_3hSleepy]=DurationEpoch(and(WakeWiNoise,epoch_3hSleepy)); %3 hours following first sleep episode
% [durSWS_3hSleepy,durTSWS_3hSleepy]=DurationEpoch(and(SWSEpochWiNoise,epoch_3hSleepy));
% [durREM_3hSleepy,durTREM_3hSleepy]=DurationEpoch(and(REMEpochWiNoise,epoch_3hSleepy));

% [durWakeWiNoise_3hSleepyEnd,durTWakeWiNoise_3hSleepyEnd]=DurationEpoch(and(WakeWiNoise,epoch_3hSleepyEnd)); %end of 3 hours following first sleep up to the end
% [durSWS_3hSleepyEnd,durTSWS_3hSleepyEnd]=DurationEpoch(and(SWSEpochWiNoise,epoch_3hSleepyEnd));
% [durREM_3hSleepyEnd,durTREM_3hSleepyEnd]=DurationEpoch(and(REMEpochWiNoise,epoch_3hSleepyEnd));

%% RESULTAT
%WakeWiNoise
Res(1,1)=durTWake/(durTWake+durTSWS+durTREM)*100;
Res(1,2)=durTWake_pre/(durTWake_pre+durTSWS_pre+durTREM_pre)*100;
Res(1,3)=durTWake_allPost/(durTWake_allPost+durTSWS_allPost+durTREM_allPost)*100;
Res(1,4)=durTWake_3hPostInj/(durTWake_3hPostInj+durTSWS_3hPostInj+durTREM_3hPostInj)*100;
Res(1,5)=durTWake_first_3h/(durTWake_first_3h+durTSWS_first_3h+durTREM_first_3h)*100;
% Res(1,6)=durTWakeWiNoise_3hPost_to_the_end/(durTWakeWiNoise_3hPost_to_the_end+durTSWS_3hPost_to_the_end+durTREM_3hPost_to_the_end)*100;
% Res(1,7)=durTWakeWiNoise_3hSleepy/(durTWakeWiNoise_3hSleepy+durTSWS_3hSleepy+durTREM_3hSleepy)*100;
% Res(1,8)=durTWakeWiNoise_3hSleepyEnd/(durTWakeWiNoise_3hSleepyEnd+durTSWS_3hSleepyEnd+durTREM_3hSleepyEnd)*100;

%SWS
Res(2,1)=durTSWS/(durTWake+durTSWS+durTREM)*100;
Res(2,2)=durTSWS_pre/(durTWake_pre+durTSWS_pre+durTREM_pre)*100;
Res(2,3)=durTSWS_allPost/(durTWake_allPost+durTSWS_allPost+durTREM_allPost)*100;
Res(2,4)=durTSWS_3hPostInj/(durTWake_3hPostInj+durTSWS_3hPostInj+durTREM_3hPostInj)*100;
Res(2,5)=durTSWS_first_3h/(durTWake_first_3h+durTSWS_first_3h+durTREM_first_3h)*100;
% Res(2,6)=durTSWS_3hPost_to_the_end/(durTWakeWiNoise_3hPost_to_the_end+durTSWS_3hPost_to_the_end+durTREM_3hPost_to_the_end)*100;
% Res(2,7)=durTSWS_3hSleepy/(durTWakeWiNoise_3hSleepy+durTSWS_3hSleepy+durTREM_3hSleepy)*100;
% Res(2,8)=durTSWS_3hSleepyEnd/(durTWakeWiNoise_3hSleepyEnd+durTSWS_3hSleepyEnd+durTREM_3hSleepyEnd)*100;

%REM
Res(3,1)=durTREM/(durTWake+durTSWS+durTREM)*100;
Res(3,2)=durTREM_pre/(durTWake_pre+durTSWS_pre+durTREM_pre)*100;
Res(3,3)=durTREM_allPost/(durTWake_allPost+durTSWS_allPost+durTREM_allPost)*100;
Res(3,4)=durTREM_3hPostInj/(durTWake_3hPostInj+durTSWS_3hPostInj+durTREM_3hPostInj)*100;
Res(3,5)=durTREM_first_3h/(durTWake_first_3h+durTSWS_first_3h+durTREM_first_3h)*100;
% Res(3,6)=durTREM_3hPost_to_the_end/(durTWakeWiNoise_3hPost_to_the_end+durTSWS_3hPost_to_the_end+durTREM_3hPost_to_the_end)*100;
% Res(3,7)=durTREM_3hSleepy/(durTWakeWiNoise_3hSleepy+durTSWS_3hSleepy+durTREM_3hSleepy)*100;
% Res(3,8)=durTREM_3hSleepyEnd/(durTWakeWiNoise_3hSleepyEnd+durTSWS_3hSleepyEnd+durTREM_3hSleepyEnd)*100;
