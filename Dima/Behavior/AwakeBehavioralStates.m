% AwakeBehavioralStates

%%%% TODO: Add possibility to discriminate between Sleep and Awake Sessions


%% Parameters
% Before Vtsd correction == 1
old = 0;
% Smoothing
Smooth_camera = 15; %frame rate in general
Smooth_accelero = 30;
% Thresholds
thtps_immob = 2;
th_immob = 20;
th_v = 5; % 3?
thtps_v = 1.5;
th_acc = 17000000;
% Load data
load('behavResources.mat', 'Imdifftsd', 'Vtsd', 'Xtsd', 'MovAcctsd', 'ZoneEpoch', 'FreezeTime');

%% Prepare arrays
NewImdifftsd=tsd(Range(Imdifftsd),runmean(Data(Imdifftsd),Smooth_camera));
if old
%     NewVtsd = tsd(Range(Vtsd),(Data(Vtsd)./(diff(Range(Xtsd))/1E4)));
    NewVtsd = tsd(Range(Vtsd),(Data(Vtsd)./(diff(Range(Xtsd))/1E4)));
    NewVtsd = tsd(Range(NewVtsd),runmean(Data(NewVtsd),Smooth_camera));
else
    NewVtsd = tsd(Range(Vtsd),runmean(Data(Vtsd),Smooth_camera));
end
NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),Smooth_camera));


%% Calculate Epochs
% Freezing
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_acc,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
for i = 1:length(ZoneEpoch)
	FreezeTime(i)=length(Data(Restrict(Xtsd,and(FreezeAccEpoch,ZoneEpoch{i}))))./length(Data((Restrict(Xtsd,ZoneEpoch{i}))));
end

% Immobility
ImmobEpochV = thresholdIntervals(NewVtsd,th_v,'Direction','Below');
ImmobEpochV=mergeCloseIntervals(ImmobEpochV,0.3*1e4);
ImmobEpochV=dropShortIntervals(ImmobEpochV,1*1e4); % ?????????

%% Create Epochs
T = Range(Imdifftsd); % time
% Total
AllAwakeEpochDB = intervalSet(T(1),T(end));
% Freezing
FreezeAccEpoch = FreezeAccEpoch;
% Immobility
ImmobEpoch = minus(ImmobEpochV,FreezeAccEpoch);
% Locomotion
LocomotionEpoch = minus(AllAwakeEpochDB, or(ImmobEpoch,FreezeAccEpoch));

%% Save Epochs
save('behavResources.mat','FreezeAccEpoch','ImmobEpoch','LocomotionEpoch', 'AllAwakeEpochDB', 'FreezeTime',...
    'th_v', 'thtps_v', 'th_acc', 'Smooth_camera', 'Smooth_accelero', '-append');

%% Clear
clearvars -except dirin
