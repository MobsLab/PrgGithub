function [ResN1_half1,ResN2_half1,ResN3_half1,ResREM_half1,ResWake_half1,ResN1_half2,ResN2_half2,ResN3_half2,ResREM_half2,ResWake_half2] = CRHGetSubStagesPerc_MC(plo)

try
    plo;
catch
    plo=0;
end

load SleepScoring_OBGamma REMEpoch Wake SWSEpoch
load SleepSubstages

N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
REMEpoch=Epoch{4};
Wake=Epoch{5};

durtotal=max([max(End(Wake)),max(End(SWSEpoch))]);
Epoch1=intervalSet(0,durtotal/2); %pour ne considérer que la première moitié de la session (avant injection)
Epoch2=intervalSet(durtotal/2,durtotal); %pour ne considérer que la deuxième moitié de la session (après injection)


[durWake_half1,durTWake_half1]=DurationEpoch(and(Wake,Epoch1));
[durREM_half1,durTREM_half1]=DurationEpoch(and(REMEpoch,Epoch1));
[durN1_half1,durTN1_half1]=DurationEpoch(and(N1,Epoch1));
[durN2_half1,durTN2_half1]=DurationEpoch(and(N2,Epoch1));
[durN3_half1,durTN3_half1]=DurationEpoch(and(N3,Epoch1));

[durWake_half2,durTWake_half2]=DurationEpoch(and(Wake,Epoch2));
[durREM_half2,durTREM_half2]=DurationEpoch(and(REMEpoch,Epoch2));
[durN1_half2,durTN1_half2]=DurationEpoch(and(N1,Epoch2));
[durN2_half2,durTN2_half2]=DurationEpoch(and(N2,Epoch2));
[durN3_half2,durTN3_half2]=DurationEpoch(and(N3,Epoch2));


ResN1_half1=durTN1_half1/(durTN1_half1+durTN2_half1+durTN3_half1+durTWake_half1+durTREM_half1)*100;
ResN2_half1=durTN2_half1/(durTN1_half1+durTN2_half1+durTN3_half1+durTWake_half1+durTREM_half1)*100;
ResN3_half1=durTN3_half1/(durTN1_half1+durTN2_half1+durTN3_half1+durTWake_half1+durTREM_half1)*100;
ResWake_half1=durTWake_half1/(durTN1_half1+durTN2_half1+durTN3_half1+durTWake_half1+durTREM_half1)*100;
ResREM_half1=durTREM_half1/(durTN1_half1+durTN2_half1+durTN3_half1+durTWake_half1+durTREM_half1)*100;

ResN1_half2=durTN1_half2/(durTN1_half2+durTN2_half2+durTN3_half2+durTWake_half2+durTREM_half2)*100;
ResN2_half2=durTN2_half2/(durTN1_half2+durTN2_half2+durTN3_half2+durTWake_half2+durTREM_half2)*100;
ResN3_half2=durTN3_half2/(durTN1_half2+durTN2_half2+durTN3_half2+durTWake_half2+durTREM_half2)*100;
ResWake_half2=durTWake_half2/(durTN1_half2+durTN2_half2+durTN3_half2+durTWake_half2+durTREM_half2)*100;
ResREM_half2=durTREM_half2/(durTN1_half2+durTN2_half2+durTN3_half2+durTWake_half2+durTREM_half2)*100;

if plo
    figure, subplot(121),bar([ResN1_half1,ResN2_half1,ResN3_half1,ResREM_half1,ResWake_half1])
    subplot(12),bar([ResN1_half2,ResN2_half2,ResN3_half2,ResREM_half2,ResWake_half2])
end

end