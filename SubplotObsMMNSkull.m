function [tps,M]=SubplotObsMMNSkull(tps,M,idx1,idx2)

figure('color',[1 1 1])


subplot(3,1,1), hold on,

plot(tps, mean(M),'color','r','linewidth',2)
plot(tps, mean(M(idx1:idx2,:)),'k','linewidth',2)
ylim([-20+min(min(mean(M)),min(mean(M(idx1:idx2,:)))) 20+max(max(mean(M)),max(mean(M(idx1:idx2,:))))])
yl=ylim;
hold on, line([0 0],[yl(1) yl(2)],'color','k')
subplot(3,1,[2,3]), imagesc(tps, [idx1:idx2], M(idx1:idx2,:)),caxis([-2500 2500])
numfi=gcf;


load('MyColormaps','mycmap')
set(numfi,'Colormap',mycmap)
yl=ylim;
hold on, line([0 0],[yl(1) yl(2)],'color','k')
M=M(idx1:idx2,:);