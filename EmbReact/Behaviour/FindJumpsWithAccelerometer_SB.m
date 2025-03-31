function JumpEp = FindJumpsWithAccelerometer_SB(FolderName,Epoch)

cd(FolderName)

% Find accelero channels
load('LFPData/InfoLFP.mat')
AccChannels = find(~cellfun(@isempty,(strfind(InfoLFP.structure,'Accelero'))))-1;

% Load the z-axis acceleration
load(['LFPData/LFP',num2str(AccChannels(2)),'.mat'])

% Restrict if necessary
if exist('Epoch')
    LFP = Restrict(LFP,Epoch);
end

% Get the jumps
% JumpEpLow = thresholdIntervals(LFP,-4000,'Direction','Above');
% JumpEpLow = mergeCloseIntervals(JumpEpLow,0.2*1e4);
% JumpEpLow = dropShortIntervals(JumpEpLow,0.2*1e4);

% JumpEp = thresholdIntervals(LFP,1e4,'Direction','Above');
% JumpEpLowAndHigh = and(JumpEp,JumpEpLow);
% JumpEpLowAndHigh = dropShortIntervals(JumpEpLowAndHigh,0.*1e4);
% JumpEpLowAndHigh = mergeCloseIntervals(JumpEpLowAndHigh,0.5*1e4);
% 
% JumpEp = mergeCloseIntervals(JumpEp,1*1e4);
% JumpEp = dropShortIntervals(JumpEp,0.2*1e4);

 JumpEp = thresholdIntervals(LFP,3e4,'Direction','Above');
 JumpEp = mergeCloseIntervals(JumpEp,0.5*1e4);
%  JumpEp = dropShortIntervals(JumpEp,0.1*1e4);
 
%  figure
% plot(Range(LFP,'s'),Data(LFP))
% hold on
% plot(Start(JumpEp,'s'),2.5e4,'*')
% keyboard
end
