


Mouse=1189;
Session_type={'Cond'};
for sess=1
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = ...
        MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ob_low');
end

OB_shock = CleanSpectro(OutPutData.Cond.ob_low.spectrogram{5} , Spectro{3} , 8);
OB_safe = CleanSpectro(OutPutData.Cond.ob_low.spectrogram{6} , Spectro{3} , 5);


figure
subplot(211)
imagesc(linspace(0,sum(DurationEpoch(Epoch1.Cond{5}))/1e4,length(Range(OB_shock))) ,...
    Spectro{3} , runmean(runmean(log10(Data(OB_shock))',5)',10)')
axis xy, yticks([0:2:10])
ylim([0 10]), ylabel('Frequency (Hz)'), caxis([4.2 6]), hline(4,'-k')
makepretty

subplot(212)
imagesc(linspace(0,sum(DurationEpoch(Epoch1.Cond{6}))/1e4,length(Range(OB_safe))) ,...
    Spectro{3} , runmean(runmean(log10(Data(OB_safe))',5)',10)')
axis xy, yticks([0:2:10])
ylim([0 10]), xlabel('time (s)'), ylabel('Frequency (Hz)'), caxis([4.2 6]), hline(4,'-k')
makepretty


