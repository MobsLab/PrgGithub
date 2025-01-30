%%OccurenceRipplesFakeDeltaDownSupPlot
% 09.09.2019 KJ
%
% Infos
%   script about real and fake slow waves : MUA and down
%
% see
%    OccurenceRipplesFakeDeltaSup OccurenceRipplesFakeDeltaDeepPlot OccurenceRipplesFakeDeltaDownSup


% load
clear
load(fullfile(FolderDeltaDataKJ,'OccurenceRipplesFakeDeltaDownSup.mat'))

animals = unique(ripples_res.name);

smoothing = 2;
normalized = 1;

%init
cc_all.down.y = [];
cc_all.ddiff.y = [];

cc_all.delta.y = [];
cc_all.other.y = [];

cc_all.diff_real.y = [];
cc_all.real_diff.y = [];


for m=1:length(animals)
    
    
    %% global down down2 and diff deltas
    
    cc_mouse.down.y = [];
    cc_mouse.down2.y = [];
    cc_mouse.ddiff.y = [];
    
    %loop over records of animals
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
            
            %x
            cc_mouse.down.x = ripples_res.down.global{p}(:,1);
            cc_mouse.ddiff.x = ripples_res.diff.global{p}(:,1);
            
            %normalisation factor
            if normalized
                x_norm = cc_mouse.down.x<-800;
                normfact.down = mean(ripples_res.down.global{p}(x_norm,2));
                normfact.ddiff = mean(ripples_res.diff.global{p}(x_norm,2));
            else
                normfact.down = 1; 
                normfact.down2 = 1;
                normfact.ddiff = 1; 
            end
            
            %y
            cc_mouse.down.y = [cc_mouse.down.y runmean(ripples_res.down.global{p}(:,2) / normfact.down, smoothing)];
            cc_mouse.ddiff.y = [cc_mouse.ddiff.y runmean(ripples_res.diff.global{p}(:,2) / normfact.ddiff, smoothing)];
        end
    end
        
    %average of mouse
    cc_meanmouse.down.y{m} = mean(cc_mouse.down.y,2);
    cc_meanmouse.ddiff.y{m} = mean(cc_mouse.ddiff.y,2);
    %x
    cc_meanmouse.down.x{m} = cc_mouse.down.x;
    cc_meanmouse.ddiff.x{m} = cc_mouse.ddiff.x;
    
    %concatenate all
    cc_all.down.y = [cc_all.down.y cc_meanmouse.down.y{m}];
    cc_all.ddiff.y = [cc_all.ddiff.y cc_meanmouse.ddiff.y{m}];
    
    
    %% deltas crosscorr - average by channel 
    cc_mousech.delta.y = cell(1,12);
    cc_mousech.other.y = cell(1,12);
    cc_mousech.diff_real.y = cell(1,12);
    cc_mousech.real_diff.y = cell(1,12);
    
    %loop over records of animals
    for p=1:length(ripples_res.path)
        if p==10
            continue
        end
        if strcmpi(ripples_res.name{p},animals{m})
            nb_channels = ripples_res.channels{p};
            mouse_clusters = ripples_res.clusters{p};
            for ch=1:length(nb_channels)
                
                cc_mouse.delta.x = ripples_res.delta.global{p,ch}(:,1);
                cc_mouse.other.x = ripples_res.delta.other{p,ch}(:,1);
                cc_mouse.diff_real.x = ripples_res.diff_real{p,ch}(:,1);
                cc_mouse.real_diff.x = ripples_res.real_diff{p,ch}(:,1);
                
                %normalisation factor
                if normalized
                    x_norm = cc_mouse.delta.x<-500;
                    normfact.delta = mean(ripples_res.delta.global{p,ch}(x_norm,2));
                    normfact.other = mean(ripples_res.delta.other{p,ch}(x_norm,2));
                    normfact.diff_real = mean(ripples_res.diff_real{p,ch}(x_norm,2));
                    normfact.real_diff = mean(ripples_res.real_diff{p,ch}(x_norm,2));
                else
                    normfact.delta = 1; 
                    normfact.other = 1; 
                    normfact.diff_real = 1;
                    normfact.real_diff = 1;
                end
                
                %y
                cc_mousech.delta.y{ch} = [cc_mousech.delta.y{ch} runmean(ripples_res.delta.global{p,ch}(:,2) / normfact.delta, smoothing)];
                cc_mousech.other.y{ch} = [cc_mousech.other.y{ch} runmean(ripples_res.delta.other{p,ch}(:,2) / normfact.other, smoothing)];
                cc_mousech.diff_real.y{ch} = [cc_mousech.diff_real.y{ch} runmean(ripples_res.diff_real{p,ch}(:,2) / normfact.diff_real, smoothing)];
                cc_mousech.real_diff.y{ch} = [cc_mousech.real_diff.y{ch} runmean(ripples_res.real_diff{p,ch}(:,2) / normfact.real_diff, smoothing)];
            end
        end
    end
    
    %average by channels
    idx = ~cellfun(@isempty, cc_mousech.delta.y);
    cc_mousech.delta.y = cc_mousech.delta.y(idx);
    cc_mousech.other.y = cc_mousech.other.y(idx);
    cc_mousech.diff_real.y = cc_mousech.diff_real.y(idx);
    cc_mousech.real_diff.y = cc_mousech.real_diff.y(idx);
    
    for ch=1:length(cc_mousech.delta.y)
        cc_mousech.delta.y{ch} = mean(cc_mousech.delta.y{ch},2);
        cc_mousech.other.y{ch} = mean(cc_mousech.other.y{ch},2);
        cc_mousech.diff_real.y{ch} = mean(cc_mousech.diff_real.y{ch},2);
        cc_mousech.real_diff.y{ch} = mean(cc_mousech.real_diff.y{ch},2);
    end
    
    
    %% average all 
    cc_meanmouse.delta.y{m} = nanmean(cell2mat(cc_mousech.delta.y),2);
    cc_meanmouse.other.y{m} = nanmean(cell2mat(cc_mousech.other.y),2);
    cc_meanmouse.diff_real.y{m} = nanmean(cell2mat(cc_mousech.diff_real.y),2);
    cc_meanmouse.real_diff.y{m} = nanmean(cell2mat(cc_mousech.real_diff.y),2);
    
    for ch=1:length(cc_mousech.delta.y)
        cc_all.delta.y = [cc_all.delta.y cc_meanmouse.delta.y{m}];
        cc_all.other.y = [cc_all.other.y cc_meanmouse.other.y{m}];
        cc_all.diff_real.y = [cc_all.diff_real.y cc_meanmouse.diff_real.y{m}];
        cc_all.real_diff.y = [cc_all.real_diff.y cc_meanmouse.real_diff.y{m}];
    end
    
    
end


%x
cc_all.down.x = cc_meanmouse.down.x{1};
cc_all.ddiff.x = cc_meanmouse.ddiff.x{1};
cc_all.delta.x = cc_mouse.delta.x;
cc_all.other.x = cc_mouse.other.x;
cc_all.diff_real.x = cc_mouse.diff_real.x;
cc_all.real_diff.x = cc_mouse.real_diff.x;


%down
Cc.down.X     = cc_all.down.x;
Cc.down.stdY  = std(cc_all.down.y,0,2) / sqrt(size(cc_all.down.y,2));
Cc.down.meanY = mean(cc_all.down.y,2);
%delta diff
Cc.ddiff.X     = cc_all.ddiff.x;
Cc.ddiff.stdY  = std(cc_all.ddiff.y,0,2) / sqrt(size(cc_all.ddiff.y,2));
Cc.ddiff.meanY = mean(cc_all.ddiff.y,2);
%delta
Cc.delta.X     = cc_all.delta.x;
Cc.delta.stdY  = std(cc_all.delta.y,0,2) / sqrt(size(cc_all.delta.y,2));
Cc.delta.meanY = mean(cc_all.delta.y,2);
%other
Cc.other.X     = cc_all.other.x;
Cc.other.stdY  = std(cc_all.other.y,0,2) / sqrt(size(cc_all.other.y,2));
Cc.other.meanY = mean(cc_all.other.y,2);

%diff_real
Cc.diff_real.X     = cc_all.diff_real.x;
Cc.diff_real.stdY  = std(cc_all.diff_real.y,0,2) / sqrt(size(cc_all.diff_real.y,2));
Cc.diff_real.meanY = mean(cc_all.diff_real.y,2);
%diff_real
Cc.real_diff.X     = cc_all.real_diff.x;
Cc.real_diff.stdY  = std(cc_all.real_diff.y,0,2) / sqrt(size(cc_all.real_diff.y,2));
Cc.real_diff.meanY = mean(cc_all.real_diff.y,2);


%% Plot

col_mean = 'k';
col_curve = [0.4 0.4 0.4];
col_downcurve = [0.8 0.1 0.5];
col_down = 'r';

YL = [0 2.5];
fontsize = 20;


%% down delta other
figure, hold on

%down
subplot(1,4,1), hold on
for m=1:length(animals)
    plot(Cc.down.X, cc_meanmouse.down.y{m}, 'color', col_downcurve, 'linewidth',1);
end
area(Cc.down.X, Cc.down.meanY','FaceColor',col_down,'facealpha',0.4,'edgealpha',0);
plot(Cc.down.X, Cc.down.meanY, 'color',col_down, 'linewidth',2),
set(gca,'ylim',YL, 'fontsize', fontsize),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
xlabel('time from ripples (ms)'), ylabel('Occurence of down states'), 
title('Down states'),


%delta diff
subplot(1,4,2), hold on
for m=1:length(animals)
    plot(Cc.ddiff.X, cc_meanmouse.ddiff.y{m}, 'color', col_curve, 'linewidth',1);
end
area(Cc.down.X, Cc.down.meanY','FaceColor',col_down,'facealpha',0.2,'edgealpha',0);
plot(Cc.ddiff.X, Cc.ddiff.meanY, 'color',col_mean, 'linewidth',2),
set(gca,'ylim',[0 3.1], 'fontsize', fontsize),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
% xlabel('time from ripples (ms)'),ylabel('Occurence of delta waves'), 
title('Delta diff'),


%delta with down
subplot(1,4,3), hold on
for m=1:length(animals)
    plot(Cc.delta.X, cc_meanmouse.delta.y{m}, 'color', col_curve, 'linewidth',1);
end
area(Cc.down.X, Cc.down.meanY','FaceColor',col_down,'facealpha',0.2,'edgealpha',0);
plot(Cc.delta.X, Cc.delta.meanY, 'color',col_mean, 'linewidth',2),
set(gca,'ylim',YL, 'fontsize', fontsize),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
% xlabel('time from ripples (ms)'),ylabel('Occurence of delta waves'), 
title({'Real Slow Wave', '(with down)'}),


%fake delta
subplot(1,4,4), hold on
for m=1:length(animals)
    plot(Cc.other.X, cc_meanmouse.other.y{m}, 'color', col_curve, 'linewidth',1);
end
area(Cc.down.X, Cc.down.meanY','FaceColor',col_down,'facealpha',0.2,'edgealpha',0);
plot(Cc.other.X, Cc.other.meanY, 'color',col_mean, 'linewidth',2),
set(gca,'ylim',YL, 'fontsize', fontsize),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
% xlabel('time from ripples (ms)'),ylabel('Occurence of delta waves'), 
title({'Fake Slow Wave', '(no down)'}),




% %% diff real
% figure, hold on
% 
% %diff_real
% subplot(1,4,1), hold on
% for m=1:length(animals)
%     plot(Cc.diff_real.X, cc_meanmouse.diff_real.y{m}, 'color', col_curve, 'linewidth',1);
% end
% % plot(Cc.diff_real.X, Cc.diff_real.meanY, 'color',col_mean, 'linewidth',2),
% line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
% xlabel('time from Diff deltas (ms)'), ylabel('Occurence of real slow waves'), 
% title('Diff vs real delta'),
% 
% %diff_real
% subplot(1,4,2), hold on
% for m=1:length(animals)
%     plot(Cc.real_diff.X, cc_meanmouse.real_diff.y{m}, 'color', col_curve, 'linewidth',1);
% end
% % plot(Cc.real_diff.X, Cc.real_diff.meanY, 'color',col_mean, 'linewidth',2),
% line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
% xlabel('time from real slow waves (ms)'), ylabel('Occurence of diff deltas'), 
% title('Real vs diff delta'),




