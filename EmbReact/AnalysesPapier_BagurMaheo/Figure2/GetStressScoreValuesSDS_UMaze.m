function [AllDatCtrl,AllDatSDS] = GetStressScoreValuesSDS_UMaze

%% Outputs the elements of the stresssocre for SDS animals
% AllDAT : prop wake, prop rem, HR, thigmo
% Control
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_ctrl=RestrictPathForExperiment(Dir_ctrl,'nMice',[1423 1424 1425 1426 1433 1434 1449 1450 1451 1414 1439 1440 1437]);

% SDS protocl
DirSocialDefeat_classic1 = PathForExperiments_SD_MC('SleepPostSD_SalineInj');
DirSocialDefeat_classic2 = PathForExperiments_SD_MC('SleepPostSD_oneSensoryExposure_SalineInjection');
% BM mice - heart
DirSocialDefeat_BM1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_BM2 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
DirSocialDefeat_BM = MergePathForExperiment(DirSocialDefeat_BM1,DirSocialDefeat_BM2);
% Merge them
DirSocialDefeat_classic = MergePathForExperiment(DirSocialDefeat_classic2,DirSocialDefeat_classic1);
DirSocialDefeat = MergePathForExperiment(DirSocialDefeat_BM,DirSocialDefeat_classic);


% Period to quantify
time_start = 0*3600*1e4; % first hour
time_end = 3*3600*1e4; % first hour
% Thigmotaxy parameters
SpeedLim = 2; % To define movepoch
RectangleCorners = [0,0;20,0;20,40;0,40];
ExtRectangleCorners = [-2,-2;22,-2;22,42;-2,42];
ExtendedCagePoly = polyshape(ExtRectangleCorners);
LimInOut = 12;
SpVal = [0:0.2:10];

for group = 1:2
    if group ==1
        Dir = Dir_ctrl;
    else
        Dir = DirSocialDefeat;
    end
    for i=1:length(Dir.path)
        cd(Dir.path{i}{1});
        
        %%SLEEP
        %Load sleep scoring
        if exist('SleepScoring_Accelero.mat')
            stages = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        elseif exist('SleepScoring_OBGamma.mat')
            sstages = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
        else
        end
        
        %Define different periods of time for quantifications
        EPOI = intervalSet(time_start,time_end); % restrict to this epoch
        
        % States
        Sleep = or(stages.SWSEpoch,stages.REMEpoch);
        Sleep = and(Sleep,EPOI);
        Wake = and(stages.Wake,EPOI);
        REM = and(stages.REMEpoch,EPOI);
        
        %% Sleep Proportion
        REMProp{group}(i) = sum(Stop(REM) - Start(REM))./sum(Stop(Sleep)-Start(Sleep));
        SleepProp{group}(i) = sum(Stop(Sleep) - Start(Sleep))./(time_end - time_start);
        
        % Heart rate
        if exist('HeartBeatInfo.mat')>0
            load('HeartBeatInfo.mat', 'EKG')
            % Calculate HR variability
            rg = Range(EKG.HBRate);
            dt = movstd(Data(EKG.HBRate),5);
            HRVariability = tsd(rg,dt);
            LastWake = subset(Wake,length(Start(Wake)));
%             FirstWake = subset(Wake,1);
            
            HR{group}(i) = nanmean(Data(Restrict(EKG.HBRate,intervalSet(0,5*1e4)))) - nanmean(Data(Restrict(EKG.HBRate,Wake)));
            
            %             % get the speed
            %             load('behavResources.mat', 'Vtsd')
            %
            %             for sp = 1:length(SpVal)-1
            %
            %                 % Restrict to time with specific speed
            %                 LitEpoch = and(thresholdIntervals(Vtsd,SpVal(sp),'Direction','Above'),thresholdIntervals(Vtsd,SpVal(sp+1),'Direction','Below'));
            %                 LitEpoch = and(LitEpoch,Wake);
            %
            %                 % Mean heart rate during this time
            %                 MnHR_CTRL_BySpeed(sp) = nanmean(Data(Restrict(EKG.HBRate,LitEpoch)));
            %
            %
            %                 % Mean heart rate varaibility during this time
            %                 HRVar_CTRL_BySpeed(sp) = nanmean(Data(Restrict(HRVariability,LitEpoch)) );
            %             end
            %             HR{group}(i) = nanmean(MnHR_CTRL_BySpeed);
            %             HRVar{group}(i) = nanmean(HRVar_CTRL_BySpeed);
            
        else
            HR{group}(i) = NaN;
            HRVar{group}(i) = NaN;
        end
        
        %% Thigmotaxy
        if exist('AlignedCagePos.mat')
            FirstSleep = min(Start(dropShortIntervals(Sleep,1*1e4)));
            PreSleep = intervalSet(0,FirstSleep);
            
            load('behavResources.mat')
            MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
            MovEpoch = dropShortIntervals(MovEpoch,0.1*1e4);
            MovEpoch = mergeCloseIntervals(MovEpoch,3*1e4);
            
            load('AlignedCagePos.mat', 'AlignedYtsd','AlignedXtsd')
            % Distance to wall during mouvement
            X = Data(Restrict(AlignedYtsd,and(intervalSet(0,3600*1e4),MovEpoch)));
            Y = Data(Restrict(AlignedXtsd,and(intervalSet(0,3600*1e4),MovEpoch)));
            % Get rid of times when mouse is on top of the cage
            TFin = isinterior(ExtendedCagePoly,X,Y);
            X = X(TFin);
            Y = Y(TFin);
            
            for ii = 1:length(X)
                DistNear(ii) = DistancePointNearestSideRectangle([X(ii),Y(ii)],RectangleCorners);
            end
            [Y,X] = hist(DistNear,[0:0.2:10]);
            AllHist = runmean(Y/sum(Y),3);
            
            ThigmoScore{group}(i) = nanmean(AllHist(1:LimInOut)')./nanmean(AllHist(LimInOut+1:end)');
        else
            ThigmoScore{group}(i) = NaN;
        end
    end
end
% Normalize by controls
ThigmoScore{2} = ThigmoScore{2}./mean(ThigmoScore{1});
ThigmoScore{1} = ThigmoScore{1}./mean(ThigmoScore{1});

group = 1;
AllDatCtrl = [1-SleepProp{group};REMProp{group};HR{group};ThigmoScore{group}];
group = 2;
AllDatSDS = [1-SleepProp{group};REMProp{group};HR{group};ThigmoScore{group}];
