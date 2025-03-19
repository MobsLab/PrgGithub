% CorrelogramDeltaToneTransitionSub
% 13.12.2016 KJ
%
% Collect data to plot the correlograms about tones vs substage transitions
% - the origin is the tone/sham event
% 
% 
%   see TransitionToSWSDeltaTone
%


Dir1 = PathForExperimentsDeltaWavesTone('Basal');
for p=1:length(Dir1.path)
    Dir1.delay{p}=0;
end
Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
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
binsize_cc = 100; %10ms
nbins_cc = 500;
substage_ind = 1:6;

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    correlo_res.path{p}=Dir.path{p};
    correlo_res.manipe{p}=Dir.manipe{p};
    correlo_res.delay{p}=Dir.delay{p};
    correlo_res.name{p}=Dir.name{p};

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
    
    %Events that were followed by a delta
    effect_period = 3000; %300ms
    tone_intv_post = intervalSet(Range(tEvents), Range(tEvents) + effect_period);  % Tone and its window where an effect could be observed

    induce_delta = zeros(nb_events, 1);
    [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv_post) End(tone_intv_post)]);
    interval(interval==0)=[];
    event_success = unique(interval);
    induce_delta(event_success) = 1;
    tEvents_success = ts(event_tmp(induce_delta==1));
    tEvents_failed = ts(event_tmp(induce_delta==0));

    
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
                
                %correlogram tone - transition
                Cc_tone_transit{sub1,sub2} = CrossCorr(tEvents, ts(start_sub2_from_sub1), binsize_cc, nbins_cc);
                %correlogram tone success - transition
                Cc_tone_success_transit{sub1,sub2} = CrossCorr(tEvents_success, ts(start_sub2_from_sub1), binsize_cc, nbins_cc);
                %correlogram tone success - transition
                Cc_tone_failed_transit{sub1,sub2} = CrossCorr(tEvents_failed, ts(start_sub2_from_sub1), binsize_cc, nbins_cc);
                %number of transition
                nb_transitions{sub1,sub2} = length(start_sub2_from_sub1);
           end
       end
    end
    
    correlo_res.correlograms{p} = Cc_tone_transit;
    correlo_res.correlo_success{p} = Cc_tone_success_transit;
    correlo_res.correlo_failed{p} = Cc_tone_failed_transit;
    correlo_res.nb_epoch{p} = nb_epoch;
    correlo_res.nb_events{p} = nb_events;
    correlo_res.nb_transitions{p} = nb_transitions;
    
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save CorrelogramDeltaToneTransitionSub.mat correlo_res substage_ind binsize_cc nbins_cc transition_window
        










