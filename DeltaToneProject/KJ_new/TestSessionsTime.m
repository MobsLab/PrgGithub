% TestSessionsTime
% 10.02.2017 KJ
%
% for each night, look at the time of each sessions
%
% see
%   


%% Dir
Dir = PathForExperimentsDeltaWavesTone('all');
%Dir = PathForExperimentsDeltaKJHD('all');
Dir_long = PathForExperimentsDeltaLongSleep('all');

Dir = IntersectPathForExperiment(Dir,Dir_long);
clearvars -except Dir

%condition 
Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end




%% loop
for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    session_res.path{p}=Dir.path{p};
    session_res.manipe{p}=Dir.manipe{p};
    session_res.delay{p}=Dir.delay{p};
    session_res.name{p}=Dir.name{p};
    session_res.condition{p}=Dir.condition{p};
    
    %% load
    clear DeltaOffline SWSEpoch start_time sessions
    
    %Session
    clear sessions
    load IntervalSession
    sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
    start_time = (TimeDebRec(1,1)*3600 + TimeDebRec(1,2)*60 + TimeDebRec(1,3))*1E4; %start time in sec

    session_res.sessions{p} = nan(5,2);
    for s=1:length(sessions)
       session_res.sessions{p}(s,1) = Start(sessions{s}) + start_time;
       session_res.sessions{p}(s,2) = End(sessions{s}) + start_time;
    end
    
    
end


%saving data
cd([FolderProjetDelta 'Data/'])
save TestSessionsTime.mat session_res


