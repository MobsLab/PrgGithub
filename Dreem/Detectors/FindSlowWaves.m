function SlowWaveEpochs=FindSlowWaves(EEG,varargin)
%
%   SlowWaveEpochs=FindSlowWaves(EEG,varargin)
%
% INPUT
%   EEG                 tsd: EEG signal
%
%   method              (optional) str - which method is used to detect Slow Waves
%                           - KarimJr: simple thresholds method
%                           - Predetect: similar to KarimJr - the intervals returned are between two zero-rising points
%                           - Ngo2015: insipired from this article - not fit
%                       (default 'KarimJr')
%   params              (optional) struct - structure with the params used for Slow Waves detection
%                       (default {})
%
% OUTPUT
%   SlowWaveEpochs      intervalSet - Epochs detected
%
% SEE
%    DetectSlowWaves_KJ DetectSlowWaves_NGO2015
%
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
        case 'method'
            method = varargin{i+1};
            if ~isstring_FMAToolbox(method,'karimjr','predetect','ngo2015')
                error('Incorrect value for property ''method''.');
            end
        case 'params'
            params = varargin{i+1};
            if ~isstruct(params) && ~isempty(params)
                error('Incorrect value for property ''params''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check if exist and assign default value if not
if ~exist('method','var')
    method = 'karimjr';
end
if ~exist('params','var')
    params = cell(0);
end


%% Params
if ~isempty(params)
    all_fields = fieldnames(params);
    vararguments_func = {};
    for f=1:length(all_fields)
       vararguments_func{end+1} = all_fields{f};
       vararguments_func{end+1} = params.(all_fields{f});
    end
end


%% IF METHOD IS KarimJr
if strcmpi(method,'karimjr')
    if isempty(params)
        SlowWaveEpochs=DetectSlowWaves_KJ(EEG);
    else
        SlowWaveEpochs=DetectSlowWaves_KJ(EEG,vararguments_func{:});
    end
end


%% IF METHOD IS KarimStd
if strcmpi(method,'karimstd')
    if isempty(params)
        SlowWaveEpochs=DetectSlowWaves_Std(EEG);
    else
        SlowWaveEpochs=DetectSlowWaves_Std(EEG,vararguments_func{:});
    end
end




%% IF METHOD IS Predetect
if strcmpi(method,'predetect')
    if isempty(params)
        SlowWaveEpochs=PreDetectSlowWaves_KJ(EEG);
    else
        SlowWaveEpochs=PreDetectSlowWaves_KJ(EEG,vararguments_func{:});
    end
end


%% IF METHOD IS NGO2015
if strcmpi(method,'ngo2015')
    if isempty(params)
        SlowWaveEpochs=DetectSlowWaves_NGO2015(EEG);
    else
        SlowWaveEpochs=DetectSlowWaves_NGO2015(EEG,vararguments_func{:});
    end
end



end

