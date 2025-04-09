function StructOutput = GetBehavParams(Dir, varargin)
%GETBEHAVPARAMS Extracts behavioral parameters from input data.
%   This function is designed to process and extract specific behavioral
%   parameters from the provided input data.
%
%   Inputs:
%       Dir: A structure containing paths to data directories.
%            - Dir.path: Cell array of strings specifying paths to data folders for each mouse.
%            - Dir.results: Cell array of strings specifying paths to results folders for each mouse.

%           - Additional fields for each parameter, containing mean values and restricted time series data for different states.
%            - 'params': Cell array of strings specifying parameters to extract (default: {'speed', 'X', 'Y'}).
%            - 'restrict': Boolean or string specifying whether to restrict epochs (default: false).
%            - 'resultsFolder': String specifying the folder name for results (default: 'Current_Results').
%            - 'windowSize': Numeric value specifying the window size for analysis (default: 180).
%            - 'isSleep': Logical flag indicating whether to process sleep data (default: false).
%
%   Outputs:
%       StructOutput: A structure containing the extracted behavioral parameters.
%           - speed: A time series object (tsd) representing the smoothed speed.
%           - LinearPred: A time series object (tsd) of linear predictions.
%           - LossPred: A time series object (tsd) of corrected loss predictions.
%           - LinearTrue: A time series object (tsd) of true linear values.
%           - X: A time series object (tsd) of X-coordinates.
%           - Y: A time series object (tsd) of Y-coordinates.
%           - linearPos: A placeholder for linear position data (to be implemented).%
%   Example:
%       % Example usage of the GetBehavParams function
%       result = GetBehavParams(inputData);
%
%   See also:
% MeanPhysioParameters, MeanValuesPhysiologicalParameters_BM

p = inputParser;
defaultParams = {'speed', 'X', 'Y'};
addOptional(p, 'params', defaultParams, @iscell);
addOptional(p, 'restrict', false, @(x) islogical(x) || ischar(x));
addOptional(p, 'resultsFolder', 'Current_Results', @ischar);
addOptional(p, 'windowSize', 180, @isnumeric);
addOptional(p, 'isSleep', false, @islogical);

parse(p, varargin{:});
params = p.Results.params;
restrict = p.Results.restrict;
resultsFolder = p.Results.resultsFolder;
windowSize = p.Results.windowSize;
for mouse = 1:length(Dir.path)
    load(fullfile(Dir.path{mouse}{1},  'SleepScoring_OBGamma.mat'), 'TotalNoiseEpoch')
    load(fullfile(Dir.path{mouse}{1},  'behavResources.mat'), 'StimEpoch', 'SessionEpoch', 'FreezeAccEpoch', 'ZoneEpoch')
    load(fullfile(Dir.path{mouse}{1},  'LFPData/LFP0.mat'))

    NoisyEpoch = or(TotalNoiseEpoch , StimEpoch);
    Epoch{mouse,1} = intervalSet(0,max( Range(LFP)))-NoisyEpoch; % total
    St = Stop(StimEpoch);
    Epoch{mouse,2} = intervalSet(St,St+1e4); % after stim
    Epoch{mouse,3} = FreezeAccEpoch; % fz
    Epoch{mouse,4} = Epoch{mouse,1} - Epoch{mouse,3}; % active
    Epoch{mouse,5}=and(Epoch{mouse,3} , ZoneEpoch.Shock);
    Epoch{mouse,6}=and(Epoch{mouse,3} , or(or(ZoneEpoch.NoShock , ZoneEpoch.FarNoShock) , ZoneEpoch.CentreNoShock));
    Epoch{mouse,7}=and(Epoch{mouse,4} , ZoneEpoch.Shock);
    Epoch{mouse,8}=and(Epoch{mouse,4} , or(or(ZoneEpoch.NoShock , ZoneEpoch.FarNoShock) , ZoneEpoch.CentreNoShock));
    basePath = Dir.path{1}{1};

    NameEpoch{1}='Total';
    NameEpoch{2}='After_stim';
    NameEpoch{3}='Freezing';
    NameEpoch{4}='Active';
    NameEpoch{5}='Freezing_shock';
    NameEpoch{6}='Freezing_safe';
    NameEpoch{7}='Active_shock';
    NameEpoch{8}='Active_safe';

    if restrict
        if ischar(restrict)
            for e = 1:length(Epoch)
                Epoch{mouse,e} = Restrict(Epoch{mouse,e}, SessionEpoch.(restrict));
            end
        elseif class(restrict) == 'intervalSet'
            for e = 1:length(Epoch)
                Epoch{mouse,e} = Restrict(Epoch{mouse,e},restrict);
            end
        else
            error('restrict must be a string corresponding to a valid SessionEpoch field or a proper intervalSet.');
        end
    end

    if any(contains(lower(params),'true')) | any(contains(lower(params),'pred')) | any(contains(lower(params),'proj'))
        warning('Loading ANN data with following settings: %s', strjoin([resultsFolder, windowSize], ', '));
        csvTimeStepsPred = loadParameterData(basePath, resultsFolder, windowSize, 'timeStepsPred.csv', false, '');
        idxTimeStepsPred = csvTimeStepsPred(2:end,1);
        TimeStepsPred = csvTimeStepsPred(2:end,2);
        if any(contains(lower(params),'sleep'))
            warning('Loading ANN data with following settings: %s', strjoin([resultsFolder, windowSize], ', '));
            csvTimeStepsPredSleep = loadParameterData(basePath, resultsFolder, windowSize, 'timeStepsPred.csv', true);
            TimeStepsPredSleep = csvTimeStepsPredSleep(2:end,2);
    end
    end

    % Replace the original block with a call to the helper function
    [hab, testPre, cond, testPost, extinct, tot, sleep] = defineSessionEpochs(SessionEpoch);

    % Initialize StructOutput
    StructOutput = struct();
    for i = 1:length(params)
        clear OutputTsd
        if ischar(params{i})
            switch(lower(params{i}))
                case 'speed'
                    OutPutVar = load([Dir.path{mouse}{1}  'behavResources.mat'],'Vtsd');
                    OutputTsd = Vtsd;

                case 'linearpred'
                    csvLinearPred = loadParameterData(basePath, resultsFolder, windowSize, 'linearPred.csv', false, '');
                    LinearPred = csvLinearPred(2:end,2);
                    OutputTsd = tsd(TimeStepsPred * 1E4, LinearPred);

                case 'losspred'
                    csvLossPred = loadParameterData(basePath, resultsFolder, windowSize, 'lossPred.csv', false, '');
                    LossPred = csvLossPred(2:end,2);
                    OutputTsd = tsd(TimeStepsPred * 1E4, LossPred);

                case 'linearpredsleep'
                    csvLinearPredSleep = loadParameterData(basePath, resultsFolder, windowSize, 'linearPred.csv', true);
                    LinearPredSleep = csvLinearPredSleep(2:end,2);
                    OutputTsd = tsd(TimeStepsPredSleep * 1E4, LinearPredSleep);

                case 'losspredsleep'
                    csvLossPredSleep = loadParameterData(basePath, resultsFolder, windowSize, 'lossPred.csv', true);
                    LossPredSleep = csvLossPredSleep(2:end,2);
                    OutputTsd = tsd(TimeStepsPredSleep * 1E4, LossPredSleep);

                case 'lineartrue'
                    csvLinearTrue = loadParameterData(basePath, resultsFolder, windowSize, 'linearTrue.csv', false, '');
                    LinearTrue = csvLinearTrue(2:end,2);
                    OutputTsd = tsd(TimeStepsPred * 1E4, LinearTrue);
                
                case 'lineardist'
                    OutPutVar = load([Dir.path{mouse}{1}  'behavResources.mat'],'LinearDist');
                    OutputTsd = OutPutVar.LinearDist;

                case 'X'
                    try
                        OutPutVar = load([Dir.path{mouse}{1}  'behavResources.mat'],'AlignedXtsd');
                        OutputTsd = OutputVar.AlignedXtsd;
                    catch
                        OutPutVar = load([Dir.path{mouse}{1}  'behavResources.mat'],'Xtsd');
                        OutputTsd = OutputVar.Xtsd;
                    end

                case 'Y'
                    try 
                        OutPutVar = load([Dir.path{mouse}{1}  'behavResources.mat'],'AlignedYtsd');
                        OutputTsd = OutputVar.AlignedYtsd;
                    catch
                        OutPutVar = load([Dir.path{mouse}{1}  'behavResources.mat'],'Ytsd');
                        OutputTsd = OutputVar.Ytsd;
                    end

                case 'stim'
                    OutputVar = load([Dir.path{mouse}{1}  'behavResources.mat'],'StimEpoch');
                    OutputTsd=ts(Start(StimEpoch));
                
                case 'ripep'
                    try 
                        OutputVar = load([Dir.path{mouse}{1}  'SWR.mat'],'tRipples');
                        tRipples = OutputVar.Ripples;
                        RipEp=intervalSet(Range(tRipples)-0.2*1E4,Range(tRipples)+0.2*1E4);
                        OutputTsd=mergeCloseIntervals(RipEp,1);
                    catch
                        OutputTsd = tsd([], []);
                    end

                case 'heartrate'
                    try
                        OutputVar = load([Dir.path{mouse}{1}  'HeartBeatInfo.mat']);
                        OutputTsd = OutputVar.EKG.HBRate;
                    catch
                        OutputTsd = tsd([],[]);
                    end

                otherwise
                    warning(['Parameter ', params{i}, ' is not recognized.']);
            end
        end
        for states = 1:8
            try
                StructOutput.(params{i}).mean(mouse, states, :) = nanmean(Data(Restrict(OutputTsd, Epoch{mouse, states})));
                StructOutput.(params{i}).tsd{mouse, states} = Restrict(OutputTsd, Epoch{mouse, states});
            catch
            end
        end
    end
    disp(Dir.name{mouse})
end
end

% Refactor repetitive parameter loading into a helper function
function data = loadParameterData(basePath, resultsFolder, windowSize, fileName, isSleep)
    sleepFolder = 'results_Sleep';
filePath = [basePath '/' resultsFolder '/results/' num2str(windowSize) '/' fileName];
if isSleep
    filePath = [basePath '/' resultsFolder '/' sleepFolder '/' num2str(windowSize) '/PostSleep/' fileName];
end
if endsWith(fileName, '.csv')
    data = readmatrix(filePath);
else
    data = readtable(filePath);
end
end


% Refactor repetitive code for session epoch definitions into a helper function
function [hab, testPre, cond, testPost, extinct, tot, sleep] = defineSessionEpochs(SessionEpoch)
sleep= 0;
try
    hab = or(SessionEpoch.Hab1, SessionEpoch.Hab2);
catch
    hab = SessionEpoch.Hab;
end

try
    testPre = or(or(SessionEpoch.Hab1, SessionEpoch.Hab2), or(or(SessionEpoch.TestPre1, SessionEpoch.TestPre2), or(SessionEpoch.TestPre3, SessionEpoch.TestPre4)));
catch
    testPre = or(SessionEpoch.Hab, or(or(SessionEpoch.TestPre1, SessionEpoch.TestPre2), or(SessionEpoch.TestPre3, SessionEpoch.TestPre4)));
end

cond = or(or(SessionEpoch.Cond1, SessionEpoch.Cond2), or(SessionEpoch.Cond3, SessionEpoch.Cond4));

try
    testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
catch
    testPost = or(SessionEpoch.TestPost1, SessionEpoch.TestPost2);
end

try
    extinct = SessionEpoch.Extinct;
catch
    extinct = SessionEpoch.Extinction;
end

if exist('SessionEpoch.PreSleep', 'var') && exist('SessionEpoch.PostSleep', 'var')
    preSleep = SessionEpoch.PreSleep;
    postSleep = SessionEpoch.PostSleep;
    sleep = or(preSleep, postSleep);
end
try
    tot = or(or(hab, or(testPre, or(testPost, or(cond, extinct)))), sleep);
catch
    disp('no sleep session');
    tot = or(or(hab, or(testPre, or(testPost, cond))), sleep);
end
end