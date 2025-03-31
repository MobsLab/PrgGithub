% DensityDeltaToneRealTime
% 01.12.2016 KJ
%
% collect data about the density of data, function of the real time of the day.
% 
% 
%   see  
%



% Dir1 = PathForExperimentsDeltaWavesTone('Basal');
% for p=1:length(Dir1.path)
%     Dir1.delay{p}=0;
% end
% Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
% Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
% Dir = MergePathForExperiment(Dir2,Dir3);
% Dir = MergePathForExperiment(Dir1,Dir);

Dir1 = PathForExperimentsDeltaKJHD('Basal');
for p=1:length(Dir1.path)
    Dir1.delay{p}=0;
end
Dir2 = PathForExperimentsDeltaKJHD('RdmTone');
Dir3 =PathForExperimentsDeltaKJHD('DeltaToneAll');
Dir = MergePathForExperiment(Dir2,Dir3);
Dir = MergePathForExperiment(Dir1,Dir);
clear Dir1 Dir2 Dir3

%params
binsize_density = 60E4; % 60s

%% 
p=10;

disp(' ')
disp('****************************************************************')
eval(['cd(Dir.path{',num2str(p),'}'')'])
disp(pwd)

%load
clear Down DeltaOffline ToneEvent 
%tones
try
    load('DeltaSleepEvent.mat', 'TONEtime1')
    delay = Dir.delay{p}*1E4;
    tEvents = ts(TONEtime1 + delay);
    leg_event = 'Tones';
catch
    load('ShamSleepEvent.mat', 'SHAMtime')
    tEvents = SHAMtime;
    leg_event = 'Shams';
end

%Down states
try
    load newDownState Down
catch
    try
        load DownSpk Down
    catch
        Down = intervalSet([],[]);
    end
end
tdowns = (Start(Down)+End(Down))/2;
%Delta waves
try
    load DeltaPFCx DeltaOffline
catch
    load newDeltaPFCx DeltaEpoch
    DeltaOffline = DeltaEpoch;
    clear DeltaEpoch
end
tdeltas = (Start(DeltaOffline)+End(DeltaOffline))/2;

%Times will be convert in seconds or 1E-4s
load behavResources TimeDebRec TimeEndRec
start_time = TimeDebRec(1,1)*3600 + TimeDebRec(1,2)*60 + TimeDebRec(1,3); %start time in sec

%% Density

%delta density
ST1{1}=ts(tdeltas);
try
    ST1=tsdArray(ST1);
end
QDelta = MakeQfromS(ST1,binsize_density);
QDelta = tsd(Range(QDelta) + start_time*1E4,full(Data(QDelta)));
clear ST
%down density
ST1{1}=ts(tdowns);
try
    ST1=tsdArray(ST1);
end
QDown = MakeQfromS(ST1,binsize_density);
QDown = tsd(Range(QDown) + start_time*1E4,full(Data(QDown)));
clear ST

%tone/sham density
ST1{1}=tEvents;
try
    ST1=tsdArray(ST1);
end
Qevents = MakeQfromS(ST1,binsize_density);
Qevents = tsd(Range(Qevents) + start_time*1E4,full(Data(Qevents)));
clear ST


%% Plot Figure
figure, hold on,
smoothing=1;

yyaxis left
plot(Range(QDelta,'s')/3600,SmoothDec(Data(QDelta),smoothing),'-',  'color','k'), hold on,
plot(Range(QDown,'s')/3600,SmoothDec(Data(QDown),smoothing),'--',  'color','r'), hold on,

yyaxis right
plot(Range(Qevents,'s')/3600,SmoothDec(Data(Qevents),smoothing),'-',  'color','b'), hold on,

legend('Delta', 'Down', leg_event), hold on,
xlim([TimeDebRec(1,1) TimeEndRec(end,1)+1]), hold on,
xlabel('Time (h)'),title('Density of events'), 



