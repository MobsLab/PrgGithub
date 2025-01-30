% ClinicDelayPhaseEffectPlot
% 12.07.2017 KJ
%
% Delta Stat - only delta after tones or sham
% Analyse delay and phase
% 
%   see ClinicStatSlowWaves ClinicStatSlowWavesPlot1 ClinicStatSlowWavesPlot2 ClinicDelayRefractoryPeriodPlot
%


clear

%% load
load([FolderPrecomputeDreem 'ClinicStatSlowWaves.mat']) 
conditions = {'sham','upphase','random'};
conditionsWithTones = {'Random'};
subjects = unique(cell2mat(quantity_res.subject));

%% init

%percentile
range_delay = 0:150:1500;
labels_delay = cell(0);
for i=1:length(range_delay)
    labels_delay{end+1} = num2str(round(range_delay(i)));
end
range_phase = -pi:pi/4.5:pi;
labels_phase = cell(0);
for i=1:length(range_phase)
    labels_phase{end+1} = num2str(round(range_phase(i)*180/pi));
end


%% Delay
for p=1:length(quantity_res.filename)
        if any(strcmpi(quantity_res.condition{p}, conditionsWithTones))
            
            night_delay = quantity_res.tones.delay{p}/10;
            night_induced =  quantity_res.tones.induce{p};
            
            %result whole night
            for i=1:length(range_delay)-1
                delay.success(p,i) = sum(night_induced(night_delay>range_delay(i) & night_delay<range_delay(i+1)));
                delay.number(p,i) = sum(night_delay>range_delay(i) & night_delay<range_delay(i+1));
            end
        end
end
%percentage whole night
percentage_delay = (delay.success ./ delay.number)*100;
delay.failed = delay.number - delay.success;
%percentiles
x_delay = 1:length(range_delay)-1;


%% Phase
for p=1:length(quantity_res.filename)
        if any(strcmpi(quantity_res.condition{p}, conditionsWithTones))
            
            night_phase = quantity_res.tones.phase{p};
            night_induced =  quantity_res.tones.induce{p};
            
            %result whole night
            for i=1:length(range_phase)-1
                phase.success(p,i) = sum(night_induced(night_phase>range_phase(i) & night_phase<range_phase(i+1)));
                phase.number(p,i) = sum(night_phase>range_phase(i) & night_phase<range_phase(i+1));
            end
        end
end
%percentage whole night
percentage_phase = (phase.success ./ phase.number)*100;
phase.failed = phase.number - phase.success;
%percentiles
x_phase = 1:length(range_phase)-1;




%% PLOT
figure, hold on

% delay
subplot(2,1,1), hold on
yyaxis left
bar(1:length(range_delay)-1,[mean(delay.success)', mean(delay.failed)'], 'stack'); 
set(gca, 'ylim', [0 50], 'YTick',0:20:50); ylabel('number'),
yyaxis right
PlotErrorLineN_KJ(percentage_delay, 'newfig',0,'linecolor','k');
set(gca, 'ylim', [0 50], 'YTick',0:20:50); ylabel('% of success tones'),

legend('Success','Failed', '% success'),
xlabel('Delays between slow wave and sound'),
set(gca, 'XTickLabel', labels_delay,'XTick',(1:numel(labels_delay)) - 0.5,'xlim',[0.5 length(labels_delay)-0.5],'XTickLabelRotation',30,'FontName','Times','fontsize',12), hold on,

%phase
subplot(2,1,2), hold on
yyaxis left
bar(1:length(range_phase)-1,[mean(phase.success)', mean(phase.failed)'], 'stack');
set(gca, 'ylim', [0 70], 'YTick',0:20:70); ylabel('number'),
yyaxis right
PlotErrorLineN_KJ(percentage_phase, 'newfig',0,'linecolor','k');
set(gca, 'ylim', [0 70], 'YTick',0:20:70); ylabel('% of success tones'),

legend('Success','Failed', '% success'),
xlabel('Phase of stimulation'),
set(gca, 'XTickLabel', labels_phase,'XTick',(1:numel(labels_phase)) - 0.5,'xlim',[0.5 length(labels_phase)-0.5],'XTickLabelRotation',30,'FontName','Times','fontsize',12), hold on,











% %% PLOT
% figure, hold on
% 
% subplot(2,1,1), hold on
% PlotErrorBarN_KJ(percentage_delay, 'newfig',0,'paired',0,'showPoints',0,'ShowSigstar','none');
% PlotErrorLineN_KJ(percentage_delay, 'newfig',0,'linecolor','r');
% xlabel('Delays between slow wave and sound'),
% ylabel('% of success tones'),ylim([0 60]),
% set(gca, 'XTickLabel', labels_delay,'XTick',(1:numel(labels_delay)+1) - 0.5,'YTick',0:20:60,'XTickLabelRotation',30,'FontName','Times','fontsize',12), hold on,
% 
% 
% subplot(2,1,2), hold on
% PlotErrorBarN_KJ(percentage_phase, 'newfig',0,'paired',0,'showPoints',0,'ShowSigstar','none');
% PlotErrorLineN_KJ(percentage_phase, 'newfig',0,'linecolor','r');
% xlabel('Phase of stimulation'),
% ylabel('% of success tones'),ylim([0 60]),
% set(gca, 'XTickLabel', labels_phase,'XTick',(1:numel(labels_phase)+1) - 0.5,'YTick',0:20:60,'XTickLabelRotation',30,'FontName','Times','fontsize',12), hold on,



