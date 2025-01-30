function Out = GetSVMDataFromDir_SDS_UmazeComp_SleepSession(Dir)

cd(Dir)
% analyse first three hours
time_start = 0*3600*1e4;
time_end = 3*3600*1e4;

%% Get freezing
if exist('B_High_Spectrum.mat')
    
    load('behavResources.mat', 'MovAcctsd')
    thtps_immob = 2;
    th_immob_Acc = 1.7e7;
    smoofact_Acc = 30;
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
    FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
    FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
    FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
    load('SleepScoring_OBGamma.mat','SleepWiNoise')
    FirstSleep = min(Start(dropShortIntervals(SleepWiNoise,5*1e4)));
    
    GoodEpoch = intervalSet(0,FirstSleep) - SleepWiNoise;
    FreezeAccEpoch = and(FreezeAccEpoch,GoodEpoch);
    
    if sum(Stop(FreezeAccEpoch)-Start(FreezeAccEpoch))>0
        
        Out.FzTime = sum(Stop(FreezeAccEpoch,'s') - Start(FreezeAccEpoch,'s'));
        Out.FzProp = sum(Stop(FreezeAccEpoch,'s') - Start(FreezeAccEpoch,'s'))./(FirstSleep/1e4);
        
        load('SleepScoring_OBGamma.mat','TotalNoiseEpoch')
        TotalNoiseEpoch = CleanUpEpoch(TotalNoiseEpoch);
        FreezeAccEpoch = FreezeAccEpoch-TotalNoiseEpoch;
        
        Out.FzTimeAnalysis = sum(Stop(FreezeAccEpoch,'s') - Start(FreezeAccEpoch,'s'));
        
        %% Get respi frequency
        OB_Low = load('Bulb_deep_Low_Spectrum.mat');
        OB_Low_Sptsd = tsd(OB_Low.Spectro{2}*1e4 , OB_Low.Spectro{1});
        Out.OBSpec_Lo = nanmean(Data(Restrict(OB_Low_Sptsd , FreezeAccEpoch)));
        
        % Get instantaneous frequency
        load('InstFreqAndPhase_B.mat','LocalFreq')
        dat = Data(LocalFreq.WV);
        dat(dat>15) = NaN;
        dat = movmedian(dat,10,'omitnan');
        LocalFreq.WV = Restrict(tsd(Range(LocalFreq.WV),dat),LocalFreq.PT);
        consensusFreq = tsd(Range(LocalFreq.PT),nanmean([Data(LocalFreq.WV),Data(LocalFreq.PT)],2));
        Out.AllInstFreqFz = Data(Restrict(consensusFreq,FreezeAccEpoch));
        
        
        %% Get OB gamma frequency and power
        OB_Hi = load('B_High_Spectrum.mat');
        OB_Hi_Sptsd = tsd(OB_Hi.Spectro{2}*1e4 , OB_Hi.Spectro{1});
        [Spectrum_Frequency , ~] = ConvertSpectrum_in_Frequencies_BM(OB_Hi.Spectro{3} , OB_Hi.Spectro{2}*1e4 , OB_Hi.Spectro{1} , 'frequency_band' , [50 80] , 'bin_size' , 50);
        Out.OBSpec_Hi = nanmean(Data(Restrict(OB_Hi_Sptsd , FreezeAccEpoch)));
        Out.OBGammaFreq = nanmean(Data(Restrict(Spectrum_Frequency , FreezeAccEpoch)));
        try
            load('SleepScoring_OBGamma.mat', 'SmoothGamma')
        end
        Out.OBGammaPower = nanmean(Data(Restrict(SmoothGamma , FreezeAccEpoch)));
        
        if Out.FzTime>0
            subplot(311)
            imagesc(OB_Low.Spectro{2},OB_Low.Spectro{3},log(OB_Low.Spectro{1}')), axis xy
            subplot(325)
            plot(OB_Low.Spectro{3},Out.OBSpec_Lo)
            subplot(312)
            imagesc(OB_Hi.Spectro{2},OB_Hi.Spectro{3},log(OB_Hi.Spectro{1}')), axis xy
            subplot(326)
            plot(OB_Hi.Spectro{3},Out.OBSpec_Hi)
            keyboard
        end
        %% Get ripples density
        if exist('SWR.mat')
            load('SWR.mat', 'tRipples')
            Out.Rip_density = length(Restrict(tRipples , FreezeAccEpoch))/(sum(DurationEpoch(FreezeAccEpoch))/1e4);
        else
            Out.Rip_density = NaN;
        end
        
        %% Sleep properties
        if exist('SleepScoring_Accelero.mat')
            stages_ctrl = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        elseif exist('SleepScoring_OBGamma.mat')
            stages_ctrl= load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
        end
        %%Define different periods of time for quantifications
        EPOI = intervalSet(time_start,time_end); % restrict to this epoch
        Sleep = or(stages_ctrl.SWSEpoch,stages_ctrl.REMEpoch);
        Sleep = and(Sleep,EPOI);
        
        % REM prop
        Out.REMProp = sum(Stop(and(stages_ctrl.REMEpoch,EPOI)) - Start(and(stages_ctrl.REMEpoch,EPOI)))./sum(Stop(Sleep)-Start(Sleep));
        Out.SleepProp = sum(Stop(Sleep) - Start(Sleep))./(time_end - time_start);
        
        
        
    else
        disp('no freezing')
        Out.FzTime = 0;
        Out.FzProp = 0;
        Out.FzTimeAnalysis = 0;
        Out.OBSpec_Lo = nan(1,249);
        Out.OBSpec_Hi = nan(1,32);
        Out.OBGammaFreq = NaN;
        Out.OBGammaPower = NaN;
        Out.Rip_density = NaN;
        Out.AllInstFreqFz = NaN;

        %% Sleep properties
        if exist('SleepScoring_Accelero.mat')
            stages_ctrl = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        elseif exist('SleepScoring_OBGamma.mat')
            stages_ctrl= load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
        end
        %%Define different periods of time for quantifications
        EPOI = intervalSet(time_start,time_end); % restrict to this epoch
        Sleep = or(stages_ctrl.SWSEpoch,stages_ctrl.REMEpoch);
        Sleep = and(Sleep,EPOI);
        
        % REM prop
        Out.REMProp = sum(Stop(and(stages_ctrl.REMEpoch,EPOI)) - Start(and(stages_ctrl.REMEpoch,EPOI)))./sum(Stop(Sleep)-Start(Sleep));
        Out.SleepProp = sum(Stop(Sleep) - Start(Sleep))./(time_end - time_start);
        
    end
else
    
    disp('problem')
    Out.FzTime = NaN;
    Out.FzProp = NaN;
    Out.FzTimeAnalysis = NaN;
    Out.OBSpec_Lo = nan(1,249);
    Out.OBSpec_Hi = nan(1,32);
    Out.OBGammaFreq = NaN;
    Out.OBGammaPower = NaN;
    Out.Rip_density = NaN;
    Out.REMProp = NaN;
    Out.SleepProp = NaN;
    Out.AllInstFreqFz = NaN;
end
end