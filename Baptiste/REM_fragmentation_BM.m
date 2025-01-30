


Dir1=PathForExperimentsSD_MC('SleepPostSD');
Dir2=PathForExperimentsSD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection');

for i=1:length(Dir1.path)
%     cd(Dir1.path{i}{1})
%     clear REMEpoch
%     load('SleepScoring_OBGamma.mat', 'REMEpoch')
%     REM_SD{i} = REMEpoch;
%     REM_dur{i} = DurationEpoch(REM_SD{i})/1e4;
%     subplot(2,4,i)
%     hist(REM_dur{i})
    M1(i) = median(REM_dur{i});
end

figure
for i=1:length(Dir2.path)
%     cd(Dir2.path{i}{1})
%     clear REMEpoch
%     load('SleepScoring_OBGamma.mat', 'REMEpoch')
%     REM_SD2{i} = REMEpoch;
%     REM_dur2{i} = DurationEpoch(REM_SD2{i})/1e4;
%     subplot(2,4,i)
%     hist(REM_dur2{i})
    M2(i) = median(REM_dur2{i});
end

Cols={[.5 1 .5],[.5 1 1]};
X=[1:2];
Legends={'SD','SD_CNO'};

figure
MakeSpreadAndBoxPlot3_SB({M1 M2},Cols,X,Legends,'showpoints',1,'paired',0);




