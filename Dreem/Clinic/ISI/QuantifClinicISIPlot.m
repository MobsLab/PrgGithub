% QuantifClinicISIPlot
% 18.01.2017 KJ
%
% collect data for the quantification of Inter Slow-wave Intervals for different sleep stages
%   - Sleep stages = N1, N2, N3, REM, WAKE
%
% Here, we plot
%
%   see QuantifClinicISI_bis QuantifClinicISI


clear
eval(['load ' FolderPrecomputeDreem 'QuantifClinicISI_bis.mat'])

%params
NameSleepStages = {'N1','N2', 'N3','REM','Wake'}; % Sleep stages
sstage=3; %N3

optiontest='ranksum';

cond_basal = find(strcmpi(conditions,'Basal'));
cond_random = find(strcmpi(conditions,'Random'));
cond_upphase = find(strcmpi(conditions,'UpPhase'));

failed=1;
success=2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Order and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Figure1 - Order by type
condition_fig = [cond_random, cond_upphase];
titles = {'Random','Up Phase'};
maintitle = 'Inter delta waves interval (Basal night and night with Tones';
labels={'Success Tones n+1','Success Tones n+2','Success Tones n+3','Failed Tones n+1','Failed Tones n+2','Failed Tones n+3','Basal n+1','Basal n+2','Basal n+3',};
bar_color={'b','b','b','r','r','r',[0.2 0.2 0.2],[0.2 0.2 0.2],[0.2 0.2 0.2]};
noncolumntest = [1 2;1 3;2 3;4 5;4 6;5 6;7 8;7 9;8 9]; 
nb_isi = 1:3;


figure, hold on
for cond=1:length(condition_fig)

    %data
    data = cell(0);
    for i=nb_isi
        data{end+1} = isi_clinic.data{condition_fig(cond),sstage,i,success}; %success        
    end
    for i=nb_isi
        data{end+1} = isi_clinic.data{condition_fig(cond),sstage,i,failed}; %failed
    end
    for i=nb_isi
        data{end+1} = isi_clinic.data{cond_basal,sstage,i,1}; %basal
    end

    %subplot
    subplot(1,length(condition_fig),cond), hold on,
        [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'paired',0,'horizontal',1,'barcolors',bar_color,'NonColumnTest',noncolumntest,'ShowSigstar','none', 'optiontest',optiontest);
    title(titles{cond},'fontsize',20), xlabel('s'), hold on,
    set(eb,'Linewidth',2); %bold error bar
    set(gca, 'YTickLabel',labels, 'YTick',1:numel(labels),'FontName','Times','fontsize',15), hold on,
%     set(gca, 'XTick',0:1000:3000,'XLim',[0 5000]);

    %lines
    for i=nb_isi
        mean_success_x = nanmean(data{i});
        line([mean_success_x mean_success_x], [i i+6.3], 'color', 'b', 'LineStyle', '--'), hold on
    end
    for i=nb_isi
        mean_success_x = nanmean(data{i+3});
        line([mean_success_x mean_success_x], [i+3 i+6.3], 'color', 'r', 'LineStyle', '--'), hold on
    end

end


%% Figure2 - Order by isi
condition_fig = [cond_random, cond_upphase];
titles = {'Random','Up Phase'};
maintitle = 'Inter delta waves interval (Basal night and night with Tones';
labels={'Success Tones n+1','Failed Tones n+1','Basal n+1','Success Tones n+2','Failed Tones n+2','Basal n+2','Success Tones n+3','Failed Tones n+3','Basal n+3',};
bar_color={'b','r',[0.2 0.2 0.2]};
bar_color = [bar_color bar_color bar_color];
columtest  = [nchoosek(1:3,2) ; nchoosek(1:3,2) + 3; nchoosek(1:3,2) + 2*3];
nb_isi = 1:3;


figure, hold on
for cond=1:length(condition_fig)

    %data
    data = cell(0);
    for i=nb_isi
        data{end+1} = isi_clinic.data{condition_fig(cond),sstage,i,success}; %success        
        data{end+1} = isi_clinic.data{condition_fig(cond),sstage,i,failed}; %failed
        data{end+1} = isi_clinic.data{cond_basal,sstage,i,1}; %basal
    end

    %subplot
    subplot(1,length(condition_fig),cond), hold on,
        [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'paired',0,'horizontal',1,'barcolors',bar_color,'ColumnTest',columtest,'ShowSigstar','sig', 'optiontest',optiontest);
    title(titles{cond},'fontsize',20), xlabel('s'), hold on,
    set(eb,'Linewidth',2); %bold error bar
    set(gca, 'YTickLabel',labels, 'YTick',1:numel(labels),'FontName','Times','fontsize',15), hold on,
%     set(gca, 'XTick',0:1000:3000,'XLim',[0 5000]);


end











