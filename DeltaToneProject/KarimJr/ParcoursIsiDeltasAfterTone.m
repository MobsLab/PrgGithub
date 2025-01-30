%ParcoursIsiDeltasAfterTone
a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243';  % 16-04-2015 > random tone effect  - Mouse 243 (delay 200ms!! of M244 detection)
Dir.delay{a}=0.2; Dir.title{a}='Mouse243 - 16042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244';  % 17-04-2015 > random tone effect  - Mouse 244 (delay 200ms!! of M243 detection)
Dir.delay{a}=0.2; Dir.title{a}='Mouse244 - 17042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150603/Breath-Mouse-252-251-03062015/Mouse251';  % 03-06-2015 > random tone effect  - Mouse 251 (delay 140ms!! of M252 detection)
Dir.delay{a}=0.14; Dir.title{a}='Mouse251 - 03062015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150602/Breath-Mouse-251-252-02062015/Mouse252';  % 02-06-2015 > random tone effect  - Mouse 252 (delay 140ms!! of M251 detection)
Dir.delay{a}=0.14; Dir.title{a}='Mouse252 - 02062015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243';  % 17-04-2015 > delay 200ms - Mouse 243
Dir.delay{a}=0.2; Dir.title{a}='Mouse243 - 17042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms - Mouse 244
Dir.delay{a}=0.2; Dir.title{a}='Mouse244 - 16042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150423/Breath-Mouse-243-23042015';               % 23-04-2015 > delay 320ms - Mouse 243
Dir.delay{a}=0.32; Dir.title{a}='Mouse243 - 23042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150424/Breath-Mouse-244-24042015';               % 24-04-2015 > delay 320ms - Mouse 244
Dir.delay{a}=0.32; Dir.title{a}='Mouse244 - 24042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150617/Breath-Mouse-251-17062015';               % 17-06-2015 > delay 320ms - Mouse 251
Dir.delay{a}=0.32; Dir.title{a}='Mouse251 - 17062015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150605/Breath-Mouse-252-05062015';               % 05-06-2015 > delay 320ms - Mouse 252
Dir.delay{a}=0.32; Dir.title{a}='Mouse252 - 05062015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150425/Breath-Mouse-243-25042015';               % 25-04-2015 > delay 480ms - Mouse 243
Dir.delay{a}=0.48; Dir.title{a}='Mouse243 - 25042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';               % 26-04-2015 > delay 480ms - Mouse 244
Dir.delay{a}=0.48; Dir.title{a}='Mouse244 - 26042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150619/Breath-Mouse-251-19062015';               % 09-06-2015 > delay 480ms - Mouse 251
Dir.delay{a}=0.48; Dir.title{a}='Mouse251 - 19062015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150608/Breath-Mouse-252-08062015';               % 08-06-2015 > delay 480ms - Mouse 252
Dir.delay{a}=0.48; Dir.title{a}='Mouse252 - 08062015';


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    
    %load data
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPdeep=LFP;
    clear LFP
    load ChannelsToAnalyse/PFCx_sup
    eval(['load LFPData/LFP',num2str(channel)])
    LFPsup=LFP;
    clear LFP
    clear channel
    load StateEpochSB SWSEpoch Wake
    load SpikeData
    eval('load SpikesToAnalyse/PFCx_Neurons')
    NumNeurons=number;
    clear number
    load('DeltaSleepEvent.mat', 'TONEtime2')

    %params
    freqDelta = [1 6];
    thD = 2;
    thDeep = 2.4;
    minDeltaDuration = 50;
    binsize=10;
    thresh0 = 0.7;
    minDownDur = 100;
    maxDownDur = 500;
    mergeGap = 10; % merge
    predown_size = 50;
    %tones
    delay = Dir.delay{p}*1E4; %in 1E-4s
    ToneEvent = Restrict(ts(TONEtime2 + delay),SWSEpoch);
    nb_tones = length(ToneEvent);

    %% Deltas
    k=1;
    for i=0.1:0.1:4
        distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
        k=k+1;
    end
    Factor=find(distance==min(distance))*0.1;
    EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
    Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
    pos_filtdiff = max(Data(Filt_diff),0);
    std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

    thresh_delta = thD * std_diff;
    all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
    DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
    start_deltas = Start(DeltaOffline);


    %% Multi-Unit activity and down
    T=PoolNeurons(S,NumNeurons);
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
    Q = Restrict(Q, SWSEpoch);
    %Down
    Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
    start_down = Start(Down);


    %% Tones that induces a down or not
    effect_period = 2000; %200ms
    tone_intv = intervalSet(Range(ToneEvent), Range(ToneEvent) + effect_period);  % Tone and its window where an effect could be observed
    induce_down = zeros(nb_tones, 1);

    [status,interval,~] = InIntervals(start_down, [Start(tone_intv) End(tone_intv)]);
    tone_success = unique(interval);
    induce_down(tone_success(2:end)) = 1;  %do not consider the first nul element

    tones = Range(ToneEvent);
    good_tones = tones(induce_down==1);
    bad_tones = tones(induce_down==0);

    intv1_good_tones = zeros(length(good_tones),1);
    intv2_good_tones = zeros(length(good_tones),1);
    for i=1:length(good_tones)
        next_down = start_down(find(start_down>good_tones(i), 3));
        prev_down = start_down(find(start_down<good_tones(i), 1, 'last'));
        try
            intv1_good_tones(i) = next_down(2) - prev_down;
        catch
            intv1_good_tones(i) = 0;
        end
        try
            intv2_good_tones(i) = next_down(3) - prev_down;
        catch
            intv2_good_tones(i) = 0;
        end
    end

    intv1_bad_tones = zeros(length(bad_tones),1);
    intv2_bad_tones = zeros(length(bad_tones),1);
    for i=1:length(bad_tones)
        next_down = start_down(find(start_down>bad_tones(i),2));
        prev_down = start_down(find(start_down<bad_tones(i), 1, 'last'));
        try
            intv1_bad_tones(i) = next_down(1) - prev_down;
        catch
            intv1_bad_tones(i) = 0;
        end
        try
            intv2_bad_tones(i) = next_down(2) - prev_down;
        catch
            intv2_bad_tones(i) = 0;
        end
    end

    %% Same thing with delta
    induce_delta = zeros(nb_tones, 1);
    
    [status,interval,~] = InIntervals(start_deltas, [Start(tone_intv) End(tone_intv)]);
    tone_success = unique(interval);
    induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element
    
    tones = Range(ToneEvent);
    good_tones = tones(induce_delta==1);
    bad_tones = tones(induce_delta==0);
    
    intv1_good_tones_delta = zeros(length(good_tones),1);
    intv2_good_tones_delta = zeros(length(good_tones),1);
    for i=1:length(good_tones)
        next_delta = start_deltas(find(start_deltas>good_tones(i), 3));
        prev_delta = start_deltas(find(start_deltas<good_tones(i), 1, 'last'));
        try
            intv1_good_tones_delta(i) = next_delta(2) - prev_delta;
        catch
            intv1_good_tones_delta(i) = 0;
        end
        try
            intv2_good_tones_delta(i) = next_delta(3) - prev_delta;
        catch
            intv2_good_tones_delta(i) = 0;
        end
    end
    
    intv1_bad_tones_delta = zeros(length(bad_tones),1);
    intv2_bad_tones_delta = zeros(length(bad_tones),1);
    for i=1:length(bad_tones)
        next_delta = start_deltas(find(start_deltas>bad_tones(i),2));
        prev_delta = start_deltas(find(start_deltas<bad_tones(i), 1, 'last'));
        try
            intv1_bad_tones_delta(i) = next_delta(1) - prev_delta;
        catch
            intv1_bad_tones_delta(i) = 0;
        end
        try
            intv2_bad_tones_delta(i) = next_delta(2) - prev_delta;
        catch
            intv2_bad_tones_delta(i) = 0;
        end
    end
    
    % Remove bad values from ISI
    intv1_good_tones(intv1_good_tones==0)=[];
    intv1_bad_tones(intv1_bad_tones==0)=[];
    intv1_good_tones_delta(intv1_good_tones_delta==0)=[];
    intv1_bad_tones_delta(intv1_bad_tones_delta==0)=[];
    intv2_good_tones(intv2_good_tones==0)=[];
    intv2_bad_tones(intv2_bad_tones==0)=[];
    intv2_good_tones_delta(intv2_good_tones_delta==0)=[];
    intv2_bad_tones_delta(intv2_bad_tones_delta==0)=[];
    
    
    %% Distribution plot
    step = 50;
    edges = 0:step:2500;

    %down
    h1 = histogram(intv1_good_tones/10,edges,'Normalization','probability');
    x_h1 = h1.BinEdges(2:end) - step/2;
    y_h1 = h1.Values;
    h2 = histogram(intv1_bad_tones/10,edges,'Normalization','probability');
    x_h2 = h2.BinEdges(2:end) - step/2;
    y_h2 = h2.Values;
    h3 = histogram(intv2_good_tones/10,edges,'Normalization','probability');
    x_h3 = h3.BinEdges(2:end) - step/2;
    y_h3 = h3.Values;
    h4 = histogram(intv2_bad_tones/10,edges,'Normalization','probability');
    x_h4 = h4.BinEdges(2:end) - step/2;
    y_h4 = h4.Values;
    %delta
    h5 = histogram(intv1_good_tones_delta/10,edges,'Normalization','probability');
    x_h5 = h5.BinEdges(2:end) - step/2;
    y_h5 = h5.Values;
    h6 = histogram(intv1_bad_tones_delta/10,edges,'Normalization','probability');
    x_h6 = h6.BinEdges(2:end) - step/2;
    y_h6 = h6.Values;
    h7 = histogram(intv2_good_tones_delta/10,edges,'Normalization','probability');
    x_h7 = h7.BinEdges(2:end) - step/2;
    y_h7 = h7.Values;
    h8 = histogram(intv2_bad_tones_delta/10,edges,'Normalization','probability');
    x_h8 = h8.BinEdges(2:end) - step/2;
    y_h8 = h8.Values;

    figure, hold on
    subplot(2,2,1), plot(x_h1, y_h1, 'color', 'b'), hold on, plot(x_h2, y_h2, 'color', 'r'),
    legend('Effective tones','Not effective tones'), title('down ISI - 1st down'),hold on,
    subplot(2,2,2), plot(x_h3, y_h3, 'color', 'b'), hold on, plot(x_h4, y_h4, 'color', 'r'),
    legend('Effective tones','Not effective tones'), title('down ISI - 2nd down'),hold on,
    subplot(2,2,3), plot(x_h5, y_h5, 'color', 'b'), hold on, plot(x_h6, y_h6, 'color', 'r'),
    legend('Effective tones','Not effective tones'), title('delta ISI - 1st down'),hold on,
    subplot(2,2,4), plot(x_h7, y_h7, 'color', 'b'), hold on, plot(x_h8, y_h8, 'color', 'r'),
    legend('Effective tones','Not effective tones'), title('delta ISI - 2nd down')
    suplabel(Dir.title{p},'t');
    
    %save figure
    cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/KJ/New')
    savefig(['ParcoursIsiDeltasAfterTone' num2str(p)])

    close all

end





