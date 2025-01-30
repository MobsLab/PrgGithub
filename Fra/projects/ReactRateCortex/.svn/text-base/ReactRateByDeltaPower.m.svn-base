function ReactRateByDeltaPower
% ReactRateByDeltaPower plots ReactRateR as a function of delta power
cd /home/fpbatta/Data/WarpRat

load ReactRate
load ReactRateByDelta
load globalBinnedFRateSleep2
n_q = 5; % the number of quantiles


for i = 1:54
  n_cells(i) = length(find(FRateSPWSleep1_idx == i));
end

good_datasets = find (n_cells >20);

rr = tsdArray;

for i = 1:length(good_datasets)
  rr{i}= ReactBinnedR{good_datasets(i)};
end

rr = map(rr, 'TSO = realign(TSA, ''ZeroFirst'', 1);');

rr = Data(merge(rr));
rr = rr((1:end-1),:);

rd = tsdArray;
for i = 1:length(good_datasets)
  rd{i}= DeltaNormBinnedS2{good_datasets(i)};
end


rd= map(rd, 'TSO = realign(TSA, ''ZeroFirst'', 1);');



rd = Data(merge(rd));

rr = rr(:);
rd = rd(:);

[idxs_delta, range_min, range_max] = SplitQuantiles(rd, n_q);
 

figure(1)

plot(rd, rr, '.');

xlabel('delta power during sleep 2');
ylabel('r-value for rate raectivation');

 
for i = 1:n_q
 r_q(i) = mean(rr(idxs_delta{i}));
 s_q(i) = std(rr(idxs_delta{i})) / sqrt(length(idxs_delta{i}));
 
end

figure(2)
clf

errorbar(1:n_q, r_q, s_q);

range_max(end) = nanmax(rd);

for i = 1:n_q
  xtck{i} = [num2str(100 * range_min(i), '%3.1f'), '-', ...
	     num2str(100 * range_max(i), '%3.1f')];
end

set(gca, 'xtick', 1:n_q);
set(gca, 'xticklabel', xtck);

xlabel('delta power during sleep 2');
ylabel('r-value for rate raectivation');

saveas(gcf, 'ReactRateByDelta.fig');

figure(3)


X_S2S1Delta = log(FRateDeltaSleep2 ./ FRateDeltaSleep1);
X_S2S1NoDelta = log(FRateNoDeltaSleep2 ./ FRateNoDeltaSleep1);

nancorrcoef(X_MS1,X_S2S1Delta) 
plot(X_MS1,X_S2S1Delta, '.') ;
figure(4)
nancorrcoef(X_MS1,X_S2S1NoDelta) 
plot(X_MS1,X_S2S1NoDelta, 'r.') ;



figure(5)
% React R as a function of total firing rate 

% $$$ rr = Data(merge(ReactBinnedR));
% $$$ 
% $$$ rr = rr(:);

rp = tsdArray;
for i = 1:length(good_datasets)
  rp{i}= GlobalBinnedFRateSleep2{good_datasets(i)};
end

rp = map(rp, 'TSO = realign(TSA, ''ZeroFirst'', 1);');


rp = Data(merge(rp));

rp = rp * diag(1./mean(rp));


rp1 = rp(1:end-1,:);
rp = rp(:);
rp1 = rp1(:);
[idxs_pop, range_min, range_max] = SplitQuantiles(rp1, n_q);
plot(rp1, rr, '.');

xlabel('population rate during sleep 2');
ylabel('r-value for rate raectivation');


 
for i = 1:n_q
 r_q(i) = mean(rr(idxs_pop{i}));
 s_q(i) = std(rr(idxs_pop{i})) / sqrt(length(idxs_pop{i}));
 
end

figure(6)

errorbar(1:n_q, r_q, s_q);

for i = 1:n_q
  xtck{i} = [num2str(range_min(i), '%3.1f'), '-', ...
	     num2str(range_max(i), '%3.1f')];
end

set(gca, 'xtick', 1:n_q);
set(gca, 'xticklabel', xtck);

xlabel('population rate during sleep 2');
ylabel('r-value for rate raectivation');

saveas(gcf, 'ReactRateByDelta.fig');


figure(7)

plot(rp1, rd, '.')
keyboard