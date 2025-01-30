
%% Drugs

clear all

SleepInfo = GetSleepSessions_Drugs_BM;

EpochName = {'Beginning','Just_Bef_Inj','Just_Aft_Inj','SleepPre','SleepPost','First_Sleep_Aft_Inj','FreezeAccEpoch','MovingEpoch'};
time_aft_inj = 10; % in minutes
smootime = 1;
interp_value = 100;

for drug=[4]
    for mouse=1:size(SleepInfo.path{drug},2)
        
        cd(SleepInfo.path{drug}{mouse})
        
        clear SmoothGamma SmoothAcc Smooth_HR SmoothSpeed Smooth_EMG ep FreezeAccEpoch OB_Sp_tsd HPC_Sp_tsd PFC_Sp_tsd HPC_VHigh_Sp_tsd FilLFP
        
        load('SleepScoring_OBGamma.mat', 'Epoch_Drugs', 'SmoothGamma', 'Sleep','Wake')
        % Gamma
        load('ChannelsToAnalyse/Bulb_deep.mat'); load(['LFPData/LFP' num2str(channel) '.mat'])
        FilGamma=FilterLFP(LFP,[50 70],1024);
        HilGamma=abs(hilbert(Data(FilGamma)));
        smooth_ghi=tsd(Range(FilGamma),runmean_BM(HilGamma,ceil(smootime/median(diff(Range(FilGamma,'s'))))));
        % Accelero
        load('behavResources.mat', 'MovAcctsd')
        SmoothAcc = tsd(Range(MovAcctsd),runmean_BM(Data(MovAcctsd),30));
        % Speed
        load('behavResources.mat', 'Vtsd')
        SmoothSpeed = tsd(Range(Vtsd) , runmean_BM(Data(Vtsd), ceil(smootime/median(diff(Range(Vtsd,'s'))))));
        % Ripples density
        try
            load('SWR.mat', 'ripples', 'RipplesEpoch'), load('LFPData/LFP0.mat')
            tRipples = ts(ripples(:,2)*1e4);
        catch
            tRipples = [];
        end
        tRipples = ts(ripples(:,2)*1e4);
        [Y,X] = hist(Range(tRipples,'s'),[0:1:max(Range(LFP,'s'))]);
        Y = runmean(Y,3);
        SmoothRipDensity = tsd(X'*1E4,Y');
        % OB Low
        load('B_Low_Spectrum.mat')
        OB_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
        
        Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
        Smooth_Respi = tsd(Range(Spectrum_Frequency),runmean_BM(Data(Spectrum_Frequency),ceil(smootime/median(diff(Range(Spectrum_Frequency,'s'))))));
        % HPC Low
        load('H_Low_Spectrum.mat')
        HPC_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});

        
        % Epochs
        Beginning = intervalSet(0 , 10*60e4);
                
        Just_Bef_Inj = intervalSet(Stop(Epoch_Drugs{1})-600e4 , Stop(Epoch_Drugs{1}));
        Just_Aft_Inj = intervalSet(Start(Epoch_Drugs{2}) , Start(Epoch_Drugs{2})+60e4*time_aft_inj);
        
        SleepPre = and(Sleep ,Epoch_Drugs{1});
        SleepPost = and(Sleep , or(Epoch_Drugs{2} , Epoch_Drugs{3}));
        
        ep = find(DurationEpoch(SleepPost)>300e4, 1);
        First_Sleep_Aft_Inj = intervalSet(Start(subset(Sleep,ep)) , Start(subset(Sleep,ep))+300e4);
        
        Wake_Just_Aft_Inj = and(Wake , Just_Aft_Inj);
        FreezeAccEpoch=thresholdIntervals(Restrict(SmoothAcc,Wake_Just_Aft_Inj),1.7e7,'Direction','Below');
        FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
        FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,2*1e4);
        MovingEpoch = Wake_Just_Aft_Inj-FreezeAccEpoch;
        
        for epoch = 1:length(EpochName)
            
            if epoch==1; Epoch_to_use = Beginning;
            elseif epoch==2; Epoch_to_use = Just_Bef_Inj;
            elseif epoch==3; Epoch_to_use = Just_Aft_Inj;
            elseif epoch==4; Epoch_to_use = SleepPre;
            elseif epoch==5; Epoch_to_use = SleepPost;
            elseif epoch==6; Epoch_to_use = First_Sleep_Aft_Inj;
            elseif epoch==7; Epoch_to_use = FreezeAccEpoch;
            elseif epoch==8; Epoch_to_use = MovingEpoch;

            end
           
            
            % Respi
            try
                Respi_evol.(EpochName{epoch}){drug}(mouse,:) = interp1(linspace(0,1,length(Data(Restrict(Smooth_Respi , Epoch_to_use)))) , Data(Restrict(Smooth_Respi , Epoch_to_use)) , linspace(0,1,interp_value));
                Respi_mean.(EpochName{epoch}){drug}(mouse) = nanmean(Data(Restrict(Smooth_Respi , Epoch_to_use)));
            catch
                Respi_evol.(EpochName{epoch}){drug}(mouse,:) = NaN(1,interp_value);
                Respi_mean.(EpochName{epoch}){drug}(mouse) = NaN;
            end
            % Ripples density
            try
                RipDensity_evol.(EpochName{epoch}){drug}(mouse,:) = interp1(linspace(0,1,length(Data(Restrict(SmoothRipDensity , Epoch_to_use)))) , Data(Restrict(SmoothRipDensity , Epoch_to_use)) , linspace(0,1,interp_value));
                RipDensity_mean.(EpochName{epoch}){drug}(mouse) = nanmean(Data(Restrict(SmoothRipDensity , Epoch_to_use)));
            catch
                RipDensity_evol.(EpochName{epoch}){drug}(mouse,:) = NaN(1,interp_value);
                RipDensity_mean.(EpochName{epoch}){drug}(mouse,:) = NaN;
            end
            % Ripples number
            try
                RipDensity_numb.(EpochName{epoch}){drug}(mouse,:) = length(Start(and(RipplesEpoch , Epoch_to_use)));
            catch
                RipDensity_numb.(EpochName{epoch}){drug}(mouse,:) = NaN;
            end
            % OB Low
            try
                OB_Low.(EpochName{epoch}){drug}(mouse,:) = nanmean(Data(Restrict(OB_Sp_tsd , Epoch_to_use)));
            catch
                OB_Low.(EpochName{epoch}){drug}(mouse,:) = NaN(1,261);
            end
            
            % Freeze time
            FreezeTime.(EpochName{epoch}){drug}(mouse) = sum(DurationEpoch(FreezeAccEpoch))/60e4;
        end
        disp([num2str(mouse) ' ' num2str(drug)])
    end
end










