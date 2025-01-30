
close all
cd ~/Data/WarpRat
load SpwPETHTemplate
nbins = 101;
load ReactRate FRateSPWSleep1_idx
for i = 1:54
  n_cells(i) = length(find(FRateSPWSleep1_idx == i));
end
good_datasets = find(n_cells > 20);
good_datasets = setdiff(good_datasets, 12);

%%%% the overall template

figure(1)
a = cellArray(SPWTempOverlapS1);
SPWTempOverlapS1 = tsdArray(a(good_datasets));
t_s1 = Data(oneSeries(SPWTempOverlapS1));
subplot(2,1,1)

[g,l] = hist(t_s1 - nanmean(t_s1), linspace(-0.5, 0.5, nbins));
plot(l,g)
hold on 
g_sym = (g + g(end:-1:1))/2;
plot(l,g_sym, '--');

display('sleep1')
nanmean(t_s1)
t = t_s1(isfinite(t_s1));
skewness(t)
kurtosis(t)
title('template s1')

a = cellArray(SPWTempOverlapS2);
SPWTempOverlapS2 = tsdArray(a(good_datasets));
t_s2 = Data(oneSeries(SPWTempOverlapS2));
subplot(2,1,2)

[g,l] = hist(t_s2 - nanmean(t_s2), linspace(-0.5, 0.5, nbins));
plot(l,g)
hold on 
g_sym = (g + g(end:-1:1))/2;
plot(l,g_sym, '--');


display('sleep2')
nanmean(t_s2)
t = t_s2(isfinite(t_s2));
skewness(t)
kurtosis(t)
title('template s2')


%%%% the clustered template
figure(2)
a = cellArray(SPWCTempOverlapS1);
SPWCTempOverlapS1 = tsdArray(a(good_datasets));
t_s1 = Data(oneSeries(SPWCTempOverlapS1));
subplot(2,1,1)

[g,l] = hist(t_s1 - nanmean(t_s1), linspace(-0.5, 0.5, nbins));
plot(l,g)
hold on 
g_sym = (g + g(end:-1:1))/2;
plot(l,g_sym, '--');

display('clustered sleep1')
nanmean(t_s1)
t = t_s1(isfinite(t_s1));
skewness(t)
kurtosis(t)
title('clustered template s1')

a = cellArray(SPWCTempOverlapS2);
SPWCTempOverlapS2 = tsdArray(a(good_datasets));
t_s2 = Data(oneSeries(SPWCTempOverlapS2));
subplot(2,1,2)

[g,l] = hist(t_s2 - nanmean(t_s2), linspace(-0.5, 0.5, nbins));
plot(l,g)
hold on 
g_sym = (g + g(end:-1:1))/2;
plot(l,g_sym, '--');


display('clustered template sleep2')
nanmean(t_s2)
t = t_s2(isfinite(t_s2));
skewness(t)
kurtosis(t)
title('template s2')



%%%% the isolated template
figure(3)
a = cellArray(SPWUTempOverlapS1);
SPWUTempOverlapS1 = tsdArray(a(good_datasets));
t_s1 = Data(oneSeries(SPWUTempOverlapS1));
subplot(2,1,1)

[g,l] = hist(t_s1 - nanmean(t_s1), linspace(-0.5, 0.5, nbins));
plot(l,g)
hold on 
g_sym = (g + g(end:-1:1))/2;
plot(l,g_sym, '--');

display('isolated sleep1')
nanmean(t_s1)
t = t_s1(isfinite(t_s1));
skewness(t)
kurtosis(t)
title('isolated template s1')

a = cellArray(SPWUTempOverlapS2);
SPWUTempOverlapS2 = tsdArray(a(good_datasets));
t_s2 = Data(oneSeries(SPWUTempOverlapS2));
subplot(2,1,2)

[g,l] = hist(t_s2 - nanmean(t_s2), linspace(-0.5, 0.5, nbins));
plot(l,g)
hold on 
g_sym = (g + g(end:-1:1))/2;
plot(l,g_sym, '--');


display('isolated template sleep2')
nanmean(t_s2)
t = t_s2(isfinite(t_s2));
skewness(t)
kurtosis(t)
title('template s2')



