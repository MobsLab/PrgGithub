% 'SoundHab' 'SoundCond' 'SoundTest' 'SoundTestPlethysmo'

Sessions = {'SoundHab' ,'SoundTest', 'SoundTestPlethysmo'};

for ss = 2 :length(Sessions)
    
    Dir=PathForExperimentsMtzlProject(Sessions{ss})
    
    for d = 1:length(Dir.path)
        clf
        cd(Dir.path{d}{1})
        disp(Dir.path{d}{1})
        
        load('behavResources.mat')
        TotEpoch = intervalSet(0,max(Range(MovAcctsd)));
        
        subplot(5,5,1:4)
        load('H_Low_Spectrum.mat')
        imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy
        sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
        line([Start((FreezeAccEpoch),'s') Stop((FreezeAccEpoch),'s')]',[Stop((FreezeAccEpoch),'s')*0 Stop((FreezeAccEpoch),'s')*0]'+18,'color','c','linewidth',3)
        hold on
        plot(Start(mergeCloseIntervals(TTLInfo.CSplus,10e4),'s'),15,'r*')
        plot(Start(mergeCloseIntervals(TTLInfo.CSMinus,10e4),'s'),15,'g*')
        title('HPC')
        subplot(5,5,5)
        plot(Spectro{3},nanmean(log(Data(Restrict(sptsd,FreezeAccEpoch)))),'b'), hold on
        plot(Spectro{3},nanmean(log(Data(Restrict(sptsd,TotEpoch-FreezeAccEpoch)))),'r')
        legend('Fz','NoFz')
        
        try
        subplot(5,5,6:9)
        load('PFCx_Low_Spectrum.mat')
        imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy
        sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
        line([Start((FreezeAccEpoch),'s') Stop((FreezeAccEpoch),'s')]',[Stop((FreezeAccEpoch),'s')*0 Stop((FreezeAccEpoch),'s')*0]'+18,'color','c','linewidth',3)
        hold on
        plot(Start(mergeCloseIntervals(TTLInfo.CSplus,10e4),'s'),15,'ro')
        plot(Start(mergeCloseIntervals(TTLInfo.CSMinus,10e4),'s'),15,'go')
        title('PFC')
        subplot(5,5,10)
        plot(Spectro{3},nanmean(log(Data(Restrict(sptsd,FreezeAccEpoch)))),'b'), hold on
        plot(Spectro{3},nanmean(log(Data(Restrict(sptsd,TotEpoch-FreezeAccEpoch)))),'r')
        end
        
        subplot(5,5,11:14)
        load('B_Low_Spectrum.mat')
        imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy
        sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
        line([Start((FreezeAccEpoch),'s') Stop((FreezeAccEpoch),'s')]',[Stop((FreezeAccEpoch),'s')*0 Stop((FreezeAccEpoch),'s')*0]'+18,'color','c','linewidth',3)
        hold on
        plot(Start(mergeCloseIntervals(TTLInfo.CSplus,10e4),'s'),15,'r*')
        plot(Start(mergeCloseIntervals(TTLInfo.CSMinus,10e4),'s'),15,'g*')
        title('OB')
        subplot(5,5,15)
        plot(Spectro{3},nanmean(log(Data(Restrict(sptsd,FreezeAccEpoch)))),'b'), hold on
        plot(Spectro{3},nanmean(log(Data(Restrict(sptsd,TotEpoch-FreezeAccEpoch)))),'r')
        
        if exist('ChannelsToAnalyse/Respi.mat')>0
            subplot(5,5,16:19)
            load('Respi_Low_Spectrum.mat')
            imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy
            hold on
            load('BreathingInfo.mat')
            plot(Range(Frequecytsd,'s'),Data(Frequecytsd),'k:')
            sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
            line([Start((FreezeAccEpoch),'s') Stop((FreezeAccEpoch),'s')]',[Stop((FreezeAccEpoch),'s')*0 Stop((FreezeAccEpoch),'s')*0]'+18,'color','c','linewidth',3)
            hold on
            plot(Start(mergeCloseIntervals(TTLInfo.CSplus,10e4),'s'),15,'r*')
            plot(Start(mergeCloseIntervals(TTLInfo.CSMinus,10e4),'s'),15,'g*')
            title('breath')
            subplot(5,5,20)
            plot(Spectro{3},nanmean(log(Data(Restrict(sptsd,FreezeAccEpoch)))),'b'), hold on
            plot(Spectro{3},nanmean(log(Data(Restrict(sptsd,TotEpoch-FreezeAccEpoch)))),'r')
            
            subplot(5,5,21:24)
            load('Respi_B_Low_Coherence.mat')
            imagesc(Coherence{2},Coherence{3},(Coherence{1}')), axis xy
            sptsd=tsd(Coherence{2}*1e4,(Coherence{1}));
            line([Start((FreezeAccEpoch),'s') Stop((FreezeAccEpoch),'s')]',[Stop((FreezeAccEpoch),'s')*0 Stop((FreezeAccEpoch),'s')*0]'+18,'color','c','linewidth',3)
            hold on
            plot(Start(mergeCloseIntervals(TTLInfo.CSplus,10e4),'s'),15,'r*')
            plot(Start(mergeCloseIntervals(TTLInfo.CSMinus,10e4),'s'),15,'g*')
            title('OB/breath coh')
            subplot(5,5,25)
            plot(Spectro{3},nanmean((Data(Restrict(sptsd,FreezeAccEpoch)))),'b'), hold on
            plot(Spectro{3},nanmean((Data(Restrict(sptsd,TotEpoch-FreezeAccEpoch)))),'r')
            
        end
        saveas(1,'OverviewAllSpec.fig')
        saveas(1,'OverviewAllSpec.png')
        
    end
    
end
