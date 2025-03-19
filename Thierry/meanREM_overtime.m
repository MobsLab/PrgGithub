% parameters
try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end


%% Mouse in homecage1

mm=0;
mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M929_Baseline2';
mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M930_Baseline2';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M927_Baseline2';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline2_02072019/M928_Baseline2';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M953_Baseline2';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline2_09072019/M954_Baseline2';

for m = 1:mm
    cd(FileName{m})
    load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
    load('ExpeInfo.mat')

    maxlimHomecage1(m)=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);
    numpointsHomecage1(m)=floor(maxlimHomecage1(m)/pas/1E4)+1;
    MouseNumber{m} = num2str(ExpeInfo.nmouse);
    
for i=1:numpointsHomecage1(m)
    perHomecage1(m,i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsHomecage1(m,i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


end

for m = 1:mm
ZeroVals = find(tpsHomecage1(m,:) == 0);
perHomecage1(m,ZeroVals) = NaN;
tpsHomecage1(m,ZeroVals) = NaN;
plot(tpsHomecage1(m,:)/1E4,perHomecage1(m,:),'o-')
ylabel('Percentage (%)')
xlabel('time (s)')
title('Homecage1')
legend(MouseNumber)
hold on

end

plot(nanmean(tpsHomecage1/1E4),nanmean(perHomecage1),'k-')
errorbar(nanmean(tpsHomecage1/1E4),nanmean(perHomecage1),stdError(perHomecage1))
ylabel('Percentage (%)')
xlabel('time (s)')
legend('Homecage1')
hold on

%% Mouse with CNO in exchange cage condition

mm=0;
mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M929_CNO';
mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M930_CNO';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M927_CNO_1_day5';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M928_CNO_1_day5';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M953_CNO';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_CNO_10072019/M954_CNO';

for m = 1:mm
    cd(FileName{m})
    load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
    load('ExpeInfo.mat')

    maxlimCNO(m)=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);
    numpointsCNO(m)=floor(maxlimCNO(m)/pas/1E4)+1;
    MouseNumber{m} = num2str(ExpeInfo.nmouse);
    
for i=1:numpointsCNO(m)
    perCNO(m,i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsCNO(m,i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


end

for m = 1:mm
ZeroVals = find(tpsCNO(m,:) == 0);
perCNO(m,ZeroVals) = NaN;
tpsCNO(m,ZeroVals) = NaN;
plot(tpsCNO(m,:)/1E4,perCNO(m,:),'o-')
ylabel('Percentage (%)')
xlabel('time (s)')
title('CNO')
legend(MouseNumber)
hold on
end


plot(nanmean(tpsCNO/1E4),nanmean(perCNO),'k-')
errorbar(nanmean(tpsCNO/1E4),nanmean(perCNO),stdError(perCNO))
ylabel('Percentage (%)')
xlabel('time (s)')
legend('Homecage1', 'CNO')
hold on



%% Mouse in homecage2

mm=0;
mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M929_Baseline3';
mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M930_Baseline3';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M927_Baseline3';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_Baseline3_04072019/M928_Baseline3';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M953_Baseline3';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Baseline3_day4_190711/M954_Baseline3';

for m = 1:mm
    cd(FileName{m})
    load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
    load('ExpeInfo.mat')

    maxlimHomecage2(m)=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);
    numpointsHomecage2(m)=floor(maxlimHomecage2(m)/pas/1E4)+1;
    MouseNumber{m} = num2str(ExpeInfo.nmouse);
    
for i=1:numpointsHomecage2(m)
    perHomecage2(m,i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsHomecage2(m,i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


end

for m = 1:mm
ZeroVals = find(tpsHomecage2(m,:) == 0);
perHomecage2(m,ZeroVals) = NaN;
tpsHomecage2(m,ZeroVals) = NaN;
plot(tpsHomecage2(m,:)/1E4,perHomecage2(m,:),'o-')
ylabel('Percentage (%)')
xlabel('time (s)')
title('Homecage2')
legend(MouseNumber)

hold on

end

plot(nanmean(tpsHomecage2/1E4),nanmean(perHomecage2),'k-')
errorbar(nanmean(tpsHomecage2/1E4),nanmean(perHomecage2),stdError(perHomecage2))
ylabel('Percentage (%)')
xlabel('time (s)')
legend('Homecage2')
hold on


%% Mouse with Saline in exchange cage condition

mm=0;
mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M929_Saline';
mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M930_Saline';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M923_Saline_1_day5';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_saline_2_05072019/M926_Saline_1_day5';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M953 Saline';
% mm=mm+1; FileName{mm} = '/media/nas5/Thierry_DATA/Exchange_Cages/929_930_953_954_Saline_day5_12072019/M954 Saline';

for m = 1:mm
    cd(FileName{m})
    load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
    load('ExpeInfo.mat')

    maxlimSaline(m)=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);
    numpointsSaline(m)=floor(maxlimSaline(m)/pas/1E4)+1;
    MouseNumber{m} = num2str(ExpeInfo.nmouse);
    
for i=1:numpointsSaline(m)
    perSaline(m,i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tpsSaline(m,i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end


end

for m = 1:mm
ZeroVals = find(tpsSaline(m,:) == 0);
perSaline(m,ZeroVals) = NaN;
tpsSaline(m,ZeroVals) = NaN;
plot(tpsSaline(m,:)/1E4,perSaline(m,:),'o-')
ylabel('Percentage (%)')
xlabel('time (s)')
title('Saline')
legend(MouseNumber)

hold on

end

plot(nanmean(tpsSaline/1E4),nanmean(perSaline),'k-')
errorbar(nanmean(tpsSaline/1E4),nanmean(perSaline),stdError(perSaline))
ylabel('Percentage (%)')
xlabel('time (s)')
legend('saline')


% Résumé des graphes moyens

plot(nanmean(tpsHomecage1/1E4),nanmean(perHomecage1),'k-')
errorbar(nanmean(tpsHomecage1/1E4),nanmean(perHomecage1),stdError(perHomecage1))
ylabel('Percentage (%)')
xlabel('time (s)')
hold on

plot(nanmean(tpsCNO/1E4),nanmean(perCNO),'r-')
errorbar(nanmean(tpsCNO/1E4),nanmean(perCNO),stdError(perCNO))
ylabel('Percentage (%)')
xlabel('time (s)')
hold on

plot(nanmean(tpsHomecage2/1E4),nanmean(perHomecage2),'g-')
errorbar(nanmean(tpsHomecage2/1E4),nanmean(perHomecage2),stdError(perHomecage2))
ylabel('Percentage (%)')
xlabel('time (s)')
hold on

plot(nanmean(tpsSaline/1E4),nanmean(perSaline),'b-')
errorbar(nanmean(tpsSaline/1E4),nanmean(perSaline),stdError(perSaline))
ylabel('REM Percentage (%)')
xlabel('time (s)')
legend('Homecage1', 'Homecage-CNO','Homecage2','Homecage-Saline')
set(gca,'FontSize',14)
xticks([1 2 3 4])

%% superposition de saline et CNO

plot(nanmean(tpsCNO/1E4),nanmean(perCNO),'r-','LineWidth',2)
errorbar(nanmean(tpsCNO/1E4),nanmean(perCNO),stdError(perCNO))
ylabel('Percentage (%)')
xlabel('time (s)')
hold on

plot(nanmean(tpsSaline/1E4),nanmean(perSaline),'k','LineWidth',2)
errorbar(nanmean(tpsSaline/1E4),nanmean(perSaline),stdError(perSaline))
ylabel('REM Percentage (%)')
xlabel('time (s)')
legend('Homecage-CNO','Homecage-Saline')
set(gca,'FontSize',14)
xticks([1 2])



%%%
cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse923_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')

try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlim923CNO=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);

numpoints923CNO=floor(maxlim923CNO/pas/1E4)+1;

for i=1:numpoints923CNO
    per923CNO(mm,i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tps923CNO(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

plot(tps923CNO/1E4,rescale(per923CNO,-1,2),'ro-')
ylabel('Percentage (%)')
xlabel('time (s)')
title('Day CNO or Saline Day 3')
legend('923CNO')
hold on

cd /media/nas5/Thierry_DATA/Exchange_Cages/923_926_927_928_Session1_CNO_Saline_03072019/Mouse926_CNO_1_day3
load('SleepScoring_OBGamma.mat', 'Wake','REMEpoch','SWSEpoch','Sleep')
try
    pas;
catch
    pas=500;
end

try
    plo;
catch
    plo=0;
end

maxlim926CNO=max([max(End(Wake)),max(End(REMEpoch)), max(End(SWSEpoch))]);

numpoints926CNO=floor(maxlim926CNO/pas/1E4)+1;

for i=1:numpoints926CNO
    per926CNO(i)=FindPercREM(REMEpoch,SWSEpoch, intervalSet((i-1)*pas*1E4,i*pas*1E4));
    tps926CNO(i)=(i*pas*1E4+(i-1)*pas*1E4)/2;
end

plot(tpsCNO/1E4,rescale(perCNO,3,6),'bo-')
ylabel('Percentage (%)')
xlabel('time (s)')
title('Day CNO or Saline Day 3')
legend('926CNO')
hold on

