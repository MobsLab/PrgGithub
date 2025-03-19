clear all

%% input dir
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_ctrl=RestrictPathForExperiment(Dir_ctrl,'nMice',[1423 1424 1425 1426 1433 1434 1449 1450 1451 1414 1439 1440 1437]);

DirSocialDefeat_totSleepPost_BM_cno1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
DirSocialDefeat_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_BM = MergePathForExperiment(DirSocialDefeat_totSleepPost_BM_cno1,DirSocialDefeat_BM_saline1);
DirSocialDefeat_classic1 = PathForExperiments_SD_MC('SleepPostSD');
DirSocialDefeat_classic2 = PathForExperiments_SD_MC('SleepPostSD_SalineInj');
DirSocialDefeat_classic3 = PathForExperiments_SD_MC('SleepPostSD_oneSensoryExposure_SalineInjection');
DirSocialDefeat_classic = MergePathForExperiment(DirSocialDefeat_classic1,DirSocialDefeat_classic2);
DirSocialDefeat_classic = MergePathForExperiment(DirSocialDefeat_classic,DirSocialDefeat_classic3);
DirSocialDefeat_classic1 = MergePathForExperiment(DirSocialDefeat_BM,DirSocialDefeat_classic);
%%

%% GET DATA - ctrl group (mCherry saline injection 10h without stress)
clear SFI LatencyToState
time_start = 0*3600*1e4; % first hour
time_end = 3*3600*1e4; % first hour
for i=1:length(Dir_ctrl.path)
    cd(Dir_ctrl.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_ctrl{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_ctrl{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    %%Define different periods of time for quantifications
    EPOI = intervalSet(time_start,time_end); % restrict to this epoch
    Sleep = or(stages_ctrl{i}.SWSEpoch,stages_ctrl{i}.REMEpoch);
    Sleep = and(Sleep,EPOI);
    
    % REM prop
    REMProp{1}(i) = sum(Stop(and(stages_ctrl{i}.REMEpoch,EPOI)) - Start(and(stages_ctrl{i}.REMEpoch,EPOI)))./sum(Stop(Sleep)-Start(Sleep));
    
    % Latency to state
    StateStart = Start(Sleep)/1e4;
    StateDur = DurationEpoch(Sleep)/1e4;
    j=1;
    for ii=20:20:200
        val = StateStart(find(StateDur>ii,1));
        if isempty(val)
            LatencyToState{1}(i,j) = NaN;
        else
            LatencyToState{1}(i,j) = StateStart(find(StateDur>ii,1));
        end
        j=j+1;
    end
    
    % Fragmentation
    SFI{1}(i) = length(StateStart)./(nanmean(StateDur));
    Prop{1}(i) = nansum(StateDur)/(time_end/1E4 - time_start/1E4)
end



%% GET DATA - SDS group (mCherry saline injection 10h with stress)
for i=1:length(DirSocialDefeat_classic1.path)
    cd(DirSocialDefeat_classic1.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_ctrl{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_ctrl{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    %%Define different periods of time for quantifications
    EPOI = intervalSet(time_start,time_end); % restrict to this epoch
    Sleep = or(stages_ctrl{i}.SWSEpoch,stages_ctrl{i}.REMEpoch);
    Sleep = and(Sleep,EPOI);
    
    % REM prop
    REMProp{2}(i) = sum(Stop(and(stages_ctrl{i}.REMEpoch,EPOI)) - Start(and(stages_ctrl{i}.REMEpoch,EPOI)))./sum(Stop(Sleep)-Start(Sleep));
    
    % Latency to state
    StateStart = Start(Sleep)/1e4;
    StateDur = DurationEpoch(Sleep)/1e4;
    j=1;
    for ii=20:20:200
        val = StateStart(find(StateDur>ii,1));
        if isempty(val)
            LatencyToState{2}(i,j) = NaN;
        else
            LatencyToState{2}(i,j) = StateStart(find(StateDur>ii,1));
        end
        j=j+1;
    end
    
    % Fragmentation
    SFI{2}(i) = length(StateStart)./(nanmean(StateDur));
    Prop{2}(i) = nansum(StateDur)/(time_end/1E4 - time_start/1E4)
    
end


Cols2 = {[0.75, 0.75, 0.75],[0.8,0.3,0]};
X2 = [1:2];
Legends2 = {'NoStress','Stress'};
NoLegends2 = {'',''};

% REM prop
figure
MakeSpreadAndBoxPlot3_SB(REMProp,Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('REMP proportion')


% SFI
figure
MakeSpreadAndBoxPlot3_SB(SFI,Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Sleep fragmentation index (a.u.)')


% Sleep proportion
figure
MakeSpreadAndBoxPlot3_SB(Prop,Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Sleepproportion')

