clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,514]; % 510,512 don't have tipples
GetUsefulDataRipplesReactivations_UMaze_SB

Binsize = 0.1*1e4;
SpeedLim = 2;

EpoName = {'Hab','Cond','TestPost'};
SaveFig = '/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/';
timebin = [0.01,0.05,0.1,0.2]; % in s
RipEpoch = {'Cond','SleepPre','SleepPost'};


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

cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
save('AllRippleInfo_DiffEpochs.mat','Ripples','Spikes')
figure
for rr = 1:length(RipEpoch)
    
    BinSize=0.05;
    clear RipRespP_Pre RipRespP_Post RipRespS_Post RipRespS_Pre
    for mm = 1:5
        
        %% Ripples
        if rr == 1
            StimEpochToRemove = intervalSet(Start(StimEpoch{mm}.Cond),Start(StimEpoch{mm}.Cond)+0.2*1e4);
            Ripples_Sf = Restrict(Ripples.(RipEpoch{rr}){mm},thresholdIntervals(LinPos{mm}.Cond,0.6,'Direction','Above'));
        else
            Ripples_Sf = Ripples.(RipEpoch{rr}){mm};
        end
        
        Ripples_Sf = intervalSet(Range(Ripples_Sf),Range(Ripples_Sf)+0.1*1e4);
        Ripples_Sf = mergeCloseIntervals(Ripples_Sf,1*1e4);
        Evts = Start(Ripples_Sf,'s');
        
        %% After stim
        Q = MakeQfromS(Spikes{mm}.Cond,BinSize*1e4);
        Q = tsd(Range(Q),nanzscore(Data(Q)));
        
        PostStim=intervalSet(Start(StimEpoch{mm}.Cond)+0.1*1e4,Start(StimEpoch{mm}.Cond)+1*1e4);
        StimData = (Data(Restrict(Q,PostStim)));
        [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(StimData,1);
        
        
        clear proj_temp
        Q = MakeQfromS(Spikes{mm}.(RipEpoch{rr}),BinSize*1e4);
        Q = tsd(Range(Q),nanzscore(Data(Q)));
        strength_temp = ReactivationStrength_SB((Data(Q)),templates);
        
        for e =  1: size(eigenvectors,2)
            proj_temp(:,e) = (Data(Q))*eigenvectors(:,e);
        end
        
        for comp = 1:3
            strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
            proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
            
            [M,T] = PlotRipRaw(strength_temp_tsd,Evts,1000,0,0);
            RipRespS_Post{mm}(comp,:) = M(:,2);
            
            [M,T] = PlotRipRaw(proj_temp_tsd,Evts,1000,0,0);
            RipRespP_Post{mm}(comp,:) = M(:,2);
            
            SafeProj{mm}(comp) = nanmean(Data(Restrict(proj_temp_tsd,AllSafe)));
            SafeProjNoRip{mm}(comp) = nanmean(Data(Restrict(proj_temp_tsd,AllSafe-RipplePer)));
            SafeProjRip{mm}(comp) = nanmean(Data(Restrict(proj_temp_tsd,and(AllSafe,RipplePer))));
            SlProj{mm}(comp) = nanmean(Data(Restrict(proj_temp_tsd,AllShk)));
            
            
        end
        
        
        %% Pre Stim
        Q = MakeQfromS(Spikes{mm}.Cond,BinSize*1e4);
        Q = tsd(Range(Q),nanzscore(Data(Q)));
        
        PreStim=intervalSet(Start(StimEpoch{mm}.Cond)-2*1e4,Start(StimEpoch{mm}.Cond)-1*1e4)-PostStim;
        StimData = (Data(Restrict(Q,PreStim)));
        [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(StimData,1);       
        clear proj_temp
        
        Q = MakeQfromS(Spikes{mm}.(RipEpoch{rr}),BinSize*1e4);
        Q = tsd(Range(Q),nanzscore(Data(Q)));
        strength_temp = ReactivationStrength_SB((Data(Q)),templates);
        
        for e =  1: size(eigenvectors,2)
            proj_temp(:,e) = (Data(Q))*eigenvectors(:,e);
        end
        
        % Ripples
        
        for comp = 1:3
            strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
            proj_temp_tsd = tsd(Range(Q),proj_temp(:,comp));
            
            [M,T] = PlotRipRaw(strength_temp_tsd,Evts,1000,0,0);
            RipRespS_Pre{mm}(comp,:) = M(:,2);
            
            [M,T] = PlotRipRaw(proj_temp_tsd,Evts,1000,0,0);
            RipRespP_Pre{mm}(comp,:) = M(:,2);
        end
        
    end
    
    subplot(2,3,rr)
    AllRippleProj = [];
    AllRippleProjPre = [];
    for mm = 1:5
        AllRippleProj = [AllRippleProj;(RipRespP_Post{mm}')'];
        AllRippleProjPre = [AllRippleProjPre;(RipRespP_Pre{mm}')'];
    end
    errorbar(M(:,1),nanmean(AllRippleProjPre),stdError(AllRippleProjPre),'k')
    hold on
    errorbar(M(:,1),nanmean(AllRippleProj),stdError(AllRippleProj),'r')
    ylim([0 1.5])
    makepretty
    xlabel('time to rip (s)')
    
    subplot(2,3,rr+3)
    AllRippleProj = [];
    AllRippleProjPre = [];
    for mm = 1:5
        AllRippleProj = [AllRippleProj;(RipRespS_Post{mm}')'];
        AllRippleProjPre = [AllRippleProjPre;(RipRespS_Pre{mm}')'];
    end
    errorbar(M(:,1),nanmean(AllRippleProjPre),stdError(AllRippleProjPre),'k')
    hold on
    errorbar(M(:,1),nanmean(AllRippleProj),stdError(AllRippleProj),'r')
    ylim([0 2.5])
    xlabel('time to rip (s)')
    makepretty
end
