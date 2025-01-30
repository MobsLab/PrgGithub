%%GetEffectPeriodUpRipples
% 18.07.2019 KJ
%
% get/load effect periods for animals of the Tones/Ripples in Down project
% - ScriptRipplesPeriodTransition
% Transitions Down to Up
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
%       GetEffectPeriodDeltaTone GetEffectPeriodDownTone GetEffectPeriodDownRipples
%
%


function effect_periods = GetEffectPeriodUpRipples(Dir)



%% CHECK INPUTS

if nargin<1
  error('Incorrect number of parameters.');
end

%init
effect_periods = nan(length(Dir.path),2);


%% Attribute value

%M243  0-40ms
effect_periods(strcmpi(Dir.name,'Mouse243'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse243'),2) = 40; %ms
%M244  0-40ms
effect_periods(strcmpi(Dir.name,'Mouse244'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse244'),2) = 40; %ms
%M403  0-30ms
effect_periods(strcmpi(Dir.name,'Mouse403'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse403'),2) = 30; %ms
%M451  0-20ms
effect_periods(strcmpi(Dir.name,'Mouse451'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse451'),2) = 20; %ms

%M490  0-50ms
effect_periods(strcmpi(Dir.name,'Mouse508'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse508'),2) = 40; %ms
%M507  0-50ms
effect_periods(strcmpi(Dir.name,'Mouse508'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse508'),2) = 40; %ms
%M508  0-50ms
effect_periods(strcmpi(Dir.name,'Mouse508'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse508'),2) = 50; %ms
%M509  0-40ms
effect_periods(strcmpi(Dir.name,'Mouse509'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse509'),2) = 40; %ms
%M514  0-40ms
effect_periods(strcmpi(Dir.name,'Mouse509'),1) = 0; %ms
effect_periods(strcmpi(Dir.name,'Mouse509'),2) = 40; %ms

%convert in ts
effect_periods = effect_periods * 10;

end
