%%tracer le spectrogramme en fonction du temps 


test=10*log10(Spectro{1}');
freq=Spectro{3};
tps=Spectro{2};
[B,id]=max(test);% B=puissance; id=ligne
figure,
subplot(3,1,1), imagesc(tps,freq,test), axis xy
subplot(3,1,2), plot(tps,B)
subplot(3,1,3), plot(tps,freq(id))
xlim([0 100])
ylim([0 20])
hold on, plot(tps,B(id),'ko-')
hold on, plot(tps,freq(id),'ko-')

figure, imagesc(test(:,1:100)),axis xy
figure, plot(max(test(:,1:100)))
[B,id]=max(test(:,1:100));

a=100;
a=a+100, xlim([a a+100])
colormap(jet)
a=a+100, xlim([a a+100]), caxis([20 55])







