% DistribDelayRipplesToDown
% 27.07.2019 KJ
%
% quantification of the delay between a tone/sham and the next down, 
% for different substages
%   UP to Down
%
%
%
%   see DistribDelayToneShamDown DistribDelayRipplesToDownMousePlot
%


clear

Dir = PathForExperimentsRipplesDown; 

% params
substages_ind = 1:6; %N1, N2, N3, REM, WAKE, NREM


%% ISI for Sham
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    delay_res.path{p}      = Dir.path{p};
    delay_res.manipe{p}    = Dir.manipe{p};
    delay_res.delay{p}     = 0;
    delay_res.name{p}      = Dir.name{p};
    
    %
    minDuration = 0.5e4; %500ms
    maxDuration = 30e4;
    
    %% load
    
    %Substages
    [N1, N2, N3, REM, Wake] = GetSubstages('scoring','ob');
    NREM = or(N1,or(N2,N3));
    Substages = {N1,N2,N3,REM,Wake,NREM};
    %ripples       
    [tRipples, ~] = GetRipples;
    ripples_res.nb_ripples = length(tRipples);
    
    %MUA & Down
    if strcmpi(Dir.name{p},'Mouse508')
        down_PFCx = GetDownStates('area','PFCx_r');
    elseif strcmpi(Dir.name{p},'Mouse509')
        down_PFCx = GetDownStates('area','PFCx_l');
    else
        down_PFCx = GetDownStates;
    end
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropShortIntervals(up_PFCx, minDuration);
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Create sham
    nb_sham = 2000;
    idx = randsample(length(st_up), nb_sham);
    sham_tmp = [];

    for i=1:length(idx)
        min_tmp = st_up(idx(i));
        duree = end_up(idx(i))-st_up(idx(i));
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end    
    ShamEvent = ts(sort(sham_tmp));
    
    
    %% Random timestamps      
    for sub=substages_ind
        rdm_tmp = Range(Restrict(Restrict(ShamEvent, up_PFCx),Substages{sub}));
        nb_rdm = length(rdm_tmp);
        
        %down
        delay_rdm = nan(nb_rdm, 1);
        for i=1:nb_rdm
            idx_down_after = find(st_down > rdm_tmp(i), 1);
            if ~isempty(idx_down_after)
                delay_rdm(i) = st_down(idx_down_after) - rdm_tmp(i);   
            end
        end
        
        delay_res.delay_rdm{p,sub} = delay_rdm;
    end
    
    %% Ripples  
    for sub=substages_ind
        ripples_tmp = Range(Restrict(Restrict(tRipples, up_PFCx),Substages{sub}));
        nb_ripples = length(ripples_tmp);
        
        %down
        delay_ripples = nan(nb_ripples, 1);
        for i=1:nb_ripples
            idx_down_after = find(st_down > ripples_tmp(i), 1);
            if ~isempty(idx_down_after)
                delay_ripples(i) = st_down(idx_down_after) - ripples_tmp(i);   
            end
        end
        
        delay_res.delay_ripples{p,sub} = delay_ripples;
    end
    

end

%saving data
cd(FolderDeltaDataKJ)
save DistribDelayRipplesToDown.mat delay_res substages_ind




