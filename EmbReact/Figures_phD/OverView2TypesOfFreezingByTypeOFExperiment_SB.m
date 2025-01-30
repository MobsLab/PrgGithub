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
% TestSessionWithNoShockGiven
SessionType{7} =  GetRightSessionsUMaze_SB('AllFreezingSessions');
Name{7} = 'AllFreezingSessions';

SaveLocation = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice';

for SOI = 1:length(SessionType)
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
                    clear TTLInfo
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
                    
                    MouseByMouse.DurSafe{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(SafeZone,'s')-Start(SafeZone,'s'));
                    MouseByMouse.DurShock{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(ShockZone,'s')-Start(ShockZone,'s'));
                    MouseByMouse.IsSession{ExpeInfo.nmouse}(ss,dd) = 1;
                    
                    MouseByMouse.SpeedSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,SafeZone)));
                    MouseByMouse.SpeedShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,ShockZone)));
                    MouseByMouse.SpeedNoFz{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,TotalEpoch-Behav.FreezeEpoch)));
                    
                    
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
                    
                    % OB frequency
                    clear LocalFreq
                    load('InstFreqAndPhase_B.mat','LocalFreq')
                    % smooth the estimates
                    WVBinsize = length(Range(LocalFreq.WV))./length(Range(Behav.LinearDist));
                    LocalFreq.WV = tsd(Range(LocalFreq.WV),movmedian(Data(LocalFreq.WV),ceil(WVBinsize)*2));
                    LocalFreq.PT = tsd(Range(LocalFreq.PT),movmedian(Data(LocalFreq.PT),4));
                    
                    MouseByMouse.FreqShock{ExpeInfo.nmouse}(ss,dd,:) = (nanmean(Data(Restrict(LocalFreq.PT,ShockZone)))+nanmean(Data(Restrict(LocalFreq.WV,ShockZone))))/2;
                    MouseByMouse.FreqSafe{ExpeInfo.nmouse}(ss,dd,:) = (nanmean(Data(Restrict(LocalFreq.PT,SafeZone)))+nanmean(Data(Restrict(LocalFreq.WV,SafeZone))))/2;
                                        
                    % Ob spec
                    clear Spectro
                    load('B_Low_Spectrum.mat')
                    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                    MouseByMouse.OBShock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ShockZone)));
                    MouseByMouse.OBSafe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,SafeZone)));
                    fLow = Spectro{3};
                    
                    % Ripple density
                    if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                        clear RipplesEpochR
                        load('Ripples.mat')
                        MouseByMouse.RippleShock{ExpeInfo.nmouse}(ss,dd) = length(Start(and(RipplesEpochR,ShockZone)));
                        MouseByMouse.RippleSafe{ExpeInfo.nmouse}(ss,dd) = length(Start(and(RipplesEpochR,SafeZone)));
                    else
                        MouseByMouse.RippleShock{ExpeInfo.nmouse}(ss,dd) = NaN;
                        MouseByMouse.RippleSafe{ExpeInfo.nmouse}(ss,dd) = NaN;
                    end
                    
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
    
    
%     keyboard
    %% Mouse averaged results
    AllMice = unique(MouseNum);
    AllMice(1) = [];
    clear HRVarShock HRSafe HRShock RipSafe RipShock HRVarSafe OBSPecShock TimeShock TimeSafe OBSPecSafe FreqOBShock FreqOBSafe
    for m=1:length(AllMice)
        
        % Ripple shock
        RipShockTemp = squeeze(MouseByMouse.RippleShock{AllMice(m)});
        RipShockTemp = RipShockTemp(:);
        RipShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
        RipShockTempTime = RipShockTempTime(:);
        RipShockTemp(isnan(RipShockTempTime)|(RipShockTempTime==0)) = [];
        RipShockTempTime(isnan(RipShockTempTime)|(RipShockTempTime==0)) = [];
        RipFreq = RipShockTemp./RipShockTempTime;
        % weighted mean according to time spent;
        RipShock(m) = RipFreq'*RipShockTempTime/sum(RipShockTempTime);
        
        % Ripple safe
        RipSafeTemp = squeeze(MouseByMouse.RippleSafe{AllMice(m)});
        RipSafeTemp = RipSafeTemp(:);
        RipSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
        RipSafeTempTime = RipSafeTempTime(:);
        RipSafeTemp(isnan(RipSafeTempTime)|(RipSafeTempTime==0)) = [];
        RipSafeTempTime(isnan(RipSafeTempTime)|(RipSafeTempTime==0)) = [];
        RipFreq = RipSafeTemp./RipSafeTempTime;
        % weighted mean according to time spentsum
        RipSafe(m) = RipFreq'*RipSafeTempTime/norm(RipSafeTempTime);
        
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
        
        % Spec
        OBSPecShockTemp = MouseByMouse.OBShock{AllMice(m)};
        OBSPecShockTemp = reshape(OBSPecShockTemp,[size(OBSPecShockTemp,1)*size(OBSPecShockTemp,2),261]);
        OBSPecShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
        OBSPecShockTempTime = OBSPecShockTempTime(:);
        OBSPecShockTemp(isnan(OBSPecShockTempTime)|(OBSPecShockTempTime==0),:) = [];
        OBSPecShockTempTime(isnan(OBSPecShockTempTime)|(OBSPecShockTempTime==0)) = [];
        Sptemp = OBSPecShockTemp'*OBSPecShockTempTime/sum(OBSPecShockTempTime);
        OBSPecShock(m,:) = Sptemp;%./nansum(Sptemp(14:end));
        TimeShock(m) = nansum(OBSPecShockTempTime);
        
        % safe
        OBSPecSafeTemp = MouseByMouse.OBSafe{AllMice(m)};
        OBSPecSafeTemp = reshape(OBSPecSafeTemp,[size(OBSPecSafeTemp,1)*size(OBSPecSafeTemp,2),261]);
        OBSPecSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
        OBSPecSafeTempTime = OBSPecSafeTempTime(:);
        OBSPecSafeTemp(isnan(OBSPecSafeTempTime)|(OBSPecSafeTempTime==0),:) = [];
        OBSPecSafeTempTime(isnan(OBSPecSafeTempTime)|(OBSPecSafeTempTime==0)) = [];
        Sptemp=(OBSPecSafeTemp'*OBSPecSafeTempTime/sum(OBSPecSafeTempTime));
        OBSPecSafe(m,:) = Sptemp;%./nansum(Sptemp(14:end));
        TimeSafe(m) = nansum(OBSPecSafeTempTime);
        Denom = (nansum(OBSPecShock(m,14:end))+nansum(OBSPecSafe(m,14:end)));
        OBSPecShock(m,:) = OBSPecShock(m,:)./Denom;
        OBSPecSafe(m,:) = OBSPecSafe(m,:)./Denom;

        % FreqOB shock
        FreqOBShockTemp = squeeze(MouseByMouse.FreqShock{AllMice(m)});
        FreqOBShockTemp = FreqOBShockTemp(:);
        FreqOBShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
        FreqOBShockTempTime = FreqOBShockTempTime(:);
        FreqOBShockTemp(isnan(FreqOBShockTempTime)|(FreqOBShockTempTime==0)) = [];
        FreqOBShockTempTime(isnan(FreqOBShockTempTime)|(FreqOBShockTempTime==0)) = [];
        FreqOBShock(m) = FreqOBShockTemp'*FreqOBShockTempTime/sum(FreqOBShockTempTime);
        
        % FreqOB safe
        FreqOBSafeTemp = squeeze(MouseByMouse.FreqSafe{AllMice(m)});
        FreqOBSafeTemp = FreqOBSafeTemp(:);
        FreqOBSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
        FreqOBSafeTempTime = FreqOBSafeTempTime(:);
        FreqOBSafeTemp(isnan(FreqOBSafeTempTime)|(FreqOBSafeTempTime==0)) = [];
        FreqOBSafeTempTime(isnan(FreqOBSafeTempTime)|(FreqOBSafeTempTime==0)) = [];
        FreqOBSafe(m) = FreqOBSafeTemp'*FreqOBSafeTempTime/sum(FreqOBSafeTempTime);
        
        % Movement
        MovSafeTemp = squeeze(MouseByMouse.MovSafe{AllMice(m)});
        MovSafeTemp = MovSafeTemp(:);
        MovSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
        MovSafeTempTime = MovSafeTempTime(:);
        MovSafeTemp(isnan(MovSafeTempTime)|(MovSafeTempTime==0)) = [];
        MovSafeTempTime(isnan(MovSafeTempTime)|(MovSafeTempTime==0)) = [];
        MovSafe(m) = nanmean(MovSafeTemp);
        
        % Movement
        MovShockTemp = squeeze(MouseByMouse.MovShock{AllMice(m)});
        MovShockTemp = MovShockTemp(:);
        MovShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
        MovShockTempTime = MovShockTempTime(:);
        MovShockTemp(isnan(MovShockTempTime)|(MovShockTempTime==0)) = [];
        MovShockTempTime(isnan(MovShockTempTime)|(MovShockTempTime==0)) = [];
        MovShock(m) = nanmean(MovShockTemp);
        
        % Movement
        MovNoFzTemp = squeeze(MouseByMouse.MovNoFz{AllMice(m)});
        MovNoFzTemp = MovNoFzTemp(:);
        MovNoFzTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
        MovNoFzTempTime = MovNoFzTempTime(:);
        MovNoFzTemp(isnan(MovNoFzTempTime)|(MovNoFzTempTime==0)) = [];
        MovNoFzTempTime(isnan(MovNoFzTempTime)|(MovNoFzTempTime==0)) = [];
        MovNoFz(m) = nanmean(MovNoFzTemp);
        
        
        % Speedement
        SpeedSafeTemp = squeeze(MouseByMouse.SpeedSafe{AllMice(m)});
        SpeedSafeTemp = SpeedSafeTemp(:);
        SpeedSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
        SpeedSafeTempTime = SpeedSafeTempTime(:);
        SpeedSafeTemp(isnan(SpeedSafeTempTime)|(SpeedSafeTempTime==0)) = [];
        SpeedSafeTempTime(isnan(SpeedSafeTempTime)|(SpeedSafeTempTime==0)) = [];
        SpeedSafe(m) = nanmean(SpeedSafeTemp);
        
        % Speedement
        SpeedShockTemp = squeeze(MouseByMouse.SpeedShock{AllMice(m)});
        SpeedShockTemp = SpeedShockTemp(:);
        SpeedShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
        SpeedShockTempTime = SpeedShockTempTime(:);
        SpeedShockTemp(isnan(SpeedShockTempTime)|(SpeedShockTempTime==0)) = [];
        SpeedShockTempTime(isnan(SpeedShockTempTime)|(SpeedShockTempTime==0)) = [];
        SpeedShock(m) = nanmean(SpeedShockTemp);
        
        % Speedement
        SpeedNoFzTemp = squeeze(MouseByMouse.SpeedNoFz{AllMice(m)});
        SpeedNoFzTemp = SpeedNoFzTemp(:);
        SpeedNoFzTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
        SpeedNoFzTempTime = SpeedNoFzTempTime(:);
        SpeedNoFzTemp(isnan(SpeedNoFzTempTime)|(SpeedNoFzTempTime==0)) = [];
        SpeedNoFzTempTime(isnan(SpeedNoFzTempTime)|(SpeedNoFzTempTime==0)) = [];
        SpeedNoFz(m) = nanmean(SpeedNoFzTemp);
        
    end
    
%     figure
%     subplot(211)
%     OBSPecSafeForImage = OBSPecSafe;
%     OBSPecSafeForImage(find(sum(isnan(OBSPecSafeForImage)')),:) = [];
%     imagesc(fLow,1:13,ZScoreWiWindowSB(OBSPecSafeForImage,[20:261]))
%     clim([-2 4])
%     xlim([1 15])
%     title('Safe')
%     xlabel('Frequency (Hz)')
%     ylabel('Mouse number')
%     set(gca,'LineWidth',2,'FontSize',10)
%     box off
%     
%     subplot(212)
%     OBSPecShockForImage = OBSPecShock;
%     OBSPecShockForImage(find(sum(isnan(OBSPecShockForImage)')),:) = [];
%     imagesc(fLow,1:13,ZScoreWiWindowSB(OBSPecShockForImage,[20:261]))
%     clim([-2 4])
%     xlim([1 15])
%     set(gca,'LineWidth',2,'FontSize',10)
%     box off
%     title('Shock')
%     xlabel('Frequency (Hz)')
%     ylabel('Mouse number')
% 
%     
    Cols = {[1 0.6 0.6],[0.6 0.6 1]};
    Legends = {'Shock','Safe'};
%     
%     addpath(genpath('/home/gruffalo/Downloads/MatlabToolbox-master'))
%     fig = figure;
%     
%     ha = tight_subplot(5,1,[.03 .1],[.07 .01],[.15 .05]);
%     axes(ha(1))
%     A = {FreqOBShock,FreqOBSafe};
%     MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
%     xlim([0.5 2.5])
%     try
%         [p,h,stats] = signrank(FreqOBShock,FreqOBSafe);
%         sigstar({{1,2}},p)
%     end
%     
%     set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
%     ylabel('OB Frequency (Hz)')
%     
%     axes(ha(2))
%     A = {RipShock,RipSafe};
%     MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
%     xlim([0.5 2.5])
%     try,[p,h,stats] = signrank(RipShock,RipSafe);
%         sigstar({{1,2}},p),end
%     set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
%     ylabel('Ripples /sec')
%     
%     axes(ha(3))
%     A = {HRShock,HRSafe};
%     MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
%     try,[p,h,stats] = signrank(HRShock,HRSafe);
%         sigstar({{1,2}},p),end
%     xlim([0.5 2.5])
%     set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
%     ylabel('Heart rate (Hz)')
%     
%     axes(ha(4))
%     A = {HRVarShock,HRVarSafe};
%     MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
%     xlim([0.5 2.5])
%     try,[p,h,stats] = signrank(HRVarShock,HRVarSafe);
%         sigstar({{1,2}},p),end
%     xlim([0.5 2.5])
%     set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
%     ylabel('Heart rate var')
%     
%     axes(ha(5))
%     A = {1-(TimeSafe./(TimeShock+TimeSafe)),(TimeSafe./(TimeShock+TimeSafe))};
%     MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
%     try,[p,h,stats] = signrank(1-(TimeSafe./(TimeShock+TimeSafe)),(TimeSafe./(TimeShock+TimeSafe)));end
%     sigstar({{1,2}},p)
%     xlim([0.5 2.5])
%     set(gca,'LineWidth',2,'FontSize',10,'XTick',[1,2],'XTickLabel',{'Shock','Safe'})
%     ylabel('% freezing time')
%     
%     saveas(fig.Number,[SaveLocation,filesep,'AllParams_',Name{SOI},'.fig'])
%     saveas(fig.Number,[SaveLocation,filesep,'AllParams_',Name{SOI},'.png'])
    
    fig = figure;
    g = shadedErrorBar(fLow,nanmean(OBSPecShock),stdError(OBSPecShock));
    set(g.patch,'FaceColor',Cols{1},'FaceAlpha',0.5)
    set(g.mainLine,'Color',Cols{1},'linewidth',2), hold on
    g = shadedErrorBar(fLow,nanmean(OBSPecSafe),stdError(OBSPecSafe));
    set(g.patch,'FaceColor',Cols{2},'FaceAlpha',0.3)
    set(g.mainLine,'Color',Cols{2},'linewidth',2)
    xlim([1 15])
    box off
    set(gca,'LineWidth',2,'FontSize',15)
    xlabel('Frequency(Hz)')
    ylabel('Power (AU)')
    
    saveas(fig.Number,[SaveLocation,filesep,'OBSPecNewNorm_',Name{SOI},'.fig'])
    saveas(fig.Number,[SaveLocation,filesep,'OBSPecNewNorm_',Name{SOI},'.png'])f

    
%     fig = figure;
%     subplot(121)
%     Cols2 = {[0.6 0.6 0.6],[1 0.6 0.6],[0.6 0.6 1]};
%     A = {MovNoFz,MovShock,MovSafe};
%     MakeSpreadAndBoxPlot_SB(A,Cols2,1:3)
%     try,[p,h,stats] = signrank(MovShock,MovSafe);
%         sigstar({{2,3}},p),end
%     xlim([0.5 3.5])
%     set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
%     ylabel('HeadAcceleration')
%         set(gca,'LineWidth',2,'FontSize',10,'XTick',[1:3],'XTickLabel',{'Act','Fz-Shock','Fz-Safe'})
% 
%     subplot(122)
%     A = {SpeedNoFz,SpeedShock,SpeedSafe};
%     MakeSpreadAndBoxPlot_SB(A,Cols2,1:3)
%     try,[p,h,stats] = signrank(SpeedShock,SpeedSafe);
%         sigstar({{2,3}},p),end
%     xlim([0.5 3.5])
%     set(gca,'LineWidth',2,'FontSize',10,'XTick',[1:3],'XTickLabel',{'Act','Fz-Shock','Fz-Safe'})
%     ylabel('Speed')
%     saveas(fig.Number,[SaveLocation,filesep,'FreezingMovement_',Name{SOI},'.fig'])
%     saveas(fig.Number,[SaveLocation,filesep,'FreezingMovement_',Name{SOI},'.png'])

    
    
end