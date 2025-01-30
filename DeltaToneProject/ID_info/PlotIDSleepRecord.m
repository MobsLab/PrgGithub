% PlotIDSleepRecord
% 22.11.2016 KJ
%
% Load data and plot description figures of a sleep record
%
%   See GenerateIDSleepRecord


%%load
load IdFigureData

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('units','normalized','outerposition',[0 0 1 1]);
RasterDown_Axes = axes('position', [0.27 0.72 0.15 0.21]);
DistribDown_Axes = axes('position', [0.45 0.72 0.15 0.21]);
textbox_dim = [0.05 0.75 0.18 0.17];

Sleepscoring_Axes = axes('position', [0.74 0.6 0.2 0.32]);
SleepscoringTheta_Axes = axes('position', [0.66 0.6 0.07 0.32]);
SleepscoringGamma_Axes = axes('position', [0.74 0.49 0.2 0.1]);

AverageRipple_Axes = axes('position', [0.05 0.54 0.3 0.13]);
AverageSpindle_Axes = axes('position', [0.05 0.3 0.3 0.19]);
AverageDelta_Axes = axes('position', [0.41 0.3 0.3 0.25]);

Substages_Axes = axes('position', [0.05 0.05 0.4075 0.2]);
StatSubstage_Axes = axes('position', [0.52 0.05 0.2 0.2]);
MeanDurSubstage_Axes = axes('position', [0.75 0.05 0.2 0.2]);


%% Down states
% Create textbox
if nb_neuron
    textbox_str = {[num2str(nb_neuron) ' neurons'], [num2str(nb_pyramidal) ' pyramidal(s) / ' num2str(nb_interneuron) ' interneuron(s)'],... 
                    ['FR (SWS) = ' num2str(firingRates_sws) ' Hz ( ' num2str(firingRates_sws/nb_neuron) ' Hz)'],...
                    ['FR (Wake) = ' num2str(firingRates_wake) ' Hz ( ' num2str(firingRates_wake/nb_neuron) ' Hz)'],...
                    ['Pyr (SWS) = ' num2str(firingRates_sws_pyr) ' Hz ( ' num2str(firingRates_sws_pyr/nb_pyramidal) ' Hz)'],...
                    ['Pyr (Wake) = ' num2str(firingRates_wake_pyr) ' Hz ( ' num2str(firingRates_wake_pyr/nb_pyramidal) ' Hz)'],...
                    ['Int (SWS) = ' num2str(firingRates_sws_int) ' Hz ( ' num2str(firingRates_sws_int/nb_interneuron) ' Hz)'],...
                    ['int (Wake) = ' num2str(firingRates_wake_int) ' Hz ( ' num2str(firingRates_wake_int/nb_interneuron) ' Hz)']};
else
   textbox_str = {'No neurons'}; 
end

annotation(gcf,'textbox',...
    textbox_dim,...
    'String',textbox_str,...
    'LineWidth',1,...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FitBoxToText','off');

%raster
axes(RasterDown_Axes);
if exist('raster_x','var')
    imagesc(raster_x/1E4, 1:size(raster_matrix,1), raster_matrix), hold on
    axis xy, xlabel('time (sec)'), ylabel('# down'), hold on
    colorbar, hold on
end
try title({pwd,' '});end

%distribution of down
axes(DistribDown_Axes);
if nb_neuron>0
    plot(minDurBins, nbDownSWS ,'r'), hold on
    plot(minDurBins, nbDownWake ,'k'), hold on
    set(gca,'xscale','log','yscale','log'), hold on
    set(gca,'ylim',[1 1E6],'xlim',[10 1500]), hold on
    set(gca,'xtick',[10 50 100 200 500 1500]), hold on
    legend('SWS','Wake'), xlabel('down duration (ms)'), ylabel('number of down')
end

%% Substages  
axes(Substages_Axes);
ylabel_substage = {'N3','N2','N1','REM','WAKE'};


ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
plot(Range(SleepStages,'s')/3600,Data(SleepStages),'k'), hold on,
for ep=1:length(Epochs)
    plot(Range(Restrict(SleepStages,Epochs{ep}),'s')/3600 ,Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori{ep}), hold on,
end
xlim([0 max(Range(SleepStages,'s')/3600)]), ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
title('Hypnogram'); xlabel('Time (h)')

axes(StatSubstage_Axes);
for ep=1:length(time_substages)
    h = bar(ep, time_substages(ep)/1000); hold on
    set(h,'FaceColor', colori{ep}), hold on
    if any(1:3==ep)
        text(ep - 0.3, time_substages(ep)/1000 + 1000, [num2str(percentvalues_NREM(ep)) '%'], 'VerticalAlignment', 'top', 'FontSize', 8)
    end
end
set(gca, 'XTickLabel',{'N1','N2','N3','REM','WAKE'}, 'XTick',1:5), hold on
ylim([0, max(time_substages/1000) * 1.2]);
title('Total duration'); ylabel('duration (s)')


axes(MeanDurSubstage_Axes)
for ep=1:length(meanDuration_substages)
    h = bar(ep, meanDuration_substages(ep)/1000); hold on
    set(h,'FaceColor', colori{ep}), hold on
end
set(gca, 'XTickLabel',{'N1','N2','N3','REM','WAKE'}, 'XTick',1:5), hold on
title('Episode mean duration'); ylabel('duration (s)')


%% Ripples and spindles
%ripples
axes(AverageRipple_Axes);
plot(Mripples(:,1),Mripples(:,2),'r','linewidth',2), hold on 
line([0 0],get(gca,'YLim')), hold on
title('Mean ripples signal : -50 +50 ms'), hold on

%spindles
axes(AverageSpindle_Axes);
yyaxis left
plot(Mspindles_low_sup(:,1),Mspindles_low_sup(:,2),'b','linewidth',2), hold on
plot(Mspindles_high_sup(:,1),Mspindles_high_sup(:,2),'r','linewidth',2), hold on
ylabel('LFP')
try
    yyaxis right
    plot(Mmua_ls_sup(:,1),Mmua_ls_sup(:,2), 'color','b'), hold on
    plot(Mmua_hs_sup(:,1),Mmua_hs_sup(:,2), 'color','r'), hold on
    ylabel('MUA (10s bin)')
    legend('LFP: low spindles','LFP: high spindles','MUA: low spindles','MUA: high spindles')
catch
    legend('LFP: low spindles','LFP: high spindles')
end
line([0 0],get(gca,'YLim')), hold on
title('Mean spindles signal : -500 +500 ms'), hold on

%% Delta waves
axes(AverageDelta_Axes);
yyaxis left
plot(Ms_delta_small(:,1),Ms_delta_small(:,2),'--', 'color', 'b'), hold on
plot(Md_delta_small(:,1),Md_delta_small(:,2),'--', 'color', 'r'), hold on
plot(Ms_delta_big(:,1),Ms_delta_big(:,2), '-', 'color', 'b'), hold on
plot(Md_delta_big(:,1),Md_delta_big(:,2),'-', 'color', 'r'), hold on
ylabel('LFP')
try %MUA average sync
    yyaxis right
    maxvalue = ceil(max([Mmua_delta_small(:,2);Mmua_delta_big(:,2)]));
    plot(Mmua_delta_small(:,1),Mmua_delta_small(:,2),'--', 'color','k'), hold on
    plot(Mmua_delta_big(:,1),Mmua_delta_big(:,2),'-',  'color','k'), hold on
    ylabel('MUA (10s bin)'), ylim([0 maxvalue*3])
    legend('LFP Sup (small deltas)','LFP deep (small deltas)','LFP Sup (big deltas)','LFP deep (big deltas)','MUA (small deltas)','MUA (big deltas)')
    title_ax = 'Mean LFP and MUA: averaged on delta waves centers';
catch
    legend('LFP Sup (small deltas)','LFP deep (small deltas)','LFP Sup (big deltas)','LFP deep (big deltas)')
    title_ax = 'Mean LFP  averaged on delta waves centers';
end

line([0 0],get(gca,'YLim')), hold on
title(title_ax), hold on


%% Sleep scoring
axes(Sleepscoring_Axes);
plot(log(Data(ghi_new_rem)),log(Data(remtheta)),'.','color',[1 0.2 0.2],'MarkerSize',1); hold on
plot(log(Data(ghi_new_sws)),log(Data(sleeptheta)),'.','color',[0.4 0.5 1],'MarkerSize',1); hold on
plot(log(Data(ghi_new_wake)),log(Data(waketheta)),'.','color',[0.6 0.6 0.6],'MarkerSize',1); hold on
[~,icons,~,~]=legend('REM','SWS','Wake'); hold on
set(icons(5),'MarkerSize',20)
set(icons(7),'MarkerSize',20)
set(icons(9),'MarkerSize',20)
ys=get(gca,'Ylim');
xs=get(gca,'Xlim');
box on
set(gca,'XTick',[],'YTick',[])

axes(SleepscoringTheta_Axes);
[~, rawN, ~] = nhist(log(Data(Restrict(smooth_Theta,sleepper))),'maxx',max(log(Data(Restrict(smooth_Theta,sleepper)))),'noerror','xlabel','Theta power','ylabel',[]); axis xy
view(90,-90)
line([log(theta_thresh) log(theta_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',ys)

axes(SleepscoringGamma_Axes);
[~, rawN, ~] = nhist(log(Data(smooth_ghi)),'maxx',max(log(Data(smooth_ghi))),'noerror','xlabel','Gamma power','ylabel',[]);
line([log(gamma_thresh) log(gamma_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',xs)
