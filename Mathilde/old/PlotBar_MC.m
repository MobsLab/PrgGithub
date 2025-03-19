function [p,stats] = PlotBar_MC(A,B,plo)

try
    plo;
catch
    plo=1;
end

if plo
    figure, hold on
end

[p(1),~,stats{1}] = ranksum(A,B);


bar([mean(A) mean(B)],1)
hb = bar([mean(A);mean(B)],1);
set (hb(1), 'facecolor',[0.8 0.8 0.8])
% set (hb(2), 'facecolor',  [0.95 0.95 0.95])

errorbar(0.86,mean(A),stdError(A),'color','k');
errorbar(2.86,mean(B),stdError(B),'color','k');


plot(0.82,A,'.k','MarkerSize',20);
plot(0.82,A,'.w','MarkerSize',10);
plot(2.82,B,'.k','MarkerSize',20);
plot(2.82,B,'.w','MarkerSize',10);






p(p>0.05) = NaN;
sigstar({[0.82,2.82]},p)

hold off
legend (hb, 'control', 'opto ', 'Location','northwest')


