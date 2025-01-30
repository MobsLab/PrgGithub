%%RipplesInDownRasterNeuron
% 30.05.2018 KJ
%
%
% see
%   ToneInDownRasterNeuron 
%
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
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s
    binsize_mua  = 2; %2ms
    minDuration = 40;
    
    %ripples    
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10;
    RipplesEvent = ts(ripples_tmp);
    
    
    %% MUA & Down
    %MUA
    MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    
    %down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 0, 'predown_size', 20, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_duration = End(down_PFCx) - Start(down_PFCx);
    
    
    %% Rippless in or out
    intwindow = 2000;
    aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);
    upInterval = intervalSet(Start(down_PFCx)-intwindow, Start(down_PFCx));
    upInterval = CleanUpEpoch(and(upInterval, intervalSet(Start(down_PFCx), Start(down_PFCx)+intwindow)));
    

    %ripples in and out down states
    Allnight = intervalSet(0,max(Range(MUA)));
    RipplesIn = Restrict(RipplesEvent, down_PFCx);
    RipplesOut = Restrict(RipplesEvent, CleanUpEpoch(Allnight-aroundDown));
    RipplesAround = Restrict(RipplesEvent, upInterval);
    
    ripplesin_tmp = Range(RipplesIn);
    ripplesout_tmp = Range(RipplesOut);
    ripplesaround_tmp = Range(RipplesAround);
    
    
    %% Rasters    
    ripples_res.rasters.inside{p}  = RasterMatrixKJ(MUA, RipplesIn, t_start, t_end);
    
    
    %% orders
    %ripples in down
    ripples_res.inside.before{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.inside.after{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.inside.postdown{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)        
        st_bef = st_down(find(st_down<ripplesin_tmp(i),1,'last'));
        ripples_res.inside.before{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>ripplesin_tmp(i),1));
        ripples_res.inside.after{p}(i) = end_aft - ripplesin_tmp(i);
        
        down_post = st_down(find(st_down>ripplesin_tmp(i),1));
        ripples_res.inside.postdown{p}(i) = down_post - ripplesin_tmp(i);

    end
    
    %ripples around down
    ripples_res.around.before{p} = nan(length(ripplesaround_tmp), 1);
    ripples_res.around.postdown{p} = nan(length(ripplesaround_tmp), 1);
    for i=1:length(ripplesaround_tmp)        
        st_bef = end_down(find(end_down<ripplesaround_tmp(i),1,'last'));
        ripples_res.around.before{p}(i) = ripplesaround_tmp(i) - st_bef;
        
        down_post = st_down(find(st_down>ripplesaround_tmp(i),1));
        ripples_res.around.postdown{p}(i) = down_post - ripplesaround_tmp(i);
    end
    
     
end

%saving data
cd(FolderDeltaDataKJ)
save RipplesInDownRasterNeuron.mat -v7.3 ripples_res t_start t_end binsize_mua minDuration





