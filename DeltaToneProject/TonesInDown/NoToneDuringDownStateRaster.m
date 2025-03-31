%%NoToneDuringDownStateRaster
% 22.03.2018 KJ
%
%
% see
%   
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);


for p=1:length(Dir.path)

    cd(Dir.path{p})

    clearvars -except Dir p raster_tsd
    
    %params
    select_tone = 'inside';
    t_start =  -1e4;
    t_end = 1e4;
    
    %load
    MUA = GetMuaNeurons_KJ('PFCx');
    load('DownState.mat')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_duration = End(down_PFCx) - Start(down_PFCx);
    nb_down = length(st_down);

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);
    nb_tones = length(tones_tmp);

    
    %% find down with no tone around
    thresh = 4000;
    down_rep  = repmat(st_down,1,length(tones_tmp));
    tones_rep = repmat(tones_tmp',length(st_down),1);
    delay_rep     = tones_rep - down_rep;
    delay_rep(delay_rep<-thresh | delay_rep>down_rep+thresh)=nan;
    delay_tonedown = max(delay_rep,[],2);
    idx_down = find(isnan(delay_tonedown));
    
    
    new_stdown = st_down(idx_down);
    new_endown = end_down(idx_down);
    
    
    %% random times
    
    idx = randsample(length(new_stdown), 3000);
    sham_tmp = [];
    for i=1:length(idx)
        min_tmp = new_stdown(idx(i));
        duree = new_endown(idx(i))-new_stdown(idx(i))+1200;
        
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end
    sham_tmp = sort(sham_tmp);
    
    
    %% delay
    
    down_rep  = repmat(new_stdown,1,length(sham_tmp));    
    end_rep   = repmat(new_endown,1,length(sham_tmp));
    sham_rep = repmat(sham_tmp,length(new_stdown),1);

    
    delay_rep = sham_rep - down_rep;    
        
    if strcmpi(select_tone,'inside')
        delay_rep(delay_rep>(end_rep-down_rep))=nan;
        delay_rep(delay_rep<0)=nan;
    elseif strcmpi(select_tone,'before')
        delay_rep(delay_rep<-1000 | delay_rep>0)=nan;
    elseif strcmpi(select_tone,'after')
        delay_rep(delay_rep<(end_rep-down_rep) | delay_rep>(end_rep-down_rep)+1000)=nan;
    end
    
    [delay_tonedown, id_max] = max(delay_rep,[],2);
    
    %ids of events
    idx_down = find(~isnan(delay_tonedown));
    id_sham = id_max(idx_down);
    
    for i=1:length(id_sham)
        iduration(i) = new_endown(idx_down(i)) - new_stdown(idx_down(i));
        ibefore(i) = sham_tmp(id_sham(i)) - new_stdown(idx_down(i));
        iafter(i) = new_endown(idx_down(i)) - sham_tmp(id_sham(i));
    end
    
    %sort
    if  strcmpi(select_tone,'after')
        [~, idx_order] = sort(iafter);        
    else
        [~, idx_order] = sort(ibefore);
    end
    
    %raster
    sham_selected = sham_tmp(id_sham);    
    raster_tsd{p} = RasterMatrixKJ(MUA, ts(sham_selected), t_start, t_end, idx_order);
     
    
end



%% Plot
figure, hold on

for p=1:length(Dir.path)
    
    x_mua = Range(raster_tsd{p});
    MatMUA = Data(raster_tsd{p})';
    
    %fig 1
    subplot(2,1,p), hold on
    imagesc(x_mua/1E4, 1:size(MatMUA,1), MatMUA), hold on
    axis xy, ylabel('# tones'), hold on
    line([0 0], ylim,'Linewidth',2,'color','k'), hold on
    set(gca,'YLim', [0 size(MatMUA,1)], 'XLim',[-1 1]);
    title(Dir.name{p}),
    
end




