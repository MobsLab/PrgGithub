% QuantifNumberDelta
% 01.02.2017 KJ
%
% number of delta waves for each record
% 
% 
%   see FrequencyEventsDeltaShamEffect frequency_delta_test QuantifNumberDeltaPlot QuantifNumberDeltaPlotSpread 
%

%% Dir
%Dir = PathForExperimentsDeltaKJHD('all');
Dir = PathForExperimentsDeltaLongSleep('all');

clearvars -except Dir

%condition 
Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end


%params
substages_ind = 1:6;

hours_expe = 9:1:20;
for h=1:length(hours_expe)
    hours_epoch{h} = intervalSet(hours_expe(h)*3600E4, (hours_expe(h)+1)*3600E4-1);
end
midday_epoch = intervalSet(12*3600E4, 14*3600E4);
evening_epoch = intervalSet(17*3600E4, 19*3600E4);



%% loop
for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    deltanumber_res.path{p}=Dir.path{p};
    deltanumber_res.manipe{p}=Dir.manipe{p};
    deltanumber_res.delay{p}=Dir.delay{p};
    deltanumber_res.name{p}=Dir.name{p};
    deltanumber_res.condition{p}=Dir.condition{p};
    
    %% load
    clear DeltaOffline SWSEpoch start_time sessions
    
    %Session
    clear sessions
    load IntervalSession
    sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
    start_time = (TimeDebRec(1,1)*3600 + TimeDebRec(1,2)*60 + TimeDebRec(1,3))*1E4; %start time in sec
    for s=1:length(sessions)
        sessions{s} = intervalSet(Start(sessions{s}) + start_time, End(sessions{s}) + start_time);
    end
    
    %Epoch
    load StateEpochSB SWSEpoch
    SWSEpoch = intervalSet(Start(SWSEpoch) + start_time, End(SWSEpoch) + start_time);
    
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    Substages = Substages(substages_ind);
    for sub=substages_ind
        intervalSet(Start(Substages{sub}) + start_time, End(Substages{sub}) + start_time);
    end
    
    %Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline = DeltaEpoch;
        clear DeltaEpoch
    end
    DeltaOffline = intervalSet(Start(DeltaOffline) + start_time, End(DeltaOffline) + start_time);
    start_deltas = Restrict(ts(Start(DeltaOffline)),SWSEpoch);
    
    
    %% QUANTIF
    
    %Epoch duration
    deltanumber_res.substage_duration{p}=nan(length(sessions),length(substages_ind));
    for sub=substages_ind
        for s=1:length(sessions)
            deltanumber_res.substage_duration{p}(s,sub) = tot_length(and(sessions{s},Substages{sub}));
        end
    end
    
    %total
    deltanumber_res.total{p} = length(start_deltas);
    
    %session
    deltanumber_res.session_time{p} = nan(length(sessions),2);
    for s=1:length(sessions)
        deltanumber_res.session{p,s} = length(Restrict(start_deltas,sessions{s}));
        deltanumber_res.session_time{p}(s,1) = Start(sessions{s});
        deltanumber_res.session_time{p}(s,2) = End(sessions{s});
    end
        
    %hours
    for h=1:length(hours_epoch)
        deltanumber_res.hours{p,h} = length(Restrict(start_deltas,hours_epoch{h}));
    end
    
    %midday and evening
    deltanumber_res.midday{p} = length(Restrict(start_deltas,midday_epoch));
    deltanumber_res.evening{p} = length(Restrict(start_deltas,evening_epoch));
    
end


%saving data
cd([FolderProjetDelta 'Data/'])
save NumberDeltaPerRecord.mat deltanumber_res


