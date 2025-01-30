% DistribDelayToneShamEndDeltaMousePlot
% 24.07.2019 KJ
%
% quantification of the delay between a tone/sham in a delta and the end of the delta, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE, NREM
%
% Here, the data are plotted for each mouse
%
%   see DistribDelayToneShamEndDelta DistribDelayToneShamDeltaMousePlot  
%       


clear

%load
load(fullfile(FolderDeltaDataKJ,'DistribDelayToneShamEndDelta.mat'))

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
    delay_rdmsham = [];
    for sub=substages_hist
        for p=1:length(sham_res.path)
            if strcmpi(sham_res.name{p},animals{m})
                delay_rdmsham = [delay_rdmsham ; sham_res.delay_rdm{p,sub}];
            end
        end
    end
    delay_rdmsham = delay_rdmsham / 10; %in ms

    %sham random
    [rdmsham.histo.y, rdmsham.histo.x] = histcounts(delay_rdmsham, edges, 'Normalization','probability');
    rdmsham.histo.x = rdmsham.histo.x(1:end-1) + diff(rdmsham.histo.x);

    %% RANDOM Tones

    %Pool
    delay_randomtone = [];
    for sub=substages_hist
        for p=1:length(tones_res.path)
            if strcmpi(tones_res.name{p},animals{m}) 
                delay_randomtone = [delay_randomtone ; tones_res.delay_deltatone{p,sub}];
            end
        end
    end
    delay_randomtone = delay_randomtone / 10; %in ms

    %RANDOM
    [random.histo.y, random.histo.x] = histcounts(delay_randomtone, edges, 'Normalization','probability');
    random.histo.x = random.histo.x(1:end-1) + diff(random.histo.x);


    %% DATA to plot
    [rdmsham.plot.x, rdmsham.plot.y] = stairs(rdmsham.histo.x, rdmsham.histo.y);
    [random.plot.x, random.plot.y] = stairs(random.histo.x, random.histo.y);


    %% plot

    %Delta delay distribution
    figure, hold on
    h(1) = plot(random.histo.x, random.histo.y, 'color','b', 'LineWidth',4); hold on,
    h(2) = plot(rdmsham.histo.x, rdmsham.histo.y, 'color','r', 'LineWidth',4); hold on,


    xlabel('time from tones/sham(ms)'), ylabel('density of tones/sham')
    set(gca,'XTick',0:100:max_edge-100,'XLim',[0 max_edge],'Ytick',0:0.02:proba_max, 'FontName','Times','fontsize',26), hold on,
    title(animals{m})

    legend(h,'Random tones', 'Rdm sham')
    

end

