%%MakePhaseLFPData
% 23.07.2019 KJ
%
% create tsd with phases of LFP for a channel
%
% function 
%
% INPUT:
% - channel                     channel to use for the phase computation
%                           
%
% - foldername (optional)       = folder path for the detection of delta waves
%                               (default pwd)
% - bandpass  (optional)        = bandpass for the filter to use
%                               (default [0.5 4])
% - zerophase  (optional)        = 0 for a zero-phase filter, 1 for a standard forward filter
%                               (default 1)
%
% OUTPUT:
% - PhaseLFP                    = tsd - phase value and timestamps
%
%
%   see 
%       
%


function PhaseLFP = MakePhaseLFPData(channel, varargin)


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
        case 'foldername'
            foldername = varargin{i+1};
        case 'bandpass'
            bandpass_phase = lower(varargin{i+1});
        case 'zerophase'
            zerophase = lower(varargin{i+1});
            if zerophase~=0 && zerophase ~=1
                error('Incorrect value for property ''zerophase''.');
            end
        case 'recompute'
            recompute = varargin{i+1};
            if recompute~=0 && recompute ~=1
                error('Incorrect value for property ''recompute''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('foldername','var')
    foldername=pwd;
end
if ~exist('bandpass','var')
    bandpass_phase=[0.5 4];
end
if ~exist('zerophase','var')
    zerophase=1;
end
%recompute?
if ~exist('recompute','var')
    recompute=0;
end


%names & recompute
if zerophase
    filename = ['PhaseLFP' num2str(channel) '.mat'];
else
    filename = ['PhaseFwLFP' num2str(channel) '.mat'];
end
%check if already exist
if ~recompute
    if exist(fullfile(foldername,'PhaseLFP',filename),'file')==2
        disp(['Phase already generated for channel ' num2str(channel) ' : ' filename])
        return
    end
end


%% load
load(['LFPData/LFP' num2str(channel) '.mat']);


%% Compute
%Filtering
if zerophase
    LFPfilt = FilterLFP(LFP, bandpass_phase, 1024);
else
    LFPfilt = FilterForwardLFP(LFP, bandpass_phase, 1024);
end
h = hilbert(Data(LFPfilt));

PhaseLFP = tsd(Range(LFPfilt), angle(h));


%% save
save(fullfile(foldername,'PhaseLFP',filename), 'PhaseLFP')



end



