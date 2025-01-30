function SlowWavePoints = DetectSlowWavesTM(EEG, sample_times)
%
%   SlowWavePoints = DetectSlowWavesTM(EEG)
%
% INPUT
%   EEG                 tsd: EEG signal
%
%
% OUTPUT
%   SlowWavePoints      time point detected
%
% SEE
%    DetectHeartBeats DetectSlowWaves_KJ
%
%


%% CHECK INPUTS

if nargin < 2,
  error('Incorrect number of parameters.');
end


%params
template_duration = 500;
slowwave_thresh_std = 2;
snip_duration = 5; %s
min_sw_separation = 0.2; % ms, so heart rate cannot be above 5Hz


%% create template
[MR,~] = PlotRipRaw(EEG, sample_times'/1E4, template_duration,0,0);
Template = MR(:,2);
ConvSig = tsd(Range(EEG), conv(Data(EEG),Template,'same') .* conv(Data(EEG), Template, 'same'));


%% find match
NumSnips = ceil(max(Range(EEG,'s'))/snip_duration);
Times=[]; Vals=[];

for i=1:NumSnips
    LocEpoch = intervalSet((i-1)*snip_duration*1e4, (i)*snip_duration*1e4);
    LocalSigConv = Restrict(ConvSig, LocEpoch);
    LocalSig = Restrict(EEG,LocEpoch);
    if ~isempty(Data(LocalSigConv))
        x_data = Range(LocalSigConv);
        y_data = Data(LocalSig);
        xmx = findpeaks(Data(LocalSigConv),std(Data(LocalSigConv))*slowwave_thresh_std);
        xmx.loc = xmx.loc(y_data(xmx.loc)>std(y_data)*slowwave_thresh_std);
        Times = [Times;x_data(xmx.loc)];
        Vals = [Vals;y_data(xmx.loc)];
    end
end


%% Get rid of too close peaks
TimeDiff = diff(Times);
problem_points = find(TimeDiff<min_sw_separation*1e4);
while ~isempty(problem_points)
    ToExclude = [];
    for k=1:length(problem_points)
        ToCompare = [Vals(problem_points(k)),Vals(problem_points(k)+1)];
        [~, idx] = min(ToCompare);
        ToExclude(k) = problem_points(k)+idx-1;
    end
    Times(ToExclude) = [];
    Vals(ToExclude) = [];
    TimeDiff = diff(Times);
    problem_points = find(TimeDiff<min_sw_separation*1e4);
end


%% results
SlowWavePoints = Times;


end






