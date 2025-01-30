 function Res=ComputeSleepStagesPercentagesWithoutWakeMC(Wake,SWSEpoch,REMEpoch,plo)

%
% -
% Calcul la quantité de chaque stade de sommeil dans differente périodes
% ----------------------------------------------------------------------
%
% Res=ComputeSleepStagesPercentageTotalandThird(Wake,SWSEpoch,REMEpoch,plo)
% Res matrice (3x8)
%
% Res(1,:) []
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

st_epoch_pre = 0.3*1E8; %st_epoch_pre = 0.35*1E8;
en_epoch_pre = 1.5*1E8; %en_epoch_pre = 1*1E8;
st_epoch_post = 1.65*1E8;
en_epoch_post = 2.6*1E8;

%% time periods

durtotal=max([max(End(Wake)),max(End(SWSEpoch))]);

epoch_preInj=intervalSet(0,en_epoch_preInj);%first half / pre injection

epoch_postInj=intervalSet(st_epoch_post,durtotal);%second half / post injection

epoch_3hPostInj=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);%restricted to 3 hours post injection

epoch_first_3h_of_recording=intervalSet(0,3*3600*1e4); %first 3 hours of the recording

% epoch_3hPost_to_the_end=intervalSet(End(epoch_3hPostInj),durtotal);%end of the first 3h hours up to the end

% %3 hours following first sleep episode
% [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(Wake,SWSEpoch,REMEpoch,5,20); tpsFirstSleep=tpsFirstSWS;
% epoch_3hSleepy=intervalSet(tpsFirstSleep*1e4,tpsFirstSleep*1e4+3*3600*1E4);
% 
% epoch_3hSleepyEnd=intervalSet(End(epoch_3hSleepy),durtotal);%end of 3 hours following first sleep up to the end


%% duration of stages according to specific time periods

TotalSleep = or(SWSEpoch,REMEpoch);

%%all recording
[durSWS,durTSWS]=DurationEpoch(SWSEpoch);
[durREM,durTREM]=DurationEpoch(REMEpoch);
[durTotSleep,durTTotSleep]=DurationEpoch(TotalSleep);

%%first half / pre injection
[durSWS_pre,durTSWS_pre]=DurationEpoch(and(SWSEpoch,epoch_preInj));
[durREM_pre,durTREM_pre]=DurationEpoch(and(REMEpoch,epoch_preInj));
[durTotSleep_pre,durTTotSleep_pre]=DurationEpoch(and(TotalSleep,epoch_preInj));

%%second half / post injection
[durSWS_allPost,durTSWS_allPost]=DurationEpoch(and(SWSEpoch,epoch_postInj));
[durREM_allPost,durTREM_allPost]=DurationEpoch(and(REMEpoch,epoch_postInj));
[durTotSleep_allPost,durTTotalSleep_allPost]=DurationEpoch(and(TotalSleep,epoch_postInj));

%%restricted to 3 hours post injection
[durSWS_3hPostInj,durTSWS_3hPostInj]=DurationEpoch(and(SWSEpoch,epoch_3hPostInj));
[durREM_3hPostInj,durTREM_3hPostInj]=DurationEpoch(and(REMEpoch,epoch_3hPostInj));
[durTotSleep_3hPostInj,durTTotSleep_3hPostInj]=DurationEpoch(and(TotalSleep,epoch_3hPostInj));

%%first 3 hours of the recording
[durSWS_first3h,durTSWS_first3h]=DurationEpoch(and(SWSEpoch,epoch_first_3h_of_recording));
[durREM_first3h,durTREM_first3h]=DurationEpoch(and(REMEpoch,epoch_first_3h_of_recording));
[durTotSleep_first3h,durTTotSleep_first3h]=DurationEpoch(and(TotalSleep,epoch_first_3h_of_recording));

% %end of the first 3h hours up to the end
% [durSWS_3hPost_to_the_end,durTSWS_3hPost_to_the_end]=DurationEpoch(and(SWSEpoch,epoch_3hPost_to_the_end));
% [durREM_3hPost_to_the_end,durTREM_3hPost_to_the_end]=DurationEpoch(and(REMEpoch,epoch_3hPost_to_the_end));
% [durTotSleep_3hPost_to_the_end,durTTotSleep_epoch_3hPost_to_the_end]=DurationEpoch(and(TotalSleep,epoch_3hPost_to_the_end));


% %%3 hours following first sleep episode
% [durWake_3hSleepy,durTWake_3hSleepy]=DurationEpoch(and(Wake,epoch_3hSleepy)); 
% [durSWS_3hSleepy,durTSWS_3hSleepy]=DurationEpoch(and(SWSEpoch,epoch_3hSleepy));
% [durREM_3hSleepy,durTREM_3hSleepy]=DurationEpoch(and(REMEpoch,epoch_3hSleepy));
% [durTotSleep_3hSleepy,durTTotSleep_3hSleepy]=DurationEpoch(and(TotalSleep,epoch_3hSleepy));
% 
% %%end of 3 hours following first sleep up to the end
% [durWake_3hSleepyEnd,durTWake_3hSleepyEnd]=DurationEpoch(and(Wake,epoch_3hSleepyEnd)); 
% [durSWS_3hSleepyEnd,durTSWS_3hSleepyEnd]=DurationEpoch(and(SWSEpoch,epoch_3hSleepyEnd));
% [durREM_3hSleepyEnd,durTREM_3hSleepyEnd]=DurationEpoch(and(REMEpoch,epoch_3hSleepyEnd));
% [durTotSleep_3hSleepyEnd,durTTotSleep_3hSleepyEnd]=DurationEpoch(and(TotalSleep,epoch_3hSleepyEnd));

%% RESULTAT
%SWS
Res(2,1)=durTSWS/durTTotSleep*100;
Res(2,2)=durTSWS_pre/durTTotSleep_pre*100;
Res(2,3)=durTSWS_allPost/durTTotalSleep_allPost*100;
Res(2,4)=durTSWS_3hPostInj/durTTotSleep_3hPostInj*100;
Res(2,5)=durTSWS_first3h/durTTotSleep_first3h*100;
% Res(2,6)=durTSWS_3hPost_to_the_end/durTTotSleep_epoch_3hPost_to_the_end*100;
% Res(2,7)=durTSWS_3hSleepy/durTTotSleep_3hSleepy*100;
% Res(2,8)=durTSWS_3hSleepyEnd/durTTotSleep_3hSleepyEnd*100;

%REM
Res(3,1)=durTREM/durTTotSleep*100;
Res(3,2)=durTREM_pre/durTTotSleep_pre*100;
Res(3,3)=durTREM_allPost/durTTotalSleep_allPost*100;
Res(3,4)=durTREM_3hPostInj/durTTotSleep_3hPostInj*100;
Res(3,5)=durTREM_first3h/durTTotSleep_first3h*100;
% Res(3,6)=durTREM_3hPost_to_the_end/durTTotSleep_epoch_3hPost_to_the_end*100;
% Res(3,7)=durTREM_3hSleepy/durTTotSleep_3hSleepy*100;
% Res(3,8)=durTREM_3hSleepyEnd/durTTotSleep_3hSleepyEnd*100;

