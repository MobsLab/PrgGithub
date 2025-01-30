

HeadRestraintSess_BM

cd('/media/nas7/ProjetEmbReact/Mouse1385/20221107')

load('SleepScoring_OBGamma.mat', 'SmoothGamma')
[Y,X]=hist(log10(Data(SmoothGamma)),1000);
Y=Y/sum(Y);
plot(X,Y)
hold on


cd(HeadRestraintSess{7}{4})

load('StateEpochSB.mat', 'smooth_ghi')
[Y,X]=hist(log10(Data(smooth_ghi)),1000);
Y=Y/sum(Y);
plot(X,Y)


legend('Freely moving','Head restraint')
v=vline(2.55); set(v,'LineWidth',2)
box off
xlabel('OB gamma power (a.u.)')







%% Individual analysis
load('StateEpochSB.mat')
% load('H_rip_Low_Spectrum.mat')
% Sptsd.HPC_rip_Low = tsd(Spectro{2}*1e4 , Spectro{1});
load('H_Low_Spectrum.mat')
Sptsd.HPC_deep_Low = tsd(Spectro{2}*1e4 , Spectro{1});
Low_Frequency_Range=Spectro{3};
load('B_Low_Spectrum.mat')
Sptsd.Bulb_Low = tsd(Spectro{2}*1e4 , Spectro{1});
load('B_Middle_Spectrum.mat')
Middle_Frequency_Range=Spectro{3};
Sptsd.Bulb_Middle = tsd(Spectro{2}*1e4 , Spectro{1});
load('B_High_Spectrum.mat')
Sptsd.Bulb_High = tsd(Spectro{2}*1e4 , Spectro{1});
High_Frequency_Range=Spectro{3};
load('PFCx_Low_Spectrum.mat')
Sptsd.PFC_Low = tsd(Spectro{2}*1e4 , Spectro{1});
load('H_VHigh_Spectrum.mat')
Sptsd.HPC_VHigh = tsd(Spectro{2}*1e4 , Spectro{1});
VHigh_Frequency_Range=Spectro{3};

% HR
load('HeartBeatInfo.mat')
EKG.HBRate_Moving=Restrict(EKG.HBRate , Behav.MovingEpoch);
EKG.HBRate_Fz=Restrict(EKG.HBRate , Behav.FreezeAccEpoch);

%% Figures
% showing first that there is 2 states : moving/immobile
figure
subplot(311)
plot(Range(NewMovAcctsd,'s')/60 , Data(NewMovAcctsd));
hold on
plot(Range(Restrict(NewMovAcctsd , FreezeAccEpoch),'s')/60 , Data(Restrict(NewMovAcctsd , FreezeAccEpoch)));
ylim([0 2e7]); xlim([0 max(Range(NewMovAcctsd,'s')/60)])
ylabel('Acceleration'); legend('Moving','Immobile')
title('Accelerometer')

subplot(312)
imagesc(Range(Sptsd.Bulb_Low,'s')/60,Low_Frequency_Range,Data(Sptsd.Bulb_Low)'); axis xy
Colors.FreezeAccEpoch = 'r';
Colors.MovingEpoch = 'c';
Colors.Noise = [0 0 0];
PlotPerAsLine(FreezeAccEpoch, 15, Colors.FreezeAccEpoch, 'timescaling', 60e4, 'linewidth',10);
PlotPerAsLine(MovingEpoch, 15, Colors.MovingEpoch, 'timescaling', 60e4, 'linewidth',10);
ylabel('Frequency (Hz)'); f=get(gca,'Children'); legend([f(ceil(length(f))/2+1),f(1)],'Immobile','Moving');
title('Low Bulb')

subplot(313)
plot(Range(EKG.HBRate,'s')/60 , runmean(Data(EKG.HBRate),5))
hold on
plot(Range(Restrict(EKG.HBRate , FreezeAccEpoch),'s')/60 , runmean(Data(Restrict(EKG.HBRate , FreezeAccEpoch)),5));
legend('Moving','Immobile')
xlabel('time (min)'); ylabel('Frequency (Hz)'); xlim([0 max(Range(NewMovAcctsd,'s')/60)]); 
title('Heart rate')


% spectrograms
figure
subplot(311)
imagesc(Range(Sptsd.HPC_rip_Low),Low_Frequency_Range,Data(Sptsd.HPC_rip_Low)'); axis xy
caxis([0 3e4])

subplot(312)
imagesc(Range(Sptsd.HPC_deep_Low),Low_Frequency_Range,Data(Sptsd.HPC_deep_Low)'); axis xy
caxis([0 3e4])

subplot(313)
imagesc(Range(Sptsd.HPC_27),Low_Frequency_Range,Data(Sptsd.HPC_27)'); axis xy
caxis([0 3e4])


figure
subplot(311)
imagesc(Range(Sptsd.Bulb_Low),Low_Frequency_Range,Data(Sptsd.Bulb_Low)'); axis xy

subplot(312)
imagesc(Range(Sptsd.Bulb_Middle),Middle_Frequency_Range,Data(Sptsd.Bulb_Middle)'); axis xy
caxis([0 1e4])

subplot(313)
imagesc(Range(Sptsd.Bulb_High),High_Frequency_Range,Data(Sptsd.Bulb_High)'); axis xy
caxis([0 1e4])

figure
subplot(211)
imagesc(Range(Sptsd.PFC_Low),Low_Frequency_Range,Data(Sptsd.PFC_Low)'); axis xy
caxis([0 3e4])

subplot(212)
imagesc(Range(Sptsd.HPC_VHigh),VHigh_Frequency_Range,Data(Sptsd.HPC_VHigh)'); axis xy
caxis([0 3e2]); ylim([100 250])
colormap jet



% Mean spectrums
figure
subplot(231)
plot(Low_Frequency_Range , nanmean(Data(Sptsd.HPC_deep_Low)),'Color' , [0 1 0])
hold on
plot(Low_Frequency_Range , nanmean(Data(Sptsd.HPC_rip_Low)),'Color' , [0 .6 0])
ylabel('Power (a.u.)')
legend('dHPC deep','dHPC rip'); makepretty
title('HPC Low')

subplot(2,9,11)
plot(VHigh_Frequency_Range , nanmean(Data(Sptsd.HPC_VHigh27)),'Color' , [0 1 0])
hold on
plot(VHigh_Frequency_Range , nanmean(Data(Sptsd.HPC_VHigh)),'Color' , [0 .6 0])
set(gca, 'YScale', 'log'); makepretty; xlim([30 250])
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')
title('HPC VHigh')

subplot(232)
plot(Low_Frequency_Range , nanmean(Data(Sptsd.Bulb_Low)),'Color' , [0 0 1])
hold on
plot(Low_Frequency_Range , nanmean(Data(Sptsd.Bulb3)),'Color' , 'c')
makepretty; legend('Bulb1','Bulb2','PFC'); ylim([3e2 1e6])
set(gca, 'YScale', 'linear');
title('Bulb Low')
ylim([2e3 1e6])

subplot(235)
plot(Middle_Frequency_Range , nanmean(Data(Sptsd.Bulb_Middle)),'b')
hold on
plot(Middle_Frequency_Range , nanmean(Data(Sptsd.Bulb3_Middle)),'c')
makepretty; ylim([0 7e3])
xlabel('Frequency (Hz)')
title('Bulb High')
set(gca, 'YScale', 'linear');

subplot(233)
plot(Low_Frequency_Range , nanmean(Data(Sptsd.Bulb_Low)/max(nanmean(Data(Sptsd.Bulb_Low)))),'Color' , [0 0 1])
hold on
plot(Low_Frequency_Range , nanmean(Data(Sptsd.PFC_Low)/max(nanmean(Data(Sptsd.PFC_Low)))),'Color' , 'r')
makepretty; legend('Bulb1','PFC'); title('PFC Low')
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')
axes('Position',[.8 .68 .15 .15]); box on
plot(Low_Frequency_Range , nanmean(Data(Sptsd.Bulb_Low)),'Color' , [0 0 1])
hold on
plot(Low_Frequency_Range , nanmean(Data(Sptsd.PFC_Low)),'Color' , 'r')
makepretty; xlim([0 10])

subplot(236)
plot(Middle_Frequency_Range , nanmean(Data(Sptsd.PFC18_Middle)),'Color' , 'r')
makepretty; ylim([50 1e4])
set(gca, 'YScale', 'log'); vline(45,'--r')
xlabel('Frequency (Hz)');  title('PFC High')


% Differences immobile/active
Sptsd.Bulb_Low_Moving = Restrict(Sptsd.Bulb_Low , MovingEpoch);
Sptsd.Bulb_Low_Fz = Restrict(Sptsd.Bulb_Low , FreezeAccEpoch);
Sptsd.HPC_Low_Moving = Restrict(Sptsd.HPC_deep_Low , MovingEpoch);
Sptsd.HPC_Low_Fz = Restrict(Sptsd.HPC_deep_Low , FreezeAccEpoch);
Sptsd.Bulb_Middle_Moving = Restrict(Sptsd.Bulb_Middle , MovingEpoch);
Sptsd.Bulb_Middle_Fz = Restrict(Sptsd.Bulb_Middle , FreezeAccEpoch);
Sptsd.HPC_VHigh_Moving = Restrict(Sptsd.HPC_VHigh , MovingEpoch);
Sptsd.HPC_VHigh_Fz = Restrict(Sptsd.HPC_VHigh , FreezeAccEpoch);
Sptsd.PFC_Low_Moving = Restrict(Sptsd.PFC_Low , MovingEpoch);
Sptsd.PFC_Low_Fz = Restrict(Sptsd.PFC_Low , FreezeAccEpoch);
Sptsd.PFC_Middle_Moving = Restrict(Sptsd.PFC_Middle , MovingEpoch);
Sptsd.PFC_Middle_Fz = Restrict(Sptsd.PFC_Middle , FreezeAccEpoch);


figure
subplot(231)
plot(Low_Frequency_Range , nanmean(Data(Sptsd.HPC_Low_Moving))); 
hold on
plot(Low_Frequency_Range , nanmean(Data(Sptsd.HPC_Low_Fz)));
makepretty; xlim([0 15])
ylabel('Power (a.u.)'); 
legend('Moving','Immobile')
title('HPC Low')

subplot(234)
plot(VHigh_Frequency_Range , nanmean(Data(Sptsd.HPC_VHigh_Moving))); 
hold on
plot(VHigh_Frequency_Range , nanmean(Data(Sptsd.HPC_VHigh_Fz)));
makepretty; set(gca, 'YScale', 'log');
ylabel('Power (a.u.)'); xlabel('Frequency (Hz)')
title('HPC VHigh')

subplot(232)
plot(Low_Frequency_Range , nanmean(Data(Sptsd.Bulb_Low_Moving))); 
hold on
plot(Low_Frequency_Range , nanmean(Data(Sptsd.Bulb_Low_Fz)));
makepretty; xlim([0 15])
title('OB Low')

subplot(235)
plot(Middle_Frequency_Range , nanmean(Data(Sptsd.Bulb_Middle_Moving))); 
hold on
plot(Middle_Frequency_Range , nanmean(Data(Sptsd.Bulb_Middle_Fz)));
makepretty; ylim([0 6e3])
xlabel('Frequency (Hz)')
title('OB High')

subplot(233)
plot(Low_Frequency_Range , nanmean(Data(Sptsd.PFC_Low_Moving))); 
hold on
plot(Low_Frequency_Range , nanmean(Data(Sptsd.PFC_Low_Fz)));
makepretty; xlim([0 15]); ylim([0 3.2e4])
title('PFC Low')

subplot(236)
plot(Middle_Frequency_Range , nanmean(Data(Sptsd.PFC_Middle_Moving))); 
hold on
plot(Middle_Frequency_Range , nanmean(Data(Sptsd.PFC_Middle_Fz)));
makepretty; ylim([0 1e3])
title('PFC Low')




%% Analysis multi days



edit HeadRestraintSess_BM.m

for sess=1:length(HeadRestraintSess.M1227)
    
    cd(HeadRestraintSess.M1227{sess})
    
    load('behavResources.mat', 'MovAcctsd')
    load('behavResources_SB.mat', 'Behav')
%         NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),30));
%     
%         subplot(5,1,sess)
%         plot(Range(NewMovAcctsd),Data(NewMovAcctsd))
%         hold on
%         plot(Range(Restrict(NewMovAcctsd , Behav.FreezeAccEpoch)),Data(Restrict(NewMovAcctsd , Behav.FreezeAccEpoch)))
%         xlim([0 3.6e7])
%         ylim([0 4e7])
%     ImmobArray(sess)=sum(Stop(Behav.FreezeAccEpoch)-Start(Behav.FreezeAccEpoch))/max(Range(MovAcctsd));
%     
    clear RipplesEpochR
    load('Ripples.mat')
    RipArray(sess,1) = length(Start(RipplesEpochR));
    RipArray(sess,2) = length(Start(and(RipplesEpochR , Behav.FreezeAccEpoch)));
    RipArray(sess,3) = length(Start(and(RipplesEpochR , Behav.MovingEpoch)));
      
    RipArray(sess,4) = length(Start(RipplesEpochR))/max(Range(MovAcctsd,'s'));
    RipArray(sess,5) = length(Start(and(RipplesEpochR , Behav.FreezeAccEpoch)))/(sum(Stop(Behav.FreezeAccEpoch)-Start(Behav.FreezeAccEpoch))/1e4);
    RipArray(sess,6) = length(Start(and(RipplesEpochR , Behav.MovingEpoch)))/(sum(Stop(Behav.MovingEpoch)-Start(Behav.MovingEpoch))/1e4);
    
%     SessNames{1} = cd;
%     EMG_Data = ConcatenateDataFromFolders_SB(SessNames,'emg');
%     EMG_Filtered_Pre = FilterLFP(EMG_Data , [50 300] , 1024);
%     DataEMG_Filtered = log10(runmean(Data((EMG_Filtered_Pre)).^2,ceil(3/median(diff(Range(EMG_Filtered_Pre,'s'))))));
%     EMG_Filtered = tsd(Range(EMG_Data) , DataEMG_Filtered);
%     subplot(5,1,sess)
%     plot(Range(EMG_Filtered),Data(EMG_Filtered))
%     hold on
%     plot(Range(Restrict(EMG_Filtered , Behav.FreezeAccEpoch)),Data(Restrict(EMG_Filtered , Behav.FreezeAccEpoch)))
%     xlim([0 3.6e7])
%     ylim([4 5.5])
    
%     load('HeartBeatInfo.mat')
%      subplot(5,1,sess)
%     plot(Range(EKG.HBRate),Data(EKG.HBRate))
%     hold on
%     plot(Range(Restrict(EKG.HBRate , Behav.FreezeAccEpoch)),Data(Restrict(EKG.HBRate , Behav.FreezeAccEpoch)))
%     xlim([0 3.6e7])
%     ylim([10 13.5])
    
end


Cols = {[0 0 1],[0.4 0.4 1],[0.7 0.7 1]};
X = [1:3];
Legends = {'All','Immobile','Moving'};


figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(RipArray(:,1:3),Cols,X,Legends,'showpoints',0,'paired',1);
subplot(122)
MakeSpreadAndBoxPlot2_SB(RipArray(:,4:6),Cols,X,Legends,'showpoints',0,'paired',1);

for sess=1:length(HeadRestraintSess.M1227)
    
    cd(HeadRestraintSess.M1227{sess})
    
    load('Ripples.mat', 'RipplesEpochR')
    clear Rg_Acc SmallEpoch RipDensity_Pre TimeRange
    Rg_Acc = Range(MovAcctsd);
    i=1; bin_length = ceil(60/median(diff(Range(MovAcctsd,'s')))); % in 2s
    for bin=1:bin_length:length(Rg_Acc)-bin_length
        SmallEpoch=intervalSet(Rg_Acc(bin),Rg_Acc(bin+bin_length));
        RipDensity_Pre(i) = length(Start(and(RipplesEpochR , SmallEpoch)));
        TimeRange(i) = Rg_Acc(bin);
        i=i+1;
    end
    RipDensity_tsd = tsd(TimeRange' , RipDensity_Pre');
    
    subplot(5,1,sess)
    plot(Range(RipDensity_tsd),Data(RipDensity_tsd))
    ylim([0 30])
end








    
    
    
    

