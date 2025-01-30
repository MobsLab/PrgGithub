% StimImpactSlowWavesThresholdAnalysis3
% 01.04.2018 KJ
%
% Infos
%    
%
% see
%    StimImpactSlowWavesThresholdAnalysis  StimImpactSlowWavesThresholdAnalysis2
%


clear
load(fullfile(FolderStimImpactData,'StimImpactSlowWavesThresholdAnalysis.mat'));


%params density
binsize_density = 60E4; %60s
windowsize = 60e4; %60s
%params isi
step=100;
edges=0:step:5000;

gap = [0.02 0.02];

for p=6%1:length(thres_res.filereference)
    
    
    %% night duration and intervals
    StageEpochs = thres_res.dreemnogram{p};
    for st=1:length(StageEpochs)
        try
            endst(st) = max(End(StageEpochs{st})); 
        catch
            endst(st) = nan;
        end
    end
    night_duration = max(endst);

    %intervals
    intervals_start = 0:windowsize:night_duration;    
    x_intervals = (intervals_start + windowsize/2)/(3600E4);
    
    %% EEG
    std_eeg     = thres_res.std_eeg{p}{1};
    distrib_eeg = thres_res.distrib_eeg{p};
    x_distrib = distrib_eeg{1}.x(1:end-1) + diff(distrib_eeg{1}.x);
    y_distrib = distrib_eeg{1}.y;

        
    %% PLOT
    figure, hold on
    k=1;
    
    %std EEG
    subtightplot(8,6,k:k+2, gap), hold on
    k=k+3;
    plot(x_distrib, y_distrib), hold on
    line([log10(std_eeg) log10(std_eeg)], get(gca,'ylim'), 'linewidth',2), hold on
    maintitle = [thres_res.subject{p} ' - ' num2str(thres_res.filereference{p}) ' (' thres_res.condition{p} ') - ' thres_res.date{p} ];
    title(maintitle);
    ylabel('EEG amplitude'), xlabel('log10 (µV)'), hold on

    
    
    for t=1:15%length(thD_list)
        
        
        %% slow-waves
        center_slowwaves = (Start(thres_res.slowwaves{p}{t}) + End(thres_res.slowwaves{p}{t})) / 2;
        nb_slowwaves = length(center_slowwaves);


        %Slow Wave density
        slowwaves_density = zeros(length(intervals_start),1);
        for i=1:length(intervals_start)
            intv = intervalSet(intervals_start(i),intervals_start(i) + windowsize);
            slowwaves_density(i) = length(Restrict(ts(center_slowwaves),intv)); %per min
        end
        density_sw.x = x_intervals;
        density_sw.y = slowwaves_density;


        %% Inter SlowWaves Intervals
        tSlowwave = center_slowwaves;

        %all SW        
        [isi_sw.y, isi_sw.x] = histcounts(diff(tSlowwave/10), edges);
        isi_sw.x = isi_sw.x(1:end-1) + diff(isi_sw.x);
        
        
        %% plot
        %density
        subtightplot(8,6,k:k+1, gap), hold on
        k=k+2;
        plot(density_sw.x, density_sw.y,'-',  'color','k'), hold on,
        ylabel('Slow waves, per min'),
        xlim([0 night_duration/3600E4]), hold on,
         
        if t==1
            title('Density of events'),
        end
        if t==8
             xlabel('time(h)'), hold on
        else
            set(gca, 'XTickLabel', {}, 'XTick',[]), hold on
        end
        
        
        %ISI
        subtightplot(8,6,k, gap), hold on
        k=k+1;
        bar(isi_sw.x, isi_sw.y), hold on
        xlim([0 4000]), hold on,
        if t==1
            title('Slow waves (ISI)')
        end
        if t==8
             xlabel('Inter SW Interval'), hold on
        else
            set(gca, 'XTickLabel', {}, 'XTick',[]), hold on
        end

        
        
        

    end


end


