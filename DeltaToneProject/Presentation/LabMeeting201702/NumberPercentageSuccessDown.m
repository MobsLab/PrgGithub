% NumberPercentageSuccessDown
% 16.02.2017 KJ
%
% quantify the number of tones evoking down states
%
% see 
%   Figure6GeneratedDelta_bis  NumberPercentageSuccessDelta
%  
%

%% Dir
Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaToneAll');
Dir = MergePathForExperiment(Dir1,Dir2);

% Dir1 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir2 = PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir1,Dir2);

clearvars -except Dir

%condition 
Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end


%params
effect_period = 3000; %300ms
substages_ind = 1:6;


%% RECORD WITH TONE
for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        successdown_res.path{p}=Dir.path{p};
        successdown_res.manipe{p}=Dir.manipe{p};
        successdown_res.delay{p}=Dir.delay{p};
        successdown_res.name{p}=Dir.name{p};
        successdown_res.path{p}=Dir.path{p};

        %Epoch
        load StateEpochSB SWSEpoch Wake REMEpoch
        %Substages
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        if ~isempty(op)
            disp('Loading epochs from NREMepochsML.m')
        else
            clear op NamesOp Dpfc Epoch noise
            load NREMepochsML_old.mat op NamesOp Dpfc Epoch noise
            disp('Loading epochs from NREMepochsML.m')
        end
        [Substages,NamesSubstages]=DefineSubStages(op,noise);
        NREM = Substages{6};
        %Session
        load IntervalSession
        sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
        
        
        %Down states
        try
            load newDownState Down
        catch
            try
                load DownSpk Down
            catch
                Down = intervalSet([],[]);
            end
        end
        start_down = Start(Down);
        start_down = Range(Restrict(ts(start_down),NREM));
        nb_down = length(start_down);
        
        %tones
        load('DeltaSleepEvent.mat', 'TONEtime2_SWS')
        load('DeltaSleepEvent.mat', 'TONEtime1_SWS')
        delay = Dir.delay{p}*1E4;
        if exist('TONEtime2_SWS','var')
            tones_tmp = TONEtime2_SWS + delay;
        else
            tones_tmp = TONEtime1_SWS + delay;
        end
        ToneEvent = ts(tones_tmp);
        nb_tones = length(tones_tmp);
        tone_intv_post = intervalSet(tones_tmp, tones_tmp + effect_period);  % Tone and its window where an effect could be observed
        
        
         %% SUBSTAGE
        substage_tone = nan(1,length(tones_tmp));
        for sub=substages_ind
            substage_tone(ismember(tones_tmp, Range(Restrict(ToneEvent, Substages{sub})))) = sub;
        end
        
        %% INDUCED Down ?
        if ~isempty(start_down)
            induce_down = zeros(nb_tones, 1);
            [status,interval,~] = InIntervals(start_down, [Start(tone_intv_post) End(tone_intv_post)]);
            down_tone_success = unique(interval);
            induce_down(down_tone_success(2:end)) = 1;  %do not consider the first nul element
            down_induced = status;
        else
            induce_down = [];
            down_induced = [];
        end
        
        %% SUCCESS RATE in S2 & S4
        for s=1:2
            tone_intv_session = intervalSet(Range(Restrict(ToneEvent,sessions{s*2})), Range(Restrict(ToneEvent,sessions{s*2})) + effect_period);
            nb_tones_session(s) = length(Start(tone_intv_session));

            %down
            [~,interval,~] = InIntervals(start_down, [Start(tone_intv_session) End(tone_intv_session)]);
            nb_success_session_down(s) = length(unique(interval)) - 1; %exclude the 0
            nb_down_session(s) = length(Restrict(ts(start_down),sessions{s*2}));
        end
        
        
        %% SAVE AND RASTER
        successdown_res.nb_down{p} = nb_down;
        successdown_res.nb_down_session{p} = nb_down_session;
        successdown_res.induced{p} = induce_down;
        successdown_res.substage_tone{p} = substage_tone;
        successdown_res.nb_session{p} = nb_tones_session;
        successdown_res.nb_success{p} = nb_success_session_down;
        
        
    end
end

%saving data
cd([FolderProjetDelta 'Data/'])
save NumberPercentageSuccessDown.mat -v7.3 successdown_res effect_period substages_ind




