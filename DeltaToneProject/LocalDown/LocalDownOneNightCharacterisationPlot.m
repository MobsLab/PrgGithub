%%LocalDownOneNightCharacterisationPlot
% 25.09.2019 KJ
%
% Infos
%   Examples homeostasis figures
%
% see
%     PlotExampleOneNightLocalDown LocalDownOneNightCharacterisation
%
%



clear
load(fullfile(FolderDeltaDataKJ,'LocalDownOneNightCharacterisation.mat'))


%params
tetrodesNames = {'A','B','C','D','E','F'};





%% local

for tt=1:nb_tetrodes
    figure, hold on
    
    
    %% down distrib
    subplot(2,4,1), hold on
    h(1) = plot(duration_bins, nbDownLoc.real.nrem{tt},'color',[0 0.5 0],'linewidth',2);
    h(2) = plot(duration_bins, nbDownLoc.real.wake{tt},'k','linewidth',2);
    for k=1:length(permutation_range)
        plot(duration_bins, nbDownLoc.perm.nrem{tt}{k},'color',[0 0.5 0]),
    end
    line([100 100], [1 1e6],'Linewidth',2,'color','k'), hold on
    set(gca,'xscale','log','yscale','log'), hold on
    set(gca,'ylim',[1 1E6],'xlim',[10 1500]), hold on
    set(gca,'xtick',[10 50 100 200 500 1500]), hold on
    legend(h, 'NREM','Wake'), xlabel('down duration (ms)'), ylabel('number of down')
    title(['Tetrode ' tetrodesNames{tt}]),
    
    
    %% mean MUA
    subplot(2,4,2), hold on
    xmet = met_mua.local{tt}(:,1)<-500; 
    
    norm_factor = mean(met_mua.local{tt}(xmet,2));
    h(1) = plot(met_mua.local{tt}(:,1), met_mua.local{tt}(:,2)/norm_factor, 'color','k','linewidth',2);
    norm_factor = mean(met_mua.ext{tt}(xmet,2));
    h(2) = plot(met_mua.ext{tt}(:,1), met_mua.ext{tt}(:,2)/norm_factor, 'color','r','linewidth',2);
    
    set(gca, 'xlim',[-500 500]),
    line([0 0], ylim,'Linewidth',2,'color',[0.8 0.8 0.8], 'linewidth',0.4), hold on
    xlabel('time from local down (ms)'), ylabel('Normalized MUA')
    legend(h, ['tetrode ' tetrodesNames{tt}],  'other tetrodes'),
    title('MUA on local down')
    
    
    %% Cross-corr tetrode
    MLocal = MatnLocal.center{tt}./ mean(MatnLocal.center{tt}(:,x_matG<-600),2);

        
    %ext neurons
    subplot(4,4,3), hold on        
    for i=1:length(ext_neurons{tt})
        plot(x_matG, Smooth(MLocal(ext_neurons{tt}(i),:),1),'color',[0.7 0.7 0.7])
    end
    plot(x_matG, mean(MLocal(ext_neurons{tt},:),1),'color','k','linewidth',2)
    
    set(gca,'xlim',[-500 500]);
    line([0 0], ylim,'Linewidth',2,'color',[0.8 0.8 0.8], 'linewidth',0.4), hold on
    ylabel('normalized occurence of spikes')
    title('CrossCorr spikes on down states center')
    
    %local neurons
    subplot(4,4,7), hold on
    for i=1:length(local_neurons{tt})
        plot(x_matG, Smooth(MLocal(local_neurons{tt}(i),:),1),'color',[0.7 0.7 0.7])
    end
    plot(x_matG, mean(MLocal(NeuronTetrodes{tt},:),1),'color','k','linewidth',2)
    
    set(gca,'xlim',[-500 500]);
    line([0 0], ylim,'Linewidth',2,'color',[0.8 0.8 0.8], 'linewidth',0.4), hold on
    ylabel('normalized occurence of spikes'), xlabel('time from local down center (ms)'),
    

    
    
    
    
end







