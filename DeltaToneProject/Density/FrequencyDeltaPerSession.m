% FrequencyDeltaPerSession
% 30.11.2016 KJ
%
% collect data for the evaluation of the frequency of delta/tones per
% session
%
% Here, the data are collected
%
%   see FrequencyDeltaPerSession2
%
%


Dir1 = PathForExperimentsDeltaWavesTone('Basal');
for p=1:length(Dir1.path)
    Dir1.delay{p}=0;
end
Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir2,Dir3);
Dir = MergePathForExperiment(Dir1,Dir);

% Dir1 = PathForExperimentsDeltaKJHD('Basal');
% for p=1:length(Dir1.path)
%     Dir1.delay{p}=0;
% end
% Dir2 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir3 =PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir2,Dir3);
% Dir = MergePathForExperiment(Dir1,Dir);


for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'Basal')
        Dir.condition{p} = 'Basal';
    elseif strcmpi(Dir.manipe{p},'RdmTone')
        Dir.condition{p} = 'RdmTone';
    elseif strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end  

conditions = unique(Dir.condition); %Mice
%% params
substages_ind = 1:6; %N1, N2, N3, REM, WAKE


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    frequency_res.path{p}=Dir.path{p};
    frequency_res.manipe{p}=Dir.manipe{p};
    frequency_res.delay{p}=Dir.delay{p};
    frequency_res.name{p}=Dir.name{p};
    frequency_res.condition{p}=Dir.condition{p};

    %% load
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
    %Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline = DeltaEpoch;
        clear DeltaEpoch
    end
    start_deltas = Start(DeltaOffline);
    %Session
    load IntervalSession
    sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
    
    
    %% frequency
    for s=1:length(sessions)
        durations(p,s) = tot_length(sessions{s}) / 1E4;
        
        deltas.nb(p,s) = length(Restrict(ts(start_deltas), sessions{s}));
        deltas.frequency(p,s) = deltas.nb(p,s) / durations(p,s);
        downs.nb(p,s) = length(Restrict(ts(start_down), sessions{s}));
        downs.frequency(p,s) = downs.nb(p,s) / durations(p,s);
    end
    
end

frequency_res.deltas = deltas;
frequency_res.downs = downs;
frequency_res.durations = durations;

%saving data
cd([FolderProjetDelta 'Data/']) 
save FrequencyDeltaPerSession.mat frequency_res conditions sessions

 


