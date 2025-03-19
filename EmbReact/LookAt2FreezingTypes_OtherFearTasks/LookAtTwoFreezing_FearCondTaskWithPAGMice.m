Dir=PathForExperimentsEmbReact('SoundTest');

%% Look at the freezing parameters

for mm = 1: length(Dir.path)
    
    
    %% Go to file location
    disp(Dir.path{mm}{1})
    cd(Dir.path{mm}{1})
    clear Spec_H Spec_B FreqBand NewMat TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch FreqBand
    clear Movtsd MovAcctsd
    
    % Epochs
    load('behavResources_SB.mat')
    if not(isempty(Behav.FreezeAccEpoch))
        FreezeEpoch=Behav.FreezeAccEpoch;
    end
    FreezeEpoch = Behav.FreezeEpoch;
    
    load('InstFreqAndPhase_B.mat')
    OBFreq = LocalFreq;
    
    load('InstFreqAndPhase_H.mat')
    HPCFreq = LocalFreq;
    
    try
        load('Ripples.mat')
        [Y,X] = hist(Start(RipplesEpochR,'s'),Range(OBFreq.PT,'s'));
        Riptsd = tsd(Range(OBFreq.PT),Y');
    catch
        Riptsd = tsd(0,0);
        
    end
    
    figure
    subplot(411)
    plot(movmedian(Data((OBFreq.PT)),10))
    yyaxis right
    bar(movmean(Data((Riptsd)),10))
    ylim([0 0.5])
    
    subplot(412)
    load('B_Low_Spectrum.mat')
    OB_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
    imagesc(Range((OB_Sptsd),'s'),Spectro{3},log(Data((OB_Sptsd))')), axis xy
    grid minor
    subplot(413)
    try
        load('H_Low_Spectrum.mat')
    catch
        load('ChannelsToAnalyse/dHPC_rip.mat')
        LowSpectrumSB([cd filesep],channel,'H')
        load('H_Low_Spectrum.mat')
        
    end
    
    HPC_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
    imagesc(Range((HPC_Sptsd),'s'),Spectro{3},log(Data((HPC_Sptsd))')), axis xy
    grid minor
    SpLow = Spectro{3};
    subplot(414)
    try
    plot(Data((Behav.MovAcctsd)))
    catch
       plot(Data((Behav.Imdifftsd)))
    end
    
    
    
    
    figure
    subplot(2,2,1)
    imagesc(SpLow,SpLow,corr(log(Data(Restrict(OB_Sptsd,FreezeEpoch))),log(Data(Restrict(OB_Sptsd,FreezeEpoch)))))
    axis square
    axis xy
    xlim([0 15]),ylim([0 15])
    subplot(2,2,2)
    imagesc(SpLow,SpLow,corr(log(Data(Restrict(HPC_Sptsd,FreezeEpoch))),log(Data(Restrict(HPC_Sptsd,FreezeEpoch)))))
    axis square
    axis xy
    xlim([0 15]),ylim([0 15])
    subplot(2,2,3)
    imagesc(SpLow,SpLow,corr(log(Data(Restrict(OB_Sptsd,FreezeEpoch))),log(Data(Restrict(HPC_Sptsd,FreezeEpoch)))))
    axis square
    axis xy
    xlim([0 15]),ylim([0 15])
    
    
    
    
end