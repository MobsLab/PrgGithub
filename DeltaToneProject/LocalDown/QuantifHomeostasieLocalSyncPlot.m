%%QuantifHomeostasieLocalSyncPlot
% 08.09.2019 KJ
%
% Infos
%   plot quantif on homeostasis for global, local, fake delta waves
%
% see
%    ParcoursHomeostasieLocalDeltaDensityPlot ParcoursHomeostasieLocalDeltaOccupancy
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'ParcoursHomeostasieLocalDeltaOccupancy.mat'))


% local global sync
for p=1:length(homeo_res.path)

    % union, global and ratio
    union.x_intervals = homeo_res.down.union.x_intervals{p};
    union.y_density = homeo_res.down.union.y_density{p};
    
    downglobal.x_intervals = homeo_res.down.global.x_intervals{p};
    downglobal.y_density = homeo_res.down.global.y_density{p};

    ratio.x_density = union.x_intervals;
    ratio.y_density = downglobal.y_density ./ (union.y_density+0.1);
    ratio.y_density(union.y_density==0) = 0; 
    
    
    %% homeostat data
    Hstat = HomestasisStat_KJ(ratio.x_density*3600e4, ratio.y_density, intervalSet(0,max(ratio.x_density)), 4);
    
    ratio.p0(p,1)    = Hstat.p0(1);
    ratio.p1(p,1)    = Hstat.p1(1);
    ratio.p2(p,1)    = Hstat.p2(1);
    ratio.exp_b(p,1) = Hstat.exp_b(1);
    %correlation
    ratio.R2_0(p,1)  = Hstat.R2_0;
    ratio.R2_1(p,1)  = Hstat.R2_1;
    ratio.R2_2(p,1)  = Hstat.R2_2;
    ratio.exp_R2(p,1) = Hstat.exp_R2;
    
    
    %% slopes
    
    %global
    down.global.slope0(p,1) = homeo_res.down.global.p0{p}(1);
    %all_local
    slope0 = [];
    for tt=1:length(homeo_res.nb.tetrodes{p})
        slope0 = [slope0 homeo_res.down.all_local.p0{p,tt}(1)];
    end
    down.all_local.slope0(p,1) = mean(slope0);
    %local
    slope0 = [];
    for tt=1:length(homeo_res.nb.tetrodes{p})
        slope0 = [slope0 homeo_res.down.local.p0{p,tt}(1)];
    end
    down.local.slope0(p,1) = mean(slope0);
    %union
    down.union.slope0(p,1) = homeo_res.down.global.p0{p}(1);
    
    
    %% epoch for comparison
    %
    homeo_start = homeo_res.down.global.x_peaks{p}(1);
    homeo_end = homeo_res.down.global.x_peaks{p}(end);
    
    
    firstEpoch = [homeo_start, homeo_start+2];
    lastEpoch = [homeo_end-2, homeo_end];
        
    quarter_night = (homeo_end - homeo_start) / 4;
    for i=1:4
        Quarters{i} = homeo_start + [quarter_night*(i-1), quarter_night*i];
    end

    
    %% quantif first and last two hours
    firstEp_ratio(p,1) = nanmean(ratio.y_density(ratio.x_density>firstEpoch(1) & ratio.x_density<=firstEpoch(2)));
    lastEp_ratio(p,1) = nanmean(ratio.y_density(ratio.x_density>lastEpoch(1) & ratio.x_density<=lastEpoch(2)));
    
    for i=1:4
        quartersEp_ratio{i}(p,1) = nanmean(ratio.y_density(ratio.x_density>Quarters{i}(1) & ratio.x_density<=Quarters{i}(2)));
    end
end


%% Plot

figure, hold on 
fontsize = 15;

%down local vs global
subplot(1,3,1), hold on
PlotErrorBarN_KJ([firstEp_ratio lastEp_ratio]*100, 'newfig',0, 'barcolors',{'b','r'}, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:2,'XtickLabel',{'first 2h','last 2h'},'Fontsize',fontsize),
ylabel('% intersection/union of all down states');
title('Sync of down states'),

subplot(1,3,2), hold on
PlotErrorBarN_KJ([quartersEp_ratio{1} quartersEp_ratio{2} quartersEp_ratio{3} quartersEp_ratio{4}]*100, 'newfig',0, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:4,'XtickLabel',{'Begin','2nd','3rd','End'},'Fontsize',fontsize),
ylabel('% intersection/union of all down states');
title('Sync of down states'),


subplot(1,3,3), hold on
%ratio
data_slope = [down.global.slope0 down.all_local.slope0 down.local.slope0 down.union.slope0 ratio.p0]*100;
PlotErrorBarN_KJ(data_slope, 'newfig',0, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:5,'XtickLabel',{'Global','All local','Local','Union','Ratio inters'},'Fontsize',10),
ylabel('slopes');
title('slopes value (%/min/h)'),













