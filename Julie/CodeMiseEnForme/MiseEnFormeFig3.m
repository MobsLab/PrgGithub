% mise en page figure 3
cd /home/mobs/Dropbox/SophiesOB4HzManusciptFolder/Fig3
res=pwd;
Msize=8;
EdgeGreyColor=[0 0 0];%EdgeGreyColor=[0.5 0.5 0.5];

FaceGreyColor=[0.7 0.7 0.7];
uiopen('/home/mobs/Dropbox/SophiesOB4HzManusciptFolder/Fig3/PFCsOBKappa.fig',1)
 mk_A=findall(gca,'marker','^'); mk_B=findall(gca,'marker','o'); mk_AB=findall(gca,'marker','sq');
set(mk_AB,'Marker','o','MarkerEdgeColor',EdgeGreyColor,'MarkerFaceColor','k','MarkerSize',Msize)
set(mk_A,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',FaceGreyColor,'MarkerSize',Msize)
set(mk_B,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',FaceGreyColor,'MarkerSize',Msize)
xlim([0 1.2])
ylim([0 1.2])

set(gcf,'Position',[    1899         397         450         450])
line([0 1.2], [0 1.2],'Color','k')
saveFigure(gcf, 'PFCsOBKappa_mep2',res)
saveas(gcf, 'PFCsOBKappa_mep2.fig')


 uiopen('/home/mobs/Dropbox/SophiesOB4HzManusciptFolder/Fig3/RespivsOBKappa.fig',1)
mmk_A=findall(gca,'marker','^'); mmk_B=findall(gca,'marker','o'); mmk_AB=findall(gca,'marker','sq');
 set(mmk_AB,'Marker','o','MarkerEdgeColor',EdgeGreyColor,'MarkerFaceColor','k','MarkerSize',Msize)
set(mmk_A,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',FaceGreyColor,'MarkerSize',Msize)
set(mmk_B,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',FaceGreyColor,'MarkerSize',Msize)

xlim([0 1.2])
ylim([0 1.2])
set(gcf,'WindowStyle','normal')
set(gcf,'Position',[    2200        397         450         450])
line([0 1.2], [0 1.2],'Color','k')
saveFigure(gcf, 'RespivsOBKappa_mep2',res)
saveas(gcf, 'RespivsOBKappa_mep2.fig')