%TestDownDurationEvolution
% 12.04.2018 KJ
%
% evolution of down state density in function of time
%
% see 

clear


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



%% loop
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
        
    
    %% load
    %SWS
    try
        load SleepScoring_Accelero SWSEpoch TotalNoiseEpoch
    catch
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
    end
    
    %down states
    load('DownState.mat','down_PFCx')
    
    %night duration
    load LFPData/LFP0
    night_duration = max(Range(LFP));
    clear LFP
    
    
    %% params       
    windowsize = 60E4; %60s
    intervals_start = 0:windowsize:night_duration;
    
    x_intervals{p} = (intervals_start + windowsize/2)/(3600E4);
    
    
    %% density
    down_duration{p} = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        down_duration{p}(t) = tot_length(and(down_PFCx,intv))/10; %in ms
    end

        
end


%% plot
smoothing = 1;

figure, hold on
for p=1:length(Dir.path)
    down_duration{p} = Smooth(down_duration{p}, smoothing);
    
    subplot(3,2,p),
    plot(x_intervals{p}, down_duration{p},'-','color', 'k', 'Linewidth', 1),
    xlabel('Time(h)'), ylabel('Down duration (ms)');

    title([Dir.name{p} ' - ' Dir.date{p}]),
end







