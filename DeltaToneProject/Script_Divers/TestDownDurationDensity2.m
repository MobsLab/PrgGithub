%TestDownDurationDensity2
% 22.12.2017 KJ
%
% evolution of down state density in function of time
%
% see 



%% Dir
a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20161209/Mouse403/Breath-Mouse-403-09122016/';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/'; % Mouse 508 - Basal 1 
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

Dir = PathForExperimentsBasalSleepSpike;


%% loop and plot
for p=1%:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
%     %params
%     down_duration{1} = [75 100];
%     down_duration{2} = [100 150];
%     down_duration{3} = [150 200];
%     down_duration{4} = [200 250];
%     down_duration{5} = [250 400];
%     down_duration{6} = [75 1000];
    
    %% load
    %SWS
    try
        load SleepScoring_Accelero SWSEpoch TotalNoiseEpoch
    catch
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
    end
    
    %down states
    load('DownState.mat','down_PFCx')
    load('DeltaWaves.mat', 'deltas_PFCx')
    
    %night duration
%     load LFPData/LFP0
%     night_duration = max(Range(LFP));
%     clear LFP
    load('IdFigureData2.mat', 'night_duration')
    
    %% params       
    smoothing = 3;
    windowsize = 60E4; %60s
    intervals_start = 0:windowsize:night_duration;
    
    x_intervals = (intervals_start + windowsize/2)/(3600E4);
    
    
    %% down
    start_down = ts(Start(down_PFCx));
    density_down = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        density_down(t) = length(Restrict(start_down,intv))/60; %per sec
    end
    %smooth
    smooth_down = Smooth(density_down, smoothing);

    %regression
    idx_down = smooth_down > max(smooth_down)/8;
    [p_down,~] = polyfit(x_intervals(idx_down), smooth_down(idx_down)', 1);
    reg_down = polyval(p_down,x_intervals);
    
    
    %% delta >50ms
    
    start_delta1 = ts(Start(deltas_PFCx));
    density_delta1 = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        density_delta1(t) = length(Restrict(start_delta1,intv))/60; %per sec
    end
    %smooth
    smooth_delta1 = Smooth(density_delta1, smoothing);

    %regression
    idx_delta1 = smooth_delta1 > max(smooth_delta1)/8;
    [p_delta1,~] = polyfit(x_intervals(idx_delta1), smooth_delta1(idx_delta1)', 1);
    reg_delta1 = polyval(p_delta1,x_intervals);
    
    
     %% delta >75ms
    
    start_delta2 = ts(Start(dropShortIntervals(deltas_PFCx,750)));
    density_delta2 = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        density_delta2(t) = length(Restrict(start_delta2,intv))/60; %per sec
    end
    %smooth
    smooth_delta2 = Smooth(density_delta2, smoothing);

    %regression
    idx_delta2 = smooth_delta2 > max(smooth_delta2)/8;
    [p_delta2,~] = polyfit(x_intervals(idx_delta2), smooth_delta2(idx_delta2)', 1);
    reg_delta2 = polyval(p_delta2,x_intervals);
    
    %% delta >75ms
    
    deltaShort = dropLongIntervals(dropShortIntervals(deltas_PFCx,500),750);
    
    start_delta3 = ts(Start(deltaShort));
    density_delta3 = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        density_delta3(t) = length(Restrict(start_delta3,intv))/60; %per sec
    end
    %smooth
    smooth_delta3 = Smooth(density_delta3, smoothing);

    %regression
    idx_delta3 = smooth_delta3 > max(smooth_delta3)/8;
    [p_delta3,~] = polyfit(x_intervals(idx_delta3), smooth_delta3(idx_delta3)', 1);
    reg_delta3 = polyval(p_delta3,x_intervals);
    
 
    %% plot
    figure, hold on
    subplot(4,1,1), hold on
    plot(x_intervals, density_down,'-','color', 'k', 'Linewidth', 1), hold on
    plot(x_intervals, smooth_down,'-','color', 'r', 'Linewidth', 1), hold on
    plot(x_intervals, reg_down, 'color', 'b'), hold on
    idx_down
    scatter(x_intervals(idx_down), smooth_down(idx_down)',20, 'g');
    
    xlabel('Time(h)'), ylabel('per sec');
    title('down states'),
    
    subplot(4,1,2), hold on
    plot(x_intervals, density_delta1,'-','color', 'k', 'Linewidth', 1), hold on
    plot(x_intervals, smooth_delta1,'-','color', 'r', 'Linewidth', 1), hold on
    plot(x_intervals, reg_delta1, 'color', 'b'), hold on
    scatter(x_intervals(idx_delta1), smooth_delta2(idx_delta1)',20, 'g');
    xlabel('Time(h)'), ylabel('per sec');
    title('delta waves >50ms')
    
    subplot(4,1,3), hold on
    plot(x_intervals, density_delta2,'-','color', 'k', 'Linewidth', 1), hold on
    plot(x_intervals, smooth_delta2,'-','color', 'r', 'Linewidth', 1), hold on
    plot(x_intervals, reg_delta2, 'color', 'b'), hold on
    scatter(x_intervals(idx_delta2), smooth_delta2(idx_delta2)',20, 'g');
    xlabel('Time(h)'), ylabel('per sec');
    title('delta waves >75ms')
    
    subplot(4,1,4), hold on
    plot(x_intervals, density_delta3,'-','color', 'k', 'Linewidth', 1), hold on
    plot(x_intervals, smooth_delta3,'-','color', 'r', 'Linewidth', 1), hold on
    plot(x_intervals, reg_delta3, 'color', 'b'), hold on
    scatter(x_intervals(idx_delta3), smooth_delta3(idx_delta3)',20, 'g');
    xlabel('Time(h)'), ylabel('per sec');
    title('delta waves [50-75ms]')
    
    
end

