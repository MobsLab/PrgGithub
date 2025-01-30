function hb = PlotErrorBar3MC(A,A2,B,B2,C,C2,plo)

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
[p(3),~,stats{3}] = ranksum(C,C2);

% [p(4),~,stats{4}] = ranksum(A,B);
% [p(5),~,stats{5}] = ranksum(A,C);
% [p(6),~,stats{6}] = ranksum(B,C);
% 
% [p(7),~,stats{7}] = ranksum(A2,B2);
% [p(8),~,stats{8}] = ranksum(A2,C2);
% [p(9),~,stats{9}] = ranksum(B2,C2);

% [p(4),~,stats{4}] = signrank(A,B);
% [p(5),~,stats{5}] = signrank(A,C);
% [p(6),~,stats{6}] = signrank(B,C);
% 
% [p(7),~,stats{7}] = signrank(A2,B2);
% [p(8),~,stats{8}] = signrank(A2,C2);
% [p(9),~,stats{9}] = signrank(B2,C2);

bar([[nanmean(A) nanmean(A2)];[ nanmean(B) nanmean(B2)];[ nanmean(C) nanmean(C2)]],1)
hb = bar([[nanmean(A) nanmean(A2)];[ nanmean(B) nanmean(B2)];[ nanmean(C) nanmean(C2)]],1);
set (hb(1), 'facecolor',[1 1 1])
set (hb(2), 'facecolor',  [0.3 0.3 0.3])

errorbar(0.86,nanmean(A),stdError(A),'color','k');
errorbar(1.14,nanmean(A2),stdError(A2),'color','k');

errorbar(1.86,nanmean(B),stdError(B),'color','k');
errorbar(2.14,nanmean(B2),stdError(B2),'color','k');

errorbar(2.86,nanmean(C),stdError(C),'color','k');
errorbar(3.14,nanmean(C2),stdError(C2),'color','k');

plot(0.82,A,'.k','MarkerSize',20);
plot(0.82,A,'.w','MarkerSize',10);
plot(1.10,A2,'.k','MarkerSize',20);
plot(1.10,A2,'.w','MarkerSize',10);


plot(1.82,B,'.k','MarkerSize',20);
plot(1.82,B,'.w','MarkerSize',10);
plot(2.10,B2,'.k','MarkerSize',20);
plot(2.10,B2,'.w','MarkerSize',10);

plot(2.82,C,'.k','MarkerSize',20);
plot(2.82,C,'.w','MarkerSize',10);
plot(3.10,C2,'.k','MarkerSize',20);
plot(3.10,C2,'.w','MarkerSize',10);

% p(p>0.05) = NaN;
% sigstar({[0.82, 1.10], [1.82,2.1], [2.82,3.10]},p)%, [0.82,1.82], [0.82,2.82], [1.82,2.82], [1.10,2.10], [1.10,3.10], [2.10,3.10]},p)

hold off
% legend (hb, 'sham', 'experimental')