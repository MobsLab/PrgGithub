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
                    clear TTLInfo smooth_ghi
                    load('behavResources_SB.mat')
                    load('ExpeInfo.mat')
                    MouseNum(ss,d,dd) = ExpeInfo.nmouse;
                    
                    % Get epochs
                    load('StateEpochSB.mat','SleepyEpoch')
                    load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','smooth_ghi')
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
                    
                    MouseByMouse.DurSafe{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(SafeZone,'s')-Start(SafeZone,'s'));
                    MouseByMouse.DurShock{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(ShockZone,'s')-Start(ShockZone,'s'));
                    MouseByMouse.IsSession{ExpeInfo.nmouse}(ss,dd) = 1;
                    
                    MouseByMouse.SpeedSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,SafeZone)));
                    MouseByMouse.SpeedShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,ShockZone)));
                    MouseByMouse.SpeedNoFz{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,TotalEpoch-Behav.FreezeEpoch)));
                    
                    MouseByMouse.GammaSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(smooth_ghi,SafeZone)));
                    MouseByMouse.GammaShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(smooth_ghi,ShockZone)));

                    
                    try
                        MouseByMouse.MovSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.MovAcctsd,SafeZone)));
                        MouseByMouse.MovShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.MovAcctsd,ShockZone)));
                        MouseByMouse.MovNoFz{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.MovAcctsd,TotalEpoch-Behav.FreezeEpoch)));
                        if nanmean(Data(Restrict(Behav.MovAcctsd,ShockZone)))>9e6
                            keyboard
                        end
                    catch
                        MouseByMouse.MovSafe{ExpeInfo.nmouse}(ss,dd)  = NaN;
                        MouseByMouse.MovShock{ExpeInfo.nmouse}(ss,dd) = NaN;
                        MouseByMouse.MovNoFz{ExpeInfo.nmouse}(ss,dd) = NaN;
                    end
                    
                    % Ob spec
                    clear Spectro
                    load('B_Low_Spectrum.mat')
                    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                    MouseByMouse.OBShock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ShockZone)));
                    MouseByMouse.OBSafe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,SafeZone)));
                    fLow = Spectro{3};
                    
                    
                    % Heart rate and heart rate variability in and out of freezing
                    if exist('HeartBeatInfo.mat')>0
                        clear EKG
                        load('HeartBeatInfo.mat')
                        HRVar = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
                        MouseByMouse.HRShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(EKG.HBRate,ShockZone)));
                        MouseByMouse.HRSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(EKG.HBRate,SafeZone)));
                        MouseByMouse.HRVarShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(HRVar,ShockZone)));
                        MouseByMouse.HRVarSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(HRVar,SafeZone)));
                        
                    else
                        MouseByMouse.HRShock{ExpeInfo.nmouse}(ss,dd) = NaN;
                        MouseByMouse.HRSafe{ExpeInfo.nmouse}(ss,dd) = NaN;
                        MouseByMouse.HRVarShock{ExpeInfo.nmouse}(ss,dd) = NaN;
                        MouseByMouse.HRVarSafe{ExpeInfo.nmouse}(ss,dd) = NaN;
                        
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
        
        clear smooth_ghi SmoothGamma SWSEpoch Sptsd B_Low_Spectrum EKG ExpeInfo
        cd(FolderToUse)
        load('ExpeInfo.mat')
        clear SWSEpoch smooth_ghi
        try
            load('SleepScoring_OBGamma.mat','SWSEpoch','SmoothGamma')
            smooth_ghi =  SmoothGamma;
        catch
            load('StateEpochSB.mat','SWSEpoch','smooth_ghi')
        end
        load('B_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        MouseByMouse.OBSleep{ExpeInfo.nmouse} = nanmean(Data(Restrict(Sptsd,SWSEpoch)));
        MouseByMouse.GammaSleep{ExpeInfo.nmouse} = nanmean(Data(Restrict(smooth_ghi,SWSEpoch)));
        
        if exist('HeartBeatInfo.mat')>0
            clear EKG
            load('HeartBeatInfo.mat')
            HRVar = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
            MouseByMouse.HRSleep{ExpeInfo.nmouse} = nanmean(Data(Restrict(EKG.HBRate,SWSEpoch)));
            MouseByMouse.HRVarSleep{ExpeInfo.nmouse} = nanmean(Data(Restrict(HRVar,SWSEpoch)));
            
        else
            MouseByMouse.HRSleep{ExpeInfo.nmouse} = NaN;
            MouseByMouse.HRVarSleep{ExpeInfo.nmouse} = NaN;
        end
        
    end
    
    keyboard
    
    %% Mouse averaged results
    AllMice = unique(MouseNum);
    AllMice(1) = [];
    clear HRVarShock HRSafe HRShock RipSafe RipShock HRVarSafe OBSPecShock TimeShock TimeSafe OBSPecSafe FreqOBShock FreqOBSafe
    for m=1:length(AllMice)
        
        % HR shock
        HRShockTemp = squeeze(MouseByMouse.HRShock{AllMice(m)});
        HRShockTemp = HRShockTemp(:);
        HRShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
        HRShockTempTime = HRShockTempTime(:);
        HRShockTemp(isnan(HRShockTempTime)|(HRShockTempTime==0)) = [];
        HRShockTempTime(isnan(HRShockTempTime)|(HRShockTempTime==0)) = [];
        HRShock(m) = HRShockTemp'*HRShockTempTime/sum(HRShockTempTime);
        
        % HR Safe
        HRSafeTemp = squeeze(MouseByMouse.HRSafe{AllMice(m)});
        HRSafeTemp = HRSafeTemp(:);
        HRSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
        HRSafeTempTime = HRSafeTempTime(:);
        HRSafeTemp(isnan(HRSafeTempTime)|(HRSafeTempTime==0)) = [];
        HRSafeTempTime(isnan(HRSafeTempTime)|(HRSafeTempTime==0)) = [];
        HRSafe(m) = HRSafeTemp'*HRSafeTempTime/sum(HRSafeTempTime);
        
        % HR SLEEP
        HRSleep(m) = MouseByMouse.HRSleep{AllMice(m)};
        
        % HRVar shock
        HRVarShockTemp = squeeze(MouseByMouse.HRVarShock{AllMice(m)});
        HRVarShockTemp = HRVarShockTemp(:);
        HRVarShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
        HRVarShockTempTime = HRVarShockTempTime(:);
        HRVarShockTemp(isnan(HRVarShockTempTime)|(HRVarShockTempTime==0)) = [];
        HRVarShockTempTime(isnan(HRVarShockTempTime)|(HRVarShockTempTime==0)) = [];
        HRVarShock(m) = HRVarShockTemp'*HRVarShockTempTime/sum(HRVarShockTempTime);
        
        % HRVar Safe
        HRVarSafeTemp = squeeze(MouseByMouse.HRVarSafe{AllMice(m)});
        HRVarSafeTemp = HRVarSafeTemp(:);
        HRVarSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
        HRVarSafeTempTime = HRVarSafeTempTime(:);
        HRVarSafeTemp(isnan(HRVarSafeTempTime)|(HRVarSafeTempTime==0)) = [];
        HRVarSafeTempTime(isnan(HRVarSafeTempTime)|(HRVarSafeTempTime==0)) = [];
        HRVarSafe(m) = HRVarSafeTemp'*HRVarSafeTempTime/sum(HRVarSafeTempTime);
        
        % Hr var
        HRVarSleep(m) = MouseByMouse.HRVarSleep{AllMice(m)};
        
        % Spec
        OBSPecShockTemp = MouseByMouse.OBShock{AllMice(m)};
        OBSPecShockTemp = reshape(OBSPecShockTemp,[size(OBSPecShockTemp,1)*size(OBSPecShockTemp,2),261]);
        OBSPecShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
        OBSPecShockTempTime = OBSPecShockTempTime(:);
        OBSPecShockTemp(isnan(OBSPecShockTempTime)|(OBSPecShockTempTime==0),:) = [];
        OBSPecShockTempTime(isnan(OBSPecShockTempTime)|(OBSPecShockTempTime==0)) = [];
        Sptemp = OBSPecShockTemp'*OBSPecShockTempTime/sum(OBSPecShockTempTime);
        OBSPecShock(m,:) = Sptemp./nansum(Sptemp(14:end));
        TimeShock(m) = nansum(OBSPecShockTempTime);
        
        % safe
        OBSPecSafeTemp = MouseByMouse.OBSafe{AllMice(m)};
        OBSPecSafeTemp = reshape(OBSPecSafeTemp,[size(OBSPecSafeTemp,1)*size(OBSPecSafeTemp,2),261]);
        OBSPecSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
        OBSPecSafeTempTime = OBSPecSafeTempTime(:);
        OBSPecSafeTemp(isnan(OBSPecSafeTempTime)|(OBSPecSafeTempTime==0),:) = [];
        OBSPecSafeTempTime(isnan(OBSPecSafeTempTime)|(OBSPecSafeTempTime==0)) = [];
        Sptemp=(OBSPecSafeTemp'*OBSPecSafeTempTime/sum(OBSPecSafeTempTime));
        OBSPecSafe(m,:) = Sptemp./nansum(Sptemp(14:end));
        TimeSafe(m) = nansum(OBSPecSafeTempTime);
        
        % ob spec
        OBSPecSleep(m,:) = MouseByMouse.OBSleep{AllMice(m)}./nansum(MouseByMouse.OBSleep{AllMice(m)}(14:end));
        
        
        % Gamma shock
        GammaShockTemp = squeeze(MouseByMouse.GammaShock{AllMice(m)});
        GammaShockTemp = GammaShockTemp(:);
        GammaShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
        GammaShockTempTime = GammaShockTempTime(:);
        GammaShockTemp(isnan(GammaShockTempTime)|(GammaShockTempTime==0)) = [];
        GammaShockTempTime(isnan(GammaShockTempTime)|(GammaShockTempTime==0)) = [];
        GammaShock(m) = GammaShockTemp'*GammaShockTempTime/sum(GammaShockTempTime);
        
        % Gamma Safe
        GammaSafeTemp = squeeze(MouseByMouse.GammaSafe{AllMice(m)});
        GammaSafeTemp = GammaSafeTemp(:);
        GammaSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
        GammaSafeTempTime = GammaSafeTempTime(:);
        GammaSafeTemp(isnan(GammaSafeTempTime)|(GammaSafeTempTime==0)) = [];
        GammaSafeTempTime(isnan(GammaSafeTempTime)|(GammaSafeTempTime==0)) = [];
        GammaSafe(m) = GammaSafeTemp'*GammaSafeTempTime/sum(GammaSafeTempTime);
        
        
        % GAMMA SLEEP
        GammaSleep(m) = MouseByMouse.GammaSleep{AllMice(m)};
        
        
    end
    
    
    Cols = {[0.6 0.6 0.6],UMazeColors('Shock'),UMazeColors('Safe')};
    Legends = {'Shock','Safe'};
    
    addpath(genpath('/home/gruffalo/Downloads/MatlabToolbox-master'))
    fig = figure;
        
    A = {HRSleep,HRShock,HRSafe};
    MakeSpreadAndBoxPlot_SB(A,Cols,1:3)
    try,[p,h,stats] = signrank(HRSleep,HRShock);
        sigstar({{1,2}},p),end
     try,[p,h,stats] = signrank(HRSleep,HRSafe);
        sigstar({{1,3}},p),end
    xlim([0.5 3.5])
    set(gca,'LineWidth',2,'FontSize',20,'XTick',[1:3],'XTickLabel',{'Sleep','Fz-Shock','Fz-Sleep'})
    ylabel('Heart rate (Hz)')
    ylim([0 14])
    
    figure
    A = {GammaSleep./GammaSleep,GammaShock./GammaSleep,GammaSafe./GammaSleep};
    MakeSpreadAndBoxPlot_SB(A,Cols,1:3)
    try,[p,h,stats] = signrank(GammaSleep./GammaSleep,GammaShock./GammaSleep);
        sigstar({{1,2}},p),end
     try,[p,h,stats] = signrank(GammaSleep./GammaSleep,GammaSafe./GammaSleep);
        sigstar({{1,3}},p),end
    xlim([0.5 3.5])
    set(gca,'LineWidth',2,'FontSize',20,'XTick',[1:3],'XTickLabel',{'Sleep','Fz-Shock','Fz-Sleep'})
    ylabel('Gamma power norm to sleep')
    
    
    
    
    fig = figure;
    g = shadedErrorBar(fLow,nanmean(OBSPecSleep),stdError(OBSPecSleep));
    set(g.patch,'FaceColor',Cols{1},'FaceAlpha',0.5)
    set(g.mainLine,'Color',Cols{1},'linewidth',2), hold on
     g = shadedErrorBar(fLow,nanmean(OBSPecShock),stdError(OBSPecShock));
    set(g.patch,'FaceColor',Cols{2},'FaceAlpha',0.5)
    set(g.mainLine,'Color',Cols{2},'linewidth',2), hold on
    g = shadedErrorBar(fLow,nanmean(OBSPecSafe),stdError(OBSPecSafe));
    set(g.patch,'FaceColor',Cols{3},'FaceAlpha',0.3)
    set(g.mainLine,'Color',Cols{3},'linewidth',2)
    
    xlim([1 15])
    box off
    set(gca,'LineWidth',2,'FontSize',20)
    xlabel('Frequency(Hz)')
    ylabel('Power (AU)')
    
    saveas(fig.Number,[SaveLocation,filesep,'OBSPec_',Name{SOI},'.fig'])
    saveas(fig.Number,[SaveLocation,filesep,'OBSPec_',Name{SOI},'.png'])

    
    fig = figure;
    subplot(121)
    Cols2 = {[0.6 0.6 0.6],[1 0.6 0.6],[0.6 0.6 1]};
    A = {MovNoFz,MovShock,MovSafe};
    MakeSpreadAndBoxPlot_SB(A,Cols2,1:3)
    try,[p,h,stats] = signrank(MovShock,MovSafe);
        sigstar({{2,3}},p),end
    xlim([0.5 3.5])
    set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
    ylabel('HeadAcceleration')
        set(gca,'LineWidth',2,'FontSize',10,'XTick',[1:3],'XTickLabel',{'Act','Fz-Shock','Fz-Safe'})

    subplot(122)
    A = {SpeedNoFz,SpeedShock,SpeedSafe};
    MakeSpreadAndBoxPlot_SB(A,Cols2,1:3)
    try,[p,h,stats] = signrank(SpeedShock,SpeedSafe);
        sigstar({{2,3}},p),end
    xlim([0.5 3.5])
    set(gca,'LineWidth',2,'FontSize',10,'XTick',[1:3],'XTickLabel',{'Act','Fz-Shock','Fz-Safe'})
    ylabel('Speed')
    saveas(fig.Number,[SaveLocation,filesep,'FreezingMovement_',Name{SOI},'.fig'])
    saveas(fig.Number,[SaveLocation,filesep,'FreezingMovement_',Name{SOI},'.png'])

    
    
end