% QuantifDelayFirstDeltaToneSubstage2
% 15.11.2016 KJ
%
% distributions of the delays after the tones 
%
% Info
%   Analysis are made for the different substages and conditions.
%
%
% See
%   QuantifDelayFirstDeltaToneSubstage3
%

% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifDelayFirstDeltaToneSubstage.mat'))


%% Concatenate
animals = unique(delay_res.name);

for sub=substages_ind
    for d=1:length(delays)
        for m=1:length(animals)
            delay_delta_tone = [];
            delay_down_tone = [];
            for p=1:length(delay_res.path)
                if delay_res.delay{p}==delays(d) && strcmpi(delay_res.name{p},animals(m))
                    delay_delta_tone = [delay_delta_tone ; delay_res.delay_delta_tone{p,sub}];
                    delay_down_tone = [delay_down_tone ; delay_res.delay_down_tone{p,sub}];
                end
            end

            deltas.medians_delay(d,sub,m) = median(delay_delta_tone)/10;
            deltas.modes_delay(d,sub,m) = mode(delay_delta_tone)/10;

            downs.medians_delay(d,sub,m) = median(delay_down_tone)/10;
            downs.modes_delay(d,sub,m) = mode(delay_down_tone)/10;
        end
    end
end

clear sub p m d
clear delay_delta_tone delay_down_tone delay_res

%% Order and plot
figtypes = {'Median', 'Mode'}; % stats
NameSubstages = {'N2', 'N3'}; % NREM substages
substages_plot = 2:3;

%Delta
for ft=1:length(figtypes)
    figure, hold on
    for d=1:length(delays)
        data = [];
        labels = cell(0);
        for s=1:length(substages_plot)
            sub=substages_plot(s);
            if ft==1 %median
                data = [data squeeze(deltas.medians_delay(d,sub,:))];
            elseif ft==2 %mode
                data = [data squeeze(deltas.modes_delay(d,sub,:))];
            end
            labels{end+1} = NameSubstages{s};
            
        end
  
        subplot(2,3,d), hold on,
            PlotErrorBarN_KJ(data,'newfig',0);
        if delays(d)==-1
            title('Random')
        else
            title([num2str(delays(d)*1000) 'ms']), hold on,
        end
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
        for s=1:length(substages_plot)
            sub=substages_plot(s);
            if ft==1 %median
                data = [data squeeze(downs.medians_delay(d,sub,:))];
            elseif ft==2 %mode
                data = [data squeeze(downs.modes_delay(d,sub,:))];
            end
            labels{end+1} = NameSubstages{s};
            
        end
  
        subplot(2,3,d), hold on,
            PlotErrorBarN_KJ(data,'newfig',0);
        if delays(d)==-1
            title('Random')
        else
            title([num2str(delays(d)*1000) 'ms']), hold on,
        end
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), ylabel('ms'), hold on,
        
    end
    suplabel(['Down delay - ' figtypes{ft}],'t');
    
end



