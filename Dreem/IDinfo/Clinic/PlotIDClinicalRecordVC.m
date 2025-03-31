% PlotIDClinicalRecordVC
% 11.07.2017 KJ
%
% infos = PlotIDClinicalRecord(filereference)
%
% INFOS
%   Plot description figures of a record of clinical trial
% 
%
% SEE 
%   GenerateIDClinicalRecordVC PlotIDClinicalRecord
%
%


function infos = PlotIDClinicalRecordVC(filereference)

%% Load Data
try
    cd(FolderProcessDreem)
    datafile = ['IDfigures_' num2str(filereference) '.mat'];
    load(datafile)
catch
    disp('File not loaded')
end
if ~exist('infos','var')
    error('data not loaded.')
end

try
    display_hypno = infos.hypno_pascal;
catch
    display_hypno = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);

%left
textbox_dim = [0.05 0.87 0.2 0.08];
table_dim = [0.05 0.58 0.205 0.27];

ISI_Axes = axes('position', [0.28 0.62 0.2 0.32]);

MeanCurves_Axes = axes('position', [0.05 0.05 0.24 0.45]);

Phase_Axes = axes('position', [0.31 0.15 0.22 0.3]);


%right
Spectrogram_Axes = axes('position', [0.56 0.79 0.42 0.18]);

Density_Axes = axes('position', [0.56 0.53 0.42 0.2]);

Sleepstages_Axes = axes('position', [0.56 0.29 0.42 0.18]);

StatStage_Axes = axes('position', [0.56 0.05 0.18 0.17]);
MeanDurStage_Axes = axes('position', [0.78 0.05 0.18 0.17]);


%% Textbox and infos table
textbox_str = {['Subject ' num2str(infos.subject) ' / night ' num2str(infos.night)], [infos.date ' / ' infos.condition], [num2str(infos.nb_tones) ' stimulations'], [num2str(nb_hypnogram) '(+1) hypnograms']}; 

annotation(gcf,'textbox',...
    textbox_dim,...
    'String',textbox_str,...
    'LineWidth',1,...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FitBoxToText','off');

tableau = uitable(gcf,'Data', infos.data_table,'units','normalized','position',table_dim);
tableau.ColumnName = infos.column_table;

%% ISI & Correlogram
axes(ISI_Axes);
bar(histo.x,histo.y), hold on
plot(histo_n2.x, histo_n2.y), hold on
plot(histo_n3.x, histo_n3.y), hold on
xlim([min(edges),edges(end-1)])
title('Slow waves (ISI)'); xlabel('Inter SW Interval')
legend('All slow waves','N2','N3')


%% Mean Curves sync on Tones
axes(MeanCurves_Axes);
try
    for i=1:length(params.channels_frontal)
        plot(Ms_tone{i}(:,1),Ms_tone{i}(:,2),'linewidth',2), hold on
    end
    legend(infos.name_channel(params.channels_frontal))
    ylim([-100 100]), hold on
    plot(Ms_tone{1}(:,1),zeros(length(Ms_tone{1}(:,2)),1), 'color',[0.5 0.5 0.5]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    ylabel('EEG averaged on stims'); xlabel('Time (ms)')
end


%% Phase histogram
axes(Phase_Axes);
rose(phase_tone,36);
title('Stim Phase Histogram')


%% Spectrogram
axes(Spectrogram_Axes);
imagesc(t_spg/3600, f_spg, log(Specg)'), hold on
axis xy, ylabel('frequency'), hold on
set(gca,'Yticklabel',5:5:25);
title([infos.name_channel_specg ' Spectrogram'])


%% Density of events: Slow waves-tones  &  SWA 
axes(Density_Axes);
smoothing=1;

yyaxis left
plot(Range(QSlowWave,'s')/3600,SmoothDec(Data(QSlowWave),smoothing),'-',  'color','k'), hold on,
plot(Range(QTones,'s')/3600,SmoothDec(Data(QTones),smoothing),'-',  'color','b'), hold on,
ylabel('Slow waves / Tones, per min'),
yyaxis right
plot(params.swa_time/3600E4, swa_power, 'r', 'linewidth',2)
ylabel('SWA (normalized)'),

legend('Slow waves', 'Tones','SWA 0.5-4 Hz'), hold on,
xlim([0 infos.night_duration/3600E4]), hold on,
title('Density of events - SWA'), 


%% Sleep Stages
if display_hypno
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

end