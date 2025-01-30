

cd ~/Data/WarpRat
load ReactRateSpwPETH.mat

load ReactRate FRateSPWSleep1_idx
for i = 1:54
  n_cells(i) = length(find(FRateSPWSleep1_idx == i));
end
good_datasets = find (n_cells >20);





rs2 = merge(ReactR200SpwPETHS2);
drs2 = Data(rs2);
rs2_m = (nanmean((drs2(:,2*good_datasets-1))'))';
rs2_s = (nansum((drs2(:,2*good_datasets).^2)'))';
n_sessions = size(drs2, 2)/2;
rs2_s = sqrt(rs2_s)/n_sessions;

rss2 = merge(ReactR200SpwPETHShuffleCS2);
drss2 = Data(rss2);
rss2_m = (nanmean((drss2(:,2*good_datasets-1))'))';
rss2_s = (nansum((drss2(:,2*good_datasets).^2)'))';
n_sessions = size(drss2, 2)/2;
rss2_s = sqrt(rss2_s)/n_sessions;

figure(2)
subplot(4,1,1)
errorbar(Range(rs2, 's'),  rs2_m, rs2_s)
hold on 
errorbar(Range(rss2, 's'),  rss2_m, rss2_s, 'r')
subplot(4,1,2)
e = sqrt(rs2_s.^2+rss2_s.^2);
errorbar(Range(rs2, 's'),  rs2_m-rss2_m,e)





rs1 = merge(ReactR200SpwPETHS1);
drs1 = Data(rs1);
rs1_m = (nanmean((drs1(:,2*good_datasets-1))'))';
rs1_s = (nansum((drs1(:,2*good_datasets).^2)'))';
n_sessions = size(drs1, 2)/2;
rs1_s = sqrt(rs1_s)/n_sessions;

rss1 = merge(ReactR200SpwPETHShuffleCS1);
drss1 = Data(rss1);
rss1_m = (nanmean((drss1(:,2*good_datasets-1))'))';
rss1_s = (nansum((drss1(:,2*good_datasets).^2)'))';
n_sessions = size(drss1, 2)/2;
rss1_s = sqrt(rss1_s)/n_sessions;

subplot(4,1,3)
errorbar(Range(rs1, 's'),  rs1_m, rs1_s)
hold on 
errorbar(Range(rss1, 's'),  rss1_m, rss1_s, 'r')
subplot(4,1,4)
e = sqrt(rs1_s.^2+rss1_s.^2);
errorbar(Range(rs1, 's'),  rs1_m-rss1_m,e)
