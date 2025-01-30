%%RipplesShamInUpRasterNeuron
% 14.06.2018 KJ
%
%
% see
%   RipplesInUpRasterNeuron
% 


clear

Dir=PathForExperimentsBasalSleepSpike;
Dir=RestrictPathForExperiment(Dir, 'nMice', [243,244,403,451]);


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p sham_res
    
    sham_res.path{p}   = Dir.path{p};
    sham_res.manipe{p} = Dir.manipe{p};
    sham_res.name{p}   = Dir.name{p};
    sham_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -2e4; %1s
    t_end        = 2e4; %1s
    binsize_mua  = 2; %2ms
    maxDuration  = 10e4;
    
    %ripples    
    load('ShamRipples.mat', 'Ripples')
    sham_tmp = Ripples(:,2)*10;
    ShamEvent = ts(sham_tmp);
    
    
    
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
    ShamIn = Restrict(ShamEvent, up_PFCx);
    shamin_tmp = Range(ShamIn);
    
    
    %% Rasters
    sham_res.rasters.inside{p}  = RasterMatrixKJ(MUA, ShamIn, t_start, t_end);
    
    
    %% orders
    %ripples in up
    sham_res.inside.before{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.after{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.postup{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.postdown{p} = nan(length(shamin_tmp), 1);
    
    for i=1:length(shamin_tmp)     
        try
            st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
            sham_res.inside.before{p}(i) = shamin_tmp(i) - st_bef;
        end
        try
            end_aft = end_up(find(end_up>shamin_tmp(i),1));
            sham_res.inside.after{p}(i) = end_aft - shamin_tmp(i);
        end
        try
            up_post = st_up(find(st_up>shamin_tmp(i),1));
            sham_res.inside.postup{p}(i) = up_post - shamin_tmp(i);
        end
        try
            down_post = st_down(find(st_down>shamin_tmp(i),1));
            sham_res.inside.postdown{p}(i) = down_post - shamin_tmp(i);
        end
    end
    
end

%saving data
cd(FolderDeltaDataKJ)
save RipplesShamInUpRasterNeuron.mat -v7.3 sham_res t_start t_end binsize_mua maxDuration





