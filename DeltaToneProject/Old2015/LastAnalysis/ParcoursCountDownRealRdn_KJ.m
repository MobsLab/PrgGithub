%ParcoursCountDownRealRdn_KJ

%Plot number of neuronal silence among records and comparable simulations.
%To detect downstate, it uses FindDown2_KJ


clear

%prefix = '/home/karim/Documents/'; 
prefix = '/Volumes/';

%% Path
a=0;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244']; % Mouse 244 - Day 1
Dir.mouse{a}=244;

a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse243']; % Mouse 243 - Day 2
Dir.mouse{a}=243;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244']; % Mouse 244 - Day 2
Dir.mouse{a}=244;

a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243']; % Mouse 243 - Day 3
Dir.mouse{a}=243;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244']; % Mouse 244 - Day 3    
Dir.mouse{a}=244;

a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243']; % Mouse 243 - Day 4
Dir.mouse{a}=243;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244']; % Mouse 244 - Day 4
Dir.mouse{a}=244;

a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243']; % Mouse 243 - Day 5
Dir.mouse{a}=243;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244']; % Mouse 244 - Day 5
Dir.mouse{a}=244;

nb_records = a;

% params
delta = 10; % simulation step size in ms
minDurBins = 0:10:1500; % minimum duration bins for downstates
thresh0 = 0.9;
thresh1 = 1.1;

binsiz = 10; % in ms
minDownDur = 0;
maxDownDur = 1000;
mergeGap = 0; % duration max to allow a merge of silence period

% Selected Mice
selected_mice = [243 244];

ncol = ceil(a / 2);
figure, hold on
% Loop over all experiments
for manip=1:length(Dir.path)
    %current folder with experiment data
    if ~ismember(Dir.mouse{manip}, selected_mice)
       continue 
    end
    disp('  ')
    disp(Dir.path{manip})
    disp(' ')
    cd(Dir.path{manip})
    tit = Dir.path{manip};

    %Load data
    load SpikeData
    eval('load SpikesToAnalyse/PFCx_Neurons')
    NumNeurons=number;
    clear number
    load StateEpochSB SWSEpoch Wake
    
    % Total durations of Epochs
    DurationSWS=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
    DurationWake=sum(End((Wake),'s')-Start((Wake),'s'));
    

    % Mean firing rates
    bin_size = 10; %10ms
    Q = MakeQfromS(S(NumNeurons), bin_size * 10);
    firingRates_sws = mean(full(Data(Restrict(Q, SWSEpoch))), 1); % firing rate for a bin of 10ms
    firingRates_wake = mean(full(Data(Restrict(Q, Wake))), 1);

    % generation of random spikes: poisson process
    Nsws = floor(DurationSWS * 1E3 / delta); % number of steps
    Nwake = floor(DurationWake * 1E3 / delta);
    % SWS and Wake
    nb_neuron = length(NumNeurons);
    spikes_sws = zeros(Nsws, nb_neuron);
    spikes_wake = zeros(Nwake, nb_neuron);
    for i=1:nb_neuron
        lambda = firingRates_sws(i); % firing rate for a bin of 10ms
        spikes_sws(:,i) = poissrnd(lambda,Nsws,1);
        lambda = firingRates_wake(i);
        spikes_wake(:,i) = poissrnd(lambda,Nwake,1);
    end

    mua_sws = sum(spikes_sws, 2);
    mua_wake = sum(spikes_wake, 2);

    tmp_tsd = (1:length(mua_sws)) * 100;  % E-4s
    QswsRd = tsd(tmp_tsd,mua_sws);
    tmp_tsd = (1:length(mua_wake)) * 100;  % E-4s
    QwakeRd = tsd(tmp_tsd,mua_wake);

    % Get real spikes
    binsize=100; % binsize in E-4s, for MUA
    merge_thresh = 200; % 20ms
    T=PoolNeurons(S,NumNeurons);
    clear ST
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    Q=MakeQfromS(ST,binsize);
    Qsws = Restrict(Q, SWSEpoch);
    Qwake = Restrict(Q, Wake);
    
    % Simulated data
    DownSwsS = FindDown2_KJ(QswsRd, thresh0, thresh1, minDownDur,maxDownDur, mergeGap);
    downSwsS_dur = (End(DownSwsS) - Start(DownSwsS)) / 10; %in ms
    DownWakeS = FindDown2_KJ(QwakeRd, thresh0, thresh1, minDownDur,maxDownDur, mergeGap);
    downWakeS_dur = (End(DownWakeS) - Start(DownWakeS)) / 10; %in ms

    nbDownSWS_sim = zeros(1, length(minDurBins));
    nbDownWake_sim = zeros(1, length(minDurBins));
    for j=1:length(minDurBins)
        bmin = minDurBins(j);
        nbDownSWS_sim(j) = sum(downSwsS_dur>bmin);
        nbDownWake_sim(j) = sum(downWakeS_dur>bmin);
    end


    % Real data
    DownSws = FindDown2_KJ(Qsws, thresh0, thresh1, minDownDur,maxDownDur, mergeGap);
    downSws_dur = (End(DownSws) - Start(DownSws)) / 10;
    DownWake = FindDown2_KJ(Qwake, thresh0, thresh1, minDownDur,maxDownDur, mergeGap);
    downWake_dur = (End(DownWake) - Start(DownWake)) / 10;

    nbDownSWS_data = zeros(1, length(minDurBins));
    nbDownWake_data = zeros(1, length(minDurBins));
    for j=1:length(minDurBins)
        bmin = minDurBins(j);
        nbDownSWS_data(j) = sum(downSws_dur>bmin);
        nbDownWake_data(j) = sum(downWake_dur>bmin);
    end
    
    
    %% plot
    hourSws = DurationSWS / 3600;
    hourWake = DurationWake / 3600;

    
    subplot(2, ncol, manip), hold on
    hold on, plot(minDurBins, nbDownSWS_sim / hourSws,'b')
    hold on, plot(minDurBins, nbDownWake_sim / hourWake,'y')
    hold on, plot(minDurBins, nbDownSWS_data / hourSws,'r')
    hold on, plot(minDurBins, nbDownWake_data / hourWake,'k')
    hold on, set(gca,'xscale','log')
    hold on, set(gca,'yscale','log')
    hold on, set(gca,'xtick',[10 50 100 200 500 1500])
    hold on, legend('SIM sws','SIM wake','SWS','Wake')
    hold on, title(tit(end-16:end))
    
end  

