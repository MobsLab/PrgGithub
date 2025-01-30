% plot react rate correlation coefficients for groups divided by depth
% and firing rate during sleep 

cd /home/fpbatta/Data/WarpRat

load ReactRate
load CortCellDepth

n_q = 5; % the number of quantiles

frate_sleep = 0.5 * (FRateSleep1 + FRateSleep2);



[idxs_rate, range_min, range_max] = SplitQuantiles(frate_sleep, n_q);
 



 
for i = 1:n_q
  [c, clo, chi] = nancorrcoef(X_MS1(idxs_rate{i}), X_S2S1(idxs_rate{i}), ...
			      'bootstrap'); 
  r_byrate(i) = c(1,2);
  r_hi_byrate(i) = clo(1,2);
  r_lo_byrate(i) = chi(1,2);  
end

figure(1)
clf
plot(r_byrate)
hold on 
plot(r_hi_byrate, '--');
plot(r_lo_byrate, '--');


for i = 1:n_q
  xtck{i} = [num2str(range_min(i)) '-' num2str(range_max(i))];
end

set(gca, 'xtick', 1:n_q);
set(gca, 'xticklabel', xtck);

xlabel('firing rate during sleep');
ylabel('r-value for rate raectivation');

saveas(gcf, 'ReactRateByRate.fig');


% now for the calculations depth-wise

[idxs_depth, range_min, range_max] = SplitQuantiles(CortCellDepth, n_q);
 



 
for i = 1:n_q
  [c, clo, chi] = nancorrcoef(X_MS1(idxs_depth{i}), X_S2S1(idxs_depth{i}), ...
			      'bootstrap'); 
  r_bydepth(i) = c(1,2);
  r_hi_bydepth(i) = clo(1,2);
  r_lo_bydepth(i) = chi(1,2);  
end

figure(2)
clf
plot(r_bydepth)
hold on 
plot(r_hi_bydepth, '--');
plot(r_lo_bydepth, '--');


for i = 1:n_q
  xtck{i} = [num2str(range_min(i)) '-' num2str(range_max(i))];
end

set(gca, 'xtick', 1:n_q);
set(gca, 'xticklabel', xtck);

xlabel('depth from brain surface');
ylabel('r-value for rate raectivation');

saveas(gcf, 'ReactRateByDepth.fig');


