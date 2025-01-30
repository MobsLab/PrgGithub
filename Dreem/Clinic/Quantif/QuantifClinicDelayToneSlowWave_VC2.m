% QuantifClinicDelayToneSlowWave_VC2
% 26.06.2017 KJ
%
% distributions of the delays after the tones
% -> Collect and save data 
%
%   see 
%       QuantifClinicDelayToneSlowWave_VC QuantifClinicDelayToneSlowWave2
%

%load
clear
eval(['load ' FolderPrecomputeDreem 'QuantifClinicDelayToneSlowWave_VC.mat'])
conditionsWithTones = {'Random','UpPhase'};
conditionSham = {'Sham'};
name_channels = {'VC Dreem','VC Actiwave'};

%% Concatenate
%params
step = 40;
max_edge = 1200;
edges = 0:step:max_edge;
smoothing=2;


%% DREEM

%tone
delay_slowwave_tone1 = [];
delay_slowwave_tone2 = [];
for sstage=sleepstage_ind
    for p=1:length(delay_res.filename)
        if any(strcmpi(delay_res.condition{p}, conditionsWithTones))   
            delay_slowwave_tone1 = [delay_slowwave_tone1 ; delay_res.dreem.delay_slowwave_tone1{p,sstage}'];
            delay_slowwave_tone2 = [delay_slowwave_tone2 ; delay_res.dreem.delay_slowwave_tone2{p,sstage}'];
        end
    end
end

%sham
delay_slowwave_sham = [];
for sstage=sleepstage_ind
    for p=1:length(delay_res.filename)
        if any(strcmpi(delay_res.condition{p}, conditionSham))   
            delay_slowwave_sham = [delay_slowwave_sham ; delay_res.dreem.delay_slowwave_tone1{p,sstage}'];
            delay_slowwave_sham = [delay_slowwave_sham ; delay_res.dreem.delay_slowwave_tone2{p,sstage}'];
        end
    end
end

%first tone
slow_waves.first.medians_delay = median(delay_slowwave_tone1(delay_slowwave_tone1/10<max_edge))/10;
slow_waves.first.modes_delay = mode(delay_slowwave_tone1(delay_slowwave_tone1/10<max_edge))/10;
h = histogram(delay_slowwave_tone1/10, edges,'Normalization','probability');
slow_waves.first.histo.x{1} = h.BinEdges(2:end) - step/2;
slow_waves.first.histo.y{1} = SmoothDec(h.Values,smoothing); close

%second tone
slow_waves.second.medians_delay = median(delay_slowwave_tone2(delay_slowwave_tone2/10<max_edge))/10;
slow_waves.second.modes_delay = mode(delay_slowwave_tone2(delay_slowwave_tone2/10<max_edge))/10;
h = histogram(delay_slowwave_tone2/10, edges,'Normalization','probability');
slow_waves.second.histo.x{1} = h.BinEdges(2:end) - step/2;
slow_waves.second.histo.y{1} = SmoothDec(h.Values,smoothing); close

%sham
slow_waves.sham.medians_delay = median(delay_slowwave_sham(delay_slowwave_sham/10<max_edge))/10;
slow_waves.sham.modes_delay = mode(delay_slowwave_sham(delay_slowwave_sham/10<max_edge))/10;
h = histogram(delay_slowwave_sham/10, edges,'Normalization','probability');
slow_waves.sham.histo.x{1} = h.BinEdges(2:end) - step/2;
slow_waves.sham.histo.y{1} = SmoothDec(h.Values,smoothing); close

%% ACTIWAVE

%tone
delay_slowwave_tone1 = [];
delay_slowwave_tone2 = [];
for sstage=sleepstage_ind
    for p=1:length(delay_res.filename)
        if any(strcmpi(delay_res.condition{p}, conditionsWithTones))   
            delay_slowwave_tone1 = [delay_slowwave_tone1 ; delay_res.psg.delay_slowwave_tone1{p,sstage}'];
            delay_slowwave_tone2 = [delay_slowwave_tone2 ; delay_res.psg.delay_slowwave_tone2{p,sstage}'];
        end
    end
end

%sham
delay_slowwave_sham = [];
for sstage=sleepstage_ind
    for p=1:length(delay_res.filename)
        if any(strcmpi(delay_res.condition{p}, conditionSham))   
            delay_slowwave_sham = [delay_slowwave_sham ; delay_res.psg.delay_slowwave_tone1{p,sstage}'];
            delay_slowwave_sham = [delay_slowwave_sham ; delay_res.psg.delay_slowwave_tone2{p,sstage}'];
        end
    end
end

%first tone
slow_waves.first.medians_delay = median(delay_slowwave_tone1(delay_slowwave_tone1/10<max_edge))/10;
slow_waves.first.modes_delay = mode(delay_slowwave_tone1(delay_slowwave_tone1/10<max_edge))/10;
h = histogram(delay_slowwave_tone1/10, edges,'Normalization','probability');
slow_waves.first.histo.x{2} = h.BinEdges(2:end) - step/2;
slow_waves.first.histo.y{2} = SmoothDec(h.Values,smoothing); close

%second tone
slow_waves.second.medians_delay = median(delay_slowwave_tone2(delay_slowwave_tone2/10<max_edge))/10;
slow_waves.second.modes_delay = mode(delay_slowwave_tone2(delay_slowwave_tone2/10<max_edge))/10;
h = histogram(delay_slowwave_tone2/10, edges,'Normalization','probability');
slow_waves.second.histo.x{2} = h.BinEdges(2:end) - step/2;
slow_waves.second.histo.y{2} = SmoothDec(h.Values,smoothing); close

%sham
slow_waves.sham.medians_delay = median(delay_slowwave_sham(delay_slowwave_sham/10<max_edge))/10;
slow_waves.sham.modes_delay = mode(delay_slowwave_sham(delay_slowwave_sham/10<max_edge))/10;
h = histogram(delay_slowwave_sham/10, edges,'Normalization','probability');
slow_waves.sham.histo.x{2} = h.BinEdges(2:end) - step/2;
slow_waves.sham.histo.y{2} = SmoothDec(h.Values,smoothing); close


%% plot
figure, hold on

for ch=1:2
    subplot(2,1,ch), hold on
    plot(slow_waves.first.histo.x{ch}, slow_waves.first.histo.y{ch}, 'color', 'k','linewidth',2), hold on,
    plot(slow_waves.second.histo.x{ch}, slow_waves.second.histo.y{ch}, 'color', 'b','linewidth',2), hold on,
    plot(slow_waves.sham.histo.x{ch}, slow_waves.sham.histo.y{ch}, 'color', [0.7 0.7 0.7],'linewidth',1), hold on,
    xlabel('time (ms)'),
    set(gca,'XTick',0:200:1500,'Ytick',0:0.01:0.05,'YLim',[0 0.1],'FontName','Times','fontsize',16), hold on,
    line([600 600],get(gca,'YLim'), 'color',[0.5 0.5 0.5],'linestyle','--'), hold on
    h_leg = legend('First Tones','Second Tones');
    set(h_leg,'FontSize',16);
    title(name_channels{ch}), hold on
    
end

