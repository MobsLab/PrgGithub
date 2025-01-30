%PlotSleepScoring


load StateEpoch

Sp=Spectro{1};
t=Spectro{2};
f=Spectro{3};

ratio_display_mov=(max(Data(ThetaRatioTSD))-min(Data(ThetaRatioTSD)))/(max(Data(Mmov))-min(Data(Mmov)));

figure('color',[1 1 1]),Gf=gcf;
subplot(2,1,1),imagesc(t,f,10*log10(Sp)'), axis xy;
title('Spectrogramm');

figure(Gf), subplot(2,1,2), hold off, plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2); xlim([0,max(Range(ThetaRatioTSD,'s'))]);
hold on, subplot(2,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+5,'b');
hold on, plot(Range(Restrict(Mmov,MovEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,MovEpoch))+5,'c');
subplot(2,1,2), line([Start(SWSEpoch,'s') Start(SWSEpoch,'s')],[0 10],'color','r','linewidth',1)
hold on, plot(Range(Restrict(Mmov,SWSEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,SWSEpoch))+5,'r');
if isempty(Start(REMEpoch))==0
subplot(2,1,2), line([Start(REMEpoch,'s') Start(REMEpoch,'s')],[0 10],'color','g','linewidth',1)
hold on, plot(Range(Restrict(Mmov,REMEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,REMEpoch))+5,'g');
RgREMEpoch=Start(REMEpoch,'s');
for i=1:length(Start(REMEpoch))
hold on, text(RgREMEpoch(i),9,num2str(i),'Color','g')
end
end
title('Wake=cyan, SWS=red, REM=green');

subplot(2,1,1), line([Start(SWSEpoch,'s') Start(SWSEpoch,'s')],[0 20],'color','k','linewidth',2)
subplot(2,1,1), line([End(SWSEpoch,'s') End(SWSEpoch,'s')],[0 20],'color','b','linewidth',2)
subplot(2,1,1), line([Start(REMEpoch,'s') Start(REMEpoch,'s')],[0 20],'color','r','linewidth',2)
subplot(2,1,1), line([End(REMEpoch,'s') End(REMEpoch,'s')],[0 20],'color','m','linewidth',2)


% 
% figure('color',[1 1 1]),Gf=gcf;
% subplot(2,1,1),imagesc(t,f,10*log10(Sp)'), axis xy,
% figure(Gf), subplot(2,1,2), hold off, plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
% hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2); xlim([0,max(Range(ThetaRatioTSD,'s'))]);
% hold on, subplot(2,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+5,'b');
% hold on, plot(Range(Restrict(Mmov,MovEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,MovEpoch))+5,'c');
% subplot(2,1,2), line([Start(SWSEpoch,'s') Start(SWSEpoch,'s')],[0 10],'color','r','linewidth',1)
% hold on, plot(Range(Restrict(Mmov,SWSEpoch),'s'),rescale(Data(Restrict(Mmov,SWSEpoch))+5,10,15),'r');
% if isempty(Start(REMEpoch))==0
% subplot(2,1,2), line([Start(REMEpoch,'s') Start(REMEpoch,'s')],[0 10],'color','g','linewidth',1)
% hold on, plot(Range(Restrict(Mmov,REMEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,REMEpoch))+5,'g');
% RgREMEpoch=Start(REMEpoch,'s');
% for i=1:length(Start(REMEpoch))
% hold on, text(RgREMEpoch(i),9,num2str(i),'Color','g')
% end
% end
% title('Wake=cyan, SWS=red, REM=green');
% 
% 
% figure(Gf), subplot(2,1,2), hold off, plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
% hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2); xlim([0,max(Range(ThetaRatioTSD,'s'))]);
% hold on, subplot(2,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+5,'b');
% hold on, plot(Range(Restrict(Mmov,MovEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,MovEpoch))+5,'c');
% subplot(2,1,2), line([Start(SWSEpoch,'s') Start(SWSEpoch,'s')],[0 10],'color','r','linewidth',1)
% hold on, plot(Range(Restrict(Mmov,SWSEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,SWSEpoch))+5,'r');
% if isempty(Start(REMEpoch))==0
% subplot(2,1,2), line([Start(REMEpoch,'s') Start(REMEpoch,'s')],[0 10],'color','g','linewidth',1)
% hold on, plot(Range(Restrict(Mmov,REMEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,REMEpoch))+5,'g');
% end
% title('Wake=cyan, SWS=red, REM=green');
