% FigureExampleDensityNights
% 16.02.2017 KJ
%
% plot the evolution of delta density and tones for some nights
% 
% 
%   see DeltaWavesDensityNights 
%


%% Dir
a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice293-294-296/20151211/Mouse296/Breath-Mouse-296-11122015'; % Mouse 296 - Day 4
Dir.condition{a}='Basal';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243'; % 16-04-2015 > random tone effect  - Mouse 243 (delay 200ms!! of M244 detection)
Dir.condition{a}='RdmTone';

a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244'; % Mouse 244 - Day 5
Dir.condition{a}='Basal';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';               % 26-04-2015 > delay 490ms - Mouse 244
Dir.condition{a}='Tone 490ms';
    
% names and dates
for i=1:length(Dir.path)
    if Dir.path{i}(end-8)=='/'
    Dir.name{i}=Dir.path{i}(end-7:end);
    else
    Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'Mouse'):strfind(Dir.path{i},'Mouse')+8);
    Dir.name{i}(Dir.name{i}=='-')=[];
    Dir.name{i}(Dir.name{i}=='/')=[];
    end
    ind=strfind(Dir.path{i},'2015');
    if isempty(ind)
        ind=strfind(Dir.path{i},'2016');
    end
    if isempty(ind)
        ind=strfind(Dir.path{i},'2017');
    end
    Dir.date{i} = Dir.path{i}(ind(end)-4:ind(end)+3);
end  


clearvars -except Dir

%% params
smoothing = 1;
y_rec1 = [0 0 1.5 1.5];
y_rec2 = [0 0 1.5 1.5];



%% Plot
figure, hold on

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
    
    %delta_density = Smooth(delta_density_raw, smoothing);
    delta_density_sws = Smooth(delta_density_raw_sws, smoothing);
 
    %% plot
    subplot(2,2,p), hold on
    %plot(x_intervals, delta_density,'-','color', 'r', 'Linewidth', 2), hold on
    plot(x_intervals, delta_density_sws,'-','color', 'b', 'Linewidth', 2), hold on
    ylabel('deltas per sec'); set(gca,'Ylim',[0 1.5]);
    xlabel('Time(h)');
    legend('Delta waves')
    hold on, patch(x_rec1, y_rec1, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    hold on, patch(x_rec2, y_rec2, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    title([Dir.name{p} ' - '  Dir.condition{p} ' - ' Dir.date{p}]);
    set(gca, 'XTick',8:20), hold on
    
end

suplabel('Delta waves density','t');










