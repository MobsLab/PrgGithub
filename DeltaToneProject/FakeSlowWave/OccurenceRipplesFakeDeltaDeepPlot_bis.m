%%OccurenceRipplesFakeDeltaDeepPlot_bis
% 09.09.2019 KJ
%
% Infos
%   script about real and fake slow waves : MUA and down
%
% see
%    OccurenceRipplesFakeDeltaDeep_bis OccurenceRipplesFakeDeltaSupPlot


% load
clear
load(fullfile(FolderDeltaDataKJ,'OccurenceRipplesFakeDeltaDeep.mat'))

animals = unique(ripples_res.name);
smoothing = 1;

cc_all.down.y   = [];
cc_all.deltas.y = [];
cc_all.good.y   = [];
cc_all.fake.y   = [];

for m=1:length(animals)

    cc_mouse.down.y   = [];
    cc_mouse.deltas.y = [];
    cc_mouse.good.y   = [];
    cc_mouse.fake.y   = [];
    
    %loop over records of animals
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
            
            cc_mouse.down.x   = ripples_res.cc.down{p}(:,1);
            cc_mouse.deltas.x = ripples_res.cc.deltas{p}(:,1);
            cc_mouse.good.x   = ripples_res.cc.good{p}(:,1);
            cc_mouse.fake.x   = ripples_res.cc.fake{p}(:,1);
            
%             norm_factor.down   = ripples_res.nb.down{p};
%             norm_factor.deltas = ripples_res.nb.deltas{p};
%             norm_factor.good   = ripples_res.nb.good{p};
%             norm_factor.fake   = ripples_res.nb.fake{p};
            
            norm_factor.down   = mean(ripples_res.cc.down{p}(:,2));
            norm_factor.deltas = mean(ripples_res.cc.deltas{p}(:,2));
            norm_factor.good   = mean(ripples_res.cc.good{p}(:,2));
            norm_factor.fake   = mean(ripples_res.cc.fake{p}(:,2));
            
            cc_mouse.down.y   = [cc_mouse.down.y Smooth(ripples_res.cc.down{p}(:,2)/norm_factor.down,smoothing)];
            cc_mouse.deltas.y = [cc_mouse.deltas.y Smooth(ripples_res.cc.deltas{p}(:,2)/norm_factor.deltas,smoothing)];
            cc_mouse.good.y   = [cc_mouse.good.y Smooth(ripples_res.cc.good{p}(:,2)/norm_factor.good,smoothing)];
            cc_mouse.fake.y   = [cc_mouse.fake.y Smooth(ripples_res.cc.fake{p}(:,2)/norm_factor.fake,smoothing)];
            
        end
    end
    
    %abscissa
    cc_all.down.x   = cc_mouse.down.x;
    cc_all.deltas.x = cc_mouse.deltas.x;
    cc_all.good.x   = cc_mouse.good.x;
    cc_all.fake.x   = cc_mouse.fake.x;
    %average of mouse
    cc_all.down.y   = [cc_all.down.y mean(cc_mouse.down.y,2)];
    cc_all.deltas.y = [cc_all.deltas.y mean(cc_mouse.deltas.y,2)];
    cc_all.good.y   = [cc_all.good.y mean(cc_mouse.good.y,2)];
    cc_all.fake.y   = [cc_all.fake.y mean(cc_mouse.fake.y,2)];

end

%down
Cc.down.X     = cc_all.down.x;
Cc.down.stdY  = std(cc_all.down.y,0,2) / sqrt(size(cc_all.down.y,2));
Cc.down.meanY = mean(cc_all.down.y,2);
%deltas
Cc.deltas.X     = cc_all.deltas.x;
Cc.deltas.stdY  = std(cc_all.deltas.y,0,2) / sqrt(size(cc_all.deltas.y,2));
Cc.deltas.meanY = mean(cc_all.deltas.y,2);
%good
Cc.good.X     = cc_all.good.x;
Cc.good.stdY  = std(cc_all.good.y,0,2) / sqrt(size(cc_all.good.y,2));
Cc.good.meanY = mean(cc_all.good.y,2);
%fake
Cc.fake.X     = cc_all.fake.x;
Cc.fake.stdY  = std(cc_all.fake.y,0,2) / sqrt(size(cc_all.fake.y,2));
Cc.fake.meanY = mean(cc_all.fake.y,2);


%% Plot
fontsize = 18;
color_down = 'k';
color_deltas = [0.7 0.7 0.7];
color_good = 'b';
color_fake = 'r';


figure, hold on

%down
subplot(2,2,1), hold on
Hs = shadedErrorBar(Cc.down.X, Cc.down.meanY, Cc.down.stdY,{},0.4);
Hs.patch.FaceColor = color_down;
plot(Cc.down.X, Cc.down.meanY, 'color', color_down, 'linewidth',2);

line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
xlabel('time from ripples (ms)'),
ylabel('Normalized occurence of down states'), 
title('Down'),

%deltas
subplot(2,2,2), hold on
Hs = shadedErrorBar(Cc.deltas.X, Cc.deltas.meanY, Cc.deltas.stdY,{},0.4);
Hs.patch.FaceColor = color_deltas;
plot(Cc.deltas.X, Cc.deltas.meanY, 'color', color_deltas, 'linewidth',2);

line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
xlabel('time from ripples (ms)'),
ylabel('Normalized occurence of delta waves'), 
title('Delta waves (diff)'),

%good
subplot(2,2,3), hold on
Hs = shadedErrorBar(Cc.good.X, Cc.good.meanY, Cc.good.stdY,{},0.4);
Hs.patch.FaceColor = color_good;
plot(Cc.good.X, Cc.good.meanY, 'color', color_good, 'linewidth',2);

line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
xlabel('time from ripples (ms)'),
ylabel('Normalized occurence of delta waves'), 
title('Delta waves (sup - good)'),

%good
subplot(2,2,4), hold on
Hs = shadedErrorBar(Cc.fake.X, Cc.fake.meanY, Cc.fake.stdY,{},0.4);
Hs.patch.FaceColor = color_fake;
plot(Cc.fake.X, Cc.fake.meanY, 'color', color_fake, 'linewidth',2);

line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
xlabel('time from ripples (ms)'),
ylabel('Normalized occurence of delta waves'), 
title('Delta waves (sup - fake)'),


