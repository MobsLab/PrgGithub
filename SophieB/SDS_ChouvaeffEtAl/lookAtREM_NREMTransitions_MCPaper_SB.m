clear all
%DIR INHI DREADDS PFC-VLPO SAL/CNO (basal sleep)
Dir_saline=PathForExperiments_DREADD_MC('inhibDREADD_retroCre_PFC_VLPO_SalineInjection_1pm');
TimeLimTrigger = 5000;

for mm = 1:length(Dir_saline.path)
    cd(Dir_saline.path{mm}{1})
    
    % load SeepScoring
    load('SleepScoring_Accelero.mat','REMEpoch','Wake','SWSEpoch','ThetaRatioTSD')
    load('behavResources.mat', 'MovAcctsd')
    load('SleepScoring_OBGamma.mat', 'SmoothGamma')
    
%     if exist('ChannelsToAnalyse/EMG.mat')
%         load('ChannelsToAnalyse/EMG.mat')
%         load(['LFPData/LFP',num2str(channel)]);
%         FilLFP=FilterLFP(LFP,[50 300],1024);
%         EMGData=tsd(Range(FilLFP),Data((FilLFP)).^2);
%         EMGData = tsd(Range(EMGData),log(runmean(movmax(Data(EMGData),20),50)));
%     end
%     
    % Get REM followed by wake and sleep
    [aft_cell,bef_cell]=transEpoch(REMEpoch,Wake);
    RemToWake = aft_cell{1,2};
    [aft_cell,bef_cell]=transEpoch(REMEpoch,SWSEpoch);
    RemToSWS = aft_cell{1,2};
    
    
    % Get NREM followed by wake and sleep
    [aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
    SWSToWake = aft_cell{1,2};
    
    
    % z-score tsdMovement to make sure comparable between mice
    MovAcctsd = tsd(Range(MovAcctsd),zscore(Data(MovAcctsd)));
    SmoothGamma = tsd(Range(SmoothGamma),zscore(Data(SmoothGamma)));
    
    % Accelero Trigger on REM end
    [M,T.acc.REMToWake{mm}] = PlotRipRaw(MovAcctsd,Stop(RemToWake,'s'),TimeLimTrigger,0,0,0);
    [M,T.acc.REMtoSWS{mm}] = PlotRipRaw(MovAcctsd,Stop(RemToSWS,'s'),TimeLimTrigger,0,0,0);
    [M,T.acc.SWSToWake{mm}] = PlotRipRaw(MovAcctsd,Stop(SWSToWake,'s'),TimeLimTrigger,0,0,0);
    time_spec.acc = M(:,1);
    
    
    % Theta Trigger on REM end
    [M,T.thetdel.REMToWake{mm}] = PlotRipRaw(ThetaRatioTSD,Stop(RemToWake,'s'),TimeLimTrigger,0,0,0);
    [M,T.thetdel.REMtoSWS{mm}] = PlotRipRaw(ThetaRatioTSD,Stop(RemToSWS,'s'),TimeLimTrigger,0,0,0);
    [M,T.thetdel.SWSToWake{mm}] = PlotRipRaw(ThetaRatioTSD,Stop(SWSToWake,'s'),TimeLimTrigger,0,0,0);
    time_spec.thetdel = M(:,1);
    
    % Gamma Trigger on REM end
    [M,T.obgamma.REMToWake{mm}] = PlotRipRaw(SmoothGamma,Stop(RemToWake,'s'),TimeLimTrigger,0,0,0);
    [M,T.obgamma.REMtoSWS{mm}] = PlotRipRaw(SmoothGamma,Stop(RemToSWS,'s'),TimeLimTrigger,0,0,0);
    [M,T.obgamma.SWSToWake{mm}] = PlotRipRaw(SmoothGamma,Stop(SWSToWake,'s'),TimeLimTrigger,0,0,0);
    time_spec.obgamma = M(:,1);
    
%     % EMG Trigger on REM end
%     if exist('ChannelsToAnalyse/EMG.mat')
%         
%         [M,T.emg.REMToWake{mm}] = PlotRipRaw(EMGData,Stop(RemToWake,'s'),TimeLimTrigger,0,0,0);
%         [M,T.emg.REMtoSWS{mm}] = PlotRipRaw(EMGData,Stop(RemToSWS,'s'),TimeLimTrigger,0,0,0);
%         [M,T.emg.SWSToWake{mm}] = PlotRipRaw(EMGData,Stop(SWSToWake,'s'),TimeLimTrigger,0,0,0);
%         time_spec.emg = M(:,1);
%     else
%         T.emg.REMToWake{mm} = nan(length(Stop(RemToWake,'s')),5001);
%         T.emg.REMtoSWS{mm} = nan(length(Stop(RemToSWS,'s')),5001);
%         T.emg.SWSToWake{mm} = nan(length(Stop(SWSToWake,'s')),5001);
%     end
end


clear ind AllEv
AllTransitions = fieldnames(T.acc);
AllVar= fieldnames(T);
for var = 1:length(AllVar)
    for tr = 1:length(AllTransitions)
        AllEv.(AllVar{var}).(AllTransitions{tr}) = [];
    end
end


TimeLim = 0.2; % WindowToUse for sorting matrix
for var = 1:length(AllVar)
    figure
    for tr = 1:length(AllTransitions)
        for mm = 1:length(Dir_saline.path)
            if not(isempty(T.(AllVar{var}).(AllTransitions{tr}){mm}))
            
            time = time_spec.(AllVar{var});
            window = [find(time>0,1,'first') : find(time>TimeLim,1,'first')];
            MatOfInterest = (T.(AllVar{var}).(AllTransitions{tr}){mm});
            subplot(3,3,tr)
            plot(time,nanmean(MatOfInterest))
            yl(tr,mm,:) = ylim;
            hold on
            title(AllTransitions{tr})
            MiceAv.(AllVar{var}).(AllTransitions{tr})(mm,:) = nanmean(MatOfInterest);
            AllEv.(AllVar{var}).(AllTransitions{tr}) = [ AllEv.(AllVar{var}).(AllTransitions{tr}) ;MatOfInterest];
            end
        end
        subplot(3,3,tr+3)
        imagesc(time,1:length(Dir_saline.path),MiceAv.(AllVar{var}).(AllTransitions{tr}))
        cax(tr,:) = caxis;
        
        subplot(3,3,tr+6)
        Mat = AllEv.(AllVar{var}).(AllTransitions{tr});
        if var == 1
            [MatNew,ind{tr}]=SortMat(Mat,window);
            imagesc(time,1:length(ind{tr}),MatNew)
        else
            imagesc(time,1:length(ind{tr}),Mat(ind{tr},:))
        end
    end
    for tr = 1:length(AllTransitions)
        subplot(3,3,tr+3)
        caxis([min(cax(:,1)) max(cax(:,2))])
        subplot(3,3,tr+6)
        caxis([min(cax(:,1)) max(cax(:,2))])
        subplot(3,3,tr)
        ylim([min(min(yl(:,:,1))) max(max(yl(:,:,2)))])

    end
end
