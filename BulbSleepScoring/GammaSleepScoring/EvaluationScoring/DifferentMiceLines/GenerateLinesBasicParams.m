%% Used for draft 11th april
clear all, close all

%% Sessions
% C57
% m=1;
% filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M147';
% % filename{m,2}=7;
% m=m+1;
% filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
% % filename{m,2}=7;
% m=m+1;
% filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177';
% % filename{m,2}=9;
% m=m+1;
% filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178';
% % filename{m,2}=18;
% m=m+1;
% filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M177';
% % filename{m,2}=9;
% m=m+1;
% filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M178';
% % filename{m,2}=18;
% m=m+1;
% filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M258/20151112/';
% % filename{m,2}=18;
% m=m+1;
% filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M259/20151112/';

% DBA
% m=1;
% filename{m,1}='/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M721/Sleep_Baseline';
% m=m+1;
% filename{m,1}='/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M730';
% m=m+1;
% filename{m,1}='/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M729';

% % C3H
% m=1;
% filename{m,1}='/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M719/Sleep_Baseline';
% filename{m,2}=7;
% m=m+1;
% filename{m,1}='/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M720/Sleep_Baseline';
% % filename{m,2}=7;

% Gadcre
filename ={'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161116',
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123',
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126',
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130',
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202'};
m=5;

for mm=1:m
    mm
    cd(filename{mm})
    load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake','Epoch')

    SleepParams.TotTime(mm) = sum(Stop(Epoch,'s')-Start(Epoch,'s'));
    SleepParams.REMTime(mm) = sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
    SleepParams.SWSTime(mm) = sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
    SleepParams.WakeTime(mm) = sum(Stop(Wake,'s')-Start(Wake,'s'));
    
    SleepParams.REMBoutDur{mm} = (Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
    SleepParams.SWSBoutDur{mm} = nanmean(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
    SleepParams.WakeBoutDur{mm} = nanmean(Stop(Wake,'s')-Start(Wake,'s'));

    
end

save('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/SleepParametersGADCre.mat','SleepParams')
