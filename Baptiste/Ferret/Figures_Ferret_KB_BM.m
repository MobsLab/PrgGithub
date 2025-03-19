

figure

load('B_Low_Spectrum.mat')
Data_Low = Spectro{1};
Time_Low = Spectro{2};
Range_Low = Spectro{3};

subplot(211)
imagesc(Time_Low/3600 , Range_Low , runmean(10*log10(Data_Low),30)'); axis xy
caxis([30 50])
ylabel('Frequency (Hz)')
title('OB Low Spectrogram')
colorbar

load('B_Middle_Spectrum.mat')
Data_Middle = Spectro{1};
Time_Middle = Spectro{2};
Range_Middle = Spectro{3};

subplot(212)
imagesc(Time_Middle/3600 , Range_Middle , runmean(10*log10(Data_Middle),200)'); axis xy
caxis([24 38])
u=hline(40,'--k'), set(u,'Linewidth',2);
u=hline(60,'--k'), set(u,'Linewidth',2);
ylim([20 100])
xlabel('time (hrs)'), ylabel('Frequency (Hz)')
title('OB High Spectrogram')
colorbar
colormap jet

a=sgtitle('Spectrograms, sleep session');
a.FontSize=20;




figure

load('B_UltraLow_Spectrum.mat')
Data_ULow = Spectro{1};
Time_ULow = Spectro{2};
Range_ULow = Spectro{3};

subplot(211)
imagesc(Time_ULow/3600 , Range_ULow , runmean(10*log10(Data_ULow),10)'); axis xy
caxis([20 65])
u=hline(.11,'--k'), set(u,'Linewidth',2);
u=hline(.5,'--k'), set(u,'Linewidth',2);
ylabel('Frequency (Hz)')
title('OB Ultra Low Spectrogram')
colorbar

load('B_Middle_Spectrum.mat')
range_Middle = Spectro{3};
Data_Middle = Spectro{1};


xlim([1.90 2.05])

figure
subplot(411)
plot(Range(smooth_01_05)/3600e4 , runmean(log(Data(smooth_01_05)),1e4),'k')
xlim([0 max(Range(smooth_01_05)/3600e4)])
ylabel('Power (log)')
subplot(412)
plot(Range(smooth_ghi)/3600e4 , runmean(log(Data(smooth_ghi)),1e4),'k')
xlim([0 max(Range(smooth_ghi)/3600e4)])


figure
[Y,X]=hist(log10(Data(smooth_ghi)),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,20))
makepretty
u=vline(2.6,'-k'), set(u,'Linewidth',5)


figure
[Y,X]=hist(log10(Data(smooth_01_05)),1000);
Y=Y/sum(Y);
plot(X,runmean(Y,20))
makepretty
u=vline(2.117,'-k'), set(u,'Linewidth',5);




%%
figure
[Y,X]=hist(log10(Data(smooth_01_05)),1000);
Y=Y/sum(Y);
u=area(X,runmean(Y,20),'FaceColor',[.5 .5 .5],'EdgeColor',[0 0 0],'Linewidth',3.5)
makepretty
u=vline(2.117,'-r'), set(u,'Linewidth',5);
set(gca, 'XDir','reverse')

figure
[Y,X]=hist(log10(Data(smooth_ghi)),1000);
Y=Y/sum(Y);
u=area(X,runmean(Y,20),'FaceColor',[.5 .5 .5],'EdgeColor',[0 0 0],'Linewidth',3.5)
makepretty
u=vline(2.6,'-r'), set(u,'Linewidth',5);


figure
clf
clear X Y
X = log10(Data(Restrict(smooth_ghi,Wake)));
Y = log10(Data(Restrict(smooth_01_05,Wake)));
plot(X(1:200:end) , Y(1:200:end) , '.' , 'Color' , [.5 .5 .5])
hold on
clear X Y
X = log10(Data(Restrict(smooth_ghi,and(Epoch_01_05,Sleep))));
Y = log10(Data(Restrict(smooth_01_05,and(Epoch_01_05,Sleep))));
plot(X(1:500:end) , Y(1:500:end) , '.' , 'Color' , [1 0 0])
clear X Y
X = log10(Data(Restrict(smooth_ghi,and(Epoch-Epoch_01_05,Sleep))));
Y = log10(Data(Restrict(smooth_01_05,and(Epoch-Epoch_01_05,Sleep))));
plot(X(1:500:end) , Y(1:500:end) , '.' , 'Color' , [.2 .2 1])
axis square, axis off
legend('Wake','NREM','REM')



t=Range(LFP);
begin=t(1)/3600e4;
endin=t(end)/3600e4;

line([begin endin],[19 19],'linewidth',10,'color','w')
sleepstart=Start(and(Epoch_01_05,Sleep));
sleepstop=Stop(and(Epoch_01_05,Sleep));
for k=1:length(sleepstart)
    line([sleepstart(k)/3600e4 sleepstop(k)/3600e4],[19 19],'color',[1 0.2 0.2],'linewidth',5);
end
sleepstart=Start(and(Epoch-Epoch_01_05,Sleep));
sleepstop=Stop(and(Epoch-Epoch_01_05,Sleep));
for k=1:length(sleepstart)
    line([sleepstart(k)/3600e4 sleepstop(k)/3600e4],[19 19],'color',[0.4 0.5 1],'linewidth',5);
end
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/3600e4 sleepstop(k)/3600e4],[19 19],'color',[0.6 0.6 0.6],'linewidth',5);
end
% Hypnogram_LineColor_BM



