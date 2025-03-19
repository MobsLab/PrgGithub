%%EndOfDownDeltaToneInside
% 04.04.2018 KJ
%
%
% see
%   ToneDuringDownStateEffect
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);


for p=1:length(Dir.path)

    cd(Dir.path{p})

%     clearvars -except Dir p 
    
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    binsize_mua = 2;
    
    minDuration = 75;
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    if ~exist('TONEtime2','var')
        continue
    end
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);
    nb_tones = length(tones_tmp);
    
    
    %% Tones in or out
    intwindow = 4000;
    aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);

    %tones in and out down states
    Allnight = intervalSet(0,max(Range(MUA)));
    ToneIn = Restrict(ToneEvent, down_PFCx);
    ToneOut = Restrict(ToneEvent, CleanUpEpoch(Allnight-aroundDown));
    
    %Down with or without
    intv_down = [Start(down_PFCx) End(down_PFCx)];
    [~,intv_with,~] = InIntervals(tones_tmp, intv_down);
    intv_with = unique(intv_with);
    intv_with(intv_with==0) = [];
    
    intv_without = setdiff(1:length(Start(down_PFCx)), intv_with);
    
    DownTone = intervalSet(intv_down(intv_with,1),intv_down(intv_with,2));
    DownNo   = intervalSet(intv_down(intv_without,1),intv_down(intv_without,2));
    
    
    %% sham
    st_downno = Start(DownNo);
    end_downno = End(DownNo);
    
    idx = randsample(length(Start(DownNo)), nb_tones);
    sham_tmp = [];
    for i=1:length(idx)
        min_tmp = st_downno(idx(i));
        duree = end_downno(idx(i))-st_downno(idx(i));
        
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end
    ShamIn = ts(sort(sham_tmp));
    
    
    %% response to MUA
    
    % In down
    [m,~,tps] = mETAverage(Range(ToneIn), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_inside{p}(:,1) = tps; met_inside{p}(:,2) = m;
    nb_inside{p} = length(ToneIn);
    % out of down
    [m,~,tps] = mETAverage(Range(ToneOut), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_out{p}(:,1) = tps; met_out{p}(:,2) = m;
    nb_out{p} = length(ToneOut);
    %sham in
    [m,~,tps] = mETAverage(Range(ShamIn), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_shamin{p}(:,1) = tps; met_shamin{p}(:,2) = m;
    nb_shamin{p} = length(ToneOut);
    
    
    %% Peth on end of down
    % with
    [m,~,tps] = mETAverage(End(DownTone), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_with{p}(:,1) = tps; met_with{p}(:,2) = m;
    nb_with{p} = length(End(DownTone));
    
    % without
    [m,~,tps] = mETAverage(End(DownNo), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_without{p}(:,1) = tps; met_without{p}(:,2) = m;
    nb_without{p} = length(End(DownNo));
    
    
    
end



%% Plot
smoothing = 0;

figure, hold on

for p=1:length(Dir.path)
    subplot(2,3,p), hold on
    
    h(1) = plot(met_inside{p}(:,1), Smooth(met_inside{p}(:,2), smoothing), 'b', 'linewidth', 2); hold on
    h(2) = plot(met_out{p}(:,1), met_out{p}(:,2), 'r', 'linewidth', 2); hold on
    h(3) = plot(met_shamin{p}(:,1), met_shamin{p}(:,2), 'color', [0.2 0.2 0.2], 'linewidth', 2); hold on
    ylim([0 0.8]),
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]),
    legend(h, ['inside (n=' num2str(nb_inside{p}) ')'], ['outside (n=' num2str(nb_out{p}) ')'], ['sham in (n=' num2str(nb_shamin{p}) ')']),
    title([Dir.name{p} '-' Dir.date{p} ' (' Dir.manipe{p} ')']),
end
suplabel('MUA on Tones','t');


figure, hold on
for p=1:length(Dir.path)
    subplot(2,3,p), hold on
    
    h(1) = plot(met_with{p}(:,1), Smooth(met_with{p}(:,2), smoothing), 'b', 'linewidth', 2); hold on
    h(2) = plot(met_without{p}(:,1), met_without{p}(:,2), 'r', 'linewidth', 2); hold on
    ylim([0 0.8]),
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]),
    legend(h, ['with (n=' num2str(nb_with{p}) ')'],['without (n=' num2str(nb_without{p}) ')']),
    title([Dir.name{p} '-' Dir.date{p} ' (' Dir.manipe{p} ')']),
end
suplabel('MUA on End of down','t');







