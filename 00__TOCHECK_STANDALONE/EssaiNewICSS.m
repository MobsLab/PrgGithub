

close all


load ICSS-Mouse-17-14062011-03-QuantifExplo1-wideband
Pq1=PosTh;
goodQ1=Smooth(Pq1(:,4),15);


load ICSS-Mouse-17-14062011-05-ICSSManual1-wideband
picss1=PosTh(:,2:3);

load ICSS-Mouse-17-14062011-07-QuantifExplo2-wideband
Pq2=PosTh;
goodQ2=Smooth(Pq2(:,4),15);



load ICSS-Mouse-17-14062011-07-QuantifExplo2-wideband
Pq3=PosTh;
goodQ3=Smooth(Pq3(:,4),15);

load ICSS-Mouse-17-14062011-09-ICSSManual2-wideband
picss2=PosTh(:,2:3);

load ICSS-Mouse-17-14062011-11-QuantifExplo3-wideband
Pq4=PosTh;
goodQ4=Smooth(Pq4(:,4),15);


Xrange=[10 230];
Yrange=[10 230];
        
Picss1=picss1;        
Picss1(:,1)=rescale(picss1(:,1)-picss1(1,1),Xrange(1),Xrange(2));
Picss1(:,2)=rescale(picss1(:,2)-picss1(1,2),Yrange(1),Yrange(2));

Picss2=picss2;  
Picss2(:,1)=rescale(picss2(:,1)-picss2(1,1),Xrange(1),Xrange(2));        
Picss2(:,2)=rescale(picss2(:,2)-picss2(1,2),Yrange(1),Yrange(2));        


[Q1,Q2,Z1,Z2,X1,X2,H1,P1,H2,P2,p_xy,p_xy2,M1,M2]=EntropieKB(Pq1(goodQ1>0.9,2:3),Pq2(goodQ2>0.9,2:3));
% figure('Color',[1 1 1]), hold on
% plot(Picss1(:,1),250-Picss1(:,2),'k')
% plot(p_xy2(:,1),250-p_xy2(:,2),'r','linewidth',2)
% xlim([0 300])
% ylim([0 250])

[Q1b,Q2b,Z1b,Z2b,X1b,X2b,H1b,P1b,H2b,P2b,p_xyb,p_xy2b,M1b,M2b]=EntropieKB(Pq1(goodQ1>0.9,2:3),Pq4(goodQ4>0.9,2:3));


% figure('Color',[1 1 1]), hold on
% plot(Picss2(:,1),250-Picss2(:,2),'k')
% plot(p_xy2b(:,1),250-p_xy2b(:,2),'r','linewidth',2)
% 
% xlim([0 300])
% ylim([0 250])



figure('Color',[1 1 1])
subplot(3,3,1),
plot(p_xy(:,1),250-p_xy(:,2),'k')
xlim([0 300])
ylim([0 250])
subplot(3,3,2), 
plot(Picss1(:,1),250-Picss1(:,2),'r')
xlim([0 300])
ylim([0 250])
subplot(3,3,3), 
plot(p_xy2(:,1),250-p_xy2(:,2),'k')
xlim([0 300])
ylim([0 250])

subplot(3,3,4), hold on
plot(Picss1(:,1),250-Picss1(:,2),'Color',[0.7 0.7 0.7])
plot(p_xy2(:,1),250-p_xy2(:,2),'r')
xlim([0 300])
ylim([0 250])


subplot(3,3,5), bar([Q1 Q2]), xlim([0 3]), title('Quadrant')
subplot(3,3,6), bar([Z1 Z2]), xlim([0 3]), title('Zone')
subplot(3,3,7), bar([X1 X2]), xlim([0 3]), title('Crossing')
subplot(3,3,8), bar([P1 P2]), xlim([0 3]), title('Proximity measure')
subplot(3,3,9), bar([H1 H2]), xlim([0 3]), title('Entropy')





figure('Color',[1 1 1])
subplot(3,3,1),
plot(p_xyb(:,1),250-p_xyb(:,2),'k')
xlim([0 300])
ylim([0 250])
subplot(3,3,2), 
plot(Picss2(:,1),250-Picss2(:,2),'r')
xlim([0 300])
ylim([0 250])
subplot(3,3,3), 
plot(p_xy2b(:,1),250-p_xy2b(:,2),'k')
xlim([0 300])
ylim([0 250])

subplot(3,3,4), hold on
plot(Picss2(:,1),250-Picss2(:,2),'Color',[0.7 0.7 0.7])
plot(p_xy2b(:,1),250-p_xy2b(:,2),'r')
xlim([0 300])
ylim([0 250])


subplot(3,3,5), bar([Q1b Q2b]), xlim([0 3]), title('Quadrant')
subplot(3,3,6), bar([Z1b Z2b]), xlim([0 3]), title('Zone')
subplot(3,3,7), bar([X1b X2b]), xlim([0 3]), title('Crossing')
subplot(3,3,8), bar([P1b P2b]), xlim([0 3]), title('Proximity measure')
subplot(3,3,9), bar([H1b H2b]), xlim([0 3]), title('Entropy')


