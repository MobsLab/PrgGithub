clear all
Dir=PathForExperimentsSleepRipplesSpikes('Basal')
FolderName = '/media/DataMOBsRAIDN/ProjetNREM/Figures_SB/PCADifferentStates/';
cols = lines(5);
RemoveDown = 0;
Binsize = 2*1e4;
figure(1)
clf

for m = 1 : length(Dir.path)
    
    cd(Dir.path{m})
    disp(Dir.path{m})
    
    % Load LFP to get time right
    load('LFPData/LFP1.mat')
    AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
    tps = Range(LFP);
    
    % Get the neurons from the PFCx
    load('SpikeData.mat')
    [numNeurons, numtt, TT] = GetSpikesFromStructure('PFCx','remove_MUA',1);
    try,S = tsdArray(S);end
    S = S(numNeurons);
    S{1} = tsd([0;Range(S{1});max(Range(LFP))],[0;Range(S{1});max(Range(LFP))]);
    Q = MakeQfromS(S,Binsize);
    % DatQ = zscore(Data(Q));
    % Q = tsd(Range(Q),DatQ);
    
    % Arrange everything (downstates and sleep epochs) with the right bins
    load('DownState.mat')
    
    % Downs
    timeEvents = Data(Restrict(AllTime,down_PFCx));
    binsEvents = tsdArray(tsd([0;tps(timeEvents);max(Range(LFP))],[0;tps(timeEvents);max(Range(LFP))]));
    QEvents = MakeQfromS(binsEvents,2*1e4);
    QDown = tsd(Range(QEvents),Data(QEvents)/2500); % divide by number of bins in 2seconds
    DatQ = Data(Q);
    for sp = 1:length(numNeurons)
        DatQ(:,sp) = DatQ(:,sp)./(1-Data(QDown));
    end
    Q_downcorr = tsd(Range(Q),DatQ);
    
    % Sleep substates
    try,load('SleepSubstages.mat')
    catch
        load('NREMsubstages.mat')
    end
    
    
    Qref = full(zscore(Data(Q)));
    [EigVect,EigVals]=PerformPCA(Qref');
    
    
    subplot(4,5,m)
    
    clear Vals
    for f = 1:2
        [vali,ind] = max(abs(EigVect(:,f)));
        EigVect(:,f) = sign(EigVect(ind,f)) * EigVect(:,f);
        Ftsd = tsd(Range(Q),(EigVect(:,f)'*Qref')');
        if f==2
            if sign(nanmean(Data(Restrict(Ftsd,Epoch{4}))))==-1
                Ftsd = tsd(Range(Q),(-EigVect(:,f)'*Qref')');
            end
        end
        for ep = 1:5
            Vals{ep}(f,:) = Data(Restrict(Ftsd,Epoch{ep}));
        end
    end
    
    % count transitions 2 by 2
    for ep = 1:5
        for ep2 = 1:5
            [aft_cell,bef_cell]=transEpoch(Epoch{ep},Epoch{ep2});
            TransNum(ep,ep2) = length(Start(aft_cell{1,2})); %all ep followd by ep2
        end
    end
    
    TransNum = TransNum./sum(TransNum);
    
    % Get distance in PCA space
    for ep = 1:5
        Loc(ep,:) = [nanmean(Vals{ep}(1,1:end)),nanmean(Vals{ep}(2,1:end))];
    end
    
    MatDist = squareform(pdist(Loc));
    
    
    % Link the two
    RemTranNum(m,:) = squareform(TransNum);
    RemMatDist(m,:) = squareform(MatDist);
    [CorrVal(m),PDuo(m)] = corr(RemTranNum(m,:)',RemMatDist(m,:)');
    
    
    % Look at trios
    SleepStage=[];
    for n=1:5
        SleepStage=[SleepStage; [ Start(Epoch{n},'s'),Stop(Epoch{n},'s'),n*ones(length(Start(Epoch{n})),1)]];
    end
    
    SleepStage=sortrows(SleepStage,1);
    
    ind=find(diff(SleepStage(:,3))==0);% if noise between..
    while ~isempty(ind)
        SleepStage(ind+1,1)=SleepStage(ind,1);
        SleepStage(ind,:)=[];
        ind=find(diff(SleepStage(:,3))==0);
    end
    
    SleepStage(:,4)=SleepStage(:,2)-SleepStage(:,1); % duration
    MatS=[0;0;SleepStage(:,3)];
    MatS(:,2)=[0;SleepStage(:,3);0];
    MatS(:,3)=[SleepStage(:,3);0;0];
    MatS(:,4)=[0;0;SleepStage(:,4)];
    MatS(:,5)=[0;SleepStage(:,4);0];
    MatS(:,6)=[SleepStage(:,4);0;0];
    
    TrioL = [];
    TrioDist = [];
    disp('Counting all transitions')
    for ii=1:5
        for ij=1:5
            for ik=1:5
                if ij~=ii && ij~=ik
                    ijk=find(MatS(:,1)==ii & MatS(:,2)==ij& MatS(:,3)==ik);
                    ijkL3=find(MatS(ijk,4)>3 & MatS(ijk,5)>3 & MatS(ijk,6)>3);
                    ijkL5=find(MatS(ijk,4)>5 & MatS(ijk,5)>5 & MatS(ijk,6)>5);
                    TrioL=[TrioL;[ii,ij,ik,length(ijk)]];
                    TrioDist=[TrioDist;[ii,ij,ik,MatDist(ii,ij)+MatDist(ij,ik)]];
                end
            end
        end
        
    end
    
    RemTrioL(m,:) = TrioL(:,4)';
    RemTrioDist(m,:) = TrioDist(:,4)';
    [CorrValTrio(m),PTrio(m)] = corr(RemTrioL(m,:)',RemTrioDist(m,:)');
    
    
    
    AllPerm = perms(1:5);
    AllPerm = AllPerm(AllPerm(:,1)==1,:);
    clear Dist TotDist
    for k = 1:size(AllPerm,1)
        for i = 1:4
            Dist(i) = MatDist(AllPerm(k,i),AllPerm(k,i+1));
        end
     %   Dist(5) = MatDist(AllPerm(k,5),AllPerm(k,1));
        TotDist(k) = sum(Dist);
    end
    
    [C,IA,IC] = unique(TotDist);
    GoodPerm = AllPerm(IA,:);
    A = (sortrows([C;GoodPerm']'));
    RemOrder{m} = A;
    A = A(:,2:end);
    
    a = RemOrder{m}(1,2:end);
    if a(2)~=2 & a(2)~=3
        a= fliplr(circshift(a,4));
    end
    BestOrder = a;
    
    
    [xy,distance,t] = distance2curve(Loc(a,:),[(EigVect(:,1)'*Qref')',(EigVect(:,2)'*Qref')'],'linear');
    Postsd = tsd(Range(Q),t);
    for ep = 1:5
        
    end

    
    figure(1)
    clf
    for ep = 1:5
        plot(Vals{ep}(1,1:end),Vals{ep}(2,1:end),'.','color',cols(ep,:),'MarkerSize',15)
        hold on
    end
    
    for ep = 1:5
        plot(nanmean(Vals{ep}(1,1:end)),nanmean(Vals{ep}(2,1:end)),'.','color','k','MarkerSize',50)
        plot(nanmean(Vals{ep}(1,1:end)),nanmean(Vals{ep}(2,1:end)),'.','color',cols(ep,:),'MarkerSize',40)
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
        plot(intdat_g(K),intdat_t(K),'linewidth',5,'color',cols(ep,:)*0.8)
    end
    
    plot(Loc(BestOrder,1),Loc(BestOrder,2),'-','linewidth',4,'MarkerSize',10,'color','k')
    
    xlabel('PC1')
    ylabel('PC2')
    box off
    set(gca,'FontSize',20,'linewidth',2)
    axis tight
    title([Dir.name{m} ' - ' num2str(length(EigVals)) ' units'])
    legend(NameEpoch(1:5))
    keyboard
    saveas(1,['/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/N1N2N3PCA/PCAShortestpath',num2str(m),'.png'])
    
end


for m = 1 : length(Dir.path)
%     a = RemOrder{m}(1,2:end);
%     if a(2)~=2 & a(2)~=3
%         a= fliplr(circshift(a,4));
%     end
%     BestOrder(m,:) = a;
%     
%     a = RemOrder{m}(2,2:end);
%     if a(2)~=2 & a(2)~=3
%         a= fliplr(circshift(a,4));
%     end
%     SecondBestOrder(m,:) = a;
    
    MouseName{m} = Dir.name{m};
    
end

figure
subplot(121)
plotSpread(BestOrder)
xlabel('Order of visit')
set(gca,'YTick',[1:5],'YTickLabel',{'N1','N2','N3','REM','Wake'})
ylim([0 6])
set(gca,'FontSize',15,'linewidth',2)
title('Shortest path')

subplot(122)
plotSpread(SecondBestOrder)
xlabel('Order of visit')
set(gca,'YTick',[1:5],'YTickLabel',{'N1','N2','N3','REM','Wake'})
ylim([0 6])
set(gca,'FontSize',15,'linewidth',2)
title('Second shortest path')


figure
subplot(121)
imagesc(BestOrder)
set(gca,'YTick',1:m,'YTickLabel',MouseName)
colormap(cols)
set(gca,'FontSize',15,'linewidth',2)
box off
xlabel('Order of visit')
title('Shortest path')

subplot(122)
imagesc(SecondBestOrder)
colormap(cols)
set(gca,'YTick',1:m,'YTickLabel',MouseName)
set(gca,'FontSize',15,'linewidth',2)
set(gca,'FontSize',15,'linewidth',2)
box off
xlabel('Order of visit')
title('Second shortest path')

figure
CorrVal(18) = NaN;
subplot(221)
plotSpread(-CorrVal')
line([0.5 1.5],[1 1]*nanmedian(-CorrVal),'color',[0.6 0.6 0.6],'linewidth',2)
ylim([0 1])
ylabel('Corr Num trans vs dist in PFC PCA space')
box off
set(gca,'FontSize',11,'linewidth',2)
title('Transition duos')

CorrValTrio(18) = NaN;
subplot(222)
plotSpread(-CorrValTrio')
line([0.5 1.5],[1 1]*nanmedian(-CorrValTrio),'color',[0.6 0.6 0.6],'linewidth',2)
ylim([0 1])
ylabel('Corr Num trans vs dist in PFC PCA space')
box off
set(gca,'FontSize',11,'linewidth',2)
title('Transition trios')

subplot(223)
for m = 1 : length(Dir.path)
    plot(log(RemTranNum(m,:)/sum(RemMatDist(m,:))),log(RemMatDist(m,:)),'*')
    hold on
end
xlabel('Prop of transitions')
ylabel('Distance in PFC PCA space')
box off
set(gca,'FontSize',11,'linewidth',2)

subplot(224)
for m = 1 : length(Dir.path)
    plot(log(RemTrioL(m,:)/sum(RemTrioDist(m,:))),log(RemTrioDist(m,:)),'*')
    hold on
end
xlabel('Prop of transitions')
ylabel('Distance in PFC PCA space')
box off
set(gca,'FontSize',11,'linewidth',2)
