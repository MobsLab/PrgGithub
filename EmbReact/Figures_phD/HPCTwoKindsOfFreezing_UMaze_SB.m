clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MouseToAvoid=[117,431,795]; % mice with noisy data to exclude

% Everything Together
SessionType{1} =  GetRightSessionsUMaze_SB('AllCondSessions');
Name{1} = 'AllCondSessions';
% PAG Only
SessionType{2} =  {'UMazeCond'};
Name{2} = 'PagDay';
% PAG Night only
SessionType{3} =  {'UMazeCondNight'};
Name{3} = 'PagNight';
% Eyeshock only
SessionType{4} =  GetRightSessionsUMaze_SB('AllCondSessions_Eyeshock');
Name{4} = 'Eyeshock';
% Eyeshock only but with no doors
SessionType{5} =  GetRightSessionsUMaze_SB('AllCond_EyeShock_NoDoors');
Name{5} = 'EyeshockNoDoors';
% TestSessionWithNoShockGiven
SessionType{6} =  GetRightSessionsUMaze_SB('TestSessionDoors_EyeShock');
Name{6} = 'EyeshockNoShockExt';

SaveLocation = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice';

for SOI = 1%:length(SessionType)
    clear MouseByMouse MouseNum
    for ss=1:length(SessionType{SOI})
        Dir=PathForExperimentsEmbReact(SessionType{SOI}{ss});
        Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
        disp(SessionType{SOI}{ss})
        for d=1:length(Dir.path)
            MouseByMouse.IsSession{Dir.ExpeInfo{d}{1}.nmouse} = nan(length(SessionType{SOI}{ss}),length(Dir.path{d}));
        end
    end
    
    
    for ss=1:length(SessionType{SOI})
        Dir=PathForExperimentsEmbReact(SessionType{SOI}{ss});
        Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
        disp(SessionType{SOI}{ss})
        for d=1:length(Dir.path)
            
            for dd=1:length(Dir.path{d})
                go=0;
                if isfield(Dir.ExpeInfo{d}{dd},'DrugInjected')
                    if strcmp(Dir.ExpeInfo{d}{dd}.DrugInjected,'SAL')
                        go=1;
                    end
                else
                    go=1;
                end
                
                if go ==1
                    cd(Dir.path{d}{dd})
                    disp(Dir.path{d}{dd})
                    clear TTLInfo Behav SleepyEpoch
                    load('behavResources_SB.mat')
                    load('ExpeInfo.mat')
                    MouseNum(ss,d,dd) = ExpeInfo.nmouse;
                    
                    % Get epochs
                    load('StateEpochSB.mat','SleepyEpoch')
                    load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                    TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch)-0.5*1e4,Stop(TTLInfo.StimEpoch)+2.5*1e4);
                    RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
                    TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
                    if isfield(Behav,'FreezeAccEpoch')
                        if not(isempty(Behav.FreezeAccEpoch))
                            Behav.FreezeEpoch = Behav.FreezeAccEpoch;
                        end
                    end
                    CleanFreezeEpoch  = Behav.FreezeEpoch-RemovEpoch;
                    CleanNoFreezeEpoch  = (TotalEpoch-Behav.FreezeEpoch)-RemovEpoch;
                    SafeZone = and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
                    ShockZone = and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch;
                    ActivePeriod = mergeCloseIntervals(thresholdIntervals(Behav.Vtsd,5,'Direction','Above'),2*1E4)-RemovEpoch;
                    
                    MouseByMouse.DurSafe{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(SafeZone,'s')-Start(SafeZone,'s'));
                    MouseByMouse.DurShock{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(ShockZone,'s')-Start(ShockZone,'s'));
                    MouseByMouse.DurActive{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(ActivePeriod,'s')-Start(ActivePeriod,'s'));
                    MouseByMouse.IsSession{ExpeInfo.nmouse}(ss,dd) = 1;
                    
                    MouseByMouse.SpeedSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,SafeZone)));
                    MouseByMouse.SpeedShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,ShockZone)));
                    MouseByMouse.SpeedNoFz{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,TotalEpoch-Behav.FreezeEpoch)));
                    
                    [Sp,t,f]=LoadSpectrumML('Bulb_deep');
                        Sptsd=tsd(t*1e4,Sp);
                        if MouseByMouse.DurShock{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.OB_Shock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ShockZone)));
                        else
                            MouseByMouse.OB_Shock{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        end
                        if MouseByMouse.DurSafe{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.OB_Safe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,SafeZone)));
                        else
                            MouseByMouse.OB_Safe{ExpeInfo.nmouse}(ss,dd,:) =    nan(1,261);
                        end
                        if MouseByMouse.DurActive{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.OB_Active{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ActivePeriod)));
                        else
                            MouseByMouse.OB_Active{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        end
                    
                    if exist('ChannelsToAnalyse/dHPC_deep.mat')>0
                        [Sp,t,f]=LoadSpectrumML('dHPC_deep');
                        Sptsd=tsd(t*1e4,Sp);
                        if MouseByMouse.DurShock{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.dHPCdeep_Shock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ShockZone)));
                        else
                            MouseByMouse.dHPCdeep_Shock{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        end
                        if MouseByMouse.DurSafe{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.dHPCdeep_Safe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,SafeZone)));
                        else
                            MouseByMouse.dHPCdeep_Safe{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        end
                        if MouseByMouse.DurActive{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.dHPCdeep_Active{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ActivePeriod)));
                        else
                            MouseByMouse.dHPCdeep_Active{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        end
                        fLow = f;
                    end
                    
                    if exist('ChannelsToAnalyse/dHPC_sup.mat')>0
                        [Sp,t,f]=LoadSpectrumML('dHPC_sup');
                        Sptsd=tsd(t*1e4,Sp);
                        if MouseByMouse.DurShock{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.dHPCsup_Shock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ShockZone)));
                        else
                            MouseByMouse.dHPCsup_Shock{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        end
                        if MouseByMouse.DurSafe{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.dHPCsup_Safe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,SafeZone)));
                        else
                            MouseByMouse.dHPCsup_Safe{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        end
                        if MouseByMouse.DurActive{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.dHPCsup_Active{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ActivePeriod)));
                        else
                            MouseByMouse.dHPCsup_Active{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        end
                        fLow = f;
                    end
                    
                    if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                        [Sp,t,f]=LoadSpectrumML('dHPC_rip');
                        Sptsd=tsd(t*1e4,Sp);
                        if MouseByMouse.DurShock{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.dHPCrip_Shock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ShockZone)));
                        else
                            MouseByMouse.dHPCrip_Shock{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        end
                        if MouseByMouse.DurSafe{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.dHPCrip_Safe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,SafeZone)));
                        else
                            MouseByMouse.dHPCrip_Safe{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        end
                        if MouseByMouse.DurActive{ExpeInfo.nmouse}(ss,dd)>1
                            MouseByMouse.dHPCrip_Active{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ActivePeriod)));
                        else
                            MouseByMouse.dHPCrip_Active{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        end
                        fLow = f;
                    end
                    
                    
                    
                end
            end
        end
    end
    
    MouseList = unique(MouseNum(:));
    MouseList(1) =  [];
    for mm = 1:length(MouseList)
        SleepFolder = FindSleepFile_EmbReact_SB(MouseList(mm),'20180101');
        if not(isempty(SleepFolder.UMazeDay))
            FolderToUse = SleepFolder.UMazeDay;
        else
            FolderToUse = SleepFolder.Base;
        end
        
        cd(FolderToUse)
        load('ExpeInfo.mat')
        clear SWSEpoch REMEpoch Epoch
        try
            load('SleepScoring_OBGamma.mat','SWSEpoch','REMEpoch')
        catch
            load('StateEpochSB.mat','SWSEpoch','REMEpoch')
        end
        
        try,load('SleepSubstages.mat'), end
        
        [Sp,t,f]=LoadSpectrumML('Bulb_deep');
                        Sptsd=tsd(t*1e4,Sp);
        MouseByMouse.OB_SWS{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,SWSEpoch)));
        MouseByMouse.OB_REM{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,REMEpoch)));
        try Epoch
            MouseByMouse.OB_N1{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{1})));
            MouseByMouse.OB_N2{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{2})));
            MouseByMouse.OB_N3{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{3})));
        end
        
        
        if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
            [Sp,t,f]=LoadSpectrumML('dHPC_rip');
            Sptsd=tsd(t*1e4,Sp);
            MouseByMouse.dHPCrip_SWS{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,SWSEpoch)));
            MouseByMouse.dHPCrip_REM{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,REMEpoch)));
            try Epoch
                MouseByMouse.dHPCrip_N1{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{1})));
                MouseByMouse.dHPCrip_N2{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{2})));
                MouseByMouse.dHPCrip_N3{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{3})));
            end
        end
        
        if exist('ChannelsToAnalyse/dHPC_deep.mat')>0
            [Sp,t,f]=LoadSpectrumML('dHPC_deep');
            Sptsd=tsd(t*1e4,Sp);
            MouseByMouse.dHPCdeep_SWS{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,SWSEpoch)));
            MouseByMouse.dHPCdeep_REM{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,REMEpoch)));
            try Epoch
                MouseByMouse.dHPCdeep_N1{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{1})));
                MouseByMouse.dHPCdeep_N2{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{2})));
                MouseByMouse.dHPCdeep_N3{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{3})));
            end
        end
        
        if exist('ChannelsToAnalyse/dHPC_sup.mat')>0
            [Sp,t,f]=LoadSpectrumML('dHPC_sup');
            Sptsd=tsd(t*1e4,Sp);
            MouseByMouse.dHPCsup_SWS{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,SWSEpoch)));
            MouseByMouse.dHPCsup_REM{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,REMEpoch)));
            try Epoch
                MouseByMouse.dHPCsup_N1{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{1})));
                MouseByMouse.dHPCsup_N2{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{2})));
                MouseByMouse.dHPCsup_N3{ExpeInfo.nmouse}(1,1,:) = nanmean(Data(Restrict(Sptsd,Epoch{3})));
            end
            
        end
    end
    
    keyboard
    %% Mouse averaged results
    AllMice = unique(MouseNum);
    AllMice(1) = [];
    HPCStruct = {'OB','dHPCrip','dHPCdeep'};
    EpochName = {'Active','Shock','Safe','N1','N2','N3','REM'};
    clear HRVarShock HRSafe HRShock RipSafe RipShock HRVarSafe OBSPecShock TimeShock TimeSafe OBSPecSafe FreqOBShock FreqOBSafe
    for m=1:length(AllMice)
        
        for h = 1:length(HPCStruct)
            for e = 1:length(EpochName)
                if not(isempty(MouseByMouse.([HPCStruct{h},'_',EpochName{e}]){AllMice(m)}))
                    SpecShockTemp = MouseByMouse.([HPCStruct{h},'_',EpochName{e}]){AllMice(m)};
                    SpecShockTemp = reshape(SpecShockTemp,[size(SpecShockTemp,1)*size(SpecShockTemp,2),261]);
                    if size(SpecShockTemp,1)>1
                        SpecShockTempTime = squeeze(MouseByMouse.(['Dur',EpochName{e}]){AllMice(m)});
                        SpecShockTempTime = SpecShockTempTime(:);
                        SpecShockTemp(isnan(SpecShockTempTime)|(SpecShockTempTime==0),:) = [];
                        SpecShockTempTime(isnan(SpecShockTempTime)|(SpecShockTempTime==0)) = [];
                        Sptemp = SpecShockTemp'*SpecShockTempTime/nansum(SpecShockTempTime);
                        Spec.(EpochName{e}).(HPCStruct{h})(m,:) = Sptemp./nansum(Sptemp(14:end));
                    else
                        Spec.(EpochName{e}).(HPCStruct{h})(m,:) = SpecShockTemp./nansum(SpecShockTemp(14:end));
                        
                    end
                else
                    Spec.(EpochName{e}).(HPCStruct{h})(m,:) = nan(1,261);
                end
            end
        end
        
        
    end
    
    colsleep = summer(3);
    Cols = {[0.5 0 0],UMazeColors('sal'),UMazeColors('shock'),UMazeColors('safe'),colsleep(1,:),colsleep(2,:),colsleep(3,:)};
    
        EpochName = {'REM','Active','Shock','Safe','N1','N2','N3'};
    for h = 1:length(HPCStruct)
        subplot(1,3,h)
        for e = 1:length(EpochName)
            SpecToUse = (Spec.(EpochName{e}).(HPCStruct{h}));
            g = shadedErrorBar(fLow,nanmean(SpecToUse),stdError(SpecToUse));
            set(g.patch,'FaceColor',Cols{e},'FaceAlpha',0.5)
            set(g.mainLine,'Color',Cols{e},'linewidth',2), hold on
            
            hold on
        end
        title(HPCStruct{h})
        xlim([1 15])
        box off
        set(gca,'LineWidth',2,'FontSize',15)
        xlabel('Frequency(Hz)')
        ylabel('Power (AU)')
    end
    
    
    
    
    
    
    
    
    
    
    
end