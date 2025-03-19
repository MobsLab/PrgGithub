% DeltaWavesDensityNights
% 01.02.2017 KJ
%
% plot the evolution of delta density and tones for each night
% 
% 
%   see FrequencyEventsDeltaShamEffect frequency_delta_test 
%

%% Dir

Dir1 = PathForExperimentsDeltaWavesTone('Basal');
for p=1:length(Dir1.path)
    Dir1.delay{p}=0;
end
Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir2,Dir3);
Dir = MergePathForExperiment(Dir1,Dir);

% Dir1 = PathForExperimentsDeltaKJHD('Basal');
% for p=1:length(Dir1.path)
%     Dir1.delay{p}=0;
% end
% Dir2 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir3 = PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir2,Dir3);
% Dir = MergePathForExperiment(Dir1,Dir);

clearvars -except Dir

%% init
Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end

%params
smoothing = 1;
y_rec1 = [0 0 1.5 1.5];
y_rec2 = [0 0 1.5 1.5];


%% loop
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    
    %% load
    load StateEpochSB SWSEpoch
    %Session
    clear sessions
    load IntervalSession
    sessions{1}=Session1;sessions{2}=Session2;sessions{3}=Session3;sessions{4}=Session4;sessions{5}=Session5;
    
    clear DeltaOffline
    %Delta waves
    try
        load DeltaPFCx DeltaOffline
    catch
        load newDeltaPFCx DeltaEpoch
        DeltaOffline = DeltaEpoch;
        clear DeltaEpoch
    end
    start_deltas = ts(Start(DeltaOffline));
    deltas_sws = Restrict(start_deltas,SWSEpoch);
    
    
    %% Epochs
    start_time = TimeDebRec(1,1)*3600 + TimeDebRec(1,2)*60 + TimeDebRec(1,3); %start time in sec
    start_time = start_time*1E4;
    
    windowsize = 60E4; %60s
    night_duration = End(sessions{5});
    intervals_start = 0:windowsize:night_duration;
    
    x_intervals = (intervals_start + windowsize/2 + start_time)/(3600E4);
    x_rec1 = [Start(sessions{2}) End(sessions{2}) End(sessions{2}) Start(sessions{2})];
    x_rec1 = (x_rec1 + start_time)/(3600E4);
    x_rec2 = [Start(sessions{4}) End(sessions{4}) End(sessions{4}) Start(sessions{4})];
    x_rec2 = (x_rec2 + start_time)/(3600E4);
    
    
    %% density
    delta_density_raw = zeros(length(intervals_start),1);
    delta_density_raw_sws = zeros(length(intervals_start),1);
    for i=1:length(intervals_start)
        intv = intervalSet(intervals_start(i),intervals_start(i) + windowsize);
        delta_density_raw(i) = length(Restrict(start_deltas,intv))/60; %per sec
        delta_density_raw_sws(i) = length(Restrict(deltas_sws,intv))/60; %per sec
    end
    
    delta_density = Smooth(delta_density_raw, smoothing);
    delta_density_sws = Smooth(delta_density_raw_sws, smoothing);
 
    %% plot
    figure, hold on
    plot(x_intervals, delta_density,'-','color', 'r', 'Linewidth', 2), hold on
    plot(x_intervals, delta_density_sws,'-','color', 'b', 'Linewidth', 2), hold on
    ylabel('deltas per sec'); set(gca,'Ylim',[0 1.5]);
    xlabel('Time(h)');
    legend('Delta waves', 'Delta SWS')
    hold on, patch(x_rec1, y_rec1, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    hold on, patch(x_rec2, y_rec2, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    title([Dir.name{p} ' - '  Dir.condition{p} ' - ' Dir.date{p}]);
    set(gca, 'XTick',8:20), hold on
    
    
    %% save fig
    %title
    filename_fig = ['Delta_density_time_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
    %save figure
    cd([FolderFigureDelta 'IDfigures/DeltaDensity/'])
    saveas(gcf,filename_png,'png')
    close all
    
end







