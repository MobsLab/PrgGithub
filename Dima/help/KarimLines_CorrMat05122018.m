


%[C{i,j},B{i,j}]=CrossCorr(Range(S{i}),Range(S{j}),100,100);

S = S(BasicNeuronInfo.idx_SUA);
Q=MakeQfromS(S,500);

% QPRE=full(Data(Restrict(Q,intervalSet(0,7.6E6))));
% QTASK=full(Data(Restrict(Q,intervalSet(7.8E6,1.2E7))));
% QPOST=full(Data(Restrict(Q,intervalSet(1.26E7,1.8E7))));

% % M797
% QPRE=zscore(full(Data(Restrict(Q,intervalSet(0,7676604)))));
% QTASK=zscore(full(Data(Restrict(Q,intervalSet(7676604,11179799)))));
% QPOST=zscore(full(Data(Restrict(Q,intervalSet(11179799,22128263)))));

% M798
QPRE=zscore(full(Data(Restrict(Q,intervalSet(0,6388848)))));
QTASK=zscore(full(Data(Restrict(Q,intervalSet(6388848,10191852)))));
QPOST=zscore(full(Data(Restrict(Q,intervalSet(10191852,22939092)))));

RPRE=zeros(length(S),length(S));
PPRE=zeros(length(S),length(S));
RTASK=zeros(length(S),length(S));
PTASK=zeros(length(S),length(S));
RPOST=zeros(length(S),length(S));
PPOST=zeros(length(S),length(S));

for i=1:length(S)
    for j=i+1:length(S)
        [r,p]=corrcoef(QPRE(:,i),QPRE(:,j));
        RPRE(i,j)=r(2,1);
        PPRE(i,j)=p(2,1);
        
        [r,p]=corrcoef(QTASK(:,i),QTASK(:,j));
        RTASK(i,j)=r(2,1);
        PTASK(i,j)=p(2,1);
        
        [r,p]=corrcoef(QPOST(:,i),QPOST(:,j));
        RPOST(i,j)=r(2,1);
        PPOST(i,j)=p(2,1);
    end
end


ca=0.1;
figure, 
subplot(2,3,1),imagesc(RPRE), caxis([-ca ca])
subplot(2,3,2),imagesc(RTASK), caxis([-ca ca])
subplot(2,3,3),imagesc(RPOST), caxis([-ca ca])

subplot(2,3,4),imagesc(RPRE), caxis([ca-0.05 ca])
subplot(2,3,5),imagesc(RTASK), caxis([ca-0.05  ca])
subplot(2,3,6),imagesc(RPOST), caxis([ca-0.05  ca])



subplot(1,3,1),imagesc(RPRE), caxis([-ca ca])
subplot(1,3,2),imagesc(RTASK), caxis([-ca ca])
subplot(1,3,3),imagesc(RPOST), caxis([-ca ca])
