% AnalysesERPDownDeltaToneMousePlot2
% 24.04.2017 KJ
%
% Show tone effects on signals:
%   - show MUA raster synchronized on tones
%   - show PFC averaged LFP synchronized on tones (may depth)
%   - show Bulb, HPC signals
%   - distinguish delta-triggered tones
%   - distinguish delta-inducing tones
%   - per conditions and per mouse
%
% See AnalysesERPDownDeltaTonePlot AnalysesERPDownDeltaToneMousePlot AnalysesERPDownDeltaTone2
%   
%



%% load
clear
load([FolderProjetDelta 'Data/AnalysesERPDownDeltaTone2.mat']) 

conditions=unique(down_tone.condition);
delays=unique(cell2mat(down_tone.delay));
animals=unique(down_tone.name);

no=1;
yes=2;

%params
x_lim = [-1 1];
y_lim = [-1500 2000];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Format data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for cond=1:length(conditions)
    for m=1:length(animals)
        mua_cond{cond,m} = [];
        for p=1:length(down_tone.path)
            if strcmpi(down_tone.condition{p},conditions{cond}) && strcmpi(down_tone.name{p},animals{m})

                %mua
                mua_tsd = Data(down_tone.mua.raster{p})';
                mua_x = Range(down_tone.mua.raster{p});
                
                %pfc
                pfcdeep_tsd = Data(down_tone.pfc.deep{p})';
                pfcdeep_x = Range(down_tone.pfc.deep{p});
                pfcsup_tsd = Data(down_tone.pfc.sup{p})';
                pfcsup_x = Range(down_tone.pfc.sup{p});

%                 pfc1_tsd = Data(down_tone.pfc.d1{p})';
%                 pfc1_x = Range(down_tone.pfc.d1{p});
%                 pfc2_tsd = Data(down_tone.pfc.d2{p})';
%                 pfc2_x = Range(down_tone.pfc.d12p});
%                 pfc3_tsd = Data(down_tone.pfc.d3{p})';
%                 pfc3_x = Range(down_tone.pfc.d3{p});
                
                %hpc
                hpc_tsd = Data(down_tone.hpc.rip{p})';
                hpc_x = Range(down_tone.hpc.rip{p});
                
                %bulb
                bulbdeep_tsd = Data(down_tone.bulb.deep{p})';
                bulbdeep_x = Range(down_tone.bulb.deep{p});
                bulbsup_tsd = Data(down_tone.bulb.sup{p})';
                bulbsup_x = Range(down_tone.bulb.sup{p});
                
                %pacx
                pacxdeep_tsd = Data(down_tone.pacx.deep{p})';
                pacxdeep_x = Range(down_tone.pacx.deep{p});
                pacxsup_tsd = Data(down_tone.pacx.sup{p})';
                pacxsup_x = Range(down_tone.pacx.sup{p});
                
                
                if isempty(mua_cond{cond,m})
                    %mua
                    mua_cond{cond,m} = mua_tsd;
                    %pfc
                    pfcdeep_cond{cond,m} = pfcdeep_tsd;
                    pfcsup_cond{cond,m} = pfcsup_tsd;
%                     pfc1_cond{cond,m} = pfc1_tsd;
%                     pfc2_cond{cond,m} = pfc2_tsd;
%                     pfc3_cond{cond,m} = pfc3_tsd;
                    
                    %hpc
                    hpc_cond{cond,m} = hpc_tsd;
                    %bulb
                    bulbdeep_cond{cond,m} = bulbdeep_tsd;
                    bulbsup_cond{cond,m} = bulbsup_tsd;
                    %pacx
                    pacxdeep_cond{cond,m} = pacxdeep_tsd;
                    pacxsup_cond{cond,m} = pacxsup_tsd;

                    %
                    raster_delay{cond,m} = down_tone.down_delay{p};
                    raster_induced{cond,m} = down_tone.induced{p};
                    raster_substage{cond,m} = down_tone.substage_tone{p}';
                    raster_nrem{cond,m} = down_tone.nrem_tone{p}';
                else
                    %mua
                    mua_cond{cond,m} = [mua_cond{cond,m} ; mua_tsd];
                    %pfc
                    pfcdeep_cond{cond,m} = [pfcdeep_cond{cond,m} ; pfcdeep_tsd];
                    pfcsup_cond{cond,m} = [pfcsup_cond{cond,m} ; pfcsup_tsd];
%                     pfc1_cond{cond,m} = [pfc1_cond{cond,m} ; pfc1_tsd];
%                     pfc2_cond{cond,m} = [pfc2_cond{cond,m} ; pfc2_tsd];
%                     pfc3_cond{cond,m} = [pfc3_cond{cond,m} ; pfc3_tsd];
                    
                    %hpc
                    hpc_cond{cond,m} = [hpc_cond{cond,m} hpc_tsd];
                    %bulb
                    bulbdeep_cond{cond,m} = [bulbdeep_cond{cond,m} bulbdeep_tsd];
                    bulbsup_cond{cond,m} = [bulbsup_cond{cond,m} bulbsup_tsd];
                    %pacx
                    pacxdeep_cond{cond,m} = [pacxdeep_cond{cond,m} pacxdeep_tsd];
                    pacxsup_cond{cond,m} = [pacxsup_cond{cond,m} pacxsup_tsd];

                    %
                    raster_delay{cond,m} = [raster_delay{cond,m} ; down_tone.down_delay{p}];
                    raster_induced{cond,m} = [raster_induced{cond,m} ; down_tone.induced{p}];
                    raster_substage{cond,m} = [raster_substage{cond,m} ; down_tone.substage_tone{p}'];
                    raster_nrem{cond,m} = [raster_nrem{cond,m} ; down_tone.nrem_tone{p}'];
                end
                
            end
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loop over condition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for cond=1:length(conditions)
    for m=1:length(animals)
        %% gather data for the condition
        delay = delays(cond)*1E4;
        good_delay = raster_delay{cond,m}>delay-1000 & raster_delay{cond,m}<delay+1000;
        for sub=substage_ind
            for trig=[no yes]
                for indu=[no yes]
                    idx_tone{trig,indu,sub} = (good_delay==trig-1) .* (raster_induced{cond,m}==indu-1) .* (raster_substage{cond,m}==sub);
                end
            end
        end
        %NREM = 6
        for trig=[no yes]
            for indu=[no yes]
                idx_tone{trig,indu,6} = (good_delay==trig-1) .* (raster_induced{cond,m}==indu-1) .* (raster_nrem{cond,m}==1);
            end
        end

        for sub=[substage_ind 6] %6 is NREM
            for trig=[no yes]
                for indu=[no yes]
                    pfcdeep_met{trig,indu,sub} = pfcdeep_cond{cond,m}(idx_tone{trig,indu,sub}==1,:);
                    pfcdeep_met{trig,indu,sub} = tsd(pfcdeep_x,mean(pfcdeep_met{trig,indu,sub},1)');
                    pfcsup_met{trig,indu,sub} = pfcsup_cond{cond,m}(idx_tone{trig,indu,sub}==1,:);
                    pfcsup_met{trig,indu,sub} = tsd(pfcsup_x,mean(pfcsup_met{trig,indu,sub},1)');

                    hpc_met{trig,indu,sub} = hpc_cond{cond,m}(idx_tone{trig,indu,sub}==1,:);
                    hpc_met{trig,indu,sub} = tsd(hpc_x,mean(hpc_met{trig,indu,sub},1)');
                    
                    bulbdeep_met{trig,indu,sub} = bulbdeep_cond{cond,m}(idx_tone{trig,indu,sub}==1,:);
                    bulbdeep_met{trig,indu,sub} = tsd(bulbdeep_x,mean(bulbdeep_met{trig,indu,sub},1)');
                    bulbsup_met{trig,indu,sub} = bulbsup_cond{cond,m}(idx_tone{trig,indu,sub}==1,:);
                    bulbsup_met{trig,indu,sub} = tsd(bulbsup_x,mean(bulbsup_met{trig,indu,sub},1)');
                    
                    pacxdeep_met{trig,indu,sub} = pacxdeep_cond{cond,m}(idx_tone{trig,indu,sub}==1,:);
                    pacxdeep_met{trig,indu,sub} = tsd(pacxdeep_x,mean(pacxdeep_met{trig,indu,sub},1)');
                    pacxsup_met{trig,indu,sub} = pacxsup_cond{cond,m}(idx_tone{trig,indu,sub}==1,:);
                    pacxsup_met{trig,indu,sub} = tsd(pacxsup_x,mean(pacxsup_met{trig,indu,sub},1)');

                end
            end
        end

        %% Figure in NREM, for triggered tone
        sub=6; trig=yes;

        % for the line spliting success and failed tones
        border = sum(idx_tone{trig,yes,sub}==1); %number of triggered and success tones, in NREM

        % matrix with the raster (gather failed and success together)
        failed_mat = mua_cond{cond,m}(idx_tone{trig,no,sub}==1,:);
        failed_mat = failed_mat(randperm(size(failed_mat,1)),:);
        success_mat = mua_cond{cond,m}(idx_tone{trig,yes,sub}==1,:);
        success_mat = success_mat(randperm(size(success_mat,1)),:);
        raster_mat = [success_mat ; failed_mat];
        
        
        %% PLOT - figure3 : Average LFP (many PFC depth)

        figure, hold on
        %LFP average - not inducing
        subplot(3,1,1); hold on
        plot(Range(pfcdeep_met{trig,no,sub})/1E4 , Data(pfcdeep_met{trig,no,sub}) , 'Linewidth',2,'color','b');
        plot(Range(pfcsup_met{trig,no,sub})/1E4 , Data(pfcsup_met{trig,no,sub}) , 'Linewidth',2,'color','r');
        plot(Range(hpc_met{trig,no,sub})/1E4 , Data(hpc_met{trig,no,sub}) , 'Linewidth',2,'color','k');
        plot(Range(bulbdeep_met{trig,no,sub})/1E4 , Data(bulbdeep_met{trig,no,sub}) , 'Linewidth',2,'color',[1 0.41 0.7]);
        plot(Range(pacxdeep_met{trig,no,sub})/1E4 , Data(pacxdeep_met{trig,no,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);

        h_leg = legend('PFCx deep', 'PFCx sup', 'HPC', 'Bulb deep', 'PaCx deep'); set(h_leg,'FontSize',15);
        line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
        set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
        title('Tones not inducing Down states');

        %LFP average - difference between inducing and not inducing ERPs
        subplot(3,1,2); hold on
        plot(Range(pfcdeep_met{trig,yes,sub})/1E4 , Data(pfcdeep_met{trig,yes,sub}) - Data(pfcdeep_met{trig,no,sub}) , 'Linewidth',2,'color','b');
        plot(Range(pfcsup_met{trig,yes,sub})/1E4 , Data(pfcsup_met{trig,yes,sub}) - Data(pfcsup_met{trig,no,sub}) , 'Linewidth',2,'color','r');
        plot(Range(hpc_met{trig,yes,sub})/1E4 , Data(hpc_met{trig,yes,sub}) - Data(hpc_met{trig,no,sub}) , 'Linewidth',2,'color','k');
        plot(Range(bulbdeep_met{trig,yes,sub})/1E4 , Data(bulbdeep_met{trig,yes,sub}) - Data(bulbdeep_met{trig,no,sub}) , 'Linewidth',2,'color',[1 0.41 0.7]);
        plot(Range(pacxdeep_met{trig,yes,sub})/1E4 , Data(pacxdeep_met{trig,yes,sub}) - Data(pacxdeep_met{trig,no,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);

        %h_leg = legend('PFCx deep', 'PFCx sup', 'HPC', 'Bulb deep', 'PaCx deep'); set(h_leg,'FontSize',15); xlabel('time (sec)'),
        line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
        set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
        title('Substraction: Inducing - Not inducing');

        %LFP average - inducing
        subplot(3,1,3); hold on
        plot(Range(pfcdeep_met{trig,yes,sub})/1E4 , Data(pfcdeep_met{trig,yes,sub}) , 'Linewidth',2,'color','b');
        plot(Range(pfcsup_met{trig,yes,sub})/1E4 , Data(pfcsup_met{trig,yes,sub}) , 'Linewidth',2,'color','r');
        plot(Range(hpc_met{trig,yes,sub})/1E4 , Data(hpc_met{trig,yes,sub}) , 'Linewidth',2,'color','k');
        plot(Range(bulbdeep_met{trig,yes,sub})/1E4 , Data(bulbdeep_met{trig,yes,sub}) , 'Linewidth',2,'color',[1 0.41 0.7]);
        plot(Range(pacxdeep_met{trig,yes,sub})/1E4 , Data(pacxdeep_met{trig,yes,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);

        %h_leg = legend('PFCx deep', 'PFCx sup', 'HPC', 'Bulb deep', 'PaCx deep'); set(h_leg,'FontSize',15); xlabel('time (sec)'),
        line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
        set(gca, 'YTick',[-1000 0 1000],'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
        title('Tones inducing Down states');

        suplabel([animals{m} ' - ' conditions{cond}],'t');
    end
end







