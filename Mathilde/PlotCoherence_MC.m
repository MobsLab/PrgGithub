function [Coh_VLPO_PFC_deep,Cohtsd_VLPO_PFC_deep] = GetCoherence_MC(Wake, REMEpoch, SWSEpoch)

load VLPO_PFCx_deep_Low_Coherence.mat Coherence
Coh_VLPO_PFC_deep=Coherence;
Cohtsd_VLPO_PFC_deep = tsd(Coh_VLPO_PFC_deep{2}*1e4,Coh_VLPO_PFC_deep{1});
% clear Coherence
% load VLPO_PFCx_sup_Low_Coherence.mat
% Coherence2=Coherence;
% Cohtsd2 = tsd(Coherence2{2}*1e4,Coherence2{1});
% clear Coherence
% load Bulb_PFCx_sup_Low_Coherence.mat
% Coherence3=Coherence;
% Cohtsd3 = tsd(Coherence3{2}*1e4,Coherence3{1});

end

% 
% % plot
% figure, subplot(131), plot(Coh_VLPO_PFC_deep{3},nanmean(Data(Restrict(Cohtsd_VLPO_PFC_deep,Wake))),'b')
% hold on
% plot(Coherence1{3},nanmean(Data(Restrict(Cohtsd_VLPO_PFC_deep,SWSEpoch))),'r')
% hold on
% plot(Coherence1{3},mean(Data(Restrict(Cohtsd_VLPO_PFC_deep,REMEpoch))),'g')
% % legend('wake','NREM','REM')
% title('VLPO PFC deep coherence')
% ylim([0.4 0.95])
% 
% subplot(132), plot(Coherence2{3},nanmean(Data(Restrict(Cohtsd2,Wake))),'b')
% hold on
% plot(Coherence2{3},nanmean(Data(Restrict(Cohtsd2,SWSEpoch))),'r')
% hold on
% plot(Coherence2{3},mean(Data(Restrict(Cohtsd2,REMEpoch))),'g')
% % legend('wake','NREM','REM')
% title('VLPO PFC sup coherence')
% ylim([0.4 0.95])
% subplot(133), plot(Coherence3{3},nanmean(Data(Restrict(Cohtsd3,Wake))),'b')
% hold on
% plot(Coherence3{3},nanmean(Data(Restrict(Cohtsd3,SWSEpoch))),'r')
% hold on
% plot(Coherence3{3},mean(Data(Restrict(Cohtsd3,REMEpoch))),'g')
% legend('wake','NREM','REM')
% title('Bulb PFC sup coherence')
% ylim([0.4 0.95])



% 
% load ExpeInfo
% load SleepScoring_OBGamma.mat
% load VLPO_PFCx_deep_Low_Coherence.mat Coherence
% Coherence1=Coherence;
% Cohtsd1 = tsd(Coherence1{2}*1e4,Coherence1{1});
% clear Coherence
% load VLPO_PFCx_sup_Low_Coherence.mat
% Coherence2=Coherence;
% Cohtsd2 = tsd(Coherence2{2}*1e4,Coherence2{1});
% clear Coherence
% load Bulb_PFCx_sup_Low_Coherence.mat
% Coherence3=Coherence;
% Cohtsd3 = tsd(Coherence3{2}*1e4,Coherence3{1});
% 
% % Spectsd_PFC = tsd(SingleSpectro.ch2{2}*1e4,SingleSpectro.ch2{1});
% % Spectsd_VLPO = tsd(SingleSpectro.ch1{2}*1e4,SingleSpectro.ch1{1});
% 
% figure, subplot(131), plot(Coherence1{3},nanmean(Data(Restrict(Cohtsd1,Wake))),'b')
% hold on
% plot(Coherence1{3},nanmean(Data(Restrict(Cohtsd1,SWSEpoch))),'r')
% hold on
% plot(Coherence1{3},mean(Data(Restrict(Cohtsd1,REMEpoch))),'g')
% % legend('wake','NREM','REM')
% title('VLPO PFC deep coherence')
% ylim([0.4 0.95])
% 
% subplot(132), plot(Coherence2{3},nanmean(Data(Restrict(Cohtsd2,Wake))),'b')
% hold on
% plot(Coherence2{3},nanmean(Data(Restrict(Cohtsd2,SWSEpoch))),'r')
% hold on
% plot(Coherence2{3},mean(Data(Restrict(Cohtsd2,REMEpoch))),'g')
% % legend('wake','NREM','REM')
% title('VLPO PFC sup coherence')
% ylim([0.4 0.95])
% subplot(133), plot(Coherence3{3},nanmean(Data(Restrict(Cohtsd3,Wake))),'b')
% hold on
% plot(Coherence3{3},nanmean(Data(Restrict(Cohtsd3,SWSEpoch))),'r')
% hold on
% plot(Coherence3{3},mean(Data(Restrict(Cohtsd3,REMEpoch))),'g')
% legend('wake','NREM','REM')
% title('Bulb PFC sup coherence')
% ylim([0.4 0.95])
% suptitle([' ',num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse)])
% 
