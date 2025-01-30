hm = getenv('HOME');


parent_dir = '/media/sdb1/Data'

cd(parent_dir);


datasets = List2Cell([ parent_dir filesep 'datasets_general.list' ] );
%  datasets = List2Cell([ parent_dir filesep 'datasets_test.list' ] );
%  datasets = List2Cell([ parent_dir filesep 'datasets_rat19.list' ] );

%  datasets= {'Rat20/200110'};

A = Analysis(parent_dir);



%
%  A = run(A, 'PositionResources', datasets, 'PositionResources', 'DoDebug',1);

% A = run(A, 'SpectrumTrial', datasets, 'SpectrumTrial', 'DoDebug', 1);
A = run(A, 'PfcHcEEGTraces', datasets, 'PfcHcEEGTraces', 'DoDebug', 0);
%A = run(A, 'PfcHcCohgramGlobal', datasets, 'PfcHcCohgramGlobal', 'DoDebug', 1);
%A = run(A, 'PfcHcTrigCohgram2', datasets, 'PfcHcTrigCohgram2', 'DoDebug',
%1);  DON"T RUN IT"S WRONG!!!
%A = run(A, 'PfcHcCohgramByTrial', datasets, 'PfcHcTrigCohgramByTrial', 'DoDebug', 1);

 %A = run(A, 'PostRewardTimes', datasets, 'PostRewardTimes', 'DoDebug', 1);
 % A = run(A, 'PfcHcCohgramByPostTrial', datasets, 'PfcHcCohgramByPostTrial', 'DoDebug', 1);
%  A = run(A, 'PfcHcSpecgramGlobal', datasets, 'PfcHcSpecgramGlobal', 'DoDebug', 1);
%A = run(A, 'DisplayCohgram', datasets, 'DisplayCohgram', 'DoDebug', 1);
% A = run(A, 'computeBinnedVelocity', datasets, 'computeBinnedVelocity', 'DoDebug', 1);
%A = run(A, 'PfcHcSpecgramTrials', datasets, 'PfcHcSpecgramTrials', 'DoDebug', 1);
%A = run(A, 'HcPfcPowerCorrelation', datasets, 'HcPfcPowerCorrelation', 'DoDebug', 1);
%A = run(A, 'DisplaySpeedThetaCoh', datasets, 'DisplaySpeedThetaCoh', 'DoDebug', 1);
%
% A = run(A, 'SpectrumTrial2', datasets, 'SpectrumTrial2', 'DoDebug', 1);
% A = run(A, 'ShowSpectrumTrial', datasets, 'ShowSpectrumTrial', 'DoDebug', 1);
%  A = run(A, 'makeSpikeData', datasets, 'SpikeData', 'DoDebug', 1);
%  A = run(A, 'behaviorResources', datasets, 'behavResources', 'DoDebug', 1,'Overwrite',1);
%  A = run(A, 'basicPETH', datasets, 'basicPETH', 'DoDebug', 1);
% A = run(A, 'correctErrorPrevTrialPETH', datasets, 'correctErrorPrevTrialPETH', 'DoDebug', 1);
%   A = run(A, 'correctErrorPETH', datasets, 'correctErrorPETH', 'DoDebug', 1);
%   A = run(A, 'goLightDarkPETH', datasets, 'goLightDarkPETH', 'DoDebug', 1);
%  A = run(A, 'leftrightPETH', datasets, 'leftrightPETH', 'DoDebug', 1);

%  A = run(A, 'behavEpochs', datasets, 'behavEpochs', 'DoDebug', 0,'Overwrite',1);
%A = run(A, 'scatterPlaceFields', datasets, 'scatterPlaceFields', 'DoDebug', 1);
%  A = run(A, 'SleepSpecgramGlobal', datasets, 'SleepSpecgramGlobal', 'DoDebug', 0);
%  A = run(A, 'findDeltaEpochs', datasets, 'findDeltaEpochs', 'DoDebug', 0);
%A = run(A, 'basicFiringStats', datasets, 'basicFiringStats', 'DoDebug', 1);
%A = run(A, 'LPPAReactRate', datasets, 'LPPAReactRate', 'DoDebug', 1);
%A = run(A, 'LPPAReactRateDelta', datasets, 'LPPAReactRateDelta',
%'DoDebug', 1);
%	<A = run(A, 'ReactRPairsLPPA', datasets, 'ReactRPairsLPPA', 'DoDebug', 1);
%A = run(A, 'LPPAReactRateBinned', datasets, 'LPPAReactRateBinned', 'DoDebug', 1);

%A = run(A, 'LPPAIntervalFiringRates', datasets, 'LPPAIntervalFiringRates', 'DoDebug', 1);
%  A = run(A, 'LPPACorrCoef', datasets, 'LPPAIntervalFiringRates', 'DoDebug', 1);

%   A = run(A, 'binnedFiringRateEpochs', datasets, 'binnedFiringRate', 'DoDebug', 1, 'Overwrite',1);
%     A = run(A, 'Paircov', datasets, 'PairCov', 'DoDebug', 1, 'Overwrite',1);
%  %     A = run(A, 'ValidCells', datasets, 'ValidCells', 'DoDebug', 1, 'Overwrite',0);
%   A = run(A, 'JointCorrSpw', datasets, 'JointCorrSpw_PCA', 'DoDebug', 1, 'Overwrite',1);
%     A = run(A, 'ratesContrast', datasets, 'RatesContrast', 'DoDebug', 1, 'Overwrite',1);
%     A = run(A, 'contrastVectors', datasets, 'ContrastVectors', 'DoDebug', 1, 'Overwrite',1);
%    A = run(A, 'DefineExpRules', datasets, 'DefineExpRules', 'DoDebug', 1, 'Overwrite',1);
%     A = run(A, 'DefCorrectError', datasets, 'DefCorrectError', 'DoDebug', 1, 'Overwrite',1);
%       A = run(A, 'firingRatesByInterval', datasets, 'firingRatesByInterval', 'DoDebug', 1, 'Overwrite',1);
%       A = run(A, 'behavReport', datasets, 'behavReport', 'DoDebug', 1, 'Overwrite',1);
%       A = run(A, 'PCAreact', datasets, 'PCAreact', 'DoDebug', 1, 'Overwrite',1);

%         A = run(A, 'FindDownStates', datasets, 'FindDownStates', 'DoDebug', 1, 'Overwrite',1);
%         A = run(A, 'RipplesRaster', datasets, 'RippelsRaster', 'DoDebug', 1, 'Overwrite',1);
%         A = run(A, 'SpwTrigReactDiff', datasets, 'SpwTrigReactDiff', 'DoDebug', 1, 'Overwrite',1);

%         A = run(A, 'globalSleepReactivation', datasets, 'globalSleepReactivation', 'DoDebug', 1, 'Overwrite',1);

%   A = run(A, 'FindRecordRipples', datasets, 'FindRecordRipples', 'DoDebug', 0, 'Overwrite',1);
%     A = run(A, 'EEGSelection', datasets, 'EEGSelection', 'DoDebug', 1, 'Overwrite',1);
%     A = run(A, 'SPWReactPCA', datasets, 'SPWReactPCA', 'DoDebug', 1, 'Overwrite',1);
%     A = run(A, 'PCMazeSign', datasets, 'PCMazeSign', 'DoDebug', 1, 'Overwrite',1);
%     A = run(A, 'ReactTimeCourse', datasets, 'ReactTimeCourse', 'DoDebug', 0, 'Overwrite',1);
%     A = run(A, 'ReactTimeCoursePCA', datasets, 'ReactTimeCoursePCA', 'DoDebug', 0, 'Overwrite',1);
%     A = run(A, 'ReactTimeCourse2', datasets, 'ReactTimeCourse2', 'DoDebug', 0, 'Overwrite',1);

