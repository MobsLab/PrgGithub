%%DownstatesSubpopulationAnalysis_perm
%
% 11.03.2018 KJ
%
%  Takes all the down computed in DownstatesSubpopulationAnalysis, make the
%  duration distribution and compute the permuation effect
%  
%
% see
%   DownstatesSubpopulationAnalysis
%


%load
clear
load(fullfile(FolderProjetDelta,'Data','DownstatesSubpopulationAnalysis.mat'))
load(fullfile(FolderProjetDelta,'Data','DownstatesSubpopulationAnalysis2.mat'))

%params
duration_bins = 0:10:1200; %duration bins for downstates


for p=1:length(downsub_res.path)
    
    disp(' ')
    disp('****************************************************************')
    disp(downsub_res.path{p})
    
    
    %real down    
    sws_real   = GetDurationDistribution(downsub_res.all.real.sws{p}, duration_bins);
    wake_real  = GetDurationDistribution(downsub_res.all.real.wake{p}, duration_bins);
    
    %permuted
    clear sws_perm wake_perm
    for k=1:length(permutation_range)
        sws_perm{k}  = GetDurationDistribution(downsub_res.all.perm.sws{p,k}, duration_bins);
        wake_perm{k} = GetDurationDistribution(downsub_res.all.perm.wake{p,k}, duration_bins);
    end
    
    
    allneur.sws.perm_effect{p}  = GetPermutationEffect(sws_real, sws_perm, duration_bins);
    allneur.wake.perm_effect{p} = GetPermutationEffect(wake_real, wake_perm, duration_bins);
    allneur.nb_neuron{p}  = downsub_res.all.nb_neuron{p};
    allneur.sws.fr{p}  = downsub_res.all.firingrate.sws{p};
    allneur.wake.fr{p} = downsub_res.all.firingrate.wake{p};
    
    
    %% subpopulation
    for i=1:length(range_nbneurons)
        if ~isempty(downsub_res.sub.real.sws{p,i})
            %real down    
            sws_real   = GetDurationDistribution(downsub_res.sub.real.sws{p,i}, duration_bins);
            wake_real  = GetDurationDistribution(downsub_res.sub.real.wake{p,i}, duration_bins);

            %permuted
            clear sws_perm wake_perm
            for k=1:length(permutation_range)    
                sws_perm{k}   = GetDurationDistribution(permsub_res.sws{p,i,k}, duration_bins);
                wake_perm{k}  = GetDurationDistribution(permsub_res.wake{p,i,k}, duration_bins);
            end

            subneur.sws.perm_effect{p,i}  = GetPermutationEffect(sws_real, sws_perm, duration_bins);
            subneur.wake.perm_effect{p,i} = GetPermutationEffect(wake_real, wake_perm, duration_bins);
            subneur.nb_neuron{p,i}  = range_nbneurons(i);
            subneur.sws.fr{p,i}     = downsub_res.sub.firingrate.sws{p,i};
            subneur.wake.fr{p,i}    = downsub_res.sub.firingrate.wake{p,i};
        
        end
    end
    
end


%saving data
cd([FolderProjetDelta 'Data/'])
save DownstatesSubpopulationAnalysis_perm.mat -v7.3 allneur subneur permutation_range range_nbneurons












