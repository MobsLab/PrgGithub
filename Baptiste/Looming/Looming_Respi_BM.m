
cd('/media/nas7/Looming/1482')
cd('/media/nas7/Looming/1439')

load('behavResources.mat', 'MovAcctsd')
NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),30));
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,4e7,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,.5*1e4);

NewMovAcctsd_Fz = Restrict(NewMovAcctsd , FreezeAccEpoch);

Fz_Dur = sum(DurationEpoch(FreezeAccEpoch))/1e4;

figure
clf
plot(Range(NewMovAcctsd,'s') , Data(NewMovAcctsd))
hold on
plot(Range(NewMovAcctsd_Fz,'s') , Data(NewMovAcctsd_Fz))
vline([170 200 300 340])
xlabel('time (s)'), ylabel('Acc values (a.u.)')

OB_Spec = load('B_Low_Spectrum.mat');
OB_sptsd = tsd(OB_Spec.Spectro{2}*1e4 , OB_Spec.Spectro{1});

OB_Sp_Fz = Restrict(OB_sptsd , NewMovAcctsd_Fz);


figure
imagesc(linspace(0,Fz_Dur,length(Data(OB_Sp_Fz))) , OB_Spec.Spectro{3} , SmoothDec(10*log10(Data(OB_Sp_Fz)),.7)'), axis xy, caxis([45 59])
xlabel('time (s)'), ylabel('Frequency (Hz)')
title('OB Low during freezing')

Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(OB_Spec.Spectro{3} , Range(OB_Sp_Fz) , Data(OB_Sp_Fz) , 40);

figure
plot(linspace(0,Fz_Dur,length(Data(Spectrum_Frequency))) , Data(Spectrum_Frequency))
xlabel('time (s)'), ylabel('Frequency (Hz)')
title('Respi during freezing')

% imagesc(Range(OB_Sp_Fz) , OB_Spec.Spectro{3} , (OB_Spec.Spectro{3}.*Data(OB_Sp_Fz))'), axis xy






