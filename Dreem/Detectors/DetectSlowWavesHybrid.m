function SlowWaveEpochs=DetectSlowWavesHybrid(EEG,N3)
%
%   SlowWaveEpochs=DetectSlowWaves_KJ(EEG,varargin)
%
% INPUT
%   EEG                 tsd: EEG signal
%   N3                  intervalSet: N3 period
%
%
% OUTPUT
%   SlowWaveEpochs      intervalSet - Epochs detected
%
% SEE
%    FindSlowWaves DetectSlowWaves_KJ DetectSlowWavesTree 
%
%

%% CHECK INPUTS

if nargin < 1,
  error('Incorrect number of parameters.');
end



%% Predetection
common_data=GetClinicCommonData();
params_so = common_data.predetect_so;
SlowWaveEpochs_predetect = FindSlowWaves(EEG, 'method','predetect','params', params_so);

start_predetect = Start(SlowWaveEpochs_predetect);
end_predetect = End(SlowWaveEpochs_predetect);


%% Detection

%Classic detection
SlowWaveEpochs_classic = FindSlowWaves(EEG);
[~, sw_classic_times] = extremumEpochs(EEG, SlowWaveEpochs_classic, 0); %minima of epochs


%Random forest
SlowWaveEpochs_tree = DetectSlowWavesTree(EEG);
[~, sw_rf_times] = extremumEpochs(EEG, SlowWaveEpochs_tree, 0); %minima of epochs 


%threshold detection
threshold_sw = 2.5 * std(Data(Restrict(EEG,N3)));
inteval_detected = thresholdIntervals(EEG, -threshold_sw, 'Direction','Below');
[~, sw_thres_times] = extremumEpochs(EEG, inteval_detected, 0); %minima of epochs



%% UNION
all_detection = sort([sw_classic_times sw_rf_times sw_thres_times]);
[~,interval,~] = InIntervals(all_detection, [start_predetect end_predetect]);
good_intervals = unique(interval);
good_intervals(good_intervals==0)=[];

intv = [start_predetect end_predetect];
SlowWaveEpochs_union = intv(good_intervals,:);
SlowWaveEpochs = intervalSet(SlowWaveEpochs_union(:,1), SlowWaveEpochs_union(:,2));



end
