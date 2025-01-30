%TestDeltaDensityThreshDuration
% 20.12.2017 KJ
%
% test the influence of delta minimum duration on density evolution
%
% see 



%% Dir
a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse403/Breath-Mouse-403-09122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep/'; % Mouse 509 - Basal 1 
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse451/Breath-Mouse-451-09122016/';


%% name, manipe, group, date 
for i=1:length(Dir.path)
    %mouse name
    Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'/Mouse'):strfind(Dir.path{i},'/Mouse')+8);
    Dir.name{i}(Dir.name{i}=='-')=[];
    Dir.name{i}(Dir.name{i}=='/')=[];
    
    %date
    ind = strfind(Dir.path{i},'/201');
    Dir.date{i} = Dir.path{i}(ind + [7 8 5 6 1:4]);
end



%% loop and plot
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    %params
    thresh_duration{1} = [50 75];
    thresh_duration{2} = [75 100];
    thresh_duration{3} = [100 150];
    thresh_duration{4} = [150 200];
    thresh_duration{5} = [200 300];
    thresh_duration{6} = [300 1000];
    
    
    %% load
    %SWS
    try
        load SleepScoring_Accelero SWSEpoch TotalNoiseEpoch
    catch
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
    end
        
    %deep
    try
        load('ChannelsToAnalyse/PFCx_deltadeep');
    catch
        load('ChannelsToAnalyse/PFCx_deep');
    end    
    eval(['load LFPData/LFP',num2str(channel)])
    LFPdeep=LFP;
    %sup
    try
        load('ChannelsToAnalyse/PFCx_deltasup');
    catch
        load('ChannelsToAnalyse/PFCx_sup');
    end
    eval(['load LFPData/LFP',num2str(channel)])
    LFPsup=LFP;
    
    clear LFP channel
    
    
    %% params    
    freq_delta = [1 6];
    thresh_std = 2;
    
    smoothing = 1;
    windowsize = 60E4; %60s
    night_duration = max(Range(LFPsup));
    intervals_start = 0:windowsize:night_duration;
    
    x_intervals = (intervals_start + windowsize/2)/(3600E4);
    
    
    %% detect delta waves
    %normalize
    clear distance
    k=1;
    for i=0.1:0.1:4
        distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
        k=k+1;
    end
    Factor = find(distance==min(distance))*0.1;
    %resample & filter & positive value
    EEGsleepDiff = ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
    Filt_diff = FilterLFP(EEGsleepDiff, freq_delta, 1024);
    pos_filtdiff = max(Data(Filt_diff),0);
    %threshold
    std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds
    thresh_delta = thresh_std * std_diff;
    
    %detection
    all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');

    %start deltas of various durations, restrict to SWS    
    for i=1:length(thresh_duration)
        min_dur = thresh_duration{i}(1) * 10;
        max_dur = thresh_duration{i}(2) * 10;
        DeltaEpochs = dropLongIntervals(dropShortIntervals(all_cross_thresh, min_dur), max_dur);
        start_deltas{i} = Restrict(ts(Start(DeltaEpochs)),SWSEpoch);
    end
    
    
    %% density
    
    for i=1:length(thresh_duration)
        density_deltas{i} = zeros(length(intervals_start),1);
        for t=1:length(intervals_start)
            intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
            density_deltas{i}(t) = length(Restrict(start_deltas{i},intv))/60; %per sec
        end
        %smooth
        density_deltas{i} = Smooth(density_deltas{i}, smoothing);
    end

 
    %% plot
    figure, hold on
    for i=1:length(thresh_duration)
        subplot(3,2,i),
        plot(x_intervals, density_deltas{i},'-','color', 'k', 'Linewidth', 1),
        xlabel('Time(h)'), ylabel('deltas per sec');
        
        min_dur = thresh_duration{i}(1);
        max_dur = thresh_duration{i}(2);
        title([num2str(min_dur) ' - ' num2str(max_dur) ' ms']),
    end
    
    suplabel([Dir.name{p} ' - ' Dir.date{p}], 't');
    
    
end

