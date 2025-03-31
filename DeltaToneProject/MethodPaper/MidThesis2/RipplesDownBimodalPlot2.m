% RipplesDownBimodalPlot2
% 25.09.2018 KJ
% 
% 
% Data to analyse tone effect on signals:
%   - show MUA raster synchronized on ripples
%   - show PFC averaged LFP synchronized on ripples (many depth)
%
%   On mouse 243 (PaCx) - plot nights
% 
% See AnalysesERPDownDeltaTone AnalysesERPRipplesDelta RipplesDownBimodal1
%   
% 
% 

if ~exist('ripple_res','var')
    load([FolderDeltaDataKJ '/RipplesDownBimodal2.mat'])
end

for p=5%1:length(ripple_res.path)
    
%     clearvars -except ripple_res p t_before t_after binsize effect_period_down
%     
%     try
% 
%         induce_down = ripple_res.induce_down{p};
%         idx_notinduced = find(induce_down==0);
% 
%         raster_deep = Data(ripple_res.raster_deep{p});
%         x_deep = Range(ripple_res.raster_deep{p});
% 
%         raster_sup = Data(ripple_res.raster_sup{p});
%         x_sup = Range(ripple_res.raster_sup{p});
% 
%         raster_mua = Data(ripple_res.raster_mua{p});
%         x_mua = Range(ripple_res.raster_mua{p});
% 
%         raster_padeep = Data(ripple_res.pacx_deep{p});
%         x_padeep = Range(ripple_res.pacx_deep{p});
% 
%         raster_pasup = Data(ripple_res.pacx_sup{p});
%         x_pasup = Range(ripple_res.pacx_sup{p});
% 
%         raster_modeep = Data(ripple_res.mocx_deep{p});
%         x_modeep = Range(ripple_res.mocx_deep{p});
% 
%         raster_mosup = Data(ripple_res.mocx_sup{p});
%         x_mosup = Range(ripple_res.mocx_sup{p});
% 
% 
%         %raster on down
%         MatPaDownDeep = Data(ripple_res.down.pacx_deep{p})';
%         MatPaDownSup = Data(ripple_res.down.pacx_sup{p})';
%         x_down = Range(ripple_res.down.pacx_deep{p});
% 
%         %raster on down
%         MatMoDownDeep = Data(ripple_res.down.mocx_deep{p})';
%         MatMoDownSup = Data(ripple_res.down.mocx_sup{p})';
%         x_down = Range(ripple_res.down.mocx_deep{p});
% 
% 
%         %% Sort
% 
%         direction='ascend';
% 
%         %sort ripples by the response of PFC deep
%         [~, id_deep] = sort(mean(raster_deep(x_deep>0 & x_deep<effect_period_down,induce_down==0),1),direction);
%         %sort ripples by the response of PFC sup
%         [~, id_sup] = sort(mean(raster_sup(x_sup>0 & x_sup<effect_period_down,induce_down==0),1),direction);
%         %sort ripples by the response of MUA
%         [~, id_mua] = sort(mean(raster_mua(x_mua>0 & x_mua<effect_period_down,induce_down==0),1),direction);
% 
%         %sort ripples by the response of PaCx deep
%         [~, id_padeep] = sort(mean(raster_padeep(x_padeep>0 & x_padeep<effect_period_down,induce_down==0),1),direction);
%         %sort ripples by the response of PaCx sup
%         [~, id_pasup] = sort(mean(raster_pasup(x_pasup>0 & x_pasup<effect_period_down,induce_down==0),1),direction);
% 
%         %sort ripples by the response of MoCx deep
%         [~, id_modeep] = sort(mean(raster_modeep(x_modeep>0 & x_modeep<effect_period_down,induce_down==0),1),direction);
%         %sort ripples by the response of MoCx sup
%         [~, id_mosup] = sort(mean(raster_mosup(x_mosup>0 & x_mosup<effect_period_down,induce_down==0),1),direction);
% 
%         
% 
%         %% ordering
% 
%         nb_sample=100; %for average
%         idx1 = id_sup;
% 
%         %mua
%         mat1 = raster_mua(:,induce_down==0);
%         mat2 = raster_mua(:,induce_down==1);
%         MatMUA = [mat2' ; mat1(:,idx1)'];
%         %deep
%         mat1 = raster_deep(:,induce_down==0);
%         mat2 = raster_deep(:,induce_down==1);
%         MatDeep = [mat2' ; mat1(:,idx1)'];
%         %sup
%         mat1 = raster_sup(:,induce_down==0);
%         mat2 = raster_sup(:,induce_down==1);
%         MatSup = [mat2' ; mat1(:,idx1)'];
% 
% 
%         %PaCx deep
%         mat1 = raster_padeep(:,induce_down==0);
%         mat2 = raster_padeep(:,induce_down==1);
%         MatPaDeep = [mat2' ; mat1(:,id_pasup)'];
%         %PaCx sup
%         mat1 = raster_pasup(:,induce_down==0);
%         mat2 = raster_pasup(:,induce_down==1);
%         MatPaSup = [mat2' ; mat1(:,id_pasup)'];
% 
%         %MoCx deep
%         mat1 = raster_modeep(:,induce_down==0);
%         mat2 = raster_modeep(:,induce_down==1);
%         MatMoDeep = [mat2' ; mat1(:,id_mosup)'];
%         %MoCx sup
%         mat1 = raster_mosup(:,induce_down==0);
%         mat2 = raster_mosup(:,induce_down==1);
%         MatMoSup = [mat2' ; mat1(:,id_mosup)'];



        %% PLOT
        gap = [0.03 0.06];
        x_lim = [-400 400];
        y_lim = [-1000 2000];
        ylim_mua = [0 10];
        fontsize = 16;
        
        figure, hold on
        %MUA raster
        imagesc(x_mua/1E4, 1:size(MatMUA,2), MatMUA), hold on
        axis xy, ylabel('# ripples'), hold on
        line([0 0], ylim,'Linewidth',2,'color','k'), hold on
        line(xlim, get(gca,'xlim'),'color','k'), hold on
        set(gca,'YLim', [0 size(MatMUA,2)], 'Yticklabel',{[]},'Xticklabel',{[]}, 'XLim',x_lim,'FontName','Times','fontsize',fontsize);
        hb = colorbar('location','eastoutside'); hold on
        

        figure, hold on
        %PFC average - not inducing
        subtightplot(3,3,1,gap); hold on

        h(1) = plot(x_deep/10 , mean(MatDeep(end-nb_sample:end,:),1) , 'Linewidth',2,'color','r');
        h(2) = plot(x_sup/10 , mean(MatSup(end-nb_sample:end,:),1) , 'Linewidth',2,'color','b');
        yyaxis right
        h(3) = plot(x_mua/10 , mean(MatMUA(end-nb_sample:end,:),1) , 'Linewidth',2,'color','k');
        set(gca, 'YTick',1:3,'ylim', ylim_mua),

        yyaxis left
        line([0 0], ylim,'color','k','linewidth',2), hold on
        h_leg = legend(h,'deep', 'sup', 'MUA'); set(h_leg,'FontSize',20);
        set(gca, 'YTick',[-1000 0 1000 2000],'Xticklabel',{[]},'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',fontsize);
        title('Ripples not inducing Down states');

        %PFC average - inducing
        subtightplot(3,3,2,gap); hold on

        h(1) = plot(x_deep/10 , mean(MatDeep(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','r');
        h(2) = plot(x_sup/10 , mean(MatSup(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','b');
        yyaxis right
        h(3) = plot(x_mua/10 , mean(MatMUA(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','k');
        set(gca, 'YTick',1:3,'ylim', ylim_mua),

        yyaxis left
        line([0 0], ylim,'color','k','linewidth',2), hold on
%         h_leg = legend(h,'PFCx deep', 'PFCx sup', 'MUA'); set(h_leg,'FontSize',fontsize);
        set(gca, 'YTick',[-1000 0 1000 2000],'Xticklabel',{[]},'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',fontsize);
        title('Ripples inducing Down states');


        %PACx average - not inducing
        subtightplot(3,3,4,gap); hold on

        h(1) = plot(x_padeep/10 , mean(MatPaDeep(end-nb_sample:end,:),1) , 'Linewidth',2,'color','r');
        h(2) = plot(x_pasup/10 , mean(MatPaSup(end-nb_sample:end,:),1) , 'Linewidth',2,'color','b');
        yyaxis right
        h(3) = plot(x_mua/10 , mean(MatMUA(end-nb_sample:end,:),1) , 'Linewidth',2,'color','k');
        set(gca, 'YTick',1:3,'ylim', ylim_mua),

        yyaxis left
        ylim([-1400 2000]),
        line([0 0], ylim,'color','k','linewidth',2), hold on
        set(gca, 'YTick',[-1000 0 1000 2000],'Xticklabel',{[]},'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
%         title('PaCx')
        %PACx average - inducing
        subtightplot(3,3,5,gap); hold on

        h(1) = plot(x_padeep/10 , mean(MatPaDeep(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','r');
        h(2) = plot(x_pasup/10 , mean(MatPaSup(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','b');
        yyaxis right
        h(3) = plot(x_mua/10 , mean(MatMUA(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','k');
        set(gca, 'YTick',1:3,'ylim', ylim_mua),

        yyaxis left
        ylim([-1400 2000]),
        line([0 0], ylim,'color','k','linewidth',2), hold on
        set(gca, 'YTick',[-1000 0 1000 2000],'Xticklabel',{[]},'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
%         title('PaCx')
        %PACx average -on down states
        subtightplot(3,3,6,gap); hold on

        h(1) = plot(x_down/10 , mean(MatPaDownDeep,1) , 'Linewidth',2,'color','r');
        h(2) = plot(x_down/10 , mean(MatPaDownSup,1) , 'Linewidth',2,'color','b');
        ylim([-1400 2000]),
        line([0 0], ylim,'color','k','linewidth',2), hold on
        set(gca, 'YTick',[-1000 0 1000 2000],'Xticklabel',{[]},'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
        title('Mean LFP - Down states')
        
        
        %MoCx average - not inducing
        subtightplot(3,3,7,gap); hold on

        h(1) = plot(x_modeep/10 , mean(MatMoDeep(end-nb_sample:end,:),1) , 'Linewidth',2,'color','r');
        h(2) = plot(x_mosup/10 , mean(MatMoSup(end-nb_sample:end,:),1) , 'Linewidth',2,'color','b');
        yyaxis right
        h(3) = plot(x_mua/10 , mean(MatMUA(end-nb_sample:end,:),1) , 'Linewidth',2,'color','k');
        set(gca, 'YTick',1:3,'ylim', ylim_mua),

        yyaxis left
        ylim([-1000 1000])
        line([0 0], ylim,'color','k','linewidth',2), hold on
        set(gca, 'YTick',[-1000 0 1000],'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
%         title('MoCx')
        %MoCx average - inducing
        subtightplot(3,3,8,gap); hold on

        h(1) = plot(x_modeep/10 , mean(MatMoDeep(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','r');
        h(2) = plot(x_mosup/10 , mean(MatMoSup(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','b');
        yyaxis right
        h(3) = plot(x_mua/10 , mean(MatMUA(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','k');
        set(gca, 'YTick',1:3,'ylim', ylim_mua),

        yyaxis left
        ylim([-1000 1000])
        line([0 0], ylim,'color','k','linewidth',2), hold on
        set(gca, 'YTick',[-1000 0 1000],'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
%         title('MoCx')
        %MoCx average -on down states
        subtightplot(3,3,9,gap); hold on

        h(1) = plot(x_down/10 , mean(MatMoDownDeep,1) , 'Linewidth',2,'color','r');
        h(2) = plot(x_down/10 , mean(MatMoDownSup,1) , 'Linewidth',2,'color','b');
        ylim([-1000 1000])
        line([0 0], ylim,'color','k','linewidth',2), hold on
        set(gca, 'YTick',[-1000 0 1000],'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
%         title('MoCx on down states')
        


        %% maintitle
%         suplabel([ripple_res.name{p} ' - ' ripple_res.date{p}], 't');
    
%     end

    
end