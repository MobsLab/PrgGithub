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
                    
                    
                    load('ChannelsToAnalyse/PFCx_deep.mat')
                    chan_PFC = channel;
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    chan_Bulb = channel;
                    
                    try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
                        try,load('ChannelsToAnalyse/dHPC_deep.mat'),
                        catch
                            try,load('ChannelsToAnalyse/dHPC_sup.mat'),
                            end
                        end
                    end
                    chan_HPC = channel;
                    
                    try,load('ChannelsToAnalyse/dHPC_rip.mat'), chan_HPCrip = channel;
                    catch,chan_HPCrip=[];
                    end
                    
                    % Trigger OB and PFC responses
                    load(['LFPData/LFP' num2str(chan_PFC) '.mat'])
                    LFP_PFC = LFP;
                    load(['LFPData/LFP' num2str(chan_Bulb) '.mat'])
                    LFP_Bulb = LFP;
                    load('InstFreqAndPhase_B.mat','AllPeaks')
                    
                    [M,TDown] = PlotRipRaw(LFP_Bulb,AllPeaks(find(AllPeaks(:,2)==-1),1),500,0,0);
                    TDowntsd_OB = tsd(AllPeaks(find(AllPeaks(:,2)==-1),1)*1E4,TDown);
                    [M,TUp] = PlotRipRaw(LFP_Bulb,AllPeaks(find(AllPeaks(:,2)==1),1),500,0,0);
                    TUptsd_OB = tsd(AllPeaks(find(AllPeaks(:,2)==1),1)*1E4,TUp);
                    tps = AllPeaks(find(AllPeaks(:,2)==1),1)*1E4;
                    if size(TDown,1)>size(TUp,1),
                        TDown = TDown(1:end-1,:);
                    elseif size(TDown,1)<size(TUp,1),
                        TUp = TUp(1:end-1,:);
                        tps = tps(1:end-1,:);
                    end
                    TDifftsd_OB = tsd(tps,TDown-TUp);
                    
                    [M,TDown] = PlotRipRaw(LFP_PFC,AllPeaks(find(AllPeaks(:,2)==-1),1),500,0,0);
                    TDowntsd_PFC = tsd(AllPeaks(find(AllPeaks(:,2)==-1),1)*1E4,TDown);
                    [M,TUp] = PlotRipRaw(LFP_PFC,AllPeaks(find(AllPeaks(:,2)==1),1),500,0,0);
                    TUptsd_PFC = tsd(AllPeaks(find(AllPeaks(:,2)==1),1)*1E4,TUp);
                    tps = AllPeaks(find(AllPeaks(:,2)==1),1)*1E4;
                    if size(TDown,1)>size(TUp,1),
                        TDown = TDown(1:end-1,:);
                    elseif size(TDown,1)<size(TUp,1),
                        TUp = TUp(1:end-1,:);
                        tps = tps(1:end-1,:);
                    end
                    TDifftsd_PFC = tsd(tps,TDown-TUp);
                    
                    % Get coherence
                    [Coh_P_B,t,f]=LoadCohgramML(chan_PFC,chan_Bulb,[cd filesep],'low');
                    Coh_P_B = tsd(t*1e4,Coh_P_B);
                    [Coh_P_H,t,f]=LoadCohgramML(chan_PFC,chan_HPC,[cd filesep],'low');
                    Coh_P_H = tsd(t*1e4,Coh_P_H);
                    [Coh_B_H,t,f]=LoadCohgramML(chan_Bulb,chan_HPC,[cd filesep],'low');
                    Coh_B_H = tsd(t*1e4,Coh_B_H);
                    
                    % Get spectra
                    [SpB,t,f] = LoadSpectrumML(chan_Bulb,[cd filesep],'low');
                    SpB = tsd(t*1e4,SpB);
                    
                    [SpP,t,f] = LoadSpectrumML(chan_PFC,[cd filesep],'low');
                    SpP = tsd(t*1e4,SpP);
                    
                    [SpH,t,f] = LoadSpectrumML(chan_HPC,[cd filesep],'low');
                    SpH = tsd(t*1e4,SpH);
                    
                    if not(isempty(chan_HPCrip))
                        [SpHR,t,f] = LoadSpectrumML(chan_HPCrip,[cd filesep],'low');
                        SpHR = tsd(t*1e4,SpHR);
                    end
                    
                    if MouseByMouse.DurShock{ExpeInfo.nmouse}(ss,dd)>1
                        MouseByMouse.Coh_P_B_Shock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Coh_P_B,ShockZone)));
                        MouseByMouse.Coh_P_H_Shock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Coh_P_H,ShockZone)));
                        MouseByMouse.Coh_B_H_Shock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Coh_B_H,ShockZone)));
                        
                        MouseByMouse.SpB_Shock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpB,ShockZone)));
                        MouseByMouse.SpP_Shock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpP,ShockZone)));
                        MouseByMouse.SpH_Shock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpH,ShockZone)));
                        if not(isempty(chan_HPCrip))
                            MouseByMouse.SpHR_Shock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpHR,ShockZone)));
                        else
                            MouseByMouse.SpHR_Shock{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        end
                        
                        MouseByMouse.MeanShapeSKUp_OB{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDifftsd_OB,ShockZone)));
                        MouseByMouse.MeanShapeSKUp_PFC{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TUptsd_PFC,ShockZone)));
                        
                        MouseByMouse.MeanShapeSKDown_OB{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDowntsd_OB,ShockZone)));
                        MouseByMouse.MeanShapeSKDown_PFC{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDowntsd_PFC,ShockZone)));
                        
                        MouseByMouse.MeanShapeSKDiff_OB{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDifftsd_OB,ShockZone)));
                        MouseByMouse.MeanShapeSKDIff_PFC{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDifftsd_PFC,ShockZone)));
                        
                        temp = (Data(Restrict(TDifftsd_OB,ShockZone)));
                        MouseByMouse.AllValsSK_OB{ExpeInfo.nmouse}{ss,dd} = min(temp(:,590:660)');
                        
                        temp = (Data(Restrict(TDifftsd_PFC,ShockZone)));
                        MouseByMouse.AllValsSK_PFC{ExpeInfo.nmouse}{ss,dd} = min(temp(:,590:660)');
                        
                    else
                        MouseByMouse.Coh_P_B_Shock{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.Coh_P_H_Shock{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.Coh_B_H_Shock{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.SpB_Shock{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        MouseByMouse.SpP_Shock{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.SpH_Shock{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.SpHR_Shock{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        
                        MouseByMouse.MeanShapeSKUp_OB{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeSKUp_PFC{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeSKDown_OB{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeSKDown_PFC{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeSKDiff_OB{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeSKDIff_PFC{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.AllValsSK_OB{ExpeInfo.nmouse}{ss,dd} =  [];
                        MouseByMouse.AllValsSK_PFC{ExpeInfo.nmouse}{ss,dd} = [];
                    end
                    
                    if MouseByMouse.DurSafe{ExpeInfo.nmouse}(ss,dd)>1
                        MouseByMouse.Coh_P_B_Safe{ExpeInfo.nmouse}(ss,dd,:) =  nanmean(Data(Restrict(Coh_P_B,SafeZone)));
                        MouseByMouse.Coh_P_H_Safe{ExpeInfo.nmouse}(ss,dd,:) =  nanmean(Data(Restrict(Coh_P_H,SafeZone)));
                        MouseByMouse.Coh_B_H_Safe{ExpeInfo.nmouse}(ss,dd,:) =  nanmean(Data(Restrict(Coh_B_H,SafeZone)));
                        
                        MouseByMouse.SpB_Safe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpB,SafeZone)));
                        MouseByMouse.SpP_Safe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpP,SafeZone)));
                        MouseByMouse.SpH_Safe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpH,SafeZone)));
                        
                        if not(isempty(chan_HPCrip))
                            MouseByMouse.SpHR_Safe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpHR,SafeZone)));
                        else
                            MouseByMouse.SpHR_Safe{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        end
                        
                        
                        MouseByMouse.MeanShapeSFUp_OB{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDifftsd_OB,SafeZone)));
                        MouseByMouse.MeanShapeSFUp_PFC{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TUptsd_PFC,SafeZone)));
                        
                        MouseByMouse.MeanShapeSFDown_OB{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDowntsd_OB,SafeZone)));
                        MouseByMouse.MeanShapeSFDown_PFC{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDowntsd_PFC,SafeZone)));
                        
                        MouseByMouse.MeanShapeSFDiff_OB{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDifftsd_OB,SafeZone)));
                        MouseByMouse.MeanShapeSFDIff_PFC{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDifftsd_PFC,SafeZone)));
                        
                        temp = (Data(Restrict(TDifftsd_OB,SafeZone)));
                        MouseByMouse.AllValsSF_OB{ExpeInfo.nmouse}{ss,dd} = min(temp(:,590:660)');
                        
                        temp = (Data(Restrict(TDifftsd_PFC,SafeZone)));
                        MouseByMouse.AllValsSF_PFC{ExpeInfo.nmouse}{ss,dd} = min(temp(:,590:660)');
                    else
                        MouseByMouse.Coh_P_B_Safe{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.Coh_P_H_Safe{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.Coh_B_H_Safe{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.SpB_Safe{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        MouseByMouse.SpP_Safe{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.SpH_Safe{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.SpHR_Safe{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        
                        MouseByMouse.MeanShapeSFUp_OB{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeSFUp_PFC{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeSFDown_OB{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeSFDown_PFC{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeSFDiff_OB{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeSFDIff_PFC{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.AllValsSF_OB{ExpeInfo.nmouse}{ss,dd} =  [];
                        MouseByMouse.AllValsSF_PFC{ExpeInfo.nmouse}{ss,dd} = [];
                        
                    end
                    
                    if MouseByMouse.DurActive{ExpeInfo.nmouse}(ss,dd)>1
                        MouseByMouse.Coh_P_B_Active{ExpeInfo.nmouse}(ss,dd,:) =  nanmean(Data(Restrict(Coh_P_B,ActivePeriod)));
                        MouseByMouse.Coh_P_H_Active{ExpeInfo.nmouse}(ss,dd,:) =  nanmean(Data(Restrict(Coh_P_H,ActivePeriod)));
                        MouseByMouse.Coh_B_H_Active{ExpeInfo.nmouse}(ss,dd,:) =  nanmean(Data(Restrict(Coh_B_H,ActivePeriod)));
                        
                        MouseByMouse.SpB_Active{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpB,ActivePeriod)));
                        MouseByMouse.SpP_Active{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpP,ActivePeriod)));
                        MouseByMouse.SpH_Active{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpH,ActivePeriod)));
                        if not(isempty(chan_HPCrip))
                            MouseByMouse.SpHR_Active{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(SpHR,ActivePeriod)));
                        else
                            MouseByMouse.SpHR_Active{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        end
                        
                        
                        MouseByMouse.MeanShapeActUp_OB{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDifftsd_OB,ActivePeriod)));
                        MouseByMouse.MeanShapeActUp_PFC{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TUptsd_PFC,ActivePeriod)));
                        
                        MouseByMouse.MeanShapeActDown_OB{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDowntsd_OB,ActivePeriod)));
                        MouseByMouse.MeanShapeActDown_PFC{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDowntsd_PFC,ActivePeriod)));
                        
                        MouseByMouse.MeanShapeActDiff_OB{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDifftsd_OB,ActivePeriod)));
                        MouseByMouse.MeanShapeActDIff_PFC{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(TDifftsd_PFC,ActivePeriod)));
                        
                        temp = (Data(Restrict(TDifftsd_OB,ActivePeriod)));
                        MouseByMouse.AllValsAct_OB{ExpeInfo.nmouse}{ss,dd} = min(temp(:,590:660)');
                        
                        temp = (Data(Restrict(TDifftsd_PFC,ActivePeriod)));
                        MouseByMouse.AllValsAct_PFC{ExpeInfo.nmouse}{ss,dd} = min(temp(:,590:660)');
                    else
                        MouseByMouse.Coh_P_B_Active{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.Coh_P_H_Active{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        MouseByMouse.Coh_B_H_Active{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        
                        
                        MouseByMouse.SpB_Active{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        MouseByMouse.SpP_Active{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        MouseByMouse.SpH_Active{ExpeInfo.nmouse}(ss,dd,:) = nan(1,261);
                        MouseByMouse.SpHR_Active{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,261);
                        
                        MouseByMouse.MeanShapeActUp_OB{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeActUp_PFC{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeActDown_OB{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeActDown_PFC{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeActDiff_OB{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.MeanShapeActDIff_PFC{ExpeInfo.nmouse}(ss,dd,:) =  nan(1,1251);
                        MouseByMouse.AllSkGuessSfValsAct_OB{ExpeInfo.nmouse}{ss,dd} =  [];
                        MouseByMouse.AllValsAct_PFC{ExpeInfo.nmouse}{ss,dd} = [];
                        
                    end
                    
                    fLow = f;
                end
                
            end
        end
    end
end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/PFCOBHPCCoherence
% keyboard
%% Mouse averaged results
AllMice = unique(MouseNum);
AllMice(1) = [];
VarNames = {'Coh_B_H','Coh_P_H','Coh_P_B','SpB','SpP','SpH','SpHR'};
EpochName = {'Active','Shock','Safe'};
clear HRVarShock HRSafe HRShock RipSafe RipShock HRVarSafe OBSPecShock TimeShock TimeSafe OBSPecSafe FreqOBShock FreqOBSafe
for m=1:length(AllMice)
    
    for h = 1:length(VarNames)
        for e = 1:length(EpochName)
            if not(isempty(MouseByMouse.([VarNames{h},'_',EpochName{e}]){AllMice(m)}))
                SpecShockTemp = MouseByMouse.([VarNames{h},'_',EpochName{e}]){AllMice(m)};
                SpecShockTemp = reshape(SpecShockTemp,[size(SpecShockTemp,1)*size(SpecShockTemp,2),261]);
                if size(SpecShockTemp,1)>1
                    SpecShockTempTime = squeeze(MouseByMouse.(['Dur',EpochName{e}]){AllMice(m)});
                    SpecShockTempTime = SpecShockTempTime(:);
                    SpecShockTemp(isnan(SpecShockTempTime)|(SpecShockTempTime==0),:) = [];
                    SpecShockTempTime(isnan(SpecShockTempTime)|(SpecShockTempTime==0)) = [];
                    Sptemp = SpecShockTemp'*SpecShockTempTime/nansum(SpecShockTempTime);
                    Spec.(EpochName{e}).(VarNames{h})(m,:) = Sptemp;
                else
                    Spec.(EpochName{e}).(VarNames{h})(m,:) = SpecShockTemp;
                    
                end
            else
                Spec.(EpochName{e}).(VarNames{h})(m,:) = nan(1,261);
            end
        end
    end
    
end

figure
Cols = {[0.6 0.6 0.6],UMazeColors('shock'),UMazeColors('safe')};
for h = 1:length(VarNames)
 if h>3
            subplot(2,4,h+1)
    else
    subplot(2,3,h)
 end
 for e = 1:length(EpochName)
        
        SpecToUse = (Spec.(EpochName{e}).(VarNames{h}));
        [val,ind]=max(SpecToUse(:,20:end)'); ind=ind+20;
        Freq{h}{e} = fLow(ind);
        Coh{h}{e} = val;
        
        g = shadedErrorBar(fLow,nanmean(SpecToUse),stdError(SpecToUse));
        set(g.patch,'FaceColor',Cols{e},'FaceAlpha',0.5)
        set(g.mainLine,'Color',Cols{e},'linewidth',2), hold on
        
        hold on
    end
    title(VarNames{h})
    xlim([1 15])
    box off
    set(gca,'LineWidth',2,'FontSize',15)
    xlabel('Frequency(Hz)')
    ylabel('Power (AU)')
    %     ylim([0.4 0.9])
end

figure
subplot(1,3,1)
Cols = {UMazeColors('shock'),UMazeColors('safe')};
MakeSpreadAndBoxPlot_SB(Coh{4}(2:3),Cols,[1,2])
[p,h5,stats] = signrank(Coh{4}{2},Coh{4}{3})
sigstar({{1,2}},p),
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:2,'XTickLabel',{'Shock','Safe'})
ylabel('Power(AU)')
title('OB')

subplot(1,3,2)
Coh{5}{2}(3) = NaN; % One abherrant value removed
Cols = {UMazeColors('shock'),UMazeColors('safe')};
MakeSpreadAndBoxPlot_SB(Coh{5}(2:3),Cols,[1,2])
[p,h5,stats] = signrank(Coh{5}{2},Coh{5}{3})
sigstar({{1,2}},p),
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:2,'XTickLabel',{'Shock','Safe'})
ylabel('Power(AU)')
title('PFC')

subplot(1,3,3)
Cols = {UMazeColors('shock'),UMazeColors('safe')};
MakeSpreadAndBoxPlot_SB(Coh{3}(2:3),Cols,[1,2])
[p,h5,stats] = signrank(Coh{3}{2},Coh{4}{3})
sigstar({{1,2}},p),
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:2,'XTickLabel',{'Shock','Safe'})
ylabel('Coherence')
title('OB/PFC coherence')

figure
Cols = {[0.6 0.6 0.6],UMazeColors('shock'),UMazeColors('safe')};
for h = 1:length(VarNames)
    if h>3
            subplot(2,4,h+1)
    else
    subplot(2,3,h)
    end
    for e = 1:length(EpochName)
        SpecToUse = (Spec.(EpochName{e}).(VarNames{h}));
        MeanVal(e,:) = nanmean(SpecToUse(:,20:end)');
    end
    MeanVal = nanmean(MeanVal);
    for e = 1:length(EpochName)
        SpecToUse = (Spec.(EpochName{e}).(VarNames{h}));
        if h>3
        for t = 1:size(SpecToUse,1)
            SpecToUse(t,:) = SpecToUse(t,:)./MeanVal(t);
        end
        end
    
    [val,ind]=max(SpecToUse(:,20:end)'); ind=ind+20;
    Freq{h}{e} = fLow(ind);
    Coh{h}{e} = val;
    
    g = shadedErrorBar(fLow,nanmean(SpecToUse),stdError(SpecToUse));
    set(g.patch,'FaceColor',Cols{e},'FaceAlpha',0.5)
    set(g.mainLine,'Color',Cols{e},'linewidth',2), hold on
    
    hold on
end
title(VarNames{h})
xlim([1 15])
box off
set(gca,'LineWidth',2,'FontSize',15)
xlabel('Frequency(Hz)')
ylabel('Power (AU)')
%     ylim([0.4 0.9])
end

figure
subplot(1,3,1)
Cols = {UMazeColors('shock'),UMazeColors('safe')};
MakeSpreadAndBoxPlot_SB(Coh{4}(2:3),Cols,[1,2])
[p,h5,stats] = signrank(Coh{4}{2},Coh{4}{3})
sigstar({{1,2}},p),
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:2,'XTickLabel',{'Shock','Safe'})
ylabel('Power(AU)')
title('OB')

subplot(1,3,2)
Cols = {UMazeColors('shock'),UMazeColors('safe')};
MakeSpreadAndBoxPlot_SB(Coh{5}(2:3),Cols,[1,2])
[p,h5,stats] = signrank(Coh{5}{2},Coh{5}{3})
sigstar({{1,2}},p),
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:2,'XTickLabel',{'Shock','Safe'})
ylabel('Power(AU)')
title('PFC')

subplot(1,3,3)
Cols = {UMazeColors('shock'),UMazeColors('safe')};
MakeSpreadAndBoxPlot_SB(Coh{3}(2:3),Cols,[1,2])
[p,h5,stats] = signrank(Coh{3}{2},Coh{4}{3})
sigstar({{1,2}},p),
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:2,'XTickLabel',{'Shock','Safe'})
ylabel('Coherence')
title('OB/PFC coherence')


    for h = 1:length(VarNames)
        subplot(2,3,h)
        PlotErrorBarN_KJ(Freq{h},'newfig',0)
        subplot(2,3,h+3)
        PlotErrorBarN_KJ(Coh{h},'newfig',0)
    end
    
    h=3;
    Cols = {UMazeColors('shock'),UMazeColors('safe')};
    MakeSpreadAndBoxPlot_SB(Coh{h}(2:3),Cols,[1,2])
    [p,h5,stats] = signrank(Coh{h}{2},Coh{h}{3})
    sigstar({{1,2}},p),
set(gca,'LineWidth',2,'FontSize',15,'XTick',1:2,'XTickLabel',{'Shock','Safe'})
ylabel('Coherence')

    %% Look at response shapes
    clear Shape
    for m=1:length(AllMice)
        
        
        SpecShockTemp_OB = MouseByMouse.MeanShapeSKDiff_OB{AllMice(m)};
        SpecShockTemp_PFC = MouseByMouse.MeanShapeSKDIff_PFC{AllMice(m)};
        
        SpecSafeTemp_OB = MouseByMouse.MeanShapeSFDiff_OB{AllMice(m)};
        SpecSafeTemp_PFC = MouseByMouse.MeanShapeSFDIff_PFC{AllMice(m)};
        
        
        SpecActTemp_OB = MouseByMouse.MeanShapeActDiff_OB{AllMice(m)};
        SpecActTemp_PFC = MouseByMouse.MeanShapeActDIff_PFC{AllMice(m)};
        
        SpecShockTempFin_OB = [];
        SpecShockTempFin_PFC = [];
        SpecSafeTempFin_OB = [];
        SpecSafeTempFin_PFC = [];
        SpecActTempFin_OB = [];
        SpecActTempFin_PFC = [];
        
        
        TotDurSk = [];
        TotDurSf = [];
        TotDurAct = [];
        for k = 1 : size(SpecShockTemp_OB,1)
            for kk = 1 : size(SpecShockTemp_OB,2)
                if MouseByMouse.DurShock{AllMice(m)}(k,kk)>0
                    SpecShockTempFin_OB = [SpecShockTempFin_OB,squeeze(SpecShockTemp_OB(k,kk,:)*MouseByMouse.DurShock{AllMice(m)}(k,kk))];
                    SpecShockTempFin_PFC = [SpecShockTempFin_PFC,squeeze(SpecShockTemp_PFC(k,kk,:)*MouseByMouse.DurShock{AllMice(m)}(k,kk))];
                    TotDurSk = [TotDurSk,MouseByMouse.DurShock{AllMice(m)}(k,kk)];
                end
                if MouseByMouse.DurSafe{AllMice(m)}(k,kk)>0
                    SpecSafeTempFin_OB = [SpecSafeTempFin_OB,squeeze(SpecSafeTemp_OB(k,kk,:)*MouseByMouse.DurSafe{AllMice(m)}(k,kk))];
                    SpecSafeTempFin_PFC = [SpecSafeTempFin_PFC,squeeze(SpecSafeTemp_PFC(k,kk,:)*MouseByMouse.DurSafe{AllMice(m)}(k,kk))];
                    TotDurSf = [TotDurSf,MouseByMouse.DurSafe{AllMice(m)}(k,kk)];
                end
                if MouseByMouse.DurActive{AllMice(m)}(k,kk)>0
                    SpecActTempFin_OB = [SpecActTempFin_OB,squeeze(SpecActTemp_OB(k,kk,:)*MouseByMouse.DurActive{AllMice(m)}(k,kk))];
                    SpecActTempFin_PFC = [SpecActTempFin_PFC,squeeze(SpecActTemp_PFC(k,kk,:)*MouseByMouse.DurActive{AllMice(m)}(k,kk))];
                    TotDurAct = [TotDurAct,MouseByMouse.DurActive{AllMice(m)}(k,kk)];
                end
            end
        end
        if (size(SpecActTempFin_OB,1)==1251)
            Shape.Active.OB(m,:) = nansum(SpecActTempFin_OB',1)./nansum(TotDurAct);
            Shape.Active.PFC(m,:) = nansum(SpecActTempFin_PFC',1)./nansum(TotDurAct);
        else
            Shape.Active.OB(m,:) = nan(1,1251);
            Shape.Active.PFC(m,:) = nan(1,1251);
        end
        
        if (size(SpecShockTempFin_OB,1)==1251)
            Shape.FzSk.OB(m,:) = nansum(SpecShockTempFin_OB',1)./nansum(TotDurSk);
            Shape.FzSk.PFC(m,:) = nansum(SpecShockTempFin_PFC',1)./nansum(TotDurSk);
        else
            Shape.FzSk.OB(m,:) =  nan(1,1251);
            Shape.FzSk.PFC(m,:) = nan(1,1251);
        end
        
        if (size(SpecSafeTempFin_OB,1)==1251)
            Shape.FzSf.OB(m,:) = nansum(SpecSafeTempFin_OB',1)./nansum(TotDurSf);
            Shape.FzSf.PFC(m,:) = nansum(SpecSafeTempFin_PFC',1)./nansum(TotDurSf);
        else
            Shape.FzSf.OB(m,:) =  nan(1,1251);
            Shape.FzSf.PFC(m,:) = nan(1,1251);
            
        end
    end
    tpstrig = M(:,1);
    figure
    g = shadedErrorBar(tpstrig,nanmean(Shape.FzSk.OB),stdError(Shape.FzSk.OB));
    set(g.patch,'FaceColor',Cols{1},'FaceAlpha',0.5)
    set(g.mainLine,'Color',Cols{1},'linewidth',2), hold on
    hold on
    g = shadedErrorBar(tpstrig,nanmean(Shape.FzSf.OB),stdError(Shape.FzSf.OB));
    set(g.patch,'FaceColor',Cols{2},'FaceAlpha',0.5)
    set(g.mainLine,'Color',Cols{2},'linewidth',2), hold on
title('OB')

    figure
    g = shadedErrorBar(tpstrig,nanmean(Shape.FzSk.PFC),stdError(Shape.FzSk.PFC));
    set(g.patch,'FaceColor',Cols{1},'FaceAlpha',0.5)
    set(g.mainLine,'Color',Cols{1},'linewidth',2), hold on
    hold on
    g = shadedErrorBar(tpstrig,nanmean(Shape.FzSf.PFC),stdError(Shape.FzSf.PFC));
    set(g.patch,'FaceColor',Cols{2},'FaceAlpha',0.5)
    set(g.mainLine,'Color',Cols{2},'linewidth',2), hold on
set(gca,'LineWidth',2,'FontSize',15)
box off
xlabel('Time to OB trough (s)')
ylabel('Voltage')
title('PFC')


    clear val
    [val.FzSf.PFC,ind] = min(Shape.FzSf.PFC');
    [val.FzSf.OB,ind] = min(Shape.FzSf.OB');
    
    [val.FzSk.PFC,ind] = min(Shape.FzSk.PFC');
    [val.FzSk.OB,ind] = min(Shape.FzSk.OB');
    
    
    [val.FzSf.PFC] = sum(((Shape.FzSf.PFC').^2));
    [val.FzSf.OB] = sum(((Shape.FzSf.OB').^2));
    
    [val.FzSk.PFC] = sum(((Shape.FzSk.PFC').^2));
    [val.FzSk.OB] = sum(((Shape.FzSk.OB').^2));
    
    B = val.FzSf.PFC'./val.FzSf.OB';
    A = val.FzSk.PFC'./val.FzSk.OB';
    ToDel = find(or(isnan(A),isnan(B)));
    A(ToDel)= [];
    B(ToDel)= [];
    clf
    A(end-1) = [];
    B(end-1) = [];
    MakeSpreadAndBoxPlot_SB({A,B},Cols,[1,2])
    [p,h5,stats] = signrank(A,B)
    sigstar({{1,2}},p),
    set(gca,'LineWidth',2,'FontSize',15,'XTick',1:2,'XTickLabel',{'Shock','Safe'})
    ylabel('Power ratio PFC/OB')

    %% Look at response shapes
    clear Shape
    for m=1:length(AllMice)
        
                SpecShockTempFin_OB = [];
        SpecShockTempFin_PFC = [];
        SpecSafeTempFin_OB = [];
        SpecSafeTempFin_PFC = [];
        SpecActTempFin_OB = [];
        SpecActTempFin_PFC = [];

     
        for k = 1 : size(MouseByMouse.AllValsSK_OB{AllMice(m)},1)
            for kk = 1 : size(MouseByMouse.AllValsSK_OB{AllMice(m)},2)
                if MouseByMouse.DurShock{AllMice(m)}(k,kk)>0
                    SpecShockTempFin_OB = [SpecShockTempFin_OB,MouseByMouse.AllValsSK_OB{AllMice(m)}{k,kk}];
                    SpecShockTempFin_PFC = [SpecShockTempFin_PFC,MouseByMouse.AllValsSK_PFC{AllMice(m)}{k,kk}];
                end
                if MouseByMouse.DurSafe{AllMice(m)}(k,kk)>0
                    SpecSafeTempFin_OB = [SpecSafeTempFin_OB,MouseByMouse.AllValsSF_OB{AllMice(m)}{k,kk}];
                    SpecSafeTempFin_PFC = [SpecSafeTempFin_PFC,MouseByMouse.AllValsSF_PFC{AllMice(m)}{k,kk}];
                end
                if MouseByMouse.DurActive{AllMice(m)}(k,kk)>0
                    SpecActTempFin_OB = [SpecActTempFin_OB,MouseByMouse.AllValsAct_OB{AllMice(m)}{k,kk}];
                    SpecActTempFin_PFC = [SpecActTempFin_PFC,MouseByMouse.AllValsAct_PFC{AllMice(m)}{k,kk}];
                end
            end
        end
        
        AllData.Act.OB{m} = SpecSafeTempFin_OB;
        AllData.Act.PFC{m} = SpecActTempFin_PFC;
       
        
        AllData.FzSk.OB{m} = SpecShockTempFin_OB;
        AllData.FzSk.PFC{m} = SpecShockTempFin_PFC;
        
        AllData.FzSf.OB{m} = SpecSafeTempFin_OB;
        AllData.FzSf.PFC{m} = SpecSafeTempFin_PFC;
        
    end
    
    
    
    
    clf
            ft = fittype( 'poly1' );
            
            for m = 1:length(AllData.FzSk.PFC)
                try
                [pSk(m,:),S,mu] = polyfit(AllData.FzSk.OB{m},AllData.FzSk.PFC{m},1);
                
                [xData, yData] = prepareCurveData(AllData.FzSk.OB{m},AllData.FzSk.PFC{m} );
                [fitresultSk, gof] = fit( xData, yData, ft );
                pSk(m,:) = coeffvalues(fitresultSk);
                
                [xData, yData] = prepareCurveData(AllData.FzSf.OB{m},AllData.FzSf.PFC{m} );
                [fitresultSf, gof] = fit( xData, yData, ft );
                pSf(m,:) = coeffvalues(fitresultSf);
                
                SkGuessSf(m) = nanmean(fitresultSk(AllData.FzSf.OB{m}));
                SfGuessSk(m) =nanmean(fitresultSf(AllData.FzSk.OB{m}));
                
                SfGuessSf(m) = nanmean(fitresultSf(AllData.FzSf.OB{m}));
                SkGuessSk(m) =nanmean(fitresultSk(AllData.FzSk.OB{m}));
               
                RealSfOB(m) = nanmean(AllData.FzSf.OB{m});
                RealSkOB(m) = nanmean(AllData.FzSk.OB{m});
                
                RealSfPFC(m) = nanmean(AllData.FzSf.PFC{m});
                RealSkPFC(m) = nanmean(AllData.FzSk.PFC{m});

                end
                %pause
                clf
            end
            
            
ToDel = [find(or(or(RealSfPFC==0,RealSkPFC==0),or(RealSfOB==0,RealSkOB==0)))];
RealSfPFC(ToDel) = [];
RealSkPFC(ToDel) = [];
RealSfOB(ToDel) = [];
RealSkOB(ToDel) = [];