%%GetEffectPeriodDeltaTone
% 18.12.2019 KJ
%
% get/load effect periods for animals of the DeltaTone project (from DistribDelayToneShamDeltaMousePlot)
%   Tones in Up : Up to delta
%
% function effect_periods = GetEffectPeriodDeltaTone(Dir)
%
% INPUT:
% - Dir                         struct - from PathForExperiments (e.g PathForExperimentsDeltaCloseLoop)
%                               (default 'PFCx')
%
% OUTPUT:
% - effect_periods             = effect_periods
%
%   see 
%       DistribDelayToneShamDeltaMousePlot


function effect_periods = GetEffectPeriodDeltaTone(Dir)



%% CHECK INPUTS

if nargin<1
  error('Incorrect number of parameters.');
end

%init
effect_periods = nan(length(Dir.path),2);


%% Attribute value

%M243  40-100ms
effect_periods(strcmpi(Dir.name,'Mouse243'),1) = 20; %ms
effect_periods(strcmpi(Dir.name,'Mouse243'),2) = 150; %ms
%M244  100-240ms
effect_periods(strcmpi(Dir.name,'Mouse244'),1) = 100; %ms
effect_periods(strcmpi(Dir.name,'Mouse244'),2) = 200; %ms
%M251  50-150ms
effect_periods(strcmpi(Dir.name,'Mouse251'),1) = 50; %ms
effect_periods(strcmpi(Dir.name,'Mouse251'),2) = 150; %ms
%M252  70-150ms
effect_periods(strcmpi(Dir.name,'Mouse252'),1) = 50; %ms
effect_periods(strcmpi(Dir.name,'Mouse252'),2) = 150; %ms
%M293  50-150ms
effect_periods(strcmpi(Dir.name,'Mouse293'),1) = 60; %ms
effect_periods(strcmpi(Dir.name,'Mouse293'),2) = 150; %ms
%M294  100-200ms
effect_periods(strcmpi(Dir.name,'Mouse294'),1) = 90; %ms
effect_periods(strcmpi(Dir.name,'Mouse294'),2) = 170; %ms
%M296  110-200ms
effect_periods(strcmpi(Dir.name,'Mouse296'),1) = 110; %ms
effect_periods(strcmpi(Dir.name,'Mouse296'),2) = 200; %ms
%M328  100-210ms
effect_periods(strcmpi(Dir.name,'Mouse328'),1) = 80; %ms
effect_periods(strcmpi(Dir.name,'Mouse328'),2) = 200; %ms
%M330  130-260ms
effect_periods(strcmpi(Dir.name,'Mouse330'),1) = 130; %ms
effect_periods(strcmpi(Dir.name,'Mouse330'),2) = 230; %ms
%M403  50-100ms
effect_periods(strcmpi(Dir.name,'Mouse403'),1) = 50; %ms
effect_periods(strcmpi(Dir.name,'Mouse403'),2) = 100; %ms
%M451  50-150ms
effect_periods(strcmpi(Dir.name,'Mouse451'),1) = 50; %ms
effect_periods(strcmpi(Dir.name,'Mouse451'),2) = 110; %ms


%convert in ts
effect_periods = effect_periods * 10;

end

