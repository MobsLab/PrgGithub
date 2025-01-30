% DreemIDfunc_Stimcurves
% 27.03.2018 KJ
%
%%INPUT
% 
% 
%%OUTPUT
% 
%
% SEE
%   DreemIDStimImpact DreemIDfunc_Sleepstage
%
%


function [meancurves, nb_events, intensities] = DreemIDfunc_Stimcurves(varargin)


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
    [signals, ~, stimulations, ~, ~] = GetRecordDreem(filename);

elseif ~exist('signals','var') || ~exist('stimulations','var')
    error('A filename or signals+stimulations is required.');
end


%params
binsize_met = 20;
nbBins_met  = 300;

%% stim
[stim_tmp, sham_tmp, int_stim, stim_train, sham_train, ~, ~] = SortDreemStimSham(stimulations);

nb_events.tones = length(stim_tmp);
nb_events.sham = length(sham_tmp);
intensities = unique(int_stim);

if ~isempty(stim_train)
    first_stim = stim_train(:,1);
else
    first_stim = [];
end
if ~isempty(sham_train)
    first_sham = sham_train(:,1);
else
    first_sham = [];
end



%% Curves
if ~isempty(stim_tmp)
    for ch=1:length(signals)
        [m,~,tps] = mETAverage(first_stim, Range(signals{ch}), Data(signals{ch}), binsize_met, nbBins_met);
        meancurves.tones{ch}(:,1) = tps; meancurves.tones{ch}(:,2) = m;    
    end
else
    meancurves.tones{1}=[];
end

if ~isempty(sham_tmp)
    for ch=1:length(signals)
        [m,~,tps] = mETAverage(first_sham, Range(signals{ch}), Data(signals{ch}), binsize_met, nbBins_met);
        meancurves.sham{ch}(:,1) = tps; meancurves.sham{ch}(:,2) = m;  
    end
else
    meancurves.sham{1}=[];
end


end












