clear all
%% input dir
%%1
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_ctrl=RestrictPathForExperiment(Dir_ctrl,'nMice',[1414,1439,1440,1416,1437]); % BM mice with heart

%%2
DirSocialDefeat_totSleepPost_BM_cno1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
DirSocialDefeat_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_BM = MergePathForExperiment(DirSocialDefeat_totSleepPost_BM_cno1,DirSocialDefeat_BM_saline1);
close all

%% Speed Vals threshold
SpVal = [0:0.2:10];

time_start = 0*3600*1e4; % first hour
time_end = 3*3600*1e4; % first hour

% CTRL
for i=1:length(Dir_ctrl.path)
    cd(Dir_ctrl.path{i}{1});
    clear stages Wake EKG HRVar Vtsd
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    %%Restrict to beginning of session
    EPOI = intervalSet(time_start,time_end); % restrict to this epoch
    Wake = and(stages{i}.Wake,EPOI);
    
    % Get the herat rate
    load('HeartBeatInfo.mat', 'EKG')
    % Calculate HR variability
    rg = Range(EKG.HBRate);
    dt = movstd(Data(EKG.HBRate),5);
    HRVar = tsd(rg,dt);
    
    % get the speed
    load('behavResources.mat', 'Vtsd')
    
    for sp = 1:length(SpVal)-1
        
        % Restrict to time with specific speed
        LitEpoch = and(thresholdIntervals(Vtsd,SpVal(sp),'Direction','Above'),thresholdIntervals(Vtsd,SpVal(sp+1),'Direction','Below'));
        LitEpoch = and(LitEpoch,Wake);
        
        % Mean heart rate during this time
        MnHR_CTRL_BySpeed(i,sp) = nanmean(Data(Restrict(EKG.HBRate,LitEpoch)));
        
        
        % Mean heart rate varaibility during this time
        HRVar_CTRL_BySpeed(i,sp) = nanmean(Data(Restrict(HRVar,LitEpoch)) );
        
    end
end



% SDS
for i=1:length(DirSocialDefeat_BM.path)
    cd(DirSocialDefeat_BM.path{i}{1});
    clear stages Wake EKG HRVar Vtsd
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    %%Restrict to beginning of session
    EPOI = intervalSet(time_start,time_end); % restrict to this epoch
    Wake = and(stages{i}.Wake,EPOI);
    
    % Get the herat rate
    load('HeartBeatInfo.mat', 'EKG')
    % Calculate HR variability
    rg = Range(EKG.HBRate);
    dt = movstd(Data(EKG.HBRate),5);
    HRVar = tsd(rg,dt);
    
    % get the speed
    load('behavResources.mat', 'Vtsd')
    
    for sp = 1:length(SpVal)-1
        
        % Restrict to time with specific speed
        LitEpoch = and(thresholdIntervals(Vtsd,SpVal(sp),'Direction','Above'),thresholdIntervals(Vtsd,SpVal(sp+1),'Direction','Below'));
        LitEpoch = and(LitEpoch,Wake);
        
        % Mean heart rate during this time
        MnHR_SDS_BySpeed(i,sp) = nanmean(Data(Restrict(EKG.HBRate,LitEpoch)));
        
        % Mean heart rate varaibility during this time
        HRVar_SDS_BySpeed(i,sp) = nanmean(Data(Restrict(HRVar,LitEpoch)) );
        
    end
end
SpVal = SpVal(1:end-1);

Cols2 = {[0.75, 0.75, 0.75],[0.8,0.3,0]};
X2 = [1:2];
Legends2 = {'NoStress','Stress'};

figure
subplot(2,3,1:2)
errorbar(SpVal,nanmean(MnHR_CTRL_BySpeed),stdError(MnHR_CTRL_BySpeed),'color',Cols2{1})
hold on
errorbar(SpVal,nanmean(MnHR_SDS_BySpeed),stdError(MnHR_SDS_BySpeed),'color',Cols2{2})
ylabel('HR')
xlabel('Speed (cm/s)')
makepretty

subplot(2,3,3)
Vals = {nanmean(MnHR_CTRL_BySpeed'),nanmean(MnHR_SDS_BySpeed')}
MakeSpreadAndBoxPlot3_SB(Vals,Cols2,X2,Legends2,'showpoints',1,'paired',0)
ylabel('HR')
ylim([8 13])
makepretty

subplot(2,3,4:5)
errorbar(SpVal,nanmean(HRVar_CTRL_BySpeed),stdError(HRVar_CTRL_BySpeed),'color',Cols2{1})
hold on
errorbar(SpVal,nanmean(HRVar_SDS_BySpeed),stdError(HRVar_SDS_BySpeed),'color',Cols2{2})
ylabel('HRVar')
makepretty

subplot(2,3,6)
Vals = {nanmean(HRVar_CTRL_BySpeed'),nanmean(HRVar_SDS_BySpeed')}
MakeSpreadAndBoxPlot3_SB(Vals,Cols2,X2,Legends2,'showpoints',1,'paired',0)
ylabel('HRVar')
ylim([0 0.2])
makepretty


%% Try matching the mice
count = 1;
for mm = 1:length(DirSocialDefeat_BM.name)
    id = find(strcmp(DirSocialDefeat_BM.name{mm},Dir_ctrl.name));
    if not(isempty(id))
        MatchedMice.Ctrl(count) = id;
        MatchedMice.SDS(count) = mm;
        count = count+1;
        
    end
end
% Same but with  matched mice
figure
subplot(2,3,1:2)
errorbar(SpVal,nanmean(MnHR_CTRL_BySpeed(MatchedMice.Ctrl,:)),stdError(MnHR_CTRL_BySpeed(MatchedMice.Ctrl,:)),'color',Cols2{1})
hold on
errorbar(SpVal,nanmean(MnHR_SDS_BySpeed(MatchedMice.SDS,:)),stdError(MnHR_SDS_BySpeed(MatchedMice.SDS,:)),'color',Cols2{2})
ylabel('HR')
xlabel('Speed (cm/s)')
makepretty
subplot(2,3,3)
Vals = {nanmean(MnHR_CTRL_BySpeed(MatchedMice.Ctrl,:)'),nanmean(MnHR_SDS_BySpeed(MatchedMice.SDS,:)')}
MakeSpreadAndBoxPlot3_SB(Vals,Cols2,X2,Legends2,'showpoints',1,'paired',1)
ylabel('HR')
ylim([8 13])
makepretty
subplot(2,3,4:5)
errorbar(SpVal,nanmean(HRVar_CTRL_BySpeed(MatchedMice.Ctrl,:)),stdError(HRVar_CTRL_BySpeed(MatchedMice.Ctrl,:)),'color',Cols2{1})
hold on
errorbar(SpVal,nanmean(HRVar_SDS_BySpeed(MatchedMice.SDS,:)),stdError(HRVar_SDS_BySpeed(MatchedMice.SDS,:)),'color',Cols2{2})
ylabel('HRVar')
makepretty
subplot(2,3,6)
Vals = {nanmean(HRVar_CTRL_BySpeed(MatchedMice.Ctrl,:)'),nanmean(HRVar_SDS_BySpeed(MatchedMice.SDS,:)')}
MakeSpreadAndBoxPlot3_SB(Vals,Cols2,X2,Legends2,'showpoints',1,'paired',1)
ylabel('HRVar')
ylim([0 0.2])
makepretty
