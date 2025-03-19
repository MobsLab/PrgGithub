%%DistribShamvsToneInDown2
% 04.04.2018 KJ
%
%   same as DistribShamvsToneInDown, but here the distributions of
%   delay(start,tones) should be the same
%
% see
%   ToneDuringDownStateEffect EndOfDownDeltaToneInside DistribShamvsToneInDown
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);


for p=1:length(Dir.path)

    cd(Dir.path{p})

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    binsize_mua = 2;
    
    minDuration = 75;
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    
    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);
    nb_tones = length(tones_tmp);
    
    
    %% Delay between tones/sham and down

    %tones in
    ToneIn = Restrict(ToneEvent, down_PFCx);
    tonesin_tmp = Range(ToneIn);
    
    tones_bef{p} = nan(length(tonesin_tmp), 1);
    tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>tonesin_tmp(i),1));
        tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    %distribution
    edges = 0:200:4000;
    [y_distrib, x_distrib] = histcounts(tones_bef{p}, edges,'Normalization','probability');
    x_distrib = x_distrib(1:end-1) + diff(x_distrib);
    
    
    %% Create Sham
    delay_generated = GenerateNumbersDistribution_KJ(x_distrib, y_distrib, 6000);
    
    idx = randsample(length(st_down), 3000);
    sham_tmp = [];
    for i=1:length(idx)
        min_tmp = st_down(idx(i));
        duree  = end_down(idx(i))-st_down(idx(i));
        delays = randsample(delay_generated,1);
        
        if delays<duree
            sham_tmp = [sham_tmp min_tmp+delays];
        end
    end
    shamin_tmp = sort(sham_tmp);
    ShamIn = ts(shamin_tmp);
    
    
    %% Delay between sham and down

    sham_bef{p} = nan(length(shamin_tmp), 1);
    sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    
    
    
end


%% distrib
edges = 0:20:400;
edges_norm = 0:0.05:1;

for p=1:length(Dir.path)
    
    %tones
    [d_before.tones{p}, x_before.tones{p}] = histcounts(tones_bef{p}/10, edges,'Normalization','probability');
    x_before.tones{p} = x_before.tones{p}(1:end-1) + diff(x_before.tones{p});
    
    [d_after.tones{p}, x_after.tones{p}] = histcounts(tones_aft{p}/10, edges,'Normalization','probability');
    x_after.tones{p} = x_after.tones{p}(1:end-1) + diff(x_after.tones{p});
    
    norm_tones{p} = tones_bef{p} ./ (tones_bef{p} + tones_aft{p});
    [d_norm.tones{p}, x_norm.tones{p}] = histcounts(norm_tones{p}, edges_norm,'Normalization','probability');
    x_norm.tones{p} = x_norm.tones{p}(1:end-1) + diff(x_norm.tones{p});
    
    
    %sham
    [d_before.sham{p}, x_before.sham{p}] = histcounts(sham_bef{p}/10, edges,'Normalization','probability');
    x_before.sham{p} = x_before.sham{p}(1:end-1) + diff(x_before.sham{p});
    
    [d_after.sham{p}, x_after.sham{p}] = histcounts(sham_aft{p}/10, edges,'Normalization','probability');
    x_after.sham{p} = x_after.sham{p}(1:end-1) + diff(x_after.sham{p});
    
    norm_sham{p} = sham_bef{p} ./ (sham_bef{p} + sham_aft{p});
    [d_norm.sham{p}, x_norm.sham{p}] = histcounts(norm_sham{p}, edges_norm,'Normalization','probability');
    x_norm.sham{p} = x_norm.sham{p}(1:end-1) + diff(x_norm.sham{p});
end


%% Plot
smoothing = 1;

%Start
figure, hold on
for p=1:length(Dir.path)
    subplot(2,3,p), hold on
    
    
    h(1) = plot(x_before.tones{p}, Smooth(d_before.tones{p},smoothing),'b','linewidth',2); hold on
    h(2) = plot(x_before.sham{p}, Smooth(d_before.sham{p},smoothing),'color', [0.2 0.2 0.2], 'linewidth',2); hold on
    legend(h, 'tones', 'sham'),
    xlabel('delay (ms)'), ylabel('probability')

    title([Dir.name{p} '-' Dir.date{p} ' (' Dir.manipe{p} ')']),
end
suplabel('Delay between start and tones/sham','t');


%End
figure, hold on
for p=1:length(Dir.path)
    subplot(2,3,p), hold on
    
    
    h(1) = plot(x_after.tones{p}, Smooth(d_after.tones{p},smoothing),'b','linewidth',2); hold on
    h(2) = plot(x_after.sham{p}, Smooth(d_after.sham{p},smoothing),'color', [0.2 0.2 0.2], 'linewidth',2); hold on
    legend(h, 'tones', 'sham'),
    xlabel('delay (ms)'), ylabel('probability')

    title([Dir.name{p} '-' Dir.date{p} ' (' Dir.manipe{p} ')']),
end
suplabel('Delay between end and tones/sham','t');


%Norm
figure, hold on
for p=1:length(Dir.path)
    subplot(2,3,p), hold on
    
    
    h(1) = plot(x_norm.tones{p}, Smooth(d_norm.tones{p},smoothing),'b','linewidth',2); hold on
    h(2) = plot(x_norm.sham{p}, Smooth(d_norm.sham{p},smoothing),'color', [0.2 0.2 0.2], 'linewidth',2); hold on
    legend(h, 'tones', 'sham'),
    xlabel('delay (ms)'), ylabel('probability')

    title([Dir.name{p} '-' Dir.date{p} ' (' Dir.manipe{p} ')']),
end
suplabel('Occurence of sham/tones in down','t');




