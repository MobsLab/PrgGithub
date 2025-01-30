%%MeanCurvesMUAFakeDeltaSupPlot
% 05.09.2019 KJ
%
% Infos
%   script about real and fake slow waves : MUA and down
%
% see
%    MeanCurvesMUAFakeDeltaSup FigureExampleFakeSlowWaveSup


% load
clear
load(fullfile(FolderDeltaDataKJ,'MeanCurvesMUAFakeDeltaSup.mat'))

animals = unique(muadelta_res.name);


met_y.all  = [];
met_y.good = [];
met_y.fake = [];

recall.all = []; precision.all = [];
recall.good = []; precision.good = [];
recall.fake = []; precision.fake = [];


for m=1:length(animals)
    
    mouse_y.all  = [];
    mouse_y.good = [];
    mouse_y.fake = [];
    
    recall_mouse.all = []; precision_mouse.all = [];    
    recall_mouse.good = []; precision_mouse.good = [];
    recall_mouse.fake = []; precision_mouse.fake = [];
    
    for p=1:length(muadelta_res.path)
        if strcmpi(muadelta_res.name{p},animals{m})
            
            %MUA
            y_all = muadelta_res.met_mua.all{p}(:,2);
            y_good = muadelta_res.met_mua.good{p}(:,2);
            y_fake = muadelta_res.met_mua.fake{p}(:,2);
            
            y_all = y_all / mean(y_all(1:20));
            y_good = y_good / mean(y_good(1:20));
            y_fake = y_fake / mean(y_fake(1:20));
            
            mouse_y.all  = [mouse_y.all y_all];
            mouse_y.good = [mouse_y.good y_good];
            mouse_y.fake = [mouse_y.fake y_fake];
            
            mouse_x.all  = muadelta_res.met_mua.all{p}(:,1);
            mouse_x.good = muadelta_res.met_mua.good{p}(:,1);
            mouse_x.fake = muadelta_res.met_mua.fake{p}(:,1);
            
            %recall precision
            recall_mouse.all = [recall_mouse.all muadelta_res.all.nb_down{p}/muadelta_res.nb_down{p}];
            recall_mouse.good = [recall_mouse.good muadelta_res.good.nb_down{p}/muadelta_res.nb_down{p}];
            recall_mouse.fake = [recall_mouse.fake muadelta_res.fake.nb_down{p}/muadelta_res.nb_down{p}];
            
            precision_mouse.all = [precision_mouse.all muadelta_res.all.nb_down{p}/muadelta_res.all.nb{p}];
            precision_mouse.good = [precision_mouse.good muadelta_res.good.nb_down{p}/muadelta_res.good.nb{p}];
            precision_mouse.fake = [precision_mouse.fake muadelta_res.fake.nb_down{p}/muadelta_res.fake.nb{p}];
            
        end
    end
    
    %average per mouse
    met_y.all  = [met_y.all mean(mouse_y.all,2)];
    met_y.good = [met_y.good mean(mouse_y.good,2)];
    met_y.fake = [met_y.fake mean(mouse_y.fake,2)];
    
    met_x.all  = mouse_x.all;
    met_x.good = mouse_x.good;
    met_x.fake = mouse_x.fake;
    
    %recall precision
    recall.all(m,1) = 1-mean(recall_mouse.all);
    recall.good(m,1) = 1-mean(recall_mouse.good);
    recall.fake(m,1) = 1-mean(recall_mouse.fake);
    
    precision.all(m,1) = 1-mean(precision_mouse.all);
    precision.good(m,1) = 1-mean(precision_mouse.good);
    precision.fake(m,1) = 1-mean(precision_mouse.fake);
    
end
   
%mean
mua_mean.all.y  = mean(met_y.all, 2);
mua_mean.good.y = mean(met_y.good, 2);
mua_mean.fake.y = mean(met_y.fake, 2);

%std
mua_mean.all.std  = std(met_y.all,0,2) / sqrt(size(met_y.all,2));
mua_mean.good.std = std(met_y.good,0,2) / sqrt(size(met_y.good,2));
mua_mean.fake.std = std(met_y.fake,0,2) / sqrt(size(met_y.fake,2));

%x
mua_mean.all.x  = met_x.all;
mua_mean.good.x = met_x.good;
mua_mean.fake.x = met_x.fake;


%% Plot
fontsize = 22;
color_all = [0.7 0.7 0.7];
color_good = 'b';
color_fake = 'r';
optiontest = 'ranksum';

figure, hold on

subplot(1,3,[1 2]), hold on
% %error shadow
% Hsgood = shadedErrorBar(mua_mean.good.x, mua_mean.good.y, mua_mean.good.std,{},0.4);
% Hsfake = shadedErrorBar(mua_mean.fake.x, mua_mean.fake.y, mua_mean.fake.std,{},0.4);
% Hsgood.patch.FaceColor = color_good;
% Hsfake.patch.FaceColor = color_fake;

errorbar(mua_mean.good.x, mua_mean.good.y, mua_mean.good.std, 'color', color_good,'CapSize',1)
errorbar(mua_mean.fake.x, mua_mean.fake.y, mua_mean.fake.std, 'color', color_fake,'CapSize',1)

%mean curves
h(1) = plot(mua_mean.good.x, mua_mean.good.y, 'color', color_good, 'linewidth',2);
h(2) = plot(mua_mean.fake.x, mua_mean.fake.y, 'color', color_fake, 'linewidth',2);
%properties
set(gca,'YLim', [0 1.8],'XLim',[-600 600],'Fontsize',fontsize);

line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
legend(h,'25% highest inversion', '25% lowest inversion');
xlabel('time from superficial slow wave detection (ms)'),
ylabel('Normalized MUA'), 

%precision
subplot(1,3,3), hold on
PlotErrorBarN_KJ([precision.good precision.fake]*100, 'newfig',0, 'barcolors',{color_good, color_fake}, 'paired',1, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'ylim',[0 100],'xtick',1:2,'XtickLabel',{'high inv','low inv'},'Fontsize',fontsize),
xtickangle(30),
ylabel('% of fake detection'),
title('False positive')

