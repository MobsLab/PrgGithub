%%OccurenceRipplesLocalDeltaPlot2
% 09.09.2019 KJ
%
% Infos
%   script about real and fake slow waves : MUA and down
%
% see
%    OccurenceRipplesFakeDeltaSup OccurenceRipplesLocalDeltaPlot


% load
clear
load(fullfile(FolderDeltaDataKJ,'OccurenceRipplesLocalDelta.mat'))

animals = unique(ripples_res.name);
smoothing = 0;
normalized = 0;
 
%init
cc_all.down.global.y  = [];
cc_all.down.local.y   = [];
cc_all.delta.global.y = [];
cc_all.delta.local.y  = [];
cc_all.delta.fake.y   = [];


for m=1:length(animals)

    cc_mouse.down.global.y  = [];
    cc_mouse.down.local.y   = [];
    cc_mouse.delta.global.y = [];
    cc_mouse.delta.local.y  = [];
    cc_mouse.delta.fake.y   = [];
    
    %loop over records of animals
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
            
            %global down
            cc_mouse.down.global.x  = ripples_res.down.global{p}(:,1);
            if normalized
                x_norm = cc_mouse.down.global.x<-800;
                normfact.down.global  = mean(ripples_res.down.global{p}(x_norm,2));
            else
                normfact.down.global  = 1; 
            end
            cc_mouse.down.global.y  = [cc_mouse.down.global.y Smooth(ripples_res.down.global{p}(:,2)/normfact.down.global, smoothing)];
            
            
            %per tetrode
            for tt=1:ripples_res.nb_tetrodes{p}
                
                cc_mouse.down.local.x   = ripples_res.down.local{p,tt}(:,1);
                cc_mouse.delta.global.x = ripples_res.delta.global{p,tt}(:,1);
                cc_mouse.delta.local.x  = ripples_res.delta.local{p,tt}(:,1);
                cc_mouse.delta.fake.x   = ripples_res.delta.fake{p,tt}(:,1);

                if normalized
                    x_norm = cc_mouse.down.local.x<-800;
                    normfact.down.local   = mean(ripples_res.down.local{p,tt}(x_norm,2));
                    normfact.delta.global = mean(ripples_res.delta.global{p,tt}(x_norm,2));
                    normfact.delta.local  = mean(ripples_res.delta.local{p,tt}(x_norm,2));
                    normfact.delta.fake   = mean(ripples_res.delta.fake{p,tt}(x_norm,2));
                else
                    normfact.down.local   = 1;
                    normfact.delta.global = 1; 
                    normfact.delta.local  = 1;
                    normfact.delta.fake   = 1;
                end

                cc_mouse.down.local.y   = [cc_mouse.down.local.y Smooth(ripples_res.down.local{p,tt}(:,2)/normfact.down.local, smoothing)];
                cc_mouse.delta.global.y = [cc_mouse.delta.global.y Smooth(ripples_res.delta.global{p,tt}(:,2)/normfact.delta.global, smoothing)];
                cc_mouse.delta.local.y  = [cc_mouse.delta.local.y Smooth(ripples_res.delta.local{p,tt}(:,2)/normfact.delta.local, smoothing)];
                cc_mouse.delta.fake.y   = [cc_mouse.delta.fake.y Smooth(ripples_res.delta.fake{p,tt}(:,2)/normfact.delta.fake, smoothing)];
            end
            
        end
    end
    
    %average of mouse
    cc_meanmouse.down.global.y{m}  = mean(cc_mouse.down.global.y,2);
    cc_meanmouse.down.local.y{m}   = mean(cc_mouse.down.local.y,2);
    cc_meanmouse.delta.global.y{m} = mean(cc_mouse.delta.global.y,2);
    cc_meanmouse.delta.local.y{m}  = mean(cc_mouse.delta.local.y,2);
    cc_meanmouse.delta.fake.y{m}   = mean(cc_mouse.delta.fake.y,2);
    
    %abscissa
    cc_all.down.global.x  = cc_mouse.down.global.x;
    cc_all.down.local.x   = cc_mouse.down.local.x;
    cc_all.delta.global.x = cc_mouse.delta.global.x;
    cc_all.delta.local.x  = cc_mouse.delta.local.x;
    cc_all.delta.fake.x   = cc_mouse.delta.fake.x;
    
    %concatenate
    cc_all.down.global.y  = [cc_all.down.global.y cc_meanmouse.down.global.y{m}];
    cc_all.down.local.y   = [cc_all.down.local.y cc_meanmouse.down.local.y{m}];
    cc_all.delta.global.y = [cc_all.delta.global.y cc_meanmouse.delta.global.y{m}];
    cc_all.delta.local.y  = [cc_all.delta.local.y cc_meanmouse.delta.local.y{m}];
    cc_all.delta.fake.y   = [cc_all.delta.fake.y cc_meanmouse.delta.fake.y{m}];
    
end

%down global
Cc.down.global.X     = cc_all.down.global.x;
Cc.down.global.stdY  = std(cc_all.down.global.y,0,2) / sqrt(size(cc_all.down.global.y,2));
Cc.down.global.meanY = mean(cc_all.down.global.y,2);
%down local
Cc.down.local.X     = cc_all.down.local.x;
Cc.down.local.stdY  = std(cc_all.down.local.y,0,2) / sqrt(size(cc_all.down.local.y,2));
Cc.down.local.meanY = mean(cc_all.down.local.y,2);
%delta global
Cc.delta.global.X     = cc_all.delta.global.x;
Cc.delta.global.stdY  = std(cc_all.delta.global.y,0,2) / sqrt(size(cc_all.delta.global.y,2));
Cc.delta.global.meanY = mean(cc_all.delta.global.y,2);
%delta local
Cc.delta.local.X     = cc_all.delta.local.x;
Cc.delta.local.stdY  = std(cc_all.delta.local.y,0,2) / sqrt(size(cc_all.delta.local.y,2));
Cc.delta.local.meanY = mean(cc_all.delta.local.y,2);
%delta fake
Cc.delta.fake.X     = cc_all.delta.fake.x;
Cc.delta.fake.stdY  = std(cc_all.delta.fake.y,0,2) / sqrt(size(cc_all.delta.fake.y,2));
Cc.delta.fake.meanY = mean(cc_all.delta.fake.y,2);



%% Plot

col_mean = 'k';
col_curve = [0.6 0.6 0.6];

figure, hold on

%down global
subplot(2,3,1), hold on
for m=1:length(animals)
    plot(cc_all.down.global.x, cc_meanmouse.down.global.y{m}, 'color', col_curve, 'linewidth',1);
end
plot(Cc.down.global.X,Cc.down.global.meanY,'color',col_mean,'linewidth',2),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
xlabel('time from ripples (ms)'),
ylabel('Normalized occurence of down states'), 
title('Global Down'),

%down local
subplot(2,3,2), hold on
for m=1:length(animals)
    plot(cc_all.down.local.x, cc_meanmouse.down.local.y{m}, 'color', col_curve, 'linewidth',1);
end
plot(Cc.down.local.X,Cc.down.local.meanY,'color',col_mean,'linewidth',2),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
xlabel('time from ripples (ms)'),
ylabel('Normalized occurence of local down'), 
title('Local Down'),

%delta global
subplot(2,3,4), hold on
for m=1:length(animals)
    plot(cc_all.delta.global.x, cc_meanmouse.delta.global.y{m}, 'color', col_curve, 'linewidth',1);
end
plot(Cc.delta.global.X,Cc.delta.global.meanY,'color',col_mean,'linewidth',2),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
xlabel('time from ripples (ms)'),
ylabel('Normalized occurence of delta waves'), 
title('Global Delta (linked to local down)'),

%delta local
subplot(2,3,5), hold on
for m=1:length(animals)
    plot(cc_all.delta.local.x, cc_meanmouse.delta.local.y{m}, 'color', col_curve, 'linewidth',1);
end
plot(Cc.delta.local.X,Cc.delta.local.meanY,'color',col_mean,'linewidth',2),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
xlabel('time from ripples (ms)'),
ylabel('Normalized occurence of delta'), 
title('Local delta (linked to local down)'),

%delta fake
subplot(2,3,3), hold on
for m=1:length(animals)
    plot(cc_all.delta.fake.x, cc_meanmouse.delta.fake.y{m}, 'color', col_curve, 'linewidth',1);
end
plot(Cc.delta.fake.X,Cc.delta.fake.meanY,'color',col_mean,'linewidth',2),
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
xlabel('time from ripples (ms)'),
ylabel('Normalized occurence of delta'), 
title('Fake delta'),



