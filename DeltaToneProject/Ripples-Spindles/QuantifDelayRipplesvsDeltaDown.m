% QuantifDelayRipplesvsDeltaDown
% 21.09.2017 KJ
%
% collect data for the quantification of the delay between a ripples and the next delta, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE
%
% Here, the data are just collected and saved
%
%   see QuantifDelayripplesDelta 


clear
%% Dir
Dir=PathForExperimentsDeltaLongSleepNew('basal');
% Dir = PathForExperimentsDeltaKJHD('basal');

Dir.condition=Dir.manipe;

% params
substages_ind = 1:6; %N1, N2, N3, REM, WAKE, NREM



%% ISI for DeltaTone
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    delay_res.path{p}=Dir.path{p};
    delay_res.manipe{p}=Dir.manipe{p};
    delay_res.delay{p}=0;
    delay_res.name{p}=Dir.name{p};
    delay_res.condition{p}=Dir.condition{p};
    
    
    %% load
    %ripples
    load newRipHPC Ripples_tmp
    RipplesEvent = ts(Ripples_tmp(:,2)*1E4);
    
    %Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline = DeltaEpoch;
        clear DeltaEpoch
    end
    start_deltas = Start(DeltaOffline);
    
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

    %Substages
    clear op NamesOp Dpfc Epoch noise
    load NREMepochsML.mat op NamesOp Dpfc Epoch noise
    disp('Loading epochs from NREMepochsML.m')
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    
    %% Sound and delay    
    for sub=substages_ind
        ripples_tmp = Range(Restrict(RipplesEvent, Substages{sub}));
        nb_ripples = length(ripples_tmp);
        
        %delta
        delay_delta_ripples = zeros(nb_ripples, 1);
        for i=1:nb_ripples
            idx_delta_before = find(start_deltas > ripples_tmp(i), 1);
            if isempty(idx_delta_before)
                delay_delta_ripples(i) = nan;
            else
                delay_delta_ripples(i) = start_deltas(idx_delta_before) - ripples_tmp(i);    
            end
        end
        
        %down
        delay_down_ripples = zeros(nb_ripples, 1);
        for i=1:nb_ripples
            idx_down_before = find(start_down > ripples_tmp(i), 1);
            if isempty(idx_down_before)
                delay_down_ripples(i) = nan;
            else
                delay_down_ripples(i) = start_down(idx_down_before) - ripples_tmp(i);    
            end
        end
        
        
        %save
        delay_delta_ripples(isnan(delay_delta_ripples)) = [];
        delay_res.delay_delta_ripples{p,sub} = delay_delta_ripples;
        
        delay_down_ripples(isnan(delay_down_ripples)) = [];
        delay_res.delay_down_ripples{p,sub} = delay_down_ripples;
        
    end

end


%saving data
cd([FolderProjetDelta 'Data/'])
save QuantifDelayRipplesvsDeltaDown.mat delay_res substages_ind 


