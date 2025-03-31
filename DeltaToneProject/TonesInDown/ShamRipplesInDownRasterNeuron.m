%%ShamRipplesInDownRasterNeuron
% 30.05.2018 KJ
%
%
% see
%   ShamInDownRasterNeuron RipplesInDownRasterNeuron
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
    
    clearvars -except Dir p sham_res sham_distrib
    
    sham_res.path{p}   = Dir.path{p};
    sham_res.manipe{p} = Dir.manipe{p};
    sham_res.name{p}   = Dir.name{p};
    sham_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s
    binsize_mua  = 2; %2ms
    minDuration = 40;
    nb_sham = 3000;
    
    %ripples    
    load('ShamRipples.mat', 'Ripples')
    sham_tmp = Ripples(:,2)*10;
    ShamEvent = ts(sham_tmp);
    
    
    %% MUA & Down
    %MUA
    MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    
    %down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 0, 'predown_size', 20, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_duration = End(down_PFCx) - Start(down_PFCx);
    
    
    %% Sham in    
    intwindow = 2000;
    aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);
    upInterval = intervalSet(Start(down_PFCx)-intwindow, Start(down_PFCx));
    upInterval = CleanUpEpoch(and(upInterval, intervalSet(Start(down_PFCx), Start(down_PFCx)+intwindow)));
    
    ShamIn = Restrict(ShamEvent, down_PFCx);
    shamin_tmp = Range(ShamIn);
    
    ShamAround = Restrict(ShamEvent, upInterval);
    shamaround_tmp = Range(ShamAround);
    
    
    %% Rasters
    sham_res.rasters.inside{p}  = RasterMatrixKJ(MUA, ShamIn, t_start, t_end);
    
    
    %% orders
    %sham in down
    sham_res.inside.before{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.after{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.postdown{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        sham_res.inside.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        sham_res.inside.after{p}(i) = end_aft - shamin_tmp(i);
        
        down_post = st_down(find(st_down>shamin_tmp(i),1));
        sham_res.inside.postdown{p}(i) = down_post - shamin_tmp(i);

    end

    %sham around down
    sham_res.around.before{p} = nan(length(shamaround_tmp), 1);
    sham_res.around.postdown{p} = nan(length(shamaround_tmp), 1);
    for i=1:length(shamaround_tmp)        
        st_bef = end_down(find(end_down<shamaround_tmp(i),1,'last'));
        sham_res.around.before{p}(i) = shamaround_tmp(i) - st_bef;
        
        down_post = st_down(find(st_down>shamaround_tmp(i),1));
        sham_res.around.postdown{p}(i) = down_post - shamaround_tmp(i);
    end
     
end

%saving data
cd(FolderDeltaDataKJ)
save ShamRipplesInDownRasterNeuron.mat -v7.3 sham_res t_start t_end binsize_mua minDuration


