function PlotErrorBar7MC(A,A2,B,B2,C,C2,D,D2,E,E2,F,F2,G,G2,plo)

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
[p(5),~,stats{5}] = ranksum(E,E2);
[p(6),~,stats{6}] = ranksum(F,F2);
[p(7),~,stats{7}] = ranksum(G,G2);
% 
% [p(6),~,stats{6}] = signrank(A,B);
% [p(7),~,stats{7}] = signrank(A,C);
% [p(8),~,stats{8}] = signrank(A,D);
% [p(9),~,stats{9}] = signrank(A,E);
% [p(10),~,stats{10}] = signrank(B,C);
% [p(11),~,stats{11}] = signrank(B,D);
% [p(12),~,stats{12}] = signrank(B,E);
% [p(13),~,stats{13}] = signrank(C,D);
% [p(14),~,stats{14}] = signrank(C,E);
% [p(15),~,stats{15}] = signrank(E,D);
% 
% [p(16),~,stats{16}] = signrank(A2,B2);
% [p(17),~,stats{17}] = signrank(A2,C2);
% [p(18),~,stats{18}] = signrank(A2,D2);
% [p(19),~,stats{19}] = signrank(A2,E2);
% [p(20),~,stats{20}] = signrank(B2,C2);
% [p(21),~,stats{21}] = signrank(B2,D2);
% [p(22),~,stats{22}] = signrank(B2,E2);
% [p(23),~,stats{23}] = signrank(C2,D2);
% [p(24),~,stats{24}] = signrank(C2,E2);
% [p(25),~,stats{25}] = signrank(E2,D2);
% 
% 
% [p(28),~,stats{28}] = signrank(A,F);
% [p(29),~,stats{29}] = signrank(A,G);
% [p(30),~,stats{30}] = signrank(B,F);
% [p(31),~,stats{31}] = signrank(B,G);
% [p(32),~,stats{32}] = signrank(C,F);
% 
% [p(33),~,stats{33}] = signrank(F,D);
% [p(34),~,stats{34}] = signrank(F,E);
% [p(35),~,stats{35}] = signrank(D,G);
% [p(36),~,stats{36}] = signrank(E,G);
% [p(37),~,stats{37}] = signrank(F,G);
% 
% [p(38),~,stats{38}] = signrank(A2,F2);
% [p(39),~,stats{39}] = signrank(A2,G2);
% [p(40),~,stats{40}] = signrank(B2,F2);
% [p(41),~,stats{41}] = signrank(B2,G2);
% [p(42),~,stats{42}] = signrank(C2,F2);
% [p(43),~,stats{43}] = signrank(F2,D2);
% [p(44),~,stats{44}] = signrank(F2,E2);
% [p(45),~,stats{45}] = signrank(D2,G2);
% [p(46),~,stats{46}] = signrank(E2,G2);
% [p(47),~,stats{47}] = signrank(F2,G2);
% [p(48),~,stats{49}] = signrank(C,G);


bar([[mean(A) mean(A2)];[mean(B) mean(B2)];[mean(C) mean(C2)];[mean(D) mean(D2)];[mean(E) mean(E2)];[mean(F) mean(F2)]; [mean(G) mean(G2)]],1)
hb = bar([[mean(A) mean(A2)];[ mean(B) mean(B2)];[ mean(C) mean(C2)];[ mean(D) mean(D2)];[mean(E) mean(E2)];[mean(F) mean(F2)]; [mean(G) mean(G2)]],1);
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
errorbar(5.86,mean(F),stdError(F),'color','k');
errorbar(6.14,mean(F2),stdError(F2),'color','k');
errorbar(6.86,mean(G),stdError(G),'color','k');
errorbar(7.14,mean(G2),stdError(G2),'color','k');

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

plot(5.82,F,'.k','MarkerSize',20);
plot(5.82,F,'.w','MarkerSize',10);
plot(6.10,F2,'.k','MarkerSize',20);
plot(6.10,F2,'.w','MarkerSize',10);

plot(6.82,G,'.k','MarkerSize',20);
plot(6.82,G,'.w','MarkerSize',10);
plot(7.10,G2,'.k','MarkerSize',20);
plot(7.10,G2,'.w','MarkerSize',10);

% p(p>0.05) = NaN;
sigstar({[0.82, 1.10],[1.82,2.1],[2.82,3.10],[3.82,4.10],[4.82,5.10],[5.82 6.10],[6.82,7.10]},p)
%     [0.86,1.86],[0.68,2.86],[0.86,3.86],[0.86,4.86],[1.86,2.86],[1.86,3.86],[1.86,4.86],[2.86,3.86],[2.86,4.86],[4.86,3.86],...
%     [1.14,2.14],[1.14,3.14],[1.14,4.14],[1.14,5.14],[2.14,3.14],[2.14,4.14],[2.14,5.14],[3.14,4.14],[3.14,5.14],[5.14,4.14],},p)

hold off
legend (hb, 'sham', 'experimental ','northwest')
