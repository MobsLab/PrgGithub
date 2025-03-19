for imouse=1:length(Dir{2}.path)
    cd(Dir{2}.path{imouse}{1});
figure, subplot(1,5,[1,2]), imagesc(temps, freq{1}, SpectroREM_Opto{imouse}), axis xy, colormap(jet), caxis([0 5]), xlim([-60 60])
line([0 0], ylim,'color','w','linestyle','-')
colorbar
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Average HPC spectrogram for stims occuring in REM sleep')
subplot(153), PlotErrorBarN_KJ({mean(mean(ThetaBandREM_Opto_Before15{imouse})), mean(mean(ThetaBandREM_Opto_During15{imouse}))},'newfig',0,'paired',1,'ShowSigstar','sig','showPoints',0);
ylabel('theta power')
xticks(1:2)
ylim([0 4])
xticklabels({'Before','During'});
title('time window : 0-10sec')

subplot(154), PlotErrorBarN_KJ({mean(mean(ThetaBandREM_Opto_Before20{imouse})), mean(mean(ThetaBandREM_Opto_During20{imouse}))},'newfig',0,'paired',1,'ShowSigstar','sig','showPoints',0);
ylabel('theta power')
xticks(1:2)
ylim([0 4])

xticklabels({'Before','During'});
title('time window : 0-20sec')

subplot(155), PlotErrorBarN_KJ({mean(mean(ThetaBandREM_Opto_Before520{imouse})), mean(mean(ThetaBandREM_Opto_During520{imouse}))},'newfig',0,'paired',1,'ShowSigstar','sig','showPoints',0);
ylabel('theta power')
xticks(1:2)
ylim([0 4])

xticklabels({'Before','During'});
title('time window : 5-20sec')
end

 

    