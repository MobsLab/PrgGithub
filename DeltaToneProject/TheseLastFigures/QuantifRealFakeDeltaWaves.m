%%QuantifRealFakeDeltaWaves
% 16.09.2019 KJ
%
%   
%
% see
%   CharacterisationDeltaDownStates CharacterisationDeltaDownStates
%


clear
Dir = PathForExperimentsFakeSlowWave('sup');


%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p quantif_res
    
    quantif_res.path{p}   = Dir.path{p};
    quantif_res.manipe{p} = Dir.manipe{p};
    quantif_res.name{p}   = Dir.name{p};
    quantif_res.date{p}   = Dir.date{p};

    %params
    marginsup  = 0.1e4;
    
    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);
    %Substages
    [N1, N2, N3, REM, Wake] = GetSubstages('scoring','ob');
    Substages = {N1,N2,N3,REM,Wake};
    NameSubstages = {'N1','N2','N3','REM','Wake'};
        
    
    %% down states
    %down
    try
        load('DownState.mat', 'down_PFCx_r')
        down_PFCx = down_PFCx_r;
    catch
        load('DownState.mat', 'down_PFCx')
    end
    
    
    
    %% delta waves
 
    %channels
    try
        load('ChannelsToAnalyse/PFCx_deep_right.mat')
        ch_deep = channel; clear channel
        load('ChannelsToAnalyse/PFCx_sup_right.mat')
        ch_sup = channel; clear channel 
    catch
        load('ChannelsToAnalyse/PFCx_deep.mat')
        ch_deep = channel; clear channel
        load('ChannelsToAnalyse/PFCx_sup.mat')
        ch_sup = channel; clear channel       
    end
    
    %Deep
    name_var = ['delta_ch_' num2str(ch_deep)];
    load('DeltaWavesChannels.mat', name_var)
    eval(['deltas = ' name_var ';'])
    DeltaDeep  = and(deltas, NREM);

    %Sup
    name_var = ['delta_ch_' num2str(ch_sup)];
    load('DeltaWavesChannels.mat', name_var)
    eval(['deltas = ' name_var ';'])
    DeltaSup  = and(deltas, NREM);
        

    %% Quantification good and fake
 
    quantif_res.nb_down{p} = length(Start(down_PFCx));

    %Deep
    RealDelta = GetIntersectionsEpochs(DeltaDeep, down_PFCx);

    quantif_res.deep.nb_delta{p} = length(Start(DeltaDeep));
    quantif_res.deep.nb_real{p} = length(Start(RealDelta));
    quantif_res.deep.nb_fake{p} = length(Start(DeltaDeep)) - length(Start(RealDelta));

    %Sup
    larger_deltas = intervalSet(Start(DeltaSup)-marginsup,End(DeltaSup));
    RealDelta = GetIntersectionsEpochs(larger_deltas, down_PFCx);

    quantif_res.sup.nb_delta{p} = length(Start(DeltaSup));
    quantif_res.sup.nb_real{p} = length(Start(RealDelta));
    quantif_res.sup.nb_fake{p} = length(Start(DeltaSup)) - length(Start(RealDelta));
    
    
    
    %% Substages
    for s=1:3
        %down of substages
        down_sub = and(down_PFCx,Substages{s});
        down_sub = GetIntersectionsEpochs(down_PFCx, down_sub);
        
        %deltas of substages
        DeltaDeep_sub = and(DeltaDeep,Substages{s});
        DeltaDeep_sub = GetIntersectionsEpochs(DeltaDeep, DeltaDeep_sub);
        DeltaSup_sub = and(DeltaSup,Substages{s});
        DeltaSup_sub = GetIntersectionsEpochs(DeltaSup, DeltaSup_sub);
        
        
        %Quantif
        quantif_res.sub.nb_down{p,s} = length(Start(down_sub));

        %Deep
        RealDelta = GetIntersectionsEpochs(DeltaDeep_sub, down_sub);

        quantif_res.deep.sub.nb_delta{p,s} = length(Start(DeltaDeep_sub));
        quantif_res.deep.sub.nb_real{p,s} = length(Start(RealDelta));
        quantif_res.deep.sub.nb_fake{p,s} = length(Start(DeltaDeep_sub)) - length(Start(RealDelta));

        %Sup
        larger_deltas = intervalSet(Start(DeltaSup_sub)-marginsup,End(DeltaSup_sub));
        RealDelta = GetIntersectionsEpochs(larger_deltas, down_sub);

        quantif_res.sup.sub.nb_delta{p,s} = length(Start(DeltaSup_sub));
        quantif_res.sup.sub.nb_real{p,s} = length(Start(RealDelta));
        quantif_res.sup.sub.nb_fake{p,s} = length(Start(DeltaSup_sub)) - length(Start(RealDelta));
        
    end
    
    
    
end



%saving data
cd(FolderDeltaDataKJ)
save QuantifRealFakeDeltaWaves.mat quantif_res NameSubstages




