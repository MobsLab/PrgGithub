function BurstEpochs=FindBurstSlowWave(SlowWaveEpochs,varargin)
%
%   BurstEpochs=FindBurstSlowWave(SlowWaveEpochs,varargin)
%
% INPUT
%   SlowWaveEpochs      intervalSet: Slow Waves Intervals
%
%   distanceLimit       (optional) distance max between 2 slow waves to classify as burst
%                       (default 1500ms)
%
% OUTPUT
%   BurstEpochs         intervalSet - Epochs detected
%
% SEE
%    
%
%


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
        case 'distancelimit',
            distancelim = varargin{i+1};
            if ~isvector(distancelim) || length(distancelim)~=1
                error('Incorrect value for property ''distanceLimit''.');
            end

        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check if exist and assign default value if not
if ~exist('threshold','var')
    distancelim = 1500;
end

%params
distancelim = distancelim *10;

%% Burst
BurstEpochs=mergeCloseIntervals(SlowWaveEpochs, distancelim);


end