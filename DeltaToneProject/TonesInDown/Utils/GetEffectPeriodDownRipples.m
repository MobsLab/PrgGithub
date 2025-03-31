%%GetEffectPeriodDownRipples
% 18.07.2019 KJ
%
% get/load effect periods for animals of the Tones/Ripples in Down project
% (BasalSleepSpikes)
% Transitions Up to Down
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
%       GetEffectPeriodDeltaTone GetEffectPeriodDownTone GetEffectPeriodUpRipples
%
%


function effect_periods = GetEffectPeriodDownRipples(Dir)



%% CHECK INPUTS

if nargin<1
  error('Incorrect number of parameters.');
end

%init
effect_periods = nan(length(Dir.path),2);


%% Attribute value

%M243  30-100ms
effect_periods(strcmpi(Dir.name,'Mouse243'),1) = 30; %ms
effect_periods(strcmpi(Dir.name,'Mouse243'),2) = 100; %ms
%M244  30-90ms
effect_periods(strcmpi(Dir.name,'Mouse244'),1) = 30; %ms
effect_periods(strcmpi(Dir.name,'Mouse244'),2) = 90; %ms
%M330  30-90ms
effect_periods(strcmpi(Dir.name,'Mouse330'),1) = 30; %ms
effect_periods(strcmpi(Dir.name,'Mouse330'),2) = 70; %ms
%M403  30-100ms
effect_periods(strcmpi(Dir.name,'Mouse403'),1) = 30; %ms
effect_periods(strcmpi(Dir.name,'Mouse403'),2) = 100; %ms
%M451  30-90ms
effect_periods(strcmpi(Dir.name,'Mouse451'),1) = 30; %ms
effect_periods(strcmpi(Dir.name,'Mouse451'),2) = 60; %ms

%M490  30-90ms
effect_periods(strcmpi(Dir.name,'Mouse490'),1) = 50; %ms
effect_periods(strcmpi(Dir.name,'Mouse490'),2) = 80; %ms
%M507  50-90ms
effect_periods(strcmpi(Dir.name,'Mouse507'),1) = 45; %ms
effect_periods(strcmpi(Dir.name,'Mouse507'),2) = 90; %ms
%M508  50-90ms
effect_periods(strcmpi(Dir.name,'Mouse508'),1) = 50; %ms
effect_periods(strcmpi(Dir.name,'Mouse508'),2) = 80; %ms
%M509  45-90ms
effect_periods(strcmpi(Dir.name,'Mouse509'),1) = 50; %ms
effect_periods(strcmpi(Dir.name,'Mouse509'),2) = 80; %ms
%M514  50-90ms
effect_periods(strcmpi(Dir.name,'Mouse514'),1) = 45; %ms
effect_periods(strcmpi(Dir.name,'Mouse514'),2) = 80; %ms

%convert in ts
effect_periods = effect_periods * 10;

end

