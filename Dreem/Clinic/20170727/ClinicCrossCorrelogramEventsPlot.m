% ClinicCrossCorrelogramEventsPlot
% 24.07.2017 KJ
%
% Cross-correlogram Tones-SlowWaves
% -> plot data
%
%   see 
%       
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'ClinicCrossCorrelogramEvents.mat'])

conditions = unique(crosscor_res.condition);
colori = {'b','k','r'};
smoothing_factor = 4;


%% Gather data
for cond=1:length(conditions)

    crosscorr.tone_slowwave.y{cond} = [];
    crosscorr.tone_burst.y{cond} = [];
    autocorr.slowwave.y{cond} = [];
    autocorr.burst.y{cond} = [];
    
    nb_tones = 0;
    nb_slowwaves = 0;
    nb_burst = 0;
    
    for p=1:length(crosscor_res.filename)
        if strcmpi(crosscor_res.condition{p},conditions{cond})
            if isempty(crosscorr.tone_slowwave.y{cond})
                crosscorr.tone_slowwave.y{cond} = Data(crosscor_res.Cc.tone_slowwave{p}) * crosscor_res.nb.tones{p};
                crosscorr.tone_burst.y{cond} = Data(crosscor_res.Cc.tone_burst{p}) * crosscor_res.nb.tones{p};
                autocorr.slowwave.y{cond} = Data(crosscor_res.Ac.slowwave{p}) * crosscor_res.nb.slowwaves{p};
                autocorr.burst.y{cond} = Data(crosscor_res.Ac.burst{p}) * crosscor_res.nb.burst{p};
            else
                crosscorr.tone_slowwave.y{cond} = crosscorr.tone_slowwave.y{cond} + Data(crosscor_res.Cc.tone_slowwave{p}) * crosscor_res.nb.tones{p};
                crosscorr.tone_burst.y{cond} = crosscorr.tone_burst.y{cond} + Data(crosscor_res.Cc.tone_burst{p}) * crosscor_res.nb.tones{p};
                autocorr.slowwave.y{cond} = autocorr.slowwave.y{cond} + Data(crosscor_res.Ac.slowwave{p}) * crosscor_res.nb.slowwaves{p};
                autocorr.burst.y{cond} = autocorr.burst.y{cond} + Data(crosscor_res.Ac.burst{p}) * crosscor_res.nb.burst{p};
            end
            
            nb_tones = nb_tones + crosscor_res.nb.tones{p};
            nb_slowwaves = nb_slowwaves + crosscor_res.nb.slowwaves{p};
            nb_burst = nb_burst + crosscor_res.nb.burst{p};
            
            crosscorr.tone_slowwave.x{cond} = Range(crosscor_res.Cc.tone_slowwave{p});
            crosscorr.tone_burst.x{cond} = Range(crosscor_res.Cc.tone_burst{p});
            autocorr.slowwave.x{cond} = Range(crosscor_res.Ac.slowwave{p});
            autocorr.burst.x{cond} = Range(crosscor_res.Ac.burst{p});
            
        end
    end
    
    %remove center element for auto-correlogram
    autocorr.slowwave.y{cond}(autocorr.slowwave.x{cond}==0) = 0;
    autocorr.burst.y{cond}(autocorr.burst.x{cond}==0) = 0;
    
    % mean and smooth
    crosscorr.tone_slowwave.y{cond} = smooth(crosscorr.tone_slowwave.y{cond} / nb_tones, smoothing_factor);
    crosscorr.tone_burst.y{cond} = smooth(crosscorr.tone_burst.y{cond} / nb_tones, smoothing_factor);
    autocorr.slowwave.y{cond} = smooth(autocorr.slowwave.y{cond} / nb_slowwaves, smoothing_factor);
    autocorr.burst.y{cond} = smooth(autocorr.burst.y{cond} / nb_burst, smoothing_factor);
    
end



%% Plot
figure, hold on

%Cross-correlogram Tone vs Slow-Wave
subplot(2,2,1),hold on
for cond=1:length(conditions)
    h(cond) = plot(crosscorr.tone_slowwave.x{cond}, crosscorr.tone_slowwave.y{cond}, colori{cond}); hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    xlabel('Time (ms)')
    title('Cross-correlogram Tone vs Slow-Wave')
end
legend(h,conditions{:});

%Cross-correlogram Tone vs Burst
subplot(2,2,2),hold on
for cond=1:length(conditions)
    h(cond) = plot(crosscorr.tone_burst.x{cond}, crosscorr.tone_burst.y{cond}, colori{cond}); hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    xlabel('Time (ms)')
    title('Cross-correlogram Tone vs Burst')
end
legend(h,conditions{:});

% Auto-correlogram of Slow-Wavessubplot(2,2,3),hold on
subplot(2,2,3),hold on
for cond=1:length(conditions)
    h(cond) = plot(autocorr.slowwave.x{cond}, autocorr.slowwave.y{cond}, colori{cond}); hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    xlabel('Time (ms)')
    title('Auto-correlogram of Slow-Waves')
end
legend(h,conditions{:});

% Auto-correlogram of Bursts
subplot(2,2,4),hold on
for cond=1:length(conditions)
    h(cond) = plot(autocorr.burst.x{cond}, autocorr.burst.y{cond}, colori{cond}); hold on
    line([0 0],get(gca,'YLim'), 'color',[0.5 0.5 0.5]), hold on
    xlabel('Time (ms)')
    title('Auto-correlogram of Bursts')
end
legend(h,conditions{:});











