% Get All the ttls
clear all
% get the channel
ONOFFChan = 1;
CAMERAChan = 2;
SHOCKChan=3;

mouse_num=891;
path=strcat('/media/mobschapeau/09E7077B1FE07CCB/DREADD/', num2str(mouse_num), '/cond/day1_hab_cond/cond');
cd(path)

%% OnOff
if not(isempty(ONOFFChan))
    load(['LFPData/DigInfo',num2str(ONOFFChan),'.mat'])
    UpEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    StartSession = Start(UpEpoch);
    StopSession = Stop(UpEpoch);
    
    TTLInfo.StartSession = StartSession;
    TTLInfo.StopSession = StopSession;   
else
    TTLInfo.StartSession = NaN;
    TTLInfo.StopSession = NaN; 
end


%% Camera synchronisation
if not(isempty(CAMERAChan))
    load(['LFPData/DigInfo',num2str(CAMERAChan),'.mat'])
    CamTrigEpo = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    CamTrigTimes = Start(CamTrigEpo);
    TTLInfo.CamTrigTimes = CamTrigTimes;
else
    TTLInfo.CamTrigTimes = NaN;
end

%% shock
if not(isempty(SHOCKChan))
    load(['LFPData/DigInfo',num2str(SHOCKChan),'.mat'])
    ShockTrigEpo = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    ShockTrigTimes = Start(ShockTrigEpo);
    TTLInfo.ShockTrigTimes = ShockTrigTimes;
else
    TTLInfo.ShockTrigTimes = NaN;
end

%% sounds
load('ExpeInfo.mat')
ToneChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'CS+Tone')));
load(['LFPData/DigInfo',num2str(ToneChannel),'.mat']);
ToneEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
AllToneTTL = Start(ToneEpoch);
AllToneTTL_bon=AllToneTTL*1e-4;
AllToneTTL=AllToneTTL_bon;

%Cs-

WNChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'CS-WN')));
load(['LFPData/DigInfo',num2str(WNChannel),'.mat']);
WNEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
AllWNTTL = Start(WNEpoch);
AllWNTTL_bon=AllWNTTL*1e-4;
AllWNTTL=AllWNTTL_bon;


TTLInfo.AllToneTTL=AllToneTTL;
TTLInfo.AllWNTTL=AllWNTTL;

CSMoinsTTL=[AllWNTTL(1)];
for k=2:length(AllWNTTL)-1
    if AllWNTTL(k)-AllWNTTL(k-1)>2
       CSMoinsTTL=[CSMoinsTTL; AllWNTTL(k)];
    end
end

CSPlusTTL=[AllToneTTL(1)];
for k=2:length(AllToneTTL)-1
    if AllToneTTL(k)-AllToneTTL(k-1)>2
        CSPlusTTL=[CSPlusTTL; AllToneTTL(k)];
    end
end

TTLInfo.CSMoinsTTL=CSMoinsTTL;
TTLInfo.CSPlusTTL=CSPlusTTL;

save(strcat('behavResources-',num2str(mouse_num),'.mat'),'TTLInfo','-append');

%% epoch

Epoch.CSPlus1=intervalSet(TTLInfo.CSPlusTTL(1:4)*1e4, TTLInfo.CSPlusTTL(1:4)*1e4+30*1e4);
Epoch.CSPlus2=intervalSet(TTLInfo.CSPlusTTL(5:8)*1e4, TTLInfo.CSPlusTTL(5:8)*1e4+30*1e4);

Epoch.CSMoins1=intervalSet(TTLInfo.CSMoinsTTL(1:4)*1e4, TTLInfo.CSMoinsTTL(1:4)*1e4+30*1e4);
Epoch.CSMoins2=intervalSet(TTLInfo.CSMoinsTTL(5:8)*1e4, TTLInfo.CSMoinsTTL(5:8)*1e4+30*1e4);


%% determiner le threshold de freezing


load(strcat('behavResources-',num2str(mouse_num),'.mat'));
plot(Range(Imdifftsd,'s'),Data(Imdifftsd))
hist(Data(Imdifftsd),[0:50])
th=20
FreezeEpoch=thresholdIntervals(Imdifftsd,th,'Direction','Below');
FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.4*1E4);
FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);

Epoch.All_Freeze=FreezeEpoch;

save('Epoch', 'Epoch');
