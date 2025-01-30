% QuantifDetectionDeltaDown
% 28.11.2016 KJ
%
% collect data for the quantification of the detection of down and delta,
% and their comparison
%
%   see QuantifDetectionDeltaDown2
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


%% params
substages_ind = 1:5; %N1, N2, N3, REM, WAKE


%% Data for Basal
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    quantif_res.path{p}=Dir.path{p};
    quantif_res.manipe{p}=Dir.manipe{p};
    quantif_res.delay{p}=Dir.delay{p};
    quantif_res.name{p}=Dir.name{p};

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
    tdowns = (Start(Down)+End(Down))/2; 
    %Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline = DeltaEpoch;
        clear DeltaEpoch
    end
    tdeltas = (Start(DeltaOffline)+End(DeltaOffline))/2;
    %Substages
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    
    
    %% Numbers
    
    % intersection delta waves and down states
    intvDur = 1E3;
    larger_delta_epochs = [Start(DeltaOffline)-intvDur, End(DeltaOffline)+intvDur];
    if ~isempty(tdowns)
        [status,~,~] = InIntervals(tdowns,larger_delta_epochs);
    else
        status = [];
    end
    tDownDelta = ts(tdowns(status));
    tdowns = ts(tdowns);
    tdeltas = ts(tdeltas);
    
    %% Substages ISI
    for sub=substages_ind
        quantif_res.substage{p,sub} = NamesSubstages{sub};
    
        % numbers of events
        quantif_res.nb_down{p,sub} = length(Restrict(tdowns,Substages{sub}));
        quantif_res.nb_delta{p,sub} = length(Restrict(tdeltas,Substages{sub}));
        quantif_res.nb_delta_down{p,sub} = length(Restrict(tDownDelta,Substages{sub}));
    
    end
    
end


name_substages = NamesSubstages(substages_ind);
%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifDetectionDeltaDown.mat -v7.3 substages_ind quantif_res

