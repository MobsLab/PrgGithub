% 1161
% resultsPath = '/media/mobs/DimaERC2/DataERC2/M1161'
% 1199
% resultsPath = '/media/mobs/DimaERC2/TEST1_Basile/TEST'
% nasResultsDecoding = '/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/resultsDecoding'

% resultsPath = '/media/mickey/DataMOBS210/DimaERC2/neuroencoders_1021/_work/M994_PAG/'
% windowSizeMS = 108

function [TimeStepsPred,LinearTrue,LinearPred,TimeStepsPredPreSleep,...
    TimeStepsPredPostSleep,LinearPredPreSleep,LinearPredPostSleep,LossPred, LossPredPreSleep,LossPredPostSleep,...
    LossPredTsd, LossPredPreSleepTsd,LossPredPostSleepTsd,LinearTrueTsd, LinearPredTsd,LinearPredPreSleepTsd,...
    LinearPredPostSleepTsd, XpredTsd, YpredTsd] = importResults(resultsPath,nasResultsDecoding,windowSizeMS)
    
    resultsPath_wake = fullfile(resultsPath, '/results/', num2str(windowSizeMS));
    resultsPath_preSleep = fullfile(resultsPath,'/results_Sleep/', num2str(windowSizeMS), '/PreSleep');
    resultsPath_postSleep = fullfile(resultsPath,'/results_Sleep/', num2str(windowSizeMS), '/PostSleep');

    % Importing time steps of the decoding
    csvTimeStepsPred = readtable(fullfile(resultsPath_wake, '/timeStepsPred.csv'));
    idxTimeStepsPred = csvTimeStepsPred{2:end,1};
    TimeStepsPred = csvTimeStepsPred{2:end,2};
    % Save in the results folder
    save(fullfile(resultsPath_wake, '/timeStepsPred.mat'), 'idxTimeStepsPred', 'TimeStepsPred')
    load(fullfile(resultsPath_wake, '/timeStepsPred.mat'))
    % Save in the nas
    save(fullfile(nasResultsDecoding, '/timeStepsPred.mat'), 'idxTimeStepsPred', 'TimeStepsPred')

    % Importing true position
    csvLinearTrue = readtable(fullfile(resultsPath_wake, '/linearTrue.csv'));
    idxLinearTrue = csvLinearTrue{2:end,1};
    LinearTrue=csvLinearTrue{2:end,2};
    save(fullfile(resultsPath_wake, '/linearTrue.mat'), 'idxLinearTrue', 'LinearTrue')
    load(fullfile(resultsPath_wake, '/linearTrue.mat'))
    save(fullfile(nasResultsDecoding, '/linearTrue.mat'), 'idxLinearTrue', 'LinearTrue')

    % Importing linearized decoded position
    csvLinearPred = readtable(fullfile(resultsPath_wake, '/linearPred.csv'));
    idxLinearPred = csvLinearPred{2:end,1};
    LinearPred=csvLinearPred{2:end,2};
    save(fullfile(resultsPath_wake, '/linearPred.mat'), 'idxLinearPred', 'LinearPred')
    load(fullfile(resultsPath_wake, '/linearPred.mat'))
    save(fullfile(nasResultsDecoding, '/linearPred.mat'), 'idxLinearPred', 'LinearPred')

    % Importing time steps of the decoding during pre sleep
    csvTimeStepsPredPreSleep = readtable(fullfile(resultsPath_preSleep, '/timeStepsPred.csv'));
    idxTimeStepsPredPreSleep = csvTimeStepsPredPreSleep{2:end,1};
    TimeStepsPredPreSleep = csvTimeStepsPredPreSleep{2:end,2};
    save(fullfile(resultsPath_preSleep, '/timeStepsPredPreSleep.mat'), 'idxTimeStepsPredPreSleep', 'TimeStepsPredPreSleep')
    load(fullfile(resultsPath_preSleep, '/timeStepsPredPreSleep.mat'))
    save(fullfile(nasResultsDecoding, '/timeStepsPredPreSleep.mat'), 'idxTimeStepsPredPreSleep', 'TimeStepsPredPreSleep')

    % Importing time steps of the decoding during post sleep
    csvTimeStepsPredPostSleep = readtable(fullfile(resultsPath_postSleep, '/timeStepsPred.csv'));
    idxTimeStepsPredPostSleep = csvTimeStepsPredPostSleep{2:end,1};
    TimeStepsPredPostSleep = csvTimeStepsPredPostSleep{2:end,2};
    save(fullfile(resultsPath_postSleep, '/timeStepsPredPostSleep.mat'), 'idxTimeStepsPredPostSleep', 'TimeStepsPredPostSleep')
    load(fullfile(resultsPath_postSleep, '/timeStepsPredPostSleep.mat'))
    save(fullfile(nasResultsDecoding, '/timeStepsPredPostSleep.mat'), 'idxTimeStepsPredPostSleep', 'TimeStepsPredPostSleep')

    % Importing decoded position during pre sleep
    csvLinearPredPreSleep = readtable(fullfile(resultsPath_preSleep, '/linearPred.csv'));
    idxLinearPredPreSleep = csvLinearPredPreSleep{2:end,1};
    LinearPredPreSleep=csvLinearPredPreSleep{2:end,2};
    save(fullfile(resultsPath_preSleep, '/linearPredPreSleep.mat'), 'idxLinearPredPreSleep', 'LinearPredPreSleep')
    load(fullfile(resultsPath_preSleep, '/linearPredPreSleep.mat'))
    save(fullfile(nasResultsDecoding, '/linearPredPreSleep.mat'), 'idxLinearPredPreSleep', 'LinearPredPreSleep')

    % Importing decoded position during post sleep
    csvLinearPredPostSleep = readtable(fullfile(resultsPath_postSleep, '/linearPred.csv'));
    idxLinearPredPostSleep = csvLinearPredPostSleep{2:end,1};
    LinearPredPostSleep=csvLinearPredPostSleep{2:end,2};
    save(fullfile(resultsPath_postSleep, '/linearPredPostSleep.mat'), 'idxLinearPredPostSleep', 'LinearPredPostSleep')
    load(fullfile(resultsPath_postSleep, '/linearPredPostSleep.mat'))
    save(fullfile(nasResultsDecoding, '/linearPredPostSleep.mat'), 'idxLinearPredPostSleep', 'LinearPredPostSleep')

    % Importing predicted loss during wake
    csvLossPred = readtable(fullfile(resultsPath_wake, '/lossPred.csv'));
    idxLossPred = csvLossPred{2:end,1};
    LossPred=csvLossPred{2:end,2};
    save(fullfile(resultsPath_wake, '/lossPred.mat'), 'idxLossPred', 'LossPred')
    load(fullfile(resultsPath_wake, '/lossPred.mat'))
    save(fullfile(nasResultsDecoding, '/lossPred.mat'), 'idxLossPred', 'LossPred')
    
    % Importing predicted loss during pre sleep
    csvLossPredPreSleep = readtable(fullfile(resultsPath_preSleep, '/lossPred.csv'));
    idxLossPredPreSleep = csvLossPredPreSleep{2:end,1};
    LossPredPreSleep=csvLossPredPreSleep{2:end,2};
    save(fullfile(resultsPath_wake, '/lossPredPreSleep.mat'), 'idxLossPredPreSleep', 'LossPredPreSleep')
    load(fullfile(resultsPath_wake, '/lossPredPreSleep.mat'))
    save(fullfile(nasResultsDecoding, '/lossPredPreSleep.mat'), 'idxLossPredPreSleep', 'LossPredPreSleep')
    
    % Importing predicted loss during post sleep
    csvLossPredPostSleep = readtable(fullfile(resultsPath_postSleep, '/lossPred.csv'));
    idxLossPredPostSleep = csvLossPredPostSleep{2:end,1};
    LossPredPostSleep=csvLossPredPostSleep{2:end,2};
    save(fullfile(resultsPath_wake, '/lossPredPostSleep.mat'), 'idxLossPredPostSleep', 'LossPredPostSleep')
    load(fullfile(resultsPath_wake, '/lossPredPostSleep.mat'))
    save(fullfile(nasResultsDecoding, '/lossPredPostSleep.mat'), 'idxLossPredPostSleep', 'LossPredPostSleep')
    
    % Importing predicted X and Y
    csvFeaturePred = readtable(fullfile(resultsPath_wake, '/featurePred.csv'));
    idxFeaturePred = csvFeaturePred{2:end,1};
    Xpred = csvFeaturePred{2:end,2};
    Ypred = csvFeaturePred{2:end,3};
    save(fullfile(resultsPath_wake, '/featurePred.mat'), 'idxFeaturePred', 'Xpred', 'Ypred')
    load(fullfile(resultsPath_wake, '/featurePred.mat'))
    save(fullfile(nasResultsDecoding, '/featurePred.mat'), 'idxFeaturePred', 'Xpred', 'Ypred')


    LossPredTsd=tsd(TimeStepsPred*1E4,LossPred);
    LossPredPreSleepTsd=tsd(TimeStepsPredPreSleep*1E4,LossPredPreSleep);
    LossPredPostSleepTsd=tsd(TimeStepsPredPostSleep*1E4,LossPredPostSleep);
    LinearTrueTsd=tsd(TimeStepsPred*1E4,LinearTrue);
    LinearPredTsd=tsd(TimeStepsPred*1E4,LinearPred);
    LinearPredPreSleepTsd=tsd(TimeStepsPredPreSleep*1E4,LinearPredPreSleep);
    LinearPredPostSleepTsd=tsd(TimeStepsPredPostSleep*1E4,LinearPredPostSleep);
    XpredTsd=tsd(TimeStepsPred*1E4,Xpred);
    YpredTsd=tsd(TimeStepsPred*1E4,Ypred);
end


