SessNames = {'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'...
    'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
% SessNames = {    'HabituationBlockedShock_EyeShock','HabituationBlockedSafe_EyeShock',...
%     'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};

SessNames = {'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'...
    'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

for ss = 2:length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    
    for d=1:length(Dir.path)-1
        for dd=1:length(Dir.path{d})
            
            cd(Dir.path{d}{dd})
            clear Params Behav NoDoorEpoch
            load('behavResources_SB.mat','Params','Behav')
            if not(isfield(Behav,'EscapeLat')) & not(Dir.ExpeInfo{d}{dd}.nmouse==875)
                disp(Dir.path{d}{dd})
                
                NoDoorEpoch = intervalSet(Params.DoorRemoved*1e4,max(Range(Behav.Vtsd)));
                
                % Blocked shock or safe
                if (isempty(strfind(SessNames{ss},'Shock')))
                    % safe zone blocked
                    RegionsToExplore = [5,3,1]; % opp corner - middle - opp side
                else
                    % shock zone blocked
                    RegionsToExplore = [4,3,2]; % opp corner - middle - opp side
                end
                
                for k = 1:3
                    Val = min(Start(and(Behav.ZoneEpoch{RegionsToExplore(k)},NoDoorEpoch),'s'));
                    if not(isempty(Val))
                        EscapeLat.ZoneEpoch(k) = Val-Params.DoorRemoved;
                    else
                        EscapeLat.ZoneEpoch(k) = 200;
                    end
                end
                try
                    for k = 1:3
                        Val = min(Start(and(Behav.ZoneEpochAligned{RegionsToExplore(k)},NoDoorEpoch),'s'));
                        if not(isempty(Val))
                            EscapeLat.ZoneEpochAligned(k) = Val-Params.DoorRemoved;
                        else
                            EscapeLat.ZoneEpochAligned(k) = 200;
                        end
                    end
                end
                Behav.EscapeLat  = EscapeLat;
                
                %
                %             clf
                %             plot(Range(Behav.LinearDist,'s'),Data(Behav.LinearDist)), hold on
                %             line([Params.DoorRemoved Params.DoorRemoved],ylim,'linewidth',3,'color','k')
                %             plot(EscapeLat.ZoneEpoch(1)+Params.DoorRemoved,0.5,'*r')
                %             plot(EscapeLat.ZoneEpochAligned(1)+Params.DoorRemoved,0.55,'*m')
                %             plot(EscapeLat.ZoneEpoch(2)+Params.DoorRemoved,0.5,'*b')
                %             plot(EscapeLat.ZoneEpochAligned(2)+Params.DoorRemoved,0.55,'*c')
                %             pause
                %             clf
                save('behavResources_SB.mat','Behav','-append')
                clear EscapeLat
                
            end
            
        end
    end
end



%% BM way
for mouse=20:29
    n=1; clear Check_Figure
    for sess=1:length(CondSess.(Mouse_names{mouse}))
        
        cd(CondSess.(Mouse_names{mouse}){sess})
        
        clear Params Behav Sta
        load('behavResources_SB.mat','Params','Behav')
%         Params.DoorRemoved = 300;
        
        if ~(isempty(strfind(CondSess.(Mouse_names{mouse}){sess},'CondB')))
            
            Sta = Start(Behav.ZoneEpoch{3});
            if isempty(Sta); Sta = 480e4; end % if didn't go in safe zone, put 480s
            
            if ~or(sum(Stop(Behav.ZoneEpoch{1})-Start(Behav.ZoneEpoch{1}))/1e4 > 295 , sum(Stop(Behav.ZoneEpoch{2})-Start(Behav.ZoneEpoch{2}))/1e4 > 295)  % if spent less than 295s in shock zone or enter safe zone before 300s
                keyboard
            else
                if Behav.Latency_BM<0
                    Behav.Latency_BM=0;
                else
                    try
                        time=min(find(Sta>295e4));  %
                        if ~isempty(time)
                            Behav.Latency_BM = Sta(time)/1e4-Params.DoorRemoved;
                        else
                            Behav.Latency_BM =180;
                        end
                    catch
                        %                                         Params.DoorRemoved = 300;
                        %                                         Behav.Latency_BM = Sta(1)/1e4-Params.DoorRemoved;
                        keyboard
                    end
                end
            end
            
            save('behavResources_SB.mat','Behav','-append')
            
            Check_Figure(n) = Behav.Latency_BM;
            n=n+1;
        end
    end
    bar(Check_Figure)
    disp(['Check Figure ' Mouse_names{mouse}])
    keyboard
end


