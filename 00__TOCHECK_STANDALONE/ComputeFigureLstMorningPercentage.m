% ComputeFigureLstMorningPercentage

% close all; [ResTones1,Res1,r1z1,p1z1,r2z1,p2z1,TT2n1,TT4n1]=ParcoursQuantifTonesDeltaCorticesRipples(0,'DeltaTone',2,0);
% close all, [ResTones2,Res2,r1z2,p1z2,r2z2,p2z2,TT2n2,TT4n2]=ParcoursQuantifTonesDeltaCorticesRipples(0,'DeltaT140',2,0);
% close all, [ResTones3,Res3,r1z3,p1z3,r2z3,p2z3,TT2n3,TT4n3]=ParcoursQuantifTonesDeltaCorticesRipples(0,'DeltaT200',2,0);
% close all, [ResTones4,Res4,r1z4,p1z4,r2z4,p2z4,TT2n4,TT4n4]=ParcoursQuantifTonesDeltaCorticesRipples(0,'DeltaT320',2,0);
% close all, [ResTones5,Res5,r1z5,p1z5,r2z5,p2z5,TT2n5,TT4n5]=ParcoursQuantifTonesDeltaCorticesRipples(0,'DeltaT480',2,0);
% close all, [ResTones6,Res6,r1z6,p1z6,r2z6,p2z6,TT2n6,TT4n6]=ParcoursQuantifTonesDeltaCorticesRipples(0,'RdmTone',2,0);
% close all, [ResTones7,Res7,r1z7,p1z7,r2z7,p2z7,TT2n7,TT4n7]=ParcoursQuantifTonesDeltaCorticesRipples(0,'BASAL',2,0);
% close all
% 
% cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  
% save DataFigureLstMorningPercentage


cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  
load DataFigureLstMorningPercentage


sav=0;


idOK1=find(ResTones1(:,6)<35);
idOK2=find(ResTones2(:,6)<35);
idOK3=find(ResTones3(:,6)<35);
idOK4=find(ResTones4(:,6)<35);
idOK5=find(ResTones5(:,6)<35);
idOK6=find(ResTones6(:,6)<35);

PlotErrorBarN(ResTones1(idOK1,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('DeltaTone')
PlotErrorBarN(ResTones2(idOK2,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('DeltaT140')
PlotErrorBarN(ResTones3(idOK3,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('DeltaT200')
PlotErrorBarN(ResTones4(idOK4,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('DeltaT320')
PlotErrorBarN(ResTones5(idOK5,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('DeltaT480')
PlotErrorBarN(ResTones6(idOK6,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('RdmTone')


PlotErrorBarN(ResTones1(:,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('DeltaTone')
PlotErrorBarN(ResTones2(:,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('DeltaT140')
PlotErrorBarN(ResTones3(:,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('DeltaT200')
PlotErrorBarN(ResTones4(:,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('DeltaT320')
PlotErrorBarN(ResTones5(:,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('DeltaT480')
PlotErrorBarN(ResTones6(:,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds'), ylim([0 35]), title('RdmTone')

% if sav
% saveFigure(1,'FigureLastMorning17','/media/DISK_1/Dropbox/MOBS_workingON/PhD_Manuscrip_GdL/Figures Projet DeltaFeedback/FigFRomK')
% saveFigure(2,'FigureLastMorning18','/media/DISK_1/Dropbox/MOBS_workingON/PhD_Manuscrip_GdL/Figures Projet DeltaFeedback/FigFRomK')
% saveFigure(3,'FigureLastMorning19','/media/DISK_1/Dropbox/MOBS_workingON/PhD_Manuscrip_GdL/Figures Projet DeltaFeedback/FigFRomK')
% saveFigure(4,'FigureLastMorning20','/media/DISK_1/Dropbox/MOBS_workingON/PhD_Manuscrip_GdL/Figures Projet DeltaFeedback/FigFRomK')
% saveFigure(5,'FigureLastMorning21','/media/DISK_1/Dropbox/MOBS_workingON/PhD_Manuscrip_GdL/Figures Projet DeltaFeedback/FigFRomK')
% saveFigure(6,'FigureLastMorning22','/media/DISK_1/Dropbox/MOBS_workingON/PhD_Manuscrip_GdL/Figures Projet DeltaFeedback/FigFRomK')
% saveFigure(7,'FigureLastMorning23','/media/DISK_1/Dropbox/MOBS_workingON/PhD_Manuscrip_GdL/Figures Projet DeltaFeedback/FigFRomK')
% saveFigure(8,'FigureLastMorning24','/media/DISK_1/Dropbox/MOBS_workingON/PhD_Manuscrip_GdL/Figures Projet DeltaFeedback/FigFRomK')
% saveFigure(9,'FigureLastMorning25','/media/DISK_1/Dropbox/MOBS_workingON/PhD_Manuscrip_GdL/Figures Projet DeltaFeedback/FigFRomK')
% saveFigure(10,'FigureLastMorning26','/media/DISK_1/Dropbox/MOBS_workingON/PhD_Manuscrip_GdL/Figures Projet DeltaFeedback/FigFRomK')
% end

eval(['load ParcoursQuantifTonesDeltaCorticesRipples','DeltaTone','Tone','2 M2'])
tps=M2{2}(:,1);

smo=0.7;
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z1,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaTone S1')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z2,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT140 S1')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z3,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT200 S1')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z4,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT320 S1')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z5,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT480 S1')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z6,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('RdmTone S1')
% 
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z1,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaTone S2')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z2,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT140 S2')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z3,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT200 S2')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z4,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT320 S2')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z5,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT480 S2')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z6,[smo smo])), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('RdmTone S2')

for i=1:length(r1z1)
    r1z1(i,i)=1;
    r1z2(i,i)=1;
    r1z3(i,i)=1;
    r1z4(i,i)=1;
    r1z5(i,i)=1;
    r1z6(i,i)=1;
    
    r2z1(i,i)=1;
    r2z2(i,i)=1;
    r2z3(i,i)=1;
    r2z4(i,i)=1;
    r2z5(i,i)=1;
    r2z6(i,i)=1;
    
    p1z1(i,i)=0;
    p1z2(i,i)=0;
    p1z3(i,i)=0;
    p1z4(i,i)=0;
    p1z5(i,i)=0;
    p1z6(i,i)=0;
    
    p2z1(i,i)=0;
    p2z2(i,i)=0;
    p2z3(i,i)=0;
    p2z4(i,i)=0;
    p2z5(i,i)=0;
    p2z6(i,i)=0;
    
end

r1z1(p1z1>0.05)=0;
r1z2(p1z2>0.05)=0;
r1z3(p1z3>0.05)=0;
r1z4(p1z4>0.05)=0;
r1z5(p1z5>0.05)=0;
r1z6(p1z6>0.05)=0;

r2z1(p2z1>0.05)=0;
r2z2(p2z2>0.05)=0;
r2z3(p2z3>0.05)=0;
r2z4(p2z4>0.05)=0;
r2z5(p2z5>0.05)=0;
r2z6(p2z6>0.05)=0;

figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z1,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaTone S1'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT2n1')'),-0.6,0.4),'k')
figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z2,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT140 S1'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT2n2')'),-0.6,0.4),'k')
figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z3,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT200 S1'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT2n3')'),-0.6,0.4),'k')
figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z4,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT320 S1'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT2n4')'),-0.6,0.4),'k')
figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z5,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT480 S1'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT2n5')'),-0.6,0.4),'k')
figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r1z6,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('RdmTone S1'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT2n6')'),-0.6,0.4),'k')

figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z1,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaTone S2'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT4n1')'),-0.6,0.4),'k')
figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z2,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT140 S2'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT4n2')'),-0.6,0.4),'k')
figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z3,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT200 S2'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT4n3')'),-0.6,0.4),'k')
figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z4,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT320 S2'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT4n4')'),-0.6,0.4),'k')
figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z5,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT480 S2'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT4n5')'),-0.6,0.4),'k')
figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(r2z6,[smo smo])), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('RdmTone S2'), axis xy, hold on, plot(tps,rescale(nanmean(zscore(TT4n6')'),-0.6,0.4),'k')

% 
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p1z1,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaTone S1')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p1z2,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT140 S1')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p1z3,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT200 S1')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p1z4,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT320 S1')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p1z5,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT480 S1')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p1z6,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('RdmTone S1')
% 
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p2z1,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaTone S2')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p2z2,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT140 S2')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p2z3,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT200 S2')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p2z4,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT320 S2')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p2z5,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('DeltaT480 S2')
% figure('color',[1 1 1]), imagesc(tps,tps,SmoothDec(p2z6,[smo smo])), caxis([0 0.05]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar, title('RdmTone S2')


    idxAft=find(tps>0.08&tps<0.14);
    idxBef=find(tps>-0.05&tps<0);
    
      figure('color',[1 1 1])
    subplot(6,2,1), PlotErrorBar2(mean(TT2n1(:,idxBef),2),mean(TT2n1(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n1(:,idxBef),2),mean(TT2n1(:,idxAft),2)); title(num2str(p))
    subplot(6,2,2), PlotErrorBar2(mean(TT4n1(:,idxBef),2),mean(TT4n1(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n1(:,idxBef),2),mean(TT2n1(:,idxAft),2)); title(num2str(p))
    
    subplot(6,2,3), PlotErrorBar2(mean(TT2n2(:,idxBef),2),mean(TT2n2(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n2(:,idxBef),2),mean(TT2n2(:,idxAft),2)); title(num2str(p))
    subplot(6,2,4), PlotErrorBar2(mean(TT4n2(:,idxBef),2),mean(TT4n2(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n2(:,idxBef),2),mean(TT2n2(:,idxAft),2)); title(num2str(p))
    
    subplot(6,2,5), PlotErrorBar2(mean(TT2n3(:,idxBef),2),mean(TT2n3(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n3(:,idxBef),2),mean(TT2n3(:,idxAft),2)); title(num2str(p))
    subplot(6,2,6), PlotErrorBar2(mean(TT4n3(:,idxBef),2),mean(TT4n3(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n3(:,idxBef),2),mean(TT2n3(:,idxAft),2)); title(num2str(p))
    
    subplot(6,2,7), PlotErrorBar2(mean(TT2n4(:,idxBef),2),mean(TT2n4(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n4(:,idxBef),2),mean(TT2n4(:,idxAft),2)); title(num2str(p))
    subplot(6,2,8), PlotErrorBar2(mean(TT4n4(:,idxBef),2),mean(TT4n4(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n4(:,idxBef),2),mean(TT2n4(:,idxAft),2)); title(num2str(p))
    
    subplot(6,2,9), PlotErrorBar2(mean(TT2n5(:,idxBef),2),mean(TT2n5(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n5(:,idxBef),2),mean(TT2n5(:,idxAft),2)); title(num2str(p))
    subplot(6,2,10), PlotErrorBar2(mean(TT4n5(:,idxBef),2),mean(TT4n5(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n5(:,idxBef),2),mean(TT2n5(:,idxAft),2)); title(num2str(p))
    
    subplot(6,2,11), PlotErrorBar2(mean(TT2n6(:,idxBef),2),mean(TT2n6(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n6(:,idxBef),2),mean(TT2n6(:,idxAft),2)); title(num2str(p))
    subplot(6,2,12), PlotErrorBar2(mean(TT4n6(:,idxBef),2),mean(TT4n6(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2n6(:,idxBef),2),mean(TT2n6(:,idxAft),2)); title(num2str(p))
    
    
    
    
    k=0;
k=k+1; ti{k}='SPW-Rs';
k=k+1; ti{k}='Down';
k=k+1; ti{k}='Delta Pfc';
k=k+1; ti{k}='Delta Pac';
k=k+1; ti{k}='Delta Moc';
k=k+1; ti{k}='SWS';
k=k+1; ti{k}='REM';
k=k+1; ti{k}='Wake'; 
k=k+1; ti{k}='SPW with tones'; 
k=k+1; ti{k}='SPW without tones'; 
k=k+1; ti{k}='Down with tones'; 
k=k+1; ti{k}='Down without tones'; 
k=k+1; ti{k}='Delta Pfc with tones'; 
k=k+1; ti{k}='Delta Pfc without tones'; 
k=k+1; ti{k}='Delta Pac with tones'; 
k=k+1; ti{k}='Delta Pac without tones'; 
k=k+1; ti{k}='Delta Moc with tones'; 
k=k+1; ti{k}='Delta Moc without tones'; 
   a=1;
   figure('color',[1 1 1])
   for i=1:5:90
   subplot(3,6,a), PlotErrorBarN(Res1(:,i:i+4),0);try, title(['DeltaTone, ',ti{a}]), end
   a=a+1;
   end
   
   a=1;
   figure('color',[1 1 1])
   for i=1:5:90
   subplot(3,6,a), PlotErrorBarN(Res1(:,i:i+4)./Res1(:,26:30),0);try, title(['DeltaTone, ',ti{a}]), end
   a=a+1;
   end
   

   
   a=1;
   figure('color',[1 1 1])
   for i=1:5:90
   subplot(3,6,a), PlotErrorBarN(Res7(:,i:i+4),0);try, title(['BASAL, ',ti{a}]), end
   a=a+1;
   end
   
   a=1;
   figure('color',[1 1 1])
   for i=1:5:90
   subplot(3,6,a), PlotErrorBarN(Res7(:,i:i+4)./Res7(:,26:30),0);try, title(['BASAL, ',ti{a}]), end
   a=a+1;
   end
   
     
   
   
   

% k=0;
% k=k+1; ti{k}='SPW-Rs';    1
% k=k+1; ti{k}='Down';      2
% k=k+1; ti{k}='Delta Pfc'; 3
% k=k+1; ti{k}='Delta Pac'; 4
% k=k+1; ti{k}='Delta Moc'; 5
% k=k+1; ti{k}='SWS';       6
% k=k+1; ti{k}='REM';       7
% k=k+1; ti{k}='Wake';      8
% k=k+1; ti{k}='SPW with tones';       9 
% k=k+1; ti{k}='SPW without tones';    10
% k=k+1; ti{k}='Down with tones';      11
% k=k+1; ti{k}='Down without tones';   12
% k=k+1; ti{k}='Delta Pfc with tones'; 13
% k=k+1; ti{k}='Delta Pfc without tones'; 14 
% k=k+1; ti{k}='Delta Pac with tones';    15
% k=k+1; ti{k}='Delta Pac without tones'; 16
% k=k+1; ti{k}='Delta Moc with tones';    17
% k=k+1; ti{k}='Delta Moc without tones'; 18

idx=1:5:90;


clear pPostTest
clear h
a=1;
for i=1:5:90
    A{1}=Res1(:,i);A{2}=Res1(:,i+1);A{3}=Res1(:,i+2);A{4}=Res1(:,i+3);A{5}=Res1(:,i+4);
    [p,t,st,Pt,group]=CalculANOVAmultipleOneway(A);close, close force
    F(a,1)=t{2,6};
    F(a,2)=p;
    for k=1:5
            num=1:5;
            num(k)=[];
            for j=1:length(num)
            [h(k,j),pPostTest(a,k,j)]=ttest(A{k},A{num(j)});   
            end
    end
    
    
    
    a=a+1;    
end

clear pPostTestb
clear hb
a=1;
for i=1:5:90
    A{1}=Res7(:,i);A{2}=Res7(:,i+1);A{3}=Res7(:,i+2);A{4}=Res7(:,i+3);A{5}=Res7(:,i+4);
    [p,t,st,Pt,group]=CalculANOVAmultipleOneway(A);close, close force
    Fb(a,1)=t{2,6};
    Fb(a,2)=p;
    for k=1:5
            num=1:5;
            num(k)=[];
            for j=1:length(num)
            [hb(k,j),pPostTestb(a,k,j)]=ttest(A{k},A{num(j)});   
            end
    end
    a=a+1;    
end





clear pPostTestr
clear hr
a=1;
for i=1:5:90
    A{1}=Res1(:,i)./Res1(:,26);A{2}=Res1(:,i+1)./Res1(:,27);A{3}=Res1(:,i+2)./Res1(:,28);A{4}=Res1(:,i+3)./Res1(:,29);A{5}=Res1(:,i+4)./Res1(:,30);
    [p,t,st,Pt,group]=CalculANOVAmultipleOneway(A);close, close force
    Fr(a,1)=t{2,6};
    Fr(a,2)=p;
    for k=1:5
            num=1:5;
            num(k)=[];
            for j=1:length(num)
            [hr(k,j),pPostTestr(a,k,j)]=ttest(A{k},A{num(j)});   
            end
    end
    a=a+1;    
end

clear pPostTestbr
clear hbr
a=1;
for i=1:5:90
    A{1}=Res7(:,i)./Res7(:,26);A{2}=Res7(:,i+1)./Res7(:,27);A{3}=Res7(:,i+2)./Res7(:,28);A{4}=Res7(:,i+3)./Res7(:,29);A{5}=Res7(:,i+4)./Res7(:,30);
    [p,t,st,Pt,group]=CalculANOVAmultipleOneway(A);close, close force
    Fbr(a,1)=t{2,6};
    Fbr(a,2)=p;
    for k=1:5
            num=1:5;
            num(k)=[];
            for j=1:length(num)
            [hbr(k,j),pPostTestbr(a,k,j)]=ttest(A{k},A{num(j)});   
            end
    end
    a=a+1;    
end



figure('color',[1 1 1]), 
subplot(1,3,1), plot(Res7(:,11)./Res7(:,26),Res7(:,12)./Res7(:,27),'ko','markerfacecolor','k'), hold on, plot(Res1(:,11)./Res1(:,26),Res1(:,12)./Res1(:,27),'ro','markerfacecolor','r'),
[rc,pc]=corrcoef([Res7(:,11)./Res7(:,26); Res1(:,11)./Res1(:,26)],[Res7(:,12)./Res7(:,27); Res1(:,12)./Res1(:,27)]);
line([0.4 1.1],[0.4 1.1],'color',[0.7 0.7 0.7])
xlim([0.4 1.1])
ylabel('Frequence Delta S2')
xlabel('Frequence Delta S1')
title(['r=',nuM2str(rc(2,1)),', p=',num2str(pc(2,1))])

subplot(1,3,2), plot(Res7(:,11)./Res7(:,26),Res7(:,12)./Res7(:,27)-Res7(:,11)./Res7(:,26),'ko','markerfacecolor','k'), hold on, plot(Res1(:,11)./Res1(:,26),Res1(:,12)./Res1(:,27)-Res1(:,11)./Res1(:,26),'ro','markerfacecolor','r'),
% line([0.4 1.1],[0.4 1.1],'color',[0.7 0.7 0.7])
% xlim([0.4 1.1])
xlabel('Frequence Delta S1')
ylabel('Frequence Delta S2-S1')
[rc2,pc2]=corrcoef([Res7(:,11)./Res7(:,26);Res1(:,11)./Res1(:,26)],[Res7(:,12)./Res7(:,27)-Res7(:,11)./Res7(:,26); Res1(:,12)./Res1(:,27)-Res1(:,11)./Res1(:,26)]);
title(['r=',nuM2str(rc2(2,1)),', p=',num2str(pc2(2,1))])

idOK7=find(Res7(:,11)./Res7(:,26)>0.75);
idOK1=find(Res1(:,11)./Res1(:,26)>0.75);
% subplot(2,2,3), PlotErrorBar2(Res7(:,12)./Res7(:,27),Res1(:,12)./Res1(:,27),0)
% [h,p]=ttest2(Res7(:,12)./Res7(:,27),Res1(:,12)./Res1(:,27));
% title(num2str(p))

subplot(1,3,3), PlotErrorBar2(Res7(idOK7,12)./Res7(idOK7,27),Res1(idOK1,12)./Res1(idOK1,27),0)
[h,p]=ttest2(Res7(idOK7,12)./Res7(idOK7,27),Res1(idOK1,12)./Res1(idOK1,27));
title(num2str(p))


    
i=idx(1);
A{1}=Res7(:,i)./Res7(:,26);A{2}=Res7(:,i+1)./Res7(:,27);A{3}=Res7(:,i+2)./Res7(:,28);A{4}=Res7(:,i+3)./Res7(:,29);A{5}=Res7(:,i+4)./Res7(:,30);
[p,t,st,Pt,group]=CalculANOVAmultipleOneway(A);
i=idx(3);
A2{1}=Res7(:,i)./Res7(:,26);A2{2}=Res7(:,i+1)./Res7(:,27);A2{3}=Res7(:,i+2)./Res7(:,28);A2{4}=Res7(:,i+3)./Res7(:,29);A2{5}=Res7(:,i+4)./Res7(:,30);
[p,t,st,Pt,group]=CalculANOVAmultipleOneway(A2);


figure('color',[1 1 1]), hold on
plot(A{1}(:),A2{1},'ko','markerfacecolor','k')
plot(A{2}(:),A2{2},'ko','markerfacecolor','m')
plot(A{3}(:),A2{3},'ko','markerfacecolor',[0.7 0.7 0.7])
plot(A{4}(:),A2{4},'ko','markerfacecolor','m')
plot(A{5}(:),A2{5},'ko','markerfacecolor','b')

At=[[A{1}(:),A2{1}];[A{2}(:),A2{2}];[A{3}(:),A2{3}];[A{4}(:),A2{4}];[A{5}(:),A2{5}]];

idOKrip=find(At(:,1)>0.235);
idNoOKrip=find(At(:,1)<0.235);

figure('color',[1 1 1]), hold on
plot(At(idNoOKrip,1),At(idNoOKrip,2),'ko','markerfacecolor','k')
plot(At(idOKrip,1),At(idOKrip,2),'ro','markerfacecolor','r')

[rr1,pp1]=corrcoef(At(idNoOKrip,1),At(idNoOKrip,2));
[rr2,pp2]=corrcoef(At(idOKrip,1),At(idOKrip,2));
[rrt,ppt]=corrcoef(At(:,1),At(:,2));

title(['r=',num2str(rr1(2,1)), ', p=',num2str(pp1(2,1)),';     r=', num2str(rr2(2,1)), ', p=',num2str(pp2(2,1)),';     r=', num2str(rrt(2,1)), ', p=',num2str(ppt(2,1))])

num=gcf;
if sav
    for i=1:num
    eval(['saveFigure(',num2str(i),',''FigureLastMorFFF',num2str(i),''',''/media/DISK_1/Dropbox/Kteam/Projet DeltaFeedBack/Figures Projet DeltaFeedback/FigFRomK/'')'])
    end
end