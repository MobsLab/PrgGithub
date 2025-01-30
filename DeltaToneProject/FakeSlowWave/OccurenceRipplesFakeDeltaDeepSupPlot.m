%%OccurenceRipplesFakeDeltaDeepSupPlot
% 09.09.2019 KJ
%
% Infos
%   script about real and fake slow waves : MUA and down
%
% see
%    OccurenceRipplesFakeDeltaSup FigureExampleFakeSlowWaveSup OccurenceRipplesFakeDeltaDownSupPlot


clear

% load Sup first
load(fullfile(FolderDeltaDataKJ,'OccurenceRipplesFakeDeltaDownSup.mat'))
ripplesup_res = ripples_res;
animals_sup = unique(ripples_res.name);
clear ripples_res


%deep
load(fullfile(FolderDeltaDataKJ,'OccurenceRipplesFakeDeltaDeep.mat'))

for p=1:length(ripples_res.path)
    list_names{p,1} = [ripples_res.name{p}];
end
animals = unique(list_names);

smoothing = 2;
normalized = 1;
clusters = 4:6;


%% DEEP

%init
cc_all.down1.y = [];
cc_all.ddiff.y = [];

cc_all.delta1.y = [];
cc_all.other1.y = [];

for c=1:length(clusters)
    cc_clu.delta1.y{c} = [];
    cc_clu.other1.y{c} = [];
end


for m=1:length(animals)
    
    
    %% global down1 down2 and diff deltas
    
    cc_mouse.down1.y = [];
    cc_mouse.ddiff.y = [];
    
    %loop over records of animals
    for p=1:length(ripples_res.path)
        if strcmpi(list_names{p},animals{m})
            
            %x
            cc_mouse.down1.x = ripples_res.down1.global{p}(:,1);
            cc_mouse.ddiff.x = ripples_res.diff.global{p}(:,1);
            
            %normalisation factor
            if normalized
                x_norm = cc_mouse.down1.x<-800;
                normfact.down1 = mean(ripples_res.down1.global{p}(x_norm,2));
                normfact.ddiff = mean(ripples_res.diff.global{p}(x_norm,2));
            else
                normfact.down1 = 1; 
                normfact.ddiff = 1; 
            end
            
            %y
            cc_mouse.down1.y = [cc_mouse.down1.y runmean(ripples_res.down1.global{p}(:,2) / normfact.down1, smoothing)];
            cc_mouse.ddiff.y = [cc_mouse.ddiff.y runmean(ripples_res.diff.global{p}(:,2) / normfact.ddiff, smoothing)];
        end
    end
        
    %average of mouse
    cc_meanmouse.down1.y{m} = mean(cc_mouse.down1.y,2);
    cc_meanmouse.ddiff.y{m} = mean(cc_mouse.ddiff.y,2);
    %x
    cc_meanmouse.down1.x{m} = cc_mouse.down1.x;
    cc_meanmouse.ddiff.x{m} = cc_mouse.ddiff.x;
    
    %concatenate all
    cc_all.down1.y = [cc_all.down1.y cc_meanmouse.down1.y{m}];
    cc_all.ddiff.y = [cc_all.ddiff.y cc_meanmouse.ddiff.y{m}];
    
    
    %% deltas crosscorr - average by channel 
    cc_mousech.delta1.y = cell(1,12);
    cc_mousech.other1.y = cell(1,12);
    
    %loop over records of animals
    for p=1:length(ripples_res.path)
        if strcmpi(list_names{p},animals{m})
            channels = ripples_res.channels{p};
            mouse_clusters = ripples_res.clusters{p};
            for ch=1:length(channels)
                
                if strcmpi(animals{m},'Mouse507') && ch==2
                    continue
                end
                
                cc_mouse.delta1.x = ripples_res.delta1.global{p,ch}(:,1);
                cc_mouse.other1.x = ripples_res.delta1.global{p,ch}(:,1);                
                %normalisation factor
                if normalized
                    x_norm = cc_mouse.delta1.x<-500;
                    normfact.delta1 = mean(ripples_res.delta1.global{p,ch}(x_norm,2));
                    normfact.other1 = mean(ripples_res.delta1.other{p,ch}(x_norm,2));
                else
                    normfact.delta1 = 1; 
                    normfact.other1 = 1; 
                end
                
                %y
                cc_mousech.delta1.y{ch} = [cc_mousech.delta1.y{ch} runmean(ripples_res.delta1.global{p,ch}(:,2) / normfact.delta1, smoothing)];
                cc_mousech.other1.y{ch} = [cc_mousech.other1.y{ch} runmean(ripples_res.delta1.other{p,ch}(:,2) / normfact.other1, smoothing)];
                
            end
        end
    end
    
    %average by channels
    idx = ~cellfun(@isempty, cc_mousech.delta1.y);
    cc_mousech.delta1.y = cc_mousech.delta1.y(idx);
    cc_mousech.other1.y = cc_mousech.other1.y(idx);
    
    for ch=1:length(cc_mousech.delta1.y)
        cc_mousech.delta1.y{ch} = mean(cc_mousech.delta1.y{ch},2);
        cc_mousech.other1.y{ch} = mean(cc_mousech.other1.y{ch},2);
    end
    
    
    %% cluster
    for c=1:length(clusters)
        cc_clum.delta1.y{c} = [];
        cc_clum.other1.y{c} = [];
    
        for ch=1:length(cc_mousech.delta1.y)
            if mouse_clusters(ch)==clusters(c)
                cc_clum.delta1.y{c} = [cc_clum.delta1.y{c} cc_mousech.delta1.y{ch}];
                cc_clum.other1.y{c} = [cc_clum.other1.y{c} cc_mousech.other1.y{ch}];
            end
        end
    end
    
    
    for c=1:length(clusters)
        cc_clumouse.delta1.y{m,c} = nanmean(cc_clum.delta1.y{c},2);
        cc_clumouse.other1.y{m,c} = nanmean(cc_clum.other1.y{c},2);
        
        cc_clu.delta1.y{c} = [cc_clu.delta1.y{c} cc_clumouse.delta1.y{m,c}];
        cc_clu.other1.y{c} = [cc_clu.other1.y{c} cc_clumouse.other1.y{m,c}];
    end
    
    
    %% average all 
    cc_meanmouse.delta1.y{m} = nanmean(cell2mat(cc_mousech.delta1.y),2);
    cc_meanmouse.other1.y{m} = nanmean(cell2mat(cc_mousech.other1.y),2);
    
    for ch=1:length(cc_mousech.delta1.y)
        cc_all.delta1.y = [cc_all.delta1.y cc_meanmouse.delta1.y{m}];
        cc_all.other1.y = [cc_all.other1.y cc_meanmouse.other1.y{m}];
    end
    
    
end


%x
cc_all.down1.x = cc_meanmouse.down1.x{1};
cc_all.ddiff.x = cc_meanmouse.ddiff.x{1};
cc_all.delta1.x = cc_mouse.delta1.x;
cc_all.other1.x = cc_mouse.other1.x;


%down1
Cc.down1.X     = cc_all.down1.x;
Cc.down1.stdY  = std(cc_all.down1.y,0,2) / sqrt(size(cc_all.down1.y,2));
Cc.down1.meanY = mean(cc_all.down1.y,2);
%delta diff
Cc.ddiff.X     = cc_all.ddiff.x;
Cc.ddiff.stdY  = std(cc_all.ddiff.y,0,2) / sqrt(size(cc_all.ddiff.y,2));
Cc.ddiff.meanY = mean(cc_all.ddiff.y,2);
%delta1
Cc.delta1.X     = cc_all.delta1.x;
Cc.delta1.stdY  = std(cc_all.delta1.y,0,2) / sqrt(size(cc_all.delta1.y,2));
Cc.delta1.meanY = mean(cc_all.delta1.y,2);
%other1
Cc.other1.X     = cc_all.other1.x;
Cc.other1.stdY  = std(cc_all.other1.y,0,2) / sqrt(size(cc_all.other1.y,2));
Cc.other1.meanY = mean(cc_all.other1.y,2);



for c=1:length(clusters)
    %delta1
    Cclu.delta1.X{c}     = cc_all.delta1.x;
    Cclu.delta1.stdY{c}  = std(cc_clu.delta1.y{c},0,2) / sqrt(size(cc_clu.delta1.y{c},2));
    Cclu.delta1.meanY{c} = mean(cc_clu.delta1.y{c},2);
    %other1
    Cclu.other1.X{c}     = cc_all.other1.x;
    Cclu.other1.stdY{c}  = std(cc_clu.other1.y{c},0,2) / sqrt(size(cc_clu.other1.y{c},2));
    Cclu.other1.meanY{c} = mean(cc_clu.other1.y{c},2);
end



%% SUP

%init
cc_all.delta.y = [];
cc_all.other.y = [];

for m=1:length(animals_sup)
    
    %% deltas crosscorr - average by channel 
    cc_mousesup.delta.y = cell(1,12);
    cc_mousesup.other.y = cell(1,12);
    
    %loop over records of animals
    for p=1:length(ripplesup_res.path)
        if p==10
            continue
        end
        if strcmpi(ripplesup_res.name{p},animals_sup{m})
            nb_channels = ripplesup_res.channels{p};
            mouse_clusters = ripplesup_res.clusters{p};
            for ch=1:length(nb_channels)
                
                cc_mouse.delta.x = ripplesup_res.delta.global{p,ch}(:,1);
                cc_mouse.other.x = ripplesup_res.delta.other{p,ch}(:,1);                
                %normalisation factor
                if normalized
                    x_norm = cc_mouse.delta.x<-500;
                    normfact.delta = mean(ripplesup_res.delta.global{p,ch}(x_norm,2));
                    normfact.other = mean(ripplesup_res.delta.other{p,ch}(x_norm,2));
                else
                    normfact.delta = 1; 
                    normfact.other = 1; 
                end
                
                %y
                cc_mousesup.delta.y{ch} = [cc_mousesup.delta.y{ch} runmean(ripplesup_res.delta.global{p,ch}(:,2) / normfact.delta, smoothing)];
                cc_mousesup.other.y{ch} = [cc_mousesup.other.y{ch} runmean(ripplesup_res.delta.other{p,ch}(:,2) / normfact.other, smoothing)];
            end
        end
    end
    
    %average by channels
    idx = ~cellfun(@isempty, cc_mousesup.delta.y);
    cc_mousesup.delta.y = cc_mousesup.delta.y(idx);
    cc_mousesup.other.y = cc_mousesup.other.y(idx);    
    for ch=1:length(cc_mousesup.delta.y)
        cc_mousesup.delta.y{ch} = mean(cc_mousesup.delta.y{ch},2);
        cc_mousesup.other.y{ch} = mean(cc_mousesup.other.y{ch},2);
    end
    
    
    %% average all 
    cc_meanmousesup.delta.y{m} = nanmean(cell2mat(cc_mousesup.delta.y),2);
    cc_meanmousesup.other.y{m} = nanmean(cell2mat(cc_mousesup.other.y),2);
    
    for ch=1:length(cc_mousesup.delta.y)
        cc_all.delta.y = [cc_all.delta.y cc_meanmousesup.delta.y{m}];
        cc_all.other.y = [cc_all.other.y cc_meanmousesup.other.y{m}];
    end
    
    
end

%x
cc_all.delta.x = cc_mouse.delta.x;
cc_all.other.x = cc_mouse.other.x;

%delta
Ccsup.delta.X     = cc_all.delta.x;
Ccsup.delta.stdY  = std(cc_all.delta.y,0,2) / sqrt(size(cc_all.delta.y,2));
Ccsup.delta.meanY = mean(cc_all.delta.y,2);
%other
Ccsup.other.X     = cc_all.other.x;
Ccsup.other.stdY  = std(cc_all.other.y,0,2) / sqrt(size(cc_all.other.y,2));
Ccsup.other.meanY = mean(cc_all.other.y,2);




%% Plot

col_mean = 'k';
col_curve = [0.4 0.4 0.4];
col_down = 'r';
col_downcurve = [0.8 0.1 0.5];

YL = [0 2.7];
fontsize = 20;

%% down1 delta1 other1
figure, hold on

%down
subplot(1,4,1), hold on
for m=1:length(animals)
    plot(Cc.down1.X, cc_meanmouse.down1.y{m}, 'color', col_downcurve, 'linewidth',1);
end
area(Cc.down1.X, Cc.down1.meanY','FaceColor',col_down,'facealpha',0.4,'edgealpha',0);
plot(Cc.down1.X, Cc.down1.meanY, 'color',col_down, 'linewidth',2),
set(gca,'ylim',YL, 'fontsize', fontsize),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
% xlabel('time from ripples (ms)'),
ylabel('Occurence of down states'), 
title('Down states'),


%delta diff
subplot(1,4,2), hold on
for m=1:length(animals)
    plot(Cc.ddiff.X, cc_meanmouse.ddiff.y{m}, 'color', col_curve, 'linewidth',1);
end
area(Cc.down1.X, Cc.down1.meanY','FaceColor',col_down,'facealpha',0.2,'edgealpha',0);
plot(Cc.ddiff.X, Cc.ddiff.meanY, 'color',col_mean, 'linewidth',2),
set(gca,'ylim',[0 3.8], 'fontsize', fontsize),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
xlabel('time from ripples (ms)'),
% ylabel('Occurence of delta waves'), 
title('Delta diff'),


%%%%%%%%%%
%%DEEP
%%%%%%%%%%

figure, hold
%delta with down
subplot(1,4,1), hold on
for m=1:length(animals)
    plot(Cc.delta1.X, cc_meanmouse.delta1.y{m}, 'color', col_curve, 'linewidth',1);
end
area(Cc.down1.X, Cc.down1.meanY','FaceColor',col_down,'facealpha',0.2,'edgealpha',0);
plot(Cc.delta1.X, Cc.delta1.meanY, 'color',col_mean, 'linewidth',2),
set(gca,'ylim',YL, 'fontsize', fontsize),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
% xlabel('time from ripples (ms)'),
% ylabel('Occurence of delta waves'), 
title({'Real Slow Wave', '(with down)'}),

%fake delta
subplot(1,4,2), hold on
for m=1:length(animals)
    plot(Cc.other1.X, cc_meanmouse.other1.y{m}, 'color', col_curve, 'linewidth',1);
end
area(Cc.down1.X, Cc.down1.meanY','FaceColor',col_down,'facealpha',0.2,'edgealpha',0);
plot(Cc.other1.X, Cc.other1.meanY, 'color',col_mean, 'linewidth',2),
set(gca,'ylim',YL, 'fontsize', fontsize),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
% xlabel('time from ripples (ms)'),
% ylabel('Occurence of delta waves'), 
title({'Fake Slow Wave', '(no down)'}),


%%%%%%%%%%
%%SUP
%%%%%%%%%%
YL = [0 2.4];

figure, hold
%delta with down
subplot(1,4,1), hold on
for m=1:length(animals_sup)
    plot(Ccsup.delta.X, cc_meanmousesup.delta.y{m}, 'color', col_curve, 'linewidth',1);
end
area(Cc.down1.X, Cc.down1.meanY','FaceColor',col_down,'facealpha',0.2,'edgealpha',0);
plot(Ccsup.delta.X, Ccsup.delta.meanY, 'color',col_mean, 'linewidth',2),
set(gca,'ylim',YL, 'fontsize', fontsize),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
% xlabel('time from ripples (ms)'),ylabel('Occurence of delta waves'), 
title({'Real Slow Wave', '(with down)'}),


%fake delta
subplot(1,4,2), hold on
for m=1:length(animals_sup)
    plot(Ccsup.other.X, cc_meanmousesup.other.y{m}, 'color', col_curve, 'linewidth',1);
end
area(Cc.down1.X, Cc.down1.meanY','FaceColor',col_down,'facealpha',0.2,'edgealpha',0);
plot(Ccsup.other.X, Ccsup.other.meanY, 'color',col_mean, 'linewidth',2),
set(gca,'ylim',YL, 'fontsize', fontsize),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
% xlabel('time from ripples (ms)'),ylabel('Occurence of delta waves'), 
title({'Fake Slow Wave', '(no down)'}),



