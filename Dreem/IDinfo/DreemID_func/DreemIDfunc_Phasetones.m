% DreemIDfunc_Phasetones
% 27.03.2018 KJ
%
%%INPUT
% 
% 
%%OUTPUT
% 
%
% SEE
%   DreemIDStimImpact DreemIDfunc_Sleepstage DreemIDfunc_Stimcurves
%
%


function [phase_event, nb_events, intensities] = DreemIDfunc_Phasetones(varargin)


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'filename'
            filename = varargin{i+1};
        case 'signals'
            signals = varargin{i+1};
        case 'stimulations'
            stimulations = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check inputs
if exist('filename','var')
    [signals, ~, stimulations, ~] = GetRecordDreem(filename);

elseif ~exist('signals','var') || ~exist('stimulations','var')
    error('A filename or signals+stimulations is required.');
end


%params
bandpass_phase = [0.5 4]; %filter bandpass before hilbert computing of phase


%% stimualtions
[stim_tmp, sham_tmp, int_stim] = SortDreemStimSham(stimulations);

nb_events.tones = length(stim_tmp);
nb_events.sham = length(sham_tmp);
intensities = unique(int_stim);


%% phase phase
for ch=1:length(signals)
    [phase_sig, ~] = ComputeHilbertData(signals{ch},'bandpass',bandpass_phase);
    phase_value = Data(phase_sig);
    phase_tmp = Range(phase_sig);
    
    %tones
    phase_tone = zeros(length(stim_tmp), 1);
    for i=1:length(stim_tmp)
        [~,min_idx] = min(abs(phase_tmp-stim_tmp(i)));
        phase_tone(i) = phase_value(min_idx);
    end
        
    %sham
    phase_sham = zeros(length(sham_tmp), 1);
    for i=1:length(sham_tmp)
        [~,min_idx] = min(abs(phase_tmp-sham_tmp(i)));
        phase_sham(i) = phase_value(min_idx);
    end
    
    
    %results
    phase_event.tones{ch} = phase_tone;
    phase_event.sham{ch}  = phase_sham;

end

end












