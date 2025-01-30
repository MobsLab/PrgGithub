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

for SOI = 2%:length(SessionType)
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
                    
                    % OB frequency
                    clear LocalFreq
                    load('InstFreqAndPhase_B.mat','LocalFreq')
                    % smooth the estimates
                    WVBinsize = length(Range(LocalFreq.WV))./length(Range(Behav.LinearDist));
                    LocalFreq.WV = tsd(Range(LocalFreq.WV),movmedian(Data(LocalFreq.WV),ceil(WVBinsize)*2));
                    LocalFreq.PT = tsd(Range(LocalFreq.PT),movmedian(Data(LocalFreq.PT),4));
                    
                    
                    for z = 1:5
                        PercTimeHighWV{z}(d,dd) = nanmean(Data(Restrict(LocalFreq.WV,and(Behav.ZoneEpoch{z},CleanFreezeEpoch)))>4 & Data(Restrict(LocalFreq.WV,and(Behav.ZoneEpoch{z},CleanFreezeEpoch)))<7);
                        PercTimeHighPT{z}(d,dd) = nanmean(Data(Restrict(LocalFreq.PT,and(Behav.ZoneEpoch{z},CleanFreezeEpoch)))>4 & Data(Restrict(LocalFreq.PT,and(Behav.ZoneEpoch{z},CleanFreezeEpoch)))<7);
                        PercTimeLowWV{z}(d,dd) = nanmean(Data(Restrict(LocalFreq.WV,and(Behav.ZoneEpoch{z},CleanFreezeEpoch)))<4);
                        PercTimeLowPT{z}(d,dd) = nanmean(Data(Restrict(LocalFreq.PT,and(Behav.ZoneEpoch{z},CleanFreezeEpoch)))<4);
                        PercTimeAllWV{z}(d,dd) = nanmean(Data(Restrict(LocalFreq.WV,and(Behav.ZoneEpoch{z},CleanFreezeEpoch)))<7);
                        PercTimeAllPT{z}(d,dd) = nanmean(Data(Restrict(LocalFreq.PT,and(Behav.ZoneEpoch{z},CleanFreezeEpoch)))<7);
                        
                    end
                    
                end
            end
        end
    end
end
PercTimeHighWV1 = PercTimeHighWV;
PercTime1 = PercTime;

for z = 1:5
    for mm = 1 : size(PercTimeHighWV{z},1)
        tpsWV = PercTimeHighWV{z}(mm,:);
        tpsWV(find(PercTimeAllWV{z}(mm,:)==0)) = [];
        
        tps = PercTimeAllWV{z}(mm,:);
        tps(find(PercTimeAllWV{z}(mm,:)==0)) = [];
        
        tps(isnan(tps))= [];
        tpsWV(isnan(tpsWV))= [];
        tps = tps/sum(tps);
        
        HighTimeWV(z,mm) = tpsWV*tps';
        
         tpsWV = PercTimeHighPT{z}(mm,:);
        tpsWV(find(PercTimeAllPT{z}(mm,:)==0)) = [];
        
        tps = PercTimeAllPT{z}(mm,:);
        tps(find(PercTimeAllPT{z}(mm,:)==0)) = [];
        
        tps(isnan(tps))= [];
        tpsWV(isnan(tpsWV))= [];
        tps = tps/sum(tps);
        
        HighTimePT(z,mm) = tpsWV*tps';
        
        tpsWV = PercTimeLowWV{z}(mm,:);
        tpsWV(find(PercTimeAllWV{z}(mm,:)==0)) = [];
        
        tps = PercTimeAllWV{z}(mm,:);
        tps(find(PercTimeAllWV{z}(mm,:)==0)) = [];
        
        tps(isnan(tps))= [];
        tpsWV(isnan(tpsWV))= [];
        tps = tps/sum(tps);
        
        HighTimeWV(z,mm) = tpsWV*tps';
        
    end
end

colormap hot
pie()






