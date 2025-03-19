%%CharacterisationGagulyWavesGroupPlot
% 23.11.2019 KJ
%
% Infos
%
% see
%    CharacterisationGagulyWavesGroup 


% load
clear
load(fullfile(FolderDeltaDataKJ,'CharacterisationGagulyWavesGroup.mat'))


%params
cludeep = {[3 4],[5 6]};
factorLFP = 0.195;

%% Get electrodes, animals

%animals
animals = unique(ganguly_res.name);

%animals that have each layer
for c=1:length(cludeep)
    animalsclu{c}=cell(0);
    for p=1:length(ganguly_res.path)
        if ~isempty(intersect(cludeep{c},ganguly_res.clusters{p}))
            animalsclu{c}{end+1} = ganguly_res.name{p};
        end
    end
    animalsclu{c} = unique(animalsclu{c});
end


%% Precision and recall
for c=1:length(cludeep)
    average_diff.recall{c}   = []; average_diff.precision{c}   = []; average_diff.fscore{c}   = [];
    average_so.recall{c}     = []; average_so.precision{c}     = []; average_so.fscore{c}     = [];
    average_deltag.recall{c} = []; average_deltag.precision{c} = []; average_deltag.fscore{c} = [];
    
    for m=1:length(animalsclu{c})
        mouse_recall.diff   = []; mouse_precision.diff   = []; mouse_fscore.diff   = [];
        mouse_recall.so     = []; mouse_precision.so     = []; mouse_fscore.so     = [];
        mouse_recall.deltag = []; mouse_precision.deltag = []; mouse_fscore.deltag = [];
        
        %loop over nights
        for p=1:length(ganguly_res.path)
            if strcmpi(animalsclu{c}{m},ganguly_res.name{p})
                
                mouse_recall.diff    = [mouse_recall.diff 1-ganguly_res.diff.recall{p}];
                mouse_precision.diff = [mouse_precision.diff 1-ganguly_res.diff.precision{p}];
                mouse_fscore.diff    = [mouse_fscore.diff ganguly_res.diff.fscore{p}];
                
                channels = ganguly_res.channels{p};
                clusters = ganguly_res.clusters{p};
                for ch=1:length(channels)
                    if ismember(clusters(ch),cludeep{c})
                        mouse_recall.so    = [mouse_recall.so 1-ganguly_res.so.recall{p}(ch)];
                        mouse_precision.so = [mouse_precision.so 1-ganguly_res.so.precision{p}(ch)];
                        mouse_fscore.so    = [mouse_fscore.so ganguly_res.so.fscore{p}(ch)];
                        
                        mouse_recall.deltag    = [mouse_recall.deltag 1-ganguly_res.deltag.recall{p}(ch)];
                        mouse_precision.deltag = [mouse_precision.deltag 1-ganguly_res.deltag.precision{p}(ch)];
                        mouse_fscore.deltag    = [mouse_fscore.deltag ganguly_res.deltag.fscore{p}(ch)];
                    end
                end
            end
        end
        
        %averaged per mouse
        average_diff.recall{c}(m,1) = mean(mouse_recall.diff)*100;
        average_diff.precision{c}(m,1) = mean(mouse_precision.diff)*100;
        average_diff.fscore{c}(m,1) = mean(mouse_fscore.diff)*100;
        
        average_so.recall{c}(m,1) = mean(mouse_recall.so)*100;
        average_so.precision{c}(m,1) = mean(mouse_precision.so)*100;
        average_so.fscore{c}(m,1) = mean(mouse_fscore.so)*100;
        
        average_deltag.recall{c}(m,1) = mean(mouse_recall.deltag)*100;
        average_deltag.precision{c}(m,1) = mean(mouse_precision.deltag)*100;
        average_deltag.fscore{c}(m,1) = mean(mouse_fscore.deltag)*100;
        
    end
end


%% Mean MUA
for c=1:length(cludeep)
    
    met_y.diff{c}  = []; met_y.so{c} = []; met_y.delta{c} = [];
    
    for m=1:length(animalsclu{c})
        mouse_y.diff  = []; mouse_y.so = []; mouse_y.delta = [];
        
        %loop over nights
        for p=1:length(ganguly_res.path)
            if strcmpi(animalsclu{c}{m},ganguly_res.name{p})
                
                %2-layers
                for i=1:length(ganguly_res.met_mua.diff{p})
                    y_diff = CenterFiringRateCurve(ganguly_res.met_mua.diff{p}{i}(:,1),ganguly_res.met_mua.diff{p}{i}(:,2),1);
                    mouse_y.diff  = [mouse_y.diff y_diff];
                    mouse_x.diff  = ganguly_res.met_mua.diff{p}{1}(:,1);
                end
                
                channels = ganguly_res.channels{p};
                clusters = ganguly_res.clusters{p};
                for ch=1:length(channels)
                    if ismember(clusters(ch),cludeep{c})
                        %SO
                        y_so = CenterFiringRateCurve(ganguly_res.met_mua.so{p}{ch}(:,1),ganguly_res.met_mua.so{p}{ch}(:,2),1);
                        mouse_y.so  = [mouse_y.so y_so];
                        mouse_x.so  = ganguly_res.met_mua.so{p}{ch}(:,1);
                        
                        %delta
                        y_delta = CenterFiringRateCurve(ganguly_res.met_mua.deltag{p}{ch}(:,1),ganguly_res.met_mua.deltag{p}{ch}(:,2),1);
                        mouse_y.delta  = [mouse_y.delta y_delta];
                        mouse_x.delta  = ganguly_res.met_mua.deltag{p}{ch}(:,1);

                    end
                end
            end
        end
        
        %averaged per mouse
        met_y.diff{c}  = [met_y.diff{c} mean(mouse_y.diff,2)];
        met_y.so{c}    = [met_y.so{c} mean(mouse_y.so,2)];
        met_y.delta{c} = [met_y.delta{c} mean(mouse_y.delta,2)];

        met_x.diff{c}  = mouse_x.diff;
        met_x.so{c}    = mouse_x.so;
        met_x.delta{c} = mouse_x.delta;
    end
    
    
    %mean MUA
    mua_mean.diff.y{c} = mean(met_y.diff{c}, 2);
    mua_mean.so.y{c} = mean(met_y.so{c}, 2);
    mua_mean.delta.y{c} = mean(met_y.delta{c}, 2);
    %std MUA
    mua_mean.diff.std{c} = std(met_y.diff{c},0,2) / sqrt(size(met_y.diff{c},2));
    mua_mean.so.std{c} = std(met_y.so{c},0,2) / sqrt(size(met_y.so{c},2));
    mua_mean.delta.std{c} = std(met_y.delta{c},0,2) / sqrt(size(met_y.delta{c},2));

    %x
    mua_mean.diff.x{c} = met_x.diff{c};
    mua_mean.so.x{c} = met_x.so{c};
    mua_mean.delta.x{c} = met_x.delta{c};

end


%% Mean LFP
for c=1:length(cludeep)
    
    meanlfp_y.down{c}        = []; meanlfp_y.up{c} = [];
    meanlfp_y.so_down{c}     = []; meanlfp_y.so_up{c} = []; 
    meanlfp_y.delta_start{c} = []; meanlfp_y.delta_up{c} = [];
    
    
    for m=1:length(animalsclu{c})
        mouse_y.down        = []; mouse_y.up = []; 
        mouse_y.so_down     = []; mouse_y.so_up = []; 
        mouse_y.delta_start = []; mouse_y.delta_up = []; 
        
        %loop over nights
        for p=1:length(ganguly_res.path)
            if strcmpi(animalsclu{c}{m},ganguly_res.name{p})
                
                channels = ganguly_res.channels{p};
                clusters = ganguly_res.clusters{p};
                for ch=1:length(channels)
                    if ismember(clusters(ch),cludeep{c})
                        
                        %Down
                        mouse_y.down  = [mouse_y.down ganguly_res.met_lfp.st_down{p}{ch}(:,2)];
                        mouse_x.down  = ganguly_res.met_lfp.st_down{p}{ch}(:,1);
                        
                        mouse_y.up  = [mouse_y.up ganguly_res.met_lfp.end_down{p}{ch}(:,2)];
                        mouse_x.up  = ganguly_res.met_lfp.end_down{p}{ch}(:,1);
                        
                        %SO
                        mouse_y.so_down  = [mouse_y.so_down ganguly_res.met_lfp.so_down{p}{ch}(:,2)];
                        mouse_x.so_down  = ganguly_res.met_lfp.so_down{p}{ch}(:,1);
                        
                        mouse_y.so_up  = [mouse_y.so_up ganguly_res.met_lfp.so_up{p}{ch}(:,2)];
                        mouse_x.so_up  = ganguly_res.met_lfp.so_up{p}{ch}(:,1);
                        
                        %delta
                        mouse_y.delta_start  = [mouse_y.delta_start ganguly_res.met_lfp.delta_start{p}{ch}(:,2)];
                        mouse_x.delta_start  = ganguly_res.met_lfp.delta_start{p}{ch}(:,1);
                        
                        mouse_y.delta_up  = [mouse_y.delta_up ganguly_res.met_lfp.delta_up{p}{ch}(:,2)];
                        mouse_x.delta_up  = ganguly_res.met_lfp.delta_up{p}{ch}(:,1);

                    end
                end
            end
        end
        
        %averaged per mouse
        meanlfp_y.down{c}  = [meanlfp_y.down{c} mean(mouse_y.down,2) * factorLFP];
        meanlfp_y.up{c}    = [meanlfp_y.up{c} mean(mouse_y.up,2) * factorLFP];
        meanlfp_y.so_down{c} = [meanlfp_y.so_down{c} mean(mouse_y.so_down,2) * factorLFP];
        meanlfp_y.so_up{c}   = [meanlfp_y.so_up{c} mean(mouse_y.so_up,2) * factorLFP];
        meanlfp_y.delta_start{c} = [meanlfp_y.delta_start{c} mean(mouse_y.delta_start,2) * factorLFP];
        meanlfp_y.delta_up{c}    = [meanlfp_y.delta_up{c} mean(mouse_y.delta_up,2) * factorLFP];

        meanlfp_x.down{c}        = mouse_x.down;
        meanlfp_x.up{c}          = mouse_x.up;
        meanlfp_x.so_down{c}     = mouse_x.so_down;
        meanlfp_x.so_up{c}       = mouse_x.so_up;
        meanlfp_x.delta_start{c} = mouse_x.delta_start;
        meanlfp_x.delta_up{c}    = mouse_x.delta_up;
    end
    
    
    %mean MUA
    lfp_mean.down.y{c}        = mean(meanlfp_y.down{c}, 2);
    lfp_mean.up.y{c}          = mean(meanlfp_y.up{c}, 2);
    lfp_mean.so_down.y{c}     = mean(meanlfp_y.so_down{c}, 2);
    lfp_mean.so_up.y{c}       = mean(meanlfp_y.so_up{c}, 2);
    lfp_mean.delta_start.y{c} = mean(meanlfp_y.delta_start{c}, 2);
    lfp_mean.delta_up.y{c}    = mean(meanlfp_y.delta_up{c}, 2);
    %std MUA
    lfp_mean.down.std{c}        = std(meanlfp_y.down{c},0,2) / sqrt(size(meanlfp_y.down{c},2));
    lfp_mean.up.std{c}          = std(meanlfp_y.up{c},0,2) / sqrt(size(meanlfp_y.up{c},2));
    lfp_mean.so_down.std{c}     = std(meanlfp_y.so_down{c},0,2) / sqrt(size(meanlfp_y.so_down{c},2));
    lfp_mean.so_up.std{c}       = std(meanlfp_y.so_up{c},0,2) / sqrt(size(meanlfp_y.so_up{c},2));
    lfp_mean.delta_start.std{c} = std(meanlfp_y.delta_start{c},0,2) / sqrt(size(meanlfp_y.delta_start{c},2));
    lfp_mean.delta_up.std{c}    = std(meanlfp_y.delta_up{c},0,2) / sqrt(size(meanlfp_y.delta_up{c},2));

    %x
    lfp_mean.down.x{c}        = meanlfp_x.down{c};
    lfp_mean.up.x{c}          = meanlfp_x.up{c};
    lfp_mean.so_down.x{c}     = meanlfp_x.so_down{c};
    lfp_mean.so_up.x{c}       = meanlfp_x.so_up{c};
    lfp_mean.delta_start.x{c} = meanlfp_x.delta_start{c};
    lfp_mean.delta_up.x{c}    = meanlfp_x.delta_up{c};

end



%% data to plot

for c=1:length(cludeep)
    data_recall{c}    = [average_diff.recall{c} average_so.recall{c} average_deltag.recall{c}];
    data_precision{c} = [average_diff.precision{c} average_so.precision{c} average_deltag.precision{c}];
    data_fscore{c}    = [average_diff.fscore{c} average_so.fscore{c} average_deltag.fscore{c}];
end


%% Plot

fontsize = 18;
titles = {'middle (gp 3-4)','deep (gp 5-6)'};
labels = {'2-layers','SO','\delta'};

color_down = [0.2 0 0];
color_diff = 'k';
color_so = [0.7 0.7 0.7];
color_delta = [1 0.3 0.7];
colori = {'k',[0.7 0.7 0.7], [1 0.3 0.7]};


%precision & recall
figure, hold on
for c=1:length(cludeep)
    
    subplot(length(cludeep),3,1+(c-1)*3), hold on
    PlotErrorBarN_KJ(data_precision{c}, 'newfig',0, 'barcolors', colori, 'paired',1, 'ShowSigstar','sig','showpoints',1); hold on
    set(gca, 'ylim',[0 100], 'ytick',0:20:100, 'xlim', [0 4], 'xtick', 1:3, 'XTickLabel',labels,'fontsize',fontsize), 
    ylabel('% false postive'), xtickangle(30)
    title(titles{c}),
    
    subplot(length(cludeep),3,2+(c-1)*3), hold on
    PlotErrorBarN_KJ(data_recall{c}, 'newfig',0, 'barcolors', colori, 'paired',1, 'ShowSigstar','sig','showpoints',1); hold on
    set(gca, 'ylim',[0 120], 'ytick',0:20:100, 'xlim', [0 4], 'xtick', 1:3, 'XTickLabel',labels,'fontsize',fontsize), 
    ylabel('% missed'), xtickangle(30)
    title(titles{c}),
    
    subplot(length(cludeep),3,3+(c-1)*3), hold on
    PlotErrorBarN_KJ(data_fscore{c}, 'newfig',0, 'barcolors', colori, 'paired',1, 'ShowSigstar','sig','showpoints',1); hold on
    set(gca, 'ylim',[0 100], 'ytick',0:20:100, 'xlim', [0 4], 'xtick', 1:3, 'XTickLabel',labels,'fontsize',fontsize), 
    ylabel('fscore'), xtickangle(30)
    title(titles{c}),

end


%LFP
figure, hold on
for c=1:length(cludeep)

    % Down part
    subplot(1,4,c), hold on

    errorbar(lfp_mean.down.x{c}, lfp_mean.down.y{c}, lfp_mean.down.std{c}, 'color', color_down,'CapSize',1)
    errorbar(lfp_mean.so_down.x{c}, lfp_mean.so_down.y{c}, lfp_mean.so_down.std{c}, 'color', color_so,'CapSize',1)
    errorbar(lfp_mean.delta_start.x{c}, lfp_mean.delta_start.y{c}, lfp_mean.delta_start.std{c}, 'color', color_delta,'CapSize',1)
    %mean curves
    h(1) = plot(lfp_mean.down.x{c}, lfp_mean.down.y{c}, 'color', color_down, 'linewidth',2);
    h(2) = plot(lfp_mean.so_down.x{c}, lfp_mean.so_down.y{c}, 'color', color_so, 'linewidth',2);
    h(3) = plot(lfp_mean.delta_start.x{c}, lfp_mean.delta_start.y{c}, 'color', color_delta, 'linewidth',2);
    %properties
    set(gca,'XLim',[-400 400],'Fontsize',fontsize);

    line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
    legend(h,'Down','SO','delta');
    xlabel('time from detection (ms)'),
    ylabel('LFP amplitude (µV)'), 
    title(titles{c}),
    
    
    % Up part
    subplot(1,4,c+2), hold on

    errorbar(lfp_mean.up.x{c}, lfp_mean.up.y{c}, lfp_mean.up.std{c}, 'color', color_down,'CapSize',1)
    errorbar(lfp_mean.so_up.x{c}, lfp_mean.so_up.y{c}, lfp_mean.so_up.std{c}, 'color', color_so,'CapSize',1)
    errorbar(lfp_mean.delta_up.x{c}, lfp_mean.delta_up.y{c}, lfp_mean.delta_up.std{c}, 'color', color_delta,'CapSize',1)
    %mean curves
    h(1) = plot(lfp_mean.up.x{c}, lfp_mean.up.y{c}, 'color', color_down, 'linewidth',2);
    h(2) = plot(lfp_mean.so_up.x{c}, lfp_mean.so_up.y{c}, 'color', color_so, 'linewidth',2);
    h(3) = plot(lfp_mean.delta_up.x{c}, lfp_mean.delta_up.y{c}, 'color', color_delta, 'linewidth',2);
    %properties
    set(gca,'XLim',[-400 400],'Fontsize',fontsize);

    line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
    legend(h,'Up','SO','delta');
    xlabel('time from detection (ms)'),
    ylabel('LFP amplitude (µV)'), 
    title(titles{c}),
    
end



%MUA
figure, hold on
for c=1:length(cludeep)

    subplot(1,4,c), hold on

    errorbar(mua_mean.diff.x{c}, mua_mean.diff.y{c}, mua_mean.diff.std{c}, 'color', color_diff,'CapSize',1)
    errorbar(mua_mean.so.x{c}, mua_mean.so.y{c}, mua_mean.so.std{c}, 'color', color_so,'CapSize',1)
    errorbar(mua_mean.delta.x{c}, mua_mean.delta.y{c}, mua_mean.delta.std{c}, 'color', color_delta,'CapSize',1)
    %mean curves
    h(1) = plot(mua_mean.diff.x{c}, mua_mean.diff.y{c}, 'color', color_diff, 'linewidth',2);
    h(2) = plot(mua_mean.so.x{c}, mua_mean.so.y{c}, 'color', color_so, 'linewidth',2);
    h(3) = plot(mua_mean.delta.x{c}, mua_mean.delta.y{c}, 'color', color_delta, 'linewidth',2);
    %properties
    set(gca,'YLim', [0 1.8],'XLim',[-400 400],'Fontsize',fontsize);

    line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
    legend(h,'Diff','SO','delta');
    xlabel('time from detection (ms)'),
    ylabel('Normalized MUA'), 

    
end








