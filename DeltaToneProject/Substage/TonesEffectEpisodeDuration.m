% TonesEffectEpisodeDuration
% 12.04.2017 KJ
%
% Collect data to study the effect of tones on substage episode duration
% 
% 
%   see TonesAtTransitionSWSSubstageDuration TonesEffectEpisodeDuration_bis
%


%% Dir
%Dir = PathForExperimentsDeltaKJHD('all');
Dir = PathForExperimentsDeltaLongSleepNew('all');

clearvars -except Dir

%condition 
Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end


%params
time_border = 1E4; %1000ms
substage_ind = 1:6;


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    episodedur_res.path{p}=Dir.path{p};
    episodedur_res.manipe{p}=Dir.manipe{p};
    episodedur_res.delay{p}=Dir.delay{p};
    episodedur_res.name{p}=Dir.name{p};
    episodedur_res.condition{p}=Dir.condition{p};

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
    
    %Events that were followed by a delta (success and failed tones)
    effect_period = 3000; %300ms - delay to consider that a tone induce a delta
    tone_intv_post = intervalSet(Range(tEvents), Range(tEvents) + effect_period);  % Tone and its window where an effect could be observed

    induce_delta = zeros(length(tEvents), 1);
    [~,interval,~] = InIntervals(start_deltas, [Start(tone_intv_post) End(tone_intv_post)]);
    interval(interval==0)=[];
    event_success = unique(interval);
    induce_delta(event_success) = 1;
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Episode analysis
    clear nb_epoch
    
    for sub=substage_ind
        nb_epoch = length(Start(Substages{sub})); %number of substage
        episodedur_res.nb_epoch{p,sub} = nb_epoch; 
        
        start_sub = Start(Substages{sub});
        end_sub = End(Substages{sub});
        
        substage_duration = nan(nb_epoch,1);
        tone_delay = nan(nb_epoch,1);
        tone_sucess = nan(nb_epoch,1);
        
        for i=1:nb_epoch
            substage_duration(i) = end_sub(i) - start_sub(i);
            try
                idx_event = find(event_tmp > start_sub(i)-time_border, 1);
                tone_delay(i) = event_tmp(idx_event) - start_sub(i);
                tone_sucess(i) = induce_delta(idx_event);
            end
        end
        
        episodedur_res.tone_delay{p,sub} = tone_delay;
        episodedur_res.substage_duration{p,sub} = substage_duration;
        episodedur_res.tone_sucess{p,sub} = tone_sucess;
    end
    
    %number of tones
    episodedur_res.nb_events{p} = length(event_tmp);
    episodedur_res.nb_success{p} = sum(induce_delta==1);
    episodedur_res.nb_failed{p} = sum(induce_delta==0);
    
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save TonesEffectEpisodeDuration.mat episodedur_res substage_ind time_border 





