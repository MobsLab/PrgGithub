% PlotIDDreemSlowDyn
% 13.06.2018 KJ
%
% infos = PlotIDDreemSlowDyn(filereference)
%
% INFOS
%   Plot description figures of a record of clinical trial
% 
%
% SEE 
%   DreemIDSlowDyn PlotIDDreemStimImpact
%
%


function infos = PlotIDDreemSlowDyn(filereference)

%% Load Data
try
    datafile = fullfile(FolderSlowDynID,['IdFigureData_' num2str(filereference) '.mat']);
    load(datafile)
catch
    disp('File not loaded')
end
if ~exist('infos','var')
    error('data not loaded.')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);

%left
textbox_dim = [0.05 0.87 0.2 0.08];
table_dim = [0.05 0.58 0.205 0.27];

MeanCurves_Axes = axes('position', [0.05 0.05 0.42 0.45]);

ISI_Axes = axes('position', [0.28 0.62 0.2 0.32]);

%right
Spectrogram_Axes = axes('position', [0.52 0.79 0.44 0.18]);

Density_Axes = axes('position', [0.52 0.53 0.44 0.2]);

Sleepstages_Axes = axes('position', [0.52 0.29 0.44 0.18]);

StatStage_Axes = axes('position', [0.53 0.05 0.18 0.17]);
MeanDurStage_Axes = axes('position', [0.78 0.05 0.18 0.17]);

%name channels
name_channels = {'Fpz-O1', 'Fpz-O2', 'Fpz-F7', 'F8-F7', 'F7-O1', 'F8-O2', 'Fpz-F8'};


%% Textbox and infos table

%table data
tb.column_table = {'Channel','Slow Waves','Tones success','Ratio success'};
tb.data_table = cell(0);
a=0;
for ch=1:length(infos.name_channel)
    a=a+1;
    tb.data_table{a,1} = name_channels{ch};
    tb.data_table{a,2} = stat_sw.nb_SlowWaves{ch};
    tb.data_table{a,3} = stat_sw.nb_tone_success{ch};
    tb.data_table{a,4} = round(stat_sw.ratio_success{ch} * 100,2);
end


textbox_str = {['Subject ' num2str(infos.subject)], [datestr(infos.date) ' / SlowDyn'], [num2str(nb_events.tones) ' stimulations']}; 

annotation(gcf,'textbox',...
    textbox_dim,...
    'String',textbox_str,...
    'LineWidth',1,...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FitBoxToText','on');

tableau = uitable(gcf,'Data', tb.data_table,'units','normalized','position',table_dim);
tableau.ColumnName = tb.column_table;


%% ISI & Correlogram
axes(ISI_Axes);

ch = infos.channel_specg;

bar(isi_curves.all.x{ch}, isi_curves.all.y{ch}), hold on
plot(isi_curves.n2.x{ch}, isi_curves.n2.y{ch}), hold on
plot(isi_curves.n3.x{ch}, isi_curves.n3.y{ch}), hold on
% xlim([min(edges),edges(end-1)])
title('Slow waves (ISI)'); xlabel('Inter SW Interval')
legend('All SW','N2','N3')


%% Mean Curves sync on Tones
axes(MeanCurves_Axes);
ch_curves = [1 2 5 6];
try
    for i=1:length(ch_curves)
        ch = ch_curves(i);
        h(i)=plot(meancurves_stim.tones{ch}(:,1), meancurves_stim.tones{ch}(:,2),'linewidth',2); hold on
    end
    ylim([-100 100]), hold on
    plot(meancurves_stim.tones{1}(:,1),zeros(length(meancurves_stim.tones{1}(:,1)),1), 'color',[0.7 0.7 0.7]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.7 0.7 0.7]), hold on
    ylabel('EEG averaged on stims'); xlabel('Time (ms)')
    legend(h, name_channels(ch_curves))
end

%% Spectrogram
axes(Spectrogram_Axes);
imagesc(t_spg/3600, f_spg, log(Specg)'), hold on
axis xy, ylabel('frequency'), hold on
set(gca,'Yticklabel',5:5:25);
title([infos.name_channel{infos.channel_specg} ' Spectrogram'])


%% Density of events: Slow waves-tones  &  SWA 
axes(Density_Axes);
smoothing=1;

ch = infos.channel_specg;

yyaxis left
plot(density_curves.slowwaves.x{ch}, density_curves.slowwaves.y{ch},'-',  'color','k'), hold on,
plot(density_curves.tones.x, density_curves.tones.y,'-',  'color','b'), hold on,
ylabel('Slow waves / Tones, per min'),

yyaxis right
plot(t_spg/3600, log(swa_power), 'r', 'linewidth',2)
ylabel('SWA (normalized)'),

legend('Slow waves', 'Tones','SWA 0.5-4 Hz'), hold on,
xlim([0 infos.night_duration/3600E4]), hold on,
title('Density of events - SWA'), 


%% Sleep Stages
axes(Sleepstages_Axes);
ylabel_substage = {'N3','N2','N1','REM','WAKE'};
ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
plot(Range(SleepStages,'s')/3600,Data(SleepStages),'k'), hold on,
for ep=1:length(Epochs)
    plot(Range(Restrict(SleepStages,Epochs{ep}),'s')/3600 ,Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori{ep}), hold on,
end
xlim([0 max(Range(SleepStages,'s')/3600)]), ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
title('Hypnogram'); xlabel('Time (h)')

axes(StatStage_Axes);
for ep=1:length(time_stages)
    h = bar(ep, time_stages(ep)/3600E3); hold on
    set(h,'FaceColor', colori{ep}), hold on
    if any(1:3==ep)
        text(ep - 0.3, (time_stages(ep)/1000 + 1000)/3600, [num2str(percentvalues_NREM(ep)) '%'], 'VerticalAlignment', 'top', 'FontSize', 8)
    end
end
set(gca, 'XTickLabel',{'N1','N2','N3','REM','WAKE'}, 'XTick',1:5), hold on
ylim([0, max(time_stages/3600E3) * 1.2]);
title('Total duration'); ylabel('duration (h)')


axes(MeanDurStage_Axes)
for ep=1:length(meanDuration_sleepstages)
    h = bar(ep, meanDuration_sleepstages(ep)/60E3); hold on
    set(h,'FaceColor', colori{ep}), hold on
end
set(gca, 'XTickLabel',{'N1','N2','N3','REM','WAKE'}, 'XTick',1:5), hold on
title('Episode mean duration'); ylabel('duration (min)')

end
