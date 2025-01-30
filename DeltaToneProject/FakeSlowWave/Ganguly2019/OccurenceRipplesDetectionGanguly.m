%%OccurenceRipplesDetectionGanguly
% 09.11.2019 KJ
%
% Infos
%   quantify occurence of ripples in relation to fake/real delta sup
%
% see
%     OccurenceRipplesFakeDeltaDeep
% 
% 

clear
Dir = PathForExperimentsFakeSlowWave;


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p ripples_res
    
    ripples_res.path{p}   = Dir.path{p};
    ripples_res.manipe{p} = Dir.manipe{p};
    ripples_res.name{p}   = Dir.name{p};
    ripples_res.date{p}   = Dir.date{p};
    
    %params
    binsize_cc = 5; %10ms
    nb_binscc = 400; 


    %% load
    
    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %Ripples  
    [tRipples, ~] = GetRipples;
    
    %Deltawaves
    load('DeltaWaves.mat', 'deltas_PFCx')
    DeltaDiff = deltas_PFCx;

    %Down
    down_PFCx = GetDownStates('area','PFCx');
    
    %ganguly detections
    load('GangulyWaves.mat','SlowOcsci','deltaDetect')
    
    
    %% cross corr 
    
    %delta diff
    [ripples_res.diff{p}(:,2), ripples_res.diff{p}(:,1)] = CrossCorr(Range(tRipples), Start(DeltaDiff), binsize_cc, nb_binscc);
    
    %with down
    [ripples_res.down{p}(:,2), ripples_res.down{p}(:,1)] = CrossCorr(Range(tRipples), Start(down_PFCx), binsize_cc, nb_binscc);
    
    %with so ganguly
    [ripples_res.so{p}(:,2), ripples_res.so{p}(:,1)] = CrossCorr(Range(tRipples), Start(SlowOcsci), binsize_cc, nb_binscc);
    
    %with delta ganguly
    [ripples_res.delta{p}(:,2), ripples_res.delta{p}(:,1)] = CrossCorr(Range(tRipples), Start(deltaDetect), binsize_cc, nb_binscc);
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save OccurenceRipplesDetectionGanguly.mat ripples_res


