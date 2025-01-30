function [p,stats] = PlotBarCrossProtocol(A,A2,B,B2,plo)

try
    plo;
catch
    plo=1;
end

if plo
    figure, hold on
end

[p(1),~,stats{1}] = ranksum(A,A2);
[p(2),~,stats{2}] = ranksum(B,B2);
[p(3),~,stats{3}] = signrank(A,B);
[p(4),~,stats{4}] = signrank(A2,B2);

bar([[mean(A) mean(A2)];[ mean(B) mean(B2)]],1)
hb = bar([[mean(A) mean(A2)];[ mean(B) mean(B2)]],1);
set (hb(1), 'facecolor',[0.8 0.8 0.8])
set (hb(2), 'facecolor',  [0.95 0.95 0.95])

errorbar(0.86,mean(A),stdError(A),'color','k');
errorbar(1.14,mean(A2),stdError(A2),'color','k');

plot(0.82,A,'.k','MarkerSize',20);
plot(0.82,A,'.w','MarkerSize',10);
plot(1.10,A2,'.k','MarkerSize',20);
plot(1.10,A2,'.w','MarkerSize',10);


errorbar(1.86,mean(B),stdError(B),'color','k');
errorbar(2.14,mean(B2),stdError(B2),'color','k');

plot(1.82,B,'.k','MarkerSize',20);
plot(1.82,B,'.w','MarkerSize',10);
plot(2.10,B2,'.k','MarkerSize',20);
plot(2.10,B2,'.w','MarkerSize',10);

p(p>0.05) = NaN;
sigstar({[0.82,1.1], [1.82,2.1], [0.82,1.82], [1.1,2.1]},p)

hold off
legend (hb, 'Saline', 'Methimazole ', 'Location','northwest')


