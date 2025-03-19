function PlotErrorBar4MC(A,A2,B,B2,C,C2,D,D2,plo)

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
[p(4),~,stats{4}] = ranksum(D,D2);

[p(6),~,stats{6}] = signrank(A,B);
[p(7),~,stats{7}] = signrank(A,C);
[p(8),~,stats{8}] = signrank(A,D);
[p(10),~,stats{10}] = signrank(B,C);
[p(11),~,stats{11}] = signrank(B,D);
[p(13),~,stats{13}] = signrank(C,D);

[p(16),~,stats{16}] = signrank(A2,B2);
[p(17),~,stats{17}] = signrank(A2,C2);
[p(18),~,stats{18}] = signrank(A2,D2);
[p(20),~,stats{20}] = signrank(B2,C2);
[p(21),~,stats{21}] = signrank(B2,D2);
[p(23),~,stats{23}] = signrank(C2,D2);

bar([[mean(A) mean(A2)];[mean(B) mean(B2)];[mean(C) mean(C2)];[mean(D) mean(D2)]],1)
hb = bar([[mean(A) mean(A2)];[ mean(B) mean(B2)];[ mean(C) mean(C2)];[ mean(D) mean(D2)]],1);
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

clrs = ['.k','.r','.b','.g','.c'];

for i = 1:length(A)
    plot(0.82,A,clrs(i),'MarkerSize',20);
    plot(0.82,A,'.w','MarkerSize',10);
    plot(1.10,A2,clrs(i),'MarkerSize',20);
    plot(1.10,A2,'.w','MarkerSize',10);
    
    plot(1.82,B,clrs(i),'MarkerSize',20);
    plot(1.82,B,'.w','MarkerSize',10);
    plot(2.10,B2,clrs(i),'MarkerSize',20);
    plot(2.10,B2,'.w','MarkerSize',10);
    
    plot(2.82,C,clrs(i),'MarkerSize',20);
    plot(2.82,C,'.w','MarkerSize',10);
    plot(3.10,C2,clrs(i),'MarkerSize',20);
    plot(3.10,C2,'.w','MarkerSize',10);
    
    plot(3.82,D,clrs(i),'MarkerSize',20);
    plot(3.82,D,'.w','MarkerSize',10);
    plot(4.10,D2,clrs(i),'MarkerSize',20);
    plot(4.10,D2,'.w','MarkerSize',10);
end

% p(p>0.05) = NaN;
% sigstar({[0.82, 1.10],[1.82,2.1],[2.82,3.10],[3.82,4.10],[4.82,5.10],...
%     [0.86,1.86],[0.68,2.86],[0.86,3.86],[0.86,4.86],[1.86,2.86],[1.86,3.86],[1.86,4.86],[2.86,3.86],[2.86,4.86],[4.86,3.86],...
%     [1.14,2.14],[1.14,3.14],[1.14,4.14],[1.14,5.14],[2.14,3.14],[2.14,4.14],[2.14,5.14],[3.14,4.14],[3.14,5.14],[5.14,4.14],},p)

hold off
legend (hb, 'sham', 'experimental ')
