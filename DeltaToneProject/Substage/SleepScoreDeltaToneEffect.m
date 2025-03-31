% SleepScoreDeltaToneEffect
% 04.10.2017 KJ
%
% - Measure the difference between sleep score
%
%
% See 
%   FindSleepStageML CreateModifiedSleepScore QuantitySleepDelta
%
%

clear

Dir=PathForExperimentsDeltaLongSleepNew('all');

%condition 
Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end

%params
NameSubstages={'N1','N2','N3','REM','Wake','NREM'};
colori = {'k',[0.75 0.75 0.75],'m'};
substages_ind = 1:6; %N1, N2, N3, REM, WAKE,NREM


%% Delay for sham
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    scoring_res.path{p}=Dir.path{p};
    scoring_res.manipe{p}=Dir.manipe{p};
    scoring_res.delay{p}=Dir.delay{p};
    scoring_res.name{p}=Dir.name{p};
    scoring_res.condition{p}=Dir.condition{p};
    
    
    %% Session
    clear sessions
    load IntervalSession
    sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
    start_time = (TimeDebRec(1,1)*3600 + TimeDebRec(1,2)*60 + TimeDebRec(1,3))*1E4; %start time in sec
    for s=1:length(sessions)
        sessions{s} = intervalSet(Start(sessions{s}) + start_time, End(sessions{s}) + start_time);
    end
    
    %% load real sleep score
    clear op noise
    load NREMepochsML.mat op noise
    disp('Loading epochs from NREMepochsML')
    [Substages,~]=DefineSubStages(op,noise);
    Substages = Substages(substages_ind);
    for sub=substages_ind
        Substages{sub} = intervalSet(Start(Substages{sub}) + start_time, End(Substages{sub}) + start_time);
    end
    SWSEpoch=Substages{6};
    
    %% load sleep score without delta waves after tones/sham
    clear op noise
    load NREMepochs_remove_delta.mat op noise
    disp('Loading epochs from NREMepochs_remove_delta')
    [Substages_remove,~]=DefineSubStages(op,noise);
    Substages_remove = Substages_remove(substages_ind);
    for sub=substages_ind
        Substages_remove{sub} = intervalSet(Start(Substages_remove{sub}) + start_time, End(Substages_remove{sub}) + start_time);
    end
    
    %% load sleep score with delta waves after every tones/sham
    clear op noise
    load NREMepochs_add_delta.mat op noise
    disp('Loading epochs from NREMepochs_add_delta')
    [Substages_add,~]=DefineSubStages(op,noise);
    Substages_add = Substages_add(substages_ind);
    for sub=substages_ind
        Substages_add{sub} = intervalSet(Start(Substages_add{sub}) + start_time, End(Substages_add{sub}) + start_time);
    end
    
    clear op noise

    
    %% Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline = DeltaEpoch;
        clear DeltaEpoch
    end
    DeltaOffline = intervalSet(Start(DeltaOffline) + start_time, End(DeltaOffline) + start_time);
    start_deltas = Restrict(ts(Start(DeltaOffline)),SWSEpoch);
    
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% QUANTIF
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% sessions
    scoring_res.substages.true{p} = nan(length(sessions),length(substages_ind));
    scoring_res.substages.add{p} = nan(length(sessions),length(substages_ind));
    scoring_res.substages.remove{p} = nan(length(sessions),length(substages_ind));
    
    scoring_res.session_time{p} = nan(length(sessions),2);
    scoring_res.session_time{p} = nan(length(sessions),2);
    for s=1:length(sessions)
        scoring_res.session_time{p}(s,1) = Start(sessions{s});
        scoring_res.session_time{p}(s,2) = End(sessions{s});
        %substages
        for sub=substages_ind
            scoring_res.substages.true{p}(s,sub) = tot_length(and(sessions{s},Substages{sub}));
            scoring_res.substages.add{p}(s,sub) = tot_length(and(sessions{s},Substages_add{sub}));
            scoring_res.substages.remove{p}(s,sub) = tot_length(and(sessions{s},Substages_remove{sub}));
        end
        %delta
        scoring_res.deltas.session{p,s} = length(Restrict(start_deltas,sessions{s}));
    end
    

    
end


%saving data
cd([FolderProjetDelta 'Data/'])
save SleepScoreDeltaToneEffect.mat scoring_res substages_ind







