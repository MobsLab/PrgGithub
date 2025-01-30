% TonesAtTransitionSubstage
% 13.12.2016 KJ
%
% Collect data to study the tones at the transitions of substage
% 
% 
%   see TransitionToSWSDeltaTone
%



%% Dir
Dir = PathForExperimentsDeltaWavesTone('all');
%Dir = PathForExperimentsDeltaKJHD('all');
clearvars -except Dir


%params
transition_window = 1E4; %1sec, if this window is short, there is no other substage between n2 and n3
nb_tone_before_transit = 3;
substage_ind = 1:6;


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    tonetransit_res.path{p}=Dir.path{p};
    tonetransit_res.manipe{p}=Dir.manipe{p};
    tonetransit_res.delay{p}=Dir.delay{p};
    tonetransit_res.name{p}=Dir.name{p};

    %% load
    %Epoch
    load StateEpochSB SWSEpoch Wake REMEpoch
    %Substages and stages
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);

    clear Down DeltaOffline tEvents  
    %Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline =  DeltaEpoch; 
        clear DeltaEpoch
    end
    start_deltas = Start(DeltaOffline);

    %Tones/Shams
    try
        load('DeltaSleepEvent.mat', 'TONEtime1')
        delay = Dir.delay{p}*1E4;
        tEvents = ts(TONEtime1 + delay);
    catch
        load('ShamSleepEvent.mat', 'SHAMtime')
        tEvents = SHAMtime;
    end
    event_tmp = Range(tEvents);
    nb_events = length(tEvents);
    
    %Events that were followed by a delta (success and failed tones)
    effect_period = 3000; %300ms - delay to consider that a tone induce a delta
    tone_intv_post = intervalSet(Range(tEvents), Range(tEvents) + effect_period);  % Tone and its window where an effect could be observed

    induce_delta = zeros(nb_events, 1);
    [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv_post) End(tone_intv_post)]);
    interval(interval==0)=[];
    event_success = unique(interval);
    induce_delta(event_success) = 1;
    
    success_tmp = event_tmp(induce_delta==1); %tones that induced a delta
    failed_tmp = event_tmp(induce_delta==0); %tones that did not induce a delta
    tEvents_success = ts(success_tmp);
    tEvents_failed = ts(failed_tmp);
    
    %% Find transitions
    clear nb_transitions Cc_tone_transit nb_epoch
    for sub=substage_ind
       nb_epoch{sub} = length(Start(Substages{sub}));
    end
    
    for sub1=substage_ind
       for sub2=substage_ind
           if sub1~=sub2
                end_stage_pre = End(Substages{sub1});
                start_stage_post = Start(Substages{sub2});
                
                intv_start_sub1 = [start_stage_post-transition_window start_stage_post];
                [status, interval,~] = InIntervals(end_stage_pre, intv_start_sub1);
                interval(interval==0)=[];
                interval=unique(interval);
                
                end_sub1_to_sub2 = end_stage_pre(status);
                start_sub2_from_sub1 = start_stage_post(interval);
                
                delay_success_transit = nan(length(start_sub2_from_sub1),nb_tone_before_transit);
                delay_failed_transit = nan(length(start_sub2_from_sub1),nb_tone_before_transit);
                for st=1:length(start_sub2_from_sub1)
                    idx_success_before = find(success_tmp <= start_sub2_from_sub1(st), nb_tone_before_transit, 'last');
                    idx_failed_before = find(failed_tmp <= start_sub2_from_sub1(st), nb_tone_before_transit, 'last');
                    
                    for i=1:nb_tone_before_transit
                        try
                            delay_success_transit(st,i) = start_sub2_from_sub1(st) - success_tmp(idx_success_before(end+1-i));
                        end
                        try
                            delay_failed_transit(st,i) = start_sub2_from_sub1(st) - success_tmp(idx_failed_before(end+1-i));
                        end
                    end
                end
                
                %number of transition
                nb_transitions{sub1,sub2} = length(start_sub2_from_sub1);
                %delay between preceding tones and transition
                delay_success{sub1,sub2} = delay_success_transit;
                delay_failed{sub1,sub2} = delay_failed_transit;
           end
       end
    end
    
    tonetransit_res.delay_success{p} = delay_success;
    tonetransit_res.delay_failed{p} = delay_failed;
    tonetransit_res.nb_epoch{p} = nb_epoch;
    tonetransit_res.nb_events{p} = nb_events;
    tonetransit_res.nb_transitions{p} = nb_transitions;
    
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save TonesAtTransitionSubstage.mat tonetransit_res substage_ind transition_window nb_tone_before_transit
        




