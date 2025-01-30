function [stimulations, StageEpochs] = GetStimHypnoDreem(filename,varargin)
%
%    [stimulations, StageEpochs] = GetStimHypnoDreem(filename,varargin)
%
% INPUT:
% - filename                Filename of the hdF5 file
% 
% - stage_epoch_duration    (optional) double
%                           duration of an epoch in the hypnogram (1E-4s)
%                           default: 30E4
%
%
% OUTPUT:
% - stimulations            ts - stimulation times
% - StageEpochs             struct intervalSet - intervalSet for each Sleep Stage
%                           1: N1, 2: N2, 3: N3, 4: REM, 5: Wake
%
%       see 
%           GetRecordDreem
%


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'stage_epoch_duration'
            stage_epoch_duration = varargin{i+1};
            if ~isvector(stage_epoch_duration) || length(stage_epoch_duration)~=1
                error('Incorrect value for property ''stage_epoch_duration''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('stage_epoch_duration','var')
    stage_epoch_duration = 30E4;
end


%params
NameSleepStage = {'N1','N2','N3','REM','Wake','Unknown'};
stage_ind = 1:5;
fs_eeg = 250;
delay_stim = 3120; %312ms


%% load

%stim
Stim = double(h5read(filename,'/stimulations/stimulations/'));
Stim_int =  double(h5read(filename,'/stimulations/stimulations_intensity/'));

%hypnograms
try
    Hypnogram = double(h5read(filename,'/reporting/hypnograms/'));
catch
    try
        Hypnogram = double(h5read(filename,'/algo/dreemnogram/'));
    catch
        try
            Hypnogram = double(h5read(filename,'/reporting/dreemnogram/'));
        catch
            Hypnogram = [];
        end
    end
end


%% stim
[Stim, idx] = sort(Stim);
Stim_int = Stim_int(idx);
stimulations = tsd((Stim / fs_eeg)*1E4 + delay_stim, Stim_int);


%% Hypnogram
stage_ind = -1:4;
for ss = stage_ind
    start_substage = find(Hypnogram==ss);
    intv = intervalSet((start_substage-1)*stage_epoch_duration,start_substage*stage_epoch_duration);
    if ss==0 %Wake
        StageEpochs{5} = mergeCloseIntervals(intv, 10);
    elseif ss==-1 %Noise
        StageEpochs{6} = mergeCloseIntervals(intv, 10);
    else
        StageEpochs{ss} = mergeCloseIntervals(intv, 10);
    end
end


end


