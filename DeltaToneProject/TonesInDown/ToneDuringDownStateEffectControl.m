%%shamDuringDownStateEffectControl
% 22.03.2018 KJ
%
%
% see
%   shamDuringDownStateEffect shamDuringDownStateRaster
%


clear
Dir = PathForExperimentsBasalSleepSpike;



select_sham = 'inside';

k=0;
for p=[1 3 5 7] %1:length(Dir.path)

    cd(Dir.path{p})

    clearvars -except Dir p d_before d_after d_postdown x_distrib y_distrib select_sham k
    k=k+1;
    
    %load
    load('DownState.mat')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_duration = End(down_PFCx) - Start(down_PFCx);
    nb_down = length(st_down);
    
    
    %% random times
    
    idx = randsample(nb_down, 500);
    sham_tmp = [];
    for i=1:length(idx)
        min_tmp = st_down(idx(i));
        duree = end_down(idx(i))-st_down(idx(i));
        
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end
    sham_tmp = sort(sham_tmp);
    
    
    %% delay

    %delay
    down_rep = repmat(st_down,1,length(sham_tmp));
    end_rep = repmat(end_down,1,length(sham_tmp));
    sham_rep = repmat(sham_tmp,length(st_down),1);
    delay_rep = sham_rep - down_rep;

        
    if strcmpi(select_sham,'inside')
        delay_rep(delay_rep>(end_rep-down_rep))=nan;
        delay_rep(delay_rep<0)=nan;
        x_line = 0;
    elseif strcmpi(select_sham,'before')
        delay_rep(delay_rep<-1000 | delay_rep>0)=nan;
        x_line = 100;
    elseif strcmpi(select_sham,'after')
        delay_rep(delay_rep<(end_rep-down_rep) | delay_rep>(end_rep-down_rep)+1000)=nan;
        x_line = -100;
    end
    
    [delay_shamdown, id_max] = max(delay_rep,[],2);
    
    %ids of events
    idx_down = find(~isnan(delay_shamdown));
    id_sham = id_max(idx_down);
    
    
    for i=1:length(id_sham)
        
        sham_time = sham_tmp(id_sham(i));
        
        iduration(i) = end_down(idx_down(i)) - st_down(idx_down(i));
        ibefore(i) = sham_time - st_down(idx_down(i));
        iafter(i) = end_down(idx_down(i)) - sham_time;
        
        try
            down_after = st_down(find(st_down-end_down(idx_down(i))>0, 1));
            ipostdown(i) = down_after - sham_time;
        catch
            ipostdown(i)=nan;
        end
        
    end
    
    
    %sort
    [s_postdown, idx] = sort(ipostdown);
    s_after           = iafter(idx);
    s_before          = ibefore(idx);
    
    if  strcmpi(select_sham,'after')
%         [s_before, idx] = sort(ibefore);
%         s_after         = iafter(idx);
%         s_postdown      = ipostdown(idx);

        [d_after{k}, idx] = sort(s_after);
        d_before{k}       = s_before(idx);
        d_postdown{k}     = s_postdown(idx);
        
    else
%         [s_after, idx] = sort(iafter);
%         s_before       = ibefore(idx);
%         s_postdown      = ipostdown(idx);

        [d_before{k}, idx] = sort(s_before);
        d_after{k}         = s_after(idx);
        d_postdown{k}      = s_postdown(idx);
    
    end
    
    %distrib
    ratio_shamin = abs(ibefore ./ iafter);
    edges = -5:0.1:5;
    h1 = histogram(ratio_shamin, edges,'Normalization','probability');
    x_distrib{k} = h1.BinEdges(1:end-1);
    y_distrib{k} = h1.Values; close
    
    
    
end



%% Plot
figure, hold on
sz=25;
gap = [0.05 0.03];


for p=1:length(y_distrib)
    
    %fig 1
    subtightplot(2,length(y_distrib),p,gap), hold on
    scatter(-d_before{p}/10,1:length(d_before{p}), sz,'r','filled'), hold on
    scatter(d_after{p}/10,1:length(d_after{p}), sz,'b','filled')
    scatter(d_postdown{p}/10,1:length(d_postdown{p}),sz,[0 0.8 0],'filled')

    xlabel('time relative to sham (ms)'), ylabel('#tones'), xlim([-400 800])
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title(Dir.name{p}),

    %fig 1
    subtightplot(2,length(y_distrib),p+length(y_distrib),gap), hold on
    plot(x_distrib{p}, Smooth(y_distrib{p},1),'linewidth',2), hold on
    xlabel('log(time before/time after)'), ylabel('probability')
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title(Dir.name{p}),
    
end












