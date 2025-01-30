%%NoToneDuringDownStateEffect
% 04.04.2018 KJ
%
%
% see
%   ToneDuringDownStateRaster ToneDuringDownStateEffect
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);

select_tone = 'inside';

for p=1:length(Dir.path)

    cd(Dir.path{p})

    clearvars -except Dir p d_before d_after d_postdown x_distrib y_distrib select_tone
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx','binsize',2); %2mS
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', 40,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 20, 'method', 'mono');
    
%     load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_duration = End(down_PFCx) - Start(down_PFCx);

    %Substages
    if exist('SleepSubstages.mat','file')==2
        load('SleepSubstages.mat', 'Epoch', 'NameEpoch')
        Substages = Epoch([1:5 7]);
        NamesSubstages = NameEpoch([1:5 7]);
    else
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
        [Substages,NamesSubstages]=DefineSubStages(op,noise);
    end

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);
    nb_tones = length(tones_tmp);
    
    
    %% find down with no tone around
    TonesPeriod = intervalSet(tones_tmp-4e4, tones_tmp+4e4);
    TonesPeriod = mergeCloseIntervals(TonesPeriod,10e4);
    
    %Down with or without
    intv_tonesperiod = [Start(TonesPeriod) End(TonesPeriod)];
    [status, ~,~] = InIntervals(st_down, intv_tonesperiod);
    new_stdown = st_down(status==0);
    new_endown = end_down(status==0);
    
    
    %% random times
    
    idx = randsample(length(new_stdown), 1500);
    sham_tmp = [];
    for i=1:length(idx)
        min_tmp = new_stdown(idx(i));
        duree(i) = new_endown(idx(i))-new_stdown(idx(i));
        
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree(i)];
    end
    sham_tmp = sort(sham_tmp);

    
    %% delay
    for i=1:length(sham_tmp)
        st_bef = st_down(find(st_down<sham_tmp(i),1,'last'));
        ibefore(i) = sham_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>sham_tmp(i),1));
        iafter(i) = end_aft - sham_tmp(i);
        
        down_after = st_down(find(st_down>end_aft, 1));
        ipostdown(i) = down_after - sham_time;
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
    ratio_tonein = abs(ibefore ./ iafter);
    edges = -5:0.1:5;
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

    xlabel('time relative to sham (ms)'), ylabel('#tones'), xlim([-400 800])
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title([Dir.name{p} '-' Dir.date{p} ' (' Dir.manipe{p} ')']),

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

    xlabel('time relative to sham (ms)'), ylabel('#tones'), xlim([-400 800])
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title([Dir.name{p} '-' Dir.date{p} ' (' Dir.manipe{p} ')']),

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

    xlabel('time relative to sham (ms)'), ylabel('#tones'), xlim([-400 800])
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    title([Dir.name{p} '-' Dir.date{p} ' (' Dir.manipe{p} ')']),

    %fig 1
    subtightplot(2,3,3+3*k,gap), hold on
    plot(x_distrib{p}, Smooth(y_distrib{p},1),'linewidth',2), hold on
    xlabel('log(time before/time after)'), ylabel('probability')
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    
    k=k+1;
    
end



%     %Substages
%     clear op noise
%     load NREMepochsML.mat op noise
%     if ~isempty(op)
%         disp('Loading epochs from NREMepochsML.m')
%     else
%         clear op NamesOp Dpfc Epoch noise
%         load NREMepochsML_old.mat op noise
%         disp('Loading epochs from NREMepochsML.m')
%     end
%     [Substages,NamesSubstages]=DefineSubStages(op,noise);
% 
% 



% 
%     %% Delay
% 
%     %range delay
% 
%     range_delay = -3e4:500:4000;
%     x=(range_delay(2:end)+range_delay(1:end-1))/2;
% 
%     down_dur = down_duration;
%     %clean
%     cond = isnan(delay_tonedown) | delay_tonedown<-5e4;
%     down_dur(cond) = [];
%     delay_tonedown(cond) = [];
% 
% 
%     for i=1:length(range_delay)-1
%         cond = delay_tonedown>range_delay(i) & delay_tonedown<=range_delay(i+1);
%         downdur_b{i} =  down_dur(cond)/10;
%         delay_b{i} =  delay_tonedown(cond)/10;
% 
%         labels{i} = [num2str(range_delay(i)/10) '-' num2str(range_delay(i+1)/10) ' ms']; 
% 
%     end
% 
% 
%     %plot
%     subplot(2,1,p), hold on
%     scatter(delay_tonedown/10, down_dur/10,25,'filled')
%     PlotErrorLineN_KJ(downdur_b, 'x_data',x/10, 'newfig',0,'errorbars',1);
%     xlabel('Delay down - tone (ms)'), ylabel('down durations')
%     title([Dir.name{p} ' - ' Dir.date{p} ' - Random Tone'])
%     
    




