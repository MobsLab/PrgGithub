% SWAEvolutionDeltaFeedbackPlot
% 10.10.2017 KJ
%
% Evolution of SWA during the night
% 
% 
%   see Figure3PowerDensityPlot SWAEvolutionDeltaFeedback
%



clear
load([FolderProjetDelta 'Data/SWAEvolutionDeltaFeedback.mat']) 

conditions = unique(swa_res.condition);
hours_plot = 1:10;
hours_tick = 10:19;


%% gather data
for cond=1:length(conditions)
    
    nb_record = sum(strcmpi(swa_res.condition, conditions{cond}));
    
    data.power{cond} = nan(nb_record,length(hours_plot));
    data.swsratio{cond} = nan(nb_record,length(hours_plot));
    data.deltadensity{cond} = nan(nb_record,length(hours_plot));
    data.upduration{cond} = nan(nb_record,length(hours_plot));
    data.downduration{cond} = nan(nb_record,length(hours_plot));
    
    a=0;
    for p=1:length(swa_res.path)
        if strcmpi(swa_res.condition{p}, conditions{cond})
            a=a+1;
            data.power{cond}(a,:) = swa_res.so_power_hours{p}(hours_plot);
            data.swsratio{cond}(a,:) = swa_res.sws_ratio{p}(hours_plot);
            data.deltadensity{cond}(a,:) = swa_res.delta_density{p}(hours_plot);
            data.upduration{cond}(a,:) = swa_res.up_durations{p}(hours_plot) / 1E4;
            data.downduration{cond}(a,:) = swa_res.down_durations{p}(hours_plot) / 1E4;

        end
    end
end


%% plot

%basal
cond = 1;
figure, hold on
yyaxis right
PlotErrorLineN_KJ(data.power{cond},'newfig',0,'linecolor','k','median',1,'x_data',hours_tick);
yyaxis left
PlotErrorLineN_KJ(data.upduration{cond},'newfig',0,'linecolor','r','median',1,'errorbars',0,'x_data',hours_tick);
PlotErrorLineN_KJ(data.downduration{cond},'newfig',0,'linecolor','b','median',1,'errorbars',0,'x_data',hours_tick);

set(gca, 'XTick',hours_tick,'FontName','Times','fontsize',20), hold on,
title('Evolution of power')





