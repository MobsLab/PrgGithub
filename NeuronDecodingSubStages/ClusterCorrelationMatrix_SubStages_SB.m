clear all
mm=0;
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170202/ProjectEmbReact_M512_20170202_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170204/ProjectEmbReact_M512_20170204_BaselineSleep';
Binsizes =[3]*1e4;

for m = 1 : mm
    cd(FileName{m})
    
    load('SpikeData.mat')
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
    load('SleepSubstages.mat')
    mkdir('ClusterCorrelationMat')
    
    for bb = 1:length(Binsizes)
        
        Binsize = Binsizes(bb);
        
        Q = MakeQfromS(S(numNeurons),Binsize);
        zDat = full(zscore(full(Data(Q))));
        A = full((corr(zDat',zDat')));
        times = (Range(Q));
        Z = linkage(full(A),'complete','correlation');
        save(['ClusterCorrelationMat/ClusterPFCActivity_',num2str(Binsize/1e4),'s.mat'],'A','Z','Binsize','-v7.3')
        
        Q = MakeQfromS(S(numNeurons),Binsize);
        Q = Restrict(Q,Epoch{10});
        zDat = full(zscore(full(Data(Q))));
        A = full((corr(zDat',zDat')));
        times = (Range(Q));
        Z = linkage(full(A),'complete','correlation');
        save(['ClusterCorrelationMat/ClusterPFCActivitySleepOnly_',num2str(Binsize/1e4),'s.mat'],'A','Z','Binsize','-v7.3')
        
        Q = MakeQfromS(S(numNeurons),Binsize);
        Q = Restrict(Q,Epoch{7});
        zDat = full(zscore(full(Data(Q))));
        A = full((corr(zDat',zDat')));
        times = (Range(Q));
        Z = linkage(full(A),'complete','correlation');
        save(['ClusterCorrelationMat/ClusterPFCActivitySWSOnly_',num2str(Binsize/1e4),'s.mat'],'A','Z','Binsize','-v7.3')
        
    end
end

%% look at results
FolderName = '/media/DataMOBsRAIDN/ProjetNREM/Figures_SB/';
for m = 1 : mm
    cd(FileName{m})
    
    load('SpikeData.mat')
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
    load('SleepSubstages.mat')
    figure(1)
    %% all data
    load('ClusterCorrelationMat/ClusterPFCActivity_3s.mat')
    Q = MakeQfromS(S(numNeurons),Binsize);
    times = (Range(Q));
    
%     for clu = 2:10
%         T = cluster(Z,'maxclust',clu);
%         [val,ind] = sort(T);
%         subplot(5,1,1)
%         plot(Range(Q,'h'),T(ind),'linewidth',5)
%         xlim([0 max(Range(Q,'h'))])
%         box off
%         set(gca,'linewidth',2,'FontSize',16)
%         title('Cluster number')
%         
%         subplot(5,1,2:4)
%         imagesc(Range(Q,'h'),Range(Q,'h'),A(ind,ind))
%         clim([-0.5 0.5])
%         xlim([0 max(Range(Q,'h'))])
%         box off
%         set(gca,'linewidth',2,'FontSize',16)
%         title('Corr mat clustered')
%         colormap jet
%         
%         subplot(5,1,5)
%         clear percstate
%         for t = 1:clu
%             goodtimes = ts(times(find(T==t)));
%             for n = 1:5
%                 percstate(t,n) = length(Range(Restrict(goodtimes,Epoch{n})))./sum(T==t);
%             end
%         end
%         bar(percstate,'stacked')
%         legend(NameEpoch(1:5))
%         box off
%         set(gca,'linewidth',2,'FontSize',16)
%         ylabel('% cluster in state')
%         
%         saveas(1,[FolderName 'AllData_',num2str(m),'_',num2str(clu),'clusters.png'])
%         clf
%     end
%     
%     % just sleep
%     load('ClusterCorrelationMat/ClusterPFCActivitySleepOnly_3s.mat')
%     Q = MakeQfromS(S(numNeurons),Binsize);
%     Q = Restrict(Q,Epoch{10});
%     times = (Range(Q));
%     
%     for clu = 2:10
%         T = cluster(Z,'maxclust',clu);
%         [val,ind] = sort(T);
%         subplot(5,1,1)
%         plot(T(ind),'linewidth',5)
%         xlim([0 length(A)])
%         box off
%         set(gca,'linewidth',2,'FontSize',16)
%         title('Cluster number')
%         
%         subplot(5,1,2:4)
%         imagesc(A(ind,ind))
%         clim([-0.5 0.5])
%         xlim([0 length(A)])
%         box off
%         set(gca,'linewidth',2,'FontSize',16)
%         title('Corr mat clustered')
%         colormap jet
%         
%         subplot(5,1,5)
%         clear percstate
%         for t = 1:clu
%             goodtimes = ts(times(find(T==t)));
%             for n = 1:4
%                 percstate(t,n) = length(Range(Restrict(goodtimes,Epoch{n})))./sum(T==t);
%             end
%         end
%         bar(percstate,'stacked')
%         legend(NameEpoch(1:4))
%         box off
%         set(gca,'linewidth',2,'FontSize',16)
%         ylabel('% cluster in state')
%         
%         saveas(1,[FolderName 'SleepOnly',num2str(m),'_',num2str(clu),'clusters.png'])
%         
%         clf
%     end
    
    
    % just sws
%     load('ClusterCorrelationMat/ClusterPFCActivitySWSOnly_3s.mat')
%     Q = MakeQfromS(S(numNeurons),Binsize);
%     Q = Restrict(Q,Epoch{7});
%     times = (Range(Q));
%     
%     for clu = 2:10
%         T = cluster(Z,'maxclust',clu);
%         [val,ind] = sort(T);
%         subplot(5,1,1)
%         plot(T(ind),'linewidth',5)
%         xlim([0 length(A)])
%         box off
%         set(gca,'linewidth',2,'FontSize',16)
%         title('Cluster number')
%         
%         subplot(5,1,2:4)
%         imagesc(A(ind,ind))
%         clim([-0.5 0.5])
%         xlim([0 length(A)])
%         box off
%         set(gca,'linewidth',2,'FontSize',16)
%         title('Corr mat clustered')
%         colormap jet
%         
%         subplot(5,1,5)
%         clear percstate
%         for t = 1:clu
%             goodtimes = ts(times(find(T==t)));
%             for n = 1:3
%                 percstate(t,n) = length(Range(Restrict(goodtimes,Epoch{n})))./sum(T==t);
%             end
%         end
%         bar(percstate,'stacked')
%         legend(NameEpoch(1:3))
%         box off
%         set(gca,'linewidth',2,'FontSize',16)
%         ylabel('% cluster in state')
%         
%         saveas(1,[FolderName 'SWSOnly',num2str(m),'_',num2str(clu),'clusters.png'])
%         
%         clf
%     end
%     
%     
%     load('ClusterCorrelationMat/ClusterPFCActivity_3s.mat')
    figure(2)
    clf
    load('IdFigureData.mat')
    SleepStagesResampled = Restrict(SleepStages,ts(Range(Q)));
    [val,ind] = sort(Data(SleepStagesResampled));
    subplot(3,1,1:2)
    imagesc(Range(Q,'h'),Range(Q,'h'),A(ind,ind))
    clim([-0.5 0.5])
    xlabel('Time(h)')
    ylabel('Time(h)')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    title(['Corr Mat - sorted by substage, n=' num2str(size(Data(Q),2))])
    colormap jet
    subplot(3,1,3)
    plot(Range(Q,'h'),val,'linewidth',2)
    xlim([0 max(Range(Q,'h'))])
    ylabel_substage = {'N3','N2','N1','REM','WAKE'};
    ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
    ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
    xlabel('Time(h)')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    saveas(2,[FolderName 'OrderBySubStage',num2str(m),'.png'])
    
    
    figure(2)
    clf
    load('IdFigureData.mat')
    SleepStagesResampled = Restrict(SleepStages,ts(Range(Q)));
    [val,ind] = sort(Data(SleepStagesResampled));
    subplot(3,1,1:2)
    imagesc(Range(Q,'h'),Range(Q,'h'),SmoothDec(A(ind,ind),[1,1]))
    clim([-0.5 0.5])
    xlabel('Time(h)')
    ylabel('Time(h)')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    title(['Corr Mat - sorted by substage, n=' num2str(size(Data(Q),2))])
    colormap jet
    subplot(3,1,3)
    plot(Range(Q,'h'),val,'linewidth',2)
    xlim([0 max(Range(Q,'h'))])
    ylabel_substage = {'N3','N2','N1','REM','WAKE'};
    ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
    ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
    xlabel('Time(h)')
    box off
    set(gca,'linewidth',2,'FontSize',16)
    saveas(2,[FolderName 'OrderBySubStageSmoothed',num2str(m),'.png'])
end


