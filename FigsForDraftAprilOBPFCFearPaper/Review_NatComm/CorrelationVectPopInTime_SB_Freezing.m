clear all

Dir.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150506-EXT-24h-envC\20150506-EXT-24h-envC';
Dir.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse253_20150703-EXT-24h-envC_FEAR-Mouse-253-03072015\FEAR-Mouse-253-03072015';
Dir.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse254_20150703-EXT-24h-envC\20150703-EXT-24h-envC';
Dir.path{4} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse258_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{5} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse259_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{6} = 'D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse299_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
Dir.path{7} = 'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse394_FEAR-Mouse-394-EXT-24-envBraye_161020_163239_\FEAR-Mouse-394-EXT-24-envBraye_161020_163239';
Dir.path{8} = 'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse395_FEAR-Mouse-395-EXT-24-envBraye_161020_155350_\FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
Dir.path{9} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse402_FEAR-Mouse-402-EXT-24-envB_raye_161026_164106_\FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
Dir.path{10} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse403_FEAR-Mouse-403-EXT-24-envB_raye_161026_171611_\FEAR-Mouse-403-EXT-24-envB_raye_161026_171611';
Dir.path{11} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse450_FEAR-Mouse-450-EXT-24-envB_161026_174952_\FEAR-Mouse-450-EXT-24-envB_161026_174952';
Dir.path{12} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse451_FEAR-Mouse-451-EXT-24-envB_161026_182307_\FEAR-Mouse-451-EXT-24-envB_161026_182307';
Dir.path{13} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse248_20150326-EXT-24h-envC\20150326-EXT-24h-envC';

DirB.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse291_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
DirB.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse297_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
DirB.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse298_20151217-EXT-24h-envC\20151217-EXT-24h-envC';


tps=[0.05:0.05:1];
timeatTransition=3;


for mm = 1:length(Dir.path)
    cd(Dir.path{mm})
    
    
    clear FreezeAccEpoch FreezeEpoch LFP FilLFP S AllPeaks
    load('filteredLFP\MiniMaxiLFPOB1.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    FilLFP = FilterLFP(LFP,[1 20],1024);
    DatLFP = Data(FilLFP);
    tpsLFP = Range(FilLFP);
    load('behavResources.mat')
    if exist('FreezeAccEpoch')
        FreezeEpoch = FreezeAccEpoch;
    end
    load('NeuronLFPCoupling_OB4HzPaper\AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')

    
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    FreezeEpoch=and(FreezeEpoch,TotEpoch);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,5*1e4);
    %     FreezeEpoch=dropLongIntervals(FreezeEpoch,10*1e4);
    FreezeEpochBis=FreezeEpoch;
    
    % keep only well separated epochs
    for fr_ep=1:length(Start(FreezeEpoch))
        LitEp=subset(FreezeEpoch,fr_ep);
        NotLitEp=FreezeEpoch-LitEp;
        StopEp=intervalSet(Stop(LitEp)-timeatTransition*1e4,Stop(LitEp)+timeatTransition*1e4);
        if not(isempty(Data(Restrict(Movtsd,and(NotLitEp,StopEp)))))
            FreezeEpochBis=FreezeEpochBis-LitEp;
        end
    end
    FreezeEpoch=CleanUpEpoch(FreezeEpochBis);
    
    load('SpikeData.mat')
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
    S = S(numNeurons);


    Q = MakeQfromS(S,0.2*1E4);
    DatQ = Data(Q);
    Q = tsd(Range(Q),zscore(DatQ));
    
    clear MatStart
    for k = 1:length(Start(FreezeEpoch))-1
        LitEp = subset(FreezeEpoch,k);
        LitEp = intervalSet(Start(LitEp)-3*1E4,Start(LitEp));
        LitDat = Data(Restrict(Q,LitEp));
        LitDatBeg  = LitDat(end-13:end,:);
        
        LitEp = subset(FreezeEpoch,k);
        LitEp = intervalSet(Start(LitEp),Start(LitEp)+3*1E4);
        LitDat = Data(Restrict(Q,LitEp));
        LitDatEnd  = LitDat(1:14,:);
        
        MatStart(k,:,:) = full(corr([LitDatBeg;LitDatEnd]'));
    end
    
    clear MatStop
    for k = 1:length(Start(FreezeEpoch))-1
        LitEp = subset(FreezeEpoch,k);
        LitEp = intervalSet(Stop(LitEp)-3*1E4,Stop(LitEp));
        LitDat = Data(Restrict(Q,LitEp));
        LitDatBeg  = LitDat(end-13:end,:);
        
        LitEp = subset(FreezeEpoch,k);
        LitEp = intervalSet(Stop(LitEp),Stop(LitEp)+3*1E4);
        LitDat = Data(Restrict(Q,LitEp));
        LitDatEnd  = LitDat(1:14,:);
        
        MatStop(k,:,:) = full(corr([LitDatBeg;LitDatEnd]'));
    end
    
    
    %% Look at Normalized periods
    
    for k = 1:length(Start(FreezeEpoch))-1
        ActualEpoch = subset(FreezeEpoch,k);
        
        % define epoch
        timebef = 4; % now use 5s always
        % timebef=Dur{m}(ep)*timebefprop; % period before and after is 30% acutal period
        LittleEpoch=intervalSet(Start(ActualEpoch),Stop(ActualEpoch));
        LittleEpochPre=intervalSet(Start(ActualEpoch)-timebef*1e4,Start(ActualEpoch));
        LittleEpochPost=intervalSet(Stop(ActualEpoch),Stop(ActualEpoch)+timebef*1e4);
        
        TempData = full(Data(Restrict(Q,LittleEpoch)));
        TempData = interp1([1/size(TempData,1):1/size(TempData,1):1],TempData,tps);
        
        TempDataPre=full(Data(Restrict(Q,LittleEpochPre)));
        TempDataPre = interp1([1/size(TempDataPre,1):1/size(TempDataPre,1):1],TempDataPre,[0.1:0.1:1]);
        
        TempDataPost=full(Data(Restrict(Q,LittleEpochPost)));
        TempDataPost = interp1([1/size(TempDataPost,1):1/size(TempDataPost,1):1],TempDataPost,[0.1:0.1:1]);
        
        CorrRem(k,:,:) = corr([TempDataPre',TempData',TempDataPost']);
    end
    
    save(['CorrMatFzStartFzStop.mat'],'MatStart','MatStop','CorrRem')
    clear MatStart MatStop CorrRem
end

for mm = 1:length(Dir.path)
    cd(Dir.path{mm})
    
    load(['CorrMatFzStartFzStop.mat'],'MatStart','MatStop','CorrRem')
    MatStartAll(mm,:,:) = squeeze(nanmean(MatStart,1));
    MatStopAll(mm,:,:) = squeeze(nanmean(MatStop,1));
    CorrRemAll(mm,:,:) = squeeze(nanmean(CorrRem,1));
    
end

subplot(131)
A = squeeze(nanmean(MatStartAll,1));
A (1:1+size(A,1):end) = NaN;
imagesc([-3:0.1:3],[-3:0.1:3],A)
line(xlim,[0 0],'color','k')
line([0 0],ylim,'color','k')
line([0 3],[2.8 2.8],'color','c','linewidth',5)
axis square, axis xy
caxis([-0.08 0.3])
xlabel('Time to freeze start')


subplot(132)
A = squeeze(nanmean(MatStopAll,1));
A (1:1+size(A,1):end) = NaN;
imagesc([-3:0.1:3],[-3:0.1:3],A)
line(xlim,[0 0],'color','k')
line([0 0],ylim,'color','k')
axis square, axis xy
line([-3 0],[2.8 2.8],'color','c','linewidth',5)
caxis([-0.08 0.3])
xlabel('Time to freeze stop')

subplot(133)
A = squeeze(nanmean(CorrRemAll,1));
A (1:1+size(A,1):end) = NaN;
imagesc(A)
set(gca,'XTick',[10 30],'YTick',[10 30],'XTickLabel',{'0','1'},'YTickLabel',{'0','1'})
axis square, axis xy
line([10 30],[40 40],'color','c','linewidth',5)
line([10 10],ylim,'color','k')
line(xlim,[10 10],'color','k')
line([30 30],ylim,'color','k')
line(xlim,[30 30],'color','k')
caxis([-0.08 0.3])
xlabel('Norm freezing episode (0-1)')