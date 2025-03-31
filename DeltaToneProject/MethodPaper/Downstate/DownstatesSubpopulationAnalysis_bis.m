%%DownstatesSubpopulationAnalysis_bis
%
% 11.03.2018 KJ
%
%   Takes all the down computed in DownstatesSubpopulationAnalysis, remove
%   shoort and long events, and compute density curves and then:
%   - overlap, distance to density...
%
% see
%   DownstatesSubpopulationAnalysis
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'DownstatesSubpopulationAnalysis.mat'))


for p=1:length(downsub_res.path)
    
    disp(' ')
    disp('****************************************************************')
    disp(downsub_res.path{p})
    
    clearvars -except downsub_res p suball_res range_nbneurons
    
    downsub_res.path{p}   = downsub_res.path{p};
    downsub_res.manipe{p} = downsub_res.manipe{p};
    downsub_res.name{p}   = downsub_res.name{p};
    downsub_res.date{p}   = downsub_res.date{p};
    
    
    %params
    margin_intv = 0;  %0ms, the down must be inside sub population down  
    smoothing = 1;
    windowsize = 60E4; %60s
    
    %load
    load(fullfile(downsub_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    load(fullfile(downsub_res.path{p}, 'DownState.mat'), 'down_PFCx','down_PFCx_Info')
    down_tmp = (Start(down_PFCx)+End(down_PFCx)) / 2;
    min_duration = down_PFCx_Info.min_duration;
    max_duration = down_PFCx_Info.max_duration;
    
    %intervals
    intervals_start = 0:windowsize:night_duration;    
    x_intervals = (intervals_start + windowsize/2)/(3600E4);
    
    
    %% down density
    down_density = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        down_density(t) = length(Restrict(ts(down_tmp),intv))/60; %per sec
    end
    down_density = Smooth(down_density, smoothing);
    
    
    %% subpopulation
    for i=1:length(range_nbneurons)
        if ~isempty(downsub_res.sub.real.sws{p,i})
            %subpopulation down    
            sub_Down = downsub_res.sub.real.sws{p,i};
            sub_Down = dropShortIntervals(sub_Down, min_duration);
            sub_Down = dropLongIntervals(sub_Down, max_duration);
            
            
            %subpopulation down density
            subdown_tmp = (Start(sub_Down)+End(sub_Down)) / 2;
            subdown_density = zeros(length(intervals_start),1);
            for t=1:length(intervals_start)
                intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
                subdown_density(t) = length(Restrict(ts(subdown_tmp),intv))/60; %per sec
            end
            subdown_density = Smooth(subdown_density, smoothing);
            
            
            %measures
            frechet_distance = DiscreteFrechetDist(down_density, subdown_density);
            [nb_overlap, nd_down_alone, nb_sub_alone] = CountCoincidenceIntervals(down_PFCx, sub_Down, margin_intv);
            
            
            %save
            suball_res.density_distance{p,i} = frechet_distance;
            
            suball_res.detect.intersection{p,i} = nb_overlap;
            suball_res.detect.sub_alone{p,i}    = nb_sub_alone;
            suball_res.detect.down_alone{p,i}   = nd_down_alone;
            
            suball_res.nb_neuron{p,i}  = downsub_res.sub.nb_neuron{p,i};
            suball_res.sws.fr{p,i}     = downsub_res.sub.firingrate.sws{p,i};
            suball_res.wake.fr{p,i}    = downsub_res.sub.firingrate.wake{p,i};
        
        end
    end
    
end

%saving data
cd([FolderProjetDelta 'Data/'])
save DownstatesSubpopulationAnalysis_bis.mat -v7.3 suball_res range_nbneurons margin_intv




