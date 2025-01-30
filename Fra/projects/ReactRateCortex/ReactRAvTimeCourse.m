%  time course of reactivation R averaged across timestamps

load ReactRate


for i = 1:54
  n_cells(i) = length(find(FRateSPWSleep1_idx == i));
end

good_datasets = find (n_cells >20);

length(good_datasets)

rm = tsdArray;

for i = 1:length(good_datasets)
  rm{i}= ReactBinnedR{good_datasets(i)};
end


rm = map(rm, 'TSO = realign(TSA, ''ZeroFirst'', 1);');


rm = merge(rm);

ReactRAv = tsd(Range(rm), mean(Data(rm), 2));
ReactRSem = tsd(Range(rm), std(Data(rm), [],2)/sqrt(size(Data(rm),2)));


figure(2)

clf
errorbar(Range(ReactRAv,'min'), Data(ReactRAv), Data(ReactRSem));

xlabel('time (min)')
ylabel('React Rate r');

title('Averaged across datasets, errorbars = S.E.M.');


figure(3)

clf 
plot(Range(ReactRAv,'min'), Data(rm))

xlabel('time (min)')
ylabel('React Rate r');

title('35 datasets (> 20 cells)');
