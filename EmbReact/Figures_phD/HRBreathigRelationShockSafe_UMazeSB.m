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
    MouseNum= [];
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
                    if exist('HeartBeatInfo.mat')>0
                        
                        disp(Dir.path{d}{dd})
                        clear TTLInfo smooth_ghi
                        load('behavResources_SB.mat')
                        load('ExpeInfo.mat')
                        if sum(ismember(unique(unique(MouseNum)), ExpeInfo.nmouse))==0
                            MouseByMouse.PhaseSafePT{ExpeInfo.nmouse} = [];
                            MouseByMouse.PhaseSafeWV{ExpeInfo.nmouse} = [];
                            MouseByMouse.PhaseShockPT{ExpeInfo.nmouse} = [];
                            MouseByMouse.PhaseShockWV{ExpeInfo.nmouse} = [];
                        end
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
                        keyboard
                        clear EKG LocalFreq LocalPhase
                        load('InstFreqAndPhase_B.mat')
                        load('HeartBeatInfo.mat')
                        load('ChannelsToAnalyse/EKG.mat')
                        load(['LFPData/LFP',num2str(channel),'.mat'])
                        if MouseByMouse.DurSafe{ExpeInfo.nmouse}(ss,dd)>5
                            
                            [M,T] = PlotRipRaw(LFP,Range(Restrict(EKG.HBTimes,SafeZone),'s'),80,0,0);
                            MouseByMouse.HBSafe{ExpeInfo.nmouse}(ss,dd,:) = interp1(M(:,1),M(:,2),[-0.079:1/1250:0.079]);
                            
                            ph = Restrict(LocalPhase.WV, EKG.HBTimes, 'align', 'closest', 'time', 'align');
                            MouseByMouse.PhaseSafeWV{ExpeInfo.nmouse} = [MouseByMouse.PhaseSafeWV{ExpeInfo.nmouse};Data(Restrict(ph,SafeZone))];

                            ph = Restrict(LocalPhase.PT, EKG.HBTimes, 'align', 'closest', 'time', 'align');
                            MouseByMouse.PhaseSafePT{ExpeInfo.nmouse} = [MouseByMouse.PhaseSafePT{ExpeInfo.nmouse};Data(Restrict(ph,SafeZone))];

                        else
                            MouseByMouse.HBSafe{ExpeInfo.nmouse}(ss,dd,:) = nan(1,length([-0.079:1/1250:0.079]));
                            
                        end
                        
                        if MouseByMouse.DurShock{ExpeInfo.nmouse}(ss,dd)>5
                            
                            [M,T] = PlotRipRaw(LFP,Range(Restrict(EKG.HBTimes,ShockZone),'s'),80,0,0);
                            MouseByMouse.HBShock{ExpeInfo.nmouse}(ss,dd,:) = interp1(M(:,1),M(:,2),[-0.079:1/1250:0.079]);
                            
                            ph = Restrict(LocalPhase.WV, EKG.HBTimes, 'align', 'closest', 'time', 'align');
                            MouseByMouse.PhaseShockWV{ExpeInfo.nmouse} = [MouseByMouse.PhaseShockWV{ExpeInfo.nmouse};Data(Restrict(ph,ShockZone))];

                            ph = Restrict(LocalPhase.PT, EKG.HBTimes, 'align', 'closest', 'time', 'align');
                            MouseByMouse.PhaseShockPT{ExpeInfo.nmouse} = [MouseByMouse.PhaseShockPT{ExpeInfo.nmouse};Data(Restrict(ph,ShockZone))];
                            
                        else
                            MouseByMouse.HBShock{ExpeInfo.nmouse}(ss,dd,:) = nan(1,length([-0.079:1/1250:0.079]));
                           
                        end
                        
                    end
                end
            end
        end
    end
end


%% Mouse averaged results
AllMice = unique(MouseNum);
AllMice(1) = [];
clear HRVarShock HRSafe HRShock RipSafe RipShock HRVarSafe OBSPecShock TimeShock TimeSafe OBSPecSafe FreqOBShock FreqOBSafe
for m=1:length(AllMice)
    [row,col] = find(MouseByMouse.DurSafe{AllMice(m)})
    GetAllHBSafe = [];
    for k = 1:length(row)
        GetAllHBSafe = [GetAllHBSafe,MouseByMouse.HBSafe{AllMice(m)}(row(k),col(k),:)];
    end
    
    [row,col] = find(MouseByMouse.DurShock{AllMice(m)})
    GetAllHBShock = [];
    for k = 1:length(row)
        GetAllHBShock = [GetAllHBShock,MouseByMouse.HBSafe{AllMice(m)}(row(k),col(k),:)];
    end
    
    clf
    plot(squeeze(GetAllHBSafe)','b'), hold on
    plot(squeeze(GetAllHBShock)','r')
    pause
    
    
end
%% Mouse averaged results
AllMice = unique(MouseNum);
AllMice(1) = []; pvalSk = 0;
clear HRVarShock HRSafe HRShock RipSafe RipShock HRVarSafe OBSPecShock TimeShock TimeSafe OBSPecSafe FreqOBShock FreqOBSafe
for m=1:length(AllMice)
    rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/FMAToolbox/General/')
    rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
    
    try,[muSf(m), KappaSf(m), pvalSf(m), Rmean, delta, sigma,confDw,confUp] = CircularMean(MouseByMouse.PhaseSafeWV{AllMice(m)});
    catch,pvalSf(m)=NaN;
    end
    try,[muSk(m), KappaSk(m), pvalSk(m), Rmean, delta, sigma,confDw,confUp] = CircularMean(MouseByMouse.PhaseShockWV{AllMice(m)});
    catch, pvalSk(m) = NaN;
    end
    subplot(211)
    hist(MouseByMouse.PhaseSafeWV{AllMice(m)},30)
    pvalSf(m)
    subplot(212)
    hist(MouseByMouse.PhaseShockWV{AllMice(m)},30)
    pvalSk(m)
    pause
    clf
    addpath(genpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/FMAToolbox/General'))
    addpath(genpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats'))
end


