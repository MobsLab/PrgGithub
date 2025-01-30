% SuccessRateEffect
% 21.04.2017 KJ
%
% Success rate vs :
%   - substage duration
%   - deltas number 
%
%   here the data are collected
%
%   see ClinicNumberDelta1 SuccessRateEffectPlot
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


%% loop
for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    success_res.path{p}=Dir.path{p};
    success_res.manipe{p}=Dir.manipe{p};
    success_res.delay{p}=Dir.delay{p};
    success_res.name{p}=Dir.name{p};
    success_res.condition{p}=Dir.condition{p};
    
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
        Substages{sub} = intervalSet(Start(Substages{sub}) + start_time, End(Substages{sub}) + start_time);
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
    
    %Tones/Shams
    try
        load('DeltaSleepEvent.mat', 'TONEtime1')
        delay = Dir.delay{p}*1E4;
        tEvents = ts(TONEtime1 + delay);
    catch
        load('ShamSleepEvent.mat', 'SHAMtime')
        tEvents = SHAMtime;
    end
    tEvents = ts(Range(tEvents) + start_time);
    event_tmp = Range(tEvents);
    
    
    %Events that were followed by a delta (success and failed tones)
    effect_period = 3000; %300ms - delay to consider that a tone induce a delta
    tone_intv_post = intervalSet(Range(tEvents), Range(tEvents) + effect_period);  % Tone and its window where an effect could be observed

    induce_delta = zeros(length(tEvents), 1);
    [~,interval,~] = InIntervals(Range(start_deltas), [Start(tone_intv_post) End(tone_intv_post)]);
    interval(interval==0)=[];
    event_success = unique(interval);
    induce_delta(event_success) = 1;
    
    sucess_tmp = event_tmp(induce_delta==1);
    failed_tmp = event_tmp(induce_delta==0);
    tSuccess = ts(sucess_tmp);
    tFailed = ts(failed_tmp);
    
    
    %% QUANTIF
    
    %Epoch duration
    success_res.session.substage_duration{p}=nan(length(sessions),length(substages_ind));
    success_res.hours.substage_duration{p}=nan(length(hours_epoch),length(substages_ind));
    for sub=substages_ind
        for s=1:length(sessions)
            success_res.session.substage_duration{p}(s,sub) = tot_length(and(sessions{s},Substages{sub}));
        end
        for h=1:length(hours_epoch)
            success_res.hours.substage_duration{p}(h,sub) = tot_length(and(hours_epoch{h},Substages{sub}));
        end
    end
    
    %total
    success_res.total.deltas{p} = length(start_deltas);
    success_res.total.events{p} = length(tEvents);
    success_res.total.success{p} = length(tSuccess);
    success_res.total.failed{p} = length(tFailed);
    
    %session
    success_res.session_time{p} = nan(length(sessions),2);
    for s=1:length(sessions)
        success_res.session.time{p}(s,1) = Start(sessions{s});
        success_res.session.time{p}(s,2) = End(sessions{s});
        
        success_res.session.nb_delta{p}(s) = length(Restrict(start_deltas,sessions{s}));
        success_res.session.nb_event{p}(s) = length(Restrict(tEvents,sessions{s}));
        success_res.session.nb_success{p}(s) = length(Restrict(tSuccess,sessions{s}));
        success_res.session.nb_failed{p}(s) = length(Restrict(tFailed,sessions{s}));
        
        success_res.session.success_rate{p,s} = length(Restrict(tSuccess,sessions{s})) / length(Restrict(tEvents,sessions{s}));
    end
    
    %hours
    for h=1:length(hours_epoch)
        success_res.hours.nb_delta{p}(h) = length(Restrict(start_deltas,hours_epoch{h}));
        success_res.hours.nb_event{p}(h) = length(Restrict(tEvents,hours_epoch{h}));
        success_res.hours.nb_success{p}(h) = length(Restrict(tSuccess,hours_epoch{h}));
        success_res.hours.nb_failed{p}(h) = length(Restrict(tFailed,hours_epoch{h}));
        
        success_res.hours.success_rate{p,s} = length(Restrict(tSuccess,hours_epoch{h})) / length(Restrict(tEvents,hours_epoch{h}));
        
    end
    
    
end


%saving data
cd([FolderProjetDelta 'Data/'])
save SuccessRateEffect.mat success_res substages_ind hours_expe

