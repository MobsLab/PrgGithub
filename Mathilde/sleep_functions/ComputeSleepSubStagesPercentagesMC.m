function Res=ComputeSleepSubStagesPercentagesMC(Epoch,plo)
%
% Epoch{1} N1
% Epoch{2} N2
% Epoch{3} N3
% Epoch{4} WAKE
% Epoch{5} REM
%
%
% Calcul la quantité de chaque stade de sommeil dans differentes périodes
% ----------------------------------------------------------------------
%
% Res matrice (5x8)
%
% Res(1,:) donne le N1
% Res(2,:) donne le N2
% Res(3,:) donne le N3
% Res(4,:) donne le WAKE
% Res(5,:) donne le REM

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

%% rename epoch
N1 = Epoch{1};
N2 = Epoch{2};
N3 = Epoch{3};
WAKE = Epoch{5};
REM = Epoch{4};
SWS = Epoch{7};
TOTsleep = Epoch{10};

%% injection parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% time periods
durtotal=max([max(End(WAKE)),max(End(SWS))]);
%first half / pre injection
epoch_preInj=intervalSet(0,en_epoch_preInj);
%second half / post injection
epoch_postInj=intervalSet(st_epoch_postInj,durtotal);
%restricted to 3 hours post injection
epoch_3hPostInj=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
%first 3 hours of the recording
epoch_first3h=intervalSet(0,3*3600*1e4);
%end of the first 3h hours up to the end
% epoch_first3hEnd=intervalSet(End(epoch_3hPostInj),durtotal);
% %3 hours following first sleep episode
% [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(Wake,SWSEpoch,REMEpoch,5,20); tpsFirstSleep=tpsFirstSWS;
% epoch_3hSleepy=intervalSet(tpsFirstSleep*1e4,tpsFirstSleep*1e4+3*3600*1E4);
% %end of 3 hours following first sleep up to the end
% epoch_3hSleepyEnd=intervalSet(End(epoch_3hSleepy),durtotal);

%% get duration of each epoch
%all recording
[durN1,durTN1]=DurationEpoch(N1);
[durN2,durTN2]=DurationEpoch(N2);
[durN3,durTN3]=DurationEpoch(N3);
[durWAKE,durTWAKE]=DurationEpoch(WAKE);
[durREM,durTREM]=DurationEpoch(REM);
[durTOTsleep,durTTOTsleep]=DurationEpoch(TOTsleep);

%first half / pre injection
[durN1_pre,durTN1_pre]=DurationEpoch(and(N1,epoch_preInj));
[durN2_pre,durTN2_pre]=DurationEpoch(and(N2,epoch_preInj));
[durN3_pre,durTN3_pre]=DurationEpoch(and(N3,epoch_preInj));
[durWAKE_pre,durTWAKE_pre]=DurationEpoch(and(WAKE,epoch_preInj));
[durREM_pre,durTREM_pre]=DurationEpoch(and(REM,epoch_preInj));
[durTOTsleep_pre,durTTOTsleep_pre]=DurationEpoch(and(TOTsleep,epoch_preInj));

%second half / post injection
[durN1_post,durTN1_post]=DurationEpoch(and(N1,epoch_postInj));
[durN2_post,durTN2_post]=DurationEpoch(and(N2,epoch_postInj));
[durN3_post,durTN3_post]=DurationEpoch(and(N3,epoch_postInj));
[durWAKE_post,durTWAKE_post]=DurationEpoch(and(WAKE,epoch_postInj));
[durREM_post,durTREM_post]=DurationEpoch(and(REM,epoch_postInj));
[durTOTsleep_post,durTTOTsleep_post]=DurationEpoch(and(TOTsleep,epoch_postInj));

%restricted to 3 hours post injection
[durN1_3hPostInj,durTN1_3hPostInj]=DurationEpoch(and(N1,epoch_3hPostInj));
[durN2_3hPostInj,durTN2_3hPostInj]=DurationEpoch(and(N2,epoch_3hPostInj));
[durN3_3hPostInj,durTN3_3hPostInj]=DurationEpoch(and(N3,epoch_3hPostInj));
[durWAKE_3hPostInj,durTWAKE_3hPostInj]=DurationEpoch(and(WAKE,epoch_3hPostInj));
[durREM_3hPostInj,durTREM_3hPostInj]=DurationEpoch(and(REM,epoch_3hPostInj));
[durTOTsleep_3hPostInj,durTTOTsleep_3hPostInj]=DurationEpoch(and(TOTsleep,epoch_3hPostInj));


%first 3 hours of the recording
[durN1_first3h,durTN1_first3h]=DurationEpoch(and(N1,epoch_first3h));
[durN2_first3h,durTN2_first3h]=DurationEpoch(and(N2,epoch_first3h));
[durN3_first3h,durTN3_first3h]=DurationEpoch(and(N3,epoch_first3h));
[durWAKE_first3h,durTWAKE_first3h]=DurationEpoch(and(WAKE,epoch_first3h));
[durREM_first3h,durTREM_first3h]=DurationEpoch(and(REM,epoch_first3h));
[durTOTsleep_first3h,durTTOTsleep_first3h]=DurationEpoch(and(TOTsleep,epoch_first3h));


% %end of the first 3h hours up to the end
% [durN1_first3hEnd,durTN1_first3hEnd]=DurationEpoch(and(N1,epoch_first3hEnd));
% [durN2_first3hEnd,durTN2_first3hEnd]=DurationEpoch(and(N2,epoch_first3hEnd));
% [durN3_first3hEnd,durTN3_first3hEnd]=DurationEpoch(and(N3,epoch_first3hEnd));
% [durWAKE_first3hEnd,durTWAKE_first3hEnd]=DurationEpoch(and(WAKE,epoch_first3hEnd));
% [durREM_first3hEnd,durTREM_first3hEnd]=DurationEpoch(and(REM,epoch_first3hEnd));
% [durTOTsleep_first3hEnd,durTTOTsleep_first3hEnd]=DurationEpoch(and(TOTsleep,epoch_first3hEnd));


% %3 hours following first sleep episode
% [durWake_3hSleepy,durTWake_3hSleepy]=DurationEpoch(and(Wake,epoch_3hSleepy)); 
% [durSWS_3hSleepy,durTSWS_3hSleepy]=DurationEpoch(and(SWSEpoch,epoch_3hSleepy));
% [durREM_3hSleepy,durTREM_3hSleepy]=DurationEpoch(and(REMEpoch,epoch_3hSleepy));
% %end of 3 hours following first sleep up to the end
% [durWake_3hSleepyEnd,durTWake_3hSleepyEnd]=DurationEpoch(and(Wake,epoch_3hSleepyEnd)); 
% [durSWS_3hSleepyEnd,durTSWS_3hSleepyEnd]=DurationEpoch(and(SWSEpoch,epoch_3hSleepyEnd));
% [durREM_3hSleepyEnd,durTREM_3hSleepyEnd]=DurationEpoch(and(REMEpoch,epoch_3hSleepyEnd));

%% RESULTAT

%N1
Res(1,1)=durTN1/(durTWAKE+durTTOTsleep)*100;
Res(1,2)=durTN1_pre/(durTWAKE_pre+durTTOTsleep_pre)*100;
Res(1,3)=durTN1_post/(durTWAKE_post+durTTOTsleep_post)*100;
Res(1,4)=durTN1_3hPostInj/(durTWAKE_3hPostInj+durTTOTsleep_3hPostInj)*100;
Res(1,5)=durTN1_first3h/(durTWAKE_first3h+durTTOTsleep_first3h)*100;
% Res(1,6)=durTN1_first3hEnd/(durTWAKE_first3hEnd+durTTOTsleep_first3hEnd)*100;
% Res(1,7)=durTN1_3hSleepy/(durTWAKE_3hSleepy+durTSWS_3hSleepy+durTREM_3hSleepy)*100;
% Res(1,8)=durTN1_3hSleepyEnd/(durTWAKE_3hSleepyEnd+durTSWS_3hSleepyEnd+durTREM_3hSleepyEnd)*100;


%N2
Res(2,1)=durTN2/(durTWAKE+durTTOTsleep)*100;
Res(2,2)=durTN2_pre/(durTWAKE_pre+durTTOTsleep_pre)*100;
Res(2,3)=durTN2_post/(durTWAKE_post+durTTOTsleep_post)*100;
Res(2,4)=durTN2_3hPostInj/(durTWAKE_3hPostInj+durTTOTsleep_3hPostInj)*100;
Res(2,5)=durTN2_first3h/(durTWAKE_first3h+durTTOTsleep_first3h)*100;
% Res(2,6)=durTN2_first3hEnd/(durTWAKE_first3hEnd+durTTOTsleep_first3hEnd)*100;
% Res(2,7)=durTN2_3hSleepy/(durTWAKE_3hSleepy+durTSWS_3hSleepy+durTREM_3hSleepy)*100;
% Res(2,8)=durTN2_3hSleepyEnd/(durTWAKE_3hSleepyEnd+durTSWS_3hSleepyEnd+durTREM_3hSleepyEnd)*100;


%N3
Res(3,1)=durTN3/(durTWAKE+durTTOTsleep)*100;
Res(3,2)=durTN3_pre/(durTWAKE_pre+durTTOTsleep_pre)*100;
Res(3,3)=durTN3_post/(durTWAKE_post+durTTOTsleep_post)*100;
Res(3,4)=durTN3_3hPostInj/(durTWAKE_3hPostInj+durTTOTsleep_3hPostInj)*100;
Res(3,5)=durTN3_first3h/(durTWAKE_first3h+durTTOTsleep_first3h)*100;
% Res(3,6)=durTN3_first3hEnd/(durTWAKE_first3hEnd+durTTOTsleep_first3hEnd)*100;
% Res(3,7)=durTN3_3hSleepy/(durTWAKE_3hSleepy+durTSWS_3hSleepy+durTREM_3hSleepy)*100;
% Res(3,8)=durTN3_3hSleepyEnd/(durTWAKE_3hSleepyEnd+durTSWS_3hSleepyEnd+durTREM_3hSleepyEnd)*100;



%Wake
Res(4,1)=durTWAKE/(durTWAKE+durTTOTsleep)*100;
Res(4,2)=durTWAKE_pre/(durTWAKE_pre+durTTOTsleep_pre)*100;
Res(4,3)=durTWAKE_post/(durTWAKE_post+durTTOTsleep_post)*100;
Res(4,4)=durTWAKE_3hPostInj/(durTWAKE_3hPostInj+durTTOTsleep_3hPostInj)*100;
Res(4,5)=durTWAKE_first3h/(durTWAKE_first3h+durTTOTsleep_first3h)*100;
% Res(4,6)=durTWAKE_first3hEnd/(durTWAKE_first3hEnd+durTTOTsleep_first3hEnd)*100;
% Res(4,7)=durTWAKE_3hSleepy/(durTWAKE_3hSleepy+durTSWS_3hSleepy+durTREM_3hSleepy)*100;
% Res(4,8)=durTWAKE_3hSleepyEnd/(durTWAKE_3hSleepyEnd+durTSWS_3hSleepyEnd+durTREM_3hSleepyEnd)*100;

%REM
Res(5,1)=durTREM/(durTWAKE+durTTOTsleep)*100;
Res(5,2)=durTREM_pre/(durTWAKE_pre+durTTOTsleep_pre)*100;
Res(5,3)=durTREM_post/(durTWAKE_post+durTTOTsleep_post)*100;
Res(5,4)=durTREM_3hPostInj/(durTWAKE_3hPostInj+durTTOTsleep_3hPostInj)*100;
Res(5,5)=durTREM_first3h/(durTWAKE_first3h+durTTOTsleep_first3h)*100;
% Res(5,6)=durTREM_first3hEnd/(durTWAKE_first3hEnd+durTTOTsleep_first3hEnd)*100;
% Res(5,7)=durTREM_3hSleepy/(durTWAKE_3hSleepy+durTSWS_3hSleepy+durTREM_3hSleepy)*100;
% Res(5,8)=durTREM_3hSleepyEnd/(durTWAKE_3hSleepyEnd+durTSWS_3hSleepyEnd+durTREM_3hSleepyEnd)*100;



% %% to update
% if plo
% 
% figure, bar([durTREM/(durTWake+durTSWS+durTREM)*100,durTREM_pre/(durTWake_pre+durTSWS_pre+durTREM_pre)*100,durTREM_post/(durTWake_post+durTSWS_post+durTREM_post)*100,durTREM3/(durTWake3+durTSWS3+durTREM3)*100])
% set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'Total','First 1/3','Second 1/3', 'Last 1/3'})
% title('Percentage of REM over all')
% 
% figure, bar([durTSWS/(durTWake+durTSWS+durTREM)*100,durTSWS_pre/(durTWake_pre+durTSWS_pre+durTREM_pre)*100,durTSWS_post/(durTWake_post+durTSWS_post+durTREM_post)*100,durTSWS3/(durTWake3+durTSWS3+durTREM3)*100])
% set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'Total','First 1/3','Second 1/3', 'Last 1/3'})
% title('Percentage of NREM over all')
% 
% figure, bar([durTWake/(durTWake+durTSWS+durTREM)*100,durTWake_pre/(durTWake_pre+durTSWS_pre+durTREM_pre)*100,durTWake_post/(durTWake_post+durTSWS_post+durTREM_post)*100,durTWake3/(durTWake3+durTSWS3+durTREM3)*100])
% set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'Total','First 1/3','Second 1/3', 'Last 1/3'})
% title('Percentage of Wake over all')

end
