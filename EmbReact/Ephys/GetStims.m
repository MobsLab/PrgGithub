% Get All the ttls
% Out all the digital inputs in the same format
load('ExpeInfo.mat')

if convertCharsToStrings(ExpeInfo.PreProcessingInfo.TypeOfSystem) == 'Intan'
    % get the channel
    ONOFFChan = find(strcmpi(ExpeInfo.DigID,'ONOFF'));
    STIMChan = find(strcmpi(ExpeInfo.DigID,'STIM'));
    CAMERAChan = find(strcmpi(ExpeInfo.DigID,'CAMERASYNC'));
    SOUNDChan = find(strcmpi(ExpeInfo.DigID,'SOUND'));
    
    
    % correct an old mistake if its there
    if exist('LFPData/DigInfo.mat')>0
        load('LFPData/DigInfo.mat')
        DigTSDold=DigTSD;
        clear DigTSD;
        for k=1:3
            DigTSD=DigTSDold{k};
            save(['LFPData/DigInfo',num2str(k),'.mat'],'DigTSD')
        end
        delete('LFPData/DigInfo.mat')
    end
    
    
    %OnOff
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
    
    %Stim
    if not(isempty(STIMChan))
        load(['LFPData/DigInfo',num2str(STIMChan),'.mat'])
        StimEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
        
        TTLInfo.StimEpoch = StimEpoch;
        
    else
        
        TTLInfo.StimEpoch = intervalSet(0,0.01);
        
    end
    
    %Camera synchronisation
    if not(isempty(CAMERAChan))
        load(['LFPData/DigInfo',num2str(CAMERAChan),'.mat'])
        CamTrigEpo = thresholdIntervals(DigTSD,0.9,'Direction','Above');
        CamTrigTimes = Start(CamTrigEpo);
        
        TTLInfo.CamTrigTimes = CamTrigTimes;
    else
        
        TTLInfo.CamTrigTimes = NaN;
        
    end
    
    % Sound
    if not(isempty(SOUNDChan))
        load(['LFPData/DigInfo',num2str(SOUNDChan),'.mat'])
        SoundEpoch=thresholdIntervals(DigTSD,0.9,'Direction','Above');
        if  strcmp(ExpeInfo.SessionType,'SoundHab')
            SndTimes=Start(SoundEpoch);
            if length(SndTimes)==8
                CSPlusTimes=SndTimes(5:8);
                CSMoinsTimes=SndTimes(1:4);
                if ExpeInfo.nmouse==490
                    CSMoinsTimes=SndTimes(5:8);
                    CSPlusTimes=SndTimes(1:4);
                end
            else
                keyboard
            end
        elseif  strcmp(ExpeInfo.SessionType,'SoundCond')
            SndTimes=Start(SoundEpoch);
            if length(SndTimes)==16
                CSPlusTimes=SndTimes(1:2:end);
                CSMoinsTimes=SndTimes(2:2:end);
            else
                keyboard
            end
        elseif  strcmp(ExpeInfo.SessionType,'SoundTest')
            SndTimes=Start(SoundEpoch);
            if length(SndTimes)==16
                CSPlusTimes=SndTimes(5:16);
                CSMoinsTimes=SndTimes(1:4);
                if ExpeInfo.nmouse==437
                    CSPlusTimes=SndTimes([5:8,13:16]);
                    CSMoinsTimes=SndTimes([1:4,9:12]);
                end
            else
                keyboard
            end
        else
            CSMoinsTimes=[];CSPlusTimes=[];
        end
        
        TTLInfo.SoundEpoch=SoundEpoch;
        TTLInfo.CSMoinsTimes=CSMoinsTimes;
        TTLInfo.CSPlusTimes=CSPlusTimes;
        
    else
        
        TTLInfo.SoundEpoch = intervalSet(0,0.01);
        TTLInfo.CSMoinsTimes=[];
        TTLInfo.CSPlusTimes=[];
        
    end
end




