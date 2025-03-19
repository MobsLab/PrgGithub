



figure
subplot(131)
bar([23.9 35.8 4.4 39.8 47.8 48 53.7])
xticks([1:7])
xticklabels({'Raid','RaidN','Raid5','Nas4','Nas5','Nas6','Nas7'}), xtickangle(45)
ylabel('To')
title('Total capacity')

subplot(132)
bar([1-40e-6/24 1-2.7/36 1-28.4e-3/4.5 1-630e-3/40 1-6.7/47.8 1-2.4/48 1-40.1/53.7])
xticks([1:7])
xticklabels({'Raid','RaidN','Raid5','Nas4','Nas5','Nas6','Nas7'}), xtickangle(45)
ylabel('proportion')
title('Filling level')

subplot(133)
bar([40 2.7e6 28.4e3 630e3 6.7e6 2.4e6 40.1e6])
xticks([1:7])
xticklabels({'Raid','RaidN','Raid5','Nas4','Nas5','Nas6','Nas7'}), xtickangle(45)
ylabel('Mo (log scale)')
set(gca,'Yscale' , 'log')
title('Free space')


a=suptitle('Nas filling, 22/02/2023'); a.FontSize=20;















