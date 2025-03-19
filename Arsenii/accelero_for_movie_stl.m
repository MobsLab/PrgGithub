

subplot(211)
plot(Range(LFPB1,'s'),zscore(Data(LFPB1))-4,'k','color',[0.6 0 0])
hold on
plot(Range(LFPB2,'s'),zscore(Data(LFPB2))-8,'color',[1 0.6 0.2])

clear A, A=log(Data(MovAcctsd)); A(A==-Inf)=15; A = runmean_BM(A , ceil(.05/median(diff(Range(MovAcctsd,'s'))))); 
B=runmean_BM(A , ceil(3/median(diff(Range(MovAcctsd,'s'))))); 
A=(A-min(B)); A=A/max(B);
area(Range(MovAcctsd,'s'),A*8)
u=hline((log(Immobility_thresh)-min(B))/max(B) , '--k'); u.LineWidth = 4;


xlim([2 4]), ylim([-12 4])


subplot(212)
plot(Range(LFPB1,'s'),zscore(Data(LFPB1))-4,'k','color',[0.6 0 0])
hold on
plot(Range(LFPB2,'s'),zscore(Data(LFPB2))-8,'color',[1 0.6 0.2])
clear A, A=log(Data(MovAcctsd)); A(A==-Inf)=15; A = runmean_BM(A , ceil(.05/median(diff(Range(MovAcctsd,'s'))))); 
B=runmean_BM(A , ceil(3/median(diff(Range(MovAcctsd,'s'))))); 
A=(A-min(B)); A=A/max(B);
area(Range(MovAcctsd,'s'),A*4)
xlim([3002 3004]), ylim([-12 3])


