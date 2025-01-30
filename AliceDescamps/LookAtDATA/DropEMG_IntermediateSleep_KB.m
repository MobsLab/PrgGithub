tH=HPC_CNO{k}.Spectro{2};
fH=HPC_CNO{k}.Spectro{3};
spH=HPC_CNO{k}.Spectro{1};
StsdH=tsd(tH1E4,spH);

tP=PFC_CNO{k}.Spectro{2};
fP=PFC_CNO{k}.Spectro{3};
spP=PFC_CNO{k}.Spectro{1};
StsdP=tsd(tP1E4,spP);

tO=OBhigh_CNO{k}.Spectro{2};
fO=OBhigh_CNO{k}.Spectro{3};
spO=OBhigh_CNO{k}.Spectro{1};
StsdO=tsd(tO1E4,spO);

wake=sleepStage_CNO{k}.Wake;
sws=sleepStage_CNO{k}.SWSEpoch;
rem=sleepStage_CNO{k}.REMEpoch;

try, emg=Data(EMG_CNO{k});end
try,PowEMG=runmean(abs(emg),10);end

for i=1:length(Start(rem))
    tstimes=ts(Start(subset(rem,i)));
    figure,
    subplot(5,1,1),
    [Mo,So,to]=AverageSpectrogram(StsdO,fO,tstimes,400,1000,2);caxis([0 0.021E5]), title([num2str(k),', ',num2str(i)]), ylabel('OK high')
    subplot(5,1,2),
    [Mh,Sh,th]=AverageSpectrogram(StsdH,fH,tstimes,400,1000,2);caxis([0 0.31E6]), ylabel('HPC')
    subplot(5,1,3),
    [Mp,Sp,tp]=AverageSpectrogram(StsdP,fP,tstimes,400,1000,2);caxis([0 0.31E5]), ylabel('PFC')
    subplot(5,1,4),
    imagesc(tp/1E3,fP,SmoothDec(zscore(Mp')',[1 1])), axis xy, caxis([-2 2])
    subplot(5,1,5),
    [m,s,tps]=mETAverage(Range(tstimes),Range(EMG_CNO{k}),10*log10(PowEMG),400,1000);
    plot(tps/1E3,m,'linewidth',2), ylabel('EMG')
    line([0 0],ylim,'color','k','linestyle',':'), ylim([40 60])
end