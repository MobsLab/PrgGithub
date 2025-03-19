% ParcoursQuantifToneDelayEffect

clear
%% Get data

%exp='DeltaTone';
exp='RdmTone';
tic
Dir=PathForExperimentsDeltaSleepSpikes(exp);

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

lastDelta_delays = [];
lastDown_delays = [];
delta_induced = [];
down_induced = [];

a=0;
for i=1:length(Dir.path)
    a=a+1;
    eval(['cd(Dir.path{',num2str(i),'}'')'])
    disp(pwd)
    disp(num2str(a))
        
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
    load('DeltaSleepEvent.mat', 'TONEtime2_SWS')

    delay = 0; %in 1E-4s
    ToneEvent = Restrict(ts(TONEtime2_SWS + delay),SWSEpoch);
    tone_intv = intervalSet(Range(ToneEvent), Range(ToneEvent) + 3000);  % Tone and its window where an effect could be observed
    nb_tones = length(ToneEvent); 
    
    
    %% Multi-Unit activity and down
    clear T ST Q
    T=PoolNeurons(S,NumNeurons);
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
    Q = Restrict(Q, SWSEpoch);
    %Down
    Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
    down_tmp = Start(Down) + (End(Down)-Start(Down)) / 2;
    start_down = Start(Down);


    %% Signals
    clear distance
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


    %% deltas
    %diff
    thresh_delta = thD * std_diff;
    all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
    DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
    deltas_tmp = Start(DeltaOffline) + (End(DeltaOffline)-Start(DeltaOffline)) / 2;
    start_deltas = Start(DeltaOffline);
    
    
    %% delay
    tones_tmp = Range(ToneEvent);
    %delta
    last_delta_tone = zeros(nb_tones, 1);
    for i=1:nb_tones
        idx_delta_before = find(deltas_tmp < tones_tmp(i), 1, 'last');
        last_delta_tone(i) = tones_tmp(i) - deltas_tmp(idx_delta_before);
    end
    lastDelta_delays = [lastDelta_delays; last_delta_tone];
    
    %down states
    last_down_tone = zeros(nb_tones, 1);
    for i=1:nb_tones
        idx_down_before = find(down_tmp < tones_tmp(i), 1, 'last');
        last_down_tone(i) = tones_tmp(i) - down_tmp(idx_down_before);
    end
    lastDown_delays = [lastDown_delays; last_down_tone];
    
    %% Check if delta or down state after tone
    induce_delta = zeros(nb_tones, 1);
    induce_down = zeros(nb_tones, 1);

    [status,interval,~] = InIntervals(start_deltas, [Start(tone_intv) End(tone_intv)]);
    tone_success = unique(interval);
    induce_delta(tone_success(2:end)) = 1;
    delta_induced = [delta_induced; induce_delta];

    [status,interval,~] = InIntervals(start_down, [Start(tone_intv) End(tone_intv)]);
    tone_success = unique(interval);
    induce_down(tone_success(2:end)) = 1;
    down_induced = [down_induced; induce_down];

end

toc

lastDelta_delays_edge = zeros(length(lastDelta_delays),1);
lastDown_delays_edge = zeros(length(lastDown_delays),1);

edges = 0:2000:5E4;
for i=1:length(edges)
    lastDelta_delays_edge(lastDelta_delays>edges(i)) = edges(i);
    lastDown_delays_edge(lastDown_delays>edges(i)) = edges(i);
end

R_delta = zeros(length(edges),1);
E_delta = zeros(length(edges),1);
R_down = zeros(length(edges),1);
E_down = zeros(length(edges),1);

for i=1:length(edges)
    
    deltas_edge = delta_induced(lastDelta_delays_edge==edges(i));
    R_delta(i) = mean(deltas_edge);
    E_delta(i) = stdError(deltas_edge);
    
    down_edge = down_induced(lastDown_delays_edge==edges(i));
    R_down(i) = mean(down_edge);
    E_down(i) = stdError(down_edge);

end


%plot
figure('Color',[1 1 1]), hold on,

subplot(1,2,1), errorbar(edges,R_delta,E_delta,'+','Color','k'),
hold on, bar(edges,R_delta,'k'), title('delta waves')
hold on, xlim([-1500 edges(end)+1500]), ylim([0 1])

subplot(1,2,2), errorbar(edges,R_down,E_down,'+','Color','k'),
hold on, bar(edges,R_down,'k'), title('down states')
hold on, xlim([-1500 edges(end)+1500]), ylim([0 1])

















