% DeltaToneRefractoryPeriodAnalysisPlot
% 11.07.2019 KJ
%
% Success rate in function of the delay between delta waves and tones (in DeltaToneConditions)
% 
%   SEE 
%       DeltaToneRefractoryPeriodAnalysis
%       DeltaToneRefractoryPeriodAnalysisData FigureSuccessRateDelay2
%

clear

%params
thresh_delay = 4E4; %4sec - maximum delay between a delta and the next tone, for the raster
perc = 0:5:100;
delay_max = 0.95e4;
range_delays = (50:50:850)*10;

color_sham = [0.3 0.3 0.3];
color_rdm = [0 0 1];
color_bci = [0 0.5 0];

%load
load(fullfile(FolderDeltaDataKJ,'DeltaToneRefractoryPeriodAnalysis.mat'))
load(fullfile(FolderDeltaDataKJ,'DeltaToneBciEfficiency.mat'))
animals = unique(refract_res.name);


%%  Random Tones
for m=1:length(animals)
    
    delta_delay     = [];
    delta_induced   = [];
    delta_substage  = [];
    delta_tonein    = [];
    for p=1:length(refract_res.path)
        if strcmpi(refract_res.name{p},animals{m})
            delta_delay     = [delta_delay ; refract_res.delay{p}];
            delta_induced   = [delta_induced ; refract_res.induced{p}];
            delta_substage  = [delta_substage ; refract_res.substage_tone{p}'];
            delta_tonein    = [delta_tonein ; refract_res.tones_in{p}'];
        end
    end
    
    
    [sort_delay,idx_delay] = sort(delta_delay,'ascend');
    idx_delay(sort_delay>thresh_delay) = [];

    rdmtones.delay{m}     = delta_delay(idx_delay);
    rdmtones.induce{m}    = delta_induced(idx_delay);
    rdmtones.substage{m}  = delta_substage(idx_delay);
    rdmtones.tonein{m}    = delta_tonein(idx_delay);
end


%percentile
xdata_random = (range_delays(1:end-1)) / 10;

% For each animal - N2+N3
for m=1:length(animals)
    %delta
    delay = rdmtones.delay{m};
    restrictions = (rdmtones.substage{m}==2 | rdmtones.substage{m}==3) & (rdmtones.tonein{m}==0);
    for i=1:length(range_delays)-1
        restrict_tones.induce(m,i) = sum(rdmtones.induce{m}(restrictions & delay>=range_delays(i) & delay<range_delays(i+1)));
        restrict_tones.number(m,i) = sum(restrictions & delay>=range_delays(i) & delay<range_delays(i+1));
    end
end
% Data for PlotLineError 
percentage_tones.random = (restrict_tones.induce ./ restrict_tones.number)*100;



%% Random Sham
for m=1:length(animals)
    
    delta_delay     = [];
    delta_induced   = [];
    delta_substage  = [];
    delta_shamin    = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            delta_delay     = [delta_delay ; sham_res.delay{p}];
            delta_induced   = [delta_induced ; sham_res.induced{p}];
            delta_substage  = [delta_substage ; sham_res.substage_sham{p}'];
            delta_shamin    = [delta_shamin ; sham_res.sham_in{p}'];
        end
    end
    
    
    [sort_delay,idx_delay] = sort(delta_delay,'ascend');
    idx_delay(sort_delay>thresh_delay) = [];

    rdmsham.delay{m}     = delta_delay(idx_delay);
    rdmsham.induce{m}    = delta_induced(idx_delay);
    rdmsham.substage{m}  = delta_substage(idx_delay);
    rdmsham.shamin{m}    = delta_shamin(idx_delay);
end

%percentile
xdata_sham = (range_delays(1:end-1)) / 10;

% For each animal - N2+N3
for m=1:length(animals)
    %delta
    delay = rdmsham.delay{m};
    restrictions = (rdmsham.substage{m}==2 | rdmsham.substage{m}==3) & (rdmsham.shamin{m}==0);
    for i=1:length(range_delays)-1
        restrict_sham.induce(m,i) = sum(rdmsham.induce{m}(restrictions & delay>=range_delays(i) & delay<range_delays(i+1)));
        restrict_sham.number(m,i) = sum(restrictions & delay>=range_delays(i) & delay<range_delays(i+1));
    end
end
% Data for PlotLineError 
percentage_sham.random = (restrict_sham.induce ./ restrict_sham.number)*100;


%%  Close-loop Tones
for m=1:length(animals)
    
    delta_trig      = [];
    delta_delay     = [];
    delta_induced   = [];
    delta_substage  = [];
    delta_tonein    = [];
    for p=1:length(bci_res.path)
        if strcmpi(bci_res.name{p},animals{m})
            d = bci_res.delay{p}*1000;            
            delta_delay     = [delta_delay ; d*ones(length(bci_res.triggered{p}*d),1)];
            delta_induced   = [delta_induced ; bci_res.induced{p}];
            delta_substage  = [delta_substage ; bci_res.substage_tone{p}'];
            delta_tonein    = [delta_tonein ; bci_res.tones_in{p}'];
        end
    end
    
    [sort_delay,idx_delay] = sort(delta_delay,'ascend');
    idx_delay(sort_delay>thresh_delay) = [];

    bcitones.delay{m}     = delta_delay(idx_delay);
    bcitones.induce{m}    = delta_induced(idx_delay);
    bcitones.substage{m}  = delta_substage(idx_delay);
    bcitones.tonein{m}    = delta_tonein(idx_delay);
end


%percentile
all_delay = cell2mat(bcitones.delay(:));
all_delay = all_delay(all_delay<delay_max);
bci_delays = [140 320 490];
xdata_bci = [140 320 500];

% For each animal - N2+N3
for m=1:length(animals)
    %delta
    delay = bcitones.delay{m};
    restrictions = (bcitones.substage{m}==2 | bcitones.substage{m}==3) & (bcitones.tonein{m}==0);
    for i=1:length(bci_delays)
        restrict_bci.induce(m,i) = sum(bcitones.induce{m}(restrictions & delay==bci_delays(i)));
        restrict_bci.number(m,i) = sum(restrictions & delay==bci_delays(i));
    end
end
% Data for PlotLineError 
percentage_tones.bci = (restrict_bci.induce ./ restrict_bci.number)*100;



%% PLOT

%Line
figure, hold on
[~,h(2)]=PlotErrorLineN_KJ(percentage_tones.random,'x_data',xdata_random,'newfig',0,'linecolor',color_rdm, 'ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(3)]=PlotErrorLineN_KJ(percentage_sham.random,'x_data',xdata_sham,'newfig',0,'linecolor',color_sham,'ShowSigstar','none','errorbars',1,'linespec','-.');
PlotErrorLineN_KJ(percentage_tones.bci,'x_data',xdata_bci,'newfig',0,'linecolor',color_bci,'ShowSigstar','none','errorbars',1,'linespec','-o');
h(1) = scatter(xdata_bci, nanmean(percentage_tones.bci), 150, color_bci, 'filled');

legend(h,'Close-loop','Random tone', 'Sham')
title('Success rate for Delta triggered and Random Condition','fontsize',16)
set(gca,'XTick',0:100:900,'Xlim',[0 820],'YTick',0:20:80,'YLim',[0 60],'FontName','Times','fontsize',20), hold on,
ylabel('% of tones (or sham) inducing a delta waves'), xlabel('time from preceding delta waves (ms)')










