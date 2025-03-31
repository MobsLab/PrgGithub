% DownToneRefractoryPeriodAnalysisPlot
% 17.07.2019 KJ
%
% Success rate in function of the delay between down states and tones
% 
%   SEE 
%       DownToneRefractoryPeriodAnalysis DeltaToneRefractoryPeriodAnalysisPlot
%



clear

%params
thresh_delay = 4E4; %4sec - maximum delay between a delta and the next tone, for the raster
perc = 0:5:100;

%load
load(fullfile(FolderDeltaDataKJ,'DownToneRefractoryPeriodAnalysis.mat'))
animals = unique(refract_res.name);
% animals = animals(7);
% disp(animals)


%%  Random Tones
for m=1:length(animals)
    
    down_delay     = [];
    down_induced   = [];
    down_substage  = [];
    down_tonein    = [];
    for p=1:length(refract_res.path)
        if strcmpi(refract_res.name{p},animals{m})
            down_delay     = [down_delay ; refract_res.delay{p}];
            down_induced   = [down_induced ; refract_res.induced{p}];
            down_substage  = [down_substage ; refract_res.substage_tone{p}'];
            down_tonein    = [down_tonein ; refract_res.tones_in{p}'];
        end
    end
    
    
    [sort_delay,idx_delay] = sort(down_delay,'ascend');
    idx_delay(sort_delay>thresh_delay) = [];

    rdmtones.delay{m}     = down_delay(idx_delay);
    rdmtones.induce{m}    = down_induced(idx_delay);
    rdmtones.substage{m}  = down_substage(idx_delay);
    rdmtones.tonein{m}    = down_tonein(idx_delay);
end


%percentile
all_delay = cell2mat(rdmtones.delay(:));
all_delay = all_delay(all_delay<7000);
percentiles_delta = prctile(all_delay,perc);
xdata_random = (percentiles_delta(1:end-1)) / 10;

% For each animal - N2+N3
for m=1:length(animals)
    %delta
    delay = rdmtones.delay{m};
    restrictions = (rdmtones.substage{m}==2 | rdmtones.substage{m}==3) & (rdmtones.tonein{m}==0);
    for i=1:length(percentiles_delta)-1
        restrict_tones.induce(m,i) = sum(rdmtones.induce{m}(restrictions & delay>=percentiles_delta(i) & delay<percentiles_delta(i+1)));
        restrict_tones.number(m,i) = sum(restrictions & delay>=percentiles_delta(i) & delay<percentiles_delta(i+1));
    end
end
% Data for PlotLineError 
percentage_tones.random = (restrict_tones.induce ./ restrict_tones.number)*100;



%% Random Sham
for m=1:length(animals)
    
    down_delay     = [];
    down_induced   = [];
    down_substage  = [];
    down_shamin   = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            down_delay     = [down_delay ; sham_res.delay{p}];
            down_induced   = [down_induced ; sham_res.induced{p}];
            down_substage  = [down_substage ; sham_res.substage_sham{p}'];
            down_shamin   = [down_shamin ; sham_res.sham_in{p}'];
        end
    end
    
    
    [sort_delay,idx_delay] = sort(down_delay,'ascend');
    idx_delay(sort_delay>thresh_delay) = [];

    rdmsham.delay{m}     = down_delay(idx_delay);
    rdmsham.induce{m}    = down_induced(idx_delay);
    rdmsham.substage{m}  = down_substage(idx_delay);
    rdmsham.shamin{m}    = down_shamin(idx_delay);
end

%percentile
all_delay = cell2mat(rdmsham.delay(:));
all_delay = all_delay(all_delay<7000);
percentiles_delta = prctile(all_delay,perc);
xdata_sham = (percentiles_delta(1:end-1)) / 10;

% For each animal - N2+N3
for m=1:length(animals)
    %delta
    delay = rdmsham.delay{m};
    restrictions = (rdmsham.substage{m}==2 | rdmsham.substage{m}==3) & (rdmsham.shamin{m}==0);
    for i=1:length(percentiles_delta)-1
        restrict_sham.induce(m,i) = sum(rdmsham.induce{m}(restrictions & delay>=percentiles_delta(i) & delay<percentiles_delta(i+1)));
        restrict_sham.number(m,i) = sum(restrictions & delay>=percentiles_delta(i) & delay<percentiles_delta(i+1));
    end
end
% Data for PlotLineError 
percentage_sham.random = (restrict_sham.induce ./ restrict_sham.number)*100;


%% PLOT

%Line
figure, hold on
[~,h(1)]=PlotErrorLineN_KJ(percentage_tones.random,'x_data',xdata_random,'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(percentage_sham.random,'x_data',xdata_sham,'newfig',0,'linecolor',[0.75 0.75 0.75],'ShowSigstar','none','errorbars',1,'linespec','-.');

legend(h,'Random tone', 'Random Sham')
title('Success rate for Delta triggered and Random Condition','fontsize',16)
set(gca,'XTick',0:100:700,'Xlim',[-20 720],'YTick',0:20:80,'YLim',[0 100],'FontName','Times','fontsize',20), hold on,
ylabel('% of tones evoking a down states'), xlabel('delay between delta waves occurence and auditory stimuli')










