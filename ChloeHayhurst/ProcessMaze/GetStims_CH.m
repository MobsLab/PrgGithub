load('ExpeInfo.mat')

if convertCharsToStrings(ExpeInfo.PreProcessingInfo.TypeOfSystem) == 'Intan'
    % get the channel
    ONOFFChan = find(strcmpi(ExpeInfo.DigID,'ONOFF'));
    STIMChan = find(strcmpi(ExpeInfo.DigID,'STIM'));
    CAMERAChan = find(strcmpi(ExpeInfo.DigID,'CAMERASYNC'));
    STIM2Chan = find(strcmpi(ExpeInfo.DigID,'STIM2'));
    
    
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
    
    %Stim2
    if not(isempty(STIM2Chan))
        load(['LFPData/DigInfo',num2str(STIM2Chan),'.mat'])
        StimEpoch2 = thresholdIntervals(DigTSD,0.9,'Direction','Above');
        
        TTLInfo.StimEpoch2 = StimEpoch2;
        
    else
        
        TTLInfo.StimEpoch2 = intervalSet(0,0.01);
        
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
end




