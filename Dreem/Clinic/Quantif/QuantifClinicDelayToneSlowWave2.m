% QuantifClinicDelayToneSlowWave2
% 10.01.2017 KJ
%
% distributions of the delays after the tones
% -> Collect and save data 
%
%   see 
%       FigureDelayToneDelta QuantifClinicDelayToneSlowWave
%

%load
clear
eval(['load ' FolderPrecomputeDreem 'QuantifClinicDelayToneSlowWave.mat'])
conditionsWithTones = {'Random','UpPhase'};

%% Concatenate
%params
step = 40;
max_edge = 1200;
edges = 0:step:max_edge;
smoothing=2;


for ch=1:length(channels)

    delay_slowwave_tone1 = [];
    delay_slowwave_tone2 = [];
    for sstage=sleepstage_ind
        for p=1:length(delay_res.filename)
            if any(strcmpi(delay_res.condition{p}, conditionsWithTones))   
                delay_slowwave_tone1 = [delay_slowwave_tone1 ; delay_res.delay_slowwave_tone1{p,ch,sstage}'];
                delay_slowwave_tone2 = [delay_slowwave_tone2 ; delay_res.delay_slowwave_tone2{p,ch,sstage}'];
            end
        end
    end

    %first tone
    slow_waves.first.medians_delay = median(delay_slowwave_tone1(delay_slowwave_tone1/10<max_edge))/10;
    slow_waves.first.modes_delay = mode(delay_slowwave_tone1(delay_slowwave_tone1/10<max_edge))/10;
    h = histogram(delay_slowwave_tone1/10, edges,'Normalization','probability');
    slow_waves.first.histo.x{ch} = h.BinEdges(2:end) - step/2;
    slow_waves.first.histo.y{ch} = SmoothDec(h.Values,smoothing); close

    %second tone
    slow_waves.second.medians_delay = median(delay_slowwave_tone2(delay_slowwave_tone2/10<max_edge))/10;
    slow_waves.second.modes_delay = mode(delay_slowwave_tone2(delay_slowwave_tone2/10<max_edge))/10;
    h = histogram(delay_slowwave_tone2/10, edges,'Normalization','probability');
    slow_waves.second.histo.x{ch} = h.BinEdges(2:end) - step/2;
    slow_waves.second.histo.y{ch} = SmoothDec(h.Values,smoothing); close

end


%% plot
figure, hold on

for ch=1:length(channels)
    subplot(2,2,ch), hold on
    plot(slow_waves.first.histo.x{ch}, slow_waves.first.histo.y{ch}, 'color', 'k','linewidth',2), hold on,
    plot(slow_waves.second.histo.x{ch}, slow_waves.second.histo.y{ch}, 'color', 'b','linewidth',2), hold on,
    xlabel('time (ms)'),
    set(gca,'XTick',0:200:1500,'Ytick',0:0.01:0.05,'YLim',[0 0.1],'FontName','Times','fontsize',16), hold on,
    line([800 800],get(gca,'YLim'), 'color',[0.5 0.5 0.5],'linestyle','--'), hold on
    h_leg = legend('First Tones','Second Tones');
    set(h_leg,'FontSize',16);
    title(name_channels{ch}), hold on
    
end

