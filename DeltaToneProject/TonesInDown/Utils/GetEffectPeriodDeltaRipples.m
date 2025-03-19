%%GetEffectPeriodDeltaRipples
% 18.07.2019 KJ
%
% get/load effect periods for animals of the Ripples in Down project
% - ScriptRipplesDeltaPeriodTransition
% Transitions Delta to Up
%
% function effect_periods = GetEffectPeriodDeltaRipples(Dir)
%
% INPUT:
% - Dir                         struct - from PathForExperiments (e.g PathForExperimentsDeltaCloseLoop)
%                               (default 'PFCx')
%
% OUTPUT:
% - effect_periods             = effect_periods
%
%   see 
%       GetEffectPeriodDeltaTone GetEffectPeriodDownTone GetEffectPeriodDownRipples
%
%


function effect_periods = GetEffectPeriodDeltaRipples(Dir)



%% CHECK INPUTS

if nargin<1
  error('Incorrect number of parameters.');
end

%init
effect_periods = nan(length(Dir.path),2);


%% Attribute value

%M243  0-60ms
effect_periods(strcmpi(Dir.name,'Mouse243'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse243'),2) = 60; %ms
%M244  0-40ms
effect_periods(strcmpi(Dir.name,'Mouse244'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse244'),2) = 40; %ms
%M251  0-50ms
effect_periods(strcmpi(Dir.name,'Mouse251'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse251'),2) = 50; %ms
%M252  0-80ms
effect_periods(strcmpi(Dir.name,'Mouse252'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse252'),2) = 80; %ms
%M294  0-60ms
effect_periods(strcmpi(Dir.name,'Mouse294'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse294'),2) = 60; %ms
%M328  0-70ms
effect_periods(strcmpi(Dir.name,'Mouse328'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse328'),2) = 70; %ms
%M330  0-50ms
effect_periods(strcmpi(Dir.name,'Mouse330'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse330'),2) = 50; %ms
%M403  0-60ms
effect_periods(strcmpi(Dir.name,'Mouse403'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse403'),2) = 60; %ms
%M451  0-60ms
effect_periods(strcmpi(Dir.name,'Mouse451'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse451'),2) = 60; %ms
%M490  0-60ms
effect_periods(strcmpi(Dir.name,'Mouse490'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse490'),2) = 60; %ms
%M507  0-50ms
effect_periods(strcmpi(Dir.name,'Mouse507'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse507'),2) = 50; %ms
%M508  0-50ms
effect_periods(strcmpi(Dir.name,'Mouse508'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse508'),2) = 50; %ms
%M509  0-40ms
effect_periods(strcmpi(Dir.name,'Mouse509'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse509'),2) = 40; %ms
%M514  0-50ms
effect_periods(strcmpi(Dir.name,'Mouse514'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse514'),2) = 50; %ms

%convert in ts
effect_periods = effect_periods * 10;

end
