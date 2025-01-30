% FigureISIBarNP2NP1
% 17.04.2017 KJ
%
% bar plot of Inter delta waves intervals - (n+2) - (n+1)
%   - Substages = N1, N2, N3, REM, WAKE
%
% Here, the data are just collected and saved in 
%
%   see QuantifDelayFirstDeltaToneSubstage QuantifDelayTonevsDelta AnalysesISIDeltaToneSubstage



%% load
clear
eval(['load ' FolderProjetDelta 'Data/AnalysesISIDeltaToneSubstage.mat'])


%% INPUT
condition = 6; %490ms
substage = 6; %NREM

show_sig = 'sig';
optiontest='ttest';
paired=0;

%params
NameSubstages = {'N1','N2', 'N3','REM','Wake','NREM'}; % Sleep substages
NameISI = {'d(n,n+1)','d(n,n+2)','d(n,n+3)','d(n+1,n+2)','d(n+1,n+3)','d(n+2,n+3)'}; %ISI
labels = {'Success tones','Failed tones','Basal'};

cond_fig = condition;
cond_basal = 1;
substage_plot = substage;
isi_idx = 4;


%% data
if paired
    data=[];
    data=[data squeeze(cell2mat(mouse.isi.median(cond_fig,substage_plot,:,isi_idx,yes,yes)))]; %success
    data=[data squeeze(cell2mat(mouse.isi.median(cond_fig,substage_plot,:,isi_idx,yes,no)))]; %failed
    data=[data squeeze(cell2mat(mouse.isi.median(cond_basal,substage_plot,:,isi_idx,1,1)))]; %basal

    mean_success_x = nanmean(data(:,1));
    mean_failed_x = nanmean(data(:,2));
        
% not paired
else
    data=cell(0);
    data{end+1} = squeeze(cell2mat(nights.isi.median(cond_fig,substage_plot,:,isi_idx,yes,yes))); %success
    data{end+1} = squeeze(cell2mat(nights.isi.median(cond_fig,substage_plot,:,isi_idx,yes,no))); %failed
    data{end+1} = squeeze(cell2mat(nights.isi.median(cond_basal,substage_plot,:,isi_idx,1,1))); %basal

    mean_success_x = nanmean(data{1});
    mean_failed_x = nanmean(data{2});
end

%labels and colors
bar_color = cell(0);
bar_color{end+1} = 'b';

bar_color{end+1} = 'r';
bar_color{end+1} = [0.2 0.2 0.2];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%insert graph in an existing figure or create a new one
figure('color',[1 1 1]),

%bar plot
[~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'horizontal',0,'barcolors',bar_color,'ShowSigstar',show_sig, 'optiontest',optiontest,'paired',paired);
%title(['ISI ' NameISI{isi_idx} ' - '  NameSubstages{substage_plot} ' - ' conditions{cond_fig}],'fontsize',20), 
title(['ISI ' NameISI{isi_idx}],'fontsize',20), xlim([0.5 3.5]), hold on
ylabel('ms'), hold on,
set(eb,'Linewidth',2); %bold error bar
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'XTickLabelrotation',30,'FontName','Times','fontsize',20), hold on,
%set(gca, 'YTick',0:200:1000,'YLim',[0 900]);















