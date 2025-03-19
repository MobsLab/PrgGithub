%%SynchronizationDegree_KJ
% 01.04.2018 KJ
%
% Degree of synchronization of a signal
%
% sync_degree = SynchronizationDegree_KJ(Signal,varargin)
%
% INPUT:
% - Signal                  = tsd of the signals
% - rangeFreq1 (optional)   = frequency range for the spectral power (numerator)   
%                             (default [0 5])                                  
% - rangeFreq2 (optional)   = frequency range for the spectral power (denominator)                           
%                             (default [0 50])
% 
%
% OUTPUT:
% - sync_degree             = degree of synchronization
%
%   see 
%       LFPlayerInfluenceOnDetectionMouse
%


function sync_degree = SynchronizationDegree_KJ(Signal,varargin)


%% CHECK INPUTS

if nargin < 1
  error('Incorrect number of parameters.');
end

%% Initiation
% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'rangeFreq1'
            rangeFreq1 = varargin{i+1};
            if length(rangeFreq1)~=2
                error('Incorrect value for property ''rangeFreq1''.');
            end
        case 'rangeFreq2'
            rangeFreq2 = varargin{i+1};
            if length(rangeFreq2)~=2
                error('Incorrect value for property ''rangeFreq2''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('rangeFreq1','var')
    rangeFreq1 = [0 5];
end
if ~exist('rangeFreq2','var')
    rangeFreq2 = [0 50];
end


%% 
params.fpass  = [0 60];
params.tapers = [3 5];
params.Fs     = 1 / median(diff(Range(MUA,'s')));

[Sp, spfreq] = mtspectrumc(Data(Signals), params);


%P(f)
P1 = sum(Sp(spfreq>=rangeFreq1(1) & spfreq<=rangeFreq1(2)));
P2 = sum(Sp(spfreq>=rangeFreq2(1) & spfreq<=rangeFreq2(2)));


sync_degree = P1 / P2;


end





