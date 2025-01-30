
%FigureRipplesPFcN1N2N3Marie
% 
% 
% close all
% [Ctotaln3,CTot2n3,B,Nbn3,CspkTn3,CspkTcn3,CspkTcbn3,TCspktn3]=SpindlesRipplesN1N2N3('N3');
% [Ctotaln2,CTot2n2,B,Nbn2,CspkTn2,CspkTcn2,CspkTcbn2,TCspktn2]=SpindlesRipplesN1N2N3('N2');
% [Ctotaln1,CTot2n1,B,Nbn1,CspkTn1,CspkTcn1,CspkTcbn1,TCspktn1]=SpindlesRipplesN1N2N3('N1');



load DataFigureRipplesPFcN1N2N3Marie


namvar{1}='SpiFs';
namvar{2}='SpiFd';
namvar{3}='SpiSs';
namvar{4}='SpiSd';
namvar{5}='Delta';
namvar{6}='rip';
namvar{7}='rip Pre D';
namvar{8}='rip Post D';
namvar{9}='rip out D';
namvar{10}='rip Spi';
namvar{11}='rip out Spi';



lim=0.6;


figure('color',[1 1 1])
for i=1:4
subplot(1,4,i), hold on
plot(B/1E3,nanmean(CspkTcn2{i}),'k')
plot(B/1E3,nanmean(CspkTcn3{i}),'r'), title(namvar{i})
%plot(B/1E3,nanmean(CspkTcn1{i}),'b') 
line([0 0],ylim,'color',[0.8 0.8 0.8])
xlim([-lim lim])
end


% 
% figure('color',[1 1 1])
% for i=1:11
% subplot(3,4,i), hold on
% plot(B/1E3,nanmean(CspkTcn2{i}),'k')
% plot(B/1E3,nanmean(CspkTcn3{i}),'r'), title(namvar{i})
% plot(B/1E3,nanmean(CspkTcn1{i}),'b') 
% line([0 0],ylim,'color',[0.8 0.8 0.8])
% xlim([-lim lim])
% end
% 
% 
% 
% figure('color',[1 1 1])
% for i=1:11
% subplot(3,4,i), hold on
% plot(B/1E3,nanmean(CspkTcbn2{i}),'k')
% plot(B/1E3,nanmean(CspkTcbn3{i}),'r'), title(namvar{i})
% plot(B/1E3,nanmean(CspkTcbn1{i}),'b') 
% line([0 0],ylim,'color',[0.8 0.8 0.8])
% xlim([-lim lim])
% end





% 
% ca=[-6 6];
% limsort=[90 110];
% figure('color',[1 1 1]), 
% temp=zscore(TCspktn1{6}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,1), imagesc(temp(id,:)), title(namvar{6})
% caxis(ca)
% temp=zscore(TCspktn1{7}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,4), imagesc(temp(id,:)), title(namvar{7})
% caxis(ca)
% temp=zscore(TCspktn1{8}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,7), imagesc(temp(id,:)), title(namvar{8})
% caxis(ca)
% temp=zscore(TCspktn1{9}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,10), imagesc(temp(id,:)), title(namvar{9})
% caxis(ca)
% temp=zscore(TCspktn1{10}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,13), imagesc(temp(id,:)), title(namvar{10})
% caxis(ca)
% temp=zscore(TCspktn1{11}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,16), imagesc(temp(id,:)), title(namvar{11})
% caxis(ca)
% 
% temp=zscore(TCspktn2{6}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,2), imagesc(temp(id,:)), title(namvar{6})
% caxis(ca)
% temp=zscore(TCspktn2{7}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,5), imagesc(temp(id,:)), title(namvar{7})
% caxis(ca)
% temp=zscore(TCspktn2{8}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,8), imagesc(temp(id,:)), title(namvar{8})
% caxis(ca)
% temp=zscore(TCspktn2{9}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,11), imagesc(temp(id,:)), title(namvar{9})
% caxis(ca)
% temp=zscore(TCspktn2{10}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,14), imagesc(temp(id,:)), title(namvar{10})
% caxis(ca)
% temp=zscore(TCspktn2{11}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,17), imagesc(temp(id,:)), title(namvar{11})
% caxis(ca)
% 
% temp=zscore(TCspktn3{6}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,3), imagesc(temp(id,:)), title(namvar{6})
% caxis(ca)
% temp=zscore(TCspktn3{7}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,6), imagesc(temp(id,:)), title(namvar{7})
% caxis(ca)
% temp=zscore(TCspktn3{8}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,9), imagesc(temp(id,:)), title(namvar{8})
% caxis(ca)
% temp=zscore(TCspktn3{9}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,12), imagesc(temp(id,:)), title(namvar{9})
% caxis(ca)
% temp=zscore(TCspktn3{10}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,15), imagesc(temp(id,:)), title(namvar{10})
% caxis(ca)
% temp=zscore(TCspktn3{11}')';
% [BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
% subplot(6,3,18), imagesc(temp(id,:)), title(namvar{11})
% caxis(ca)
% 




% smo2=3;
% xl2=[-1 1];
% 
% figure('color',[1 1 1]), 
% subplot(6,1,1), 
% kl=6;
% temp=zscore(TCspktn1{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'b'), title(namvar{kl})
% temp=zscore(TCspktn2{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'k'), title(namvar{kl})
% temp=zscore(TCspktn3{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'r'), title(namvar{kl})
% xlim([xl2])
% 
% subplot(6,1,2), 
% kl=7;
% temp=zscore(TCspktn1{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'b'), title(namvar{kl})
% temp=zscore(TCspktn2{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'k'), title(namvar{kl})
% temp=zscore(TCspktn3{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'r'), title(namvar{kl})
% xlim([xl2])
% 
% subplot(6,1,3), 
% kl=8;
% temp=zscore(TCspktn1{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'b'), title(namvar{kl})
% temp=zscore(TCspktn2{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'k'), title(namvar{kl})
% temp=zscore(TCspktn3{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'r'), title(namvar{kl})
% xlim([xl2])
% 
% subplot(6,1,4), 
% kl=9;
% temp=zscore(TCspktn1{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'b'), title(namvar{kl})
% temp=zscore(TCspktn2{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'k'), title(namvar{kl})
% temp=zscore(TCspktn3{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'r'), title(namvar{kl})
% xlim([xl2])
% 
% subplot(6,1,5), 
% kl=10;
% temp=zscore(TCspktn1{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'b'), title(namvar{kl})
% temp=zscore(TCspktn2{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'k'), title(namvar{kl})
% temp=zscore(TCspktn3{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'r'), title(namvar{kl})
% xlim([xl2])
% 
% subplot(6,1,6), 
% kl=11;
% temp=zscore(TCspktn1{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'b'), title(namvar{kl})
% temp=zscore(TCspktn2{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'k'), title(namvar{kl})
% temp=zscore(TCspktn3{kl}')';
% hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'r'), title(namvar{kl})
% xlim([xl2])
% 





%-----------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
xl2=[-1 1];
smo2=3;
ca=[-6 6];
limsort=[90 110];
figure('color',[1 1 1]), 
temp=zscore(TCspktn1{6}')';
[BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
subplot(3,4,1), imagesc(temp(id,:)), title(namvar{6})
caxis(ca)
temp=zscore(TCspktn2{6}')';
[BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
subplot(3,4,2), imagesc(temp(id,:)), title(namvar{6})
caxis(ca)
temp=zscore(TCspktn3{6}')';
[BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
subplot(3,4,3), imagesc(temp(id,:)), title(namvar{6})
caxis(ca)
kl=6;
subplot(3,4,4), 
temp=zscore(TCspktn1{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'b'), title(namvar{kl})
temp=zscore(TCspktn2{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'k'), title(namvar{kl})
temp=zscore(TCspktn3{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'r'), title(namvar{kl})
xlim([xl2])

temp=zscore(TCspktn1{10}')';
[BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
subplot(3,4,5), imagesc(temp(id,:)), title(namvar{10})
caxis(ca)
temp=zscore(TCspktn2{10}')';
[BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
subplot(3,4,6), imagesc(temp(id,:)), title(namvar{10})
caxis(ca)
temp=zscore(TCspktn3{10}')';
[BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
subplot(3,4,7), imagesc(temp(id,:)), title(namvar{10})
caxis(ca)
kl=10;
subplot(3,4,8), 
temp=zscore(TCspktn1{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'b'), title(namvar{kl})
temp=zscore(TCspktn2{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'k'), title(namvar{kl})
temp=zscore(TCspktn3{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'r'), title(namvar{kl})
xlim([xl2])

temp=zscore(TCspktn1{11}')';
[BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
subplot(3,4,9), imagesc(temp(id,:)), title(namvar{11})
caxis(ca)
temp=zscore(TCspktn2{11}')';
[BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
subplot(3,4,10), imagesc(temp(id,:)), title(namvar{11})
caxis(ca)
temp=zscore(TCspktn3{11}')';
[BE,id]=sort(mean(temp(:,limsort(1):limsort(2)),2));
subplot(3,4,11), imagesc(temp(id,:)), title(namvar{11})
caxis(ca)
subplot(3,4,12),
kl=11;
temp=zscore(TCspktn1{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'b'), title(namvar{kl})
temp=zscore(TCspktn2{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'k'), title(namvar{kl})
temp=zscore(TCspktn3{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'r'), title(namvar{kl})
xlim([xl2])

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


figure('color',[1 1 1])
li1=95;li2=110;
li1=80;li2=90;

kl=6;
temp1=zscore(TCspktn1{kl}')';
temp2=zscore(TCspktn2{kl}')';
temp3=zscore(TCspktn3{kl}')';
subplot(2,3,1), PlotErrorBar3(mean(temp1(:,li1:li2),2),mean(temp2(:,li1:li2),2),mean(temp3(:,li1:li2),2),0,0)
set(gca,'xticklabel',{'N1','N2','N3'})
set(gca,'xtick',[1:3])
title('All ripples')

kl=10;
temp1=zscore(TCspktn1{kl}')';
temp2=zscore(TCspktn2{kl}')';
temp3=zscore(TCspktn3{kl}')';
subplot(2,3,2), PlotErrorBar3(mean(temp1(:,li1:li2),2),mean(temp2(:,li1:li2),2),mean(temp3(:,li1:li2),2),0,0)
set(gca,'xticklabel',{'N1','N2','N3'})
set(gca,'xtick',[1:3])
title('Ripples in')

kl=11;
temp1=zscore(TCspktn1{kl}')';
temp2=zscore(TCspktn2{kl}')';
temp3=zscore(TCspktn3{kl}')';
subplot(2,3,3), PlotErrorBar3(mean(temp1(:,li1:li2),2),mean(temp2(:,li1:li2),2),mean(temp3(:,li1:li2),2),0,0)
set(gca,'xticklabel',{'N1','N2','N3'})
set(gca,'xtick',[1:3])
title('Ripples out')

kl=10; temp1=zscore(TCspktn1{kl}')';
kl=11; temp2=zscore(TCspktn1{kl}')';
subplot(2,3,4), PlotErrorBar2(mean(temp1(:,li1:li2),2),mean(temp2(:,li1:li2),2),0,0)
set(gca,'xticklabel',{'in','out'})
set(gca,'xtick',[1:2])
title('N1')

kl=10; temp1=zscore(TCspktn2{kl}')';
kl=11; temp2=zscore(TCspktn2{kl}')';
subplot(2,3,5), PlotErrorBar2(mean(temp1(:,li1:li2),2),mean(temp2(:,li1:li2),2),0,0)
set(gca,'xticklabel',{'in','out'})
set(gca,'xtick',[1:2])
title('N2')

kl=10; temp1=zscore(TCspktn3{kl}')';
kl=11; temp2=zscore(TCspktn3{kl}')';
subplot(2,3,6), PlotErrorBar2(mean(temp1(:,li1:li2),2),mean(temp2(:,li1:li2),2),0,0)
set(gca,'xticklabel',{'in','out'})
set(gca,'xtick',[1:2])
title('N3')



%---------------------------------------------------------------------------

figure('color',[1 1 1])
subplot(3,1,1), hold on
kl=10;
temp=zscore(TCspktn1{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'b','linestyle','--')
kl=11;
temp=zscore(TCspktn1{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'b')
xlim([xl2])
ylim([-0.5 1])
title('N1')

subplot(3,1,2), hold on
kl=10;
temp=zscore(TCspktn2{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'k','linestyle','--')
kl=11;
temp=zscore(TCspktn2{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'k')
xlim([xl2])
ylim([-0.5 1])
title('N2')

subplot(3,1,3), hold on
kl=10;
temp=zscore(TCspktn3{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'r','linestyle','--')
kl=11;
temp=zscore(TCspktn3{kl}')';
hold on, plot(B/1E3,SmoothDec(mean(temp),smo2),'r')
xlim([xl2])
ylim([-0.5 1])
title('N3')




%---------------------------------------------------------------------------
%---------------------------------------------------------------------------




namv{1}='rip pre';
namv{2}='rip post';
namv{3}='rip out';
namv{4}='rip';
namv{5}='Delta';
namv{6}='SpiFs';
namv{7}='SpiFd';
namv{8}='SpiSs';
namv{9}='SpiSd';
namv{10}='rip Spi';
namv{11}='rip out Spi';

PlotErrorBar(Nbn2)
set(gca,'xtick',[1:11])
set(gca,'xticklabel',namv)
set(gca,'yscale','log')
title('N2')

PlotErrorBar(Nbn3)
set(gca,'xtick',[1:11])
set(gca,'xticklabel',namv)
set(gca,'yscale','log')
title('N3')


PlotErrorBar(Nbn1)
set(gca,'xtick',[1:11])
set(gca,'xticklabel',namv)
set(gca,'yscale','log')
title('N1')
