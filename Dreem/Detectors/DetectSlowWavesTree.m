function SlowWaveEpochs=DetectSlowWavesTree(EEG,predictor)
%
%   SlowWaveEpochs=DetectSlowWaves_KJ(EEG,varargin)
%
% INPUT
%   EEG                 tsd: EEG signal
%   predictor           predictor (TreeBagger) used to classify
%
%
% OUTPUT
%   SlowWaveEpochs      intervalSet - Epochs detected
%
% SEE
%    FindSlowWaves DetectSlowWaves_KJ
%
%


%% CHECK INPUTS

if nargin < 1
  error('Incorrect number of parameters.');
end
if nargin==1
    load([FolderClinicPredictor 'predictor_05102017.mat']);
    predictor = big_rf;
end



%% Predetection
common_data=GetClinicCommonData();
params_so = common_data.predetect_so;
SlowWaveEpochs_predetect = FindSlowWaves(EEG, 'method','predetect','params', params_so);

start_predetect = Start(SlowWaveEpochs_predetect);
end_predetect = End(SlowWaveEpochs_predetect);


%% Random forest

% normalize
nb_points = 30;  % number of point in the interpolation
with_duration=1;  % one feature will be the the signal duration
func_uniformize = @(a) signalEpochNormalize(a, nb_points, with_duration);
tic
[norm_waveform, ~, ~] = functionOnEpochs(EEG, SlowWaveEpochs_predetect, func_uniformize, 'uniformoutput',false);
toc

%data to test
Xtest = cell2mat(norm_waveform)';
%prediction
Yfit = predict(predictor, Xtest);
Yfit = cellfun(@str2num, Yfit);

%result
SlowWaveEpochs = intervalSet(start_predetect(Yfit==1), end_predetect(Yfit==1));



end

