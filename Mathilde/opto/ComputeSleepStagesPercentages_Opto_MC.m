 function Res=ComputeSleepStagesPercentages_Opto_MC(Wake,SWSEpoch,REMEpoch,plo)

%
% -
% Calcul la quantité de chaque stade de sommeil dans differente périodes
% ----------------------------------------------------------------------
%
% Res=ComputeSleepStagesPercentageTotalandThird(Wake,SWSEpoch,REMEpoch,plo)
% Res matrice (3x7)
%
% Res(1,:) donne le Wake
% Res(2,:) donne le SWS
% Res(3,:) donne le REM

% Res(x,1) all recording

try
  plo;
catch
    plo=0;
end

%% parameters


%% time periods

durtotal=max([max(End(Wake)),max(End(SWSEpoch))]);


%% compute durations for each time periods

[durWake,durTWake]=DurationEpoch(Wake); % all recording
[durSWS,durTSWS]=DurationEpoch(SWSEpoch);
[durREM,durTREM]=DurationEpoch(REMEpoch);


%% RESULTAT
%Wake
Res(1,1)=durTWake/(durTWake+durTSWS+durTREM)*100;


%SWS
Res(2,1)=durTSWS/(durTWake+durTSWS+durTREM)*100;


%REM
Res(3,1)=durTREM/(durTWake+durTSWS+durTREM)*100;

