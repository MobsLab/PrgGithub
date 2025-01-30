clear all, close all
AllSlScoringMice;


%Sleep Scoring Using Olfactory Bulb and Hippocampal LFP
for mm=1:m
    %     try
    cd(filename2{mm})
    tic
    %% Step 1 - channels to use and 2 spectra
    close all
    filename=cd;
    if filename(end)~='/'
        filename(end+1)='/';
    end
    scrsz = get(0,'ScreenSize');
    chB=load('StateEpochSB.mat','chB');chB=chB.chB;
    load(['LFPData/LFP',num2str(chB),'.mat']);
    LFP;
    
    r=Range(LFP);
    TotalEpoch=intervalSet(0*1e4,r(end));
    mindur=3; %abs cut off for events;
    ThetaI=[3 3]; %merge and drop
    mw_dur=5; %max length of microarousal
    sl_dur=15; %min duration of sleep around microarousal
    ms_dur=10; % max length of microsleep
    wa_dur=20; %min duration of wake around microsleep
    
    if exist('B_LowExt_Spectrum.mat')==0
        LowSpectrumSB_extended(filename,chB,'B');
        disp('Bulb Spectrum done')
    end
    ThreshEpoch=TotalEpoch;
    
    
    
    load StateEpochSB Epoch
    Epoch;
    
    TotalEpoch=and(TotalEpoch,Epoch);
    TotalEpoch=CleanUpEpoch(TotalEpoch);
    ThreshEpoch=and(ThreshEpoch,Epoch);
    ThreshEpoch=CleanUpEpoch(ThreshEpoch);
    close all;
    save('StateEpochSBAllOB_Bis.mat','chB')
    
    Find1525Epoch(ThreshEpoch,ThetaI,chB,filename);
    
    close all;
    
    %% Step 3 - Behavioural Epochs
    FindBehavEpochsAllOB1525(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename)
%     
%     %% Step 4 - Sleep scoring figure
%     PlotEp=TotalEpoch;
%     
%     SleepScoreFigureAllOB(filename,PlotEp)
%     toc
%     %     load('StateEpochSBAllOB','REMEpoch');REMEpoch1=REMEpoch;
    %     load('StateEpochSB','REMEpoch','smooth_ghi');
    %     a=size(Data(Restrict(smooth_ghi,REMEpoch1)),1);
    %     b=size(Data(Restrict(smooth_ghi,and(REMEpoch1,REMEpoch))),1); %SS
    %     Ratio(mm)=b/a;
    %
    %     catch
    %        disp([num2str(mm) 'failed'])
    %     end
end


for mm=1:m
    cd(filename2{mm})
        load('StateEpochSBAllOB','REMEpoch','SWSEpoch','smooth_1015');REMEpoch1=REMEpoch;SWSEpoch1=SWSEpoch;
        load('StateEpochSB','REMEpoch','Sleep','SWSEpoch');
        a=size(Data(Restrict(smooth_1015,REMEpoch)),1);
        b=size(Data(Restrict(smooth_1015,and(REMEpoch1,REMEpoch))),1);
        Ratio(mm,1)=b/a;
        a=size(Data(Restrict(smooth_1015,SWSEpoch)),1);
        b=size(Data(Restrict(smooth_1015,and(SWSEpoch,SWSEpoch1))),1);
        Ratio(mm,2)=b/a;
        [Y{mm},X{mm}]=hist(log(Data(Restrict(smooth_1015,Sleep))),100)
end

clear Ratio a b X Y
for mm=1:m
    cd(filename2{mm})
        load('StateEpochSBAllOB_Bis','REMEpoch','SWSEpoch','smooth_1015');REMEpoch1=REMEpoch;SWSEpoch1=SWSEpoch;
        load('StateEpochSB','REMEpoch','Sleep','SWSEpoch');
        a=size(Data(Restrict(smooth_1015,REMEpoch)),1);
        b=size(Data(Restrict(smooth_1015,and(REMEpoch1,REMEpoch))),1);
        Ratio(mm,1)=b/a;
        a=size(Data(Restrict(smooth_1015,SWSEpoch)),1);
        b=size(Data(Restrict(smooth_1015,and(SWSEpoch,SWSEpoch1))),1);
        Ratio(mm,2)=b/a;
                [Y{mm},X{mm}]=hist(log(Data(Restrict(smooth_1015,Sleep))),100)

end


for mm=3:m
    cd(filename2{mm})
    try
        load('ChannelsToAnalyse/dHPC_deep.mat')
        chH=channel;
    catch
        try
            load('ChannelsToAnalyse/dHPC_rip.mat')
            chH=channel;
        catch
            chH=input('please give hippocampus channel for theta ');
        end
    end
    VeryHighSpectrum([cd filesep],channel,'H');
    
    load('StateEpochSBAllOB','REMEpoch','SWSEpoch');REMEpoch1=REMEpoch;SWSEpoch1=SWSEpoch;
    load('StateEpochSB','REMEpoch','Wake','SWSEpoch');
    load('H_Low_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    MeanRemSpec_H(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch)));
    MeanRemSpec1_H(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch-REMEpoch1)));
    MeanSwsSpec2_H(mm,:) = nanmean(Data(Restrict(sptsd,and(REMEpoch,REMEpoch1))));
    load('B_Low_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    MeanRemSpec_B(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch)));
    MeanRemSpec1_B(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch-REMEpoch1)));
    MeanSwsSpec2_B(mm,:) = nanmean(Data(Restrict(sptsd,and(REMEpoch,REMEpoch1))));
    load('PF_Low_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    MeanRemSpec_P(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch)));
    MeanRemSpec1_P(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch-REMEpoch1)));
    MeanSwsSpec2_P(mm,:) = nanmean(Data(Restrict(sptsd,and(REMEpoch,REMEpoch1))));
    load('H_High_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    MeanRemSpec_HH(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch)));
    MeanRemSpec1_HH(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch-REMEpoch1)));
    MeanSwsSpec2_HH(mm,:) = nanmean(Data(Restrict(sptsd,and(REMEpoch,REMEpoch1))));
    load('B_High_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    MeanRemSpec_BH(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch)));
    MeanRemSpec1_BH(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch-REMEpoch1)));
    MeanSwsSpec2_BH(mm,:) = nanmean(Data(Restrict(sptsd,and(REMEpoch,REMEpoch1))));
    load('PF_High_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    MeanRemSpec_PH(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch)));
    MeanRemSpec1_PH(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch-REMEpoch1)));
    MeanSwsSpec2_PH(mm,:) = nanmean(Data(Restrict(sptsd,and(REMEpoch,REMEpoch1))));
    load('H_VHigh_Spectrum.mat')
    sptsd=tsd(Spectro{2}*1e4,log(Spectro{1}));
    MeanRemSpec_HVH(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch)));
    MeanRemSpec1_HVH(mm,:) = nanmean(Data(Restrict(sptsd,REMEpoch-REMEpoch1)));
    MeanSwsSpec2_HVH(mm,:) = nanmean(Data(Restrict(sptsd,and(REMEpoch,REMEpoch1))));
    
end

clear Spec1  Spec2 Spec3
for mm=1:m
    SumPow = nanmean(nanmean([MeanRemSpec_H(mm,:),MeanRemSpec1_H(mm,:),MeanSwsSpec2_H(mm,:)]));
    Spec1(mm,:) = MeanRemSpec_H(mm,:)./SumPow;
    Spec2(mm,:) = MeanRemSpec1_H(mm,:)./SumPow;
    Spec3(mm,:) =  MeanSwsSpec2_H(mm,:)./SumPow;
end
subplot(3,3,1)
plot(FLo,nanmean(Spec1),'k')
hold on
plot(FLo,nanmean(Spec2),'r')
plot(FLo,nanmean(Spec3),'g')
title('HPC - Low')

clear Spec1  Spec2 Spec3
for mm=1:m
    SumPow = nanmean(nanmean([MeanRemSpec_B(mm,:),MeanRemSpec1_B(mm,:),MeanSwsSpec2_B(mm,:)]));
    Spec1(mm,:) = MeanRemSpec_B(mm,:)./SumPow;
    Spec2(mm,:) = MeanRemSpec1_B(mm,:)./SumPow;
    Spec3(mm,:) =  MeanSwsSpec2_B(mm,:)./SumPow;
end
subplot(3,3,2)
plot(FLo,nanmean(Spec1),'k')
hold on
plot(FLo,nanmean(Spec2),'r')
plot(FLo,nanmean(Spec3),'g')
title('OB - Low')

clear Spec1  Spec2 Spec3
for mm=1:m
    SumPow = nanmean(nanmean([MeanRemSpec_P(mm,:),MeanRemSpec1_P(mm,:),MeanSwsSpec2_P(mm,:)]));
    Spec1(mm,:) = MeanRemSpec_P(mm,:)./SumPow;
    Spec2(mm,:) = MeanRemSpec1_P(mm,:)./SumPow;
    Spec3(mm,:) =  MeanSwsSpec2_P(mm,:)./SumPow;
end
subplot(3,3,3)
plot(FLo,nanmean(Spec1),'k')
hold on
plot(FLo,nanmean(Spec2),'r')
plot(FLo,nanmean(Spec3),'g')
title('PFC - Low')

clear Spec1  Spec2 Spec3
for mm=1:m
    SumPow = nanmean(nanmean([MeanRemSpec_HH(mm,:),MeanRemSpec1_HH(mm,:),MeanSwsSpec2_HH(mm,:)]));
    Spec1(mm,:) = MeanRemSpec_HH(mm,:)./SumPow;
    Spec2(mm,:) = MeanRemSpec1_HH(mm,:)./SumPow;
    Spec3(mm,:) =  MeanSwsSpec2_HH(mm,:)./SumPow;
end
subplot(3,3,4)
plot(FH,nanmean(Spec1),'k')
hold on
plot(FH,nanmean(Spec2),'r')
plot(FH,nanmean(Spec3),'g')
title('HPC - High')

clear Spec1  Spec2 Spec3
for mm=1:m
    SumPow = nanmean(nanmean([MeanRemSpec_BH(mm,:),MeanRemSpec1_BH(mm,:),MeanSwsSpec2_BH(mm,:)]));
    Spec1(mm,:) = MeanRemSpec_BH(mm,:)./SumPow;
    Spec2(mm,:) = MeanRemSpec1_BH(mm,:)./SumPow;
    Spec3(mm,:) =  MeanSwsSpec2_BH(mm,:)./SumPow;
end
subplot(3,3,5)
plot(FH,nanmean(Spec1),'k')
hold on
plot(FH,nanmean(Spec2),'r')
plot(FH,nanmean(Spec3),'g')
title('OB - High')
  

clear Spec1  Spec2 Spec3
for mm=1:m
    SumPow = nanmean(nanmean([MeanRemSpec_PH(mm,:),MeanRemSpec1_PH(mm,:),MeanSwsSpec2_PH(mm,:)]));
    Spec1(mm,:) = MeanRemSpec_PH(mm,:)./SumPow;
    Spec2(mm,:) = MeanRemSpec1_PH(mm,:)./SumPow;
    Spec3(mm,:) =  MeanSwsSpec2_PH(mm,:)./SumPow;
end
subplot(3,3,6)
plot(FH,nanmean(Spec1),'k')
hold on
plot(FH,nanmean(Spec2),'r')
plot(FH,nanmean(Spec3),'g')
title('PFC - High')

clear Spec1  Spec2 Spec3
for mm=1:m
    SumPow = nanmean(nanmean([MeanRemSpec_HVH(mm,:),MeanRemSpec1_HVH(mm,:),MeanSwsSpec2_HVH(mm,:)]));
    Spec1(mm,:) = MeanRemSpec_HVH(mm,:)./SumPow;
    Spec2(mm,:) = MeanRemSpec1_HVH(mm,:)./SumPow;
    Spec3(mm,:) =  MeanSwsSpec2_HVH(mm,:)./SumPow;
end
subplot(3,3,7)
plot(FVh,nanmean(Spec1),'k')
hold on
plot(FVh,nanmean(Spec2),'r')
plot(FVh,nanmean(Spec3),'g')
title('HPC- VH')

trict(sptsd,and(REMEpoch,REMEpoch1))));