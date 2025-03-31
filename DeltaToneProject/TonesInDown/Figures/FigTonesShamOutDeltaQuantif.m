%%FigTonesShamOutDeltaQuantif
% 02.09.2019 KJ
%
% effect of tones in Up states
%
%   see 
%       FigTonesInUpN2N3
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'TonesOutDeltaQuantif.mat'))
load(fullfile(FolderDeltaDataKJ,'ShamOutDeltaQuantif.mat'))


%params
%distrib delay after tones
edges_delay = 0:10:1000;
edges_norm = 0:0.05:1;
%probability
delay_up = 50:50:800;
x_up = delay_up(1:end-1) + diff(delay_up)/2;
%phase
edges_phase = 0:20:360;
x_phase = edges_phase(1:end-1) + diff(edges_phase)/2;

%animals
animals = unique(tones_res.name);


%% Delay between tones/sham and next delta

%tones
for p=1:length(tones_res.path)
    [nights.d_after.tones{p}, nights.x_after.tones{p}] = histcounts(tones_res.delay_after{p}/10, edges_delay, 'Normalization','probability');
    nights.x_after.tones{p} = nights.x_after.tones{p}(1:end-1) + diff(nights.x_after.tones{p});
end

%sham
for p=1:length(sham_res.path)
    [nights.d_after.sham{p}, nights.x_after.sham{p}] = histcounts(sham_res.delay_after{p}/10, edges_delay, 'Normalization','probability');
    nights.x_after.sham{p} = nights.x_after.sham{p}(1:end-1) + diff(nights.x_after.sham{p});
end


%average distributions
d_after.tones = [];
x_after.tones = nights.x_after.tones{1};
d_after.sham  = [];
x_after.sham  = nights.x_after.sham{1};

%tones
for m=1:length(animals)
    nrem_after_mouse = [];
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            nrem_after_mouse = [nrem_after_mouse ; nights.d_after.tones{p}];
        end
    end
    d_after.tones   = [d_after.tones ; mean(nrem_after_mouse,1)];
end
%sham
for m=1:length(animals)
    nrem_after_mouse = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            nrem_after_mouse = [nrem_after_mouse ; nights.d_after.sham{p}];
        end
    end
    d_after.sham   = [d_after.sham ; mean(nrem_after_mouse,1)];
end


%mean & std NREM
std_after.tones    = std(d_after.tones,1) / sqrt(size(d_after.tones,1));
d_after.tones      = mean(d_after.tones,1);
std_after.sham    = std(d_after.sham,1) / sqrt(size(d_after.sham,1));
d_after.sham      = mean(d_after.sham,1);



%% probability of transition after down/sham


%Tones
tones.induce = cell(0);
for m=1:length(animals)
    
    delay_mouse   = [];
    delay_after   = [];
    success_mouse = [];
    phase_mouse   = [];
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            delay_mouse   = [delay_mouse ; tones_res.delay_before{p}/10];
            delay_after   = [delay_after ; tones_res.delay_after{p}/10];
            success_mouse = [success_mouse ; tones_res.induce_delta{p}];
            phase_mouse   = [phase_mouse ; tones_res.phasedeep{p}];
        end
    end
    phase_mouse = mod(phase_mouse*180/pi,360);
    norm_mouse = delay_mouse ./ (delay_mouse + delay_after);
    
    for i=1:length(delay_up)-1
        tones.induce{i}(1,m) = mean(success_mouse(delay_mouse>=delay_up(i) & delay_mouse<delay_up(i+1))*100);
    end
    for i=1:length(edges_phase)-1
        tones.phaseind{i}(1,m) = mean(success_mouse(phase_mouse>=edges_phase(i) & phase_mouse<edges_phase(i+1))*100);
        tones.phasenorm{m}(i)  = mean(norm_mouse(phase_mouse>=edges_phase(i) & phase_mouse<edges_phase(i+1)));
    end
    
end

%Sham
sham.induce = cell(0);
for m=1:length(animals)
    
    delay_mouse   = [];
    delay_after   = [];
    success_mouse = [];
    phase_mouse   = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            delay_mouse   = [delay_mouse ; sham_res.delay_before{p}/10];
            delay_after   = [delay_after ; sham_res.delay_after{p}/10];
            success_mouse = [success_mouse ; sham_res.induce_delta{p}];
            phase_mouse   = [phase_mouse ; sham_res.phasedeep{p}];
        end
    end
    phase_mouse = mod(phase_mouse*180/pi,360);
    norm_mouse = delay_mouse ./ (delay_mouse + delay_after);
    
    for i=1:length(delay_up)-1
        sham.induce{i}(1,m) = mean(success_mouse(delay_mouse>=delay_up(i) & delay_mouse<delay_up(i+1))*100);
    end
    for i=1:length(edges_phase)-1
        sham.phaseind{i}(1,m) = mean(success_mouse(phase_mouse>=edges_phase(i) & phase_mouse<edges_phase(i+1))*100);
        sham.phasenorm{m}(i)  = mean(norm_mouse(phase_mouse>=edges_phase(i) & phase_mouse<edges_phase(i+1)));
    end
end


%replicate pĥase data (from 0 to 720)
x_phase = [x_phase x_phase+360];
tones.phaseind = [tones.phaseind tones.phaseind];
sham.phaseind = [sham.phaseind sham.phaseind];
for m=1:length(animals)
    tones.phasenorm{m} = [tones.phasenorm{m} tones.phasenorm{m}];
    sham.phasenorm{m}  = [sham.phasenorm{m} sham.phasenorm{m}];
end

%% phase and delay

%Tones
tones.delay_before = [];
tones.delay_after  = [];
tones.phasedeep    = [];
for p=1:length(tones_res.path)
    tones.delay_before = [tones.delay_before ; tones_res.delay_before{p}/10];
    tones.delay_after  = [tones.delay_after ; tones_res.delay_after{p}/10];
    tones.phasedeep    = [tones.phasedeep ; tones_res.phasedeep{p}];
end
tones.phasedeep = mod(tones.phasedeep*180/pi,360);
tones.norm_pos = tones.delay_before ./ (tones.delay_before + tones.delay_after);

Matnorm.tones = [];
for i=1:length(edges_phase)-1
    %phase index
    idph = tones.phasedeep>=edges_phase(i) & tones.phasedeep<edges_phase(i+1);
    %histo of normalized position for the selected phase
    [yh, xh] = histcounts(tones.delay_before(idph), edges_delay, 'Normalization','probability');
    xh = xh(1:end-1);
    Matnorm.tones = [Matnorm.tones yh'];
end
Matnorm.tones = [Matnorm.tones Matnorm.tones];

%Sham
sham.delay_before = [];
sham.delay_after  = [];
sham.phasedeep    = [];
for p=1:length(sham_res.path)
    sham.delay_before = [sham.delay_before ; sham_res.delay_before{p}/10];
    sham.delay_after  = [sham.delay_after ; sham_res.delay_after{p}/10];
    sham.phasedeep    = [sham.phasedeep ; sham_res.phasedeep{p}];
end
sham.phasedeep = mod(sham.phasedeep*180/pi,360);
sham.norm_pos = sham.delay_before ./ (sham.delay_before + sham.delay_after);

Matnorm.sham = [];
for i=1:length(edges_phase)-1
    %phase index
    idph = sham.phasedeep>=edges_phase(i) & sham.phasedeep<edges_phase(i+1);
    %histo of normalized position for the selected phase
    [yh, xh] = histcounts(sham.delay_before(idph), edges_delay, 'Normalization','probability');
    xh = xh(1:end-1);
    Matnorm.sham = [Matnorm.sham yh'];
end
Matnorm.sham = [Matnorm.sham Matnorm.sham];


%% PLOT
gap = [0.1 0.04];
smoothing = 1;
fontsize = 13;
paired = 1;
optiontest = 'ranksum';


figure, hold on

%Distrib of end of Up states after tones/sham
clear h
subplot(2,2,1), hold on

Hs(1) = shadedErrorBar(x_after.tones, d_after.tones, std_after.tones,{'markerfacecolor','b'},0.4);
Hs(2) = shadedErrorBar(x_after.sham, d_after.sham, std_after.sham,{'markerfacecolor','r'},0.4);
h(1) = plot(x_after.tones, Smooth(d_after.tones, 0), 'color', 'b', 'linewidth',2);
h(2) = plot(x_after.sham, Smooth(d_after.sham, 0), 'color', 'r', 'linewidth',2);

set(gca,'ylim', [0 0.03], 'ytick',0:0.02:0.1, 'Fontsize',fontsize),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('time from tones/sham (ms)'),
legend(h,'tones','sham'),
title('occurence of next delta waves - NREM'),

%probability of transitions (delay down before)
clear h
subplot(2,2,3), hold on
[~,h(1)]=PlotErrorLineN_KJ(tones.induce,'x_data',x_up,'newfig',0,'linecolor','b','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(sham.induce,'x_data',x_up,'newfig',0,'linecolor','r','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('delay (ms) between Up start and tones/sham'), ylabel('%')
set(gca,'XTick',0:200:max(delay_up),'XLim',[50 max(delay_up)],'Ylim', [0 100], 'FontName','Times','Fontsize',fontsize), hold on,
legend(h,'tones','sham'),
title('Probability of up>down transition')



%probability of transitions (phase of tone)
% 0-360 degree on peak
% 180 degree on trough
clear h
subplot(3,2,2), hold on
[~,h(1)]=PlotErrorLineN_KJ(tones.phaseind,'x_data',x_phase,'newfig',0,'linecolor','b','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(sham.phaseind,'x_data',x_phase,'newfig',0,'linecolor','r','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('Phase of tones/sham'), ylabel('%')
set(gca,'XTick',0:200:max(x_phase),'XLim',[0 max(x_phase+10)],'Ylim', [0 100], 'FontName','Times','Fontsize',fontsize), hold on,

yyaxis right
x_1 = min(x_phase):1:max(x_phase);
y_1 = cos(x_1*2*pi/360);
hold on, plot(x_1, y_1, 'k'),
set(gca,'ylim', [-6 1.2], 'ytick', []),
title('Probability of up>delta transition')


% delay and phases
subplot(3,2,4), hold on
imagesc(x_phase, edges_delay(1:end-1), Matnorm.tones), hold on
axis xy, hold on
set(gca,'YLim', [0 1000], 'XLim',[0 720],'Fontsize',fontsize);
xlabel('phases of tones'), ylabel('Normalized position in Up States'),
title('probability of position in Up with phases')
% delay and phases
subplot(3,2,6), hold on
imagesc(x_phase, edges_delay(1:end-1), Matnorm.sham), hold on
axis xy, hold on
set(gca,'YLim', [0 1000], 'XLim',[0 720],'Fontsize',fontsize);
xlabel('phases of sham'),


% % delay and phases
% clear h
% subplot(2,2,4), hold on
% for m=1:length(animals)
%     h(1) = plot(x_phase, tones.phasenorm{m} ,'b');
%     h(2) = plot(x_phase, sham.phasenorm{m} ,'r');
% end
% xlabel('Phase of tones/sham'), ylabel('Normalized position in Up States')
% set(gca,'XTick',0:200:max(x_phase),'XLim',[0 max(x_phase+10)],'Ylim', [0 1], 'FontName','Times','Fontsize',fontsize), hold on,
% 
% yyaxis right
% x_1 = min(x_phase):1:max(x_phase);
% y_1 = cos(x_1*2*pi/360);
% hold on, plot(x_1, y_1, 'k'),
% set(gca,'ylim', [-6 1.2], 'ytick', []),
% title('Phases and delay')




