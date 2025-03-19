%% Code to do the sleep scoring on the piezo data

% Project : Audiodream
% By Alexane Fauveau, Baptiste Maheo and Chloé Hayhurst

% Code used inside of this code :
% - GetGammaThresh

function [WakeEpoch_Piezo, SleepEpoch_Piezo] = SleepScoring_Piezo_AF(Piezo_Mouse_tsd, LFP_Folder, Mouse, TTLInfo)

Ok = 0;

while Ok~=1
    % Create the smooth_actimetry tsd :
%         Smooth_actimetry = tsd(Range(Piezo_Mouse_tsd), runmean(abs(zscore(Data(Piezo_Mouse_tsd))),300)); % smooth time =3s
    Smooth_actimetry = tsd(Range(Piezo_Mouse_tsd), runmean(abs(zscore(Data(Piezo_Mouse_tsd))),1000)); % smooth time =10s
    
    % Get the threshold:
    actimetry_thresh = GetGammaThresh(Data(Smooth_actimetry), 1);
    actimetry_thresh = exp(actimetry_thresh);
    
    % Create the Sleep Epoch
    minduration = 30;
    SleepEpoch_Piezo = thresholdIntervals(Smooth_actimetry, actimetry_thresh, 'Direction','Below');
    SleepEpoch_Piezo = mergeCloseIntervals(SleepEpoch_Piezo, 1*1e4);
    SleepEpoch_Piezo = dropShortIntervals(SleepEpoch_Piezo, minduration*1e4);
    TotalEpoch = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
    WakeEpoch_Piezo = TotalEpoch - SleepEpoch_Piezo;
    
    WakeEPoch_without_microwake = dropShortIntervals(WakeEpoch_Piezo, 3*1e4);
    MicroWakeEpoch = WakeEpoch_Piezo - WakeEPoch_without_microwake;
    
    % Plot to check
    
    figure
    
    Colors.Sleep = 'r';
    Colors.Wake = 'c';
    
    t = Range(Piezo_Mouse_tsd);
    begin = t(1);
    endin = t(end);
    
    % Plot the figure and save it
    
    plot(Range(Piezo_Mouse_tsd)/60 , Data(Piezo_Mouse_tsd), 'c')
    hold on
    plot(Range(Restrict(Piezo_Mouse_tsd,SleepEpoch_Piezo))/60 , Data(Restrict(Piezo_Mouse_tsd,SleepEpoch_Piezo)),'r')
    plot(Range(Smooth_actimetry)/60 , Data(Smooth_actimetry)-1,'c')
    plot(Range(Restrict(Smooth_actimetry,SleepEpoch_Piezo))/60 , Data(Restrict(Smooth_actimetry,SleepEpoch_Piezo))-1,'r')
    hold on
    LineHeight = max(Data(Piezo_Mouse_tsd)) + 0.1;
    LineHeight1 = min(Data(Smooth_actimetry)) - 2;
    LineHeight2 = LineHeight + 0.2;
    plot(Start(TTLInfo.Sounds)/60 , 3 , '*k')
    ylim([LineHeight1 LineHeight2])
    xlim([0 length(Piezo_Mouse_tsd)])
    PlotPerAsLine(SleepEpoch_Piezo, LineHeight, Colors.Sleep, 'timescaling', 60e4, 'linewidth',10);
    PlotPerAsLine(WakeEpoch_Piezo, LineHeight, Colors.Wake,  'timescaling', 60e4,  'linewidth',10);
    title('Sleep Scoring des données d actimétrie')
    
    Ok = input('--- Are you satisfied with final sleep epochs (0/1)?');
    
end

save([num2str(Mouse) '_SleepScoring.mat'],'SleepEpoch_Piezo','WakeEpoch_Piezo','Smooth_actimetry','Piezo_Mouse_tsd', 'actimetry_thresh')

end
