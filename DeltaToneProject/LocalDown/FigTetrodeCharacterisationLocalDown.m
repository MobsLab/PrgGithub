%%FigTetrodeCharacterisationLocalDown
% 25.09.2019 KJ
%
% Infos
%   
%
% see
%     LocalDownOneNightCharacterisation LocalDownOneNightCharacterisationPlot
%
%



clear
load(fullfile(FolderDeltaDataKJ,'LocalDownOneNightCharacterisation.mat'))


%params
tetrodesNames = {'A','B','C'};
fontsize = 20;
fontsize2 = 14;
color_nrem = 'r';
color_perm = [1 0.5 0.5];
color_wake = 'k';


%% Global Down
figure, hold on

%down distrib
subplot(5,2,[1 3 5]), hold on
h(1) = plot(duration_bins, nbDownGlob.real.nrem,'color','r','linewidth',2);
h(3) = plot(duration_bins, nbDownGlob.real.wake,'k','linewidth',2);
for k=1:length(permutation_range)
    h(2) = plot(duration_bins, nbDownGlob.perm.nrem{k},'color',color_perm);
end
line([75 75], [1 1e6],'Linewidth',2,'color','k'), hold on
set(gca,'xscale','log','yscale','log'), hold on
set(gca,'ylim',[1 1E6],'xlim',[10 1500]), hold on
set(gca,'xtick',[10 50 100 200 500 1500],'fontsize',fontsize), hold on
legend(h, 'NREM', 'NREM permuted', 'Wake'), xlabel('down duration (ms)'), ylabel('number of down')
title('All neurons (Global down)'),

%For each tetrodes
gap = [0.04 0.04];
    
MGlobal = MatnGlobal.center./ mean(MatnGlobal.center(:,x_matG<-600),2);
for tt=1:nb_tetrodes
    subtightplot(10,2,[2 4]+(tt-1)*4,gap), hold on        
    for i=1:length(local_neurons{tt})
        plot(x_matG, Smooth(MGlobal(local_neurons{tt}(i),:),1),'color',[0.7 0.7 0.7])
    end
    plot(x_matG, mean(MGlobal(local_neurons{tt},:),1),'color','k','linewidth',2)
    
    set(gca,'xlim',[-500 500],'xtick',[],'ytick',-1:1,'ylim',[0 2.1],'fontsize',fontsize);
    line([0 0], ylim,'Linewidth',2,'color',[0.8 0.8 0.8], 'linewidth',0.4), hold on
    title(['Tetrode ' tetrodesNames{tt}],'fontsize',fontsize2), 
end
xlabel('time from global down center (ms)'), ylabel('normalized occurence of spikes'),
xticks([-500 0 500]),


%% Local Down

%% For each tetrodes
for tt=1:nb_tetrodes
    figure, hold on
    
    
    %% down distrib
    subplot(5,2,[1 3 5]), hold on
    h(1) = plot(duration_bins, nbDownLoc.real.nrem{tt},'color',color_nrem,'linewidth',2);
    h(3) = plot(duration_bins, nbDownLoc.real.wake{tt},color_wake,'linewidth',2);
    for k=1:length(permutation_range)
        h(2) = plot(duration_bins, nbDownLoc.perm.nrem{tt}{k},'color',color_perm);
    end
    line([100 100], [1 1e6],'Linewidth',2,'color','k'), hold on
    set(gca,'xscale','log','yscale','log'), hold on
    set(gca,'ylim',[1 1E6],'xlim',[10 1500]), hold on
    set(gca,'xtick',[10 50 100 200 500 1500],'fontsize',fontsize), hold on
    legend(h, 'NREM', 'NREM permuted', 'Wake'), xlabel('down duration (ms)'), ylabel('number of down')
    title(['Tetrode ' tetrodesNames{tt}]),
    
    
    %% Cross-corr tetrode
    gap = [0.04 0.04];
    
    MLocal = MatnLocal.center{tt}./ mean(MatnLocal.center{tt}(:,x_matG<-600),2);

    %ext neurons
    subtightplot(10,2,[2 4 6],gap), hold on
    for i=1:length(ext_neurons{tt})
        plot(x_matG, Smooth(MLocal(ext_neurons{tt}(i),:),1),'color',[0.7 0.7 0.7])
    end
    plot(x_matG, mean(MLocal(ext_neurons{tt},:),1),'color','k','linewidth',2)
    
    set(gca,'xlim',[-500 500],'ylim',[0 3.5],'xtick',[],'fontsize',fontsize);
    line([0 0], ylim,'Linewidth',2,'color',[0.8 0.8 0.8], 'linewidth',0.4), hold on
    ylabel('normalized occurence of spikes')
    title('Out of tetrodes','fontsize',fontsize2), 
    
    %local neurons
    subtightplot(10,2,[8 10 12],gap), hold on        
    for i=1:length(local_neurons{tt})
        plot(x_matG, Smooth(MLocal(local_neurons{tt}(i),:),1),'color',[0.7 0.7 0.7])
    end
    plot(x_matG, mean(MLocal(local_neurons{tt},:),1),'color','k','linewidth',2)
    
    set(gca,'xlim',[-500 500],'ylim',[0 3.5],'fontsize',fontsize);
    line([0 0], ylim,'Linewidth',2,'color',[0.8 0.8 0.8], 'linewidth',0.4), hold on
    xlabel('time from local down center (ms)'),
    title(['Tetrode ' tetrodesNames{tt}],'fontsize',fontsize2),

    
end

