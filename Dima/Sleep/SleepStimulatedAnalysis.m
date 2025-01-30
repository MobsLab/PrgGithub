% Get the consistensies between TTLS and intensities

%% Parameters
TimeBefore = 1; % in s
TimeAfter = 5; % in s

Intensities = [0:0.5:2];

%% Load data
TTL = load('behavResources.mat','TTLInfo', 'PosMat');

OBScoring = load('SleepScoring_OBGamma.mat', 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');
AcceleroScoring = load('SleepScoring_Accelero.mat', 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');

%% Prepare arrays
SWStoWake=zeros(1,length(Intensities));
for i=1:length(Intensities)
    SWStoWakeTime{i} = zeros(1,10000);
end
REMtoWake=zeros(1,length(Intensities));
for i=1:length(Intensities)
    REMtoWakeTime{i} = zeros(1,10000);
end

SWStoSWS=zeros(1,length(Intensities));
for i=1:length(Intensities)
    SWStoSWSTime{i} = zeros(1,10000);
end
REMtoREM=zeros(1,length(Intensities));
for i=1:length(Intensities)
    REMtoREMTime{i} = zeros(1,10000);
end

SWStoREM=zeros(1,length(Intensities));
for i=1:length(Intensities)
    SWStoREMTime{i} = zeros(1,10000);
end
REMtoSWS=zeros(1,length(Intensities));
for i=1:length(Intensities)
    REMtoSWSTime{i} = zeros(1,10000);
end

% Times before and after
BeforeStim = Start(TTL.TTLInfo.StimEpoch)-TimeBefore*1e4;
AfterStim = Start(TTL.TTLInfo.StimEpoch)+TimeAfter*1e4;

%% Calculate
% Overall number of stims
TotalStim = length(Start(TTL.TTLInfo.StimEpoch));
StartStim = Start(TTL.TTLInfo.StimEpoch);
EndStim = End(TTL.TTLInfo.StimEpoch);

% Find indices of stims for each intensity
G = find(~isnan(TTL.PosMat(:,4)));
G = [G,[1:length(G)]'];
for i=1:length(Intensities)
    a=1;
    idxCam{i} = find(TTL.PosMat(:,4)==Intensities(i));
    for j = 1:length(G)
        if TTL.PosMat(G(j,1),4) == Intensities(i)
            idxTTL{i}(a) = G(j,2);
            a=a+1;
        end
    end
end

% Find each in TTL
for i=1:length(Intensities)
    TTLStim{i} = intervalSet(StartStim(idxTTL{i}), EndStim(idxTTL{i}));
end

% Count stimuli for each intesity
for i = 1:length(Intensities)
    StimCount(i) = length(idxTTL{i});
end

% Core
for i = 1:length(Intensities)
    for j=1:StimCount(i)
        if InIntervals(BeforeStim(idxTTL{i}(j)),[Start(OBScoring.SWSEpoch), End(OBScoring.SWSEpoch)])
            if InIntervals(AfterStim(idxTTL{i}(j)),[Start(OBScoring.Wake), End(OBScoring.Wake)])
                SWStoWake(i) = SWStoWake(i)+1;
                SWStoWakeTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
            elseif InIntervals(AfterStim(idxTTL{i}(j)),[Start(OBScoring.SWSEpoch), End(OBScoring.SWSEpoch)])
                SWStoSWS(i) = SWStoSWS(i) +1;
                SWStoSWSTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
            elseif InIntervals(AfterStim(idxTTL{i}(j)),[Start(OBScoring.REMEpoch), End(OBScoring.REMEpoch)])
                SWStoREM(i) = SWStoREM(i) +1;
                SWStoREMTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
            end
        elseif InIntervals(BeforeStim(idxTTL{i}(j)),[Start(OBScoring.REMEpoch), End(OBScoring.REMEpoch)])
            if InIntervals(AfterStim(idxTTL{i}(j)),[Start(OBScoring.Wake), End(OBScoring.Wake)])
                REMtoWake(i) = REMtoWake(i)+1;
                REMtoWakeTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
            elseif InIntervals(AfterStim(idxTTL{i}(j)),[Start(OBScoring.REMEpoch), End(OBScoring.REMEpoch)])
                REMtoREM(i) = REMtoREM(i) +1;
                REMtoREMTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
            elseif InIntervals(AfterStim(idxTTL{i}(j)),[Start(OBScoring.SWSEpoch), End(OBScoring.SWSEpoch)])
                REMtoSWS(i) = REMtoSWS(i) +1;
                REMtoSWSTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
            end
        end
    end
end

% 
% for i = 1:length(Intensities)
%     for j=1:StimCount(i)
%         if InIntervals(BeforeStim(idxTTL{i}(j)),[Start(AcceleroScoring.SWSEpoch), End(AcceleroScoring.SWSEpoch)]) &&...
%                 InIntervals(AfterStim(idxTTL{i}(j)),[Start(AcceleroScoring.Wake), End(AcceleroScoring.Wake)])
%             SWStoWake(i) = SWStoWake(i)+1;
%             SWStoWakeTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
%         elseif InIntervals(BeforeStim(idxTTL{i}(j)),[Start(AcceleroScoring.REMEpoch), End(AcceleroScoring.REMEpoch)]) &&...
%                 InIntervals(AfterStim(idxTTL{i}(j)),[Start(AcceleroScoring.Wake), End(AcceleroScoring.Wake)])
%             REMtoWake(i) = REMtoWake(i)+1;
%             REMtoWakeTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
%         elseif InIntervals(BeforeStim(idxTTL{i}(j)),[Start(AcceleroScoring.SWSEpoch), End(AcceleroScoring.SWSEpoch)]) &&...
%                 InIntervals(AfterStim(idxTTL{i}(j)),[Start(AcceleroScoring.SWSEpoch), End(AcceleroScoring.SWSEpoch)])
%             SWStoSWS(i) = SWStoSWS(i) +1;
%             SWStoSWSTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
%         elseif InIntervals(BeforeStim(idxTTL{i}(j)),[Start(AcceleroScoring.REMEpoch), End(AcceleroScoring.REMEpoch)]) &&...
%                 InIntervals(AfterStim(idxTTL{i}(j)),[Start(AcceleroScoring.REMEpoch), End(AcceleroScoring.REMEpoch)])
%             REMtoREM(i) = REMtoREM(i) +1;
%             REMtoREMTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
%         elseif InIntervals(BeforeStim(idxTTL{i}(j)),[Start(AcceleroScoring.SWSEpoch), End(AcceleroScoring.SWSEpoch)]) &&...
%                 InIntervals(AfterStim(idxTTL{i}(j)),[Start(AcceleroScoring.REMEpoch), End(AcceleroScoring.REMEpoch)])
%             SWStoREM(i) = SWStoREM(i) +1;
%             SWStoREMTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
%         elseif InIntervals(BeforeStim(idxTTL{i}(j)),[Start(AcceleroScoring.REMEpoch), End(AcceleroScoring.REMEpoch)]) &&...
%                 InIntervals(AfterStim(idxTTL{i}(j)),[Start(AcceleroScoring.SWSEpoch), End(AcceleroScoring.SWSEpoch)])
%             REMtoSWS(i) = REMtoSWS(i) +1;
%             REMtoSWSTime{i}(j) = BeforeStim(idxTTL{i}(j))/1e4/60;
%         end
%     end
% end

for i = 1:length(Intensities)
SWStoWakeTime{i}(SWStoWakeTime{i}==0)=[];
REMtoWakeTime{i}(REMtoWakeTime{i}==0)=[];
SWStoSWSTime{i}(SWStoSWSTime{i}==0)=[];
REMtoREMTime{i}(REMtoREMTime{i}==0)=[];
SWStoREMTime{i}(SWStoREMTime{i}==0)=[];
REMtoSWSTime{i}(REMtoSWSTime{i}==0)=[];
end
