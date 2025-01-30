 function Res=Compute_Seq_Single_REM_Percentages_MC(Wake,SWSEpoch,REMEpoch,param,plo)

% Calcul la quantité de chaque stade de sommeil dans differente périodes
% ----------------------------------------------------------------------
%
% Res=ComputeSleepStagesPercentageTotalandThird(Wake,SWSEpoch,REMEpoch,plo)
% Res matrice (3x8)

% Res(1,:) all recording
% Res(2,:) pre injection
% Res(3,:) post injection

% Res(x,1) total rem
% Res(x,2) sequential rem
% Res(x,3) single rem


try
  plo;
catch
    plo=0;
end

%% parameters to define time periods
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

epoch_3hPost_to_the_end=intervalSet(End(epoch_3hPostInj),durtotal);%end of the first 3h hours up to the end



%% duration of stages according to specific time periods

[Seq_REMEpoch,Single_REMEpoch] = Find_single_sequential_REM_MC(Wake,SWSEpoch,REMEpoch,param);

TotalSleep = or(SWSEpoch,REMEpoch);

%%all recording
[dur_total_REM,durT_total_REM]=DurationEpoch(REMEpoch);
[dur_seq_REM,durT_seq_REM]=DurationEpoch(Seq_REMEpoch);
[dur_sing_REM,durT_sing_REM]=DurationEpoch(Single_REMEpoch);
[durTotSleep,durTTotSleep]=DurationEpoch(TotalSleep);

%%first half / pre injection
[dur_total_REM_pre,durT_total_REM_pre]=DurationEpoch(and(REMEpoch,epoch_preInj));
[dur_seq_REM_pre,durT_seq_REM_pre]=DurationEpoch(and(Seq_REMEpoch,epoch_preInj));
[dur_sing_REM_pre,durT_sing_REM_pre]=DurationEpoch(and(Single_REMEpoch,epoch_preInj));
[durTotSleep_pre,durTTotSleep_pre]=DurationEpoch(and(TotalSleep,epoch_preInj));

%%second half / post injection
[dur_total_REM_allPost,durT_total_REM_allPost]=DurationEpoch(and(REMEpoch,epoch_postInj));
[dur_seq_REM_allPost,durT_seq_REM_allPost]=DurationEpoch(and(Seq_REMEpoch,epoch_postInj));
[dur_sing_REM_allPost,durT_sing_REM_allPost]=DurationEpoch(and(Single_REMEpoch,epoch_postInj));
[durTotSleep_allPost,durTTotalSleep_allPost]=DurationEpoch(and(TotalSleep,epoch_postInj));

% %%restricted to 3 hours post injection
% [durSWS_3hPostInj,durTSWS_3hPostInj]=DurationEpoch(and(SWSEpoch,epoch_3hPostInj));
% [durREM_3hPostInj,durTREM_3hPostInj]=DurationEpoch(and(REMEpoch,epoch_3hPostInj));
% [durTotSleep_3hPostInj,durTTotSleep_3hPostInj]=DurationEpoch(and(TotalSleep,epoch_3hPostInj));
% 
% %%first 3 hours of the recording
% [durSWS_first3h,durTSWS_first3h]=DurationEpoch(and(SWSEpoch,epoch_first_3h_of_recording));
% [durREM_first3h,durTREM_first3h]=DurationEpoch(and(REMEpoch,epoch_first_3h_of_recording));
% [durTotSleep_first3h,durTTotSleep_first3h]=DurationEpoch(and(TotalSleep,epoch_first_3h_of_recording));
% 
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


%REM
%%all recording
Res(1,1)=durT_total_REM/durTTotSleep*100;
Res(1,2)=durT_seq_REM/durTTotSleep*100;
Res(1,3)=durT_sing_REM/durTTotSleep*100;

%%pre
Res(2,1)=durT_total_REM_pre/durTTotSleep_pre*100;
Res(2,2)=durT_seq_REM_pre/durTTotSleep_pre*100;
Res(2,3)=durT_sing_REM_pre/durTTotSleep_pre*100;

%%post
Res(3,1)=durT_total_REM_allPost/durTTotalSleep_allPost*100;
Res(3,2)=durT_seq_REM_allPost/durTTotalSleep_allPost*100;
Res(3,3)=durT_sing_REM_allPost/durTTotalSleep_allPost*100;

% Res(1,4)=durTREM_3hPostInj/durTTotSleep_3hPostInj*100;
% Res(1,5)=durTREM_first3h/durTTotSleep_first3h*100;
% Res(1,6)=durTREM_3hPost_to_the_end/durTTotSleep_epoch_3hPost_to_the_end*100;
% Res(1,7)=durTREM_3hSleepy/durTTotSleep_3hSleepy*100;
% Res(1,8)=durTREM_3hSleepyEnd/durTTotSleep_3hSleepyEnd*100;


