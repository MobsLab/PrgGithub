clear all
Dir=PathForExperimentsSleepRipplesSpikes('Basal')
FolderName = '/media/DataMOBsRAIDN/ProjetNREM/Figures_SB/PCADifferentStates/';
cols = lines(5);
RemoveDown = 0;
Binsize = 2*1e4;
figure
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
    
    
    % Sleep substates
    try,load('SleepSubstages.mat')
    catch
        load('NREMsubstages.mat')
    end
    
    
    Qref = full(zscore(Data(Q)));
    [EigVect,EigVals]=PerformPCA(Qref');
    
    clear Vals Ftsd
    for f = 1:2
        [vali,ind] = max(abs(EigVect(:,f)));
        EigVect(:,f) = sign(EigVect(ind,f)) * EigVect(:,f);
        Ftsd{f} = tsd(Range(Q),(EigVect(:,f)'*Qref')');
        if f==2
            if sign(nanmean(Data(Restrict(Ftsd{f},Epoch{4}))))==-1
                Ftsd{f} = tsd(Range(Q),(-EigVect(:,f)'*Qref')');
            end
        end
        for ep = 1:5
            Vals{ep}(f,:) = Data(Restrict(Ftsd{f},Epoch{ep}));
        end
    end
    
    
    % Get distance in PCA space
    for ep = 1:5
        Loc(ep,:) = [nanmean(Vals{ep}(1,1:end)),nanmean(Vals{ep}(2,1:end))];
    end
    
    MatDist = squareform(pdist(Loc));
    
    
    AllPerm = perms(1:5);
    AllPerm = AllPerm(AllPerm(:,1)==1,:);
    clear Dist TotDist
    for k = 1:size(AllPerm,1)
        for i = 1:4
            Dist(i) = MatDist(AllPerm(k,i),AllPerm(k,i+1));
        end
        Dist(5) = MatDist(AllPerm(k,5),AllPerm(k,1));
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
    
    
    [xy,distance,t] = distance2curve([Loc(a,:)],[Data(Ftsd{1}),Data(Ftsd{2})],'linear');
    Postsd = tsd(Range(Q),t);
    
    subplot(4,5,m)
    
    for ep = 1:5
        polarhistogram(runmean(Data(Restrict(Postsd,Epoch{ep})),2)*pi*2,'Normalization','probability')
        RemVals{ep}{m} = runmean(Data(Restrict(Postsd,Epoch{ep})),2);
        hold on
    end
    
    
end

figure
clf
for ep = 1:5
    for m = 1 : length(Dir.path)
        AllM{ep}(m) = nanmedian(RemVals{ep}{m});
    end
end

for ep = 1:5
    polarhistogram(AllM{ep}*pi*2,'Normalization','probability')
    hold on
end

[Y,X] = hist(runmean(Data(Restrict(Postsd,Epoch{ep})),3),100);
EpochProj{ep} = [X,Y];
plot(X,Y/sum(Y),'linewidth',2)
hold on


