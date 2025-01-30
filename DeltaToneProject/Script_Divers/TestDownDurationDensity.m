%TestDownDurationDensity
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
    
    %params
    down_duration{1} = [75 100];
    down_duration{2} = [100 150];
    down_duration{3} = [150 200];
    down_duration{4} = [200 250];
    down_duration{5} = [250 400];
    down_duration{6} = [75 1000];
    
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
    load LFPData/LFP0
    night_duration = max(Range(LFP));
    clear LFP
    
    
    %% params       
    smoothing = 3;
    windowsize = 60E4; %60s
    intervals_start = 0:windowsize:night_duration;
    
    x_intervals = (intervals_start + windowsize/2)/(3600E4);
    
    
    %% evolution

    %start deltas of various durations, restrict to SWS    
    for i=1:length(down_duration)
        min_dur = down_duration{i}(1) * 10;
        max_dur = down_duration{i}(2) * 10;
        DownDur = dropLongIntervals(dropShortIntervals(down_PFCx, min_dur), max_dur);
        start_down{i} = Restrict(ts(Start(DownDur)),SWSEpoch);
    end
    
    
    %% density
    
    for i=1:length(down_duration)
        density_down{i} = zeros(length(intervals_start),1);
        for t=1:length(intervals_start)
            intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
            density_down{i}(t) = length(Restrict(start_down{i},intv))/60; %per sec
        end
        %smooth
        smooth_density{i} = Smooth(density_down{i}, smoothing);
        
        %regression
        idx_down = smooth_density{i} > max(smooth_density{i})/8;
        [p_multi,~] = polyfit(x_intervals(idx_down), smooth_density{i}(idx_down)', 1);
        reg_down{i} = polyval(p_multi,x_intervals);
    end
    
    
 
    %% plot
    figure, hold on
    for i=1:length(down_duration)
        subplot(3,2,i),
        plot(x_intervals, density_down{i},'-','color', 'k', 'Linewidth', 1), hold on
        plot(x_intervals, smooth_density{i},'-','color', 'r', 'Linewidth', 1), hold on
        plot(x_intervals, reg_down{i}, 'color', 'b'), hold on
        xlabel('Time(h)'), ylabel('down per sec');
        
        min_dur = down_duration{i}(1);
        max_dur = down_duration{i}(2);
        title([num2str(min_dur) ' - ' num2str(max_dur) ' ms']),
    end
        
%     %title
%     foldername = '/home/mobsjunior/Dropbox/Mobs_member/KarimJr/Projet_Delta/Figures_DeltaFeedback/BasalDataset/DownDurationHomeostasis/';
%     title_fig = [Dir.name{p}  ' - ' Dir.date{p}];
%     filename_fig = ['DownDurHomeostasis_' Dir.name{p}  '_' Dir.date{p}];
%     filename_png = [filename_fig  '.png'];
%     % suptitle
%     suplabel(title_fig,'t');
%     %save figure
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     filename_png = fullfile(FolderFigureDelta,'BasalDataset', 'DownDurationHomeostasis',filename_png);
%     saveas(gcf,filename_png,'png')
%     close all
    
    
end

