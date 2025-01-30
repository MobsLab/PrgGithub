function GenerateDeltaGL(Epoch)

% inputs:
% res (optional) = path

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZATION
erasePreviousAnalysis=0;
keyboardIfProblem=0;

    res=pwd;



disp(' ')
disp([res,'/StateEpochSB.mat'])

try
    Epoch;
catch
tempLoad=load([res,'/StateEpochSB.mat'],'SWSEpoch');
Epoch=tempLoad.SWSEpoch;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIND DELTA WAVES
disp(' ')
disp('   ________ FIND DELTA WAVES ________ ')

% ------------------ Parietal Cortex --------------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/DeltaPaCx.mat'],'tDelta');
    tempLoad.tDelta;
    tempLoad.DeltaEpoch;
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp(' ')
        disp('DeltaPaCx.mat already exists... skipping...')
        disp(' ')
    end
catch

    disp('detecting DeltaPaCx...')
    try
        cd(res)
        [tDelta,DeltaEpoch]=FindDeltaWavesChanGL('PaCx',Epoch);

        save([res,'/newDeltaPaCx.mat'],'tDelta','DeltaEpoch')
        clear tDelta 
        disp(' ')
        disp('   -> Done')
        disp(' ')
    catch
        disp(' ')
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
        disp(' ')
    end
end

% ------------------ Prefrontal Cortex ------------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/DeltaPFCx.mat'],'tDelta');
    tempLoad.tDelta;
    tempLoad.DeltaEpoch;
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp(' ')
        disp('newDeltaPFCx.mat already exists... skipping...')
        disp(' ')
    end
catch

    disp('detecting DeltaPFCx...')
    try
        cd(res)
         [tDelta,DeltaEpoch]=FindDeltaWavesChanGL('PFCx',Epoch);

        save([res,'/newDeltaPFCx.mat'],'tDelta','DeltaEpoch')
        clear tDelta 
        disp(' ')
        disp('   -> Done')
        disp(' ')
    catch
        disp(' ')
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
        disp(' ')
    end
end

% ------------------ Motor Cortex ------------------------------------
try
    clear tempLoad
    tempLoad=load([res,'/DeltaMoCx.mat'],'tDelta');
    tempLoad.tDelta;
    tempLoad.DeltaEpoch;
    clear tempLoad
    if erasePreviousAnalysis
        error;
    else
        disp(' ')
        disp('DeltaMoCx.mat already exists... skipping...')
        disp(' ')
    end
catch

    disp('detecting DeltaMoCx...')
    try
        cd(res)
        [tDelta,DeltaEpoch]=FindDeltaWavesChanGL('MoCx',Epoch);

        save([res,'/newDeltaMoCx.mat'],'tDelta','DeltaEpoch')
        clear tDelta DeltaEpoch
        disp(' ')
        disp('   -> Done')
        disp(' ')
    catch
        disp(' ')
        disp('   -> problem'); if keyboardIfProblem, keyboard;end
        disp(' ')
    end
end