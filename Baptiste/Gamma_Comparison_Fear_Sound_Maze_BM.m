

Mouse=[244,243,253,258,259,299,394,395,403,450,451]; % with good gamma
Session_type={'sound_test'};
for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('sound_test',Mouse,lower(Session_type{sess}),...
        'ob_high');
end
OutPutData2 = OutPutData;

% load('/media/nas7/ProjetEmbReact/DataEmbReact/MeanSpectrum.mat')

Session_type={'Fear'};
for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
        'ob_high');
end


figure
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.ob_high.mean(:,5,:)) , 'color' , [1 .5 .5]); 
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.ob_high.mean(:,6,:)) , 'color' , [.5 .5 1]); 
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.sound_test.ob_high.mean([1:3 5:9 11:13],2,:)) , 'color' , [.5 1 .5]); 
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
makepretty
f=get(gca,'Children'); legend([f([9 5 1])],'Freezing shock','Freezing safe','Sound test');
xlim([30 100]), ylim([.2 1.2])


figure
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.ob_high.mean(:,7,:)) , 'color' , [1 .5 .5]); 
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.ob_high.mean(:,8,:)) , 'color' , [.5 .5 1]); 
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.sound_test.ob_high.mean([1:2 8 9 11 13],3,:)) , 'color' , [.5 1 .5]); 
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
makepretty
f=get(gca,'Children'); legend([f([9 5 1])],'Freezing shock','Freezing safe','Sound test');
xlim([30 100]), ylim([.2 1.2])

figure
subplot(131)
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.ob_high.mean(:,5,:)) , 'color' , [1 .5 .5]); 
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.ob_high.mean(:,7,:)) , 'color' , [.7 .3 .3]); 
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
makepretty
f=get(gca,'Children'); legend([f([5 1])],'Freezing','Active');
xlim([30 100]), ylim([.2 1.2])
title('Shock')

subplot(132)
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.ob_high.mean(:,6,:)) , 'color' , [.5 .5 1]); 
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.ob_high.mean(:,8,:)) , 'color' , [.3 .3 .7]); 
xlabel('Frequency (Hz)')
makepretty
f=get(gca,'Children'); legend([f([5 1])],'Freezing','Active');
xlim([30 100]), ylim([.2 1.2])
title('Safe')

subplot(133)
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.sound_test.ob_high.mean([1:3 5:9 11:13],2,:)) , 'color' , [.5 1 .5]); 
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.sound_test.ob_high.mean([1:2 8 9 11 13],3,:)) , 'color' , [.3 .7 .3]); 
xlabel('Frequency (Hz)')
makepretty
f=get(gca,'Children'); legend([f([5 1])],'Freezing','Active');
xlim([30 100]), ylim([.2 1.2])
title('Sound Test')






