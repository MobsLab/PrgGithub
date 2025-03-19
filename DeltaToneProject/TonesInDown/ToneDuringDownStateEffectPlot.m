%%ToneDuringDownStateEffectPlot
% 06.04.2018 KJ
%
% effect of tones around down states
%
%   see 
%       ToneDuringDownStateEffect
%

%load
clear
load(fullfile(FolderDeltaDataKJ,'ToneDuringDownStateEffect.mat'))

%{'inside', 'before', 'after'}
select_tone = 'inside'; 

% {'after','post','before'};
select_order = 'before';


%% sort data
for p=1:length(tones_res.path)
    
    ibefore   = tones_res.(select_tone).ibefore{p};
    iafter    = tones_res.(select_tone).iafter{p};
    ipostdown = tones_res.(select_tone).ipostdown{p};
    
    if  strcmpi(select_order,'before')
        [d_before{p}, idx] = sort(ibefore);
        d_after{p}         = iafter(idx);
        d_postdown{p}      = ipostdown(idx);
    
    elseif  strcmpi(select_order,'after')
        [d_after{p}, idx] = sort(iafter);
        d_before{p}       = ibefore(idx);
        d_postdown{p}     = ipostdown(idx);
        
    elseif  strcmpi(select_order,'post')
        [d_postdown{p} , idx] = sort(ipostdown);
        d_after{p}            = iafter(idx);
        d_before{p}           = ibefore(idx);
    end
    
    
    %distrib
    ratio_tonein = abs(ibefore ./ iafter);
    edges = -3:0.1:8;
    [y_distrib{p}, x_distrib{p}] = histcounts(ratio_tonein, edges,'Normalization','probability');
    x_distrib{p}= x_distrib{p}(1:end-1) + diff(x_distrib{p});
    

end

    
    




%% Plot
figure, hold on
sz=25;
gap = [0.1 0.06];

k=0;
for p=1:2
    %fig 1
    subtightplot(2,3,(1:2)+3*k,gap), hold on
    scatter(-d_before{p}/10,1:length(d_before{p}), sz,'r','filled'), hold on
    scatter(d_after{p}/10,1:length(d_after{p}), sz,'b','filled')
    scatter(d_postdown{p}/10,1:length(d_postdown{p}),sz,[0 0.8 0],'filled')

    xlabel('time relative to tones (ms)'), ylabel('#tones'), xlim([-400 800])
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title([tones_res.name{p} '-' tones_res.date{p} ' (' tones_res.manipe{p} ')']),

    %fig 1
    subtightplot(2,3,3+3*k,gap), hold on
    plot(x_distrib{p}, Smooth(y_distrib{p},1),'linewidth',2), hold on
    xlabel('log(time before/time after)'), ylabel('probability')
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    
    k=k+1;
    
end


figure, hold on
sz=25;
gap = [0.1 0.06];

k=0;
for p=3:4
    %fig 1
    subtightplot(2,3,(1:2)+3*k,gap), hold on
    scatter(-d_before{p}/10,1:length(d_before{p}), sz,'r','filled'), hold on
    scatter(d_after{p}/10,1:length(d_after{p}), sz,'b','filled')
    scatter(d_postdown{p}/10,1:length(d_postdown{p}),sz,[0 0.8 0],'filled')

    xlabel('time relative to tones (ms)'), ylabel('#tones'), xlim([-400 800])
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title([tones_res.name{p} '-' tones_res.date{p} ' (' tones_res.manipe{p} ')']),

    %fig 1
    subtightplot(2,3,3+3*k,gap), hold on
    plot(x_distrib{p}, Smooth(y_distrib{p},1),'linewidth',2), hold on
    xlabel('log(time before/time after)'), ylabel('probability')
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    
    k=k+1;
    
end


figure, hold on
sz=25;
gap = [0.1 0.06];

k=0;
for p=5:6
    %fig 1
    subtightplot(2,3,(1:2)+3*k,gap), hold on
    scatter(-d_before{p}/10,1:length(d_before{p}), sz,'r','filled'), hold on
    scatter(d_after{p}/10,1:length(d_after{p}), sz,'b','filled')
    scatter(d_postdown{p}/10,1:length(d_postdown{p}),sz,[0 0.8 0],'filled')

    xlabel('time relative to tones (ms)'), ylabel('#tones'), xlim([-400 800])
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title([tones_res.name{p} '-' tones_res.date{p} ' (' tones_res.manipe{p} ')']),

    %fig 1
    subtightplot(2,3,3+3*k,gap), hold on
    plot(x_distrib{p}, Smooth(y_distrib{p},1),'linewidth',2), hold on
    xlabel('log(time before/time after)'), ylabel('probability')
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    
    k=k+1;
    
end


