function Res=ComputeSleepStagesPercAfterInjectionMC(Wake,SWSEpoch,REMEpoch,plo)

%
% -
% compute the percentage of Wake, REM, NREM during the whole session or
% first or second half
%
% Res matrice (3x7)
%
% Res(1,:) donne le Wake
% Res(2,:) donne le SWS
% Res(3,:) donne le REM
%
% Res(x,1) total
% Res(x,2) première moitié
% Res(x,3) deuxième moitié


try
  plo;
catch
    plo=0;
end

%%
durtotal=max([max(End(Wake)),max(End(SWSEpoch))]);
Epoch1=intervalSet(0,durtotal/2);
Epoch2=intervalSet(durtotal/2,durtotal);

%%
[durWake,durTWake]=DurationEpoch(Wake); % sur total enregistrement
[durSWS,durTSWS]=DurationEpoch(SWSEpoch);
[durREM,durTREM]=DurationEpoch(REMEpoch);

[durWake1,durTWake1]=DurationEpoch(and(Wake,Epoch1)); % première moitié
[durSWS1,durTSWS1]=DurationEpoch(and(SWSEpoch,Epoch1));
[durREM1,durTREM1]=DurationEpoch(and(REMEpoch,Epoch1));
[durWake2,durTWake2]=DurationEpoch(and(Wake,Epoch2)); % deuxième moitié (après injection)
[durSWS2,durTSWS2]=DurationEpoch(and(SWSEpoch,Epoch2));
[durREM2,durTREM2]=DurationEpoch(and(REMEpoch,Epoch2));



%% RESULTAT

%Wake
Res(1,1)=durTWake/(durTWake+durTSWS+durTREM)*100;
Res(1,2)=durTWake1/(durTWake1+durTSWS1+durTREM1)*100;
Res(1,3)=durTWake2/(durTWake2+durTSWS2+durTREM2)*100;

%SWS
Res(2,1)=durTSWS/(durTWake+durTSWS+durTREM)*100;
Res(2,2)=durTSWS1/(durTWake1+durTSWS1+durTREM1)*100;
Res(2,3)=durTSWS2/(durTWake2+durTSWS2+durTREM2)*100;

%REM
Res(3,1)=durTREM/(durTWake+durTSWS+durTREM)*100;
Res(3,2)=durTREM1/(durTWake1+durTSWS1+durTREM1)*100;
Res(3,3)=durTREM2/(durTWake2+durTSWS2+durTREM2)*100;

%% to update
if plo

figure, bar([durTREM/(durTWake+durTSWS+durTREM)*100,durTREM1/(durTWake1+durTSWS1+durTREM1)*100,durTREM2/(durTWake2+durTSWS2+durTREM2)*100,durTREM3/(durTWake3+durTSWS3+durTREM3)*100])
set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'Total','First 1/3','Second 1/3', 'Last 1/3'})
title('Percentage of REM over all')

figure, bar([durTSWS/(durTWake+durTSWS+durTREM)*100,durTSWS1/(durTWake1+durTSWS1+durTREM1)*100,durTSWS2/(durTWake2+durTSWS2+durTREM2)*100,durTSWS3/(durTWake3+durTSWS3+durTREM3)*100])
set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'Total','First 1/3','Second 1/3', 'Last 1/3'})
title('Percentage of NREM over all')

figure, bar([durTWake/(durTWake+durTSWS+durTREM)*100,durTWake1/(durTWake1+durTSWS1+durTREM1)*100,durTWake2/(durTWake2+durTSWS2+durTREM2)*100,durTWake3/(durTWake3+durTSWS3+durTREM3)*100])
set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'Total','First 1/3','Second 1/3', 'Last 1/3'})
title('Percentage of Wake over all')

end
