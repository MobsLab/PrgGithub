% QuantifClinicISI2
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

%% params
NameSleepStages = {'N1','N2', 'N3','REM','Wake'}; % Sleep stages
sstage=3; %N3
NameISI = {'d(n,n+1)','d(n,n+2)','d(n,n+3)','d(n+1,n+2)','d(n+1,n+3)','d(n+2,n+3)'}; %ISI
lineColors = {'b','r',[0.2 0.2 0.2]};
labels = {'Success','Failed','Basal'};


cond_basal = find(strcmpi(conditions,'Basal'));
cond_random = find(strcmpi(conditions,'Random'));
cond_upphase = find(strcmpi(conditions,'UpPhase'));

failed=1;
success=2;

optiontest='ranksum';
condition_fig = [cond_random, cond_upphase];
nb_isi = 1:3;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Order and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        data{end+1} = isi_clinic.data{cond_basal,sstage,i,1}; %failed
    end

    %% Stat data
    N=length(data); %number of column
    R=[];
    E=[];

    for i=1:N
        [Ri,~,Ei]=MeanDifNan(data{i});
        R=[R,nanmedian(data{i})];
        E=[E,Ei];
    end


    %% lines
    for i=1:length(labels)
        idx_line = (1:length(nb_isi)) + (i-1)*length(nb_isi);
        x_line{i} =  R(idx_line);
        bar_line{i} = E(idx_line);
    end


    figure, hold on
    %lines
    for i=1:length(labels)
        plot(x_line{i}, 1:length(nb_isi),'color',lineColors{i},'Linewidth',2), hold on
    end
    legend(labels)
    %error bar
    for i=1:length(labels)
        eb=herrorbar(x_line{i},1:length(nb_isi),bar_line{i},'.k'); hold on
        set(eb,'Linewidth',2); %bold error bar
    end

    title([NameSleepStages{sstage} ' - ' conditions{condition_fig(cond)}],'fontsize',20), xlabel('s'), hold on,
    set(gca, 'YTickLabel',NameISI(nb_isi), 'YTick',1:length(nb_isi),'YLim',[0.5 length(nb_isi)+0.5],'FontName','Times','fontsize',20), hold on,
    set(gca, 'XTick',0:10:30,'XLim',[0 22]);

end









