%%GetEffectPeriodDownTone
% 18.07.2019 KJ
%
% get/load effect periods for animals of the DeltaTone project (from DistribDelayToneShamDeltaMousePlot)
%
% function effect_periods = GetEffectPeriodDownTone(Dir)
%
% INPUT:
% - Dir                         struct - from PathForExperiments (e.g PathForExperimentsDeltaCloseLoop)
%                               (default 'PFCx')
%
% OUTPUT:
% - effect_periods             = effect_periods
%
%   see 
%       GetEffectPeriodDeltaTone
%
%


function effect_periods = GetEffectPeriodDownTone(Dir)



%% CHECK INPUTS

if nargin<1
  error('Incorrect number of parameters.');
end

%init
effect_periods = nan(length(Dir.path),2);


%% Attribute value

%M243  40-100ms
effect_periods(strcmpi(Dir.name,'Mouse243'),1) = 40; %ms
effect_periods(strcmpi(Dir.name,'Mouse243'),2) = 110; %ms
%M244  60-120ms
effect_periods(strcmpi(Dir.name,'Mouse244'),1) = 60; %ms
effect_periods(strcmpi(Dir.name,'Mouse244'),2) = 120; %ms
%M294  60-120ms
effect_periods(strcmpi(Dir.name,'Mouse294'),1) = 60; %ms
effect_periods(strcmpi(Dir.name,'Mouse294'),2) = 120; %ms
%M328  40-110ms
effect_periods(strcmpi(Dir.name,'Mouse328'),1) = 40; %ms
effect_periods(strcmpi(Dir.name,'Mouse328'),2) = 110; %ms
%M330  60-120ms
effect_periods(strcmpi(Dir.name,'Mouse330'),1) = 60; %ms
effect_periods(strcmpi(Dir.name,'Mouse330'),2) = 120; %ms
%M403  60-100ms
effect_periods(strcmpi(Dir.name,'Mouse403'),1) = 60; %ms
effect_periods(strcmpi(Dir.name,'Mouse403'),2) = 100; %ms
%M451  60-130ms
effect_periods(strcmpi(Dir.name,'Mouse451'),1) = 60; %ms
effect_periods(strcmpi(Dir.name,'Mouse451'),2) = 130; %ms


%convert in ts
effect_periods = effect_periods * 10;

end

