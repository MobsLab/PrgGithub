clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,514]; % 510,512 don't have tipples
GetUsefulDataRipplesReactivations_UMaze_SB

Binsize = 0.1*1e4;
SpeedLim = 2;

EpoName = {'Hab','Cond'};

for mm=1:length(MiceNumber)
    
    disp(num2str(MiceNumber(mm)))
    
    Ripples.Cond{mm} = ConcatenateDataFromFolders_BM(Dir{mm}.Cond,'ripples');
    
    Ripples.SleepPre{mm} = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPre,'ripples');
    SleepStates = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPre,'epoch','epochname','sleepstates');
    Ripples.SleepPre{mm} = Restrict(Ripples.SleepPre{mm},SleepStates{2});
    
    Ripples.SleepPost{mm} = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPost,'ripples');
    SleepStates = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPost,'epoch','epochname','sleepstates');
    Ripples.SleepPost{mm} = Restrict(Ripples.SleepPost{mm},SleepStates{2});
    
    Spikes{mm}.SleepPre = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPre,'spikes');
    cd(Dir{mm}.SleepPre{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
    Spikes{mm}.SleepPre = Spikes{mm}.SleepPre(numNeurons);
    
    
    Spikes{mm}.SleepPost = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPost,'spikes');
    cd(Dir{mm}.SleepPost{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
    Spikes{mm}.SleepPost = Spikes{mm}.SleepPost(numNeurons);
    
    for ep = 1:length(EpoName)
        
        Spikes{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'spikes');
        cd(Dir{mm}.(EpoName{ep}){1})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes{mm}.(EpoName{ep}) = Spikes{mm}.(EpoName{ep})(numNeurons);
        
        NoiseEpoch{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','noiseepochclosestims');
        FreezeEpoch{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','freezeepoch');
        StimEpoch{mm}.(EpoName{ep})= ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','stimepoch');
        
        LinPos{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'linearposition');
        Vtsd{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'speed');
        MovEpoch{mm}.(EpoName{ep}) = thresholdIntervals(Vtsd{mm}.(EpoName{ep}),SpeedLim,'Direction','Above');
        MovEpoch{mm}.(EpoName{ep}) = mergeCloseIntervals(MovEpoch{mm}.(EpoName{ep}),2*1e4);
        
        
        
    end
end



% Q = MakeQfromS(Spikes{mm}.(EpoName{2}),0.05*1e4);
% Q_temp = Data(Q);
% clear AllRip
% for spk = 1:min(size(Q))
%     
%     FR = tsd(Range(Q),Q_temp(:,spk));
%     Ep =  FreezeEpoch{mm}.(EpoName{2}) - NoiseEpoch{mm}.(EpoName{2});
%     [M,T] = PlotRipRaw(FR,Range(Restrict(Ripples{mm},Ep),'s'),1000,0,0);
%     AllRip(spk,:,:) = T;
% end


EpoName = {'Hab','Cond','SleepPre','SleepPost'};
CatRip = [];

for epo = 2:4
    num=1;
    for mm = 1:5
        
        numevts = [length(Ripples.(EpoName{2}){mm}),length(Ripples.(EpoName{3}){mm}),length(Ripples.(EpoName{4}){mm})];
        numevts = min(numevts);
        
        Q = MakeQfromS(Spikes{mm}.(EpoName{epo}),0.05*1e4);
        Q_temp = Data(Q);
        clear AllRip_1 AllRip_2
        for spk = 1:min(size(Q))
            
            FR = tsd(Range(Q),Q_temp(:,spk));
            Evts = Range(Ripples.(EpoName{epo}){mm},'s');
            [M,T] = PlotRipRaw(FR,Evts(1:2:end),1000,0,0);
            AllRip_1(spk,:,:) = T;
            
            [M,T] = PlotRipRaw(FR,Evts(2:2:end),1000,0,0);
            AllRip_2(spk,:,:) = T;
            
            CatRip(epo,num,:) = M(:,2);
            num=num+1;
        end
        Corr_temp = (corrcoef([zscore(squeeze(nanmean(AllRip_2,2))')',zscore(squeeze(nanmean(AllRip_1,2))')']));
        Reliab_Ripples(epo,mm,:,:) = Corr_temp(40:end,1:40);
        
    end
end

figure
for epo = 2:4
    subplot(2,3,epo-1)
    imagesc(M(:,1),M(:,1),squeeze(nanmean(Reliab_Ripples(epo,:,:,:),2)))
    title(EpoName{epo})
    caxis([-0.6 0.6])
    colormap(redblue)
    freezeColors
    makepretty
    xlabel('time to rip (s)')
    ylabel('time to rip (s)')
    axis square
    
    subplot(2,3,epo+2)
        Mat = zscore(squeeze(CatRip(3,:,:))')';
        [MatNew,ind]=SortMat(Mat,[18:22]);
    
    imagesc(M(:,1),1:260,runmean(zscore(squeeze(CatRip(epo,ind,:))'),2)')
    colormap(parula)
    caxis([-2 2])
    xlabel('time to rip (s)')
    ylabel('neuron number')
    makepretty
    
end


clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,514]; % 510,512 don't have tipples
GetUsefulDataRipplesReactivations_UMaze_SB

Binsize = 0.1*1e4;
SpeedLim = 2;

EpoName = {'Hab','Cond'};

for mm=1:length(MiceNumber)
    
    disp(num2str(MiceNumber(mm)))
    
    Ripples.Cond{mm} = ConcatenateDataFromFolders_BM(Dir{mm}.Cond,'ripples');
    
    Ripples.SleepPre{mm} = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPre,'ripples');
    SleepStates = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPre,'epoch','epochname','sleepstates');
    Ripples.SleepPre{mm} = Restrict(Ripples.SleepPre{mm},SleepStates{2});
    
    Ripples.SleepPost{mm} = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPost,'ripples');
    SleepStates = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPost,'epoch','epochname','sleepstates');
    Ripples.SleepPost{mm} = Restrict(Ripples.SleepPost{mm},SleepStates{2});
    
    Spikes{mm}.SleepPre = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPre,'spikes');
    cd(Dir{mm}.SleepPre{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
    Spikes{mm}.SleepPre = Spikes{mm}.SleepPre(numNeurons);
    
    
    Spikes{mm}.SleepPost = ConcatenateDataFromFolders_BM(Dir{mm}.SleepPost,'spikes');
    cd(Dir{mm}.SleepPost{1})
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
    Spikes{mm}.SleepPost = Spikes{mm}.SleepPost(numNeurons);
    
    for ep = 1:length(EpoName)
        
        Spikes{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'spikes');
        cd(Dir{mm}.(EpoName{ep}){1})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes{mm}.(EpoName{ep}) = Spikes{mm}.(EpoName{ep})(numNeurons);
        
        NoiseEpoch{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','noiseepochclosestims');
        FreezeEpoch{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','freezeepoch');
        StimEpoch{mm}.(EpoName{ep})= ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','stimepoch');
        
        LinPos{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'linearposition');
        Vtsd{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'speed');
        MovEpoch{mm}.(EpoName{ep}) = thresholdIntervals(Vtsd{mm}.(EpoName{ep}),SpeedLim,'Direction','Above');
        MovEpoch{mm}.(EpoName{ep}) = mergeCloseIntervals(MovEpoch{mm}.(EpoName{ep}),2*1e4);
        
        
        
    end
end


%%%%
% How reliable is the activity we're using as a template
figure
for mm=1:length(MiceNumber)
    
    Q = MakeQfromS(Spikes{mm}.(EpoName{2}),0.05*1e4);
    Q_temp = Data(Q);
    clear AllRip1 AllRip2
    for spk = 1:min(size(Q))
        
        FR = tsd(Range(Q),Q_temp(:,spk));
        Ep =  FreezeEpoch{mm}.(EpoName{2}) - NoiseEpoch{mm}.(EpoName{2});
        Evts = Range(Restrict(Ripples.Cond{mm},Ep),'s');
        [M,T] = PlotRipRaw(FR,Evts(1:2:end),1000,0,0);
        % Z score each event
        T =  ZScoreWiWindowSB(T,[1:15]);
        AllRip1(spk,:,:) = T(:,10:30);
        
        [M,T] = PlotRipRaw(FR,Evts(2:2:end),1000,0,0);
        % Z score each event
        T =  ZScoreWiWindowSB(T,[1:15]);
        AllRip2(spk,:,:) = T(:,10:30);
        
        
    end
    
    clear varexpl varexpl_CV
    [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(AllRip1(1:end,:)',1);
    for i = 1:size(eigenvectors,1)
        varexpl(i) = var(zscore(AllRip1(1:end,:)')*eigenvectors(:,i));
    end
    for i = 1:size(eigenvectors,1)
        varexpl_CV(i) = var(zscore(AllRip2(1:end,:)')*eigenvectors(:,i));
    end
    subplot(2,3,mm)
    plot(100*(varexpl)/sum(var(zscore(AllRip1(1:end,:)'))),'.-')
    hold on
    plot(100*(varexpl_CV)/sum(var(zscore(AllRip2(1:end,:)'))),'.-')
    set(gca,'XScale','log')
    line([1 1]*sum(eigenvalues>lambdaMax)+0.5,ylim)
    makepretty
    legend('Ref','CV')
    xlabel('"#eigenvect')
    ylabel('% Var expl')
    title(num2str(MiceNumber(mm)))
end


% How reliable is the activity we're using as a template
figure
for mm=1:length(MiceNumber)
    
    Q = MakeQfromS(Spikes{mm}.(EpoName{3}),0.05*1e4);
    Q_temp = Data(Q);
    clear AllRip1 AllRip2
    for spk = 1:min(size(Q))
        
        FR = tsd(Range(Q),Q_temp(:,spk));
        Evts = Range((Ripples.SleepPre{mm}),'s');
        [M,T] = PlotRipRaw(FR,Evts(1:2:end),1000,0,0);
        % Z score each event
        T =  ZScoreWiWindowSB(T,[1:15]);
        AllRip1(spk,:,:) = T(:,10:30);
        
        [M,T] = PlotRipRaw(FR,Evts(2:2:end),1000,0,0);
        % Z score each event
        T =  ZScoreWiWindowSB(T,[1:15]);
        AllRip2(spk,:,:) = T(:,10:30);
        
        
    end
    
    clear varexpl varexpl_CV
    [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(AllRip1(1:end,:)',1);
    for i = 1:size(eigenvectors,1)
        varexpl(i) = var(zscore(AllRip1(1:end,:)')*eigenvectors(:,i));
    end
    for i = 1:size(eigenvectors,1)
        varexpl_CV(i) = var(zscore(AllRip2(1:end,:)')*eigenvectors(:,i));
    end
    subplot(2,3,mm)
    plot(100*(varexpl)/sum(var(zscore(AllRip1(1:end,:)'))),'.-')
    hold on
    plot(100*(varexpl_CV)/sum(var(zscore(AllRip2(1:end,:)'))),'.-')
    set(gca,'XScale','log')
    line([1 1]*sum(eigenvalues>lambdaMax)+0.5,ylim)
    makepretty
    legend('Ref','CV')
    xlabel('"#eigenvect')
    ylabel('% Var expl')
    title(num2str(MiceNumber(mm)))
end