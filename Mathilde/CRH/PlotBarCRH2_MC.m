function PlotBarCRH2_MC(A,A2,A3,B,B2,B3,C,C2,C3,D,D2,D3,E,E2,E3,plo)

try
    plo;
catch
    plo=1;
end

if plo
    figure, hold on
end

[p(1),~,stats{1}] = ranksum(A,A2);
[p(2),~,stats{2}] = ranksum(A,A3);
[p(3),~,stats{3}] = ranksum(A2,A3);

[p(4),~,stats{4}] = ranksum(B,B2);
[p(5),~,stats{5}] = ranksum(B,B3);
[p(6),~,stats{6}] = ranksum(B2,B3);

[p(7),~,stats{7}] = ranksum(C,C2);
[p(8),~,stats{8}] = ranksum(C,C3);
[p(9),~,stats{9}] = ranksum(C2,C3);

[p(10),~,stats{10}] = ranksum(D,D2);
[p(11),~,stats{11}] = ranksum(D,D3);
[p(12),~,stats{12}] = ranksum(D2,D3);

[p(13),~,stats{13}] = ranksum(E,E2);
[p(14),~,stats{14}] = ranksum(E,E3);
[p(15),~,stats{15}] = ranksum(E2,E3);

bar([[mean(A) mean(A2) mean(A)];[mean(B) mean(B2) mean(B3)];[mean(C) mean(C2) mean(C3)];[mean(D) mean(D2) mean(D3)];[mean(E) mean(E2) mean(E3)]],1)
hb = bar([[mean(A) mean(A2) mean(A3)];[mean(B) mean(B2) mean(B3)];[mean(C) mean(C2) mean(C3)];[mean(D) mean(D2) mean(D3)];[mean(E) mean(E2) mean(E3)]],1);
set (hb(1), 'facecolor',[1 1 1])
set (hb(2), 'facecolor',  [1.6 1.6 1.6])
set (hb(3), 'facecolor',  [0 0 0])

errorbar(0.86,mean(A),stdError(A),'color','k');
errorbar(1.14,mean(A2),stdError(A2),'color','k');
errorbar(1.42,mean(A3),stdError(A3),'color','k');

errorbar(1.86,mean(A),stdError(B),'color','k');
errorbar(2.14,mean(A2),stdError(B2),'color','k');
errorbar(2.42,mean(A3),stdError(B3),'color','k');

errorbar(2.86,mean(C),stdError(C),'color','k');
errorbar(3.14,mean(C2),stdError(C2),'color','k');
errorbar(3.42,mean(C3),stdError(C3),'color','k');

errorbar(3.86,mean(D),stdError(D),'color','k');
errorbar(4.14,mean(D2),stdError(D2),'color','k');
errorbar(4.42,mean(D3),stdError(D3),'color','k');

errorbar(4.86,mean(E),stdError(E),'color','k');
errorbar(5.14,mean(E2),stdError(E2),'color','k');
errorbar(5.42,mean(E3),stdError(E3),'color','k');

plot(0.82,A,'.k','MarkerSize',20);
plot(0.82,A,'.w','MarkerSize',10);
plot(1.10,A2,'.k','MarkerSize',20);
plot(1.10,A2,'.w','MarkerSize',10);
plot(1.38,A3,'.k','MarkerSize',20);
plot(1.38,A3,'.w','MarkerSize',10);

plot(1.82,B,'.k','MarkerSize',20);
plot(1.82,B,'.w','MarkerSize',10);
plot(2.10,B2,'.k','MarkerSize',20);
plot(2.10,B2,'.w','MarkerSize',10);
plot(2.38,B3,'.k','MarkerSize',20);
plot(2.38,B3,'.w','MarkerSize',10);

plot(2.82,C,'.k','MarkerSize',20);
plot(2.82,C,'.w','MarkerSize',10);
plot(3.10,C2,'.k','MarkerSize',20);
plot(3.10,C2,'.w','MarkerSize',10);
plot(3.38,C3,'.k','MarkerSize',20);
plot(3.38,C3,'.w','MarkerSize',10);

plot(3.82,D,'.k','MarkerSize',20);
plot(3.82,D,'.w','MarkerSize',10);
plot(4.10,D2,'.k','MarkerSize',20);
plot(4.10,D2,'.w','MarkerSize',10);
plot(4.38,D3,'.k','MarkerSize',20);
plot(4.38,D3,'.w','MarkerSize',10);

plot(4.82,E,'.k','MarkerSize',20);
plot(4.82,E,'.w','MarkerSize',10);
plot(5.10,E2,'.k','MarkerSize',20);
plot(5.10,E2,'.w','MarkerSize',10);
plot(5.38,E3,'.k','MarkerSize',20);
plot(5.38,E3,'.w','MarkerSize',10);

% p(p>0.05) = NaN;
% sigstar({[0.82, 1.10],[1.82,2.1],[2.82,3.10],[3.82,4.10],[4.82,5.10]},p)

hold off
legend (hb, 'sal', 'CNO ','northwest')
