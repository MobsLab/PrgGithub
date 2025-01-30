%%RipplesDuringDownStateRaster
% 29.03.2018 KJ
%
%
% see
%   
%


clear


a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243'; % 16-04-2015 > random tone effect  - Mouse 243 (delay 200ms!! of M244 detection)
Dir.delay{a}=0.2; Dir.name{a}='Mouse243'; Dir.date{a}='16042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244'; % 17-04-2015 > random tone effect  - Mouse 244 (delay 200ms!! of M243 detection)
Dir.delay{a}=0.2; Dir.name{a}='Mouse244'; Dir.date{a}='17042015';



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

    %ripples
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10;

    
    %% delay

    %delay
    down_rep = repmat(st_down,1,length(ripples_tmp));
    end_rep = repmat(end_down,1,length(ripples_tmp));
    ripples_rep = repmat(ripples_tmp',length(st_down),1);

    delay_rep = ripples_rep - down_rep;
    
        
    if strcmpi(select_tone,'inside')
        delay_rep(delay_rep>(end_rep-down_rep))=nan;
        delay_rep(delay_rep<0)=nan;
    elseif strcmpi(select_tone,'before')
        delay_rep(delay_rep<-1000 | delay_rep>0)=nan;
    elseif strcmpi(select_tone,'after')
        delay_rep(delay_rep<(end_rep-down_rep) | delay_rep>(end_rep-down_rep)+1000)=nan;
    end
    
    [delay_ripdown, id_max] = max(delay_rep,[],2);
    
    %ids of events
    idx_down = find(~isnan(delay_ripdown));
    id_ripples = id_max(idx_down);
    
    for i=1:length(id_ripples)
        
        iduration(i) = end_down(idx_down(i)) - st_down(idx_down(i));
        ibefore(i) = ripples_tmp(id_ripples(i)) - st_down(idx_down(i));
        iafter(i) = end_down(idx_down(i)) - ripples_tmp(id_ripples(i));
        
    end
    
    %sort
    if  strcmpi(select_tone,'after')
        [~, idx_order] = sort(iafter);        
    else
        [~, idx_order] = sort(ibefore);
    end
    
    %raster
    ripples_selected = ripples_tmp(id_ripples);    
    raster_tsd{p}    = RasterMatrixKJ(MUA, ts(ripples_selected), t_start, t_end, idx_order);
     
    
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




