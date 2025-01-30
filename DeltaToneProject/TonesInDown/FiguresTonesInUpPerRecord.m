%%FiguresTonesInUpPerRecord
% 19.04.2018 KJ
%
%
%
%
% see
%   ToneDuringDownStateEffect EndOfDownDeltaToneInside
%   FiguresTonesInDownPerRecord FiguresTonesInDownPerRecordPlot
%


clear

Dir = PathForExperimentsRandomTonesSpikes;

sham_distrib = 0;

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p figure_res sham_distrib
    
    figure_res.path{p}   = Dir.path{p};
    figure_res.manipe{p} = Dir.manipe{p};
    figure_res.name{p}   = Dir.name{p};
    figure_res.date{p}   = Dir.date{p};

   
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
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    tones_tmp = Range(ToneEvent);
    
    %% Tones in or out

    %tones in and out down states
    ToneIn = Restrict(ToneEvent, up_PFCx);
    
    %Up with or without
    intv_up = [Start(up_PFCx) End(up_PFCx)];
    [~,intv_with,~] = InIntervals(tones_tmp, intv_up);
    intv_with = unique(intv_with);
    intv_with(intv_with==0) = [];
    
    intv_without = setdiff(1:length(Start(up_PFCx)), intv_with);
    
    UpTone = intervalSet(intv_up(intv_with,1),intv_up(intv_with,2));
    UpNo   = intervalSet(intv_up(intv_without,1),intv_up(intv_without,2));
    
    
    %% Delay between tones and down

    %tones in
    tonesin_tmp = Range(ToneIn);
    
    figure_res.tones_bef{p} = nan(length(tonesin_tmp), 1);
    figure_res.tones_aft{p} = nan(length(tonesin_tmp), 1);
    figure_res.tones_post{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_up(find(st_up<tonesin_tmp(i),1,'last'));
        figure_res.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>tonesin_tmp(i),1));
        figure_res.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
        
        up_post = st_up(find(st_up>tonesin_tmp(i),1));
        figure_res.tones_post{p}(i) = up_post - tonesin_tmp(i);
    end
    
    
    %% Create Sham 
    nb_sham = 3000;
    idx = randsample(length(st_up), nb_sham);
    sham_tmp = [];
        
    if sham_distrib %same distribution as tones for delay(start_down,sham)

        %distribution
        edges_delay = 0:50:4000;
        [y_distrib, x_distrib] = histcounts(figure_res.tones_bef{p}, edges_delay, 'Normalization','probability');
        x_distrib = x_distrib(1:end-1) + diff(x_distrib);
        delay_generated = GenerateNumbersDistribution_KJ(x_distrib, y_distrib, 6000);

        for i=1:length(idx)
            min_tmp = st_up(idx(i));
            duree  = end_up(idx(i))-st_up(idx(i));
            delays = randsample(delay_generated,1);

            if delays<duree
                sham_tmp = [sham_tmp min_tmp+delays];
            end
        end
    
    else %uniform sham
        for i=1:length(idx)
            min_tmp = st_up(idx(i));
            duree = end_up(idx(i))-st_up(idx(i));
            sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
        end
    end
    
    shamin_tmp = sort(sham_tmp);
    ShamIn = ts(shamin_tmp);
    
    
    %% Delay between sham and down
    figure_res.sham_bef{p} = [];
    figure_res.sham_aft{p} = [];
    figure_res.sham_post{p} = [];
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        up_post = st_up(find(st_up>shamin_tmp(i),1));
        
        if ~isempty(st_bef) && ~isempty(end_aft) && ~isempty(up_post) 
            figure_res.sham_bef{p}  = [figure_res.sham_bef{p}  ; shamin_tmp(i) - st_bef];
            figure_res.sham_aft{p}  = [figure_res.sham_aft{p}  ; end_aft - shamin_tmp(i)];
            figure_res.sham_post{p} = [figure_res.sham_post{p} ; up_post - shamin_tmp(i)];
        end
        
    end
    
    
end


%saving data
cd(FolderDeltaDataKJ)
if sham_distrib
    save FiguresTonesInUpPerRecord_2.mat figure_res sham_distrib binsize_mua maxDuration nb_sham
else
    save FiguresTonesInUpPerRecord.mat figure_res sham_distrib binsize_mua maxDuration nb_sham
end


