%%RipplesInUpRasterNeuron
% 18.04.2018 KJ
%
%
% see
%   ToneInUpRasterNeuron RipplesInUpRasterNeuron_old
% 


clear

Dir=PathForExperimentsBasalSleepSpike;
Dir=RestrictPathForExperiment(Dir, 'nMice', [243,244,403,451]);


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ripples_res
    
    ripples_res.path{p}   = Dir.path{p};
    ripples_res.manipe{p} = Dir.manipe{p};
    ripples_res.name{p}   = Dir.name{p};
    ripples_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -2e4; %1s
    t_end        = 2e4; %1s
    binsize_mua  = 2; %2ms
    maxDuration  = 10e4;
    
    %ripples    
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10;
    RipplesEvent = ts(ripples_tmp);
    
    
    
    %% MUA & Down
    %MUA
    MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration); %5sec
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Ripples in up
    RipplesIn = Restrict(RipplesEvent, up_PFCx);
    ripplesin_tmp = Range(RipplesIn);
    
    
    %% Rasters
    ripples_res.rasters.inside{p}  = RasterMatrixKJ(MUA, RipplesIn, t_start, t_end);
    
    
    %% orders
    %ripples in up
    ripples_res.inside.before{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.inside.after{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.inside.postup{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.inside.postdown{p} = nan(length(ripplesin_tmp), 1);
    
    for i=1:length(ripplesin_tmp)     
        try
            st_bef = st_up(find(st_up<ripplesin_tmp(i),1,'last'));
            ripples_res.inside.before{p}(i) = ripplesin_tmp(i) - st_bef;
        end
        try
            end_aft = end_up(find(end_up>ripplesin_tmp(i),1));
            ripples_res.inside.after{p}(i) = end_aft - ripplesin_tmp(i);
        end
        try
            up_post = st_up(find(st_up>ripplesin_tmp(i),1));
            ripples_res.inside.postup{p}(i) = up_post - ripplesin_tmp(i);
        end
        try
            down_post = st_down(find(st_down>ripplesin_tmp(i),1));
            ripples_res.inside.postdown{p}(i) = down_post - ripplesin_tmp(i);
        end
    end
    
end

%saving data
cd(FolderDeltaDataKJ)
save RipplesInUpRasterNeuron.mat -v7.3 ripples_res t_start t_end binsize_mua maxDuration





