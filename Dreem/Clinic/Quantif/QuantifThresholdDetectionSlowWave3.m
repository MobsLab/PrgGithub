% QuantifThresholdDetectionSlowWave3
% 25.01.2017 KJ
%
% Raster plot of the EEG, synchronized on tones
% -> Format data 
%
%   see 
%       QuantifThresholdDetectionSlowWave QuantifThresholdDetectionSlowWave2
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'QuantifThresholdDetectionSlowWave.mat'])

%channels
name_channels = {'FP1-M1','FP2-M2','REF F3','REF F4'};


%% concatenate

for ch=1:length(sw_detection_channels)
    nb_slowwaves{ch} = [];
    nb_slowwaves_sleep{ch} = [];
    nb_slowwaves_wake{ch} = [];
    nb_slowwaves_n3{ch} = [];
    
    for p=1:length(thresh_res.filename)
        
        nbsw = (thresh_res.nb_slowwaves{p}(:,ch) / sum(thresh_res.stage_duration{p})) * 60E4;
        nbsw_sleep = (squeeze(sum(thresh_res.nb_slowwaves_stage{p}(:,ch,1:4),3)) / sum(thresh_res.stage_duration{p}(1:4))) * 60E4;
        nbsw_wake = (squeeze(thresh_res.nb_slowwaves_stage{p}(:,ch,5)) / thresh_res.stage_duration{p}(5)) * 60E4;
        nbsw_n3 = (squeeze(thresh_res.nb_slowwaves_stage{p}(:,ch,3)) / thresh_res.stage_duration{p}(3)) * 60E4;
        
        if isempty(nb_slowwaves{ch})
            nb_slowwaves{ch} = nbsw';
            nb_slowwaves_sleep{ch} = nbsw_sleep';
            nb_slowwaves_wake{ch} = nbsw_wake';
            nb_slowwaves_n3{ch} = nbsw_n3';
        else
            nb_slowwaves{ch} = [nb_slowwaves{ch} ; nbsw'];
            nb_slowwaves_sleep{ch} = [nb_slowwaves_sleep{ch} ; nbsw_sleep'];
            nb_slowwaves_wake{ch} = [nb_slowwaves_wake{ch} ; nbsw_wake'];
            nb_slowwaves_n3{ch} = [nb_slowwaves_n3{ch} ; nbsw_n3'];
        end

    end
end


%% plot
xlabels = threshold_list;

figure, hold on
for ch=1:length(sw_detection_channels)
    subplot(2,2,ch), hold on
    [~,h(1)] = PlotErrorLineN_KJ(nb_slowwaves{ch}, 'newfig',0,'linecolor','k','ShowSigstar','none');
    [~,h(2)] = PlotErrorLineN_KJ(nb_slowwaves_sleep{ch}, 'newfig',0,'linecolor','b','ShowSigstar','none');
    [~,h(3)] = PlotErrorLineN_KJ(nb_slowwaves_wake{ch}, 'newfig',0,'linecolor','r','ShowSigstar','none');
    [~,h(4)] = PlotErrorLineN_KJ(nb_slowwaves_n3{ch}, 'newfig',0,'linecolor','g','ShowSigstar','none');
    
    legend(h,{'All','Sleep','Wake','N3'}), 
    
    ylabel('number of detections per min'), xlabel('Threshold (µV)'), hold on
    set(gca, 'XDir','reverse','XTickLabel', xlabels,'XTick',1:numel(xlabels)), hold on,    
    title(name_channels{ch})
end

suplabel('Density of detections for each thresholds','t');



