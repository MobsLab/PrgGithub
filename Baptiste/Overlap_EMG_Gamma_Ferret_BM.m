

SleepInfo = GetSleepSessions_Ferret_BM;

for ferret=2%1:2
    if ferret==1
        SESS=[1 2 4 5 9:12];
    elseif ferret==2
        SESS=2:6;%[1 2 4 5 9:12];
    end
    for sess=SESS
        
        cd(SleepInfo.path{ferret}{sess})
        
        load('SleepScoring_OBGamma.mat', 'Epoch', 'SmoothGamma')
        minduration = 3;
        
        % EMG part
        try
            load('ChannelsToAnalyse/EMG.mat', 'channel')
        catch
            if ferret==1
                channel = 12;
            end
        end
        load(['LFPData/LFP' num2str(channel) '.mat'])
        
        LFP = Restrict(LFP , Epoch);
        FilLFP=FilterLFP(LFP,[50 300],1024);
        EMGDataf=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
        
        emg_thresh = GetGammaThresh_BM(Data(EMGDataf), 1);
        
        LowEMG_Epoch = thresholdIntervals(EMGDataf,exp(emg_thresh),'Direction','Below');
        LowEMG_Epoch = mergeCloseIntervals(LowEMG_Epoch, minduration*1e4);
        LowEMG_Epoch = dropShortIntervals(LowEMG_Epoch, minduration*1e4);
        
        HighEMG_Epoch = thresholdIntervals(EMGDataf,exp(emg_thresh),'Direction','Above');
        HighEMG_Epoch = mergeCloseIntervals(HighEMG_Epoch, minduration*1e4);
        HighEMG_Epoch = dropShortIntervals(HighEMG_Epoch, minduration*1e4);
        
        
        % Gamma part
        SmoothGamma = Restrict(SmoothGamma , Epoch);
        gamma_thresh = GetGammaThresh_BM(Data(SmoothGamma), 1);
        
        LowGamma_Epoch = thresholdIntervals(SmoothGamma,exp(gamma_thresh),'Direction','Below');
        LowGamma_Epoch = mergeCloseIntervals(LowGamma_Epoch, minduration*1e4);
        LowGamma_Epoch = dropShortIntervals(LowGamma_Epoch, minduration*1e4);
        
        HighGamma_Epoch = thresholdIntervals(SmoothGamma,exp(gamma_thresh),'Direction','Above');
        HighGamma_Epoch = mergeCloseIntervals(HighGamma_Epoch, minduration*1e4);
        HighGamma_Epoch = dropShortIntervals(HighGamma_Epoch, minduration*1e4);
        
        % Intersection
        Overlap2(ferret,sess) = (sum(DurationEpoch(and(LowGamma_Epoch , LowEMG_Epoch)))+sum(DurationEpoch(and(HighGamma_Epoch , HighEMG_Epoch))))./...
            (sum(DurationEpoch(LowGamma_Epoch)) + sum(DurationEpoch(HighGamma_Epoch)))
        
    end
end

Overlap2(1,[3 6:8])=NaN;
Overlap2(2,1)=NaN;
Overlap2(Overlap2==0)=NaN;

Cols={[.6 .5 .9],[.8 .5 .9]};
X=[1:2];
Legends={'Ferret 1','Ferret 2'};

figure
MakeSpreadAndBoxPlot3_SB({Overlap2(1,:) Overlap2(2,:)},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylabel('Overlap'), ylim([0 1])








