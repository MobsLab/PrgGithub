function PlotBarCRH_MC(A,A2,B,B2,C,C2,D,D2,E,E2,plo)

try
    plo;
catch
    plo=1;
end

if plo
    hold on
end


[p(1),~,stats{1}] = signrank(A,A2);
[p(2),~,stats{2}] = signrank(B,B2);
[p(3),~,stats{3}] = signrank(C,C2);
[p(4),~,stats{4}] = signrank(D,D2);
[p(5),~,stats{5}] = signrank(E,E2);

% [p(4),~,stats{4}] = signrank(A,B);
% [p(5),~,stats{5}] = signrank(A,C);
% [p(6),~,stats{6}] = signrank(B,C);

% [p(7),~,stats{7}] = signrank(A2,B2);
% [p(8),~,stats{8}] = signrank(A2,C2);
% [p(9),~,stats{9}] = signrank(B2,C2);

bar([[mean(A) mean(A2)];[mean(B) mean(B2)];[mean(C) mean(C2)];[mean(D) mean(D2)];[mean(E) mean(E2)]],1)
hb = bar([[mean(A) mean(A2)];[ mean(B) mean(B2)];[ mean(C) mean(C2)];[ mean(D) mean(D2)];[ mean(E) mean(E2)]],1);
set (hb(1), 'facecolor',[1 1 1])
set (hb(2), 'facecolor',  [0.3 0.3 0.3])

errorbar(0.86,mean(A),stdError(A),'color','k');
errorbar(1.14,mean(A2),stdError(A2),'color','k');

errorbar(1.86,mean(B),stdError(B),'color','k');
errorbar(2.14,mean(B2),stdError(B2),'color','k');

errorbar(2.86,mean(C),stdError(C),'color','k');
errorbar(3.14,mean(C2),stdError(C2),'color','k');

errorbar(3.86,mean(D),stdError(D),'color','k');
errorbar(4.14,mean(D2),stdError(D2),'color','k');

errorbar(4.86,mean(E),stdError(E),'color','k');
errorbar(5.14,mean(E2),stdError(E2),'color','k');

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

plot(3.82,D,'.k','MarkerSize',20);
plot(3.82,D,'.w','MarkerSize',10);
plot(4.10,D2,'.k','MarkerSize',20);
plot(4.10,D2,'.w','MarkerSize',10);

plot(4.82,E,'.k','MarkerSize',20);
plot(4.82,E,'.w','MarkerSize',10);
plot(5.10,E2,'.k','MarkerSize',20);
plot(5.10,E2,'.w','MarkerSize',10);


% p(p>0.05) = NaN;
% sigstar({[0.82, 1.10],[1.82,2.1],[2.82,3.10],[3.82,4.10],[4.82,5.10]},p)


hold off
legend (hb, 'sal', 'CNO ','northwest')
