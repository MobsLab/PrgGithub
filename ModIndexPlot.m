function [p,h,stats]=ModIndexPlot(X,Y)
if isempty(Y)
    Mod=X;
else
Mod=(X-Y)./(X+Y);
end
plotSpread({Mod},'distributionColors',[0.4 0.4 0.4])
hold on
line(xlim,[0 0],'color','k')
line([0.5 1.5],[1 1]*nanmedian(Mod),'color','k','linewidth',3)
[p.nonparam,h.nonparam,stats.nonparam]=signrank(Mod);
[h.param,p.param,ci,stats.param]=ttest(Mod);
set(gca,'Xtick',[])
ylim([-max(abs(Mod))*1.4 max(abs(Mod))*1.4])
StarPos=max(abs(Mod))*1.2;
if p.nonparam<0.001
    text(0.8,StarPos,'***','FontSize',25)
elseif p.nonparam<0.01
    text(0.9,StarPos,'**','FontSize',25)
elseif p.nonparam<0.05
    text(1,StarPos,'*','FontSize',25)
end
