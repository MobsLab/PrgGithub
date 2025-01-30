% DistribDelayRipplesToDownMousePlot
% 27.07.2019 KJ
%
% quantification of the delay between a tone/sham and the next down, 
% for different substages
%   UP to Down
%
% Here, the data are plotted for each mouse
%
%   see DistribDelayRipplesToDown DistribDelayToneShamEndDeltaMousePlot  
%       


clear

%load
load(fullfile(FolderDeltaDataKJ,'DistribDelayRipplesToDown.mat'))

animals = unique(delay_res.name)';

for m=1:length(animals)
    
    clearvars -except animals delay_res substages_ind m

    % %% params
    hstep = 10;
    max_edge = 1000;
    edges = 0:hstep:max_edge;
    proba_max = 0.046;
    
    substages_hist = 1:3;


    %% SHAM

    %Pool
    delay_rdmsham = [];
    for sub=substages_hist
        for p=1:length(delay_res.path)
            if strcmpi(delay_res.name{p},animals{m})
                delay_rdmsham = [delay_rdmsham ; delay_res.delay_rdm{p,sub}];
            end
        end
    end
    delay_rdmsham = delay_rdmsham / 10; %in ms

    %sham random
    delay_rdmsham(delay_rdmsham>max_edge)=[];
    [rdmsham.histo.y, rdmsham.histo.x] = histcounts(delay_rdmsham, edges, 'Normalization','probability');
    rdmsham.histo.x = rdmsham.histo.x(1:end-1) + diff(rdmsham.histo.x)/2;

    %% RANDOM Tones

    %Pool
    delay_ripples = [];
    for sub=substages_hist
        for p=1:length(delay_res.path)
            if strcmpi(delay_res.name{p},animals{m}) 
                delay_ripples = [delay_ripples ; delay_res.delay_ripples{p,sub}];
            end
        end
    end
    delay_ripples = delay_ripples / 10; %in ms

    %RANDOM
    delay_ripples(delay_ripples>max_edge)=[];
    [ripples.histo.y, ripples.histo.x] = histcounts(delay_ripples, edges, 'Normalization','probability');
    ripples.histo.x = ripples.histo.x(1:end-1) + diff(ripples.histo.x)/2;


    %% DATA to plot
    [rdmsham.plot.x, rdmsham.plot.y] = stairs(rdmsham.histo.x, rdmsham.histo.y);
    [ripples.plot.x, ripples.plot.y] = stairs(ripples.histo.x, ripples.histo.y);


    %% plot

    %Delta delay distribution
    figure, hold on
    h(1) = plot(ripples.histo.x, ripples.histo.y, 'color','b', 'LineWidth',4); hold on,
    h(2) = plot(rdmsham.histo.x, rdmsham.histo.y, 'color','r', 'LineWidth',4); hold on,


    xlabel('time from ripples/sham(ms)'), ylabel('density of transitions')
    set(gca,'XTick',0:100:max_edge-100,'XLim',[0 max_edge],'Ytick',0:0.02:proba_max, 'FontName','Times','fontsize',26), hold on,
    title(animals{m})

    legend(h,'Ripples', 'Rdm sham')
    

end


