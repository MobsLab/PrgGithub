function [phase, enveloppe] = ComputeHilbertData(signals,varargin)
%   [phase, enveloppe] = ComputeHilbertData(signals,varargin)
%
% INPUT:
% - signals             tsd - EEG or LFP signal
% 
% (OPTIONAL)
% - bandpass            vector - bandpass frequencies to filter the signal 
%                       (default  no filtering)
%
%%
% OUTPUT:
% - phase:              tsd - phase of the signal
% - enveloppe:          tsd - enveloppe of the signal             
%
%
%       see 
%


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'bandpass'
            bandpass = varargin{i+1};
            if ~isvector(bandpass) || length(bandpass)~=2
                error('Incorrect value for property ''bandpass''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
        
    end
end

if ~exist('bandpass','var')
    filtering = 0;
else
    filtering = 1;
end


%% Filtering
if filtering
    signals = FilterLFP(signals, bandpass, 1024);
end


%% Compute
sig = Data(signals);
rg = Range(signals);

h = hilbert(sig);

enveloppe = tsd(rg, abs(h));
phase = tsd(rg, angle(h));


end

