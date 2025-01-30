

%% Individual analysis
load('StateEpochSB.mat')
load('behavResources_SB.mat')

load('H_rip_Low_Spectrum.mat')
Sptsd.HPC_rip_Low = tsd(Spectro{2}*1e4 , Spectro{1});
load('H_deep_Low_Spectrum.mat')
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
load('H_27_VHigh_Spectrum.mat')
Sptsd.HPC_VHigh27 = tsd(Spectro{2}*1e4 , Spectro{1});
load('B3_Low_Spectrum.mat')
Sptsd.Bulb3 = tsd(Spectro{2}*1e4 , Spectro{1});
load('B3_Middle_Spectrum.mat')
Sptsd.Bulb3_Middle = tsd(Spectro{2}*1e4 , Spectro{1});
load('PFC_Middle_Spectrum.mat')
Sptsd.PFC_Middle = tsd(Spectro{2}*1e4 , Spectro{1});

% HR
load('HeartBeatInfo.mat')
EKG.HBRate_Moving=Restrict(EKG.HBRate , Behav.MovingEpoch);
EKG.HBRate_Fz=Restrict(EKG.HBRate , Behav.FreezeAccEpoch);

%% Figures
% showing first that there is 2 states : moving/immobile
load('behavResources.mat')
NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),30));

figure
subplot(411)
plot(Range(NewMovAcctsd,'s')/60 , Data(NewMovAcctsd));
hold on
plot(Range(Restrict(NewMovAcctsd , Behav.FreezeAccEpoch),'s')/60 , Data(Restrict(NewMovAcctsd , Behav.FreezeAccEpoch)));
ylim([0 2e7]); xlim([0 max(Range(NewMovAcctsd,'s')/60)])
ylabel('Acceleration'); legend('Moving','Immobile')
title('Accelerometer')

subplot(412)
imagesc(Range(Sptsd.Bulb_Low,'s')/60,Low_Frequency_Range,Data(Sptsd.Bulb_Low)'); axis xy
Colors.FreezeAccEpoch = 'r';
Colors.MovingEpoch = 'c';
Colors.Noise = [0 0 0];
PlotPerAsLine(Behav.FreezeAccEpoch, 15, Colors.FreezeAccEpoch, 'timescaling', 60e4, 'linewidth',10);
PlotPerAsLine(Behav.MovingEpoch, 15, Colors.MovingEpoch, 'timescaling', 60e4, 'linewidth',10);
ylabel('Frequency (Hz)'); f=get(gca,'Children'); legend([f(ceil(length(f))/2+1),f(1)],'Immobile','Moving');
title('Low Bulb')

subplot(413)
plot(Range(EKG.HBRate,'s')/60 , runmean(Data(EKG.HBRate),5))
hold on
plot(Range(Restrict(EKG.HBRate , Behav.FreezeAccEpoch),'s')/60 , runmean(Data(Restrict(EKG.HBRate , Behav.FreezeAccEpoch)),5));
ylabel('Frequency (Hz)'); xlim([0 max(Range(NewMovAcctsd,'s')/60)]); 
title('Heart rate')

subplot(414)
SessNames{1} = cd;
EMG_Data = ConcatenateDataFromFolders_SB(SessNames,'emg');
EMG_Filtered_Pre = FilterLFP(EMG_Data , [50 300] , 1024);
DataEMG_Filtered = log10(runmean(Data((EMG_Filtered_Pre)).^2,ceil(3/median(diff(Range(EMG_Filtered_Pre,'s'))))));
EMG_Filtered = tsd(Range(EMG_Data) , DataEMG_Filtered);

plot(Range(EMG_Filtered,'s')/60 , runmean(Data(EMG_Filtered),5))
hold on
plot(Range(Restrict(EMG_Filtered , Behav.FreezeAccEpoch),'s')/60 , runmean(Data(Restrict(EMG_Filtered , Behav.FreezeAccEpoch)),5));
xlabel('time (min)'); ylabel('log scale'); xlim([0 max(Range(NewMovAcctsd,'s')/60)]); 
title('EMG')

a=suptitle('Identification of 2 states in head restraint protocol, D1, Mouse 1227'); a.FontSize=20;


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
plot(Middle_Frequency_Range , nanmean(Data(Sptsd.PFC_Middle)),'Color' , 'r')
makepretty; ylim([50 1e4])
set(gca, 'YScale', 'log'); vline(45,'--r')
xlabel('Frequency (Hz)');  title('PFC High')


% Differences immobile/active
Sptsd.Bulb_Low_Moving = Restrict(Sptsd.Bulb_Low , Behav.MovingEpoch);
Sptsd.Bulb_Low_Fz = Restrict(Sptsd.Bulb_Low , Behav.FreezeAccEpoch);
Sptsd.HPC_Low_Moving = Restrict(Sptsd.HPC_deep_Low , Behav.MovingEpoch);
Sptsd.HPC_Low_Fz = Restrict(Sptsd.HPC_deep_Low , Behav.FreezeAccEpoch);
Sptsd.Bulb_Middle_Moving = Restrict(Sptsd.Bulb_Middle , Behav.MovingEpoch);
Sptsd.Bulb_Middle_Fz = Restrict(Sptsd.Bulb_Middle , Behav.FreezeAccEpoch);
Sptsd.HPC_VHigh_Moving = Restrict(Sptsd.HPC_VHigh , Behav.MovingEpoch);
Sptsd.HPC_VHigh_Fz = Restrict(Sptsd.HPC_VHigh , Behav.FreezeAccEpoch);
Sptsd.PFC_Low_Moving = Restrict(Sptsd.PFC_Low , Behav.MovingEpoch);
Sptsd.PFC_Low_Fz = Restrict(Sptsd.PFC_Low , Behav.FreezeAccEpoch);
Sptsd.PFC_Middle_Moving = Restrict(Sptsd.PFC_Middle , Behav.MovingEpoch);
Sptsd.PFC_Middle_Fz = Restrict(Sptsd.PFC_Middle , Behav.FreezeAccEpoch);


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


load('Ripples.mat', 'RipplesEpochR')
Rg_Acc = Range(MovAcctsd);
i=1; bin_length = ceil(2/median(diff(Range(MovAcctsd,'s')))); % in 2s
for bin=1:bin_length:length(Rg_Acc)-bin_length
    SmallEpoch=intervalSet(Rg_Acc(bin),Rg_Acc(bin+bin_length));
    RipDensity_Pre(i) = length(Start(and(RipplesEpochR , SmallEpoch)));
    TimeRange(i) = Rg_Acc(bin);
    i=i+1;
end
RipDensity_tsd = tsd(TimeRange' , RipDensity_Pre');
RipDensity = Restrict(RipDensity_tsd , Behav.FreezeAccEpoch);
VHigh_OnRipplesEpoch = Restrict(Sptsd.HPC_VHigh , RipplesEpochR);

figure
subplot(211)
plot(Data(RipDensity))
subplot(223)
bar([length(Start(and(RipplesEpochR , Behav.MovingEpoch)))/sum(Stop(Behav.MovingEpoch)-Start(Behav.MovingEpoch))*1e4 ; length(Start(and(RipplesEpochR , Behav.FreezeAccEpoch)))/sum(Stop(Behav.FreezeAccEpoch)-Start(Behav.FreezeAccEpoch))*1e4 ])

figure
subplot(311)
imagesc(Range(VHigh_OnRipplesEpoch) , VHigh_Frequency_Range , Data(VHigh_OnRipplesEpoch)'); axis xy
colormap jet
caxis([0 4e3])
subplot(312)
imagesc(Range(VHigh_OnRipplesEpoch,'s') , VHigh_Frequency_Range , Data(VHigh_OnRipplesEpoch)'); axis xy
caxis([0 6e3]); ylim([120 200])
subplot(313)
imagesc(Range(VHigh_OnRipplesEpoch,'s') , VHigh_Frequency_Range , Data(VHigh_OnRipplesEpoch)'); axis xy
caxis([0 6e3]); ylim([120 200])

Data_VHigh_OnRipplesEpoch = Data(VHigh_OnRipplesEpoch);


figure
subplot(211)
plot(nanmean(Data_VHigh_OnRipplesEpoch'))
subplot(212)
plot(nanmean(Data_VHigh_OnRipplesEpoch(:,45:74)'))


ep=1;
GZ = Restrict(Sptsd.HPC_VHigh , subset(RipplesEpochR,ep)); DataGZ = Data(GZ); plot(nanmean(DataGZ(:,45:74)')); ep=ep+1;

plot(Derivated__From_NormPower(V>1e3,:)')

subplot(121)
histogram(h(V>1e3),20)
xlabel('time (1e-4 s)')
subplot(122)
histogram(V(V>1e3),20)
xlabel('Power (a.u.)')

for i=1:length(Start(RipplesEpochR))

    h(i)=sum(Stop(subset(RipplesEpochR,i))-Start(subset(RipplesEpochR,i)));
    GZ = Restrict(Sptsd.HPC_VHigh , subset(RipplesEpochR,i)); DataGZ = Data(GZ);
    V(i)=nanmean(nanmean(DataGZ(:,45:74)'));
    Vbis(i,1:length(nanmean(DataGZ(:,45:74)')))=nanmean(DataGZ(:,45:74)');
    
end
Vbis(Vbis==0)=NaN;

figure; plot(Vbis(V>1e3,:)')
for ep=1:size(Vbis,1)
    Vbis_norm(ep,:)= interp1(linspace(0,1,sum(~isnan(Vbis(ep,:)))) , Vbis(ep,1:sum(~isnan(Vbis(ep,:)))),linspace(0,1,40));
end
plot(Vbis_norm(V>1e3,:)')

for ep=1:size(Vbis_norm,1)
    for bin=2:40
        Derivated__From_NormPower(ep,1)=0;
        Derivated__From_NormPower(ep,bin)=(Vbis_norm(ep,bin)-Vbis_norm(ep,bin-1))/nanmean(Vbis_norm(ep,:));
    end
    if and(sum(Derivated__From_NormPower(ep,1:20)>0) , sum(Derivated__From_NormPower(ep,21:40)<0))
        vector_u(ep)=1;
    else
        vector_u(ep)=0;
    end
end
sum(vector_u(V>1e3))

figure
subplot(121)
plot(Vbis_norm(and(vector_u,V>1e3),:)')
subplot(122)
plot(Vbis_norm(and(~vector_u,V>1e3),:)')

load('ChannelsToAnalyse/dHPC_rip.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])

X=1:127; Y1=X(and(vector_u,V>1e3)); Y2=X(and(~vector_u,V>1e3));

figure
for i=1:7
    subplot(2,7,i)
    plot(Data(Restrict(LFP,subset(RipplesEpochR , Y1(i)))))
     subplot(2,7,i+7)
   plot(Data(Restrict(LFP,subset(RipplesEpochR , Y2(i)))))
end

plot(Data(Restrict(LFP,subset(RipplesEpochR ,18)))












figure
plot(Vbis_norm(18,:)')
plot()







    
    
    
    

