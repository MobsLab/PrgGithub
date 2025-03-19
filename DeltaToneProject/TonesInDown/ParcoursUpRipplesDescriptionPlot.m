%%ParcoursUpRipplesDescriptionPlot
% 20.09.2018 KJ
%
%   Describe Up and Down with ripples   
%
% see
%   ParcoursUpRipplesDescriptionPlot
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'ParcoursUpRipplesDescription.mat'))


%% params
%durations
hstep = 2;
max_edge_down = 400;
edges_down = 0:hstep:max_edge_down;
max_edge_up = 500;
edges_up = 0:hstep:max_edge_up;

%durations
hstep = 0.5;
max_edge_occ = 9;
edges_occ = 0:hstep:max_edge_occ;

%plot type
stairsplot = 0;
smoothing = 1;


epoch = {'night','n2','n3'};

for ep=1:length(epoch)
    
    %% concatenate

    durations.(epoch{ep}).up.ripples = [];
    durations.(epoch{ep}).up.all = [];
    durations.(epoch{ep}).down.ripples = [];
    durations.(epoch{ep}).down.all = [];

    occurences.(epoch{ep}).up.ripples = [];
    occurences.(epoch{ep}).up.all = [];
    occurences.(epoch{ep}).down.ripples = [];
    occurences.(epoch{ep}).down.all = [];

    for p=1:length(ripstat_res.path)

        %up durations
        durations.(epoch{ep}).up.ripples = [durations.(epoch{ep}).up.ripples ; ripstat_res.(epoch{ep}).withrip.up_duration{p}];
        durations.(epoch{ep}).up.all = [durations.(epoch{ep}).up.all ; ripstat_res.(epoch{ep}).all.up_duration{p}];

        %down durations
        durations.(epoch{ep}).down.ripples = [durations.(epoch{ep}).down.ripples ; ripstat_res.(epoch{ep}).withrip.down_duration{p}];
        durations.(epoch{ep}).down.all = [durations.(epoch{ep}).down.all ; ripstat_res.(epoch{ep}).all.down_duration{p}];

        %up occurences
        occurences.(epoch{ep}).up.ripples = [occurences.(epoch{ep}).up.ripples ; ripstat_res.(epoch{ep}).withrip.up_start{p}];
        occurences.(epoch{ep}).up.all = [occurences.(epoch{ep}).up.all ; ripstat_res.(epoch{ep}).all.up_duration{p}];

        %down occurences
        occurences.(epoch{ep}).down.ripples = [occurences.(epoch{ep}).down.ripples ; ripstat_res.(epoch{ep}).withrip.down_start{p}];
        occurences.(epoch{ep}).down.all = [occurences.(epoch{ep}).down.all ; ripstat_res.(epoch{ep}).all.down_duration{p}];

    end
    
    
    %% distrib durations

    %up with ripples
    [y_dur.(epoch{ep}).up.ripples, x_dur.(epoch{ep}).up.ripples] = histcounts(durations.(epoch{ep}).up.ripples/10, edges_up, 'Normalization','probability');
    x_dur.(epoch{ep}).up.ripples = x_dur.(epoch{ep}).up.ripples(1:end-1) + diff(x_dur.(epoch{ep}).up.ripples);
    %all up
    [y_dur.(epoch{ep}).up.all, x_dur.(epoch{ep}).up.all] = histcounts(durations.(epoch{ep}).up.all/10, edges_up, 'Normalization','probability');
    x_dur.(epoch{ep}).up.all = x_dur.(epoch{ep}).up.all(1:end-1) + diff(x_dur.(epoch{ep}).up.all);

    %down with ripples
    [y_dur.(epoch{ep}).down.ripples, x_dur.(epoch{ep}).down.ripples] = histcounts(durations.(epoch{ep}).down.ripples/10, edges_down, 'Normalization','probability');
    x_dur.(epoch{ep}).down.ripples = x_dur.(epoch{ep}).down.ripples(1:end-1) + diff(x_dur.(epoch{ep}).down.ripples);
    %all down
    [y_dur.(epoch{ep}).down.all, x_dur.(epoch{ep}).down.all] = histcounts(durations.(epoch{ep}).down.all/10, edges_down, 'Normalization','probability');
    x_dur.(epoch{ep}).down.all = x_dur.(epoch{ep}).down.all(1:end-1) + diff(x_dur.(epoch{ep}).down.all);

    %% distrib occurences

    %up with ripples
    [y_occ.(epoch{ep}).up.ripples, x_occ.(epoch{ep}).up.ripples] = histcounts(occurences.(epoch{ep}).up.ripples/3600e4, edges_occ, 'Normalization','probability');
    x_occ.(epoch{ep}).up.ripples = x_occ.(epoch{ep}).up.ripples(1:end-1) + diff(x_occ.(epoch{ep}).up.ripples);
    %all up
    [y_occ.(epoch{ep}).up.all, x_occ.(epoch{ep}).up.all] = histcounts(occurences.(epoch{ep}).up.all/3600e4, edges_occ, 'Normalization','probability');
    x_occ.(epoch{ep}).up.all = x_occ.(epoch{ep}).up.all(1:end-1) + diff(x_occ.(epoch{ep}).up.all);

    %down with ripples
    [y_occ.(epoch{ep}).down.ripples, x_occ.(epoch{ep}).down.ripples] = histcounts(occurences.(epoch{ep}).down.ripples/3600e4, edges_occ, 'Normalization','probability');
    x_occ.(epoch{ep}).down.ripples = x_occ.(epoch{ep}).down.ripples(1:end-1) + diff(x_occ.(epoch{ep}).down.ripples);
    %all down
    [y_occ.(epoch{ep}).down.all, x_occ.(epoch{ep}).down.all] = histcounts(occurences.(epoch{ep}).down.all/3600e4, edges_occ, 'Normalization','probability');
    x_occ.(epoch{ep}).down.all = x_occ.(epoch{ep}).down.all(1:end-1) + diff(x_occ.(epoch{ep}).down.all);



    %% DATA TO PLOT
    if stairsplot
        %duration
        [x_dur.(epoch{ep}).down.ripples, y_dur.(epoch{ep}).down.ripples] = stairs(x_dur.(epoch{ep}).down.ripples, y_dur.(epoch{ep}).down.ripples);
        [x_dur.(epoch{ep}).down.all, y_dur.(epoch{ep}).down.all] = stairs(x_dur.(epoch{ep}).down.all, y_dur.(epoch{ep}).down.all);

        [x_dur.(epoch{ep}).up.ripples, y_dur.(epoch{ep}).up.ripples] = stairs(x_dur.(epoch{ep}).up.ripples, y_dur.(epoch{ep}).up.ripples);
        [x_dur.(epoch{ep}).up.all, y_dur.(epoch{ep}).up.all] = stairs(x_dur.(epoch{ep}).up.all, y_dur.(epoch{ep}).up.all);

        %occurences
        [x_occ.(epoch{ep}).down.ripples, y_occ.(epoch{ep}).down.ripples] = stairs(x_occ.(epoch{ep}).down.ripples, y_occ.(epoch{ep}).down.ripples);
        [x_occ.(epoch{ep}).down.all, y_occ.(epoch{ep}).down.all] = stairs(x_occ.(epoch{ep}).down.all, y_occ.(epoch{ep}).down.all);

        [x_occ.(epoch{ep}).up.ripples, y_occ.(epoch{ep}).up.ripples] = stairs(x_occ.(epoch{ep}).up.ripples, y_occ.(epoch{ep}).up.ripples);
        [x_occ.(epoch{ep}).up.all, y_occ.(epoch{ep}).up.all] = stairs(x_occ.(epoch{ep}).up.all, y_occ.(epoch{ep}).up.all);

    else
        %duration
        y_dur.(epoch{ep}).down.ripples = Smooth(y_dur.(epoch{ep}).down.ripples, smoothing);
        y_dur.(epoch{ep}).down.all = Smooth(y_dur.(epoch{ep}).down.all, smoothing);

        y_dur.(epoch{ep}).up.ripples = Smooth(y_dur.(epoch{ep}).up.ripples, smoothing);
        y_dur.(epoch{ep}).up.all = Smooth(y_dur.(epoch{ep}).up.all, smoothing);

        %occurences
        y_occ.(epoch{ep}).down.ripples = Smooth(y_occ.(epoch{ep}).down.ripples, smoothing);
        y_occ.(epoch{ep}).down.all = Smooth(y_occ.(epoch{ep}).down.all, smoothing);

        y_occ.(epoch{ep}).up.ripples = Smooth(y_occ.(epoch{ep}).up.ripples, smoothing);
        y_occ.(epoch{ep}).up.all = Smooth(y_occ.(epoch{ep}).up.all, smoothing);
    end

    
end


    


%% PLOT
figure, hold on
fontsize = 18;
labels = {'whole record', 'N2', 'N3'};

for ep=1:length(epoch)
    %Down durations
    subplot(2,3,ep), hold on
    h(1) = plot(x_dur.(epoch{ep}).down.ripples, y_dur.(epoch{ep}).down.ripples, 'color', 'b', 'LineWidth',2); hold on,
    h(2) = plot(x_dur.(epoch{ep}).down.all, y_dur.(epoch{ep}).down.all, 'color', 'k', 'LineWidth',2); hold on,
%     xlabel('duration (ms)'),
    set(gca,'XTick',0:100:max_edge_down,'XLim',[0 max_edge_down], 'ytick',0:0.01:0.03, 'ylim', [0 0.03], 'FontName','Times','Fontsize',fontsize), hold on,
    if ep==1
        ylabel('probability'),
        legend(h,'with ripples','all');
    end
    title(['Down in ' labels{ep}])

    %Up durations
    subplot(2,3,ep+3), hold on
    h(1) = plot(x_dur.(epoch{ep}).up.ripples, y_dur.(epoch{ep}).up.ripples, 'color', 'b', 'LineWidth',2); hold on,
    h(2) = plot(x_dur.(epoch{ep}).up.all, y_dur.(epoch{ep}).up.all, 'color', 'k', 'LineWidth',2); hold on,
    xlabel('duration (ms)'),
    if ep==1
        ylabel('probability'),
    end
    set(gca,'XTick',[0 75 200:100:max_edge_up],'XLim',[0 max_edge_up], 'ylim', [0 6e-3], 'FontName','Times','Fontsize',fontsize), hold on,
    line([75 75], get(gca,'ylim')),
    title(['Up in ' labels{ep}])

end

% 
% 
% %Down occurencess
% subplot(2,2,3), hold on
% h(1) = plot(x_occ.night.down.ripples, y_occ.night.down.ripples, 'color', 'b', 'LineWidth',2); hold on,
% h(2) = plot(x_occ.night.down.all, y_occ.night.down.all, 'color', 'k', 'LineWidth',2); hold on,
% xlabel('occurences (ms)'), ylabel('probability')
% set(gca,'XTick',0:1:max_edge_occ,'XLim',[0 max_edge_occ],'FontName','Times','Fontsize',fontsize), hold on,
% legend(h,'with ripples','all');
% title('occurences of down states')
% 
% %Up occurencess
% subplot(2,2,4), hold on
% h(1) = plot(x_occ.night.up.ripples, y_occ.night.up.ripples, 'color', 'b', 'LineWidth',2); hold on,
% h(2) = plot(x_occ.night.up.all, y_occ.night.up.all, 'color', 'k', 'LineWidth',2); hold on,
% xlabel('occurences (ms)'), ylabel('probability')
% set(gca,'XTick',0:1:max_edge_occ,'XLim',[0 max_edge_occ],'FontName','Times','Fontsize',fontsize), hold on,
% legend(h,'with ripples','all');
% title('occurences of up states')


