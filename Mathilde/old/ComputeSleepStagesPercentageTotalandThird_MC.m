function Res=ComputeSleepStagesPercentageTotalandThird_MC(Wake,SWSEpoch,REMEpoch,plo)

%
% -
% Calcul la quantité de Wake sur total enregistrement et stades de sommeil sur total sommeil dans differentes périodes
% ----------------------------------------------------------------------
%
% Res=ComputeSleepStagesPercentageTotalandThird_MC(Wake,SWSEpoch,REMEpoch,plo)
% Res matrice (3x7)
%
% Res(1,:) donne le Wake
% Res(2,:) donne le SWS
% Res(3,:) donne le REM
%
% Res(x,1) total
% Res(x,2) premier tiers
% Res(x,3) deuxième tiers
% Res(x,4) toirsième tiers
% Res(x,5) première heure
% Res(x,6) deuxième heure
% Res(x,7) troisième heure

try
  plo;
catch
    plo=0;
end

%%
durtotal=max([max(End(Wake)),max(End(SWSEpoch))]);  %Séparation en tiers
Epoch1=intervalSet(0,durtotal/3);
Epoch2=intervalSet(durtotal/3,2*durtotal/3);
Epoch3=intervalSet(2*durtotal/3,durtotal);

Epoch1h=intervalSet(0,3600*1E4);                    %Séparation en heure
Epoch2h=intervalSet(3600*1E4,2*3600*1E4);
Epoch3h=intervalSet(2*3600*1E4,3*3600*1E4);

%%
[durWake,durTWake]=DurationEpoch(Wake);
[durSWS,durTSWS]=DurationEpoch(SWSEpoch);
[durREM,durTREM]=DurationEpoch(REMEpoch);

[durWake1,durTWake1]=DurationEpoch(and(Wake,Epoch1));       %Séparation en tiers
[durSWS1,durTSWS1]=DurationEpoch(and(SWSEpoch,Epoch1));
[durREM1,durTREM1]=DurationEpoch(and(REMEpoch,Epoch1));
[durWake2,durTWake2]=DurationEpoch(and(Wake,Epoch2));
[durSWS2,durTSWS2]=DurationEpoch(and(SWSEpoch,Epoch2));
[durREM2,durTREM2]=DurationEpoch(and(REMEpoch,Epoch2));
[durWake3,durTWake3]=DurationEpoch(and(Wake,Epoch3));
[durSWS3,durTSWS3]=DurationEpoch(and(SWSEpoch,Epoch3));
[durREM3,durTREM3]=DurationEpoch(and(REMEpoch,Epoch3));

[durWake1h,durTWake1h]=DurationEpoch(and(Wake,Epoch1h));    %Séparation en heures
[durSWS1h,durTSWS1h]=DurationEpoch(and(SWSEpoch,Epoch1h));
[durREM1h,durTREM1h]=DurationEpoch(and(REMEpoch,Epoch1h));
[durWake2h,durTWake2h]=DurationEpoch(and(Wake,Epoch2h));
[durSWS2h,durTSWS2h]=DurationEpoch(and(SWSEpoch,Epoch2h));
[durREM2h,durTREM2h]=DurationEpoch(and(REMEpoch,Epoch2h));
[durWake3h,durTWake3h]=DurationEpoch(and(Wake,Epoch3h));
[durSWS3h,durTSWS3h]=DurationEpoch(and(SWSEpoch,Epoch3h));
[durREM3h,durTREM3h]=DurationEpoch(and(REMEpoch,Epoch3h));



%% RESULTAT

%Wake
Res(1,1)=durTWake/(durTWake+durTSWS+durTREM)*100;           
Res(1,2)=durTWake1/(durTWake1+durTSWS1+durTREM1)*100;
Res(1,3)=durTWake2/(durTWake2+durTSWS2+durTREM2)*100;
Res(1,4)=durTWake3/(durTWake3+durTSWS3+durTREM3)*100;
Res(1,5)=durTWake1h/(durTWake1h+durTSWS1h+durTREM1h)*100;
Res(1,6)=durTWake2h/(durTWake2h+durTSWS2h+durTREM2h)*100;
Res(1,7)=durTWake3h/(durTWake3h+durTSWS3h+durTREM3h)*100;

%SWS
Res(2,1)=durTSWS/(durTSWS+durTREM+durTWake)*100;
Res(2,2)=durTSWS1/(durTSWS1+durTREM1+durTWake1)*100;
Res(2,3)=durTSWS2/(durTSWS2+durTREM2+durTWake2)*100;
Res(2,4)=durTSWS3/(durTSWS3+durTREM3+durTWake3)*100;
Res(2,5)=durTSWS1h/(durTSWS1h+durTREM1h+durTWake1h)*100;
Res(2,6)=durTSWS2h/(durTSWS2h+durTREM2h+durTWake2h)*100;
Res(2,7)=durTSWS3h/(durTSWS3h+durTREM3h+durTWake3h)*100;

%REM
Res(3,1)=durTREM/(durTSWS+durTREM+durTWake)*100;
Res(3,2)=durTREM1/(durTSWS1+durTREM1+durTWake1)*100;
Res(3,3)=durTREM2/(durTSWS2+durTREM2+durTWake2)*100;
Res(3,4)=durTREM3/(durTSWS3+durTREM3+durTWake)*100;
Res(3,5)=durTREM1h/(durTSWS1h+durTREM1h+durTWake1h)*100;
Res(3,6)=durTREM2h/(durTSWS2h+durTREM2h+durTWake2h)*100;
Res(3,7)=durTREM3h/(durTSWS3h+durTREM3h+durTWake3h)*100;



%%
if plo

figure, bar([durTREM/(durTSWS+durTREM+durTWake)*100,durTREM1/(durTSWS1+durTREM1+durTWake1)*100,durTREM2/(durTSWS2+durTREM2+durTWake2)*100,durTREM3/(durTSWS3+durTREM3+durTWake3)*100])
set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'Total','First 1/3','Second 1/3', 'Last 1/3'})
title('Percentage of REM')

figure, bar([durTSWS/(durTSWS+durTREM+durTWake)*100,durTSWS1/(durTSWS1+durTREM1+durTWake1)*100,durTSWS2/(durTSWS2+durTREM2+durTWake2)*100,durTSWS3/(durTSWS3+durTREM3+durTWake3)*100])
set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'Total','First 1/3','Second 1/3', 'Last 1/3'})
title('Percentage of NREM')

figure, bar([durTWake/(durTWake+durTSWS+durTREM)*100,durTWake1/(durTWake1+durTSWS1+durTREM1)*100,durTWake2/(durTWake2+durTSWS2+durTREM2)*100,durTWake3/(durTWake3+durTSWS3+durTREM3)*100])
set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'Total','First 1/3','Second 1/3', 'Last 1/3'})
title('Percentage of Wake over all')

end