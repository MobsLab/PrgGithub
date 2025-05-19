clear all
Cols = {'k','r'};
smootime=3;
Frequency{1} = [5 10];
Frequency{2} = [2 5];

TimeLimTrigger = 10000;
OnlyLongEpochs = 1;

GroupNames = {'Ctrl','SDS'};


%%1
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_ctrl=RestrictPathForExperiment(Dir_ctrl,'nMice',[1423 1424 1425 1426 1433 1434 1449 1450 1451 1414 1439 1440 1437]);
for mm = 1:length(Dir_ctrl.path)
    enregistrements_All{1}{mm} = Dir_ctrl.path{mm}{1};
end

%%3
DirSocialDefeat_classic1 = PathForExperiments_SD_MC('SleepPostSD');
DirSocialDefeat_mCherry_saline1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
DirSocialDefeat_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_mCherry_saline = MergePathForExperiment(DirSocialDefeat_mCherry_saline1,DirSocialDefeat_BM_saline1);
DirSocialDefeat_classic = MergePathForExperiment(DirSocialDefeat_classic1,DirSocialDefeat_mCherry_saline);

for mm = 1:length(DirSocialDefeat_classic.path)
    enregistrements_All{2}{mm} = DirSocialDefeat_classic.path{mm}{1};
end


for DoControls = 2
    
    if DoControls ==1
        enregistrements = enregistrements_All{1};
    else
        enregistrements = enregistrements_All{2};
    end
    
    
    for mm = 1:length(enregistrements)
        cd(enregistrements{mm})
        clear VarToMes
        mm
        % load SeepScoring
        load('SleepScoring_Accelero.mat','REMEpoch','Wake','SWSEpoch','ThetaRatioTSD')
        if OnlyLongEpochs
            REMEpoch = dropShortIntervals(REMEpoch,10*1e4);
            Wake = dropShortIntervals(Wake,10*1e4);
            SWSEpoch = dropShortIntervals(SWSEpoch,10*1e4);
        end
        % Limit to long episodes
        
        VarToMes.ThetaRatioTSD = ThetaRatioTSD;
        clear ThetaRatioTSD
        load('behavResources.mat', 'MovAcctsd')
        VarToMes.MovAcctsd = MovAcctsd;
        VarToMes.MovAcctsd = tsd(Range(VarToMes.MovAcctsd),zscore(Data(VarToMes.MovAcctsd)));
        clear MovAcctsd
        load('SleepScoring_OBGamma.mat', 'SmoothGamma')
        VarToMes.SmoothGamma = SmoothGamma;
        VarToMes.SmoothGamma = tsd(Range(VarToMes.SmoothGamma),zscore(Data(VarToMes.SmoothGamma)));
        clear SmoothGamma
        
        clear EMGData
        if exist('ChannelsToAnalyse/EMG.mat')
            load('ChannelsToAnalyse/EMG.mat')
            load(['LFPData/LFP',num2str(channel)]);
            FilLFP=FilterLFP(LFP,[50 300],1024);
            VarToMes.EMGData=tsd(Range(FilLFP),zscore(Data((FilLFP)).^2));
            clear FilLFP LFP
            %         EMGData = tsd(Range(EMGData),log(runmean(movmax(Data(EMGData),20),50)));
        end
        
        % PFC theta/delt ratio
        load('ChannelsToAnalyse/PFCx_deep.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        FilTheta = FilterLFP(LFP,Frequency{1},1024);
        FilDelta = FilterLFP(LFP,Frequency{2},1024);
        hilbert_theta = abs(hilbert(Data(FilTheta)));
        hilbert_delta = abs(hilbert(Data(FilDelta)));
        hilbert_delta(hilbert_delta<100) = 100;
        theta_ratio = hilbert_theta ./ hilbert_delta;
        ThetaRatioTSD_PFC = tsd(Range(FilTheta), theta_ratio);
        VarToMes.ThetaRatioTSD_PFC = ThetaRatioTSD_PFC;
        clear ThetaRatioTSD_PFC
        
        % Spectrograms
        try
            load('dHPC_rip_Low_Spectrum.mat')
            VarToMes.Sptsd_H = tsd(Spectro{2}*1e4,log(Spectro{1}));
        end
        try
            load('PFCx_deep_Low_Spectrum.mat')
            VarToMes.Sptsd_P = tsd(Spectro{2}*1e4,log(Spectro{1}));
        end
        
        %% Epochs
        % Get REM followed by wake and sleep
        [aft_cell,bef_cell]=transEpoch(REMEpoch,Wake);
        RemToWake = aft_cell{1,2};
        WakeAfterREM = bef_cell{2,1};
        PostREMWakeDur{mm} = Stop(WakeAfterREM,'s') - Start(WakeAfterREM,'s');
        [aft_cell,bef_cell]=transEpoch(REMEpoch,SWSEpoch);
        RemToSWS = aft_cell{1,2};
        SWSAfterREM = bef_cell{2,1};
        PostREMSWSDur{mm} = Stop(SWSAfterREM,'s') - Start(SWSAfterREM,'s');
        
        % Get NREM followed by wake and sleep
        [aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
        SWSToWake = aft_cell{1,2};
        WakeAfterSWS= bef_cell{2,1};
        PostSWSWakeDur{mm} = Stop(WakeAfterSWS,'s') - Start(WakeAfterSWS,'s');
        
        REMEpDur{mm} = Stop(REMEpoch,'s') - Start(REMEpoch,'s');
        
        % Trigger on Episode changes
        AllVar = fieldnames(VarToMes);
        for vv = 1:length(AllVar)
            
            if strcmp(AllVar{vv},'Sptsd_H') | strcmp(AllVar{vv},'Sptsd_P')
                Spec = Data(VarToMes.(AllVar{vv}));
                for f = 1:size(Spec,2)
                    Spectsd_loc = tsd(Range(VarToMes.(AllVar{vv})),Spec(:,f));
                    [M_temp,T_temp] = PlotRipRaw(Spectsd_loc,Stop(RemToWake,'s'),TimeLimTrigger,0,0,0);
                    T_temp((T_temp==0)) =NaN;
                    T_temp = naninterp(T_temp')';
                    T.(AllVar{vv}).REMToWake{mm}(f,:,:) = T_temp;
                    
                    [M_temp,T_temp] = PlotRipRaw(Spectsd_loc,Stop(RemToSWS,'s'),TimeLimTrigger,0,0,0);
                    T_temp((T_temp==0)) =NaN;
                    T_temp = naninterp(T_temp')';
                    T.(AllVar{vv}).REMtoSWS{mm}(f,:,:) = T_temp;
                    
                    [M_temp,T_temp] = PlotRipRaw(Spectsd_loc,Stop(SWSToWake,'s'),TimeLimTrigger,0,0,0);
                    T_temp((T_temp==0)) =NaN;
                    T_temp = naninterp(T_temp')';
                    T.(AllVar{vv}).SWSToWake{mm}(f,:,:) = T_temp;
                    time_spec.(AllVar{vv}) = M_temp(:,1);
                    
                    [M_temp,T_temp] = PlotRipRaw(Spectsd_loc,Start(REMEpoch,'s'),TimeLimTrigger,0,0,0);
                    T_temp((T_temp==0)) =NaN;
                    T_temp = naninterp(T_temp')';
                    T.(AllVar{vv}).REMStart{mm}(f,:,:) = T_temp;
                end
                
            else
                
                [M,T.(AllVar{vv}).REMToWake{mm}] = PlotRipRaw(VarToMes.(AllVar{vv}),Stop(RemToWake,'s'),TimeLimTrigger,0,0,0);
                [M,T.(AllVar{vv}).REMtoSWS{mm}] = PlotRipRaw(VarToMes.(AllVar{vv}),Stop(RemToSWS,'s'),TimeLimTrigger,0,0,0);
                [M,T.(AllVar{vv}).SWSToWake{mm}] = PlotRipRaw(VarToMes.(AllVar{vv}),Stop(SWSToWake,'s'),TimeLimTrigger,0,0,0);
                [M,T.(AllVar{vv}).REMStart{mm}] = PlotRipRaw(VarToMes.(AllVar{vv}),Start(REMEpoch,'s'),TimeLimTrigger,0,0,0);
                time_spec.(AllVar{vv}) = M(:,1);
                
            end
            
        end
        
        
        % EMG Trigger on REM end
        if sum(strcmp(AllVar,'EMGData'))==0
            T.EMGData.REMToWake{mm} = nan(length(Stop(RemToWake,'s')),1250*2*(TimeLimTrigger/1e3)+1);
            T.EMGData.REMtoSWS{mm} = nan(length(Stop(RemToSWS,'s')),1250*2*(TimeLimTrigger/1e3)+1);
            T.EMGData.SWSToWake{mm} = nan(length(Stop(SWSToWake,'s')),1250*2*(TimeLimTrigger/1e3)+1);
            T.EMGData.REMStart{mm} = nan(length(Start(REMEpoch,'s')),1250*2*(TimeLimTrigger/1e3)+1);
            time_spec.(AllVar{vv}) = M(:,1);
            
        end
    end
    
    
    clear ind AllEv AllEvMiceNum
    AllTransitions = fieldnames(T.ThetaRatioTSD);
    AllVar= fieldnames(T);
    for var = 1:length(AllVar)
        for tr = 1:length(AllTransitions)
            AllEv.(AllVar{var}).(AllTransitions{tr}) = [];
            AllEvMiceNum.(AllVar{var}).(AllTransitions{tr}) = [];
            AllEvPostDur.(AllVar{var}).(AllTransitions{tr}) = [];
        end
    end
    
    cd /home/pinky/Documents/Figure_PapierMathilde/Transitions
    TimeLim = 0.2; % WindowToUse for sorting matrix
    for var = 1:length(AllVar)
        if not(strcmp(AllVar{var},'Sptsd_H') | strcmp(AllVar{var},'Sptsd_P'))
            
            fig = figure('Name',AllVar{var});
            for tr = 1:length(AllTransitions)
                for mm = 1:length(enregistrements)
                    if not(isempty(T.(AllVar{var}).(AllTransitions{tr}){mm}))
                        
                        time = time_spec.(AllVar{var});
                        window = [find(time>0,1,'first') : find(time>TimeLim,1,'first')];
                        MatOfInterest = (T.(AllVar{var}).(AllTransitions{tr}){mm});
                        if size(MatOfInterest,2)==1
                            MatOfInterest = MatOfInterest';
                        end
                        subplot(3,4,tr)
                        plot(time,nanmean(MatOfInterest))
                        yl(tr,mm,:) = ylim;
                        hold on
                        title(AllTransitions{tr})
                        MiceAv.(AllVar{var}).(AllTransitions{tr})(mm,:) = nanmean(MatOfInterest);
                        AllEv.(AllVar{var}).(AllTransitions{tr}) = [ AllEv.(AllVar{var}).(AllTransitions{tr}) ;MatOfInterest];
                        AllEvMiceNum.(AllVar{var}).(AllTransitions{tr}) = [ AllEvMiceNum.(AllVar{var}).(AllTransitions{tr}) ;ones(size(MatOfInterest,1),1)*mm];
                        if tr ==1
                            AllEvPostDur.(AllVar{var}).(AllTransitions{tr}) = [ AllEvPostDur.(AllVar{var}).(AllTransitions{tr}) ;PostREMWakeDur{mm}];
                            if length(PostREMWakeDur{mm}) ~= size(MatOfInterest,1)
                                keyboard
                            end
                            
                        elseif tr==2
                            AllEvPostDur.(AllVar{var}).(AllTransitions{tr}) = [ AllEvPostDur.(AllVar{var}).(AllTransitions{tr}) ;PostREMSWSDur{mm}];
                            if length(PostREMSWSDur{mm}) ~= size(MatOfInterest,1)
                                keyboard
                            end
                        elseif tr ==3
                            AllEvPostDur.(AllVar{var}).(AllTransitions{tr}) = [ AllEvPostDur.(AllVar{var}).(AllTransitions{tr}) ;PostSWSWakeDur{mm}];
                            if length(PostSWSWakeDur{mm}) ~= size(MatOfInterest,1)
                                keyboard
                            end
                        elseif tr ==4
                            AllEvPostDur.(AllVar{var}).(AllTransitions{tr}) = [ AllEvPostDur.(AllVar{var}).(AllTransitions{tr}) ;REMEpDur{mm}];
                            if length(REMEpDur{mm}) ~= size(MatOfInterest,1)
                                keyboard
                            end
                            
                        end
                    end
                end
                subplot(3,4,tr+4)
                imagesc(time,1:length(enregistrements),MiceAv.(AllVar{var}).(AllTransitions{tr}))
                cax(tr,:) = caxis;
                
                % Sort by post episode duration
                subplot(3,4,tr+8)
                Mat = AllEv.(AllVar{var}).(AllTransitions{tr});
                Dur = AllEvPostDur.(AllVar{var}).(AllTransitions{tr});
                [val,ind] = sort(Dur);
                imagesc(time,1:length(ind),Mat(ind,:))
            end
            for tr = 1:length(AllTransitions)
                subplot(3,4,tr+4)
                caxis([min(cax(:,1)) max(cax(:,2))])
                ylabel('Mouse Number')
                subplot(3,4,tr+8)
                caxis([min(cax(:,1)) max(cax(:,2))])
                ylabel('Trial Number')
                subplot(3,4,tr)
                ylim([min(min(yl(:,:,1))) max(max(yl(:,:,2)))])
                ylabel(AllVar{var})
            end
            saveas(fig.Number,['TransitionsFor',AllVar{var},'_',GroupNames{DoControls},'_Long',num2str(OnlyLongEpochs),'.fig'])
            saveas(fig.Number,['TransitionsFor',AllVar{var},'_',GroupNames{DoControls},'_Long',num2str(OnlyLongEpochs),'.png'])
            
        end
    end
    
    AllTransitions = fieldnames(T.Sptsd_H);
    fig = figure('Name','HPC');
    for tr = 1:length(AllTransitions)
        clear Spec
        for mm = 1:length(T.Sptsd_H.(AllTransitions{tr}))
            if size(T.Sptsd_H.(AllTransitions{tr}){mm},3)>1
                try
                    Spec(mm,:,:) = squeeze(nanmean(T.Sptsd_H.(AllTransitions{tr}){mm},2));
                    Spec(mm,:,:) = Spec(mm,:,:)./squeeze(nanmean(nanmean(Spec(mm,:,:))));
                end
            end
        end
        Spec(Spec==0) = NaN;
        
        subplot(1,4,tr)
        imagesc(time_spec.Sptsd_P,Spectro{3},squeeze(nanmean(Spec,1)))
        axis xy
        title(AllTransitions{tr})
    end
    saveas(fig.Number,['HPCSpec',AllVar{var},'_',GroupNames{DoControls},'_Long',num2str(OnlyLongEpochs),'.fig'])
    saveas(fig.Number,['HPCSpec',AllVar{var},'_',GroupNames{DoControls},'_Long',num2str(OnlyLongEpochs),'.png'])
    
    
    fig = figure('Name','PFC');
    for tr = 1:length(AllTransitions)
        clear Spec
        for mm = 1:length(T.Sptsd_P.(AllTransitions{tr}))
            try
                Spec(mm,:,:) = squeeze(nanmean(T.Sptsd_P.(AllTransitions{tr}){mm},2));
                Spec(mm,:,:) = Spec(mm,:,:)./squeeze(nanmean(nanmean(Spec(mm,:,:))));
                Spec(Spec==0) = NaN;
                
            end
        end
        subplot(1,4,tr)
        imagesc(time_spec.Sptsd_P,Spectro{3},squeeze(nanmean(Spec,1)))
        axis xy
        title(AllTransitions{tr})
    end
    saveas(fig.Number,['PFCSpec',AllVar{var},'_',GroupNames{DoControls},'_Long',num2str(OnlyLongEpochs),'.fig'])
    saveas(fig.Number,['PFCSpec',AllVar{var},'_',GroupNames{DoControls},'_Long',num2str(OnlyLongEpochs),'.png'])
    
    
    save(['TransitionInfo_',GroupNames{DoControls},'_Long',num2str(OnlyLongEpochs),'.mat'],'T','AllEv','AllEvMiceNum','AllEvPostDur','MiceAv','time_spec')
    clear T AllEv AllEvMiceNum AllEvPostDur MiceAv time_spec
end




%% Compare the dynamics between groups
load(['TransitionInfo_',GroupNames{1},'_Long',num2str(1),'.mat'],'T','AllEv','AllEvMiceNum','AllEvPostDur','MiceAv','time_spec')

AllVar = fieldnames(MiceAv);
Cols = {'k','b'}
for var = 1:length(AllVar)
    fig = figure('Name',AllVar{var});
    for grp = 1:2
    load(['TransitionInfo_',GroupNames{grp},'_Long',num2str(OnlyLongEpochs),'.mat'],'T','AllEv','AllEvMiceNum','AllEvPostDur','MiceAv','time_spec')
        
        for tr = 1:length(AllTransitions)
            subplot(2,2,tr)
            temp = MiceAv.(AllVar{var}).(AllTransitions{tr});
            temp = smooth2a(temp,0,100);
            shadedErrorBar(time_spec.(AllVar{var}),nanmean(temp),stdError(temp),Cols{grp})
            title(AllTransitions{tr})
            hold on
            ylim([-0.3 0.3])
            line([0 0 ],ylim)
            xlabel('time (s)')
        end
    end
    saveas(fig.Number,['CompareTransitions_',AllVar{var},'_Long',num2str(OnlyLongEpochs),'_SDS_Vs_Ctrl.fig'])
    saveas(fig.Number,['CompareTransitions_',AllVar{var},'_Long',num2str(OnlyLongEpochs),'_SDS_Vs_Ctrl.png'])
end


%% Compare the dynamics of PFC and HPC
AllVar = {'ThetaRatioTSD','ThetaRatioTSD_PFC'};
Cols = {'c','r'}
fig = figure('Name','HPCVsPFC');
for grp = 1:2
    load(['TransitionInfo_',GroupNames{grp},'_Long',num2str(OnlyLongEpochs),'.mat'],'T','AllEv','AllEvMiceNum','AllEvPostDur','MiceAv','time_spec')
    
    for tr = 1:length(AllTransitions)
        subplot(2,4,tr+4*(grp-1))
        for v = 1:2
        shadedErrorBar(time_spec.(AllVar{v}),nanmean(zscore(MiceAv.(AllVar{v}).(AllTransitions{tr})')'),stdError(zscore(MiceAv.(AllVar{v}).(AllTransitions{tr})')'),Cols{v})
        hold on
        title(AllTransitions{tr})
        end
        line([0 0 ],ylim)
        xlabel('time (s)')
        if tr ==1
            ylabel(GroupNames{grp})
        end
    end
    saveas(fig.Number,['CompareTransitions_HPCVsPFC_Long',num2str(OnlyLongEpochs),'_SDS_Vs_Ctrl.fig'])
    saveas(fig.Number,['CompareTransitions_HPCVsPFC_Long',num2str(OnlyLongEpochs),'_SDS_Vs_Ctrl.png'])

end

%% Figure showing all mice then all events

fig = figure('Name','AllEvents');
for tr = 1:length(AllTransitions)
    AllMice_BothGroups = [];
    AllEv_BothGroups = [];
    AllEvDur_BothGroups = [];
    for grp = 1:2
    load(['TransitionInfo_',GroupNames{grp},'_Long',num2str(OnlyLongEpochs),'.mat'],'T','AllEv','AllEvMiceNum','AllEvPostDur','MiceAv','time_spec')
        AllMice_BothGroups = [AllMice_BothGroups;MiceAv.MovAcctsd.(AllTransitions{tr})];
        AllEv_BothGroups = [AllEv_BothGroups;AllEv.MovAcctsd.(AllTransitions{tr})];
        AllEvDur_BothGroups = [AllEvDur_BothGroups;AllEvPostDur.MovAcctsd.(AllTransitions{tr})];
    end
    subplot(2,4,tr)
    imagesc(time_spec.MovAcctsd,1:size(AllMice_BothGroups,1),AllMice_BothGroups)
    xlabel('time (s)')
    ylabel('Mice Number')
    caxis([-0.5 2])
title(AllTransitions{tr})
   subplot(2,4,tr+4)
   if tr==2
       [val,ind] = sort(AllEvDur_BothGroups);
       imagesc(time_spec.MovAcctsd,1:length(AllEvDur_BothGroups),AllEv_BothGroups(ind,:))
   else
       imagesc(time_spec.MovAcctsd,1:length(AllEvDur_BothGroups),AllEv_BothGroups(:,:)) 
   end
    xlabel('time (s)')
    ylabel('Event Number')
    caxis([-0.5 2])
    
end

saveas(fig.Number,['Transitions_AccMiceAndEvents_Long',num2str(OnlyLongEpochs),'_SDS_Vs_Ctrl.fig'])
saveas(fig.Number,['Transitions_AccMiceAndEvents_Long',num2str(OnlyLongEpochs),'_SDS_Vs_Ctrl.png'])








