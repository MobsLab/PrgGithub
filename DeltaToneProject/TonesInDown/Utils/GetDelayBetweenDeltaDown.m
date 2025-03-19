%%GetDelayBetweenDeltaDown
% 24.07.2019 KJ
%
% get/load delay between starts and ends of delta waves and down states,
% for each mouse
%
% function delay_detections = GetDelayBetweenDeltaDown(Dir)
%
% INPUT:
% - Dir                         struct - from PathForExperiments (e.g PathForExperimentsDeltaCloseLoop)
%                               (default 'PFCx')
%
% OUTPUT:
% - delay_detections            = delays
%
%   see 
%       DistribDelayToneShamDeltaMousePlot


function delay_detections = GetDelayBetweenDeltaDown(Dir)



%% CHECK INPUTS

if nargin<1
  error('Incorrect number of parameters.');
end

%init
delay_detections = nan(length(Dir.path),2);


%% Attribute value

%M243 
delay_detections(strcmpi(Dir.name,'Mouse243'),1) = 0; %ms
delay_detections(strcmpi(Dir.name,'Mouse243'),2) = 0; %ms
%M244
delay_detections(strcmpi(Dir.name,'Mouse244'),1) = -50; %ms
delay_detections(strcmpi(Dir.name,'Mouse244'),2) = -20; %ms
%M251
delay_detections(strcmpi(Dir.name,'Mouse251'),1) = 0; %ms
delay_detections(strcmpi(Dir.name,'Mouse251'),2) = 0; %ms
%M252 
delay_detections(strcmpi(Dir.name,'Mouse252'),1) = -40; %ms
delay_detections(strcmpi(Dir.name,'Mouse252'),2) = 40; %ms
%M294 
delay_detections(strcmpi(Dir.name,'Mouse294'),1) = -10; %ms
delay_detections(strcmpi(Dir.name,'Mouse294'),2) = 10; %ms
%M328
delay_detections(strcmpi(Dir.name,'Mouse328'),1) = -50; %ms
delay_detections(strcmpi(Dir.name,'Mouse328'),2) = 0; %ms
%M330
delay_detections(strcmpi(Dir.name,'Mouse330'),1) = -40; %ms
delay_detections(strcmpi(Dir.name,'Mouse330'),2) = 0; %ms
%M403
delay_detections(strcmpi(Dir.name,'Mouse403'),1) = -10; %ms
delay_detections(strcmpi(Dir.name,'Mouse403'),2) = 0; %ms
%M451
delay_detections(strcmpi(Dir.name,'Mouse451'),1) = 0; %ms
delay_detections(strcmpi(Dir.name,'Mouse451'),2) = 0; %ms
%M490
delay_detections(strcmpi(Dir.name,'Mouse490'),1) = -50; %ms
delay_detections(strcmpi(Dir.name,'Mouse490'),2) = 0; %ms
%M507
delay_detections(strcmpi(Dir.name,'Mouse507'),1) = 0; %ms
delay_detections(strcmpi(Dir.name,'Mouse507'),2) = 0; %ms
%M508
delay_detections(strcmpi(Dir.name,'Mouse508'),1) = 0; %ms
delay_detections(strcmpi(Dir.name,'Mouse508'),2) = 0; %ms
%M509
delay_detections(strcmpi(Dir.name,'Mouse509'),1) = 0; %ms
delay_detections(strcmpi(Dir.name,'Mouse509'),2) = 0; %ms
%M514
delay_detections(strcmpi(Dir.name,'Mouse514'),1) = -30; %ms
delay_detections(strcmpi(Dir.name,'Mouse514'),2) = 0; %ms


%convert in ts
delay_detections = delay_detections * 10;

end

