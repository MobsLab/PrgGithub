%%GetEffectPeriodEndDeltaTone
% 18.12.2019 KJ
%
% get/load effect periods for animals of the DeltaTone project (from DistribDelayToneShamEndDeltaMousePlot)
%   Tones in delta : Delta to Up
%
% function effect_periods = GetEffectPeriodEndDeltaTone(Dir)
%
% INPUT:
% - Dir                         struct - from PathForExperiments (e.g PathForExperimentsDeltaCloseLoop)
%                               (default 'PFCx')
%
% OUTPUT:
% - effect_periods             = effect_periods
%
%   see 
%       DistribDelayToneShamEndDeltaMousePlot


function effect_periods = GetEffectPeriodEndDeltaTone(Dir)



%% CHECK INPUTS

if nargin<1
  error('Incorrect number of parameters.');
end

%init
effect_periods = nan(length(Dir.path),2);


%% Attribute value

%M243  0-50ms
effect_periods(strcmpi(Dir.name,'Mouse243'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse243'),2) = 50; %ms
%M244  0-70ms
effect_periods(strcmpi(Dir.name,'Mouse244'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse244'),2) = 70; %ms
%M251  0-60ms
effect_periods(strcmpi(Dir.name,'Mouse251'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse251'),2) = 60; %ms
%M252  60-120ms
effect_periods(strcmpi(Dir.name,'Mouse252'),1) = 60; %ms
effect_periods(strcmpi(Dir.name,'Mouse252'),2) = 120; %ms
%M293  0-100ms
effect_periods(strcmpi(Dir.name,'Mouse293'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse293'),2) = 100; %ms
%M294  0-100ms
effect_periods(strcmpi(Dir.name,'Mouse294'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse294'),2) = 100; %ms
%M328  0-80ms
effect_periods(strcmpi(Dir.name,'Mouse328'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse328'),2) = 80; %ms
%M403  0-50ms
effect_periods(strcmpi(Dir.name,'Mouse403'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse403'),2) = 50; %ms
%M451  0-80ms
effect_periods(strcmpi(Dir.name,'Mouse451'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse451'),2) = 80; %ms


%convert in ts
effect_periods = effect_periods * 10;

end

