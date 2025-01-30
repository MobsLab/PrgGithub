% ClinicTransitionSleepStage
% 30.03.2017 KJ
%
% Quantify the number of transitions
% 
% 
%   see ClinicTransitionSleepStagePlot
%

clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('all');

%params
transition_window = 1E4; %1sec
sleepstage_ind = 1:5; %N1, N2, N3, REM, WAKE
NameStages = {'N1', 'N2', 'N3', 'REM', 'WAKE'};

%% loop over nights
for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    transition_res.filename{p} = Dir.filename{p};
    transition_res.condition{p} = Dir.condition{p};
    transition_res.subject{p} = Dir.subject{p};
    transition_res.date{p} = Dir.date{p};
    transition_res.night{p} = Dir.night{p};
    
    
    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});

    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Transition
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nb_transitions = nan(length(StageEpochs));
    nb_episode = nan(1,length(StageEpochs));
    for sst1=1:length(StageEpochs)
        nb_episode(sst1) = length(Start(StageEpochs{sst1}));
        for sst2=1:length(StageEpochs)
            if sst1~=sst2
                end_stage_pre = End(StageEpochs{sst1});
                start_stage_post = Start(StageEpochs{sst2});
                
                intv_start_sst1 = [start_stage_post-transition_window start_stage_post];
                [status, interval,~] = InIntervals(end_stage_pre, intv_start_sst1);
                interval(interval==0)=[];
                interval=unique(interval);
                
                start_sst2_from_sst1 = start_stage_post(interval);
                %number of transition
                nb_transitions(sst1,sst2) = length(start_sst2_from_sst1);
            end
        end
    end
    transition_res.nb_episode{p} = nb_episode;
    transition_res.nb_transitions{p} = nb_transitions;

end

%saving data
cd(FolderPrecomputeDreem)
save ClinicTransitionSleepStage.mat transition_res sleepstage_ind NameStages






