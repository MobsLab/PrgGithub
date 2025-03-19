% 'SoundHab' 'SoundCond' 'SoundTest' 'SoundTestPlethysmo'

Sessions = {'SoundHab' ,'SoundTest', 'SoundTestPlethysmo'};

for ss = 3 :length(Sessions)
    
    Dir=PathForExperimentsMtzlProject(Sessions{ss})
    for d = 1:length(Dir.path)
        cd(Dir.path{d}{1})
        disp(Dir.path{d}{1})
        
        % get freezing
        load('behavResources.mat')
        thtps_immob=2;
        smoofact_Acc = 30;
        th_immob_Acc = 10000000;
        if exist('MovAcctsd')>0
            NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
            FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
            FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
            FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
        end
        save('behavResources.mat','FreezeAccEpoch','NewMovAcctsd','-append','smoofact_Acc','th_immob_Acc','thtps_immob','-append')
        
        % get stim times
        load('ExpeInfo.mat')
        ExpeInfo.DigID{5} = 'CS-';
        ExpeInfo.DigID{4} = 'CS+';
        save('ExpeInfo.mat','ExpeInfo','-append')
        
        CSMinusChan= 5 ;
        CSPlusChan = 4;
        ONOFFChan = find(strcmpi(ExpeInfo.DigID,'ONOFF'));
        STIMChan = find(strcmpi(ExpeInfo.DigID,'STIM'));
        
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
        
        
        %SC+
        if not(isempty(CSPlusChan))
            load(['LFPData/DigInfo',num2str(CSPlusChan),'.mat'])
            StimEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
            
            TTLInfo.CSplus = StimEpoch;
            
        else
            
            TTLInfo.CSplus = intervalSet(0,0.01);
            
        end
        
        %SC-
        if not(isempty(CSMinusChan))
            load(['LFPData/DigInfo',num2str(CSMinusChan),'.mat'])
            StimEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
            
            TTLInfo.CSMinus = StimEpoch;
            
        else
            
            TTLInfo.CSMinus = intervalSet(0,0.01);
            
        end
        
        save('behavResources.mat','TTLInfo','-append')
        
        % get spectra and coherence
        clear OBChan PFCChan RespiChan HPCChan
        clear channel
        load('ChannelsToAnalyse/Bulb_deep.mat')
        channel;
        OBChan = channel;
        
        if exist('B_Low_Spectrum.mat')==0
            disp('calculating OB')
            LowSpectrumSB([cd filesep],channel,'B')
            HighSpectrum([cd filesep],channel,'B');
        end
        
        if  exist('ChannelsToAnalyse/Respi.mat')>0
            clear channel
            load('ChannelsToAnalyse/Respi.mat')
            channel;
            RespiChan = channel;
            if exist('Respi_Low_Spectrum.mat')==0
                disp('calculating Respi')
                LowSpectrumSB([cd filesep],channel,'Respi')
                HighSpectrum([cd filesep],channel,'Respi');
            end
        end
        
        clear channel
        try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
            try,load('ChannelsToAnalyse/dHPC_deep.mat'),
            catch
                try,load('ChannelsToAnalyse/dHPC_sup.mat'),
                end
            end
        end
        channel;
        HPCChan = channel;
        
        if exist('H_Low_Spectrum.mat')==0
            disp('calculating H')
            LowSpectrumSB([cd filesep],channel,'H')
        end
        
        if exist('H_VHigh_Spectrum')==0
            disp('calculating H_high')
            clear channel
            try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
                try,load('ChannelsToAnalyse/dHPC_sup.mat'),
                catch
                    try,load('ChannelsToAnalyse/dHPC_deep.mat'),
                    end
                end
            end
            channel;
            VeryHighSpectrum([cd filesep],channel,'H')
        end
        
        try
        clear channel
        load('ChannelsToAnalyse/PFCx_deep.mat')
        channel;
        PFCChan = channel;
        if exist('PFCx_Low_Spectrum.mat')==0
            disp('calculating PFC')
            LowSpectrumSB([cd filesep],channel,'PFCx')
        end
        catch
            PFCChan = NaN;
        end
        
        if exist('ChannelsToAnalyse/Respi.mat')>0
            LowCohgramSB([cd filesep],RespiChan,'Respi',OBChan,'B', 0)
            LowCohgramSB([cd filesep],RespiChan,'Respi',HPCChan,'H', 0)
            LowCohgramSB([cd filesep],RespiChan,'Respi',PFCChan,'PFCx', 0)
        end
        
        LowCohgramSB([cd filesep],PFCChan,'PFCx',OBChan,'B', 0)
        LowCohgramSB([cd filesep],HPCChan,'H',OBChan,'B', 0)
        LowCohgramSB([cd filesep],PFCChan,'PFCx',HPCChan,'H', 0)
        
    end
    
end