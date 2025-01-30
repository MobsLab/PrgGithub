% ClinicDelayRefractoryPeriodPlot
% 28.03.2017 KJ
%
% Bar plot of the success ratio for each delay
% -> Plot data 
%
%   see 
%       ClinicDelayRefractoryPeriod FigureDelayRefractoryPeriod
%

clear
load([FolderPrecomputeDreem 'ClinicDelayRefractoryPeriod.mat']) 
conditionsWithTones = {'Habituation','Random','UpPhase'};
subjects = unique(cell2mat(refractory_res.subject));

%params
colori = {[0.5 0.3 1]; [1 0.5 1]; [0.8 0 0.7]; [0.1 0.7 0]; [0.5 0.2 0.1]};
NameSubstages = {'N1';'N2';'N3';'REM';'Wake'};

%% init

%percentile
percentiles_delay = 0:200:6000;
labels_perc = cell(0);
for i=1:length(percentiles_delay)
    labels_perc{end+1} = num2str(round(percentiles_delay(i)));
end

%tones
tone_nights = ismember(refractory_res.condition,conditionsWithTones);  % nights selected, i.e not Sham
all_intensities = cell2mat(refractory_res.intensity_tone(tone_nights)');  % intensities of the tones
all_delay = cell2mat(refractory_res.delay_slowwave_tone(tone_nights)');  % delays between tones and preceding slow wave
all_delay = all_delay(all_intensities>0 & all_delay<max(percentiles_delay)*10) / 10;


%% For each substage
all_stages = cell2mat(refractory_res.sleepstage_tone(tone_nights));
all_stages = all_stages(all_intensities>0);
for i=1:length(percentiles_delay)-1    
    stage_prctile = all_stages(all_delay>percentiles_delay(i) & all_delay<percentiles_delay(i+1));
    for sstage=sleepstage_ind
        all.substage(sstage,i) = 100*sum(stage_prctile==sstage)/length(stage_prctile);
    end
end
all.percentage_n2n3 = sum(all.substage([2 3],:),1) * 100 ./ sum(all.substage,1);

%% loop over nights
%data
nights_delay = [];
nights_induced = [];
substage_tone = [];
for p=1:length(refractory_res.filename)
        if any(strcmpi(refractory_res.condition{p}, conditionsWithTones))
            
            real_tone = refractory_res.intensity_tone{p}>0;
            night_delay = refractory_res.delay_slowwave_tone{p}(real_tone==1)/10;
            night_induced =  refractory_res.induce_slow_wave{p}(real_tone==1);
            substage_tone =  refractory_res.sleepstage_tone{p}(real_tone==1)';
            
            night_delay_n3 = night_delay(substage_tone==3);
            night_induced_n3 = night_induced(substage_tone==3);
            
            %result whole night
            for i=1:length(percentiles_delay)-1
                all.induce(p,i) = sum(night_induced(night_delay>percentiles_delay(i) & night_delay<percentiles_delay(i+1)));
                all.number(p,i) = sum(night_delay>percentiles_delay(i) & night_delay<percentiles_delay(i+1));
            end
            %N3 SWS
            for i=1:length(percentiles_delay)-1
                sws.induce(p,i) = sum(night_induced_n3(night_delay_n3>percentiles_delay(i) & night_delay_n3<percentiles_delay(i+1)));
                sws.number(p,i) = sum(night_delay_n3>percentiles_delay(i) & night_delay_n3<percentiles_delay(i+1));
            end
        end
end


%percentage whole night
percentage_all = (all.induce ./ all.number)*100;
%percentage N3
percentage_sws = (sws.induce ./ sws.number)*100;
%percentiles
x = 1:length(percentiles_delay)-1;


%% plot
figure, hold on

subplot(2,1,1), hold on
yyaxis right
plot(x, all.percentage_n2n3, 'b', 'Linewidth',2);
legend('% of N2+N3'), hold on, ylim([30 100]),
yyaxis left
PlotErrorBarN_KJ(percentage_all, 'newfig',0,'paired',0,'showPoints',0,'ShowSigstar','none');
PlotErrorLineN_KJ(percentage_sws, 'newfig',0,'linecolor','r');
xlabel('Delays between slow wave and sound'),
ylabel('% of success tones'),ylim([0 60]),
set(gca, 'XTickLabel', labels_perc,'XTick',(1:numel(labels_perc)+1) - 0.5,'YTick',0:20:60,'XTickLabelRotation',30,'FontName','Times','fontsize',12), hold on,


subplot(2,1,2), hold on
b=bar(x, all.substage', 'stacked'); hold on
set(b,{'FaceColor'},colori);
xlabel('Delays between delta and sound'),
ylabel('Substage percentage'),
set(gca, 'XTickLabel', labels_perc,'XTick',(1:numel(labels_perc)+1) - 0.5,'XLim', [0 length(x)+1],'YLim', [0 100],'YTick',0:20:100,'XTickLabelRotation',30,'FontName','Times','fontsize',12), hold on,
legend(NameSubstages); 



