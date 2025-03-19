% AnalysesERPDownDeltaTonePlot
% 20.02.2017 KJ
%
% Show tone effects on signals:
%   - show MUA raster synchronized on tones
%   - show PFC averaged LFP synchronized on tones (may depth)
%   - distinguish delta-triggered tones
%   - distinguish delta-inducing tones
%   - per conditions
%
% See AnalysesERPDownDeltaTone AnalysesERPDownDeltaToneMousePlot
%   
%



%% load
clear
load([FolderProjetDelta 'Data/AnalysesERPDownDeltaTone.mat']) 

conditions=unique(down_tone.condition);
delays=unique(cell2mat(down_tone.delay));

%params
no=1;
yes=2;

x_lim = [-1 1];
y_lim = [-1500 2000];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Format data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for cond=1:length(conditions)
    mua_cond{cond} = [];
    for p=1:length(down_tone.path)
        if strcmpi(down_tone.condition{p},conditions{cond})
            
            mua_tsd = Data(down_tone.mua.raster{p})';
            mua_x = Range(down_tone.mua.raster{p});
            deep_tsd = Data(down_tone.deep.raster{p})';
            deep_x = Range(down_tone.deep.raster{p});
            sup_tsd = Data(down_tone.sup.raster{p})';
            sup_x = Range(down_tone.sup.raster{p});
            
            pfc1_tsd = Data(down_tone.pfc1.raster{p})';
            pfc1_x = Range(down_tone.pfc1.raster{p});
            pfc2_tsd = Data(down_tone.pfc2.raster{p})';
            pfc2_x = Range(down_tone.pfc2.raster{p});
            pfc3_tsd = Data(down_tone.pfc3.raster{p})';
            pfc3_x = Range(down_tone.pfc3.raster{p});
            
            
            if isempty(mua_cond{cond})
                mua_cond{cond} = mua_tsd;
                deep_cond{cond} = deep_tsd;
                sup_cond{cond} = sup_tsd;
                
                pfc1_cond{cond} = pfc1_tsd;
                pfc2_cond{cond} = pfc2_tsd;
                pfc3_cond{cond} = pfc3_tsd;
                
                raster_delay{cond} = down_tone.down_delay{p};
                raster_induced{cond} = down_tone.induced{p};
                raster_substage{cond} = down_tone.substage_tone{p}';
                raster_nrem{cond} = down_tone.nrem_tone{p}';
            else
                mua_cond{cond} = [mua_cond{cond} ; mua_tsd];
                deep_cond{cond} = [deep_cond{cond} ; deep_tsd];
                sup_cond{cond} = [sup_cond{cond} ; sup_tsd];
                
                pfc1_cond{cond} = [pfc1_cond{cond} ; pfc1_tsd];
                pfc2_cond{cond} = [pfc2_cond{cond} ; pfc2_tsd];
                pfc3_cond{cond} = [pfc3_cond{cond} ; pfc3_tsd];
                
                raster_delay{cond} = [raster_delay{cond} ; down_tone.down_delay{p}];
                raster_induced{cond} = [raster_induced{cond} ; down_tone.induced{p}];
                raster_substage{cond} = [raster_substage{cond} ; down_tone.substage_tone{p}'];
                raster_nrem{cond} = [raster_nrem{cond} ; down_tone.nrem_tone{p}'];
            end
            
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loop over condition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for cond=1:length(conditions)
    
    %% gather data for the condition
    delay = delays(cond)*1E4;
    good_delay = raster_delay{cond}>delay-1000 & raster_delay{cond}<delay+1000;
    for sub=substage_ind
        for trig=[no yes]
            for indu=[no yes]
                idx_tone{trig,indu,sub} = (good_delay==trig-1) .* (raster_induced{cond}==indu-1) .* (raster_substage{cond}==sub);
            end
        end
    end
    %NREM = 6
    for trig=[no yes]
        for indu=[no yes]
            idx_tone{trig,indu,6} = (good_delay==trig-1) .* (raster_induced{cond}==indu-1) .* (raster_nrem{cond}==1);
        end
    end

    for sub=[substage_ind 6] %6 is NREM
        for trig=[no yes]
            for indu=[no yes]
                deep_met{trig,indu,sub} = deep_cond{cond}(idx_tone{trig,indu,sub}==1,:);
                deep_met{trig,indu,sub} = tsd(deep_x,mean(deep_met{trig,indu,sub},1)');
                sup_met{trig,indu,sub} = sup_cond{cond}(idx_tone{trig,indu,sub}==1,:);
                sup_met{trig,indu,sub} = tsd(sup_x,mean(sup_met{trig,indu,sub},1)');
                
                pfc1_met{trig,indu,sub} = pfc1_cond{cond}(idx_tone{trig,indu,sub}==1,:);
                pfc1_met{trig,indu,sub} = tsd(pfc1_x,mean(pfc1_met{trig,indu,sub},1)');
                pfc2_met{trig,indu,sub} = pfc2_cond{cond}(idx_tone{trig,indu,sub}==1,:);
                pfc2_met{trig,indu,sub} = tsd(pfc2_x,mean(pfc2_met{trig,indu,sub},1)');
                pfc3_met{trig,indu,sub} = pfc3_cond{cond}(idx_tone{trig,indu,sub}==1,:);
                pfc3_met{trig,indu,sub} = tsd(pfc3_x,mean(pfc3_met{trig,indu,sub},1)');

            end
        end
    end
    
    %% Figure in NREM, for triggered tone
    sub=6; trig=yes;
    
    % for the line spliting success and failed tones
    border = sum(idx_tone{trig,yes,sub}==1); %number of triggered and success tones, in NREM
    
    % matrix with the raster (gather failed and success together)
    failed_mat = mua_cond{cond}(idx_tone{trig,no,sub}==1,:);
    failed_mat = failed_mat(randperm(size(failed_mat,1)),:);
    success_mat = mua_cond{cond}(idx_tone{trig,yes,sub}==1,:);
    success_mat = success_mat(randperm(size(success_mat,1)),:);
    raster_mat = [success_mat ; failed_mat];


    %% PLOT - figure1 : Raster + Average LFP (sup & deep)

    figure, hold on
    %LFP average
    s1=subplot(13,1,1:3); hold on
    plot(Range(deep_met{trig,no,sub})/1E4 , Data(deep_met{trig,no,sub}) , 'Linewidth',2,'color','b');
    plot(Range(sup_met{trig,no,sub})/1E4 , Data(sup_met{trig,no,sub}) , 'Linewidth',2,'color','r');
    h_leg = legend('PFCx deep', 'PFCx sup'); set(h_leg,'FontSize',15);
    line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
    set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim,'YLim',y_lim,'FontName','Times','fontsize',12);
    title(conditions{cond});
    %MUA raster
    s2=subplot(13,1,4:10); hold on
    imagesc(mua_x/1E4, 1:size(raster_mat,1), raster_mat), hold on
    axis xy, ylabel('# tone'), hold on
    line([0 0], ylim,'Linewidth',2,'color','k'), hold on
    line(xlim, [border border],'color','k'), hold on
    set(gca,'YLim', [0 size(raster_mat,1)], 'Yticklabel',{[]},'Xticklabel',{[]}, 'XLim',x_lim,'FontName','Times','fontsize',12);
    hb = colorbar('location','eastoutside'); hold on
    %LFP average
    s3=subplot(13,1,11:13); hold on
    plot(Range(deep_met{trig,yes,sub})/1E4 , Data(deep_met{trig,yes,sub}) , 'Linewidth',2,'color','b');
    plot(Range(sup_met{trig,yes,sub})/1E4 , Data(sup_met{trig,yes,sub}) , 'Linewidth',2,'color','r');
    h_leg = legend('PFCx deep', 'PFCx sup'); set(h_leg,'FontSize',15); xlabel('time (sec)'),
    line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
    set(gca, 'YTick',[-1000 0 1000],'XLim',x_lim,'YLim',y_lim,'FontName','Times','fontsize',12);


    %align subplots
    s1Pos = get(s1,'position');
    s2Pos = get(s2,'position');
    s2Pos(3) = s1Pos(3);
    set(s2,'position',s2Pos);
    
    
    %% PLOT - figure2 : Raster + Average LFP (many PFC depth)

    figure, hold on
    %LFP average - not inducing
    s1=subplot(13,1,1:3); hold on
    plot(Range(deep_met{trig,no,sub})/1E4 , Data(deep_met{trig,no,sub}) , 'Linewidth',2,'color','b');
    plot(Range(sup_met{trig,no,sub})/1E4 , Data(sup_met{trig,no,sub}) , 'Linewidth',2,'color','r');
    plot(Range(pfc1_met{trig,no,sub})/1E4 , Data(pfc1_met{trig,no,sub}) , 'Linewidth',2,'color','k');
    plot(Range(pfc2_met{trig,no,sub})/1E4 , Data(pfc2_met{trig,no,sub}) , 'Linewidth',2,'color',[0.2 0.2 0.2]);
    plot(Range(pfc3_met{trig,no,sub})/1E4 , Data(pfc3_met{trig,no,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);
    
    h_leg = legend('PFCx deep', 'PFCx sup', 'PFCx 1', 'PFCx 2', 'PFCx 3'); set(h_leg,'FontSize',15);
    line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
    set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
    title(conditions{cond});
    %MUA raster
    s2=subplot(13,1,4:10); hold on
    imagesc(mua_x/1E4, 1:size(raster_mat,1), raster_mat), hold on
    axis xy, ylabel('# tone'), hold on
    line([0 0], ylim,'Linewidth',2,'color','k'), hold on
    line(xlim, [border border],'color','k'), hold on
    set(gca,'YLim', [0 size(raster_mat,1)], 'Yticklabel',{[]},'Xticklabel',{[]}, 'XLim',x_lim,'FontName','Times','fontsize',12);
    hb = colorbar('location','eastoutside'); hold on
    %LFP average - inducing
    s3=subplot(13,1,11:13); hold on
    plot(Range(deep_met{trig,yes,sub})/1E4 , Data(deep_met{trig,yes,sub}) , 'Linewidth',2,'color','b');
    plot(Range(sup_met{trig,yes,sub})/1E4 , Data(sup_met{trig,yes,sub}) , 'Linewidth',2,'color','r');
    plot(Range(pfc1_met{trig,yes,sub})/1E4 , Data(pfc1_met{trig,yes,sub}) , 'Linewidth',2,'color','k');
    plot(Range(pfc2_met{trig,yes,sub})/1E4 , Data(pfc2_met{trig,yes,sub}) , 'Linewidth',2,'color',[0.2 0.2 0.2]);
    plot(Range(pfc3_met{trig,yes,sub})/1E4 , Data(pfc3_met{trig,yes,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);
    
    h_leg = legend('PFCx deep', 'PFCx sup', 'PFCx 1', 'PFCx 2', 'PFCx 3'); set(h_leg,'FontSize',15); xlabel('time (sec)'),
    line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
    set(gca, 'YTick',[-1000 0 1000],'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);


    %align subplots
    s1Pos = get(s1,'position');
    s2Pos = get(s2,'position');
    s2Pos(3) = s1Pos(3);
    set(s2,'position',s2Pos);
    
    
    
    %% PLOT - figure3 : Average LFP (many PFC depth)

    figure, hold on
    %LFP average - not inducing
    subplot(3,1,1); hold on
    plot(Range(deep_met{trig,no,sub})/1E4 , Data(deep_met{trig,no,sub}) , 'Linewidth',2,'color','b');
    plot(Range(sup_met{trig,no,sub})/1E4 , Data(sup_met{trig,no,sub}) , 'Linewidth',2,'color','r');
    plot(Range(pfc1_met{trig,no,sub})/1E4 , Data(pfc1_met{trig,no,sub}) , 'Linewidth',2,'color','k');
    plot(Range(pfc2_met{trig,no,sub})/1E4 , Data(pfc2_met{trig,no,sub}) , 'Linewidth',2,'color',[0.2 0.2 0.2]);
    plot(Range(pfc3_met{trig,no,sub})/1E4 , Data(pfc3_met{trig,no,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);
    
    h_leg = legend('PFCx deep', 'PFCx sup', 'PFCx 1', 'PFCx 2', 'PFCx 3'); set(h_leg,'FontSize',15);
    line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
    set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
    title('Tones not inducing Down states');
    
    %LFP average - difference between inducing and not inducing ERPs
    subplot(3,1,2); hold on
    plot(Range(deep_met{trig,yes,sub})/1E4 , Data(deep_met{trig,yes,sub}) - Data(deep_met{trig,no,sub}) , 'Linewidth',2,'color','b');
    plot(Range(sup_met{trig,yes,sub})/1E4 , Data(sup_met{trig,yes,sub}) - Data(sup_met{trig,no,sub}) , 'Linewidth',2,'color','r');
    plot(Range(pfc1_met{trig,yes,sub})/1E4 , Data(pfc1_met{trig,yes,sub}) - Data(pfc1_met{trig,no,sub}) , 'Linewidth',2,'color','k');
    plot(Range(pfc2_met{trig,yes,sub})/1E4 , Data(pfc2_met{trig,yes,sub}) - Data(pfc2_met{trig,no,sub}) , 'Linewidth',2,'color',[0.2 0.2 0.2]);
    plot(Range(pfc3_met{trig,yes,sub})/1E4 , Data(pfc3_met{trig,yes,sub}) - Data(pfc3_met{trig,no,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);
    
    h_leg = legend('PFCx deep', 'PFCx sup', 'PFCx 1', 'PFCx 2', 'PFCx 3'); set(h_leg,'FontSize',15); xlabel('time (sec)'),
    line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
    set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
    title('Substraction: Inducing - Not inducing');
    
    %LFP average - inducing
    subplot(3,1,3); hold on
    plot(Range(deep_met{trig,yes,sub})/1E4 , Data(deep_met{trig,yes,sub}) , 'Linewidth',2,'color','b');
    plot(Range(sup_met{trig,yes,sub})/1E4 , Data(sup_met{trig,yes,sub}) , 'Linewidth',2,'color','r');
    plot(Range(pfc1_met{trig,yes,sub})/1E4 , Data(pfc1_met{trig,yes,sub}) , 'Linewidth',2,'color','k');
    plot(Range(pfc2_met{trig,yes,sub})/1E4 , Data(pfc2_met{trig,yes,sub}) , 'Linewidth',2,'color',[0.2 0.2 0.2]);
    plot(Range(pfc3_met{trig,yes,sub})/1E4 , Data(pfc3_met{trig,yes,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);
    
    h_leg = legend('PFCx deep', 'PFCx sup', 'PFCx 1', 'PFCx 2', 'PFCx 3'); set(h_leg,'FontSize',15); xlabel('time (sec)'),
    line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
    set(gca, 'YTick',[-1000 0 1000],'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
    title('Tones inducing Down states');
    
    suplabel(conditions{cond},'t');
    
end






