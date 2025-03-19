 function Res=Compute_Seq_Single_REM_Percentages_SocialDefeat_MC(Wake,SWSEpoch,REMEpoch,param,plo)

 
% Res(1,:) all recording
% Res(2,:) post injection
% Res(3,:) post SD

% Res(x,1) total rem
% Res(x,2) sequential rem
% Res(x,3) single rem


try
  plo;
catch
    plo=0;
end

%% parameters to define time periods


st_epoch_post_SD = 0.55*1E8;
st_epoch_post_inj = 1.5*1E8;

%% time periods
durtotal=max([max(End(Wake)),max(End(SWSEpoch))]);

epoch_post_inj=intervalSet(st_epoch_post_inj,durtotal); %from injection to the end
epoch_post_SD=intervalSet(st_epoch_post_SD,durtotal); %SD to the end

%% duration of stages according to specific time periods

[Seq_REMEpoch,Single_REMEpoch] = Find_single_sequential_REM_MC(Wake,SWSEpoch,REMEpoch,param);

TotalSleep = or(SWSEpoch,REMEpoch);

%%all recording
% [dur_total_REM,durT_total_REM]=DurationEpoch(REMEpoch);
% [dur_seq_REM,durT_seq_REM]=DurationEpoch(Seq_REMEpoch);
% [dur_sing_REM,durT_sing_REM]=DurationEpoch(Single_REMEpoch);
% [durTotSleep,durTTotSleep]=DurationEpoch(TotalSleep);

%first half / pre injection
[dur_total_REM_post_inj,durT_total_REM_post_inj]=DurationEpoch(and(REMEpoch,epoch_post_inj));
[dur_seq_REM_post_inj,durT_seq_REM_post_inj]=DurationEpoch(and(Seq_REMEpoch,epoch_post_inj));
[dur_sing_REM_post_inj,durT_sing_REM_post_inj]=DurationEpoch(and(Single_REMEpoch,epoch_post_inj));
[durTotSleep_post_inj,durTTotSleep_post_inj]=DurationEpoch(and(TotalSleep,epoch_post_inj));

%%second half / post injection
[dur_total_REM_post_SD,durT_total_REM_post_SD]=DurationEpoch(and(REMEpoch,epoch_post_SD));
[dur_seq_REM_post_SD,durT_seq_REM_post_SD]=DurationEpoch(and(Seq_REMEpoch,epoch_post_SD));
[dur_sing_REM_post_SD,durT_sing_REM_post_SD]=DurationEpoch(and(Single_REMEpoch,epoch_post_SD));
[durTotSleep_post_SD,durTTotalSleep_post_SD]=DurationEpoch(and(TotalSleep,epoch_post_SD));


%% RESULTAT


%REM
%%all recording
% Res(1,1)=durT_total_REM/durTTotSleep*100;
% Res(1,2)=durT_seq_REM/durTTotSleep*100;
% Res(1,3)=durT_sing_REM/durTTotSleep*100;
% 
% %%post injection
Res(2,1)=durT_total_REM_post_inj/durTTotSleep_post_inj*100;
Res(2,2)=durT_seq_REM_post_inj/durTTotSleep_post_inj*100;
Res(2,3)=durT_sing_REM_post_inj/durTTotSleep_post_inj*100;

%%post SD
Res(3,1)=durT_total_REM_post_SD/durTTotalSleep_post_SD*100;
Res(3,2)=durT_seq_REM_post_SD/durTTotalSleep_post_SD*100;
Res(3,3)=durT_sing_REM_post_SD/durTTotalSleep_post_SD*100;



