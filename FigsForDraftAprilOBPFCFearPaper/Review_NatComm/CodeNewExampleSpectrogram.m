cd D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse259_20151204-EXT-24h-envC\20151204-EXT-24h-envC
load('behavResources.mat')
% StFr = Start(FreezeEpoch);
% StpFr = Stop(FreezeEpoch);

load('B_Low_Spectrum.mat')
subplot(311)
imagesc(Spectro{2},Spectro{3},log(Spectro{1})')
% line([StFr,StpFr]'/1E4,[StFr,StpFr]'*0 +12,'linewidth',5,'color','k')
caxis([7 15])
axis xy
xlim([1100 1400])

subplot(312)
load('PFCx_Low_Spectrum.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1})')
% line([StFr,StpFr]'/1E4,[StFr,StpFr]'*0 +12,'linewidth',5,'color','k')
caxis([4 12])
axis xy
xlim([1100 1400])

subplot(313)
load('D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse259_20151204-EXT-24h-envC\20151204-EXT-24h-envC\CohgramcDataL\Cohgram_13_8.mat')
imagesc(Spectro{2},Spectro{3},C')
axis xy
xlim([1100 1400])

imagesc(Spectro{2},Spectro{3},SmoothDec(C',[1.5 1]))
caxis([-0.3 1.3])
xlim([1100 1400])
axis xy


cd D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse299_20151217-EXT-24h-envC\20151217-EXT-24h-envC
load('B_Low_Spectrum.mat')
subplot(311)
imagesc(Spectro{2},Spectro{3},log(Spectro{1})')
% line([StFr,StpFr]'/1E4,[StFr,StpFr]'*0 +12,'linewidth',5,'color','k')
caxis([4 12])
axis xy
xlim([590 870])

subplot(312)
load('PFCx_Low_Spectrum.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1})')
% line([StFr,StpFr]'/1E4,[StFr,StpFr]'*0 +12,'linewidth',5,'color','k')
caxis([4 12])
axis xy
xlim([590 870])

subplot(313)
load('D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse299_20151217-EXT-24h-envC\20151217-EXT-24h-envC\CohgramcDataL\Cohgram_30_28.mat')
imagesc(Spectro{2},Spectro{3},SmoothDec(C',[1.5 1]))
caxis([-0.3 1.3])
xlim([590 870])
axis xy
