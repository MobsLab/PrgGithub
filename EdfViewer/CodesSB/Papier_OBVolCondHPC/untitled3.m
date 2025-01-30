HPCOrderChans={[123 109 110 111 119 120 106 107 108 116 121 103 104 105 117],...
    [59 45 46 47 55 56 42 43 44 52 57 39 40],...
    [61 50 60 34 35 48 51 62 63 33 30 32],...
    [26 27 24 12 3 2 28 29 14 13 0 1 31 15 49],...
    [5 19 16 17 9 6 20 21 18 10 7 25 22 23 11],...
    [101 102 114 125 124 98 99 112 115 126 127 97 94 96],...
    [90 91 88 76 67 66 92 93 78 77 64 65 95 79 113 ],...
    [69 83 80 81 73 70 84 85 82 74 71 89 86 87 75 ]};


load('Epochs.mat')
for shanknum = 1:length(HPCOrderChans)
    
    for c=1:length(HPCOrderChans{shanknum})
        chan2=HPCOrderChans{shanknum}(c);
        load([SaveFolder 'Spectro_HPC',num2str(chan2),'.mat'],'Sp','t','f')
        Sptsd=tsd(t*1E4,Sp);
        AllSpec(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllSpecMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
    end
    
    for c=1:length(HPCOrderChans{shanknum})
        chan2=HPCOrderChans{shanknum}(c);
        load(['Cohgram_OB_HPC',num2str(chan2),'.mat'])
        Sptsd=tsd(t*1E4,C);
        AllCohOB(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllCohOBMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
        
    end
    
    
    for el=1:length(HPCOrderChans{shanknum})-1
        load(['Cohgram_OB_HPCDiff_Sk',num2str(shanknum),'_El',num2str(el),'.mat'])
        Sptsd=tsd(t*1E4,C);
        AllCohDiffOB(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllCohDiffOBMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
    end
    
    for el=1:length(HPCOrderChans{shanknum})-2
        load(['Cohgram_OB_HPCCSD_Sk',num2str(shanknum),'_El',num2str(el),'.mat'])
        Sptsd=tsd(t*1E4,C);
        AllCohCSDOB(c,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        AllCohCSDOBMov(c,:)=mean(Data(Restrict(Sptsd,RunEpoch)));
    end
    figure
    subplot(241)
    imagesc(f,[1:size(AllCohOBMov,1)],AllSpecMov)
    title('HPC Spec')
    xlabel('Frequency (Hz)')
    subplot(242)
    
    imagesc(f,[1:size(AllCohOBMov,1)],AllCohOBMov),clim([0.4 0.6])
    title('Coh LFP HPC / LFP OB')
    xlabel('Frequency (Hz)')
    subplot(243)
    imagesc(f,[1:size(AllCohDiffOBMov,1)],AllCohDiffOBMov),clim([0.4 0.7])
    title('Coh CSD HPC / LFP OB')
    xlabel('Frequency (Hz)')
    subplot(244)
    imagesc(f,[1:size(AllCohCSDOBMov,1)],AllCohCSDOBMov),clim([0.4 0.7])
    title('Coh CSD HPC / LFP OB')
    xlabel('Frequency (Hz)')
    
    subplot(245)
    imagesc(f,[1:size(AllCohOBMov,1)],AllSpec)
    title('HPC Spec')
    xlabel('Frequency (Hz)')
    subplot(246)
    imagesc(f,[1:size(AllCohOB,1)],AllCohOB),clim([0.4 0.6])
    title('Coh LFP HPC / LFP OB')
    xlabel('Frequency (Hz)')
    subplot(247)
    imagesc(f,[1:size(AllCohDiffOB,1)],AllCohDiffOB),clim([0.4 0.7])
    title('Coh CSD HPC / LFP OB')
    xlabel('Frequency (Hz)')
    subplot(247)
    imagesc(f,[1:size(AllCohCSDOB,1)],AllCohCSDOB),clim([0.4 0.7])
    title('Coh CSD HPC / LFP OB')
    xlabel('Frequency (Hz)')
    
end
