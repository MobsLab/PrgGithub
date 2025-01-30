
close all
cd ~/Data/WarpRat
load SpwPETH.mat
load SpwPETHClusters.mat

load ReactRate FRateSPWSleep1_idx
for i = 1:54
  n_cells(i) = length(find(FRateSPWSleep1_idx == i));
end
good_datasets = 1:length(SpwPETH_s2);





rs1 = merge(SpwPETH_s1);
drs1 = Data(rs1);
rs1_m = (nanmean((drs1(:,2*good_datasets-1))'))';
rs1_s = (nansum((drs1(:,2*good_datasets).^2)'))';
n_sessions = size(drs1, 2)/2;
rs1_s = sqrt(rs1_s)/n_sessions;

rsc1 = merge(SpwPETHClust_s1');
drsc1 = Data(rsc1);
rsc1_m = (nanmean((drsc1(:,2*good_datasets-1))'))';
rsc1_s = (nansum((drsc1(:,2*good_datasets).^2)'))';
n_sessions = size(drsc1, 2)/2;
rsc1_s = sqrt(rsc1_s)/n_sessions;

rsu1 = merge(SpwPETHIsol_s1');
drsu1 = Data(rsu1);
rsu1_m = (nanmean((drsu1(:,2*good_datasets-1))'))';
rsu1_s = (nansum((drsu1(:,2*good_datasets).^2)'))';
n_sessions = size(drsu1, 2)/2;
rsu1_s = sqrt(rsu1_s)/n_sessions;


subplot(2,1,1)


errorbar(Range(rs1, 's'),  rs1_m, rs1_s)
hold on 
errorbar(Range(rsc1, 's'),  rsc1_m, rsc1_s, 'r')

errorbar(Range(rsu1, 's'),  rsu1_m, rsu1_s, 'g')


rs2 = merge(SpwPETH_s2);
drs2 = Data(rs2);
rs2_m = (nanmean((drs2(:,2*good_datasets-1))'))';
rs2_s = (nansum((drs2(:,2*good_datasets).^2)'))';
n_sessions = size(drs2, 2)/2;
rs2_s = sqrt(rs2_s)/n_sessions;

rsc2 = merge(SpwPETHClust_s2');
drsc2 = Data(rsc2);
rsc2_m = (nanmean((drsc2(:,2*good_datasets-1))'))';
rsc2_s = (nansum((drsc2(:,2*good_datasets).^2)'))';
n_sessions = size(drsc2, 2)/2;
rsc2_s = sqrt(rsc2_s)/n_sessions;

rsu2 = merge(SpwPETHIsol_s2');
drsu2 = Data(rsu2);
rsu2_m = (nanmean((drsu2(:,2*good_datasets-1))'))';
rsu2_s = (nansum((drsu2(:,2*good_datasets).^2)'))';
n_sessions = size(drsu2, 2)/2;
rsu2_s = sqrt(rsu2_s)/n_sessions;


subplot(2,1,2)
errorbar(Range(rs2, 's'),  rs2_m, rs2_s)
hold on 
errorbar(Range(rsc2, 's'),  rsc2_m, rsc2_s, 'r')

errorbar(Range(rsu2, 's'),  rsu2_m, rsu2_s, 'g')





