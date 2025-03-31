% DistribDelayToneShamDeltaMousePlot
% 11.07.2019 KJ
%
% quantification of the delay between a tone/sham and the next delta, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE, NREM
%
% Here, the data are plotted for each mouse
%
%   see DistribDelayToneShamDeltaPlot DistribDelayToneShamDelta DistribDelayToneShamEndDeltaMousePlot  
%       


clear

%load
load(fullfile(FolderDeltaDataKJ,'DistribDelayToneShamDelta.mat'))

animals = unique(tones_res.name)';

for m=1:length(animals)
    
    clearvars -except animals sham_res tones_res substages_ind m

    % %% params
    hstep = 10;
    max_edge = 500;
    edges = 0:hstep:max_edge;
    smoothing=2;
    proba_max = 0.046;
    
    substages_hist = 1:3;


    %% SHAM

    %Pool
    delay_sham = [];
    delay_rdmsham = [];
    for sub=substages_hist
        for p=1:length(sham_res.path)
            if strcmpi(sham_res.name{p},animals{m})
                delay_sham = [delay_sham ; sham_res.delay_sham{p,sub}];
                delay_rdmsham = [delay_rdmsham ; sham_res.delay_rdm{p,sub}];
            end
        end
    end
    delay_sham = delay_sham / 10; %in ms
    delay_rdmsham = delay_rdmsham / 10; %in ms

    %sham bci
    [sham.histo.y, sham.histo.x] = histcounts(delay_sham, edges, 'Normalization','probability');
    sham.histo.x = sham.histo.x(1:end-1) + diff(sham.histo.x);

    %sham random
    [rdmsham.histo.y, rdmsham.histo.x] = histcounts(delay_rdmsham, edges, 'Normalization','probability');
    rdmsham.histo.x = rdmsham.histo.x(1:end-1) + diff(rdmsham.histo.x);

    %% RANDOM AND DELTA-TRIGGERED

    %Pool
    delay_randomtone = [];
    delay_deltatone = [];
    for sub=substages_hist
        for p=1:length(tones_res.path)
            if strcmpi(tones_res.name{p},animals{m}) 
                if strcmpi(tones_res.manipe{p},'RdmTone')
                    delay_randomtone = [delay_randomtone ; tones_res.delay_deltatone{p,sub}];
                else
                    delay_deltatone = [delay_deltatone ; tones_res.delay_deltatone{p,sub}];
                end
            end
        end
    end
    delay_randomtone = delay_randomtone / 10; %in ms
    delay_deltatone = delay_deltatone / 10; %in ms

    %RANDOM
    [random.histo.y, random.histo.x] = histcounts(delay_randomtone, edges, 'Normalization','probability');
    random.histo.x = random.histo.x(1:end-1) + diff(random.histo.x);

    %DELTA Triggered
    [deltas.histo.y, deltas.histo.x] = histcounts(delay_deltatone, edges, 'Normalization','probability');
    deltas.histo.x = deltas.histo.x(1:end-1) + diff(deltas.histo.x);


    %% DATA to plot
    [sham.plot.x, sham.plot.y] = stairs(sham.histo.x, sham.histo.y);
    [rdmsham.plot.x, rdmsham.plot.y] = stairs(rdmsham.histo.x, rdmsham.histo.y);
    [random.plot.x, random.plot.y] = stairs(random.histo.x, random.histo.y);
    [deltas.plot.x, deltas.plot.y] = stairs(deltas.histo.x, deltas.histo.y);


    %% plot

    %Delta delay distribution
    figure, hold on
    h(1) = plot(sham.plot.x, sham.plot.y, 'k', 'LineWidth',4); hold on,
    h(2) = plot(random.plot.x, random.plot.y, 'color',[0.85 0.85 0.85], 'LineWidth',4); hold on,
    h(3) = plot(deltas.plot.x, deltas.plot.y, 'color',[0.65 0.76 0.46], 'LineWidth',4); hold on,
    h(4) = plot(rdmsham.plot.x, rdmsham.plot.y, 'color','b', 'LineWidth',4); hold on,


    xlabel('time from tones/sham(ms)'), ylabel('density of tones/sham')
    set(gca,'XTick',0:100:max_edge-100,'XLim',[0 max_edge],'Ytick',0:0.02:proba_max, 'FontName','Times','fontsize',26), hold on,
    title(animals{m})

    legend(h,'Sham','Random tones','Delta-triggered tones ', 'Rdm sham')
    

end

