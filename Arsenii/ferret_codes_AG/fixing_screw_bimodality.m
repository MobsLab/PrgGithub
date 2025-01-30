






Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});

Sp_sleep = Restrict(Sp_tsd , Sleep)


imagesc(Range(Sp_sleep,'s') , Spectro{3} , log10(Data(Sp_sleep))'), axis xy, xlim([900 3e3]), caxis([1 3])

figure
[Y,X]=hist(runmean(H2,1e4),1000);
Y=Y/sum(Y);
plot(X,Y)








