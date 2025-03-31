clear all
mm=0;
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170202/ProjectEmbReact_M512_20170202_BaselineSleep';
mm = mm+1; FileName{mm} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170204/ProjectEmbReact_M512_20170204_BaselineSleep';
FolderName = '/media/DataMOBsRAIDN/ProjetNREM/Figures_SB/';
cols = lines(5);
RemoveDown = 0;
Binsize = 1*1e4;

for m = 1 : mm
    cd(FileName{m})
    clf
    load('SleepSubstages.mat')
    load('SpikeData.mat')
    [numNeurons, numtt, TT] = GetSpikesFromStructure('PFCx','remove_MUA',1);
    S = S(numNeurons);
    
    Q = MakeQfromS(S,Binsize);
    
    if RemoveDown
        
        % Arrange everything (downstates and sleep epochs) with the right bins
        load('DownState.mat')
        
        load('LFPData/LFP1.mat')
        AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
        tps = Range(LFP);

        % Downs
        timeEvents = Data(Restrict(AllTime,alldown_PFCx));
        binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
        QEvents = MakeQfromS(binsEvents,Binsize);
        QDown = tsd(Range(QEvents),Data(QEvents)/(1250*Binsize/1e4)); % divide by number of bins in 2seconds
        DatQ = Data(Q);
        for sp = 1:length(numNeurons)
            DatQ(:,sp) = DatQ(:,sp)./(1-Data(QDown));
        end
        Q = tsd(Range(Q),DatQ);
        
    end
    
    Qref = full(zscore(Data(Q)));
    [EigVect,EigVals]=PerformPCA(Qref');
    figure(2)
    clf
    subplot(2,3,1)
    clear Vals
    for f = 1:2
        Ftsd = tsd(Range(Q),(EigVect(:,f)'*Qref')');
        for ep = 1:5
            Vals{ep}(f,:) = Data(Restrict(Ftsd,Epoch{ep}));
        end
    end
    
    
    for ep = 1:5
        
        plot(Vals{ep}(1,1:end),Vals{ep}(2,1:end),'.','color',cols(ep,:))
        hold on
    end
    for ep = 1:5
        PC1tsd = tsd(Range(Restrict(Q,Epoch{ep})), Vals{ep}(1,1:end)');
        PC2tsd = tsd(Range(Restrict(Q,Epoch{ep})), Vals{ep}(2,1:end)');
        
        intdat_g=Data(PC1tsd);
        intdat_t=Data(PC2tsd);
        
        cent=[nanmean(intdat_g),nanmean(intdat_t)];
        
        distances=(intdat_g-cent(1)).^2/nanmean((intdat_g-cent(1)).^2)+(intdat_t-cent(2)).^2/nanmean((intdat_t-cent(2)).^2);
        dist=tsd(Range(Restrict(Q,Epoch{ep})),distances);
        threshold=percentile(distances,0.75);
        SubEpochC{ep}=thresholdIntervals(dist,threshold,'Direction','Below');
        
        intdat_g=Data(Restrict(PC1tsd,SubEpochC{ep}));
        intdat_t=Data(Restrict(PC2tsd,SubEpochC{ep}));
        K=convhull(intdat_g,intdat_t);
        hold on
        plot(intdat_g(K),intdat_t(K),'linewidth',3,'color',cols(ep,:)*0.8)
    end
    legend(NameEpoch(1:5))
    xlabel('PC1')
    ylabel('PC2')
    box off
    set(gca,'FontSize',15,'linewidth',2)
    
    subplot(2,3,4)
    clear Vals
    for f = 1:2
        Ftsd = tsd(Range(Q),(EigVect(:,f+2)'*Qref')');
        for ep = 1:5
            Vals{ep}(f,:) = Data(Restrict(Ftsd,Epoch{ep}));
        end
    end
    
    
    for ep = 1:5
        
        plot(Vals{ep}(1,1:end),Vals{ep}(2,1:end),'.','color',cols(ep,:))
        hold on
    end
    for ep = 1:5
        PC1tsd = tsd(Range(Restrict(Q,Epoch{ep})), Vals{ep}(1,1:end)');
        PC2tsd = tsd(Range(Restrict(Q,Epoch{ep})), Vals{ep}(2,1:end)');
        
        intdat_g=Data(PC1tsd);
        intdat_t=Data(PC2tsd);
        
        cent=[nanmean(intdat_g),nanmean(intdat_t)];
        
        distances=(intdat_g-cent(1)).^2/nanmean((intdat_g-cent(1)).^2)+(intdat_t-cent(2)).^2/nanmean((intdat_t-cent(2)).^2);
        dist=tsd(Range(Restrict(Q,Epoch{ep})),distances);
        threshold=percentile(distances,0.75);
        SubEpochC{ep}=thresholdIntervals(dist,threshold,'Direction','Below');
        
        intdat_g=Data(Restrict(PC1tsd,SubEpochC{ep}));
        intdat_t=Data(Restrict(PC2tsd,SubEpochC{ep}));
        K=convhull(intdat_g,intdat_t);
        hold on
        plot(intdat_g(K),intdat_t(K),'linewidth',3,'color',cols(ep,:)*0.8)
    end
    legend(NameEpoch(1:5))
    xlabel('PC3')
    ylabel('PC4')
    box off
    set(gca,'FontSize',15,'linewidth',2)
    
    
    subplot(2,3,2)
    clear Vals
    Vals.N1 = Data(Restrict(Q,Epoch{1}));
    Vals.N2 = Data(Restrict(Q,Epoch{2}));
    Vals.N3 = Data(Restrict(Q,Epoch{3}));
    Vals.REM = Data(Restrict(Q,Epoch{4}));
    Vals.Wake = Data(Restrict(Q,Epoch{5}));
    fields = fieldnames(Vals);
    cols = lines(5);
    Vect1 = full(nanmean(Vals.N1(1:end/2,:))-nanmean(Vals.Wake(1:end/2,:)));
    Vect2 = full(nanmean(Vals.N1(1:end/2,:))-nanmean(Vals.N3(1:end/2,:)));
    hold on
    for ff = 1:5
        Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect1');
        Proj2 = full(Vals.(fields{ff})(end/2:end,:)*Vect2');
        distances = tsd(1:length(Proj1),(Proj1 - nanmean(Proj1)).^2 + (Proj2 - nanmean(Proj2)).^2);
        Proj1 = tsd(1:length(Proj1),Proj1);
        Proj2 = tsd(1:length(Proj2),Proj2);
        %     for thres = 0.8:-0.1:0.4
        thres = 0.5;
        threshold = percentile(Data(distances),thres);
        SubEpoch = thresholdIntervals(distances,threshold,'Direction','Below');
        Proj1sub = Data(Restrict(Proj1,SubEpoch));
        Proj2sub = Data(Restrict(Proj2,SubEpoch));
        
        K=convhull(Proj1sub,Proj2sub);
        plot(Proj1sub(K),Proj2sub(K),'LineWidth',3,'color',cols(ff,:)), hold on
        %         P = patch(Proj1sub(K),Proj2sub(K),cols(ff,:));hold on
        %         set(P,'FaceAlpha',0.3)
        %         set(P,'EdgeColor','none')
        %
        %     end
    end
    legend(fields)
    xlabel('Wake vs N1')
    ylabel('N3 vs N1')
    box off
    set(gca,'FontSize',15,'linewidth',2)
    
    subplot(2,3,5)
    Vect1 = full(nanmean(Vals.REM(1:end/2,:))-nanmean(Vals.Wake(1:end/2,:)));
    Vect2 = full(nanmean(Vals.Wake(1:end/2,:))-nanmean(Vals.N3(1:end/2,:)));
    hold on
    for ff = 1:5
        Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect1');
        Proj2 = full(Vals.(fields{ff})(end/2:end,:)*Vect2');
        distances = tsd(1:length(Proj1),(Proj1 - nanmean(Proj1)).^2 + (Proj2 - nanmean(Proj2)).^2);
        Proj1 = tsd(1:length(Proj1),Proj1);
        Proj2 = tsd(1:length(Proj2),Proj2);
        %     for thres = 0.8:-0.1:0.4
        thres = 0.5;
        threshold = percentile(Data(distances),thres);
        SubEpoch = thresholdIntervals(distances,threshold,'Direction','Below');
        Proj1sub = Data(Restrict(Proj1,SubEpoch));
        Proj2sub = Data(Restrict(Proj2,SubEpoch));
        
        K=convhull(Proj1sub,Proj2sub);
        plot(Proj1sub(K),Proj2sub(K),'LineWidth',3,'color',cols(ff,:)), hold on
        %         P = patch(Proj1sub(K),Proj2sub(K),cols(ff,:));hold on
        %         set(P,'FaceAlpha',0.3)
        %         set(P,'EdgeColor','none')
        %
        %     end
    end
    legend(fields)
    ylabel('Wake vs N3')
    xlabel('Wake vs REM')
    box off
    set(gca,'FontSize',15,'linewidth',2)
    
        Q = tsd(Range(Q),zscore(Data(Q)));
  
    subplot(2,3,3)
    clear Vals
    Vals.N1 = Data(Restrict(Q,Epoch{1}));
    Vals.N2 = Data(Restrict(Q,Epoch{2}));
    Vals.N3 = Data(Restrict(Q,Epoch{3}));
    Vals.REM = Data(Restrict(Q,Epoch{4}));
    Vals.Wake = Data(Restrict(Q,Epoch{5}));
    fields = fieldnames(Vals);
    cols = lines(5);
    Vect1 = full(nanmean(Vals.N1(1:end/2,:))-nanmean(Vals.Wake(1:end/2,:)));
    Vect2 = full(nanmean(Vals.N1(1:end/2,:))-nanmean(Vals.N3(1:end/2,:)));
    hold on
    for ff = 1:5
        Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect1');
        Proj2 = full(Vals.(fields{ff})(end/2:end,:)*Vect2');
        distances = tsd(1:length(Proj1),(Proj1 - nanmean(Proj1)).^2 + (Proj2 - nanmean(Proj2)).^2);
        Proj1 = tsd(1:length(Proj1),Proj1);
        Proj2 = tsd(1:length(Proj2),Proj2);
        %     for thres = 0.8:-0.1:0.4
        thres = 0.5;
        threshold = percentile(Data(distances),thres);
        SubEpoch = thresholdIntervals(distances,threshold,'Direction','Below');
        Proj1sub = Data(Restrict(Proj1,SubEpoch));
        Proj2sub = Data(Restrict(Proj2,SubEpoch));
        
        K=convhull(Proj1sub,Proj2sub);
        plot(Proj1sub(K),Proj2sub(K),'LineWidth',3,'color',cols(ff,:)), hold on
        %         P = patch(Proj1sub(K),Proj2sub(K),cols(ff,:));hold on
        %         set(P,'FaceAlpha',0.3)
        %         set(P,'EdgeColor','none')
        %
        %     end
    end
    legend(fields)
    xlabel('Wake vs N1')
    ylabel('N3 vs N1')
    box off
    set(gca,'FontSize',15,'linewidth',2)
    
    subplot(2,3,6)
    Vect1 = full(nanmean(Vals.REM(1:end/2,:))-nanmean(Vals.Wake(1:end/2,:)));
    Vect2 = full(nanmean(Vals.Wake(1:end/2,:))-nanmean(Vals.N3(1:end/2,:)));
    hold on
    for ff = 1:5
        Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect1');
        Proj2 = full(Vals.(fields{ff})(end/2:end,:)*Vect2');
        distances = tsd(1:length(Proj1),(Proj1 - nanmean(Proj1)).^2 + (Proj2 - nanmean(Proj2)).^2);
        Proj1 = tsd(1:length(Proj1),Proj1);
        Proj2 = tsd(1:length(Proj2),Proj2);
        %     for thres = 0.8:-0.1:0.4
        thres = 0.5;
        threshold = percentile(Data(distances),thres);
        SubEpoch = thresholdIntervals(distances,threshold,'Direction','Below');
        Proj1sub = Data(Restrict(Proj1,SubEpoch));
        Proj2sub = Data(Restrict(Proj2,SubEpoch));
        
        K=convhull(Proj1sub,Proj2sub);
        plot(Proj1sub(K),Proj2sub(K),'LineWidth',3,'color',cols(ff,:)), hold on
        %         P = patch(Proj1sub(K),Proj2sub(K),cols(ff,:));hold on
        %         set(P,'FaceAlpha',0.3)
        %         set(P,'EdgeColor','none')
        %
        %     end
    end
    legend(fields)
    xlabel('Wake vs REM')
    ylabel('Wake vs N3')
    box off
    set(gca,'FontSize',15,'linewidth',2)
    
    saveas(2,[FolderName 'ComparePCADecodingDownCorr',num2str(m),'.png'])
end
