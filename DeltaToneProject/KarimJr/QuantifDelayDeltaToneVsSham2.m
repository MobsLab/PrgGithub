% QuantifDelayDeltaToneVsSham2
% 15.11.2016 KJ
%
%
% distributions of the delays after the events (tones vs sham) 
%
% Info
%   Analysis are made for the different substages and conditions.
%


% load
folder_data = [RootDropBox 'Dropbox/Kteam/Projets KarimJr/Projet Delta/Data/'];
cd(folder_data) 
clear
load QuantifDelayDeltaToneVsSham.mat


%% Concatenate
animals = unique(delay_res.name);

for sub=substages_ind
    for d=1:length(delays)
        for m=1:length(animals)
            %% Sham
            delay_delta_sham = [];
            delay_down_sham = [];
            for p=1:length(delay_res.path)
                if strcmpi(sham_res.name{p},animals(m))
                    delay_delta_sham = [delay_delta_sham ; sham_res.delay_delta_sham{p,sub,d}];
                    delay_down_sham = [delay_down_sham ; sham_res.delay_down_sham{p,sub,d}];
                end
            end

            deltas.sham.medians_delay(d,sub,m) = median(delay_delta_sham)/10;
            deltas.sham.modes_delay(d,sub,m) = mode(delay_delta_sham)/10;
            deltas.sham.means_delay(d,sub,m) = mean(delay_delta_sham)/10;
            
            downs.sham.medians_delay(d,sub,m) = median(delay_down_sham)/10;
            downs.sham.modes_delay(d,sub,m) = mode(delay_down_sham)/10;
            downs.sham.means_delay(d,sub,m) = mean(delay_down_sham)/10;
        
            %% Tone
            delay_delta_tone = [];
            delay_down_tone = [];
            for p=1:length(delay_res.path)
                if delay_res.delay{p}==delays(d) && strcmpi(delay_res.name{p},animals(m))
                    delay_delta_tone = [delay_delta_tone ; delay_res.delay_delta_tone{p,sub}];
                    delay_down_tone = [delay_down_tone ; delay_res.delay_down_tone{p,sub}];
                end
            end

            deltas.tone.medians_delay(d,sub,m) = median(delay_delta_tone)/10;
            deltas.tone.modes_delay(d,sub,m) = mode(delay_delta_tone)/10;
            deltas.tone.means_delay(d,sub,m) = mean(delay_delta_tone)/10;
            
            downs.tone.medians_delay(d,sub,m) = median(delay_down_tone)/10;
            downs.tone.modes_delay(d,sub,m) = mode(delay_down_tone)/10;
            downs.tone.means_delay(d,sub,m) = mean(delay_down_tone)/10;
            

        end
    end
end

clear sub p m d
clear delay_delta_tone delay_down_tone delay_res
clear delay_delta_sham delay_down_sham sham_res




%% Order and plot
figtypes = {'Median','Mean'}; % stats
NameSubstages = {'N2', 'N3'}; % NREM substages
substages_plot = 2:3;

%Delta
for ft=1:length(figtypes)
    figure, hold on
    for d=1:length(delays)
        data = [];
        labels = cell(0);
        bar_color = cell(0);
        for s=1:length(substages_plot)
            sub=substages_plot(s);
            if strcmpi(figtypes{ft},'Median') %median
                data = [data...
                    squeeze(deltas.sham.medians_delay(d,sub,:))...
                    squeeze(deltas.tone.medians_delay(d,sub,:))];
            elseif strcmpi(figtypes{ft},'Mode') %mode
                data = [data...
                    squeeze(deltas.sham.modes_delay(d,sub,:))...
                    squeeze(deltas.tone.modes_delay(d,sub,:))];
            elseif strcmpi(figtypes{ft},'Mean') %mode
                data = [data...
                    squeeze(deltas.sham.means_delay(d,sub,:))...
                    squeeze(deltas.tone.means_delay(d,sub,:))];
            end
            labels{end+1} = ['Sham ' NameSubstages{s}];
            labels{end+1} =['Tone ' NameSubstages{s}];
            bar_color{end+1} = 'b';
            bar_color{end+1} = 'r';
            
        end
  
        subplot(2,2,d), hold on,
            PlotErrorBarN_KJ(data,'newfig',0,'barcolors',bar_color);
        title([num2str(delays(d)*1000) 'ms']), hold on,
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), ylabel('ms'), hold on,
        
    end
    suplabel(['Delta delay - ' figtypes{ft}],'t');
    
end

%Down
for ft=1:length(figtypes)
    figure, hold on
    for d=1:length(delays)
        data = [];
        labels = cell(0);
        bar_color = cell(0);
        for s=1:length(substages_plot)
            sub=substages_plot(s);
            if strcmpi(figtypes{ft},'Median') %median
                data = [data...
                    squeeze(downs.sham.medians_delay(d,sub,:))...
                    squeeze(downs.tone.medians_delay(d,sub,:))];
            elseif strcmpi(figtypes{ft},'Mode') %mode
                data = [data...
                    squeeze(downs.sham.modes_delay(d,sub,:))...
                    squeeze(downs.tone.modes_delay(d,sub,:))];
            elseif strcmpi(figtypes{ft},'Mean') %mode
                data = [data...
                    squeeze(downs.sham.means_delay(d,sub,:))...
                    squeeze(downs.tone.means_delay(d,sub,:))];
            end
            labels{end+1} = ['Sham ' NameSubstages{s}];
            labels{end+1} =['Tone ' NameSubstages{s}];
            bar_color{end+1} = 'b';
            bar_color{end+1} = 'r';
            
        end
  
        subplot(2,2,d), hold on,
            PlotErrorBarN_KJ(data,'newfig',0,'barcolors',bar_color);
        title([num2str(delays(d)*1000) 'ms']), hold on,
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), ylabel('ms'), hold on,
        
    end
    suplabel(['Down delay - ' figtypes{ft}],'t');
    
end


