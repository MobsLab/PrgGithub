

load('B_High_Spectrum.mat')

figure
imagesc(Spectro{2} , Spectro{3} ,Spectro{1}'), axis xy, caxis([0 4e3])

Pre_Inj = intervalSet(0,6e7);
Post_Inj = intervalSet(6e7,14.68e7);


Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});

Sp_Pre_Wake = Restrict(Sp_tsd,and(Pre_Inj,Wake));
Sp_Post_Wake = Restrict(Sp_tsd,and(Post_Inj,Wake));

figure
plot(Spectro{3} , nanmean(Data(Sp_Pre_Wake)))
hold on
plot(Spectro{3} , nanmean(Data(Sp_Post_Wake)))



Sp_Sleep = Restrict(Sp_tsd,Sleep);
Sp_REM = Restrict(Sp_tsd,and(Sleep,Epoch_01_05));
Sp_NREM = Restrict(Sp_tsd,and(Sleep,Sleep-Epoch_01_05));


figure
imagesc(Range(Sp_Sleep,'s') , Spectro{3} , Data(Sp_Sleep)'), axis xy, caxis([0 4e3])

figure
plot(Spectro{3} , nanmean(Data(Sp_NREM)))
hold on
plot(Spectro{3} , nanmean(Data(Sp_REM)))

%%






LowSpectrumSB([cd filesep],1,'Ref')

figure
subplot(211)
imagesc(Spectro{2}/60 , Spectro{3} , log10(Spectro{1})'), axis xy
subplot(212)
imagesc(Spectro{2}/60 , Spectro{3} , log10(Spectro{1})'), axis xy








