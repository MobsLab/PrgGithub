% DreemIDfunc_Stagetones
% 11.04.2018 KJ
%
%%INPUT
% 
% 
%%OUTPUT
% 
%
% SEE
%   DreemIDStimImpact DreemIDfunc_Sleepstage DreemIDfunc_Phasetones
%
%


function [stage_event, nb_events, intensities] = DreemIDfunc_Stagetones(varargin)


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'filename'
            filename = varargin{i+1};
        case 'stimulations'
            stimulations = varargin{i+1};
        case 'hypnogram'
            StageEpochs = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check inputs
if exist('filename','var')
    [~, ~, stimulations, StageEpochs] = GetRecordDreem(filename);

elseif ~exist('StageEpochs','var') || ~exist('stimulations','var')
    error('A filename or signals+stimulations is required.');
end


%% stimualtions
[stim_tmp, sham_tmp, int_stim] = SortDreemStimSham(stimulations);

nb_events.tones = length(stim_tmp);
nb_events.sham = length(sham_tmp);
intensities = unique(int_stim);


%% Sleep stage of stim and sham
for i=1:5
    stage_event.tones{i} = length(Restrict(ts(stim_tmp), StageEpochs{i}));
    stage_event.sham{i}  = length(Restrict(ts(sham_tmp), StageEpochs{i}));    
end


end












