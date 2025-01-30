function PlotErrorBar2MC(A,A2,B,B2,plo)

try
    plo;
catch
    plo=1;
end

if plo
    hold on
end


[p(1),~,stats{1}] = ranksum(A,A2);
[p(2),~,stats{2}] = ranksum(B,B2);

[p(4),~,stats{4}] = ranksum(A,B);
[p(7),~,stats{7}] = ranksum(A2,B2);


bar([[nanmean(A), nanmean(A2)];[ nanmean(B), nanmean(B2)]],1)
hb = bar([[nanmean(A), nanmean(A2)];[ nanmean(B), nanmean(B2)]],1);
set (hb(1), 'facecolor',[1 1 1])
set (hb(2), 'facecolor',  [0.3 0.3 0.3])

errorbar(0.86,nanmean(A),stdError(A),'color','k');
errorbar(1.14,nanmean(A2),stdError(A2),'color','k');

errorbar(1.86,nanmean(B),stdError(B),'color','k');
errorbar(2.14,nanmean(B2),stdError(B2),'color','k');



plot(0.82,A,'.k','MarkerSize',20);
plot(0.82,A,'.w','MarkerSize',10);
plot(1.10,A2,'.k','MarkerSize',20);
plot(1.10,A2,'.w','MarkerSize',10);


plot(1.82,B,'.k','MarkerSize',20);
plot(1.82,B,'.w','MarkerSize',10);
plot(2.10,B2,'.k','MarkerSize',20);
plot(2.10,B2,'.w','MarkerSize',10);


% p(p>0.05) = NaN;
% sigstar({[0.82, 1.10], [1.82,2.1], [2.82,3.10], [0.82,1.82], [0.82,2.82], [1.82,2.82], [1.10,2.10], [1.10,3.10], [2.10,3.10]},p)

hold off
legend (hb, 'sham', 'experimental')