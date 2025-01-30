%%FiguresShamInDownPerRecord
% 12.06.2018 KJ
%
%
%
%
% see
%   ToneDuringDownStateEffect EndOfDownDeltaToneInside
%   DistribShamvsToneInDown FiguresTonesInDownPerRecordPlot
%


clear

Dir=PathForExperimentsRandomShamSpikes;

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p figsham_res
    
    figsham_res.path{p}   = Dir.path{p};
    figsham_res.manipe{p} = Dir.manipe{p};
    figsham_res.name{p}   = Dir.name{p};
    figsham_res.date{p}   = Dir.date{p};

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    binsize_mua = 2;
    
    minDuration = 20;
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    
    
    %% Sham in and out
    ShamIn = Restrict(SHAMtime, down_PFCx);
    shamin_tmp = Range(ShamIn);

    
    %% Delay between sham and down
    figsham_res.sham_bef{p} = nan(length(shamin_tmp), 1);
    figsham_res.sham_aft{p} = nan(length(shamin_tmp), 1);
    figsham_res.sham_post{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        figsham_res.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        figsham_res.sham_aft{p}(i) = end_aft - shamin_tmp(i);
        
        down_post = st_down(find(st_down>shamin_tmp(i),1));
        figsham_res.sham_post{p}(i) = down_post - shamin_tmp(i);
    end
    
    
    %% MUA response for tones & sham
    
    %sham in
    [m,~,tps] = mETAverage(Range(ShamIn), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    figsham_res.met_shamin{p}(:,1) = tps; figsham_res.met_shamin{p}(:,2) = m;
    figsham_res.nb_shamin{p} = length(ShamIn);

    
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save FiguresShamInDownPerRecord.mat figsham_res binsize_met nbBins_met binsize_mua minDuration


