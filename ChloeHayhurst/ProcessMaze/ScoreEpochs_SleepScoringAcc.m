
function [REMEpochAcc, SWSEpochAcc, WakeAcc,REMEpochWiNoiseAcc, SWSEpochWiNoiseAcc, WakeWiNoiseAcc] = ...
    ScoreEpochs_SleepScoringAcc(TotalNoiseEpoch, Epoch, SleepEpochAcc, ThetaEpochAcc, minduration,SmoothTheta,Info)

try
    theta_thresh=Info.theta_thresh;
catch
    load('StateEpochSB.mat', 'Info')
    theta_thresh=Info.theta_thresh;
end

%% Definition of vigilance states

% define REM as overlap of sleep and ThetaEpoch that lasts more than 3s
disp('          ...defining REM')
REMEpochAcc = and(SleepEpochAcc,ThetaEpochAcc);
REMEpochAcc = mergeCloseIntervals(REMEpochAcc,minduration*1e4);
REMEpochAcc = dropShortIntervals(REMEpochAcc,minduration*1e4);

% define SWS as sleep that is not REM
disp('          ...defining NREM')
SWSEpochAcc = SleepEpochAcc-REMEpochAcc;


disp('          ...defining Wake')
% modified SB 20/11/2018 according to decision made together
% define wake as time (including noise) that is not sleep
WakeWiNoiseAcc = or(Epoch,TotalNoiseEpoch)-SleepEpochAcc;
% clean wake without noise
WakeAcc = Epoch-SleepEpochAcc;


disp('          ...fixing rem-wake alignement')
% deal with non-alignement of end of REM and beginning of wake --> align if
% less than 2s difference
[~, bef_cell] = transEpoch(SWSEpochAcc,REMEpochAcc);
SWS_After_REM = bef_cell{1,2};

[aft_cell, ~] = transEpoch(SWSEpochAcc,WakeAcc);
SWS_Bef_Wake = aft_cell{1,2};

if ~isempty(SWS_After_REM) && ~isempty(SWS_Bef_Wake)
    disp('          ...removing short NREM between REM and wake')
    % remove short episodes of SWS that are between REM and Wake
    SWS_between_REM_Wake = and(SWS_After_REM,SWS_Bef_Wake);
    SWS_to_delete = dropLongIntervals(SWS_between_REM_Wake,minduration*1e4); %episodes to remove from SWS
    WakeAcc = or(WakeAcc,SWS_to_delete); % add them to Wake
    SWSEpochAcc = SWSEpochAcc-SWS_to_delete;
end

% fix bouts of rem after wake - added by SL 2021-05
disp('          ___________________________________________')
disp('')
disp('          -Check-')
[~, bef_cell] = transEpoch(REMEpochAcc,WakeAcc);
REM_After_Wake = bef_cell{1,2};
disp(['          Number of REM epochs after wake:' num2str(length(Start(REM_After_Wake)))])
if ~isempty(Start(REM_After_Wake))
    disp('                     ...fixing...')
    Theta = thresholdIntervals(SmoothTheta, theta_thresh, 'Direction','Above');
    remThetaEpoch = and(Theta,REM_After_Wake);
    remThetaEpoch = mergeCloseIntervals(remThetaEpoch, minduration*5*1E4);
    tmean = mean(Data(Restrict(SmoothTheta,SleepEpochAcc)));% find averaged theta
    % get epoch below theta threshold
    noremThetaEpoch = thresholdIntervals(Restrict(SmoothTheta,REM_After_Wake), ...
        theta_thresh-(tmean/2), 'Direction','Below'); %2nd thresh
    remThetaEpoch = mergeCloseIntervals(remThetaEpoch-noremThetaEpoch, minduration*1E4);
    remThetaEpoch = dropShortIntervals(remThetaEpoch, minduration*1E4);
    
    %     SWSEpoch_old = SWSEpoch;
    REMEpochAcc = or((REMEpochAcc-REM_After_Wake),remThetaEpoch);
    %     % update wake
    %     newSWS = SWSEpoch_old-SWSEpoch;
    %     SWSEpoch = or(newSWS,SWSEpoch);
    clear REM_After_Wake bef_cell newSWS
    
    % update SleepEpoch for added bouts (with continuity)
    SleepEpochAcc = or(SleepEpochAcc,REMEpochAcc);
    %% SB addition for safety  - 07/06/2024
    
    SleepEpochAcc = CleanUpEpoch(SleepEpochAcc)
    REMEpochAcc = CleanUpEpoch(REMEpochAcc)
    
    
    % define SWS as sleep that is not REM
    disp('          ...redefining NREM after correction (NREM=Sleep-REM)')
    SWSEpochAcc = SleepEpochAcc-REMEpochAcc;
    
    disp('          ...redefining Wake after correction')
    % clean wake without noise
    WakeAcc = Epoch-SleepEpochAcc;
    
    % verification
    [~, bef_cell] = transEpoch(REMEpochAcc,WakeAcc);
    REM_After_Wake = bef_cell{1,2};
    disp('          -After fix-')
    disp(['          Number of REM epochs after wake:' num2str(length(Start(REM_After_Wake)))])
    
end

%% Sanity checks
% There should be no noise during sleep
[aft_cell,bef_cell] = transEpoch(TotalNoiseEpoch,SWSEpochAcc);
nsleep = and(aft_cell{1,2},bef_cell{1,2});
disp(strcat('          Noise periods during sleep: ',num2str(size(Start(nsleep)/1e4,1))))
if ~isempty(Start(REM_After_Wake))
    disp('          --------------------------------------------')
    disp('          Both should be at zero.')
    disp('          If not, visually check sleep scoring.')
    disp('          It can be due to epochs scored as sleep during a wake period (solution: lower threshold).')
    disp('          Helpful funtion: gui_sleepscoring_verif')
    disp('          ____________________________________________')
end
disp(' ')

disp('          ...clean noise epochs from stages')
disp(' ')

% modified SB 20/11/2018 according to decision made together
% epochs with noise still there
WakeWiNoiseAcc = or(Epoch,TotalNoiseEpoch)-SleepEpochAcc;
REMEpochWiNoiseAcc = REMEpochAcc;
SWSEpochWiNoiseAcc = SWSEpochAcc;

% epochs with no noise
REMEpochAcc = and(REMEpochAcc, Epoch);
SWSEpochAcc = and(SWSEpochAcc, Epoch);
WakeAcc = and(WakeAcc, Epoch);
end
