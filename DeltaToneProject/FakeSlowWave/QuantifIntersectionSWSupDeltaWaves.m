%%QuantifIntersectionSWSupDeltaWaves
% 28.10.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%     
%
%


% load
clear
Dir = PathForExperimentsFakeSlowWave('allsup');

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p delta_res
    
    delta_res.path{p}   = Dir.path{p};
    delta_res.manipe{p} = Dir.manipe{p};
    delta_res.date{p}   = Dir.date{p};
    delta_res.name{p}   = Dir.name{p};

    marginsup         = 0;  
    
    %% load
    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);

    %raster
    load('RasterLFPDeltaWaves.mat','ch_sup')
    
    %delta sup
    name_var = ['delta_ch_' num2str(ch_sup)];
    load('DeltaWavesChannels.mat', name_var)
    eval(['deltas = ' name_var ';'])
    %Restrict    
    DeltaSup = and(deltas, NREM);
    
    %deltas
    load('DeltaWaves.mat', 'deltas_PFCx')
    
    
    %intersection
    larger_sup = intervalSet(Start(DeltaSup)-marginsup,End(DeltaSup));
    [~,~,Istat] = GetIntersectionsEpochs(larger_sup, deltas_PFCx);
    
    delta_res.precision(p) = Istat.precision;
    delta_res.recall(p) = Istat.recall;
    
    

end


%saving data
cd(FolderDeltaDataKJ)
save QuantifIntersectionSWSupDeltaWaves.mat delta_res



