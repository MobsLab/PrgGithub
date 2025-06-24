


load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat')




for mouse=1:length(Mouse)
    Rip = OutPutData.Cond.ripples_density.tsd{mouse,3};
    Respi = OutPutData.Cond.respi_freq_bm.tsd{mouse,3};
    Rip_corr = Restrict(Rip , Respi);
    D1 = Data(Respi);
    D2 = Data(Rip_corr);
    if and(nanmean(D2)~=0 , ~isnan(nanmean(D2)))
        [r1(mouse,:) , lags] = xcorr(D1(~isnan(D1)) , 100 , 'coeff');
        [r2(mouse,:) , lags] = xcorr(D2(~isnan(D2)) , 100 , 'coeff');
        [r3(mouse,:) , lags] = xcorr(D1(and(~isnan(D1) , ~isnan(D2))) , D2(and(~isnan(D1) , ~isnan(D2))) , 100);
    end
end
r1(nanmean(r1')==0,:) = [];
r2(nanmean(r2')==0,:) = [];
r3(nanmean(r3')==0,:) = [];

figure
subplot(231)
Data_to_use = zscore(r1')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar([-20:.2:20] , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
vline(0,'--k')
makepretty
xlabel('time (s)'), ylabel('R values')
title('Auto-corr respi')

subplot(234)
imagesc([-20:.2:20] , [1:size(r3,1)] , zscore(r1')')
makepretty
xlabel('time (s)'), ylabel('mice (#)')


subplot(232)
Data_to_use = zscore(r2')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar([-20:.2:20] , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
vline(0,'--k')
makepretty
xlabel('time (s)'), ylabel('R values')
title('Auto-corr SWR')

subplot(235)
imagesc([-20:.2:20] , [1:size(r2,1)] , zscore(r2')')
makepretty
xlabel('time (s)'), ylabel('mice (#)')


subplot(233)
Data_to_use = zscore(r3')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar([-20:.2:20] , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
vline(0,'--k')
makepretty
xlabel('time (s)'), ylabel('R values')
title('Cross-corr Respi-SWR')

subplot(236)
imagesc([-20:.2:20] , [1:size(r3,1)] , zscore(r3')')
makepretty
xlabel('time (s)'), ylabel('mice (#)')

colormap viridis




