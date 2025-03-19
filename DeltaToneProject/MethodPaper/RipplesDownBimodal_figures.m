% RipplesDownBimodal_figures
% 14.03.2018 KJ
% 
% 
% Data to analyse tone effect on signals:
%   - show MUA raster synchronized on ripples
%   - show PFC averaged LFP synchronized on ripples (many depth)
% 
% See AnalysesERPDownDeltaTone AnalysesERPRipplesDelta RipplesDownBimodal1
%   
% 


x_lim = [-0.4 0.4];
ylim_mua = [0 9];
fontsize = 13;


%% PaCx

figure, hold on
y_lim = [-1500 2000];
nb_sample = 500;


subplot(1,3,1); hold on

plot(x_down/1E4 , mean(MatPaDownDeep,1) , 'Linewidth',2,'color','r');
plot(x_down/1E4 , mean(MatPaDownSup,1) , 'Linewidth',2,'color','b');
set(gca, 'YTick',-1000:500:2000,'XLim',x_lim, 'YLim',y_lim, 'FontName','Times','fontsize',fontsize);
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
title('PaCx on down states')
        
%PACx average - inducing
subplot(1,3,2), hold on

plot(x_padeep/1E4 , mean(MatPaDeep(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','r');
plot(x_pasup/1E4 , mean(MatPaSup(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','k');
set(gca,'ylim',ylim_mua, 'YTick',{})

yyaxis left
set(gca, 'YTick',{},'XLim',x_lim, 'YLim',y_lim, 'FontName','Times','fontsize',fontsize);
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
title('PaCx')


%PACx average - not inducing
subplot(1,3,3), hold on

h(1) = plot(x_padeep/1E4 , mean(MatPaDeep(end-nb_sample:end,:),1) , 'Linewidth',2,'color','r');
h(2) = plot(x_pasup/1E4 , mean(MatPaSup(end-nb_sample:end,:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(end-nb_sample:end,:),1) , 'Linewidth',2,'color','k');
set(gca,'ylim',ylim_mua, 'YTick',0:3)

yyaxis left
set(gca, 'YTick',{},'XLim',x_lim, 'YLim',y_lim, 'FontName','Times','fontsize',fontsize);
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
h_leg = legend(h,'deep', 'sup', 'MUA PFCx'); set(h_leg,'FontSize',fontsize);
title('PaCx')





%% MOCx


figure, hold on
y_lim = [-800 600];
nb_sample = 1000;

%MoCx average -on down states
subplot(1,3,1); hold on

plot(x_down/1E4 , mean(MatMoDownDeep,1) , 'Linewidth',2,'color','r');
plot(x_down/1E4 , mean(MatMoDownSup,1) , 'Linewidth',2,'color','b');
set(gca, 'YTick',-1000:500:2000,'XLim',x_lim, 'ylim',y_lim, 'FontName','Times','fontsize',fontsize);
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
title('MoCx on down states')


%MoCx average - inducing
subplot(1,3,2), hold on

h(1) = plot(x_modeep/1E4 , mean(MatMoDeep(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','r');
h(2) = plot(x_mosup/1E4 , mean(MatMoSup(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','k');
set(gca,'ylim',ylim_mua, 'YTick',{})

yyaxis left
set(gca, 'YTick',{},'XLim',x_lim, 'YLim',y_lim, 'FontName','Times','fontsize',fontsize);
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
title('MoCx')

%MoCx average - not inducing
subplot(1,3,3), hold on

h(1) = plot(x_modeep/1E4 , mean(MatMoDeep(end-nb_sample:end,:),1) , 'Linewidth',2,'color','r');
h(2) = plot(x_mosup/1E4 , mean(MatMoSup(end-nb_sample:end,:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(end-nb_sample:end,:),1) , 'Linewidth',2,'color','k');
set(gca,'ylim',ylim_mua, 'YTick',0:3)

yyaxis left
set(gca, 'YTick',{},'XLim',x_lim, 'YLim',y_lim, 'FontName','Times','fontsize',fontsize);
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
h_leg = legend(h,'deep', 'sup', 'MUA PFCx'); set(h_leg,'FontSize',fontsize);
title('MoCx')





%% PFCx

figure, hold on
y_lim = [-1200 2000];
nb_sample = 1000;


%PFC average - inducing
subplot(1,3,2), hold on

h(1) = plot(x_deep/1E4 , mean(MatDeep(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','r');
h(2) = plot(x_sup/1E4 , mean(MatSup(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','k');
set(gca,'ylim',ylim_mua, 'YTick',{})

yyaxis left
set(gca, 'YTick',-1000:500:2000, 'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',fontsize);
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
title('Ripples inducing Down states');

%PFC average - not inducing
subplot(1,3,3), hold on

h(1) = plot(x_deep/1E4 , mean(MatDeep(end-nb_sample:end,:),1) , 'Linewidth',2,'color','r');
h(2) = plot(x_sup/1E4 , mean(MatSup(end-nb_sample:end,:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(end-nb_sample:end,:),1) , 'Linewidth',2,'color','k');
set(gca,'ylim',ylim_mua, 'YTick',0:3)

yyaxis left
set(gca, 'XLim',x_lim, 'YTick',{}, 'YLim',y_lim,'FontName','Times','fontsize',fontsize);
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
h_leg = legend(h,'PFCx deep', 'PFCx sup', 'MUA PFCx'); set(h_leg,'FontSize',fontsize);
title('Ripples not inducing Down states');





%MUA raster
figure, hold on
imagesc(x_mua/1E4, 1:size(MatMUA,1), MatMUA), hold on
axis xy, ylabel('# ripples'), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
line(get(gca,'xlim'), [sum(induce_down) sum(induce_down)],'color','k','linewidth',3), hold on
set(gca,'YLim', [0 size(MatMUA,1)], 'ytick',0:1000:3000, 'ylim',[0 3200], 'XLim',x_lim, 'xtick',-0.4:0.2:0.4) 
set(gca,'FontName','Times','fontsize',fontsize);
hb = colorbar('location','eastoutside'); hold on
caxis([0 12])















