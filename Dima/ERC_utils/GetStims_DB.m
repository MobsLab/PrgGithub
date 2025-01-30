% Get All the ttls (UMaze Experiment)
% Out all the digital inputs in the same format
load('ExpeInfo.mat')

%OnOff

load(['LFPData/DigInfo' num2str(find(strcmp(ExpeInfo.DigID,'ONOFF'))) '.mat']);
UpEpoch=thresholdIntervals(DigTSD,0.9,'Direction','Above');
StartSession=Start(UpEpoch);
StopSession=Stop(UpEpoch);
%Stim
load(['LFPData/DigInfo' num2str(find(strcmp(ExpeInfo.DigID,'STIM'))) '.mat']);
% load('LFPData/DigInfo3.mat')
StimEpoch=thresholdIntervals(DigTSD,0.9,'Direction','Above');

TTLInfo.StartSession=StartSession;
TTLInfo.StopSession=StopSession;
TTLInfo.StimEpoch=StimEpoch;

save('behavResources.mat', 'TTLInfo', '-append');
