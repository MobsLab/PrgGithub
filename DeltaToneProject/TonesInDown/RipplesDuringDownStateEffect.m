%%RipplesDuringDownStateEffect
% 29.03.2018 KJ
%
%
% see
%   ToneDuringDownStateRaster ToneDuringDownStateEffectControl
%


clear


a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243'; % 16-04-2015 > random tone effect  - Mouse 243 (delay 200ms!! of M244 detection)
Dir.delay{a}=0.2; Dir.name{a}='Mouse243'; Dir.date{a}='16042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244'; % 17-04-2015 > random tone effect  - Mouse 244 (delay 200ms!! of M243 detection)
Dir.delay{a}=0.2; Dir.name{a}='Mouse244'; Dir.date{a}='17042015';


select_tone = 'after';

for p=1:length(Dir.path)

    cd(Dir.path{p})

    clearvars -except Dir p d_before d_after d_postdown x_distrib y_distrib select_tone
    
    %load
    load('DownState.mat')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_duration = End(down_PFCx) - Start(down_PFCx);

    %ripples
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10;

    
    %% delay

    %delay
    down_rep    = repmat(st_down,1,length(ripples_tmp));
    end_rep     = repmat(end_down,1,length(ripples_tmp));
    ripples_rep = repmat(ripples_tmp',length(st_down),1);

    delay_rep = ripples_rep - down_rep;
    
        
    if strcmpi(select_tone,'inside')
        delay_rep(delay_rep>(end_rep-down_rep))=nan;
        delay_rep(delay_rep<0)=nan;
        x_line = 0;
    elseif strcmpi(select_tone,'before')
        delay_rep(delay_rep<-1000 | delay_rep>0)=nan;
        x_line = 100;
    elseif strcmpi(select_tone,'after')
        delay_rep(delay_rep<(end_rep-down_rep) | delay_rep>(end_rep-down_rep)+1000)=nan;
        x_line = -100;
    end
    
    [delay_ripdown, id_max] = max(delay_rep,[],2);
    
    %ids of events
    idx_down = find(~isnan(delay_ripdown));
    id_ripples = id_max(idx_down);
    
    
    for i=1:length(id_ripples)
        
        tone_time = ripples_tmp(id_ripples(i));;
        
        iduration(i) = end_down(idx_down(i)) - st_down(idx_down(i));
        ibefore(i) = tone_time - st_down(idx_down(i));
        iafter(i) = end_down(idx_down(i)) - tone_time;
        
        down_after = st_down(find(st_down-end_down(idx_down(i))>0, 1));
        ipostdown(i) = down_after - tone_time;
        
        
    end
    
    
    %sort
    [s_postdown, idx] = sort(ipostdown);
    s_after           = iafter(idx);
    s_before          = ibefore(idx);
    
    if  strcmpi(select_tone,'after')
%         [s_before, idx] = sort(ibefore);
%         s_after         = iafter(idx);
%         s_postdown      = ipostdown(idx);

        [d_after{p}, idx] = sort(s_after);
        d_before{p}       = s_before(idx);
        d_postdown{p}     = s_postdown(idx);
        
    else
%         [s_after, idx] = sort(iafter);
%         s_before       = ibefore(idx);
%         s_postdown      = ipostdown(idx);

        [d_before{p}, idx] = sort(s_before);
        d_after{p}         = s_after(idx);
        d_postdown{p}      = s_postdown(idx);
    
    end
    
    %distrib
    ratio_ripplesin = abs(ibefore ./ iafter);
    edges = -5:0.1:5;
    h1 = histogram(ratio_ripplesin, edges,'Normalization','probability');
    x_distrib{p} = h1.BinEdges(1:end-1);
    y_distrib{p} = h1.Values; close
    
    
    
    
end



%% Plot
figure, hold on
sz=25;
gap = [0.1 0.06];


for p=1:length(Dir.path)
    
    %fig 1
    subtightplot(2,3,(1:2)+3*(p-1),gap), hold on
    scatter(-d_before{p}/10,1:length(d_before{p}), sz,'r','filled'), hold on
    scatter(d_after{p}/10,1:length(d_after{p}), sz,'b','filled')
    scatter(d_postdown{p}/10,1:length(d_postdown{p}),sz,[0 0.8 0],'filled')

    xlabel('time relative to ripples (ms)'), ylabel('#ripples'), xlim([-400 800])
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title(Dir.name{p}),

    %fig 1
    subtightplot(2,3,3+3*(p-1),gap), hold on
    plot(x_distrib{p}, Smooth(y_distrib{p},1),'linewidth',2), hold on
    xlabel('log(time before/time after)'), ylabel('probability')
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title(Dir.name{p}),
    
end







