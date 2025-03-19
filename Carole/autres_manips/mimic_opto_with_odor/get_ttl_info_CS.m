% Get All the ttls
clear all
% get the channel
ONOFFChan = 1;
CAMERAChan = 2;
SHOCKChan=3;
TONEChan=4;
WNChan=5;
MOTORChanA=6;
MOTORChanB=7;



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

% %Stim
% if not(isempty(STIMChan))
%     load(['LFPData/DigInfo',num2str(STIMChan),'.mat'])
%     StimEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
%     
%     TTLInfo.StimEpoch = StimEpoch;
%     
% else
%     
%     TTLInfo.StimEpoch = intervalSet(0,0.01);
%     
% end



% TONEChan=4;
% WNChan=5;
% MOTORChanA=6;
% MOTORChanB=7;


%% sounds
if not(isempty(TONEChan))
    load(['LFPData/DigInfo',num2str(TONEChan),'.mat'])
    ToneTrigEpo = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    ToneTrigTimes = Start(ToneTrigEpo);
else
    ToneTrigTimes = NaN;
end

if not(isempty(WNChan))
    load(['LFPData/DigInfo',num2str(WNChan),'.mat'])
    WNTrigEpo = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    WNTrigTimes = Start(WNTrigEpo);
else
    WNTrigTimes = NaN;
end


if ToneTrigTimes(1)<WNTrigTimes(1) % tone=CSmoins
    TTLInfo.CSMoinsAllTrigTimes = ToneTrigTimes;
    TTLInfo.CSPlusAllTrigTimes = WNTrigTimes;
else % tone=CSplus
    TTLInfo.CSMoinsAllTrigTimes = WNTrigTimes;
    TTLInfo.CSPlusAllTrigTimes = ToneTrigTimes; 
end

CSMoinsTimes=[TTLInfo.CSMoinsAllTrigTimes(1)];
for i=2:length(TTLInfo.CSMoinsAllTrigTimes)-1
    if TTLInfo.CSMoinsAllTrigTimes(i)-TTLInfo.CSMoinsAllTrigTimes(i-1)>2*1e4
        CSMoinsTimes=[CSMoinsTimes TTLInfo.CSMoinsAllTrigTimes(i)];
    end
end

CSPlusTimes=[TTLInfo.CSPlusAllTrigTimes(1)];
for i=2:length(TTLInfo.CSPlusAllTrigTimes)-1
    if TTLInfo.CSPlusAllTrigTimes(i)-TTLInfo.CSPlusAllTrigTimes(i-1)>2*1e4
        CSPlusTimes=[CSPlusTimes TTLInfo.CSPlusAllTrigTimes(i)];
    end
end

TTLInfo.CSMoinsTimes = CSMoinsTimes;
TTLInfo.CSPlusTimes = CSPlusTimes; 

%% motor
if not(isempty(MOTORChanA))
    load(['LFPData/DigInfo',num2str(MOTORChanA),'.mat'])
    MotorATrigEpo = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    MotorATrigTimes = Start(MotorATrigEpo);
else
    MotorATrigTimes = NaN;
end

if not(isempty(MOTORChanB))
    load(['LFPData/DigInfo',num2str(MOTORChanB),'.mat'])
    MotorBTrigEpo = thresholdIntervals(DigTSD,0.9,'Direction','Above');
    MotorBTrigTimes = Start(MotorBTrigEpo);
else
    MotorBTrigTimes = NaN;
end


if MotorATrigTimes(1)<MotorBTrigTimes(1) % A=ouverture
    TTLInfo.MotorOnTrigTimes = MotorATrigTimes;
    TTLInfo.MotorOffTrigTimes = MotorBTrigTimes;
else % B=ouverture
    TTLInfo.MotorOnTrigTimes = MotorBTrigTimes;
    TTLInfo.MotorOffTrigTimes = MotorATrigTimes; 
end

%%

% % Sound
% if not(isempty(SOUNDChan))
%     load(['LFPData/DigInfo',num2str(SOUNDChan),'.mat'])
%     SoundEpoch=thresholdIntervals(DigTSD,0.9,'Direction','Above');
%     if  strcmp(ExpeInfo.SessionType,'SoundHab')
%         SndTimes=Start(SoundEpoch);
%         if length(SndTimes)==8
%             CSPlusTimes=SndTimes(5:8);
%             CSMoinsTimes=SndTimes(1:4);
%             if ExpeInfo.nmouse==490
%                 CSMoinsTimes=SndTimes(5:8);
%                 CSPlusTimes=SndTimes(1:4);
%             end
%         else
%             keyboard
%         end
%     elseif  strcmp(ExpeInfo.SessionType,'SoundCond')
%         SndTimes=Start(SoundEpoch);
%         if length(SndTimes)==16
%             CSPlusTimes=SndTimes(1:2:end);
%             CSMoinsTimes=SndTimes(2:2:end);
%         else
%             keyboard
%         end
%     elseif  strcmp(ExpeInfo.SessionType,'SoundTest')
%         SndTimes=Start(SoundEpoch);
%         if length(SndTimes)==16
%             CSPlusTimes=SndTimes(5:16);
%             CSMoinsTimes=SndTimes(1:4);
%             if ExpeInfo.nmouse==437
%                 CSPlusTimes=SndTimes([5:8,13:16]);
%                 CSMoinsTimes=SndTimes([1:4,9:12]);
%             end
%         else
%             keyboard
%         end
%     else
%         CSMoinsTimes=[];CSPlusTimes=[];
%     end
%     
%     TTLInfo.SoundEpoch=SoundEpoch;
%     TTLInfo.CSMoinsTimes=CSMoinsTimes;
%     TTLInfo.CSPlusTimes=CSPlusTimes;
%     
% else
%     
%     TTLInfo.SoundEpoch = intervalSet(0,0.01);
%     TTLInfo.CSMoinsTimes=[];
%     TTLInfo.CSPlusTimes=[];
%     
% end
% 
% 
% 
% 
% 

save('TTLInfo','TTLInfo')
