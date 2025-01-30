% TestTimingToneLFP2
% 01.02.2017 KJ
%
% for each night, look at the timing of tones and if it is coherent with
% ohter data
%
% see TestTimingToneLFP TestTimingTone TestTimingTone2


clear
load([FolderProjetDelta 'Data/TestTimingToneLFP.mat']) 

animals = unique(tonetiming_res.name);
conditions = unique(tonetiming_res.condition);


%% Concatenate
for cond=1:length(conditions)
    for m=1:length(animals)
        met_detection=[];
        met_tone=[];
        met_det_x = [];
        met_tone_x = [];
        
        for p=1:length(tonetiming_res.path)
           if strcmpi(tonetiming_res.name{p},animals{m}) && strcmpi(tonetiming_res.condition{p},conditions{cond})
               
                %% detection (fires matrix)
                if isempty(met_detection)
                    met_detection = tonetiming_res.Md_detect{p}(:,2) * tonetiming_res.nb_detect{p};
                    nb_detection = tonetiming_res.nb_detect{p};
                    
                    met_det_x = tonetiming_res.Md_detect{p}(:,1);
                    
                else
                    met_detection = met_detection + tonetiming_res.Md_detect{p}(:,2) * tonetiming_res.nb_detect{p};
                    nb_detection = nb_detection + tonetiming_res.nb_detect{p};
                end
                
                %% tone (fires actual time)
                if tonetiming_res.real_time{p}
                    if isempty(met_tone)
                        met_tone = tonetiming_res.Md_tone{p}(:,2) * tonetiming_res.nb_tone{p};
                        nb_tone = tonetiming_res.nb_tone{p};
                        
                        met_tone_x = tonetiming_res.Md_tone{p}(:,1);
                    else
                        met_tone = met_tone + tonetiming_res.Md_tone{p}(:,2) * tonetiming_res.nb_tone{p};
                        nb_tone = nb_tone + tonetiming_res.nb_tone{p};
                    end
                end
                
           end
        end
        
        try
            mean_curves.detection.x{m,cond} = met_det_x;
            mean_curves.detection.y{m,cond} = met_detection / nb_detection;
        catch
            mean_curves.detection.x{m,cond} = [];
            mean_curves.detection.y{m,cond} = [];
        end
        try 
            mean_curves.tone.x{m,cond} = met_tone_x;
            mean_curves.tone.y{m,cond} = met_tone / nb_tone;
        catch
            mean_curves.tone.x{m,cond} = [];
            mean_curves.tone.y{m,cond} = [];
        end
        
    end
end


%% plot
for cond=1:length(conditions)
    figure, hold on
    for m=1:length(animals)
        subplot(3,3,m), hold on
        plot(mean_curves.detection.x{m,cond}, mean_curves.detection.y{m,cond},'k'), hold on
        if m<5
            plot(mean_curves.tone.x{m,cond}, mean_curves.tone.y{m,cond},'b'), hold on
            legend('detection', 'tones'), 
        else
            legend('detection'), 
        end
        title(animals{m}), ylim([-1500 1500]),
        line([0 0],get(gca,'YLim')), hold on
    end
    suplabel(conditions{cond},'t');
end

cond=6;
a=0;
figure, hold on
for m=[1:6 8 9]
    a=a+1;
    subplot(3,3,a), hold on
    plot(mean_curves.detection.x{m,cond}, mean_curves.detection.y{m,cond},'k'), hold on
    if m<5
        plot(mean_curves.tone.x{m,cond}, mean_curves.tone.y{m,cond},'b'), hold on
        legend('tones1', 'tones2'), 
    else
        legend('tones1'), 
    end
    title(animals{m}), ylim([-1500 1500]),
    line([0 0],get(gca,'YLim')), hold on
end
suplabel(['ERP for ' conditions{cond}],'t');










