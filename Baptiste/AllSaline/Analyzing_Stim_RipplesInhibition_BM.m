
%% stim analyses ripples inhibition

cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Sess.mat')

CondSess.M1304 = Sess.M1304(find(not(cellfun(@isempty,strfind(Sess.M1304 ,'Cond')))));
ExtSess.M1304 = Sess.M1304(find(not(cellfun(@isempty,strfind(Sess.M1304 ,'Ext')))));


Epoch_Before_Stim = ConcatenateDataFromFolders_SB(CondSess.M1304 , 'before_stim_epoch');
VHigh_Sp_Cond_tsd = ConcatenateDataFromFolders_SB(CondSess.M1304 , 'spectrum','prefix','H_VHigh');
FzEpoch_Cond = ConcatenateDataFromFolders_SB(CondSess.M1304 , 'epoch','epochname','freezeepoch');

Around_Ripples_Epoch = ConcatenateDataFromFolders_SB(ExtSess.M1304 , 'around_ripples_epoch');
VHigh_Sp_Ext_tsd = ConcatenateDataFromFolders_SB(ExtSess.M1304 , 'spectrum','prefix','H_VHigh');
FzEpoch_Ext = ConcatenateDataFromFolders_SB(ExtSess.M1304 , 'epoch','epochname','freezeepoch');


VHigh_Sp_Cond_Fz = Restrict(VHigh_Sp_Cond_tsd , FzEpoch_Cond);
VHigh_Sp_Ext_Fz = Restrict(VHigh_Sp_Ext_tsd , FzEpoch_Ext);

for stim = 1:length(Start(Epoch_Before_Stim))
    VHigh_Sp_Before_Stim_Cond{stim} = Restrict(VHigh_Sp_Cond_tsd , subset(Epoch_Before_Stim , stim));
    D=Data(VHigh_Sp_Before_Stim_Cond{stim});
    VHigh_Sp_Before_Stim_Cond_Data(stim,:) = nanmean(D(:,54:78)); clear D
end
for stim = 1:length(Start(Around_Ripples_Epoch))
    VHigh_Sp_Around_Ripples_Ext{stim} = Restrict(VHigh_Sp_Ext_tsd , subset(Around_Ripples_Epoch , stim));
    D=Data(VHigh_Sp_Around_Ripples_Ext{stim});
    VHigh_Sp_Around_Ripples_Ext_Data(stim,:) = nanmean(D(:,54:78)); clear D
end


% imagesc of stim and ripples
load('H_VHigh_Spectrum.mat'); stim=0;
figure
stim=stim+1;

subplot(121)
D1 = Data(VHigh_Sp_Before_Stim_Cond{stim});
imagesc(Range(VHigh_Sp_Before_Stim_Cond{stim} , 's') , Spectro{3}(33:end) , zscore(D1(:,33:end)')); axis xy; caxis ([-1 1.5])
clear D1
subplot(122)
D2 = Data(VHigh_Sp_Around_Ripples_Ext{stim});
imagesc(Range(VHigh_Sp_Around_Ripples_Ext{stim} , 's') , Spectro{3}(33:end) , zscore(D2(:,33:end)')); axis xy; caxis ([-1 1.5])
clear D2


% Mean VHigh HPC Spectrum
figure
plot(Spectro{3} , nanmean(Data(VHigh_Sp_Cond_Fz))); set(gca, 'YScale', 'log');
hold on
plot(Spectro{3} , nanmean(Data(VHigh_Sp_Ext_Fz))); set(gca, 'YScale', 'log');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (log scale)'); legend('Cond / + inhib','Ext / - inhib'); 
title('HPC VHigh spectrum, freezing, +/- stims, Mouse 1304')


% Average power evolution between 150-220
figure
clf; stim=stim+1; 
D1 = Data(VHigh_Sp_Before_Stim_Cond{stim}); D1_bis = zscore(D1(:,33:end)');
plot(nanmean(D1_bis(22:46,:))); clear D1 D1_bis; hold on
D2 = Data(VHigh_Sp_Around_Ripples_Ext{stim}); D2_bis = zscore(D2(:,33:end)');
plot(nanmean(D2_bis(22:46,:))); clear D2 D2_bis; hold on
xlabel('time (a.u.)'); ylabel('power ripples frequency band')


for stim = 1:length(Start(Epoch_Before_Stim))
    D1 = Data(VHigh_Sp_Before_Stim_Cond{stim}); D1_bis = zscore(D1(:,33:end)');
    VHigh_Sp_Before_Stim_Cond_RipplesFreq(stim,:) = nanmean(D1_bis(22:46,1:41));
    clear D1 D1_bis;
end
for stim = 1:length(Start(Around_Ripples_Epoch))
    D2 = Data(VHigh_Sp_Around_Ripples_Ext{stim}); D2_bis = zscore(D2(:,33:end)');
    VHigh_Sp_Around_Ripples_Ext_Ripplesfreq(stim,:) = nanmean(D2_bis(22:46,1:41));
    clear D2 D2_bis;
end

figure
plot(nanmean(VHigh_Sp_Before_Stim_Cond_RipplesFreq))
hold on
plot(nanmean(VHigh_Sp_Around_Ripples_Ext_Ripplesfreq))
xlabel('time (a.u.)'); ylabel('power ripples frequency band')
makepretty; legend('ripples','stim')
vline(17,'--r')


%% filtered signal
LFP_rip_Cond = ConcatenateDataFromFolders_SB(CondSess.M1304 , 'lfp' , 'channumber' , 7);
LFP_rip_Ext = ConcatenateDataFromFolders_SB(ExtSess.M1304 , 'lfp' , 'channumber' , 7);


LFP_rip_Cond_LowFiltered = LowPassFilter( Data(LFP_rip_Cond) , 250 , 1250);
LFP_rip_Cond_Filtered = HighPassFilter_BM( LFP_rip_Cond_LowFiltered , 120 , 1250);
movRMS = dsp.MovingRMS(7);
LFP_rip_Cond_Filtered_RMS = tsd(Range(LFP_rip_Cond) , movRMS(LFP_rip_Cond_Filtered));
%
LFP_rip_Ext_LowFiltered = real(LowPassFilter( Data(LFP_rip_Ext) , 250 , 1250));
LFP_rip_Ext_Filtered = HighPassFilter_BM( LFP_rip_Ext_LowFiltered , 120 , 1250);
movRMS = dsp.MovingRMS(7);
LFP_rip_Ext_Filtered_RMS = tsd(Range(LFP_rip_Ext) , movRMS(LFP_rip_Ext_Filtered));


MovSTD_tsd_LFP_rip_Cond = tsd(Range(LFP_rip_Cond) , movstd(Data(LFP_rip_Cond),3));
Epoch_WithoutNoise_Cond = thresholdIntervals(MovSTD_tsd_LFP_rip_Cond,2e3,'Direction','Below');
Stim_Noise_Cond = thresholdIntervals(MovSTD_tsd_LFP_rip_Cond,2e3,'Direction','Above');
Stim_Noise_Cond=mergeCloseIntervals(Stim_Noise_Cond,0.19*1E4);
Start_Stim_Noise_Cond = Start(Stim_Noise_Cond);

figure
plot(Range(LFP_rip_Cond,'s') , Data(LFP_rip_Cond))
hold on
plot(Range(Restrict(LFP_rip_Cond , Epoch_WithoutNoise_Cond),'s') , Data(Restrict(LFP_rip_Cond , Epoch_WithoutNoise_Cond)));

for stim = 1:length(Start(Stim_Noise_Cond))
    % restrict LFP to 500ms before stim
    Epoch_to_use = intervalSet(Start_Stim_Noise_Cond(stim)-.5e4 , Start_Stim_Noise_Cond(stim));
    Data_to_use = Data(Restrict(LFP_rip_Cond , Epoch_to_use));
    Data_to_use_filtered_pre = real(LowPassFilter( Data_to_use , 250 , 1250));
    Data_to_use_filtered = real(HighPassFilter_BM( Data_to_use_filtered_pre , 120 , 1250));
    movRMS = dsp.MovingRMS(7);
    MovRMS_LFP_rip_Cond = movRMS(Data_to_use_filtered);
    RMS_BeforeStim(stim) = nanmean(MovRMS_LFP_rip_Cond(end-50:end));
    
    clear Epoch_to_use Data_to_use Data_to_use_filtered_pre Data_to_use_filtered MovRMS_LFP_rip_Cond
end

figure
histogram(RMS_BeforeStim,50)



%%
figure
clf; stim=stim+1; 

subplot(321)
plot(Range(LFP_rip_Cond,'s') , Data(LFP_rip_Cond))
hold on
plot(Range(LFP_rip_Cond,'s') , LFP_rip_Cond_Filtered)
plot(Range(LFP_rip_Cond,'s') , Data(LFP_rip_Cond_Filtered_RMS))

Sta = Start(Epoch_Before_Stim);
Sto = Stop(Epoch_Before_Stim);

xlim([Sta(stim)/1e4 Sto(stim)/1e4])

subplot(322)
plot(Range(LFP_rip_Ext,'s') , Data(LFP_rip_Ext))
hold on
plot(Range(LFP_rip_Ext,'s') , LFP_rip_Ext_Filtered)
plot(Range(LFP_rip_Ext,'s') , Data(LFP_rip_Ext_Filtered_RMS))

Sta = Start(Around_Ripples_Epoch);
Sto = Stop(Around_Ripples_Epoch);

xlim([Sta(stim)/1e4 Sto(stim)/1e4])


subplot(323)
D1 = Data(VHigh_Sp_Before_Stim_Cond{stim});
imagesc(Range(VHigh_Sp_Before_Stim_Cond{stim} , 's') , Spectro{3}(17:end) , D1(:,17:end)'); axis xy; caxis ([0 1000]), %caxis ([-1 1.5])
clear D1
subplot(324)
D2 = Data(VHigh_Sp_Around_Ripples_Ext{stim});
imagesc(Range(VHigh_Sp_Around_Ripples_Ext{stim} , 's') , Spectro{3}(17:end) , D2(:,17:end)'); axis xy; caxis ([0 1000]) %caxis ([-1 1.5])
clear D2


subplot(325)
D1 = Data(VHigh_Sp_Before_Stim_Cond{stim});
imagesc(Range(VHigh_Sp_Before_Stim_Cond{stim} , 's') , Spectro{3}(17:end) , zscore(D1(:,17:end)')); axis xy; caxis ([-1 1.5])
clear D1
subplot(326)
D2 = Data(VHigh_Sp_Around_Ripples_Ext{stim});
imagesc(Range(VHigh_Sp_Around_Ripples_Ext{stim} , 's') , Spectro{3}(17:end) , zscore(D2(:,17:end)')); axis xy; caxis ([-1 1.5])
clear D2









for stim = 1:length(Start(Epoch_Before_Stim))
    LFP_Averaged_Cond_RMS(stim,:) = Data(Restrict(LFP_rip_Cond_Filtered_RMS , subset(Epoch_Before_Stim,stim)));
end
for stim = 1:length(Start(Around_Ripples_Epoch))
    D = Data(Restrict(LFP_rip_Ext_Filtered_RMS , subset(Around_Ripples_Epoch,stim)));
    LFP_Averaged_Ext_RMS(stim,:) = D(1:249); clear D
end

figure
plot(nanmean(LFP_Averaged_Cond_RMS))
hold on
plot(nanmean(LFP_Averaged_Ext_RMS))






%% Spike2 stats



StimEpoch=thresholdIntervals(LFP,7e3,'Direction','Above');
Inhib_Epoch =  intervalSet(9e5 , max(Range(LFP)));
Non_Inhib_Epoch =  intervalSet(0 , 9e5);
StimEpoch=and(StimEpoch , Inhib_Epoch);
Start_Stim = Start(StimEpoch);
Start_Stim_2 = Start_Stim([true ; ~(abs(Start_Stim(2:end)-Start_Stim(1:end-1))<0.100e4)]);
StimEpoch2 = intervalSet(Start_Stim_2 , Start_Stim_2+20);

TTLInfo.StimEpoch2 = StimEpoch2;
save('behavResources_SB.mat','TTLInfo')


figure
plot(Range(LFP) , Data(LFP))
hold on
plot(Start(StimEpoch) , 1e4 , '*r')
plot(Start_Stim_2 , 1e4 , '*g')



Epoch_Before_Stim = ConcatenateDataFromFolders_SB({'/media/gruffalo/DataMOBs158/UMaze/1304/test/1304_test_220509_140053'} , 'before_stim_epoch');
VHigh_Sp_Cond_tsd = ConcatenateDataFromFolders_SB({'/media/gruffalo/DataMOBs158/UMaze/1304/test/1304_test_220509_140053'} , 'spectrum','prefix','H_VHigh');
FzEpoch_Cond = Inhib_Epoch;

Around_Ripples_Epoch = ConcatenateDataFromFolders_SB({'/media/gruffalo/DataMOBs158/UMaze/1304/test/1304_test_220509_140053'} , 'around_ripples_epoch');
VHigh_Sp_Ext_tsd = VHigh_Sp_Cond_tsd;
FzEpoch_Ext = Non_Inhib_Epoch;




for stim = 1:length(Start(Epoch_Before_Stim))
    VHigh_Sp_Before_Stim_Cond{stim} = Restrict(VHigh_Sp_Cond_tsd , subset(Epoch_Before_Stim , stim));
    D=Data(VHigh_Sp_Before_Stim_Cond{stim});
    VHigh_Sp_Before_Stim_Cond_Data(stim,:) = nanmean(D(:,54:78)); clear D
end
for stim = 1:length(Start(Around_Ripples_Epoch))
    VHigh_Sp_Around_Ripples_Ext{stim} = Restrict(VHigh_Sp_Ext_tsd , subset(Around_Ripples_Epoch , stim));
    D=Data(VHigh_Sp_Around_Ripples_Ext{stim});
    VHigh_Sp_Around_Ripples_Ext_Data(stim,:) = nanmean(D(:,54:78)); clear D
end


% imagesc of stim and ripples
load('H_VHigh_Spectrum.mat'); stim=0;
figure
stim=stim+1;

subplot(121)
D1 = Data(VHigh_Sp_Before_Stim_Cond{stim});
imagesc(Range(VHigh_Sp_Before_Stim_Cond{stim} , 's') , Spectro{3}(33:end) , zscore(D1(:,33:end)')); axis xy; caxis ([-1 1.5])
clear D1
subplot(122)
D2 = Data(VHigh_Sp_Around_Ripples_Ext{stim});
imagesc(Range(VHigh_Sp_Around_Ripples_Ext{stim} , 's') , Spectro{3}(33:end) , zscore(D2(:,33:end)')); axis xy; caxis ([-1 1.5])
clear D2


% Mean VHigh HPC Spectrum
figure
plot(Spectro{3} , nanmean(Data(VHigh_Sp_Cond_Fz))); set(gca, 'YScale', 'log');
hold on
plot(Spectro{3} , nanmean(Data(VHigh_Sp_Ext_Fz))); set(gca, 'YScale', 'log');
makepretty; xlabel('Frequency (Hz)'); ylabel('Power (log scale)'); legend('Cond / + inhib','Ext / - inhib'); 
title('HPC VHigh spectrum, freezing, +/- stims, Mouse 1304')


% Average power evolution between 150-220
figure
clf; stim=stim+1; 
D1 = Data(VHigh_Sp_Before_Stim_Cond{stim}); D1_bis = zscore(D1(:,33:end)');
plot(nanmean(D1_bis(22:46,:))); clear D1 D1_bis; hold on
D2 = Data(VHigh_Sp_Around_Ripples_Ext{stim}); D2_bis = zscore(D2(:,33:end)');
plot(nanmean(D2_bis(22:46,:))); clear D2 D2_bis; hold on
xlabel('time (a.u.)'); ylabel('power ripples frequency band')


for stim = 1:length(Start(Epoch_Before_Stim))
    D1 = Data(VHigh_Sp_Before_Stim_Cond{stim}); D1_bis = zscore(D1(:,33:end)');
    VHigh_Sp_Before_Stim_Cond_RipplesFreq(stim,:) = nanmean(D1_bis(22:46,1:41));
    clear D1 D1_bis;
end
for stim = 1:length(Start(Around_Ripples_Epoch))
    D2 = Data(VHigh_Sp_Around_Ripples_Ext{stim}); D2_bis = zscore(D2(:,33:end)');
    VHigh_Sp_Around_Ripples_Ext_Ripplesfreq(stim,:) = nanmean(D2_bis(22:46,1:41));
    clear D2 D2_bis;
end

figure
plot(nanmean(VHigh_Sp_Before_Stim_Cond_RipplesFreq))
hold on
plot(nanmean(VHigh_Sp_Around_Ripples_Ext_Ripplesfreq))
xlabel('time (a.u.)'); ylabel('power ripples frequency band')
makepretty; legend('ripples','stim')
vline(17,'--r')




