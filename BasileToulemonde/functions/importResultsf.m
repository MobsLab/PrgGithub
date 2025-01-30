% 1161
% resultsPath = '/media/mobs/DimaERC2/DataERC2/M1161'
% 1199
% resultsPath = '/media/mobs/DimaERC2/TEST1_Basile/TEST'
% nasResultsDecoding = '/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated/resultsDecoding'

% windowSizeMS = 200

function [TimeStepsPred,LinearTrue,LinearPred,TimeStepsPredPreSleep,TimeStepsPredPostSleep,LinearPredPreSleep,LinearPredPostSleep,LossPred, LossPredPreSleep,LossPredPostSleep,LossPredTsd, LossPredPreSleepTsd,LossPredPostSleepTsd,LinearTrueTsd, LinearPredTsd,LinearPredPreSleepTsd,LinearPredPostSleepTsd, XpredTsd, YpredTsd] = importResults(resultsPath,nasResultsDecoding,windowSizeMS)
    resultsPath_wake = strcat(resultsPath, '/results/', num2str(windowSizeMS));
    resultsPath_preSleep = strcat(resultsPath,'/results_Sleep/', num2str(windowSizeMS), '/PreSleep');
    resultsPath_postSleep = strcat(resultsPath,'/results_Sleep/', num2str(windowSizeMS), '/PostSleep');

    % Importing time steps of the decoding
    csvTimeStepsPred = readtable(strcat(resultsPath_wake, '/timeStepsPred.csv'));
    idxTimeStepsPred = csvTimeStepsPred{2:end,1};
    TimeStepsPred = csvTimeStepsPred{2:end,2};
    % Save in the results folder
    save(strcat(resultsPath_wake, '/timeStepsPred.mat'), 'idxTimeStepsPred', 'TimeStepsPred')
    load(strcat(resultsPath_wake, '/timeStepsPred.mat'))
    % Save in the nas
    save(strcat(nasResultsDecoding, '/timeStepsPred.mat'), 'idxTimeStepsPred', 'TimeStepsPred')

    % Importing true position
    csvLinearTrue = readtable(strcat(resultsPath_wake, '/linearTrue.csv'));
    idxLinearTrue = csvLinearTrue{2:end,1};
    LinearTrue=csvLinearTrue{2:end,2};
    save(strcat(resultsPath_wake, '/linearTrue.mat'), 'idxLinearTrue', 'LinearTrue')
    load(strcat(resultsPath_wake, '/linearTrue.mat'))
    save(strcat(nasResultsDecoding, '/linearTrue.mat'), 'idxLinearTrue', 'LinearTrue')

    % Importing linearized decoded position
    csvLinearPred = readtable(strcat(resultsPath_wake, '/linearPred.csv'));
    idxLinearPred = csvLinearPred{2:end,1};
    LinearPred=csvLinearPred{2:end,2};
    save(strcat(resultsPath_wake, '/linearPred.mat'), 'idxLinearPred', 'LinearPred')
    load(strcat(resultsPath_wake, '/linearPred.mat'))
    save(strcat(nasResultsDecoding, '/linearPred.mat'), 'idxLinearPred', 'LinearPred')

    % Importing time steps of the decoding during pre sleep
    csvTimeStepsPredPreSleep = readtable(strcat(resultsPath_preSleep, '/timeStepsPred.csv'));
    idxTimeStepsPredPreSleep = csvTimeStepsPredPreSleep{2:end,1};
    TimeStepsPredPreSleep = csvTimeStepsPredPreSleep{2:end,2};
    save(strcat(resultsPath_preSleep, '/timeStepsPredPreSleep.mat'), 'idxTimeStepsPredPreSleep', 'TimeStepsPredPreSleep')
    load(strcat(resultsPath_preSleep, '/timeStepsPredPreSleep.mat'))
    save(strcat(nasResultsDecoding, '/timeStepsPredPreSleep.mat'), 'idxTimeStepsPredPreSleep', 'TimeStepsPredPreSleep')

    % Importing time steps of the decoding during post sleep
    csvTimeStepsPredPostSleep = readtable(strcat(resultsPath_postSleep, '/timeStepsPred.csv'));
    idxTimeStepsPredPostSleep = csvTimeStepsPredPostSleep{2:end,1};
    TimeStepsPredPostSleep = csvTimeStepsPredPostSleep{2:end,2};
    save(strcat(resultsPath_postSleep, '/timeStepsPredPostSleep.mat'), 'idxTimeStepsPredPostSleep', 'TimeStepsPredPostSleep')
    load(strcat(resultsPath_postSleep, '/timeStepsPredPostSleep.mat'))
    save(strcat(nasResultsDecoding, '/timeStepsPredPostSleep.mat'), 'idxTimeStepsPredPostSleep', 'TimeStepsPredPostSleep')

    % Importing decoded position during pre sleep
    csvLinearPredPreSleep = readtable(strcat(resultsPath_preSleep, '/linearPred.csv'));
    idxLinearPredPreSleep = csvLinearPredPreSleep{2:end,1};
    LinearPredPreSleep=csvLinearPredPreSleep{2:end,2};
    save(strcat(resultsPath_preSleep, '/linearPredPreSleep.mat'), 'idxLinearPredPreSleep', 'LinearPredPreSleep')
    load(strcat(resultsPath_preSleep, '/linearPredPreSleep.mat'))
    save(strcat(nasResultsDecoding, '/linearPredPreSleep.mat'), 'idxLinearPredPreSleep', 'LinearPredPreSleep')

    % Importing decoded position during post sleep
    csvLinearPredPostSleep = readtable(strcat(resultsPath_postSleep, '/linearPred.csv'));
    idxLinearPredPostSleep = csvLinearPredPostSleep{2:end,1};
    LinearPredPostSleep=csvLinearPredPostSleep{2:end,2};
    save(strcat(resultsPath_postSleep, '/linearPredPostSleep.mat'), 'idxLinearPredPostSleep', 'LinearPredPostSleep')
    load(strcat(resultsPath_postSleep, '/linearPredPostSleep.mat'))
    save(strcat(nasResultsDecoding, '/linearPredPostSleep.mat'), 'idxLinearPredPostSleep', 'LinearPredPostSleep')

    % Importing predicted loss during wake
    csvLossPred = readtable(strcat(resultsPath_wake, '/lossPred.csv'));
    idxLossPred = csvLossPred{2:end,1};
    LossPred=csvLossPred{2:end,2};
    save(strcat(resultsPath_wake, '/lossPred.mat'), 'idxLossPred', 'LossPred')
    load(strcat(resultsPath_wake, '/lossPred.mat'))
    save(strcat(nasResultsDecoding, '/lossPred.mat'), 'idxLossPred', 'LossPred')
    
    % Importing predicted loss during pre sleep
    csvLossPredPreSleep = readtable(strcat(resultsPath_preSleep, '/lossPred.csv'));
    idxLossPredPreSleep = csvLossPredPreSleep{2:end,1};
    LossPredPreSleep=csvLossPredPreSleep{2:end,2};
    save(strcat(resultsPath_wake, '/lossPredPreSleep.mat'), 'idxLossPredPreSleep', 'LossPredPreSleep')
    load(strcat(resultsPath_wake, '/lossPredPreSleep.mat'))
    save(strcat(nasResultsDecoding, '/lossPredPreSleep.mat'), 'idxLossPredPreSleep', 'LossPredPreSleep')
    
    % Importing predicted loss during post sleep
    csvLossPredPostSleep = readtable(strcat(resultsPath_postSleep, '/lossPred.csv'));
    idxLossPredPostSleep = csvLossPredPostSleep{2:end,1};
    LossPredPostSleep=csvLossPredPostSleep{2:end,2};
    save(strcat(resultsPath_wake, '/lossPredPostSleep.mat'), 'idxLossPredPostSleep', 'LossPredPostSleep')
    load(strcat(resultsPath_wake, '/lossPredPostSleep.mat'))
    save(strcat(nasResultsDecoding, '/lossPredPostSleep.mat'), 'idxLossPredPostSleep', 'LossPredPostSleep')
    
    % Importing predicted X and Y
    csvFeaturePred = readtable(strcat(resultsPath_wake, '/featurePred.csv'));
    idxFeaturePred = csvFeaturePred{2:end,1};
    Xpred = csvFeaturePred{2:end,2};
    Ypred = csvFeaturePred{2:end,3};
    save(strcat(resultsPath_wake, '/featurePred.mat'), 'idxFeaturePred', 'Xpred', 'Ypred')
    load(strcat(resultsPath_wake, '/featurePred.mat'))
    save(strcat(nasResultsDecoding, '/featurePred.mat'), 'idxFeaturePred', 'Xpred', 'Ypred')


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


