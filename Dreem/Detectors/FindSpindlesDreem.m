function SpindlesEpoch=FindSpindlesDreem(EEG,varargin)
%
%   SpindlesEpoch=FindSpindlesDreem(EEG,varargin)
%
% INPUT
%   EEG                 tsd: EEG signal
%
%   method              (optional) str - which method is used to detect Slow Waves
%                       (default 'KarimJr')
%   params              (optional) struct - structure with the params used for Spindles detection
%                       (default {})
%
% OUTPUT
%   SpindlesEpoch       intervalSet - Epochs detected
%
% SEE
%    FindSlowWaves
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
            if ~isstring_FMAToolbox(method,'mensen','karimjr')
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
    method = 'mensen';
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


%% IF METHOD IS mensen
if strcmpi(method,'mensen')
    if isempty(params)
        SpindlesEpoch=DetectSpindles_Mensen(EEG);
    else
        SpindlesEpoch=DetectSpindles_Mensen(EEG,vararguments_func{:});
    end
end

%% IF METHOD IS KarimJr
if strcmpi(method,'karimjr')
    if isempty(params)
        SpindlesEpoch=DetectSpindles_KJ(EEG);
    else
        SpindlesEpoch=DetectSpindles_KJ(EEG,vararguments_func{:});
    end
end


end

