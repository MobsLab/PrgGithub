%%FiguresShamInUpPerRecord
% 12.06.2018 KJ
%
%
% see
%   FiguresTonesInUpPerRecord ShamInUpRasterNeuron Fig1TonesInUpEffect
%


clear

Dir=PathForExperimentsRandomShamSpikes;


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p figure_res figsham_res
    
    figsham_res.path{p}   = Dir.path{p};
    figsham_res.manipe{p} = Dir.manipe{p};
    figsham_res.name{p}   = Dir.name{p};
    figsham_res.date{p}   = Dir.date{p};
    
    
    %params
    binsize_mua = 2;
    maxDuration = 30e4;
    
    %SWSEpoch
    load('SleepScoring_OBGamma.mat', 'SWSEpoch')
    
    %Down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration); %5sec
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    
    
    %% Sham in and out
    ShamIn = Restrict(SHAMtime, up_PFCx);
    shamin_tmp = Range(ShamIn);
  
    
    %% Delay between sham and down
    figsham_res.sham_bef{p} = [];
    figsham_res.sham_aft{p} = [];
    figsham_res.sham_post{p} = [];
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        up_post = st_up(find(st_up>shamin_tmp(i),1));
        
        if ~isempty(st_bef) && ~isempty(end_aft) && ~isempty(up_post) 
            figsham_res.sham_bef{p}  = [figsham_res.sham_bef{p}  ; shamin_tmp(i) - st_bef];
            figsham_res.sham_aft{p}  = [figsham_res.sham_aft{p}  ; end_aft - shamin_tmp(i)];
            figsham_res.sham_post{p} = [figsham_res.sham_post{p} ; up_post - shamin_tmp(i)];
        end
        
    end
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save FiguresShamInUpPerRecord.mat figsham_res binsize_mua maxDuration


