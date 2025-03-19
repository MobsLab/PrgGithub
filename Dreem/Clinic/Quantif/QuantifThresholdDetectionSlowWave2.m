% QuantifThresholdDetectionSlowWave2
% 25.01.2017 KJ
%
% Raster plot of the EEG, synchronized on tones
% -> Format data 
%
%   see 
%       QuantifThresholdDetectionSlowWave
%

%load
clear
eval(['load ' FolderPrecomputeDreem 'QuantifThresholdDetectionSlowWave.mat'])

%channels
name_channels = {'FP1-M1','FP2-M2','REF F3','REF F4'};

for p=1:length(thresh_res.filename)
    %% data
    for ch=1:length(sw_detection_channels)
        nb_slowwaves{ch} = thresh_res.nb_slowwaves{p}(:,ch);
        nb_slowwaves_sleep{ch} = squeeze(sum(thresh_res.nb_slowwaves_stage{p}(:,ch,1:3),3));
        nb_slowwaves_wake{ch} = squeeze(thresh_res.nb_slowwaves_stage{p}(:,ch,5));
        nb_slowwaves_n3{ch} = squeeze(thresh_res.nb_slowwaves_stage{p}(:,ch,3));
        std_thresholds{ch} = -threshold_list / thresh_res.std_signals{p}(ch);
    end

    %% plot
    figure, hold on
    for ch=1:length(sw_detection_channels)
        subplot(2,2,ch), hold on
        plot(threshold_list, nb_slowwaves{ch},'k'), hold on
        plot(threshold_list, nb_slowwaves_sleep{ch},'b'), hold on
        plot(threshold_list, nb_slowwaves_wake{ch},'r'), hold on
        plot(threshold_list, nb_slowwaves_n3{ch},'g'), hold on
        ylabel('number of detections'), xlabel('Threshold (µV)'), hold on
        set(gca,'XDir','reverse'), hold on
        legend('All','Sleep','Wake','N3'), title(name_channels{ch})
    end
    maintitle = ['Subject ' num2str(thresh_res.subject{p}) ' - night ' num2str(thresh_res.night{p}) ' ' thresh_res.condition{p} ' - '  thresh_res.date{p}];
    suplabel(maintitle,'t');
end



