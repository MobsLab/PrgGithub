function Out = GetSVMDataFromDir_SDS_UmazeComp(Dir)

cd(Dir)
if exist('B_High_Spectrum.mat')

%% Get freezing
load('behavResources.mat', 'MovAcctsd')
thtps_immob = 2;
th_immob_Acc = 1.7e7;
smoofact_Acc = 30;
NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
Out.FzTime = sum(Stop(FreezeAccEpoch,'s') - Start(FreezeAccEpoch,'s'));
Out.FzProp = (sum(Stop(FreezeAccEpoch,'s') - Start(FreezeAccEpoch,'s')))/max(Range(NewMovAcctsd,'s'));

if sum(Stop(FreezeAccEpoch)-Start(FreezeAccEpoch))>0
    
    try
        load('StateEpochSB.mat','TotalNoiseEpoch')
        TotalNoiseEpoch
    catch
        disp('no noise')
        keyboard
        
        load('StateEpochSB.mat','TotalNoiseEpoch')
        
    end
    TotalNoiseEpoch = CleanUpEpoch(TotalNoiseEpoch);
    FreezeAccEpoch = FreezeAccEpoch-TotalNoiseEpoch;
    Out.FzTimeAnalysis = sum(Stop(FreezeAccEpoch,'s') - Start(FreezeAccEpoch,'s'));
    
    
    %% Get respi frequency
    OB_Low = load('Bulb_deep_Low_Spectrum.mat');
    OB_Low_Sptsd = tsd(OB_Low.Spectro{2}*1e4 , OB_Low.Spectro{1});
    Out.OBSpec_Lo = nanmean(Data(Restrict(OB_Low_Sptsd , FreezeAccEpoch)));
%     if Out.FzTime>0
%         subplot(311)
%         imagesc(OB_Low.Spectro{2},OB_Low.Spectro{3},log(OB_Low.Spectro{1}')), axis xy
%         subplot(325)
%         plot(OB_Low.Spectro{3},Out.OBSpec_Lo)
%         
%     end

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
        load('StateEpochSB.mat', 'SmoothGamma')
    end
    Out.OBGammaPower = nanmean(Data(Restrict(SmoothGamma , FreezeAccEpoch)));
    
%     if Out.FzTime>0
%         subplot(312)
%         imagesc(OB_Hi.Spectro{2},OB_Hi.Spectro{3},log(OB_Hi.Spectro{1}')), axis xy
%         subplot(326)
%         plot(OB_Hi.Spectro{3},Out.OBSpec_Hi)
%         keyboard
%     end
    
    %% Get ripples density
    if exist('SWR.mat')
        load('SWR.mat', 'tRipples')
        Out.Rip_density = length(Restrict(tRipples , FreezeAccEpoch))/(sum(DurationEpoch(FreezeAccEpoch))/1e4);
    else
        Out.Rip_density = NaN;
    end
    
else
    disp('no freezing')
       Out.FzProp = 0;
 Out.FzTime = 0;
    Out.FzTimeAnalysis = 0;
    Out.OBSpec_Lo = nan(1,249);
    Out.OBSpec_Hi = nan(1,32);
    Out.OBGammaFreq = NaN;
    Out.OBGammaPower = NaN;
    Out.Rip_density = NaN;
    Out.AllInstFreqFz = NaN;
end
else
    disp('problem')
    Out.FzProp = NaN;
    Out.FzTime = NaN;
    Out.FzTimeAnalysis = NaN;
    Out.OBSpec_Lo = nan(1,249);
    Out.OBSpec_Hi = nan(1,32);
    Out.OBGammaFreq = NaN;
    Out.OBGammaPower = NaN;
    Out.Rip_density = NaN;
        Out.AllInstFreqFz = NaN;

end

end