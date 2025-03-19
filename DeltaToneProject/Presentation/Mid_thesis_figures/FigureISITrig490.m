% FigureISITrig490
% 15.12.2016 KJ
%
% Plot the ISI figure, ordered by conditions (Basal, Failed, ISI)
% - 
% 
%   see QuantifISIDeltaToneSubstageH FigureISITrig490_2
%


%load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifISIDeltaToneSubstage_bis.mat'))

%params
NameSubstages = {'N1','N2', 'N3','REM','Wake'}; % Sleep substages
NameConditions = {'Basal','140ms','200ms','320ms','490ms'};
show_sig = 'none';
optiontest='ranksum';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Order and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos_delays = delays(delays>0);
figtypes = {'Median'}; % stats
substages_plot = 2:3;
delay_fig = 0.490;


%% Figure1 - delta-triggered tones, 490ms

maintitle = ['Inter delta waves interval (Basal night and night with Tones '  num2str(delay_fig*1000) 'ms after delta detection'];
labels={'Success Tones n+1','Success Tones n+2','Success Tones n+3','Failed Tones n+1','Failed Tones n+2','Failed Tones n+3','Basal n+1','Basal n+2','Basal n+3',};
bar_color={'b','b','b','r','r','r',[0.2 0.2 0.2],[0.2 0.2 0.2],[0.2 0.2 0.2]};
noncolumntest = [1 2;1 3;2 3;4 5;4 6;5 6;7 8;7 9;8 9]; 
nb_isi = 1:3;

%Delta
d_tone = delays==delay_fig;
d_basal = delays==0;
figure, hold on
for sbp=1:length(substages_plot)
    sub=substages_plot(sbp);

    %data
    data=[];
    for i=nb_isi
        data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,yes,yes)))]; %success
    end
    for i=nb_isi
        data=[data squeeze(cell2mat(deltas.isi.median(d_tone,sub,:,i,yes,no)))]; %failed
    end
    for i=nb_isi
        data=[data squeeze(cell2mat(deltas.isi.median(d_basal,sub,:,i,1,1)))]; %basal
    end

    %subplot
    subplot(1,length(substages_plot),sbp), hold on,
        [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'horizontal',1,'barcolors',bar_color,'NonColumnTest',noncolumntest,'ShowSigstar',show_sig, 'optiontest',optiontest);
    title([NameSubstages{sub}],'fontsize',20), xlabel('ms'), hold on,
    set(eb,'Linewidth',2); %bold error bar
    set(gca, 'YTickLabel',labels, 'YTick',1:numel(labels),'FontName','Times','fontsize',15), hold on,
    set(gca, 'XTick',0:1000:3000,'XLim',[0 3500]);
    
    %lines
    for i=nb_isi
        mean_success_x = nanmean(data(:,i));
        line([mean_success_x mean_success_x], [i i+6.3], 'color', 'b', 'LineStyle', '--'), hold on
    end
    for i=nb_isi
        mean_success_x = nanmean(data(:,i+3));
        line([mean_success_x mean_success_x], [i+3 i+6.3], 'color', 'r', 'LineStyle', '--'), hold on
    end

end
    
    
    
