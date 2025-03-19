%%RipplesDownMeancurvesPlot
% 26.08.2019 KJ
%
% Meancurves on ripples
%
%
% see
%   FigureExampleFakeSlowWaveRipple1 RipplesDownMeancurves
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'RipplesDownMeancurves.mat'))
animals = unique(ripples_res.name);


%% distrib

%all ripples
ripall.mua = [];
ripall.hpc = [];
ripall.deep = [];
ripall.sup = [];

%ripples>down states
ripdown.mua = [];
ripdown.hpc = [];
ripdown.deep = [];
ripdown.sup = [];

%ripples>fake delta
ripfake.mua = [];
ripfake.hpc = [];
ripfake.deep = [];
ripfake.sup = [];

%ripples>nothing
nofake.mua = [];
nofake.hpc = [];
nofake.deep = [];
nofake.sup = [];


for m=1:length(animals)
    
    %all ripples
    ripall.mua_mouse  = [];
    ripall.hpc_mouse  = [];
    ripall.deep_mouse = [];
    ripall.sup_mouse  = [];
    %ripples>down states
    ripdown.mua_mouse  = [];
    ripdown.hpc_mouse  = [];
    ripdown.deep_mouse = [];
    ripdown.sup_mouse  = [];
    %ripples>fake delta
    ripfake.mua_mouse  = [];
    ripfake.hpc_mouse  = [];
    ripfake.deep_mouse = [];
    ripfake.sup_mouse  = [];
    %ripples>nothing
    nofake.mua_mouse  = [];
    nofake.hpc_mouse  = [];
    nofake.deep_mouse = [];
    nofake.sup_mouse  = [];
    
    %loop over records of animals
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
        
            %all ripples
            ripall.mua_mouse  = [ripall.mua_mouse ripples_res.met_rip.mua{p}(:,2)];
            ripall.hpc_mouse  = [ripall.hpc_mouse ripples_res.met_rip.hpc{p}(:,2)];
            ripall.deep_mouse = [ripall.deep_mouse ripples_res.met_rip.deep{p}(:,2)];
            ripall.sup_mouse  = [ripall.sup_mouse ripples_res.met_rip.sup{p}(:,2)];
            %ripples>down states
            ripdown.mua_mouse  = [ripdown.mua_mouse ripples_res.met_ripdown.mua{p}(:,2)];
            ripdown.hpc_mouse  = [ripdown.hpc_mouse ripples_res.met_ripdown.hpc{p}(:,2)];
            ripdown.deep_mouse = [ripdown.deep_mouse ripples_res.met_ripdown.deep{p}(:,2)];
            ripdown.sup_mouse  = [ripdown.sup_mouse ripples_res.met_ripdown.sup{p}(:,2)];
            %ripples>fake delta
            ripfake.mua_mouse  = [ripfake.mua_mouse ripples_res.met_ripfake	.mua{p}(:,2)];
            ripfake.hpc_mouse  = [ripfake.hpc_mouse ripples_res.met_ripfake.hpc{p}(:,2)];
            ripfake.deep_mouse = [ripfake.deep_mouse ripples_res.met_ripfake.deep{p}(:,2)];
            ripfake.sup_mouse  = [ripfake.sup_mouse ripples_res.met_ripfake.sup{p}(:,2)];
            %ripples>nothing
            nofake.mua_mouse  = [nofake.mua_mouse ripples_res.met_nofake.mua{p}(:,2)];
            nofake.hpc_mouse  = [nofake.hpc_mouse ripples_res.met_nofake.hpc{p}(:,2)];
            nofake.deep_mouse = [nofake.deep_mouse ripples_res.met_nofake.deep{p}(:,2)];
            nofake.sup_mouse  = [nofake.sup_mouse ripples_res.met_nofake.sup{p}(:,2)];
        end
    end

    %% concatenate average
    
    %all ripples
    ripall.mua   = [ripall.mua nanmean(ripall.mua_mouse,2)];
    ripall.hpc   = [ripall.hpc nanmean(ripall.hpc_mouse,2)];
    ripall.deep  = [ripall.deep nanmean(ripall.deep_mouse,2)];
    ripall.sup   = [ripall.sup nanmean(ripall.sup_mouse,2)];
    %ripples>down states
    ripdown.mua   = [ripdown.mua nanmean(ripdown.mua_mouse,2)];
    ripdown.hpc   = [ripdown.hpc nanmean(ripdown.hpc_mouse,2)];
    ripdown.deep  = [ripdown.deep nanmean(ripdown.deep_mouse,2)];
    ripdown.sup   = [ripdown.sup nanmean(ripdown.sup_mouse,2)];
    %ripples>fake delta
    ripfake.mua   = [ripfake.mua nanmean(ripfake.mua_mouse,2)];
    ripfake.hpc   = [ripfake.hpc nanmean(ripfake.hpc_mouse,2)];
    ripfake.deep  = [ripfake.deep nanmean(ripfake.deep_mouse,2)];
    ripfake.sup   = [ripfake.sup nanmean(ripfake.sup_mouse,2)];
    %ripples>nothing
    nofake.mua   = [nofake.mua nanmean(nofake.mua_mouse,2)];
    nofake.hpc   = [nofake.hpc nanmean(nofake.hpc_mouse,2)];
    nofake.deep  = [nofake.deep nanmean(nofake.deep_mouse,2)];
    nofake.sup   = [nofake.sup nanmean(nofake.sup_mouse,2)];

end


%mean and std

%all ripples
ripall.std.mua  = std(ripall.mua,1,2) / sqrt(size(ripall.mua,2));
ripall.std.hpc  = std(ripall.hpc,1,2) / sqrt(size(ripall.hpc,2));
ripall.std.deep = std(ripall.deep,1,2) / sqrt(size(ripall.deep,2));
ripall.std.sup  = std(ripall.sup,1,2) / sqrt(size(ripall.sup,2));
ripall.mean.mua  = mean(ripall.mua,2);
ripall.mean.hpc  = mean(ripall.hpc,2);
ripall.mean.deep = mean(ripall.deep,2);
ripall.mean.sup  = mean(ripall.sup,2);
%ripples>down states
ripdown.std.mua  = std(ripdown.mua,1,2) / sqrt(size(ripdown.mua,2));
ripdown.std.hpc  = std(ripdown.hpc,1,2) / sqrt(size(ripdown.hpc,2));
ripdown.std.deep = std(ripdown.deep,1,2) / sqrt(size(ripdown.deep,2));
ripdown.std.sup  = std(ripdown.sup,1,2) / sqrt(size(ripdown.sup,2));
ripdown.mean.mua  = mean(ripdown.mua,2);
ripdown.mean.hpc  = mean(ripdown.hpc,2);
ripdown.mean.deep = mean(ripdown.deep,2);
ripdown.mean.sup  = mean(ripdown.sup,2);
%ripples>fake delta
ripfake.std.mua  = std(ripfake.mua,1,2) / sqrt(size(ripfake.mua,2));
ripfake.std.hpc  = std(ripfake.hpc,1,2) / sqrt(size(ripfake.hpc,2));
ripfake.std.deep = std(ripfake.deep,1,2) / sqrt(size(ripfake.deep,2));
ripfake.std.sup  = std(ripfake.sup,1,2) / sqrt(size(ripfake.sup,2));
ripfake.mean.mua  = mean(ripfake.mua,2);
ripfake.mean.hpc  = mean(ripfake.hpc,2);
ripfake.mean.deep = mean(ripfake.deep,2);
ripfake.mean.sup  = mean(ripfake.sup,2);
%ripples>nothin
nofake.std.mua  = std(nofake.mua,1,2) / sqrt(size(nofake.mua,2));
nofake.std.hpc  = std(nofake.hpc,1,2) / sqrt(size(nofake.hpc,2));
nofake.std.deep = std(nofake.deep,1,2) / sqrt(size(nofake.deep,2));
nofake.std.sup  = std(nofake.sup,1,2) / sqrt(size(nofake.sup,2));
nofake.mean.mua  = mean(nofake.mua,2);
nofake.mean.hpc  = mean(nofake.hpc,2);
nofake.mean.deep = mean(nofake.deep,2);
nofake.mean.sup  = mean(nofake.sup,2);


%% x_plot
x_plot = ripples_res.met_rip.mua{1}(:,1);



%% Plot

color_hpc  = [0 0.4 0];
color_deep = 'r';
color_sup  = 'b';
color_mua = 'k';
smoothing = 0;

figure, hold on

%all ripples
subplot(2,2,1), hold on
h(1) = plot(x_plot, ripall.mean.deep, 'color',color_deep);
h(2) = plot(x_plot, ripall.mean.sup, 'color',color_sup);
h(3) = plot(x_plot, ripall.mean.hpc, 'color',color_hpc);
% hs(1) = shadedErrorBar(x_plot, Smooth(ripall.mean.deep, smoothing), Smooth(ripall.std.deep,  smoothing), color_deep);
% hs(2) = shadedErrorBar(x_plot, Smooth(ripall.mean.sup, smoothing), Smooth(ripall.std.sup,  smoothing), color_sup);
% hs(3) = shadedErrorBar(x_plot, Smooth(ripall.mean.hpc, smoothing), Smooth(ripall.std.hpc,  smoothing), color_hpc);
xlim([-800 800]), ylim([-800 1400]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('time from ripples (ms)'), ylabel('mean amplitude')
legend(h,'deep','sup','hpc')


%ripples>down states
subplot(2,2,2), hold on
h(1) = plot(x_plot, ripdown.mean.deep, 'color',color_deep);
h(2) = plot(x_plot, ripdown.mean.sup, 'color',color_sup);
h(3) = plot(x_plot, ripdown.mean.hpc, 'color',color_hpc);
% hs(1) = shadedErrorBar(x_plot, Smooth(ripdown.mean.deep, smoothing), Smooth(ripdown.std.deep,  smoothing), color_deep);
% hs(2) = shadedErrorBar(x_plot, Smooth(ripdown.mean.sup, smoothing), Smooth(ripdown.std.sup,  smoothing), color_sup);
% hs(3) = shadedErrorBar(x_plot, Smooth(ripdown.mean.hpc, smoothing), Smooth(ripdown.std.hpc,  smoothing), color_hpc);
xlim([-800 800]), ylim([-800 1400]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('time from ripples (ms)'), ylabel('mean amplitude')
legend(h,'deep','sup','hpc'),
title('Ripples followed by a down state'),


%ripples>fake delta
subplot(2,2,3), hold on
h(1) = plot(x_plot, ripfake.mean.deep, 'color',color_deep);
h(2) = plot(x_plot, ripfake.mean.sup, 'color',color_sup);
h(3) = plot(x_plot, ripfake.mean.hpc, 'color',color_hpc);
% hs(1) = shadedErrorBar(x_plot, Smooth(ripfake.mean.deep, smoothing), Smooth(ripfake.std.deep,  smoothing), color_deep);
% hs(2) = shadedErrorBar(x_plot, Smooth(ripfake.mean.sup, smoothing), Smooth(ripfake.std.sup,  smoothing), color_sup);
% hs(3) = shadedErrorBar(x_plot, Smooth(ripfake.mean.hpc, smoothing), Smooth(ripfake.std.hpc,  smoothing), color_hpc);
xlim([-800 800]), ylim([-800 1400]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('time from ripples (ms)'), ylabel('mean amplitude')
legend(h,'deep','sup','hpc'),
title('Ripples followed by a fake delta'),


%ripples>nothing
subplot(2,2,4), hold on
h(1) = plot(x_plot, nofake.mean.deep, 'color',color_deep);
h(2) = plot(x_plot, nofake.mean.sup, 'color',color_sup);
h(3) = plot(x_plot, nofake.mean.hpc, 'color',color_hpc);
% hs(1) = shadedErrorBar(x_plot, Smooth(nofake.mean.deep, smoothing), Smooth(nofake.std.deep,  smoothing), color_deep);
% hs(2) = shadedErrorBar(x_plot, Smooth(nofake.mean.sup, smoothing), Smooth(nofake.std.sup,  smoothing), color_sup);
% hs(3) = shadedErrorBar(x_plot, Smooth(nofake.mean.hpc, smoothing), Smooth(nofake.std.hpc,  smoothing), color_hpc);
xlim([-800 800]), ylim([-800 1400]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('time from ripples (ms)'), ylabel('mean amplitude')
legend(h,'deep','sup','hpc'),
title('Ripples alone'),




















