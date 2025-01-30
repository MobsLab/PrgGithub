% ParcoursPCAreacERC2

%%
binS=0.04*1e4; 
periodAnalysis='postRip';
% periodAnalysis='wake';
% periodAnalysis='cond';
%periodAnalysis='condFree';
 
% nMice = [1199];
% nMice = [797 798 828 861 905 906 911 977 994 1161 1162 1168 1182 1186 1199];
nMice = [905 906 911 994 1161 1162 1168 1199];
% % nMice = 994;
Dir = PathForExperimentsERC('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice',nMice);

%%

a=1;
for k=1:length(Dir.path)
    k
    [PCArec(a,:),SWRrate(a,:),mPr(a,:),mHa(a,:),mCo(a,:),mPo(a,:),...
        tPr,tHa,tCo,tPo,XYHab{a},XYCond{a},PCAfreez(a,:),FiXYPCAHab{a},...
        FiXYPCACond{a},OccHab{a},OccCond{a}]=PCAreacERC2(periodAnalysis,1,binS, Dir.path{k}{1});
    title([Dir.name{k} ' PC#' num2str(1)]);
    ppc(a) = 1;
    a=a+1;
    
    [PCArec(a,:),SWRrate(a,:),mPr(a,:),mHa(a,:),mCo(a,:),mPo(a,:),...
        tPr,tHa,tCo,tPo,XYHab{a},XYCond{a},PCAfreez(a,:),FiXYPCAHab{a},...
        FiXYPCACond{a},OccHab{a},OccCond{a}]=PCAreacERC2(periodAnalysis,2,binS, Dir.path{k}{1});
    title([Dir.name{k} ' PC#' num2str(2)]);
    ppc(a) = 2;
    a=a+1;
end

% Save data
% foldertosave = ChooseFolderForFigures_DB('Data');
% save(fullfile(foldertosave, 'DataPCAreacERCpostrip400bisHighPrecision.mat'),...
%         'Res', 'PCArec', 'SWRrate', 'mPr', 'mHa', 'mCo', 'mPo', 'tPr', 'tHa',...
%         'tCo', 'tPo', 'PCAfreez', 'name ppc', 'k', 'a', 'binS', 'periodAnalysis',...
%         'XYHab', 'XYCond', 'FiXYPCAHab', 'FiXYPCACond', 'OccHab' ,'OccCond');

%%
figure('color',[1 1 1], 'units', 'normalized', 'outerposition', [0 0 0.8 0.65]), 
subplot(1,3,1), hold on, plot(tPr,mPr,'k'), ylim([-2 20]), xlim([tPo(1) tPo(end)])
xlabel('Time (ms)')
ylabel('Reactivation strength')
line([0 0],ylim,'color','k','linestyle',':')
subplot(1,3,2), hold on, plot(tPo,mPo,'r'), ylim([-2 20]), xlim([tPo(1) tPo(end)])
xlabel('Time (ms)')
ylabel('Reactivation strength')
line([0 0],ylim,'color','k','linestyle',':')
subplot(1,3,3), hold on, 
plot(tPo,nanmean(mPo),'r'), 
plot(tPr,nanmean(mPr),'k'),
plot(tPr,nanmean(mCo),'g'),
xlabel('Time (ms)')
ylabel('Reactivation strength')
line([0 0],ylim,'color','k','linestyle',':'), xlim([tPo(1) tPo(end)])
legend('PreSleep', 'PostSleep')

%% Figure for presentation
figure
shadedErrorBar(tPo, nanmean(mCo), nanstd(mCo), 'r')
hold on
shadedErrorBar(tPo, nanmean(mPr), nanstd(mPr), 'k')

figure('color',[1 1 1]), 
subplot(2,3,1), plot(PCArec(:,1),PCArec(:,4),'k.','markersize',15), line([-1 8],[-1 8],'color','k','linestyle',':')
xlabel('PC, Pre Sleep'),ylabel('PC, Post Sleep')
subplot(2,3,2), plot(PCArec(:,3),PCArec(:,4),'k.','markersize',15)
xlabel('PC, Cond'),ylabel('PC, Post Sleep')
subplot(2,3,3), plot(PCArec(:,3),PCArec(:,4)-PCArec(:,1),'k.','markersize',15)
xlabel('PC, Cond'),ylabel('PC, Post-Pre Sleep')
subplot(2,3,4), plot(max(mPr'),max(mPo'),'k.','markersize',15), line([-2 20],[-2 20],'color','k','linestyle',':')
subplot(2,3,5), plot(PCArec(:,3),max(mPo'),'k.','markersize',15)
subplot(2,3,6), plot(PCArec(:,3),max(mPo')-max(mPr'),'k.','markersize',15)

figure('color',[1 1 1]), 
subplot(1,4,1),plot(PCArec(:,3),PCArec(:,4)-PCArec(:,1),'k.','markersize',15)
[r,p]=corrcoef(PCArec(:,3),PCArec(:,4)-PCArec(:,1));
title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
xlabel('PC, Cond'),ylabel('PC, Post-Pre Sleep')
subplot(1,4,2),plot(PCArec(:,2),PCArec(:,4)-PCArec(:,1),'k.','markersize',15)
[r,p]=corrcoef(PCArec(:,2),PCArec(:,4)-PCArec(:,1));
title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
xlabel('PC, Hab'),ylabel('PC, Post-Pre Sleep')
subplot(1,4,3),plot(PCArec(:,3)-PCArec(:,2),PCArec(:,4)-PCArec(:,1),'k.','markersize',15)
[r,p]=corrcoef(PCArec(:,3)-PCArec(:,2),PCArec(:,4)-PCArec(:,1));
title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
xlabel('PC, Cond-Hab'),ylabel('PC, Post-Pre Sleep')
subplot(1,4,4), scatter(PCArec(:,1),PCArec(:,4),40,PCArec(:,3),'filled')
xlabel('PC, Pre Sleep'),ylabel('PC, Post Sleep')
line([-1 8],[-1 8],'color','k','linestyle',':')
[h,p]=ttest(PCArec(find(PCArec(:,3)>1),1),PCArec(find(PCArec(:,3)>1),4));
title(['p=',num2str(p)])
xlim([-1 8]),ylim([-1 8])

PlotErrorBarN_KJ(PCArec)
set(gca,'XTick',1:6,'XTickLabel',{'sleep pre','Hab','Cond','Sleep Post','Cond1','Cond2'})
[h,p]=ttest(PCArec(:,1),PCArec(:,4));p
[h,p]=ttest(PCArec(:,2),PCArec(:,3));p

PlotErrorBarN_KJ(PCArec(find(ppc==1),:))
set(gca,'XTick',1:6,'XTickLabel',{'sleep pre','Hab','Cond','Sleep Post','Cond1','Cond2'})
[h,p]=ttest(PCArec(find(ppc==1),1),PCArec(find(ppc==1),4));p

[h,p]=ttest(PCArec(find(PCArec(:,1)>1),1),PCArec(find(PCArec(:,1)>1),4));p
[h,p]=ttest(PCArec(find(PCArec(:,3)>1),1),PCArec(find(PCArec(:,3)>1),4));p

PlotErrorBarN_KJ(PCAfreez)
set(gca,'XTick',1:5,'XTickLabel',{'Cond','Cond noF','Cond F','Cond F rip','Cond F Norip'})

PlotErrorBarN_KJ(PCAfreez(find(ppc==1),:))
set(gca,'XTick',1:5,'XTickLabel',{'Cond','Cond noF','Cond F','Cond F rip','Cond F Norip'})

%% Figure paper
data_RS = [PCArec(:,2) PCArec(:,3) PCAfreez(:,4) PCAfreez(:,2)];
figure
[~,h_occ] = PlotErrorBarN_DB(data_RS,'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints', 0);
h_occ.FaceColor = 'flat';
h_occ.FaceAlpha = .8;
h_occ.CData(2,:) = [.5 0 0];
h_occ.CData(3,:) = [.9 0 0];
h_occ.CData(4,:) = [.7 0 0];
set(gca,'Xtick',[1:4],'XtickLabel',{'Free explo', 'Learning', '\begin{tabular}{c} Learning \\ SWR\end{tabular}',...
    '\begin{tabular}{c} Learning \\ no SWR\end{tabular}'}, 'TickLabelInterpreter', 'latex');
makepretty
% line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',5);
% ylim([0 70])
ylabel('Reactivation strength');
% title('Shock zone occupancy')
makepretty


figure('color',[1 1 1]), 
subplot(1,3,1), PlotErrorBarN_KJ([PCArec(:,1) PCArec(:,4)],'showPoints',0,'newfig',0),set(gca,'XTick',1:2,'XTickLabel',{'Sleep Pre','Sleep Post'}),xlim([0 3]),ylim([0 3.5])
subplot(1,3,2), PlotErrorBarN_KJ([PCArec(find(PCArec(:,3)<1),1) PCArec(find(PCArec(:,3)<1),4)],'showPoints',0,'newfig',0),set(gca,'XTick',1:2,'XTickLabel',{'Sleep Pre','Sleep Post'}),xlim([0 3]),ylim([0 3.5])
subplot(1,3,3), PlotErrorBarN_KJ([PCArec(find(PCArec(:,3)>1),1) PCArec(find(PCArec(:,3)>1),4)],'showPoints',0,'newfig',0),set(gca,'XTick',1:2,'XTickLabel',{'Sleep Pre','Sleep Post'}),xlim([0 3]),ylim([0 3.5])

MPo=(mPo(:,25))-mean(mPo(:,1:15),2);
MPr=(mPr(:,25))-mean(mPr(:,1:15),2);
[h,p]=ttest(MPo,MPr);p
[h,p]=ttest(mPo(:,25),mPr(:,25));p

MPo=max(mPo(:,25:26)')-mean(mPo(:,1:15),2)';
MPr=max(mPr(:,25:26)')-mean(mPr(:,1:15),2)';
[h,p]=ttest(MPo,MPr);p

MPo=max(mPo(find(ppc==1),25:26)')-mean(mPo(find(ppc==1),1:15),2)';
MPr=max(mPr(find(ppc==1),25:26)')-mean(mPr(find(ppc==1),1:15),2)';
[h,p]=ttest(MPo,MPr);p


for a=1:length(XYHab)
    XYHa(:,:,a)=XYHab{a};
    XYCo(:,:,a)=XYCond{a};
    XYHas(:,:,a)=smooth2a(XYHab{a},1,1);
    XYCos(:,:,a)=smooth2a(XYCond{a},1,1);
end



for i=1:size(XYHa,1)
    for j=1:size(XYHa,2)
        [h,p(i,j)]=ttest(XYCo(i,j,:),XYHa(i,j,:));
        try
            [pr(i,j),hr]=ranksum(squeeze(XYCo(i,j,:)),squeeze(XYHa(i,j,:)));
        catch
            pr(i,j)=nan;
        end
    end
end
p = p'; % !!!!!!!!!!!!!!!

% Mean PC Hab, Cond
figure('color',[1 1 1]), 
subplot(1,2,1)
imagesc(sum(XYHa,3,'omitnan')'/30)
axis xy
xlim([1.5 19.5]),ylim([1.5 19.5])
title('Mean PC score Hab')
caxis([0 1.5]), colorbar, set(gca,'XTick',[])
set(gca,'YTick',[])

subplot(1,2,2)
imagesc(sum(XYCo,3,'omitnan')'/30)
axis xy,
xlim([1.5 19.5]),ylim([1.5 19.5])
title('Mean PC score Cond')
caxis([0 1.5]), colorbar
set(gca,'XTick',[]),set(gca,'YTick',[])
colormap(hot)


% Mean PC Cond-Hab
figure('color',[1 1 1]), 
% subplot(1,3,1)
imagesc(sum(XYCo-XYHa,3,'omitnan')'/30)
axis xy
% xlim([1.5 19.5]),ylim([1.5 19.5])
title('Mean PC score Cond-Hab')
colorbar
set(gca,'XTick',[]),set(gca,'YTick',[])
caxis([-0.2 0.85])
%line([1.5 4.5],[4.5 4.5],'color','w','linewidth',2), line([4.5 4.5],[1.5 4.5],'color','w','linewidth',2)

MM=sum(XYCo-XYHa,3,'omitnan')'/30;
MM(p>0.05)=0;
MM(isnan(p)) = 0; % !!!!!!!!!!!!!!!
subplot(1,3,2)
imagesc(MM)
axis xy
% xlim([1.5 19.5]),ylim([1.5 19.5])
title('Mean PC score Cond-Hab (p<0.05)'), colorbar
caxis([-0.2 0.85])
set(gca,'XTick',[]),set(gca,'YTick',[])
% line([1.5 4.5],[4.5 4.5],'color','w','linewidth',2), line([4.5 4.5],[1.5 4.5],'color','w','linewidth',2)

subplot(133)
imagesc(p)
axis xy

figure('color',[1 1 1]), 
subplot(1,2,1), imagesc(sum(XYHa,3,'omitnan')'/30)
axis xy
xlim([1.5 19.5]),ylim([1.5 19.5])
title('Mean PC score Hab')
caxis([0 1.5]), colorbar
set(gca,'XTick',[]),set(gca,'YTick',[])


subplot(1,2,2)
imagesc(sum(XYCo,3,'omitnan')'/30), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond'), caxis([0 1.5]), colorbar, set(gca,'XTick',[]),set(gca,'YTick',[])%line([1.5 4.5],[4.5 4.5],'color','w','linewidth',2), line([4.5 4.5],[1.5 4.5],'color','w','linewidth',2)
colormap(hot)
figure('color',[1 1 1]), 
subplot(1,2,1), imagesc(sum(XYCo-XYHa,3,'omitnan')'/30), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond-Hab'), colorbar, set(gca,'XTick',[]),set(gca,'YTick',[])%line([1.5 4.5],[4.5 4.5],'color','w','linewidth',2), line([4.5 4.5],[1.5 4.5],'color','w','linewidth',2)
MM=sum(XYCo-XYHa,3,'omitnan')'/30;
MM(find(p>0.001))=0;
subplot(1,2,2), imagesc(MM), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond-Hab (p<0.001)'), colorbar, set(gca,'XTick',[]),set(gca,'YTick',[])% line([1.5 4.5],[4.5 4.5],'color','w','linewidth',2), line([4.5 4.5],[1.5 4.5],'color','w','linewidth',2)

for i=1:size(XYHa,1)
    for j=1:size(XYHa,1)
        [h,ps(i,j)]=ttest(XYCos(i,j,:),XYHas(i,j,:));
        try
            [prs(i,j),hr]=ranksum(squeeze(XYCos(i,j,:)),squeeze(XYHas(i,j,:)));
        catch
            prs(i,j)=nan;
        end
    end
end
ps=ps';

figure('color',[1 1 1]), 
subplot(1,2,1), imagesc(sum(XYHas,3,'omitnan')'/30), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Hab'), caxis([0 1.5]), colorbar, set(gca,'XTick',[]),set(gca,'YTick',[])%line([1.5 4.5],[4.5 4.5],'color','w','linewidth',2), line([4.5 4.5],[1.5 4.5],'color','w','linewidth',2)
subplot(1,2,2), imagesc(sum(XYCos,3,'omitnan')'/30), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond'), caxis([0 1.5]), colorbar, set(gca,'XTick',[]),set(gca,'YTick',[])%line([1.5 4.5],[4.5 4.5],'color','w','linewidth',2), line([4.5 4.5],[1.5 4.5],'color','w','linewidth',2)
colormap(hot)
figure('color',[1 1 1]), 
subplot(1,2,1), imagesc(sum(XYCos-XYHas,3,'omitnan')'/30), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond-Hab'), colorbar, set(gca,'XTick',[]),set(gca,'YTick',[])%line([1.5 4.5],[4.5 4.5],'color','w','linewidth',2), line([4.5 4.5],[1.5 4.5],'color','w','linewidth',2)
MMs=sum(XYCos-XYHas,3,'omitnan')'/30;
MMs(find(ps>0.05))=0;
subplot(1,2,2), imagesc(MMs), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond-Hab (p<0.05)'), colorbar, set(gca,'XTick',[]),set(gca,'YTick',[])% line([1.5 4.5],[4.5 4.5],'color','w','linewidth',2), line([4.5 4.5],[1.5 4.5],'color','w','linewidth',2)


%%
for a=1:length(OccCond)
    OccCondb(:,:,a)=OccCond{a};
    OccHabb(:,:,a)=OccHab{a};
    FiXYPCAHabb(:,:,a)=FiXYPCAHab{a};
    FiXYPCACondb(:,:,a)=FiXYPCACond{a};
end

figure('color',[1 1 1]) 
subplot(1,2,1), imagesc(sum(OccHabb,3)'),axis xy,title('Occ - Hab'), xlim([1.5 19.5]),ylim([1.5 19.5])
subplot(1,2,2), imagesc(sum(OccCondb,3)'),axis xy,title('Occ - Cond')
xlim([1.5 19.5]),ylim([1.5 19.5])

figure('color',[1 1 1]) 
subplot(1,2,1), imagesc(sum(FiXYPCAHabb,3)'),axis xy,title('Fr PC - Hab'),xlim([1.5 19.5]),ylim([1.5 19.5])
subplot(1,2,2), imagesc(sum(FiXYPCACondb,3)'),axis xy,title('Fr PC -Cond'),xlim([1.5 19.5]),ylim([1.5 19.5])



figure('color',[1 1 1]),
subplot(6,4,1), imagesc(XYHab{1}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,2), imagesc(XYCond{1}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,3), imagesc(OccHab{1}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,4), imagesc(OccCond{1}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)

subplot(6,4,5), imagesc(XYHab{2}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,6), imagesc(XYCond{2}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,7), imagesc(OccHab{2}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,8), imagesc(OccCond{2}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)

subplot(6,4,9), imagesc(XYHab{3}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,10), imagesc(XYCond{3}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,11), imagesc(OccHab{3}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,12), imagesc(OccCond{3}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)

subplot(6,4,13), imagesc(XYHab{4}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,14), imagesc(XYCond{4}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,15), imagesc(OccHab{4}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,16), imagesc(OccCond{4}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)

subplot(6,4,17), imagesc(XYHab{5}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,18), imagesc(XYCond{5}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,19), imagesc(OccHab{5}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,20), imagesc(OccCond{5}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)

subplot(6,4,21), imagesc(XYHab{6}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,22), imagesc(XYCond{6}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Mean PC score Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,23), imagesc(OccHab{6}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Hab'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)
subplot(6,4,24), imagesc(OccCond{6}'), axis xy, xlim([1.5 19.5]),ylim([1.5 19.5]), title('Occ Cond'),  colorbar, set(gca,'XTick',[]),set(gca,'YTick',[]),line([1.5 7.5],[7.5 7.5],'color','w','linewidth',2), line([7.5 7.5],[1.5 7.5],'color','w','linewidth',2)




