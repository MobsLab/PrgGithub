% TonesAtTransitionSWSSubstageDuration
% 13.12.2016 KJ
%
% Collect data to study the tones that induced a substage and the duration
% 
% 
%   see TransitionToSWSDeltaTone TonesAtTransitionSWSSubstageDuration_bis1 TonesAtTransitionSWSSubstageDurationPlot
%


Dir1 = PathForExperimentsDeltaLongSleepNew('Basal');
for p=1:length(Dir1.path)
    Dir1.delay{p}=0;
end
Dir2=PathForExperimentsDeltaLongSleepNew('RdmTone');
Dir3=PathForExperimentsDeltaLongSleepNew('DeltaToneAll');
Dir = MergePathForExperiment(Dir2,Dir3);
Dir = MergePathForExperiment(Dir1,Dir);
% 
% Dir1 = PathForExperimentsDeltaKJHD('Basal');
% for p=1:length(Dir1.path)
%     Dir1.delay{p}=0;
% end
% Dir2 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir3 =PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir2,Dir3);
% Dir = MergePathForExperiment(Dir1,Dir);


clear Dir1 Dir2 Dir3

%params
transition_window = 1E4; %1sec, if this window is short, there is no other substage between n2 and n3
tone_transit_period = [5E3 1E4]; %500ms before & 1sec after
substage_ind = 1:6;


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    tonesattransit_res.path{p}=Dir.path{p};
    tonesattransit_res.manipe{p}=Dir.manipe{p};
    tonesattransit_res.delay{p}=Dir.delay{p};
    tonesattransit_res.name{p}=Dir.name{p};

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
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Find transitions
    clear nb_transitions Cc_tone_transit nb_epoch
    %number of substage
    for sub=substage_ind
       tonesattransit_res.nb_epoch{p,sub} = length(Start(Substages{sub}));
    end
    
    for sub1=substage_ind
       for sub2=substage_ind
           if sub1~=sub2
                %% substages and their transitions
                start_stage_pre = Start(Substages{sub1});
                end_stage_pre = End(Substages{sub1});
                start_stage_post = Start(Substages{sub2});
                end_stage_post = End(Substages{sub2});
                
                intv_start_sub1 = [start_stage_post-transition_window start_stage_post];
                [status, interval,~] = InIntervals(end_stage_pre, intv_start_sub1);
                interval(interval==0)=[];
                interval=unique(interval);
                
                %selected substages, that transit
                Sub1Pre = intervalSet(start_stage_pre(status), end_stage_pre(status));
                Sub2Post = intervalSet(start_stage_post(interval), end_stage_post(interval));
                start_sub1pre = Start(Sub1Pre); end_sub1pre = End(Sub1Pre);
                start_sub2post = Start(Sub2Post); end_sub2post = End(Sub2Post);
                
                
                %% POST SUBSTAGE
                intv_transit = [Start(Sub2Post)-tone_transit_period(1) Start(Sub2Post)+tone_transit_period(2)];
                
                % post-substages with or without a tone at the transition
                [status, interval,~] = InIntervals(event_tmp, intv_transit);
                interval(interval==0)=[];
                interval_tone = unique(interval);
                interval_notone = ~ismember(1:length(Start(Sub2Post)),interval_tone);
                
                event_to_sub2 = event_tmp(status);
                Sub2_from_event = intervalSet(start_sub2post(interval_tone),end_sub2post(interval_tone));
                Sub2_noevent = intervalSet(start_sub2post(interval_notone),end_sub2post(interval_notone));
                
                % post-substages with or without a success tone at the transition
                [status, interval,~] = InIntervals(success_tmp, intv_transit);
                interval(interval==0)=[];
                interval_tone = unique(interval);
                interval_notone = ~ismember(1:length(Start(Sub2Post)),interval_tone);
                
                success_to_sub2 = success_tmp(status);
                Sub2_from_success = intervalSet(start_sub2post(interval_tone),end_sub2post(interval_tone));
                Sub2_nosuccess = intervalSet(start_sub2post(interval_notone),end_sub2post(interval_notone));
                
                % post-substages with or without a failed tone at the transition
                [status, interval,~] = InIntervals(failed_tmp, intv_transit);
                interval(interval==0)=[];
                interval_tone = unique(interval);
                interval_notone = ~ismember(1:length(Start(Sub2Post)),interval_tone);
                
                failed_to_sub2 = failed_tmp(status);
                Sub2_from_failed = intervalSet(start_sub2post(interval_tone),end_sub2post(interval_tone));
                Sub2_nofailed = intervalSet(start_sub2post(interval_notone),end_sub2post(interval_notone));
                
                %% PRE SUBSTAGE
                intv_transit = [End(Sub1Pre)-tone_transit_period(1) End(Sub1Pre)+tone_transit_period(2)];
                
                % pre-substages with or without a tone at the transition
                [status, interval,~] = InIntervals(event_tmp, intv_transit);
                interval(interval==0)=[];
                interval_tone = unique(interval);
                interval_notone = ~ismember(1:length(Start(Sub1Pre)),interval_tone);
                
                event_from_sub1 = event_tmp(status);
                Sub1_then_event = intervalSet(start_sub1pre(interval_tone),end_sub1pre(interval_tone));
                Sub1_noevent = intervalSet(start_sub1pre(interval_notone),end_sub1pre(interval_notone));
                
                % post-substages with or without a success tone at the transition
                [status, interval,~] = InIntervals(success_tmp, intv_transit);
                interval(interval==0)=[];
                interval_tone = unique(interval);
                interval_notone = ~ismember(1:length(Start(Sub1Pre)),interval_tone);
                
                success_from_sub1 = success_tmp(status);
                Sub1_then_success = intervalSet(start_sub1pre(interval_tone),end_sub1pre(interval_tone));
                Sub1_nosuccess = intervalSet(start_sub1pre(interval_notone),end_sub1pre(interval_notone));
                
                % post-substages with or without a failed tone at the transition
                [status, interval,~] = InIntervals(failed_tmp, intv_transit);
                interval(interval==0)=[];
                interval_tone = unique(interval);
                interval_notone = ~ismember(1:length(Start(Sub1Pre)),interval_tone);
                
                failed_from_sub1 = failed_tmp(status);
                Sub1_then_failed = intervalSet(start_sub1pre(interval_tone),end_sub1pre(interval_tone));
                Sub1_nofailed = intervalSet(start_sub1pre(interval_notone),end_sub1pre(interval_notone));
              
                
                %% SAVE
                tonesattransit_res.sub2.event.with{sub1,sub2,p} = Sub2_from_event;
                tonesattransit_res.sub2.event.without{sub1,sub2,p} = Sub2_noevent;
                tonesattransit_res.sub2.success.with{sub1,sub2,p} = Sub2_from_success;
                tonesattransit_res.sub2.success.without{sub1,sub2,p} = Sub2_nosuccess;
                tonesattransit_res.sub2.failed.with{sub1,sub2,p} = Sub2_from_failed;
                tonesattransit_res.sub2.failed.without{sub1,sub2,p} = Sub2_nofailed;
                
                tonesattransit_res.sub1.event.with{sub1,sub2,p} = Sub1_then_event;
                tonesattransit_res.sub1.event.without{sub1,sub2,p} = Sub1_noevent;
                tonesattransit_res.sub1.success.with{sub1,sub2,p} = Sub1_then_success;
                tonesattransit_res.sub1.success.without{sub1,sub2,p} = Sub1_nosuccess;
                tonesattransit_res.sub1.failed.with{sub1,sub2,p} = Sub1_then_failed;
                tonesattransit_res.sub1.failed.without{sub1,sub2,p} = Sub1_nofailed;
                
                tonesattransit_res.tones.sub2.all{sub1,sub2,p} = event_from_sub1;
                tonesattransit_res.tones.sub2.success{sub1,sub2,p} = success_from_sub1;
                tonesattransit_res.tones.sub2.failed{sub1,sub2,p} = failed_from_sub1;
                
                tonesattransit_res.tones.sub1.all{sub1,sub2,p} = event_to_sub2;
                tonesattransit_res.tones.sub1.success{sub1,sub2,p} = success_to_sub2;
                tonesattransit_res.tones.sub1.failed{sub1,sub2,p} = failed_to_sub2;
                
                
                %number of transition
                tonesattransit_res.nb_transitions{sub1,sub2,p} = length(Start(Sub1Pre));
                
           end
       end
    end
    

    %number of tones
    tonesattransit_res.nb_events{p} = nb_events;
    tonesattransit_res.nb_success{p} = length(success_tmp);
    tonesattransit_res.nb_failed{p} = length(failed_tmp);
    
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save TonesAtTransitionSWSSubstageDuration.mat tonesattransit_res substage_ind transition_window tone_transit_period 
        




