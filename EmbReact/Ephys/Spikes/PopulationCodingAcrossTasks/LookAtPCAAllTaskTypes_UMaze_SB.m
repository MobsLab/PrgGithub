clear all
Dir=PathForExperimentsSleepRipplesSpikes('Basal')
FolderName = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/PopulationCodingAcrossTasks/';
cols = lines(5);
RemoveDown = 0;
Binsize = 1*1e4;
SpeedLim = 3;
FieldGroups{1} = {'HomeMov','EPMOpen','EPMClose','SoundFz','UMazeHab','SoundHab','UMazeMov' ,'UMazeFzSk','UMazeFzSf'};
FieldGroups{2} = {'EPMOpen','EPMClose','SoundFz','UMazeMov' ,'UMazeFzSk','UMazeFzSf'};
FieldGroups{3} = {'UMazeMov' ,'UMazeFzSk','UMazeFzSf'};
FieldGroups{4} = {'EPMOpen','EPMClose','EPMCentre'};

figure(2)
clf

MiceNumber=[490,507,508,509,510,512,514];

for mm = 1 : length(MiceNumber)
    
    
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    
    
    % epochs
    NoiseEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepoch');
    FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
    StimEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
    SessNames = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','sessiontype');
    ZoneEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','zoneepoch');
    SleepStates = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','sleepstates');
    
    Vtsd = ConcatenateDataFromFolders_SB(Dir,'speed');
    
    MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
    MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4) - FreezeEpoch;
    
    LinPos = ConcatenateDataFromFolders_SB(Dir,'linearposition');
    
    % Spikes
    Spikes = ConcatenateDataFromFolders_SB(Dir,'Spikes');
    cd(Dir{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx','remove_MUA',1);
    Spikes = Spikes(numNeurons);
    
%     % Epoch of interest
%     clear EPOI
%     HomeCage = or(or(SessNames.SleepPost{1},SessNames.SleepPostSound{1}),or(SessNames.SleepPre{1},SessNames.SleepPreSound{1}));
%     EPOI.HomeMov = and(SleepStates{1},HomeCage);
%     
%     EPOI.EPMOpen = and(SessNames.EPM{1},ZoneEpoch{1});
%     EPOI.EPMClose = and(SessNames.EPM{1},ZoneEpoch{2});
%     EPOI.EPMCentre = and(SessNames.EPM{1},ZoneEpoch{3});
% 
%     EPOI.SoundFz = and(SessNames.SoundTest{1},FreezeEpoch);
%     EPOI.SoundHab = SessNames.SoundHab{1};
% 
%     UMaze = SessNames.UMazeCond{1};
%     for i = 2:length(SessNames.UMazeCond)
%         UMaze = or(UMaze, SessNames.UMazeCond{i});
%     end
%     EPOI.UMazeHab = SessNames.Habituation{1};
%     EPOI.UMazeMov = and(UMaze,MovEpoch);
%     EPOI.UMazeFzSf = and(and(UMaze,FreezeEpoch),thresholdIntervals(LinPos,0.6,'Direction','Above'));
%     EPOI.UMazeFzSk = and(and(UMaze,FreezeEpoch),thresholdIntervals(LinPos,0.4,'Direction','Below'));
%     
%     
%     for fg = 1:length(FieldGroups)
%         clf
%         Fields = FieldGroups{fg};
%         TotEpoch = intervalSet([],[]);
%         for ep = 1:length(Fields)
%             TotEpoch = or(TotEpoch,EPOI.(Fields{ep}));
%         end
%         
%         Q = MakeQfromS(Spikes,Binsize);
%         Q = Restrict(Q,TotEpoch-NoiseEpoch);
%         
%         
%         % PCA
%         
%         cols = distinguishable_colors(length(Fields));
%         Qref = full(zscore(Data(Q)));
%         [EigVect,EigVals]=PerformPCA(Qref');
%         for i =1:3
%             for k = 1:3
%                 subplot(3,3,i+(k-1)*3)
%                 Projtsd1 = tsd(Range(Q),(EigVect(:,i)'*Qref')');
%                 Projtsd2 = tsd(Range(Q),(EigVect(:,k)'*Qref')');
%                 %                 plot(Data(Projtsd1),Data(Projtsd2),'.k')
%                 hold on
%                 if i==3 & k==3
%                     for ep = 1:length(Fields)
%                         plot(Data(Restrict(Projtsd1,EPOI.(Fields{ep}))),Data(Restrict(Projtsd2,EPOI.(Fields{ep}))),'.','MarkerSize',50,'color',cols(ep,:))
%                     end
%                 else
%                     for ep = 1:length(Fields)
%                         plot(Data(Restrict(Projtsd1,EPOI.(Fields{ep}))),Data(Restrict(Projtsd2,EPOI.(Fields{ep}))),'.','MarkerSize',2,'color',cols(ep,:))
%                     end
%                 end
%                 if k==1
%                     title([num2str(100*EigVals(i)/sum(EigVals)) '%'])
%                 end
%                 axis tight
%                 
%             end
%             
%         end
%         legend(Fields)
%         
%         for i =1:3
%             for k = 1:3
%                 subplot(3,3,i+(k-1)*3)
%                 Projtsd1 = tsd(Range(Q),(EigVect(:,i)'*Qref')');
%                 Projtsd2 = tsd(Range(Q),(EigVect(:,k)'*Qref')');
%                 if k~=i
%                     for ep = 1:length(Fields)
%                         
%                         intdat_g=Data(Restrict(Projtsd1,EPOI.(Fields{ep})));
%                         intdat_t=Data(Restrict(Projtsd2,EPOI.(Fields{ep})));
%                         
%                         cent=[nanmean(intdat_g),nanmean(intdat_t)];
%                         distances=(intdat_g-cent(1)).^2/nanmean((intdat_g-cent(1)).^2)+(intdat_t-cent(2)).^2/nanmean((intdat_t-cent(2)).^2);
%                         dist=tsd(Range(Restrict(Q,EPOI.(Fields{ep}))),distances);
%                         threshold=percentile(distances,0.75);
%                         SubEpochC{ep}=thresholdIntervals(dist,threshold,'Direction','Below');
%                         
%                         intdat_g=Data(Restrict(Projtsd1,SubEpochC{ep}));
%                         intdat_t=Data(Restrict(Projtsd2,SubEpochC{ep}));
%                         K=convhull(intdat_g,intdat_t);
%                         hold on
%                         plot(intdat_g(K),intdat_t(K),'linewidth',3,'color',cols(ep,:))
%                         
%                     end
%                 end
%             end
%         end
%         saveas(2,[FolderName 'PCAFearStates',num2str(fg),'M_',num2str(mm),'.png'])
%         
%     end
    
    
    %% State by State PCA

    % Epoch of interest
    clear EPOI
    HomeCage = or(or(SessNames.SleepPost{1},SessNames.SleepPostSound{1}),or(SessNames.SleepPre{1},SessNames.SleepPreSound{1}));
    EPOI.HomeMov = and(SleepStates{1},HomeCage);
    
    EPOI.EPMOpen = and(SessNames.EPM{1},ZoneEpoch{1});
    EPOI.EPMClose = and(SessNames.EPM{1},ZoneEpoch{2});
    
    EPOI.EPM = SessNames.EPM{1};
    
    EPOI.SoundFz = and(SessNames.SoundTest{1},FreezeEpoch);
    EPOI.Sound = or(SessNames.SoundTest{1},SessNames.SoundCond{1});
    EPOI.SoundHab = SessNames.SoundHab{1};

    UMaze = SessNames.UMazeCond{1};
    for i = 2:length(SessNames.UMazeCond)
        UMaze = or(UMaze, SessNames.UMazeCond{i});
    end
    EPOI.UMazeHab = SessNames.Habituation{1};
    EPOI.UMazeMov = and(UMaze,MovEpoch);
    EPOI.UMazeMovSf = and(and(UMaze,MovEpoch),thresholdIntervals(LinPos,0.6,'Direction','Above'));
    EPOI.UMazeMovSk = and(and(UMaze,MovEpoch),thresholdIntervals(LinPos,0.4,'Direction','Below'));
    EPOI.UMazeFzSf = and(and(UMaze,FreezeEpoch),thresholdIntervals(LinPos,0.6,'Direction','Above'));
    EPOI.UMazeFzSk = and(and(UMaze,FreezeEpoch),thresholdIntervals(LinPos,0.4,'Direction','Below'));
    EPOI.AllUMaze = or(or(EPOI.UMazeFzSf,EPOI.UMazeFzSk),EPOI.UMazeMov);
    EPOI.UMazeFz = or(EPOI.UMazeFzSf,EPOI.UMazeFzSk);

    clf
    Fields = fieldnames(EPOI);
    cols = distinguishable_colors(length(Fields));
    subplot(121)
    clear EigVectState EigValsState
        Q = MakeQfromS(Spikes,Binsize);
    for ep =1:length(Fields)
        DataAmount(ep) = size(Data(Restrict(Q,EPOI.(Fields{ep})))',2);
    end
    
    for ep =1:length(Fields)
        Q = MakeQfromS(Spikes,Binsize);
        Q = Restrict(Q,EPOI.(Fields{ep})-NoiseEpoch);
        dattemp = zscore(full(Data(Q)))';
        
%         reorder = randperm(size(dattemp,2)); reorder = reorder(1:min(DataAmount));
%         dattemp = dattemp(:,reorder);
        [EigVectState{ep},EigValsState{ep}]=PerformPCA(dattemp);
        plot(cumsum(EigValsState{ep})/sum(EigValsState{ep}),'-','linewidth',3,'color',cols(ep,:))
        hold on
    end
    legend(Fields,'Location','SouthEast')
    set(gca,'FontSize',15,'linewidth',2)
    box off
    xlabel('PC number')
    ylabel('Var explained')
    AllMicePCA.EigValsStateByState{mm} = EigValsState;

    subplot(122)
    for ep =1:length(Fields)
        for ep2 =1:length(Fields)
            Q = MakeQfromS(Spikes,Binsize);
            Q = Restrict(Q,EPOI.(Fields{ep})-NoiseEpoch);
            dattemp = zscore(full(Data(Q)))';
            clear allfactPC allfact
            for f= 1:length(EigValsState{ep})
                allfactPC(f) = sum((EigVectState{ep2}(:,f)'*dattemp).^2);
            end
            VarExp(ep,ep2) = nansum(allfactPC(1:5))./nansum(allfactPC);
        end
    end
    AllMicePCA.VarExpBetweenStateByState{mm} = VarExp;
    
    for ep =1:length(Fields)
        VarExp(ep,:) = VarExp(ep,:)./nanmean(VarExp(ep,ep));
    end
    imagesc(VarExp)
    set(gca,'XTick',[1:length(Fields)],'XTickLabel',Fields,'YTick',[1:length(Fields)],'YTickLabel',Fields)
    axis xy
    xtickangle(45)
    xlabel('PCA target')
    ylabel('PCA source')
    title('Var expalined first 5 PCs')
    set(gca,'FontSize',11,'linewidth',2)
    colorbar
    
%     saveas(2,[FolderName 'PCAFearBetweenStates',num2str(fg),'M_',num2str(mm),'.png'])
    
    
end

ToUse = [1,7,8,3,2,5,10,11,12,13];

figure
clf
cols = distinguishable_colors(length(Fields));
subplot(121)
clear eigvals
xnew = [1:20]/20;
for ep =1:length(ToUse)
    for m = 1:7
        vals = AllMicePCA.EigValsStateByState{m}{ToUse(ep)};
        vals = cumsum(vals)/sum(vals);
        x=[1:length(AllMicePCA.EigValsStateByState{m}{ToUse(ep)})]/length(AllMicePCA.EigValsStateByState{m}{ToUse(ep)});
        eigvals(m,:) = 100*interp1(x,vals,xnew);
    end
    errorbar(xnew,mean(eigvals),stdError(eigvals),'linewidth',2,'color',cols(ep,:))
    hold on
        AllVals{ep}  = eigvals(:,10);

end
set(gca,'FontSize',15,'linewidth',2)
box off
xlabel('PC number - norm to 1')
ylabel('% Var expl')
ylim([0 100])
title('AllPCs')

subplot(122)
clear eigvals
xnew = [1:10];
for ep =1:length(ToUse)
    for m = 1:7
        vals = AllMicePCA.EigValsStateByState{m}{ToUse(ep)};
        vals = cumsum(vals(1:10))/sum(vals);
        eigvals(m,:) = 100*vals;
    end
    errorbar(xnew,mean(eigvals),stdError(eigvals),'linewidth',2,'color',cols(ep,:))
    AllVals{ep}  = eigvals(:,10);
    hold on
end
legend(Fields(ToUse),'Location','NorthWest')
set(gca,'FontSize',15,'linewidth',2)
box off
xlabel('PC number')
ylabel('% Var expl')
ylim([0 100])
title('First 10 PCs')

figure
PlotErrorBarN_KJ(AllVals)
set(gca,'XTick',[1:length(ToUse)],'XTickLabel',Fields(ToUse))
set(gca,'FontSize',15,'linewidth',2)
xtickangle(45)
ylabel('% Var explained by half of PCs')


%%

figure
clf
for m = 1:7
    VarExpTemp = AllMicePCA.VarExpBetweenStateByState{m};
for k =1:length(Fields)
        VarExpTemp(k,:) = VarExpTemp(k,:)./VarExpTemp(k,k);
    end
%         imagesc(VarExpTemp([1,2,3,6,7,4,5],[1,2,3,6,7,4,5]))

    VarExpAv(m,:,:) = VarExpTemp;
end

A = 100*(squeeze(nanmean(VarExpAv)));
imagesc(A(ToUse,ToUse))
set(gca,'XTick',[1:length(ToUse)],'XTickLabel',Fields(ToUse),'YTick',[1:length(ToUse)],'YTickLabel',Fields(ToUse))
axis xy
xlabel('PCA target')
ylabel('PCA source')
title('Var expalined first 5 PCs')
set(gca,'FontSize',15,'linewidth',2)
colorbar
xtickangle(45)
clim([45 70])

figure
clf
for k = 1:length(ToUse)
    subplot(3,3,k)
    PlotErrorBarN_KJ(100*squeeze(VarExpAv(:,ToUse(k),ToUse)),'newfig',0,'ShowSigstar','none')
    set(gca,'XTick',[1:length(ToUse)],'XTickLabel',Fields(ToUse))
    title(Fields(ToUse(k)))
    ylabel('% var explained norm')
    set(gca,'FontSize',11,'linewidth',2)
   xtickangle(45)
ylim([20 80])
line(xlim, [50 50])
end


