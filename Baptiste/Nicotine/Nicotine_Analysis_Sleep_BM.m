
%% Drugs

clear all

SleepInfo = GetSleepSessions_Drugs_BM;

EpochName = {'Beginning','Just_Bef_Inj','Just_Aft_Inj','SleepPre','SleepPost','First_Sleep_Aft_Inj','FreezeAccEpoch','MovingEpoch'};
time_aft_inj = 10; % in minutes
smootime = 1;
interp_value = 100;

for drug=[1 4]
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
        % Heart rate
        try
            load('HeartBeatInfo.mat')
            Smooth_HR = tsd(Range(EKG.HBRate) , runmean_BM(Data(EKG.HBRate), ceil(smootime/median(diff(Range(EKG.HBRate,'s'))))));
        catch
            Smooth_HR = tsd(NaN,NaN);
        end
        % EMG
        try
            load('ChannelsToAnalyse/EMG.mat'); load(['LFPData/LFP' num2str(channel) '.mat'])
            FilLFP=FilterLFP(LFP,[50 300],1024);
            Smooth_EMG=tsd(Range(FilLFP),runmean_BM(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
        catch
            Smooth_EMG = tsd(Range(EKG.HBRate) , NaN(length(Range(EKG.HBRate)),1));
        end
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
        % PFC Low
        load('PFCx_Low_Spectrum.mat')
        PFC_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
        % OB High
        load('B_High_Spectrum.mat')
        OB_High_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
        % HPC Very High
        try
%             load('H_VHigh_Spectrum.mat')
%             HPC_VHigh_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
        end
        
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
            
            % Gamma
            try
                Gamma_evol.(EpochName{epoch}){drug}(mouse,:) = interp1(linspace(0,1,length(Data(Restrict(SmoothGamma , Epoch_to_use)))) , log(Data(Restrict(SmoothGamma , Epoch_to_use))) , linspace(0,1,interp_value));
                Gamma_mean.(EpochName{epoch}){drug}(mouse) = nanmean(Data(Restrict(SmoothGamma , Epoch_to_use)));
            catch
                Gamma_evol.(EpochName{epoch}){drug}(mouse,:) = NaN(1,interp_value);
                Gamma_mean.(EpochName{epoch}){drug}(mouse) = NaN;
            end
            % Accelero
            try
                Acc_evol.(EpochName{epoch}){drug}(mouse,:) = interp1(linspace(0,1,length(Data(Restrict(SmoothAcc , Epoch_to_use)))) , log(Data(Restrict(SmoothAcc , Epoch_to_use))) , linspace(0,1,interp_value));
                Acc_mean.(EpochName{epoch}){drug}(mouse) = nanmean(Data(Restrict(SmoothAcc , Epoch_to_use)));
            catch
                Acc.(EpochName{epoch}){drug}(mouse,:) = NaN(1,interp_value);
                Acc_mean.(EpochName{epoch}){drug}(mouse) = NaN;
            end
            % Speed
            try
                Speed_evol.(EpochName{epoch}){drug}(mouse,:) = interp1(linspace(0,1,length(Data(Restrict(SmoothSpeed , Epoch_to_use)))) , Data(Restrict(SmoothSpeed , Epoch_to_use)) , linspace(0,1,interp_value));
                Speed_mean.(EpochName{epoch}){drug}(mouse) = nanmean(Data(Restrict(SmoothSpeed , Epoch_to_use)));
            catch
                Speed_evol.(EpochName{epoch}){drug}(mouse,:) = NaN(1,interp_value);
                Speed_mean.(EpochName{epoch}){drug}(mouse,:) = NaN;
            end
            % Heart rate
            try
                HR_evol.(EpochName{epoch}){drug}(mouse,:) = interp1(linspace(0,1,length(Data(Restrict(Smooth_HR , Epoch_to_use)))) , Data(Restrict(Smooth_HR , Epoch_to_use)) , linspace(0,1,interp_value));
                HR_mean.(EpochName{epoch}){drug}(mouse) = nanmean(Data(Restrict(Smooth_HR , Epoch_to_use)));
            catch
                HR_evol.(EpochName{epoch}){drug}(mouse,:) = NaN(1,interp_value);
                HR_mean.(EpochName{epoch}){drug}(mouse) = NaN;
            end
            % EMG
            try
                EMG_evol.(EpochName{epoch}){drug}(mouse,:) = interp1(linspace(0,1,length(Data(Restrict(Smooth_EMG , Epoch_to_use)))) , Data(Restrict(Smooth_EMG , Epoch_to_use)) , linspace(0,1,interp_value));
                EMG_mean.(EpochName{epoch}){drug}(mouse) = nanmean(Data(Restrict(Smooth_EMG , Epoch_to_use)));
            catch
                EMG_evol.(EpochName{epoch}){drug}(mouse,:) = NaN(1,interp_value);
                EMG_mean.(EpochName{epoch}){drug}(mouse) = NaN;
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
            % Ripples mean waveform
            load('ChannelsToAnalyse/dHPC_rip.mat','channel'), load(['LFPData/LFP' num2str(channel) '.mat'])
            LFP = Restrict(LFP , Epoch_to_use);
            try
                [M,T] = PlotRipRaw(LFP , ripples(:,2), 50, 0, 0);
                Mean_Ripples.(EpochName{epoch}){drug}(mouse,:) = M(:,2);
            end
            % OB Low
            try
                OB_Low.(EpochName{epoch}){drug}(mouse,:) = nanmean(Data(Restrict(OB_Sp_tsd , Epoch_to_use)));
            catch
                OB_Low.(EpochName{epoch}){drug}(mouse,:) = NaN(1,261);
            end
            % HPC Low
            try
                HPC_Low.(EpochName{epoch}){drug}(mouse,:) = nanmean(Data(Restrict(HPC_Sp_tsd , Epoch_to_use)));
            catch
                HPC_Low.(EpochName{epoch}){drug}(mouse,:) = NaN(1,261);
            end
            % PFC Low
            try
                PFC_Low.(EpochName{epoch}){drug}(mouse,:) = nanmean(Data(Restrict(PFC_Sp_tsd , Epoch_to_use)));
            catch
                PFC_Low.(EpochName{epoch}){drug}(mouse,:) = NaN(1,261);
            end
            % OB High
            try
                OB_High.(EpochName{epoch}){drug}(mouse,:) = nanmean(Data(Restrict(OB_High_Sp_tsd , Epoch_to_use)));
            catch
                OB_High.(EpochName{epoch}){drug}(mouse,:) = NaN(1,261);
            end
            % HPC VHigh
%             try
%                 HPC_VHigh.(EpochName{epoch}){drug}(mouse,:) = nanmean(Data(Restrict(HPC_VHigh_Sp_tsd , Epoch_to_use)));
%                 if isnan(nanmean(Data(Restrict(Restrict(HPC_VHigh_Sp_tsd , Epoch_to_use),RipplesEpoch))))
%                     HPC_VHigh_OnRipples.(EpochName{epoch}){drug}(mouse,:) = NaN(1,94);
%                 else
%                     HPC_VHigh_OnRipples.(EpochName{epoch}){drug}(mouse,:) = nanmean(Data(Restrict(Restrict(HPC_VHigh_Sp_tsd , Epoch_to_use),RipplesEpoch)));
%                 end
%             catch
%                 HPC_VHigh.(EpochName{epoch}){drug}(mouse,:) = NaN(1,94);
%                 HPC_VHigh_OnRipples.(EpochName{epoch}){drug}(mouse,:) = NaN(1,94);
%             end
            
            % Spectrograms
            if epoch==3 % only for after injection
                
                OB_Sp.(EpochName{epoch}){drug}(mouse,:,:) = Restrict(OB_Sp_tsd , Epoch_to_use);
                HPC_Sp.(EpochName{epoch}){drug}(mouse,:,:) = Restrict(HPC_Sp_tsd , Epoch_to_use);
                PFC_Sp.(EpochName{epoch}){drug}(mouse,:,:) = Restrict(PFC_Sp_tsd , Epoch_to_use);                
                OB_High_Sp.(EpochName{epoch}){drug}(mouse,:,:) = Restrict(OB_High_Sp_tsd , Epoch_to_use);
                
            end
            
            % Freeze time
            FreezeTime.(EpochName{epoch}){drug}(mouse) = sum(DurationEpoch(FreezeAccEpoch))/60e4;
        end
        disp([num2str(mouse) ' ' num2str(drug)])
    end
end



%% Spectrograms after injection
% clear all


smootime=1; time_aft_inj=10;
for drug=1:2
    for mouse=1:size(SleepInfo.path{drug},2)
        
        cd(SleepInfo.path{drug}{mouse})
        
        clear Spectro Epoch_Drugs
        
        load('SleepScoring_OBGamma.mat', 'Epoch_Drugs')
        Just_Aft_Inj = intervalSet(Start(Epoch_Drugs{2}) , Start(Epoch_Drugs{2})+60e4*time_aft_inj);
        
        load('B_Low_Spectrum.mat')
        OB_Sp_tsd{drug,mouse} = tsd(Spectro{2}*1e4 , Spectro{1});
        load('H_Low_Spectrum.mat')
        HPC_Sp_tsd{drug,mouse} = tsd(Spectro{2}*1e4 , Spectro{1});
        load('behavResources.mat', 'Vtsd', 'MovAcctsd')
        SmoothSpeed{drug,mouse} = tsd(Range(Vtsd) , runmean_BM(Data(Vtsd), ceil(smootime/median(diff(Range(Vtsd,'s'))))));
        SmoothAcc{drug,mouse} = tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),30));
        Epoch_Drugs_all{drug,mouse} = Epoch_Drugs;
        
        OB_Sp_AftInj{drug,mouse} = Restrict(OB_Sp_tsd{drug,mouse} , Just_Aft_Inj);
        HPC_Sp_AftInj{drug,mouse} = Restrict(HPC_Sp_tsd{drug,mouse} , Just_Aft_Inj);
        
        
        disp(mouse)
    end
end


for drug=1:2
    for mouse=1:size(SleepInfo.path{drug},2)
        
        clear D; D = Spectro{3}.*Data(OB_Sp_AftInj{drug,mouse});
        OB_Sp_AftInj_all{drug}(mouse,:,:) = log(D./mean(mean(D(:,13:131))));
         
        clear D; D = Spectro{3}.*Data(HPC_Sp_AftInj{drug,mouse});
        HPC_Sp_AftInj_all{drug}(mouse,:,:) = log(D./mean(mean(D(:,13:131))));
        
        HPC_Sp_AftInj_all{drug}(mouse,:) = Data(SmoothAcc{drug,mouse};
        
    end
end


figure
subplot(211)
imagesc(linspace(0,10,3e3) , Spectro{3} , runmean(runmean(squeeze(mean(OB_Sp_AftInj_all{1})),30)',5)), axis xy
ylabel('Frequency (Hz)'), ylim([0 15]), caxis([-3 1.5]), makepretty
title('Saline, n=5')

subplot(212)
imagesc(linspace(0,10,3e3) , Spectro{3} , runmean(runmean(squeeze(mean(OB_Sp_AftInj_all{2})),30)',5)), axis xy
ylabel('Frequency (Hz)'), xlabel('time (min)'), ylim([0 15]), caxis([-3 1]), makepretty
title('Nicotine, n=7')

a=suptitle('OB Low spectrograms after injection'); a.FontSize=20;



figure
subplot(211)
imagesc(linspace(0,10,3e3) , Spectro{3} , runmean(runmean(squeeze(mean(HPC_Sp_AftInj_all{1})),30)',5)), axis xy
ylabel('Frequency (Hz)'), ylim([0 15]), caxis([-3 1.5]), makepretty
title('Saline, n=5')

subplot(212)
imagesc(linspace(0,10,3e3) , Spectro{3} , runmean(runmean(squeeze(mean(HPC_Sp_AftInj_all{2})),30)',5)), axis xy
ylabel('Frequency (Hz)'), xlabel('time (min)'), ylim([0 15]), caxis([-3 1]), makepretty
title('Nicotine, n=7')

a=suptitle('OB Low spectrograms after injection'); a.FontSize=20;




% 
% clear all

GetSleepSessions_Drugs_BM

EpochName = {'Beginning','Just_Bef_Inj','Just_Aft_Inj','SleepPre','SleepPost','First_Sleep_Aft_Inj','FreezeAccEpoch','MovingEpoch'};
time_aft_inj = 15; % in minutes
smootime = 1;
interp_value = 100;

for drug=1
    for mouse=4:size(SleepInfo.path{drug},2)
        
        cd(SleepInfo.path{drug}{mouse})
        
        clear Just_Aft_Inj Epoch_Drugs SmoothGamma Sleep Wake
        
        load('SleepScoring_OBGamma.mat', 'Epoch_Drugs')
        Just_Aft_Inj = intervalSet(Start(Epoch_Drugs{2}) , Start(Epoch_Drugs{2})+60e4*time_aft_inj);
        % Accelero
        load('behavResources.mat', 'MovAcctsd')
        SmoothAcc = tsd(Range(MovAcctsd),runmean_BM(Data(MovAcctsd),30));
        
        Wake_Just_Aft_Inj = Just_Aft_Inj;
        FreezeAccEpoch=thresholdIntervals(Restrict(SmoothAcc,Wake_Just_Aft_Inj),1.7e7,'Direction','Below');
        FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
        FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,2*1e4);
        MovingEpoch = Wake_Just_Aft_Inj-FreezeAccEpoch;
        
        FreezeTime{drug}(mouse) = sum(DurationEpoch(FreezeAccEpoch))/60e4;
        
    end
end











